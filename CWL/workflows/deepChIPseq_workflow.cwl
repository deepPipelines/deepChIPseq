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

  deeptoolsParallel:
    type: int


#---------- Input BamFiles -----------------------------------------

  # Raw bamfiles: GALvX_Histone, GALvX_Input
  bamFilesRaw:
    type: 
    - type: array
      items: File
    secondaryFiles:
      - "^.bai"

  # Raw bamfiles: GALvX_Histone
  bamFilesRaw_Histone:
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


#----------- Step specific parameters ------------------------------

#----------- Step: generateSignalCovTrack --------------------------

  normalize:
    type: int

  outName_generateSignalCovTrack:
    type:
    - type: array
      items: string


#---------- Step: computeGCBias ------------------------------------

  genomeSize:
    type: int

  genome:
    type: File

  fragmentLength:
    type: int
  
  gcFreqFile:
    type:
    - type: array
      items: string

  biasPlot:
    type: string

#---------- Step: generateLog2FoldChangeTracks ---------------------

  scaleFactorsMeth:
    type:
    - "null"
    - type: enum
      symbols: ['readCount', 'SES']

  outName_generateLog2FoldChangeTracks:
    type:
    - type: array
      items: string


#---------- Step: computeFingerprintOnRawBam -----------------------

  outName_computeFingerprintOnRawBam_plotFile:
    type: string

  plotLabels:
    type:
    - "null"
    - type: array
      items: string

  plotTitle:
    type: string

  outName_computeFingerprintOnRawBam_QualityMetrics:
    type: string

  outName_computeFingerprintOnRawBam_RawCounts:
    type: string



outputs: []

  #TODO


steps:
  
  generateSignalCovTrack:
    run: ../tools/deepTools-tool-bamCoverage.cwl
    scatter: [bam, outFileName]
    scatterMethod: dotproduct   
    in:
      numberOfProcessors: deeptoolsParallel
      binSize: 
        valueFrom: $( 25)
      bam: bamFilesRaw
      outFileName: outName_generateSignalCovTrack
      outFileFormat: 
        valueFrom: bigwig
      normalizeTo1x: normalize
    out:
      - outputFile


  computeGCBias:
    run: ../tools/deepTools-tool-computeGCBias.cwl
    scatter: [bamfile, GCbiasFrequenciesFile]
    scatterMethod: dotproduct
    in:
      numberOfProcessors: deeptoolsParallel
      bamfile: bamFilesRaw
      effectiveGenomeSize: genomeSize
      genome: genome
      sampleSize:
        valueFrom: $( 50000000.0 )
      fragmentLength: fragmentLength
      GCbiasFrequenciesFile: gcFreqFile
      biasPlot: biasPlot
      plotFileFormat:
        valueFrom: $( svg )
    out:
      - outputFile


  generateLog2FoldChangeTracks:
    run: ../tools/deepTools-tool-bamCompare.cwl
    scatter: [bamfile1, outFileName]
    scatterMethod: dotproduct
    in:
      bamfile1: bamFilesRaw_Histone
      bamfile2: bamFilesRaw_Input
      outFileName: outName_generateLog2FoldChangeTracks
      outFileFormat:
        valueFrom: bigwig
      scaleFactorsMethod: scaleFactorsMeth
      ratio:
        valueFrom: log2
      binSize:
        valueFrom: $( 25 )
    out:
      - outputFile


  computeFingerprintOnRawBam:
    run: ../tools/deepTools-tool-plotFingerprint.cwl
    in: 
      numberOfProcessors: deeptoolsParallel 
      bamfiles: bamFilesRaw 
      plotFile: outName_computeFingerprintOnRawBam_plotFile
      labels: plotLabels
      plotTitle: plotTitle 
      numberOfSamples: 
        valueFrom: $( 500000 )
      plotFileFormat:
        valueFrom: svg
      outQualityMetrics: outName_computeFingerprintOnRawBam_QualityMetrics
      JSDsample: bamFilesRaw_Input
      outRawCounts: outName_computeFingerprintOnRawBam_RawCounts 
    out:
      - outputFile

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl

