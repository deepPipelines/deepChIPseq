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

  deeptoolsParallel:
    type: int

  bamFilesRaw:
    type: 
      - type: array
        items: File
 
  outName_generateSignalCovTrack:
    type:
      - type: array
        items: string

  normalize:
    type: int

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

  bamFilesRaw_Histone:
    type:
      - type: array
        items: File

  bamFile2:
    type: File

  outName_generateLog2FoldChangeTracks:
    type:
      - type: array
        items: string

  scaleFactorsMeth:
    type:
      - "null"
      - type: enum
        symbols: ['readCount', 'SES']


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
      bamfile2: bamFile2
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



$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl

