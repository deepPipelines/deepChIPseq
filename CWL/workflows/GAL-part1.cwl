#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
 - class: StepInputExpressionRequirement
 - class: InlineJavascriptRequirement
 - class: MultipleInputFeatureRequirement
 - class: SubworkflowFeatureRequirement

inputs:
  fq1file: File
  fq2file: File
  reference_genome: File
  outputName: string
  prefix: string
  
outputs:

  samtoolsSortBamFile:
    type: File
    outputSource: samtoolsSort/bamFile

steps:
  bwaAln1:
    run: ../tools/bioconda-tool-bwa-aln.yml
    in:
      input: fq1file
      name: outputName
      outputName:
        valueFrom:  $( inputs.name + "_R1_Aln" )
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
      name: outputName
      outputName: 
        valueFrom: $( inputs.name + "_R2_Aln" )
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
        valueFrom: $( '@RG\tID:foo\tSM:bar' )
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
      name: outputName
      outputPrefix: 
        valueFrom: $( inputs.name + "_sort" )
      src: samtoolsView/bamFile
    out: [bamFile]
