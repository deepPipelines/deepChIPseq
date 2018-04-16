cwlVersion: v1.0
class: Workflow

#s:author:
#  - class: s:Person
#    s:identifier: https://orcid.org/0000-0002-5283-7633
#    s:email: mailto:heleneluessem@gmail.com
#    s:name: Helene Luessem

requirements:
  - class: ScatterFeatureRequirement
  - class: SubworkflowFeatureRequirement


inputs:

#---------- Number of Processors------------------------------------

  deeptoolsParallel_nWF: int

  sambambaParallel_nWF : int


#---------- Files and Prefixes -------------------------------------

  # Filtered bamfile GALvX_Histone
  filteredBamFile_nWF: File

  # Filtered input bamfile: GALvX_Input
  filteredBamFile_Input_nWF: File


  filePrefix_nWF: string


#---------- Genome size --------------------------------------------

  genomeSize_nWF: int


#---------- Blacklist Regions --------------------------------------

  blacklistRegions_nWF: File


#---------- Step 9: peakCallOnFilteredBam --------------------------

  fragmentLength_peakCallOnFilteredBamN_nWF: int


#-------------------------------------------------------------------
#-------------------------------------------------------------------


outputs: []


#-------------------------------------------------------------------
#-------------------------------------------------------------------


steps:

#---------- Step 6: countReadsInFilteredBam ------------------------

  countReadsInFilteredBam:
    run: ../tools/bioconda-tool-sambamba-view.cwl
    in:
      count:
        valueFrom: $( 1==1 )
      inputFile: filteredBamFile_nWF
      outputFileName:
        valueFrom: $( filePrefix_nWF.map(function(e) {return e + ".mapped.readcount"})

    out:
      - outputBamFile


#---------- Step 7: generateCoverageForFilteredBam -----------------

  generateCoverageForFilteredBam:
    run: ../tools/deepTools-tool-bamCoverage.cwl
    in:
      numberOfProcessors: deeptoolsParallel_nWF
      binSize:
        valueFrom: $( 25 )
      bam: filteredBamFile_nWF
      outFileName:
        valueFrom: $( filePrefix_nWF.map(function(e) {return e + ".filt.bamcov"}) )
      outFileFormat:
        valueFrom:  bigwig
      normalizeTo1x: genomeSize_nWF
      blackListFileName: blacklistRegions_nWF
      ignoreForNormalization:
        valueFrom:  $( ["chrX", "chrY", "chrM", "X", "Y", "M", "MT"] )

    out:
      - outputFile

#---------- Step 9: peakCallOnFilteredBam - narrow -----------------

  peakCallOnFilteredBamN:
    run: ../tools/bioconda-tool-macs2-callpeak.cwl
    in:
      tFile: filteredBamFile_nWF
      cFile: filteredBamFile_Input_nWF
      format:
        valueFrom: BAM
      gSize: genomeSize_nWF
      keepDup:
        valueFrom: $( "all" )
      name: filePrefix_nWF
      noModel:
        valueFrom: $( 1==1 )
      extSize: fragmentLength_peakCallOnFilteredBamN_nWF
      qValue:
        valueFrom: $( 0.05 )

    out:
      - peakFile
      - tableFile
      - extraFile


#---------- Step 10: zipMacsFiles ----------------------------------

  zipMacsFilesN:
    run: ../tools/localfile-tool-zipMacsFiles.cwl
    in:
      inputFiles:
         valueFrom: $( [macsOut1, macsOut2, macsOut3] )
      outname:
         valueFrom: $( filePrefix_nWF.map.map(function(e) {return e + ".macs.out"}) )

    out:
      - outputZipFile


#---------- Step 14: countReadsOverlappingPeakRegions --------------

  countReadsOverlappingPeakRegions:
    run: ../tools/bioconda-tool-sambamba-view.cwl
    in:
      count: 
        valueFrom: $( 1==1 )
      nThreads: sambambaParallel_nWF
      regions: peakCallOnFilteredBamN/peakFile
      inputFile: filteredBamFile_nWF
      outputFileName:
        valueFrom: $( filePrefix_nWF.map(function(e) {return e + ".tmp.peak_ovl.cnt"}) )

    out:
      - outputBamFile


#---------- Step 15: intersectPeakFiles ----------------------------

  intersectPeakFiles:
    run: ../tools/bioconda-tool-bedtools-intersect.cwl
    in:
      originalAOnce:
        valueFrom: $( 1==1 )
      fileA: peakCallOnFilteredBamN/peakFile
      fileB: blacklistRegions_nWF         
      outFileName:
        valueFrom: $( filePrefix_nWF.map(function(e) {return e + ".peak-ovl-bl"}) )

    out:
      - outputFile


$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/
$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
