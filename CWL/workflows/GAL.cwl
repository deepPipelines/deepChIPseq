#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

inputs:
  inputSampleIDR1: File
  ex: string
  inputSampleIDR2: File
  ex: string
  inputReferenceGenome: File
  ex: string

outputs:
  alignmentSummarymetrics:
    type: File
    outputSource: PicardCollectMultipleMetrics/alignmentSummarymetrics

  insertSizemetrics:
    type: File
    outputSource: PicardCollectMultipleMetrics/insertSizeMetrics

  qualityByCyclemetrics:
    type: File
    outputSource: PicardCollectMultipleMetrics/qualityByCyclemetrics

  qualityByDistributionmetrics:
    type: File
    outputSource: PicardCollectMultipleMetrics/qualityDistributionmetrics

  qualityByCyclemetricsTwo:
    type: File
    outputSource: PicardCollectMultipleMetrics/qualityByCyclemetricsTwo

  qualityByDistributionmetricsTwo:
    type: File
    outputSource: PicardCollectMultipleMetrics/qualityDistributionmetrics

steps:
  bwaAln:
    run: bioconda-tool-bwa-aln.yml
    in:
      fastqfile: inputSampleIDR1
      fastqfile: inputSampleIDR2
      fastafile: inputReferenceGenome
    out:
      [saiFileReadOne]
     # [saiFileReadTwo]

  bwaSampe:
    run: bioconda-tool-bwa-sampe.yml
    in:
      src: bwaAln/saiFileReadOne
           bwaAln/saiFileReadTwo
    out:
      [samFile]

  samtoolsView:
    run: bioconda-tool-samtools-view.cwl
    in:
      src: bwaSampe/samFile
    out:
      [bamFile]

  samtoolsSort:
    run: bioconda-tool-samtools-sort.cwl
    in:
      src: samtoolsView/bamFile
    out: [bamFileSortedByCoordinates]

  picardMarkDuplicates:
    run: bioconda-tool-picard-MarkDuplicates.cwl
    in: 
      src: samtoolSort/bamFileSortedByCoordinates
    out: [bamFileWithDuplicates]

  samtoolsFlagstat:
    run: bioconda-tool-samtools-flagstat.cwl
    in: 
      src: picardMarkDuplicates/bamFileWithDuplicates
    out: []
    #output is here to stdout, is this correct then?

  picardCollectMultipleMetrics: 
    run: bioconda-tool-picard-collectMultipleMetrics.cwl
    in: 
      src: picardMarkDuplicates/bamFileWithDuplicates
    out: [alignmentSummarymetrics]
        # [insertSizemetrics]
        # [qualityByCyclemetrics]
        # [qualityDistributionmetrics]
        # [qualityByCyclemetricsTwo]
        # [qualityDistributionmetricsTwo]
