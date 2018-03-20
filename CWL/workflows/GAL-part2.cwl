#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
- class: StepInputExpressionRequirement
- class: InlineJavascriptRequirement
- class: MultipleInputFeatureRequirement

inputs: 
  bamFile: File
  outputName: string

outputs:
  logFiles: 
    type: File[]
    outputSource: picardCollectMultipleMetrics/summaryFiles

steps:
  picardMarkDuplicates:
    run: ../tools/bioconda-tool-picard-MarkDuplicates.cwl
    in:
      INPUT: bamFile
      name: outputName
      OUTPUT: 
        valueFrom: $( inputs.name + ".bam" )
      METRICS_FILE:
        valueFrom: $( inputs.name + ".PicardMarkDupmetrics.txt" )
      VALIDATION_STRINGENCY:
        valueFrom: SILENT
      REMOVE_DUPLICATES: 
        valueFrom: $( 1==0 )
      ASSUME_SORTED: 
        valueFrom: $( 1==1 )
      CREATE_INDEX:
        valueFrom: $( 1==1 )
      MAX_RECORDS_IN_RAM:
        valueFrom: $( 12500000 )
      src: bamFile
    out: [METRICS_FILE_output, OUTPUT_output]

  samtoolsFlagstat:
    run: ../tools/bioconda-tool-samtools-flagstat.cwl
    in: 
      input: picardMarkDuplicates/OUTPUT_output
      name: outputName
      outputName: 
        valueFrom: $( inputs.name + ".flagstat.txt")
      src: [picardMarkDuplicates/METRICS_FILE_output, picardMarkDuplicates/OUTPUT_output]
    out: 
      - flagstat

  picardCollectMultipleMetrics: 
    run: ../tools/bioconda-tool-picard-collectMultipleMetrics.cwl
    in:
      INPUT: picardMarkDuplicates/OUTPUT_output
      name: outputName
      OUTPUT:
        valueFrom: $( inputs.name + ".collectMultipleMetrics.txt")
      REFERNCE_SEQUENCE: 
        valueFrom: reference_genome
      ASSUME_SORTED: 
        valueFrom: $( 1==1 )
      VALIDATION_STRINGENCY:
        valueFrom: SILENT
      PROGRAMsToRun:
        valueFrom: $( ["CollectAlignmentSummaryMetrics", "CollectInsertSizeMetrics", "QualityScoreDistribution", "MeanQualityByCycle"] )
      src: [picardMarkDuplicates/METRICS_FILE_output, picardMarkDuplicates/OUTPUT_output]
    out:
      - summaryFiles
