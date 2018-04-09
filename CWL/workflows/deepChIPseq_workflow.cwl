cwlVersion: v1.0
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


#---------- Input BamFiles and Prefixes ----------------------------

  # Raw bamfiles narrow GALvX_Histone
  bamFilesRaw_Histone_narrow:
    type: 
    - type: array
      items: File
    secondaryFiles:
      - "^.bai"

  # Raw bamfiles broad GALvX_Histone
  bamFilesRaw_Histone_broad:
    type:
    - type: array
      items: File
    secondaryFiles:
      - "^.bai"

  # Raw bamfiles: GALvX_Input
  bamFilesRaw_Input:
    type: File
    secondaryFiles:
      - "^.bai"
  
  # Like <DEEPID.PROC.DATE.ASSM.HistoneID>
  prefix_narrow: string[] 
  prefix_broad: string[]
  prefix_input: string

  # Like <DEEPID.PROC.DATE.ASSM>
  filePrefix: string

#---------- Genome size --------------------------------------------

  genomeSize: int


#---------- Step specific parameters -------------------------------


#---------- Step 2: computeGCBias ----------------------------------
#---------- Step 3: generateLog2FoldChangeTracks -------------------
#---------- Step 4: computeFingerprintOnRawBam ---------------------
#---------- Step 5: filterBamFiles ---------------------------------
#---------- Step 6: countReadsInFilteredBam ------------------------
#---------- Step 7: generateCoverageForFilteredBam -----------------
#---------- Step 8: computeFingerprintForFilteredBam ---------------
#---------- Step 9.1: peakCallOnFilteredBam - narrow ---------------
#---------- Step 9.2: peakCallOnFilteredBam - broad- ---------------
#---------- Step 10.1: zipMacsFiles - narrow -----------------------
#---------- Step 10.2: zipMacsFiles - broad ------------------------
#---------- Step 11: histoneHMM ------------------------------------
#---------- Step 12: makeHistoneHMMBedLike -------------------------
#---------- Step 13: zipSecHistoneHMMFiles -------------------------
#---------- Step 14: CountReadsOverlappingPeakRegions --------------
#---------- Step 15: IntersectPeakFiles ----------------------------
#---------- Step 16: IntersectHistoneHMMFiles ----------------------
#---------- Step 17: flagAndStandardizePeaks -----------------------
#---------- Step 18: RestrictFilteredBAMstoAutosomalRegions --------
#---------- Step 19: CreateDataMatrixForCorrelationPlot ------------
#---------- Step 20: createHeatmapCorrelationPlot ------------------


#---------- Step 2: computeGCBias ----------------------------------

  genome: File

  fragmentLength_computeGCBias: int[]
  

#---------- Step 3: generateLog2FoldChangeTracks -------------------

  scaleFactorsMeth:
    type:
    - "null"
    - type: enum
      symbols: ['readCount', 'SES']


#---------- Step 4: computeFingerprintOnRawBam ---------------------

  outName_computeFingerprintOnRawBam_labels:
    type:
    - "null"
    - type: array
      items: string

  plotTitle_computeFingerprintOnRawBam:
    type: string


#---------- Step 7: generateCoverageForFilteredBam -----------------

#TODO: For several steps?

  blacklistRegions:
    type: File


#---------- Step 8: computeFingerprintForFilteredBam ---------------

  outName_computeFingerprintForFilteredBam_labels: string[]

  plotTitle_computeFingerprintForFilteredBam: string


#---------- Step 9: peakCallOnFilteredBam --------------------------

  prefix_peakCallOnFilteredBam: string

  fragmentLength_peakCallOnFilteredBam: int[]


outputs: []

  #TODO


steps:
  

#----------- Step 1: generateSignalCovTrack --------------------------

  generateSignalCovTrack:
    run: ../tools/deepTools-tool-bamCoverage.cwl
    scatter: [bam, outFileName]
    scatterMethod: dotproduct   
    in:
      numberOfProcessors: deeptoolsParallel
      binSize: 
        valueFrom: $( 25)
      bam:
        valueFrom: $(input.narrowBam.concat(input.broadBam).concat(input.inputBam))
      outFileName:
        valueFrom: $( input.narrowPrefix.concat(input.broadPrefix).concat(input.inputPrefix).map(function(e) {return e + ".raw.bamcov"}) )
      outFileFormat: 
        valueFrom: bigwig
      normalizeTo1x: genomeSize
      
      # ~Additional inputs~
      narrowBam: bamFilesRaw_Histone_narrow
      broadBam: bamFilesRaw_Histone_broad
      inputBam: bamFilesRaw_Input
      narrowPrefix: prefix_narrow
      broadPrefix: prefix_broad
      inputPrefix: prefix_input

    out:
      - outputFile


#---------- Step 2: computeGCBias ------------------------------------

  computeGCBias:
    run: ../tools/deepTools-tool-computeGCBias.cwl
    scatter: [bamfile, GCbiasFrequenciesFile, fragmentLength]
    scatterMethod: dotproduct
    in:
      numberOfProcessors: deeptoolsParallel
      bamfile:
        valueFrom: $(input.narrowBam.concat(input.broadBam).concat(input.inputBam))
      effectiveGenomeSize: genomeSize
      genome: genome
      sampleSize:
        valueFrom: $( 50000000.0 )
      fragmentLength: fragmentLength_computeGCBias
      GCbiasFrequenciesFile: 
        valueFrom: $( input.narrowPrefix.concat(input.broadPrefix).concat(input.inputPrefix).map(function(e) {return e + ".gcfreq"}) )
      biasPlot:
        valueFrom: $( input.narrowPrefix.concat(input.broadPrefix).concat(input.inputPrefix).map(function(e) {return e + ".gcbias"}) )
      plotFileFormat:
        valueFrom: $( svg )

      # ~Additional inputs~
      narrowBam: bamFilesRaw_Histone_narrow
      broadBam: bamFilesRaw_Histone_broad
      inputBam: bamFilesRaw_Input
      narrowPrefix: prefix_narrow
      broadPrefix: prefix_broad
      inputPrefix: prefix_input

    out:
      - outputFile


#---------- Step 3: generateLog2FoldChangeTracks ---------------------

  generateLog2FoldChangeTracks:
    run: ../tools/deepTools-tool-bamCompare.cwl
    scatter: [bamfile1, outFileName]
    scatterMethod: dotproduct
    in:
      bamfile1: 
        valueFrom: $(input.narrowBam.concat(input.broadBam))
      bamfile2: bamFilesRaw_Input
      outFileName:
        valueFrom: $( input.narrowPrefix.concat(input.broadPrefix).map(function(e) {return e + ".log2-Input"}) )
      outFileFormat:
        valueFrom: bigwig
      scaleFactorsMethod: scaleFactorsMeth
      ratio:
        valueFrom: log2
      binSize:
        valueFrom: $( 25 )

      # ~Additional inputs~
      narrowBam: bamFilesRaw_Histone_narrow
      broadBam: bamFilesRaw_Histone_broad
      narrowPrefix: prefix_narrow
      broadPrefix: prefix_broad

    out:
      - outputFile


#---------- Step 4: computeFingerprintOnRawBam -----------------------

  computeFingerprintOnRawBam:
    run: ../tools/deepTools-tool-plotFingerprint.cwl
    in: 
      numberOfProcessors: deeptoolsParallel 
      bamfiles:
        valueFrom: $(input.narrowBam.concat(input.broadBam).concat(input.inputBam))
      plotFile:
        valueFrom: $( input.filePrefix.map(function(e) {return e + ".fgpr"}) )
      labels: outName_computeFingerprintOnRawBam_labels
      plotTitle: plotTitle_computeFingerprintOnRawBam
      numberOfSamples: 
        valueFrom: $( 500000 )
      plotFileFormat:
        valueFrom: svg
      outQualityMetrics: 
        valueFrom: $( input.narrowPrefix.concat(input.broadPrefix).concat(input.inputPrefix).map(function(e) {return e + ".qm-fgpr"}) )
      JSDsample: bamFilesRaw_Input
      outRawCounts: 
        valueFrom: $( input.narrowPrefix.concat(input.broadPrefix).concat(input.inputPrefix).map(function(e) {return e + ".counts-fgpr"}) )

      # ~Additional inputs~
      narrowBam: bamFilesRaw_Histone_narrow
      broadBam: bamFilesRaw_Histone_broad
      inputBam: bamFilesRaw_Input
      narrowPrefix: prefix_narrow
      broadPrefix: prefix_broad
      inputPrefix: prefix_input

    out:
      - outputFile


#---------- Step 5: filterBamFiles ---------------------------------

  filterBamFiles:
    run: ../tools/bioconda-tool-sambamba-view.cwl
    scatter: [inputFile, outputFileName]
    scatterMethod: dotproduct
    in:
      format:
        valueFrom: bam 
      nThreads: sambambaParallel 
      outputFileName: 
        valueFrom: $( input.narrowPrefix.concat(input.broadPrefix).concat(input.inputPrefix).map(function(e) {return e + ".tmp.filt.bam"}) )
      filter:
        valueFrom: $( "not (duplicate or unmapped or failed_quality_control or supplementary or secondary_alignment) and mapping_quality >= 5" )
      inputFile: 
        valueFrom: $(input.narrowBam.concat(input.broadBam).concat(input.inputBam))

      # ~Additional inputs~
      narrowBam: bamFilesRaw_Histone_narrow
      broadBam: bamFilesRaw_Histone_broad
      inputBam: bamFilesRaw_Input
      narrowPrefix: prefix_narrow
      broadPrefix: prefix_broad
      inputPrefix: prefix_input

    out:
      - outputBamFile


#---------- Step 6: countReadsInFilteredBam -------------------.....

  countReadsInFilteredBam:
    run: ../tools/bioconda-tool-sambamba-view.cwl
    scatter: [inputFile]
    in:
      count:
        valueFrom: $( 1==1 )
      inputFile: filterBamFiles/outputBamFile
      outputFileName:
        valueFrom: $( input.narrowPrefix.concat(input.broadPrefix).concat(input.inputPrefix).map(function(e) {return e + ".mapped.readcount"}) )

      # ~Additional inputs~
      narrowPrefix: prefix_narrow
      broadPrefix: prefix_broad
      inputPrefix: prefix_input

    out: 
      - outputBamFile


#---------- Step 7: generateCoverageForFilteredBam -----------------

  generateCoverageForFilteredBam:
    run: ../tools/deepTools-tool-bamCoverage.cwl
    scatter: [bam, outFileName]
    scatterMethod: dotproduct
    in:
      numberOfProcessors: deeptoolsParallel 
      binSize:
        valueFrom: $( 25 ) 
      bam: filterBamFiles/outputBamFile 
      outFileName: 
        valueFrom: $( input.narrowPrefix.concat(input.broadPrefix).concat(input.inputPrefix).map(function(e) {return e + ".filt.bamcov"}) )
      outFileFormat:
        valueFrom:  bigwig
      normalizeTo1x: genomeSize 
      blackListFileName: blacklistRegions 
      ignoreForNormalization:
        valueFrom:  $( ["chrX", "chrY", "chrM", "X", "Y", "M", "MT"] )

      # ~Additional inputs~
      narrowPrefix: prefix_narrow
      broadPrefix: prefix_broad
      inputPrefix: prefix_input

    out:
      - outputFile


#---------- Step 8: computeFingerprintForFilteredBam ---------------

  computeFingerprintForFilteredBam:
    run: ../tools/deepTools-tool-plotFingerprint.cwl
    in:
      numberOfProcessors: deeptoolsParallel
      bamfiles: filterBamFiles/outputBamFile
      plotFile:
        valueFrom: $( input.filePrefix.map(function(e) {return e + ".tmp.filt.fgpr"}) )
      labels: outName_computeFingerprintForFilteredBam_labels
      plotTitle: plotTitle_computeFingerprintForFilteredBam 
      numberOfSamples:
        valueFrom: $( 500000 )
      plotFileFormat:
       valueFrom: svg
      outQualityMetrics:
        valueFrom: $( input.narrowPrefix.concat(input.broadPrefix).concat(input.inputPrefix).map(function(e) {return e + ".tmp.filt.qm-fgpr.tmp"}) )
      JSDsample:        
        valueFrom: $( input.inputPrefix.map(function(e) {return e + ".tmp.filt.bam"}) )
      outRawCounts:
        valueFrom: $( input.narrowPrefix.concat(input.broadPrefix).concat(input.inputPrefix).map(function(e) {return e + ".tmp.filt.counts-fgpr"}) )

      # ~Additional inputs~
      narrowPrefix: prefix_narrow
      broadPrefix: prefix_broad
      inputPrefix: prefix_input

    out:
      - outputFile


#---------- Step 9.1: peakCallOnFilteredBam - narrow ---------------

  peakCallOnFilteredBamN:
    run: ../tools/bioconda-tool-macs2-callpeak.cwl
    scatter: [tFile, name, extSize]
    scatterMethod: dotproduct
    in:
      tFile: 
       valueFrom: $( input.narrowPrefix.map(function(e) {return e + ".tmp.filt.bam"}) )
      cFile: 
        valueFrom: $( input.inputPrefix.map(function(e) {return e + ".tmp.filt.bam"}) )
      format:
        valueFrom: BAM 
      gSize: genomeSize
      keepDup: 
        valueFrom: $( "all" )
      name: 
        valueFrom: $( input.narrowPrefix.map(function(e) {return e + ".tmp.filt.bam_" + input.pre}) )
      noModel:
        valueFrom: $( 1==1 ) 
      extSize: fragmentLength_peakCallOnFilteredBam
      qValue:
        valueFrom: $( 0.05 ) 
     
      # ~Additional inputs~
      narrowPrefix: prefix_narrow
      inputPrefix: prefix_input
      pre: prefix_peakCallOnFilteredBam

    out:
      - outputBamFile


#---------- Step 9.2: peakCallOnFilteredBam - broad ----------------

  peakCallOnFilteredBamB:
    run: ../tools/bioconda-tool-macs2-callpeak.cwl
    scatter: [tFile, name, extSize]
    scatterMethod: dotproduct
    in:
      tFile:
        valueFrom: $( input.broadPrefix.map(function(e) {return e + ".tmp.filt.bam"}) )
      cFile:
        valueFrom: $( input.inputPrefix.map(function(e) {return e + ".tmp.filt.bam"}) )
      format:
        valueFrom: BAM
      gSize: genomeSize
      keepDup:
        valueFrom: $( "all" )
      name:
        valueFrom: $( input.broadPrefix.map(function(e) {return e + ".tmp.filt.bam_" + input.pre}) )
      noModel:
        valueFrom: $( 1==1 )
      extSize: fragmentLength_peakCallOnFilteredBam
      qValue:
        valueFrom: $( 0.05 )
      broad: 
        valueFrom: $( 1==1 )

      # ~Additional inputs~
      broadPrefix: prefix_broad
      inputPrefix: prefix_input
      pre: prefix_peakCallOnFilteredBam

    out:
      - outputBamFile


#---------- Step 10.1: zipMacsFiles - narrow -----------------------
#
#  zipMacsFilesN:
#    run: ../tools/localfile-tool-zipMacsFiles.cwl
#    scatter: [inputFile1, inputFile2, inputFile3, outname]
#    scatterMethod: dotproduct
#    in:
#      inputFile1:
#        valueFrom: $( input.narrowPrefix.map(function(e) {return e + ".tmp.filt.bam_" + input.pre + "_peaks.narrowPeak"}) )
#      inputFile2:
#        valueFrom: $( input.narrowPrefix.map(function(e) {return e + ".tmp.filt.bam_" + input.pre + "_peaks.xls"}) )
#      inputFile3:
#        valueFrom: $( input.narrowPrefix.map(function(e) {return e + ".tmp.filt.bam_" + input.pre + "_summits.bed"}) )
#      outname:
#         valueFrom: $( input.inPrefix.map(function(e) {return e + ".macs.out"}) )
# 
#      # ~Additional Inputs~
#      narrowPrefix: prefix_narrow
#      pre: prefix_peakCallOnFilteredBam
#      inPrefix: prefix_narrow
#  out:
#   - outZipFile


#---------- Step 10.2: zipMacsFiles - broad ------------------------

#  zipMacsFilesB:
#    run: ../tools/localfile-tool-zipMacsFiles.cwl
#    scatter: [arg1, arg2, arg3, outname]
#    scatterMethod: dotproduct
#    in:
#      inputFile1:
#        valueFrom: $( input.broadPrefix.map(function(e) {return e + ".tmp.filt.bam_" + input.pre + "_peaks.broadPeak"}) )
#      inputFile2:
#        valueFrom: $( input.broadPrefix.map(function(e) {return e + ".tmp.filt.bam_" + input.pre + "_peaks.xls"}) )
#      inpputFile3:
#        valueFrom: $( input.broadPrefix.map(function(e) {return e + ".tmp.filt.bam_" + input.pre + "_peaks.gappedPeak"}) )
#      outname:
#         valueFrom: $( input.inPrefix.map(function(e) {return e + ".macs.out"}) )
#
#      # ~Additional Inputs~
#      narrowPrefix: prefix_narrow
#      pre: prefix_peakCallOnFilteredBam
#      inPrefix: prefix_broad
#  out:
#    outZipFile


#---------- Step 11: histoneHMM ------------------------------------

#---------- Step 12: makeHistoneHMMBedLike -------------------------

#---------- Step 13: zipSecHistoneHMMFiles -------------------------

#---------- Step 14: countReadsOverlappingPeakRegions --------------

  countReadsOverlappingPeakRegions:
    run: ../tools/bioconda-tool-sambamba-view.cwl
    scatter: [inputFile]
    scatterMethod: dotproduct
    in:
      count: 
        valueFrom: $( 1==1 )
      nThreads: sambambaParallel
      regions: 
        valueFrom: $( (input.narrowPrefix.map(function(e) {return e + ".tmp.filt.bam_" + input.pre + "_peaks.narrowPeak"})).concat(input.broadPrefix.map(function(e) {return e + ".tmp.filt.bam_" + input.pre + "_peaks.broadPeak"})) )
      inputFile: filterBamFiles/outputBamFile
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
      fileA:
        valueFrom: $( input.narrowPrefix.map(function(e) {return e + ".tmp.filt.bam_" + input.pre + ".bed"}) )

#TODO: Only narrow peak files. Outputs for broad files are: <name>_peaks.broadPeak, <name>_peaks.xls and <name>_summits.gappesPeak

      fileB: blacklistRegions
       
      # ~Additional inputs~
      narrowPrefix: prefix_narrow
      pre: prefix_peakCallOnFilteredBam
    out:
      - outputFile


#---------- Step 16: intersectHistoneHMMFiles ----------------------

#---------- Step 17: flagAndStandardizePeaks -----------------------

#---------- Step 18: restrictFilteredBAMstoAutosomalRegions --------

#---------- Step 19: createDataMatrixForCorrelationPlot ------------

#---------- Step 20: createHeatmapCorrelationPlot ------------------



$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
