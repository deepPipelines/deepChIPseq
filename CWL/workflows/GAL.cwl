#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
 - class: StepInputExpressionRequirement
 - class: InlineJavascriptRequirement
 - class: MultipleInputFeatureRequirement

inputs:
  fq1file: File
  fq2file: File
  reference_genome: File
  outputName: string
  prefix: string
  
outputs:
  AlignmentSummarymetrics:
    type: File
    outputSource: picardCollectMultipleMetrics/AlignmentSummarymetrics

  InsertSizemetrics:
    type: File
    outputSource: picardCollectMultipleMetrics/InsertSizemetrics 

  QualityByCyclemetrics:
    type: File
    outputSource: picardCollectMultipleMetrics/QualityByCyclemetrics

  QualityDistributionmetrics:
    type: File
    outputSource: picardCollectMultipleMetrics/QualityDistributionmetrics

  QualityByCyclemetricsTwo:
    type: File
    outputSource: picardCollectMultipleMetrics/QualityByCyclemetricsTwo

  QualityDistributionmetricsTwo:
    type: File
    outputSource: picardCollectMultipleMetrics/QualityDistributionmetricsTwo

steps:
  bwaAln1:
    run: ../tools/bioconda-tool-bwa-aln.yml
    in:
      input: fq1file
      outputName:
        valueFrom:  $( outputName + "_R1_Aln" )
      prefix: prefix
      threads: 
        valueFrom: $( 12 )
      minQual:
        valueFrom: $( 20 )
    out:
      [alnFile]

  bwaAln2:
    run: ../tools/bioconda-tool-bwa-aln.yml
    in: 
      input: fq2file
      outputName: 
        valueFrom: $( outputName + "_R2_Aln" )
      prefix: prefix
      threads:
        valueFrom: $( 12 )
      minQual:
        valueFrom: $( 20 )
    out: 
       [alnFile]

  bwaSampe:
    run: ../tools/bioconda-tool-bwa-sampe.yml
    in:
      aln1: bwaAln1/alnFile
      aln2: bwaAln2/alnFile
      fq1: fq1file 
      fq2: fq2file 
      prefix: prefix
      outputName: outputName
      preloadIndex: 
        valueFrom: $( 1==1 )
      maximumInsertSize: 
        valueFrom: $( 1000 )
      readGroupHeaderLine:
        valueFrom: readgroupinformation
      src: [bwaAln1/alnFile, bwaAln2/alnFile] 
    out:
      [sampeFile]

  samtoolsView:
    run: ../tools/bioconda-tool-samtools-view.cwl
    in:
      input: bwaSampe/sampeFile
      outputFileName: 
        valueFrom: $( inputs.outputName + ".bam")
      useNoCompression: 
         valueFrom: $( 1==1 )
      outBam:
         valueFrom: $( 1==1 )
      includeHeader: 
         valueFrom: $( 1==1 )
      inputFormat: 
         valueFrom: $( 1==1 ) 
      src: bwaSampe/sampeFile
    out:
      [bamFile]

  samtoolsSort:
    run: ../tools/bioconda-tool-samtools-sort.cwl
    in:
      input: samtoolsView/bamFile
      outputPrefix: prefix
      src: samtoolsView/bamFile
    out: [bamFile]

  picardMarkDuplicates:
    run: ../tools/bioconda-tool-picard-MarkDuplicates.cwl
    in:
      INPUT: samtoolsSort/bamFile
      OUTPUT: 
        valueFrom: $( outputName + ".bam")
      METRICS_FILE:
        valueFrom: $( outputName + ".PicardMarkDupmetrics.txt" )
      VALIDATION_STRINGENCY:
        valueFrom: $( SILENT )
      REMOVE_DUPLICATES: 
        valueFrom: $( 1==0 )
      ASSUME_SORTED: 
        valueFrom: $( 1==1 )
      CREATE_INDEX:
        valueFrom: $( 1==1)
      MAX_RECORDS_IN_RAM:
        valueFrom: $( 12500000 )
      src: samtoolsSort/bamFile
    out: [METRICS_FILE_output, OUTPUT_output]

  samtoolsFlagstat:
    run: ../tools/bioconda-tool-samtools-flagstat.cwl
    in: 
      input: picardMarkDuplicates/OUTPUT_output
      outputName: 
        valueFrom: $( outputName + ".flagstat.txt")
      src: [picardMarkDuplicates/METRICS_FILE_output, picardMarkDuplicates/OUTPUT_output]
    out: 
      - flagstat

  picardCollectMultipleMetrics: 
    run: ../tools/bioconda-tool-picard-collectMultipleMetrics.cwl
    in:
      INPUT: picardMarkDuplicates/OUTPUT_output
      OUTPUT:
        valueFrom: $( outputName + ".collectMultipleMetrics.txt")
      REFERNCE_SEQUENCE: 
        valueFrom: $( reference_genome )
      ASSUME_SORTED: 
        valueFrom: $( 1==1 )
      VALIDATION_STRINGENCY:
        valueFrom: $( SILENT )
      PROGRAM: 
        valueFrom: $( [CollectAlignmentSummaryMetrics, CollectInsertSizeMetrics, QualityScoreDistribution, MeanQualityByCycle] )
      src: [picardMarkDuplicates/METRICS_FILE_output, picardMarkDuplicates/OUTPUT_output]
    out: [AlignmentSummarymetrics, InsertSizemetrics, QualityByCyclemetrics, QualityDistributionmetrics, QualityByCyclemetricsTwo, QualityDistributionmetricsTwo]
