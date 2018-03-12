#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

inputs:
  inputSampleID_R1: File
  inputSampleID_R2: File
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
      input: inputSampleID_R1
      outputName: outputName
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
      input: inputSampleID_R2
      outputName: outputName
      prefix: prefix
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
      src: [bwaAln1/alnFile, bwaAln2/alnFile] 
    out:
      [sampeFile]

  samtoolsView:
    run: ../tools/bioconda-tool-samtools-view.cwl
    in:
      input: bwaSampe/sampeFile
      outputFileName: 
        valueFrom: $( outputName + ".bam") 
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
        valueFrom: $( outputName + ".markDuplicates.txt" )
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
      src: [picardMarkDuplicates/METRICS_FILE_output, picardMarkDuplicates/OUTPUT_output]
    out: [AlignmentSummarymetrics, InsertSizemetrics, QualityByCyclemetrics, QualityDistributionmetrics, QualityByCyclemetricsTwo, QualityDistributionmetricsTwo]