#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
 - class: StepInputExpressionRequirement
 - class: InlineJavascriptRequirement
 - class: MultipleInputFeatureRequirement
 - class: SubworkflowFeatureRequirement
 - class: ScatterFeatureRequirement

inputs:
  fq1file: File[]
  fq2file: File[]
  reference_genome: File
  outputName: string
  prefix: File
  #secondaryFiles:
 #  - ".amb"
 #  - ".ann"
 #  - ".bwt"
 #  - ".pac"
 #  - ".sa"

outputs:
  logFiles:
    type: File[]
    outputSource: picardCollectMultipleMetrics/summaryFiles

  markDuplicatesBamFile:
    type: File
    outputSource: picardMarkDuplicates/OUTPUT_output

steps:
  GAL-part1:
    run: GAL-part1.cwl
    scatter:
     - fq1file
     - fq2file
    scatterMethod: dotproduct
    in:
      fq1file: fq1file
      fq2file: fq2file
      reference_genome: reference_genome
      outputName: outputName
      prefix: prefix
    out:
      - samtoolsSortBamFile
 
  picardMarkDuplicates:
    run: ../tools/bioconda-tool-picard-MarkDuplicates.cwl
    in:
      INPUT: GAL-part1/samtoolsSortBamFile
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
      src: 
        - GAL-part1/samtoolsSortBamFile
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
