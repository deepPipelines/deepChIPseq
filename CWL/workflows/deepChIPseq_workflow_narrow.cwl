lVersion: v1.0
class: Workflow

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-5283-7633
    s:email: mailto:heleneluessem@gmail.com
    s:name: Helene Luessem

requirements:
  - class: ScatterFeatureRequirement
  - class: SubworkflowFeatureRequirement


inputs:

#---------- Number of Processors------------------------------------

  deeptoolsParallel: int

  sambambaParallel : int


#---------- Files and Prefixes -------------------------------------

  # Filtered bamfile GALvX_Histone
  filteredBamFile: File

  # Filtered input bamfile: GALvX_Input
  filteredBamFile_Input: File


  filePrefix: string


#---------- Genome size --------------------------------------------

  genomeSize: int


#---------- Blacklist Regions --------------------------------------

  blacklistRegions:
    type: File


#---------- Step 9: peakCallOnFilteredBam --------------------------

  fragmentLength_peakCallOnFilteredBamN: int
  fragmentLength_peakCallOnFilteredBamB: int


#-------------------------------------------------------------------
#-------------------------------------------------------------------


outputs:


#-------------------------------------------------------------------
#-------------------------------------------------------------------


steps:

#---------- Step 6: countReadsInFilteredBam ------------------------

  countReadsInFilteredBam:
    run: ../tools/bioconda-tool-sambamba-view.cwl
    in:
      count:
        valueFrom: $( 1==1 )
      inputFile: filteredBamFile
      outputFileName:
        valueFrom: $( filePrefix.map(function(e) {return e + ".mapped.readcount"})

    out:
      - outputBamFile


#---------- Step 7: generateCoverageForFilteredBam -----------------

  generateCoverageForFilteredBam:
    run: ../tools/deepTools-tool-bamCoverage.cwl
    scatter: [bam, outFileName]
    in:
      numberOfProcessors: deeptoolsParallel
      binSize:
        valueFrom: $( 25 )
      bam: filteredBamFile
      outFileName:
        valueFrom: $( filePrefix.map(function(e) {return e + ".filt.bamcov"}) )
      outFileFormat:
        valueFrom:  bigwig
      normalizeTo1x: genomeSize
      blackListFileName: blacklistRegions
      ignoreForNormalization:
        valueFrom:  $( ["chrX", "chrY", "chrM", "X", "Y", "M", "MT"] )

    out:
      - outputFile

#---------- Step 9: peakCallOnFilteredBam - narrow -----------------

  peakCallOnFilteredBamN:
    run: ../tools/bioconda-tool-macs2-callpeak.cwl
    in:
      tFile: filteredBamFile
      cFile: filteredBamFile_Input
      format:
        valueFrom: BAM
      gSize: genomeSize
      keepDup:
        valueFrom: $( "all" )
      name: filePrefix
      noModel:
        valueFrom: $( 1==1 )
      extSize: fragmentLength_peakCallOnFilteredBamN
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
         valueFrom: $( filePrefix.map.map(function(e) {return e + ".macs.out"}) )

  out:
   - outZipFile


#---------- Step 14: countReadsOverlappingPeakRegions --------------

  countReadsOverlappingPeakRegions:
    run: ../tools/bioconda-tool-sambamba-view.cwl
    in:
      count: 
        valueFrom: $( 1==1 )
      nThreads: sambambaParallel
      regions: peakCallOnFilteredBamB/peakFile
      inputFile: filteredBamFile
      outputFileName:
        valueFrom: $( filePrefix.map(function(e) {return e + ".tmp.peak_ovl.cnt"}) )

    out:
      - outputBamFile


#---------- Step 15: intersectPeakFiles ----------------------------

  intersectPeakFiles:
    run: ../tools/bioconda-tool-bedtools-intersect.cwl
    scatter: [fileA]
    scatterMethod: dotproduct
    in:
      originalAOnce:
        valueFrom: $( 1==1 )
      fileA: peakCallOnFilteredBamB/peakFile
      fileB: blacklistRegions         
      outFileName:
        valueFrom: $( filePrefix.map(function(e) {return e + ".peak-ovl-bl"}) )

    out:
      - outputFile

