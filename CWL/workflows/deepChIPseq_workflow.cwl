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

  # Raw input bamfile: GALvX_Input
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


#---------- Blacklist Regions --------------------------------------

  blacklistRegions:
    type: File


#---------- Step specific parameters -------------------------------

#---------- Step 1: generateSignalCovTrack -------------------------
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
#---------- Step 14: countReadsOverlappingPeakRegions --------------
#---------- Step 15: intersectPeakFiles ----------------------------
#---------- Step 16: intersectHistoneHMMFiles ----------------------
#---------- Step 17: flagAndStandardizePeaks -----------------------
#---------- Step 18: restrictFilteredBAMstoAutosomalRegions --------
#---------- Step 19: createDataMatrixForCorrelationPlot ------------
#---------- Step 20: createHeatmapCorrelationPlot ------------------


#---------- Step 2: computeGCBias ----------------------------------

  genome: File

  fragmentLength_computeGCBias: int[]
  

#---------- Step 3: generateLog2FoldChangeTracks -------------------

  scaleFactorsMethod_generateLog2FoldChangeTracks:
    type:
    - "null"
    - type: enum
      symbols: ['readCount', 'SES']


#---------- Step 4: computeFingerprintOnRawBam ---------------------

  labels_computeFingerprintOnRawBam:
    type:
    - "null"
    - type: array
      items: string

  plotTitle_computeFingerprintOnRawBam:
    type: string


#---------- Step 8: computeFingerprintForFilteredBam ---------------

  labels_computeFingerprintForFilteredBam: string[]

  plotTitle_computeFingerprintForFilteredBam: string


#---------- Step 9: peakCallOnFilteredBam --------------------------

  prefix_peakCallOnFilteredBam: string

  fragmentLength_peakCallOnFilteredBam: int[]


#---------- Step 18: restrictFilteredBAMstoAutosomalRegions --------

  autosomeRegions_restrictFilteredBAMstoAutosomalRegions: File[]


#---------- Step 19: createDataMatrixForCorrelationPlot ------------

  labels_createDataMatrixForCorrelationPlot:
    - "null"
    - type: array
      items: string


#---------- Step 20: createHeatmapCorrelationPlot ------------------

  plotTitle_createHeatmapCorrelationPlot: string

  corrMethod_createHeatmapCorrelationPlot:
    type: string
#    - type: enum
#      symbols: ['spearman', 'pearson']

#-------------------------------------------------------------------

  dummyFileA: File
  dummyFileB: File
  
  dummyCorrFile: File

#-------------------------------------------------------------------
#-------------------------------------------------------------------

outputs: 

  # DEEPID.PROC.DATE.ASSM.raw.bamcov
  - id: out1
    type: File[]
    outputSource: "#generateSignalCovTrack/outputFile"

  # DEEPID.PROC.DATE.ASSM.filt.bamcov
  - id: out2
    type: File[]
    outputSource: "#generateCoverageForFilteredBam/outputFile"

  # DEEPID.PROC.DATE.ASSM.ses.log2-Input
  - id: out3
    type: File[]
    outputSource: TODO

  # DEEPID.PROC.DATE.ASSM.cnt.log2-Input
  - id: out4
    type: File[]
    outputSource: TODO

  # DEEPID.PROC.DATE.ASSM.gcfreq
  - id: out6
    type: File[]
    outputSource: "#computeGCBias/outputFile"

  # DEEPID.PROC.DATE.ASSM.hhmm.emfit 
  - id: out7
    type: File[]
    outputSource: "#makeHistoneHMMBedLike/" TODO

  # DEEPID.PROC.DATE.ASSM.hhmm.out
  - id: out8
    type: File[]
    outputSource: "#histoneHMMN/" TOOD

  # DEEPID.PROC.DATE.ASSM.macs.out
  - id: out9
    type: File[]
    outputSource: "#histoneHMMB/" TODO

  # DEEPID.PROC.DATE.ASSM.hhmm.broad
  - id: out10
    type: File[]
    outputSource: "#peakCallOnFilteredBamN/outputBamFile"

  # DEEPID.PROC.DATE.ASSM.macs.broad
  - id: out11
    type: File[]
    outputSource: "#peakCallOnFilteredBamB/outputBamFile"

  # DEEPID.PROC.DATE.ASSM.qm-fgpr
  - id: out14
    type: File[]
    outputSource: "#computeFingerprintForFilteredBam/outputFile"

  # DEEPID.PROC.DATE.ASSM.auto.counts-summ
  - id: out16
    type: File[]
    outputSource: "#createDataMatrixForCorrelationPlot/outputFile"

  # DEEPID.PROC.DATE.ASSM.corrmat
  - id: out19
    type: File[]
    outputSource: "#createHeatmapCorrelationPlot/outputFile"

#-------------------------------------------------------------------
#-------------------------------------------------------------------

steps:
  

#---------- Step 1: generateSignalCovTrack -------------------------

  generateSignalCovTrack:
    run: ../tools/deepTools-tool-bamCoverage.cwl
    scatter: [bam, outFileName]
    scatterMethod: dotproduct   
    in:
      numberOfProcessors: deeptoolsParallel
      binSize: 
        valueFrom: $( 25)
      bam:
        valueFrom: $( input.narrowBam.concat(input.broadBam).concat(input.inputBam))
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
    scatter: [bamfile, GCbiasFrequenciesFile, fragmentLength, biasPlot]
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


#---------- Step 3: generateLog2FoldChangeTracks -------------------

  generateLog2FoldChangeTracks:
    run: ../tools/deepTools-tool-bamCompare.cwl
    scatter: [bamfile1, outFileName]
    scatterMethod: dotproduct
    in:
      numberOfProcessors: deeptoolsParallel
      bamfile1: 
        valueFrom: $(input.narrowBam.concat(input.broadBam))
      bamfile2: bamFilesRaw_Input
      outFileName:
        valueFrom: $( input.narrowPrefix.concat(input.broadPrefix).map(function(e) {return e + ".log2-Input"}) )
      outFileFormat:
        valueFrom: bigwig
      scaleFactorsMethod: scaleFactorsMethod_generateLog2FoldChangeTracks
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
      labels: labels_computeFingerprintOnRawBam
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
      filePrefix: filePrefix
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


#---------- Step 8: computeFingerprintForFilteredBam ---------------

  computeFingerprintForFilteredBam:
    run: ../tools/deepTools-tool-plotFingerprint.cwl
    in:
      numberOfProcessors: deeptoolsParallel
      bamfiles: filterBamFiles/outputBamFile
      plotFile:
        valueFrom: $( input.filePrefix.map(function(e) {return e + ".tmp.filt.fgpr"}) )
      labels: labels_computeFingerprintForFilteredBam
      plotTitle: plotTitle_computeFingerprintForFilteredBam 
      numberOfSamples:
        valueFrom: $( 500000 )
      plotFileFormat:
       valueFrom: svg
      outQualityMetrics:
        valueFrom: $( input.filePrefix.map(function(e) {return e + ".tmp.filt.qm-fgpr.tmp"}) )
      JSDsample:        
        valueFrom: $( input.inputPrefix.map(function(e) {return e + ".tmp.filt.bam"}) )
      outRawCounts:
        valueFrom: $( input.filePrefix).map(function(e) {return e + ".tmp.filt.counts-fgpr"}) )

      # ~Additional inputs~
      inputPrefix: prefix_input
      filePrefix: filePrefix

    out:
      - outputFile


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
        # TODO: Which name to take here? At the moment: prefix_peakCallOnFilteredBam
      noModel:
        valueFrom: $( 1==1 )
      extSize: fragmentLength_peakCallOnFilteredBam
      # TODO: Fragment length the same for all files?
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



#---------- Step 11: histoneHMM ------------------------------------
# TODO: Missing


#---------- Step 12: makeHistoneHMMBedLike -------------------------
# TODO: Missing


#---------- Step 13: zipSecHistoneHMMFiles -------------------------
# TODO: Missing


#---------- Step 16: intersectHistoneHMMFiles ----------------------

  intersectHistoneHMMFiles:
    run: ../tools/bioconda-tool-bedtools-intersect.cwl
#    scatter: [fileA]
#    scatterMethod: dotproduct
    in:
      originalAOnce:
        valueFrom: $( 1==1 )
      fileA:
        valueFrom: dummyFileA    # TODO: Which file? 
      fileB:
        valueFrom: dummyFileB    # TODO: Which file?
#      outFileName: TODO: Which name?
 
      # ~Additional inputs~
      # TODO
    out:
      - outputFile


#---------- Step 17: flagAndStandardizePeaks -----------------------

# TODO: Missing


#---------- Step 18: restrictFilteredBAMstoAutosomalRegions --------

  restrictFilteredBAMstoAutosomalRegions:
    run: ../tools/bioconda-tool-sambamba-view.cwl
    scatter: [outputFilename, inputFile]
    scatterMethod: dotproduct
    in:
      format:
        valueFrom: bam
      nThreads: sambambaParallel
      outputFilename:
        valueFrom: $( input.filePrefix.map(function(e) {return e + ".tmp.auto.bam"}) )
      regions: autosomeRegions_restrictFilteredBAMstoAutosomalRegions
      inputFile: filterBamFiles/outputBamFile

      # ~Additional inputs~
      filePrefix: filePrefix

    out:
      - outputBamFile


#---------- Step 19: createDataMatrixForCorrelationPlot ------------

  createDataMatrixForCorrelationPlot:
    run: ../tools/deepTools-tool-multiBamSummary-bins.cwl
    in:
      numberOfProcessors:
        valueFrom: $( 8 )
      bamfiles: restrictFilteredBAMstoAutosomalRegions/outputBamFile 
      outFileName:
        valueFrom: $( input.filePrefix.map(function(e) {return e + ".auto.summ"}) )
      labels: labels_createDataMatrixForCorrelationPlot
      binSize:
        valueFrom: $( 1000 )
      distanceBetweenBins:
        valueFrom: $( 2000 )
      blackListFileName: blacklistRegions    # TODO: 1 File for all or step specific?
      outRawCounts: 
        valueFrom: $( input.filePrefix.map(function(e) {return e + ".auto.counts-summ"}) )
 
     # ~Additional inputs~
      filePrefix: filePrefix 

    out:
      - outputFile
    

#---------- Step 20: createHeatmapCorrelationPlot ------------------

  createHeatmapCorrelationPlot:
    run: ../tools/deepTools-tool-plotCorrelation.cwl
    in:
      corData: dummyCorrFile      # TODO: What file?
      plotFile:
        valueFrom: $( input.filePrefix.map(function(e) {return e + ".bamcorr"}) )
# TODO: Shouldnt it be .svg at the end?
      whatToPlot:
        valueFrom: heatmap
      plotTitle: plotTitle_createHeatmapCorrelationPlot
      plotFileFormat:
        valueFrom: svg 
      corMethod: corrMethod_createHeatmapCorrelationPlot
      plotNumbers:
        valueFrom: $ ( 1==1 )
      zMin:
        valueFrom: $( -1 )
      zMax: 
        valueFrom: $( 1 )
      colorMap:
        valueFrom: $( "coolwarm" )
      outFileCorMatrix:
        valueFrom: $( input.filePrefix.map(function(e) {return e + ".corrmat"}) 
 
      # ~Additional inputs~
      filePrefix: filePrefix
 
    out:
      - outputFile


$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl



#      # ~Additional Inputs~
#       proxy1:
#         valueFrom: $( inputs.narrowPeaks.concat(inputs.broadPeaks) )
#       proxy2:
#         valueFrom: $(
#      narrowPrefix: prefix_narrow
#       narrowPeaks:
#       narrowTable:
#       narrowSummits:

#       broadPrefix: prefix_broad
#       broadPeaks:
#       broadTable:
#       broadGapped

