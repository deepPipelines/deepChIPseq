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
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement

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
      - ".bai"

  # Raw bamfiles broad GALvX_Histone
  bamFilesRaw_Histone_broad:
    type:
    - type: array
      items: File
    secondaryFiles:
      - ".bai"

  # Raw input bamfile: GALvX_Input
  bamFilesRaw_Input:
    type: File
    secondaryFiles:
      - ".bai"
  
  # Like <DEEPID.PROC.DATE.ASSM.HistoneID>
  prefix_narrow: string[] 
  prefix_broad: string[]
  prefix_input: string

  # Like <DEEPID.PROC.DATE.ASSM>
  filePrefix: string

#---------- Genome size --------------------------------------------

  genomeSize: int


#---------- Blacklist Regions --------------------------------------

#  blacklistRegions:
#    type: File


#---------- Step specific parameters -------------------------------

#---------- Step 1: generateSignalCovTrack -------------------------M
#---------- Step 2: computeGCBias ----------------------------------M
#---------- Step 3: generateLog2FoldChangeTracks -------------------M
#---------- Step 4: computeFingerprintOnRawBam ---------------------M
#---------- Step 5.1: filterBamFiles - narrow ----------------------M
#---------- Step 5.2: filterBamFiles - broad -----------------------M
#---------- Step 5.3: filterBamFiles - input -----------------------M
#---------- Step 6: countReadsInFilteredBam ------------------------N
#---------- Step 7: generateCoverageForFilteredBam -----------------N
#---------- Step 8: computeFingerprintForFilteredBam ---------------M
#---------- Step 9.1: peakCallOnFilteredBam - narrow ---------------N
#---------- Step 9.2: peakCallOnFilteredBam - broad ----------------M
#---------- Step 10.1: zipMacsFiles - narrow -----------------------N
#---------- Step 10.2: zipMacsFiles - broad ------------------------M
#---------- Step 11: histoneHMM ------------------------------------B
#---------- Step 12: makeHistoneHMMBedLike -------------------------B
#---------- Step 13: zipSecHistoneHMMFiles -------------------------B
#---------- Step 14: countReadsOverlappingPeakRegions --------------N
#---------- Step 15: intersectPeakFiles ----------------------------N
#---------- Step 16: intersectHistoneHMMFiles ----------------------M
#---------- Step 17: flagAndStandardizePeaks -----------------------M
#---------- Step 18: restrictFilteredBAMstoAutosomalRegions --------M
#---------- Step 19: createDataMatrixForCorrelationPlot ------------M
#---------- Step 20: createHeatmapCorrelationPlot ------------------M
#---------- Step 21: narrowWorkflow --------------------------------


#---------- Step 2: computeGCBias ----------------------------------

  genome: File

  fragmentLength_computeGCBias: int[]
  

#---------- Step 3: generateLog2FoldChangeTracks -------------------

#  scaleFactorsMethod_generateLog2FoldChangeTracks:
#    type:
#    - "null"
#    - type: enum
#      symbols: ['readCount', 'SES']


#---------- Step 4: computeFingerprintOnRawBam ---------------------

#  labels_computeFingerprintOnRawBam:
#    type:
#    - "null"
#    - type: array
#      items: string

#  plotTitle_computeFingerprintOnRawBam:
#    type: string


#---------- Step 8: computeFingerprintForFilteredBam ---------------

#  labels_computeFingerprintForFilteredBam: string[]

#  plotTitle_computeFingerprintForFilteredBam: string


#---------- Step 9: peakCallOnFilteredBam --------------------------

#  prefix_peakCallOnFilteredBam: string

#  fragmentLength_peakCallOnFilteredBamN: int[]
#  fragmentLength_peakCallOnFilteredBamB: int[]

#---------- Step 18: restrictFilteredBAMstoAutosomalRegions --------

#  autosomeRegions_restrictFilteredBAMstoAutosomalRegions: File[]


#---------- Step 19: createDataMatrixForCorrelationPlot ------------

#  labels_createDataMatrixForCorrelationPlot:
#    - "null"
#    - type: array
#      items: string


#---------- Step 20: createHeatmapCorrelationPlot ------------------

#  plotTitle_createHeatmapCorrelationPlot: string

#  corrMethod_createHeatmapCorrelationPlot:
#    type: string
##    - type: enum
##      symbols: ['spearman', 'pearson']

#-------------------------------------------------------------------

#  dummyFileA: File
#  dummyFileB: File
  
#  dummyCorrFile: File

#-------------------------------------------------------------------
#-------------------------------------------------------------------

outputs: 

  # DEEPID.PROC.DATE.ASSM.raw.bamcov
  - id: out1
    type: File[]
    outputSource: "#generateSignalCovTrack/outputFile"

# DEEPID.PROC.DATE.ASSM.filt.bamcov
#  - id: out2
#    type: File[]
#    outputSource: "#computeGCBias/outputFile"

  # DEEPID.PROC.DATE.ASSM.ses.log2-Input
#  - id: out3
#    type: File[]
#    outputSource: TODO

  # DEEPID.PROC.DATE.ASSM.cnt.log2-Input
#  - id: out4
#    type: File[]
#    outputSource: TODO

  # DEEPID.PROC.DATE.ASSM.gcfreq
#  - id: out6
#    type: File[]
#    outputSource: "#computeGCBias/outputFile"

  # DEEPID.PROC.DATE.ASSM.hhmm.emfit 
#  - id: out7
#    type: File[]
#    outputSource: "#makeHistoneHMMBedLike/" TODO

  # DEEPID.PROC.DATE.ASSM.hhmm.out
#  - id: out8
#    type: File[]
#    outputSource: "#histoneHMMN/" TOOD

# DEEPID.PROC.DATE.ASSM.macs.out
#  - id: out9
#    type: File[]
#    outputSource: "#histoneHMMB/" TODO

  # DEEPID.PROC.DATE.ASSM.hhmm.broad
#  - id: out10
#    type: File[]
#    outputSource: "#peakCallOnFilteredBamN/outputBamFile"

  # DEEPID.PROC.DATE.ASSM.macs.broad
#  - id: out11
#    type: File[]
#    outputSource: "#peakCallOnFilteredBamB/outputBamFile"

  # DEEPID.PROC.DATE.ASSM.qm-fgpr
#  - id: out14
#    type: File[]
#    outputSource: "#computeFingerprintForFilteredBam/outputFile"

  # DEEPID.PROC.DATE.ASSM.auto.counts-summ
#  - id: out16
#    type: File[]
#    outputSource: "#createDataMatrixForCorrelationPlot/outputFile"

  # DEEPID.PROC.DATE.ASSM.corrmat
#  - id: out19
#    type: File[]
#    outputSource: "#createHeatmapCorrelationPlot/outputFile"

#-------------------------------------------------------------------
#-------------------------------------------------------------------


# PREPROCESSING: Put broad and narrow input files into one array ---
steps:

  concatFilesBroadNarrow:
    run:
      class: ExpressionTool
      id: "concatFilesBroadNarrow"
      inputs:
        bamFilesRaw_Histone_narrow: File[]
        bamFilesRaw_Histone_broad: File[]
      outputs:
        bamFiles: File[]
      expression: |
        ${
          var bamFiles = inputs.bamFilesRaw_Histone_narrow.concat(inputs.bamFilesRaw_Histone_broad)
          return { "bamFiles": bamFiles };
         }
    in: 
      bamFilesRaw_Histone_narrow: bamFilesRaw_Histone_narrow
      bamFilesRaw_Histone_broad: bamFilesRaw_Histone_broad
    out:
      - bamFiles

# PREPROCESSING: Put broad and narrow prefixes into one array ------
  concatPrefixesBroadNarrow:
    run:
      class: ExpressionTool
      id: "concatPrefixesBroadNarrow"
      inputs:
        prefix_narrow: string[]
        prefix_broad: string[]
      outputs:
        prefixes: string[]
      expression: |
        ${
          var prefixes = inputs.prefix_narrow.concat(inputs.prefix_broad)
          return { "prefixes": prefixes };
         }
    in:
      prefix_narrow: prefix_narrow
      prefix_broad: prefix_broad
    out:
      - prefixes

# PREPROCESSING: Put broad, narrow and input files into one array -- 
  concatFilesBroadNarrowInput:
    run:
      class: ExpressionTool
      id: "concatFilesBroadNarrowInput"
      inputs:
        bamFilesRaw_Histone_narrow: File[]
        bamFilesRaw_Histone_broad: File[]
        bamFilesRaw_Input: File
      outputs:
        bamFiles: File[]
      expression: |
        ${
          var bamFiles = inputs.bamFilesRaw_Histone_narrow.concat(inputs.bamFilesRaw_Histone_broad);
          bamFiles.push(inputs.bamFilesRaw_Input);
          return { "bamFiles": bamFiles };
        }
    in:
      bamFilesRaw_Histone_narrow: bamFilesRaw_Histone_narrow
      bamFilesRaw_Histone_broad: bamFilesRaw_Histone_broad
      bamFilesRaw_Input: bamFilesRaw_Input
    out:
      - bamFiles

# PREPROCESSING: Put broad, narrow and input prefixes into one array
  concatPrefixesBroadNarrowInput:
    run:
      class: ExpressionTool
      id: "concatPrefixesBroadNarrowInput"
      inputs:
        prefix_narrow: string[]
        prefix_broad: string[]
        prefix_input: string
      outputs:
        prefixes: string[]
      expression: |
        ${
          var prefixes = inputs.prefix_narrow.concat(inputs.prefix_broad);
          prefixes.push(inputs.prefix_input);
          return { "prefixes": prefixes };
         }
    in:
      prefix_narrow: prefix_narrow
      prefix_broad: prefix_broad
      prefix_input: prefix_input
    out:
      - prefixes

#---------- Step 1: generateSignalCovTrack -------------------------
  generateSignalCovTrack:
    run: ../tools/deepTools-tool-bamCoverage.cwl
    scatter: [bam, outFileName]
    scatterMethod: dotproduct
    in:
      numberOfProcessors: deeptoolsParallel
      binSize:
        valueFrom: $( 2500 )
      bam: concatFilesBroadNarrowInput/bamFiles
      outFileName: concatPrefixesBroadNarrowInput/prefixes
      outFileFormat:
        valueFrom:  $( "bigwig" )
      normalizeTo1x: genomeSize
 
    out:
      - outputFile
                                      
#---------- Step 2: computeGCBias ------------------------------------
  addGCFREQ:
    run:
      class: ExpressionTool
      id: "addGCFREQ"
      inputs:
        prefix_array: string[]
      outputs:
        prefixes: string[]
      expression: |
        ${
          return inputs.prefix.map(function(e) {reutrn e + ".gcfreq"});
         }
    in:
      prefix_array: concatPrefixesBroadNarrowInput/prefixes
    out:
      - prefixes


  computeGCBias:
    run: ../tools/deepTools-tool-computeGCBias.cwl
    scatter: [bamfile, fragmentLength, GCbiasFrequenciesFile] #, biasPlot]
    scatterMethod: dotproduct
    in:
      numberOfProcessors: deeptoolsParallel
      bamfile: concatFilesBroadNarrowInput/bamFiles
      effectiveGenomeSize: genomeSize
      genome: genome
      sampleSize:
        valueFrom: $( 50000000.0 )
      fragmentLength: fragmentLength_computeGCBias
      GCbiasFrequenciesFile: addGCFREQ/prefixes
#        valueFrom: $((concatPrefixesBroadNarrowInput/prefixes).map(function(e) {reutrn e + ".gcfreq"}))
#      biasPlot:
#        valueFrom: $(concatPrefixesBroadNarrowInput/prefixes).map(function(e) {return e + ".gcbias"})))
      plotFileFormat:
        valueFrom: $( svg )

    out:
      - outputFile


#---------- Step 3: generateLog2FoldChangeTracks -------------------

#  generateLog2FoldChangeTracks:
#    run: ../tools/deepTools-tool-bamCompare.cwl
#    scatter: [bamfile1, outFileName]
#    scatterMethod: dotproduct
#    in:
#      numberOfProcessors: deeptoolsParallel
#      bamfile1: 
#        valueFrom: $(input.narrowBam.concat(input.broadBam))
#      bamfile2: bamFilesRaw_Input
#      outFileName:
#        valueFrom: $( input.narrowPrefix.concat(input.broadPrefix).map(function(e) {return e + ".log2-Input"}) )
#      outFileFormat:
#        valueFrom: bigwig
#      scaleFactorsMethod: scaleFactorsMethod_generateLog2FoldChangeTracks
#      ratio:
#        valueFrom: log2
#      binSize:
#        valueFrom: $( 25 )
#
#      # ~Additional inputs~
#      narrowBam: bamFilesRaw_Histone_narrow
#      broadBam: bamFilesRaw_Histone_broad
#      narrowPrefix: prefix_narrow
#      broadPrefix: prefix_broad
#
#    out:
#      - outputFile


#---------- Step 4: computeFingerprintOnRawBam -----------------------

#  computeFingerprintOnRawBam:
#    run: ../tools/deepTools-tool-plotFingerprint.cwl
#    in: 
#      numberOfProcessors: deeptoolsParallel 
#      bamfiles:
#        valueFrom: $(input.narrowBam.concat(input.broadBam).concat(input.inputBam))
#      plotFile:
#        valueFrom: $( input.filePrefix.map(function(e) {return e + ".fgpr"}) )
#      labels: labels_computeFingerprintOnRawBam
#      plotTitle: plotTitle_computeFingerprintOnRawBam
#      numberOfSamples: 
#        valueFrom: $( 500000 )
#      plotFileFormat:
#        valueFrom: svg
#      outQualityMetrics: 
#        valueFrom: $( input.narrowPrefix.concat(input.broadPrefix).concat(input.inputPrefix).map(function(e) {return e + ".qm-fgpr"}) )
#      JSDsample: bamFilesRaw_Input
#      outRawCounts: 
#        valueFrom: $( input.narrowPrefix.concat(input.broadPrefix).concat(input.inputPrefix).map(function(e) {return e + ".counts-fgpr"}) )
#
#      # ~Additional inputs~
#      narrowBam: bamFilesRaw_Histone_narrow
#      broadBam: bamFilesRaw_Histone_broad
#      inputBam: bamFilesRaw_Input
#      narrowPrefix: prefix_narrow
#      broadPrefix: prefix_broad
#      inputPrefix: prefix_input
#      filePrefix: filePrefix
#    out:
#      - outputFile


#---------- Step 5.1: filterBamFiles - narrow ----------------------

#  filterBamFilesN:
#    run: ../tools/bioconda-tool-sambamba-view.cwl
#    scatter: [inputFile, outputFileName]
#    scatterMethod: dotproduct
#    in:
#      format:
#        valueFrom: bam 
#      nThreads: sambambaParallel 
#      outputFileName: 
#        valueFrom: $( input.narrowPrefix.map(function(e) {return e + ".tmp.filt.bam"}) )
#      filter:
#        valueFrom: $( "not (duplicate or unmapped or failed_quality_control or supplementary or secondary_alignment) and mapping_quality >= 5" )
#      inputFile: bamFilesRaw_Histone_narrow
#
#      # ~Additional inputs~
#      narrowBam: bamFilesRaw_Histone_narrow
#      narrowPrefix: prefix_narrow
#
#    out:
#      - outputBamFile


#---------- Step 5.2: filterBamFiles - broad -----------------------

#  filterBamFilesB:
#    run: ../tools/bioconda-tool-sambamba-view.cwl
#    scatter: [inputFile, outputFileName]
#    scatterMethod: dotproduct
#    in:
#      format:
#        valueFrom: bam
#      nThreads: sambambaParallel
#      outputFileName:
#        valueFrom: $( input.broadPrefix.map(function(e) {return e + ".tmp.filt.bam"}) )
#      filter:
#        valueFrom: $( "not (duplicate or unmapped or failed_quality_control or supplementary or secondary_alignment) and mapping_quality >= 5" )
#      inputFile: bamFilesRaw_Histone_broad
#
#      # ~Additional inputs~
#      broadBam: bamFilesRaw_Histone_broad
#      broadPrefix: prefix_broad
#
#    out:
#      - outputBamFile
      

#---------- Step 5.3: filterBamFiles - input -----------------------

#  filterBamFilesI:
#    run: ../tools/bioconda-tool-sambamba-view.cwl
#    scatter: [inputFile, outputFileName]
#    scatterMethod: dotproduct
#    in:
#      format:
#        valueFrom: bam
#      nThreads: sambambaParallel
#      outputFileName:
#        valueFrom: $( input.imputPrefix.map(function(e) {return e + ".tmp.filt.bam"}) )
#      filter:
#        valueFrom: $( "not (duplicate or unmapped or failed_quality_control or supplementary or secondary_alignment) and mapping_quality >= 5" )
#      inputFile: bamFilesRaw_Histone_Input
#
#     # ~Additional inputs~
#      inputBam: bamFilesRaw_Input
#      inputPrefix: prefix_input
#
#    out:
#      - outputBamFile
      

#---------- Step 8: computeFingerprintForFilteredBam ---------------

#  computeFingerprintForFilteredBam:
#    run: ../tools/deepTools-tool-plotFingerprint.cwl
#    in:
#      numberOfProcessors: deeptoolsParallel
#      bamfiles: filterBamFiles/outputBamFile
#      plotFile:
#        valueFrom: $( input.filePrefix.map(function(e) {return e + ".tmp.filt.fgpr"}) )
#      labels: labels_computeFingerprintForFilteredBam
#      plotTitle: plotTitle_computeFingerprintForFilteredBam 
#      numberOfSamples:
#        valueFrom: $( 500000 )
#      plotFileFormat:
#       valueFrom: svg
#      outQualityMetrics:
#        valueFrom: $( input.filePrefix.map(function(e) {return e + ".tmp.filt.qm-fgpr.tmp"}) )
#      JSDsample:        
#        valueFrom: $( input.inputPrefix.map(function(e) {return e + ".tmp.filt.bam"}) )
#      outRawCounts:
#        valueFrom: $( input.filePrefix).map(function(e) {return e + ".tmp.filt.counts-fgpr"}) )
#
#      # ~Additional inputs~
#      inputPrefix: prefix_input
#      filePrefix: filePrefix
#
#    out:
#      - outputFile


#---------- Step 9.2: peakCallOnFilteredBam - broad ----------------

#  peakCallOnFilteredBamB:
#    run: ../tools/bioconda-tool-macs2-callpeak.cwl
#    scatter: [tFile, name, extSize]
#    scatterMethod: dotproduct
#    in:
#      tFile:
#        valueFrom: $( input.broadPrefix.map(function(e) {return e + ".tmp.filt.bam"}) )
#      cFile:
#        valueFrom: $( input.inputPrefix.map(function(e) {return e + ".tmp.filt.bam"}) )
#      format:
#        valueFrom: BAM
#      gSize: genomeSize
#      keepDup:
#        valueFrom: $( "all" )
#      name:
#        valueFrom: $( input.broadPrefix.map(function(e) {return e + ".tmp.filt.bam_" + input.pre}) )
#        # TODO: Which name to take here? At the moment: prefix_peakCallOnFilteredBam
#      noModel:
#        valueFrom: $( 1==1 )
#      extSize: fragmentLength_peakCallOnFilteredBam
#      # TODO: Fragment length the same for all files?
#      qValue:
#        valueFrom: $( 0.05 )
#      broad: 
#        valueFrom: $( 1==1 )
#
#      # ~Additional inputs~
#      broadPrefix: prefix_broad
#      inputPrefix: prefix_input
#      pre: prefix_peakCallOnFilteredBam
#
#    out:
#      - outputBamFile


#---------- Step 17: flagAndStandardizePeaks -----------------------

# TODO: Missing


#---------- Step 18: restrictFilteredBAMstoAutosomalRegions --------

#  restrictFilteredBAMstoAutosomalRegions:
#    run: ../tools/bioconda-tool-sambamba-view.cwl
#    scatter: [outputFilename, inputFile]
#    scatterMethod: dotproduct
#    in:
#      format:
#        valueFrom: bam
#      nThreads: sambambaParallel
#      outputFilename:
#        valueFrom: $( input.filePrefix.map(function(e) {return e + ".tmp.auto.bam"}) )
#      regions: autosomeRegions_restrictFilteredBAMstoAutosomalRegions
#      inputFile: filterBamFiles/outputBamFile
#
#      # ~Additional inputs~
#      filePrefix: filePrefix
#
#    out:
#      - outputBamFile


#---------- Step 19: createDataMatrixForCorrelationPlot ------------

#  createDataMatrixForCorrelationPlot:
#    run: ../tools/deepTools-tool-multiBamSummary-bins.cwl
#    in:
#      numberOfProcessors:
#        valueFrom: $( 8 )
#      bamfiles: restrictFilteredBAMstoAutosomalRegions/outputBamFile 
#      outFileName:
#        valueFrom: $( input.filePrefix.map(function(e) {return e + ".auto.summ"}) )
#      labels: labels_createDataMatrixForCorrelationPlot
#      binSize:
#        valueFrom: $( 1000 )
#      distanceBetweenBins:
#        valueFrom: $( 2000 )
#      blackListFileName: blacklistRegions    # TODO: 1 File for all or step specific?
#      outRawCounts: 
#        valueFrom: $( input.filePrefix.map(function(e) {return e + ".auto.counts-summ"}) )
# 
#     # ~Additional inputs~
#      filePrefix: filePrefix 
#
#    out:
#      - outputFile
    

#---------- Step 20: createHeatmapCorrelationPlot ------------------

#  createHeatmapCorrelationPlot:
#    run: ../tools/deepTools-tool-plotCorrelation.cwl
#    in:
#      corData: dummyCorrFile      # TODO: What file?
#      plotFile:
#        valueFrom: $( input.filePrefix.map(function(e) {return e + ".bamcorr"}) )
## TODO: Shouldnt it be .svg at the end?
#      whatToPlot:
#        valueFrom: heatmap
#      plotTitle: plotTitle_createHeatmapCorrelationPlot
#      plotFileFormat:
#        valueFrom: svg 
#      corMethod: corrMethod_createHeatmapCorrelationPlot
#      plotNumbers:
#        valueFrom: $ ( 1==1 )
#      zMin:
#        valueFrom: $( -1 )
#      zMax: 
#        valueFrom: $( 1 )
#      colorMap:
#        valueFrom: $( "coolwarm" )
#      outFileCorMatrix:
#        valueFrom: $( input.filePrefix.map(function(e) {return e + ".corrmat"}) 
# 
#      # ~Additional inputs~
#      filePrefix: filePrefix
# 
#    out:
#      - outputFile

#---------- Step 21: narrowWorkflow --------------------------------

#  narrowWorkflow:
#    run: deepChIPseq_workflow_narrow.cwl
#    scatter: [filteredBamFile_nWF, filePrefix_nWF, fragmentLength_peakCallOnFilteredBamN_nWF]
#    scatterMethod: dotproduct
#    in:
#      deeptoolsParallel_nWF: deeptoolsParallel
#      sambambaParallel_nWF: sambambaParallel
#      filteredBamFile_nWF: filterBamFilesN/outputBamFile
#      filePrefix_nWF: prefix_narrow
#      genomeSize_nWF: genomeSize
#      blacklistRegions_nWF: blacklistRegions
#      fragmentLength_peakCallOnFilteredBamN_nWF: fragmentLength_peakCallOnFilteredBamN
#    
#    out:
#      []

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
