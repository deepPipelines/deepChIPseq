#!/usr/bin/env cwl-runner

class: CommandLineTool

id: "samtools_view"
label: "samtools view"

cwlVersion: "v1.0"

doc: |
    A Docker container containing samtools index. See the [htslib](http://www.htslib.org/) webpage for more information.

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0001-6231-4417
    s:email: mailto:karl.nordstroem@uni-saarland.de
    s:name: Karl Nordström


requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: ResourceRequirement
    coresMin: 1
    ramMin: 4092
    outdirMin: 512000
  - class: DockerRequirement
    dockerPull: "quay.io/biocontainers/samtools:1.3.1--5"

baseCommand: ["samtools", "view"]

stdout: $( inputs.outputFileName )

outputs:

  bamFile:
    type: stdout

  complementBamFile:
    type: File?
    outputBinding:
      glob: $( inputs.complementBamFilename)

inputs:

  input:
    type: File
    inputBinding:
      position: 10

  outputFileName:
    type: string
    inputBinding:
      position: 5
    doc: |
      output file name
  
  region:
    type: string?
    inputBinding:
      position: 15
    doc: |
      limit the extraction to this region

  outBam:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -b
    doc: |
      output BAM

  outCram:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -C
    doc: |
      output CRAM (requires -T)

  useFastCompression:
    type: boolean?
    inputBinding:
      position: 5
      prefix: "-1"
    doc: |
      use fast BAM compression (implies -b)

  useNoCompression:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -u
    doc: |
      uncompressed BAM output (implies -b)

  includeHeader:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -h
    doc: |
      include header in SAM output

  printOnlyHeader:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -H
    doc: |
      print SAM header only (no alignments)

  printCountMatchingLines:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -c
    doc: |
      print only the count of matching records

  complementBamFilename:
    type: string?
    inputBinding:
      position: 5
      prefix: -U
    doc: |
      output reads not selected by filters to FILE [null]

  chromSizeFile:
    type: File?
    inputBinding:
      position: 5
      prefix: -t
    doc: |
      FILE listing reference names and lengths (see long help) [null]

  overlapBedFile:
    type: File?
    inputBinding:
      position: 5
      prefix: -L
    doc: |
      only include reads overlapping this BED FILE [null]

  selectReadGroup:
    type: string?
    inputBinding:
      position: 5
      prefix: -r
    doc: |
      only include reads in read group STR [null]

  selectReadGroups:
    type: File?
    inputBinding:
      position: 5
      prefix: -R
    doc: |
      only include reads with read group listed in FILE [null]

  qualityCutoff:
    type: int?
    inputBinding:
      position: 5
      prefix: -q
    doc: |
      only include reads with mapping quality >= INT [0]

  selectLibrary:
    type: string?
    inputBinding:
      position: 5
      prefix: -l
    doc : |
      only include reads in library STR [null]

  minimumCIGARoperations:
    type: int?
    inputBinding:
      position: 5
      prefix: -m
    doc: |
      only include reads with number of CIGAR operations consuming
      query sequence >= INT [0]
  
  selectFLAGall:
    type: int?
    inputBinding:
      position: 5
      prefix: -f
    doc: |
      only include reads with all bits set in INT set in FLAG [0]

  selectFLAGnone:
    type: int?
    inputBinding:
      position: 5
      prefix: -F
    doc: |
      only include reads with none of the bits set in INT set in FLAG [0]

  stripTag:
    type: 
      - "null"
      - type: array
        items: string
        inputBinding:
          prefix: -x
    inputBinding:
      position: 5
    doc: |
      read tag to strip (repeatable) [null]

  collapseBackwardCIGAR:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -B
    doc: |
      collapse the backward CIGAR operation

  randomSeed:
    type: float?
    inputBinding:
      position: 5
      prefix: -s
    doc: |
      integer part sets seed of random number generator [0];
      rest sets fraction of templates to subsample [no subsampling]

  numberOfThreads:
    type: int?
    inputBinding:
      position: 5
      prefix: --threads
    doc: |
      number of BAM/CRAM compression threads [0]

  outputFormat:
    type:
      - "null"
      - type: enum
        symbols: [SAM, BAM, CRAM]
    inputBinding:
      position: 5
      prefix: --output-fmt
    doc: |
      Specify output format (SAM, BAM, CRAM)

  referenceFasta:
    type: File?
    inputBinding:
      position: 5
      prefix: --reference
    doc: |
      Reference sequence FASTA FILE [null]


doc: |
  Usage: samtools view [options] <in.bam>|<in.sam>|<in.cram> [region ...]
  
  Options:
    -b       output BAM
    -C       output CRAM (requires -T)
    -1       use fast BAM compression (implies -b)
    -u       uncompressed BAM output (implies -b)
    -h       include header in SAM output
    -H       print SAM header only (no alignments)
    -c       print only the count of matching records
    -o FILE  output file name [stdout]
    -U FILE  output reads not selected by filters to FILE [null]
    -t FILE  FILE listing reference names and lengths (see long help) [null]
    -L FILE  only include reads overlapping this BED FILE [null]
    -r STR   only include reads in read group STR [null]
    -R FILE  only include reads with read group listed in FILE [null]
    -q INT   only include reads with mapping quality >= INT [0]
    -l STR   only include reads in library STR [null]
    -m INT   only include reads with number of CIGAR operations consuming
             query sequence >= INT [0]
    -f INT   only include reads with all bits set in INT set in FLAG [0]
    -F INT   only include reads with none of the bits set in INT set in FLAG [0]
    -x STR   read tag to strip (repeatable) [null]
    -B       collapse the backward CIGAR operation
    -s FLOAT integer part sets seed of random number generator [0];
             rest sets fraction of templates to subsample [no subsampling]
    -@, --threads INT
             number of BAM/CRAM compression threads [0]
    -?       print long help, including note about region specification
    -S       ignored (input format is auto-detected)
        --input-fmt-option OPT[=VAL]
                 Specify a single input file format option in the form
                 of OPTION or OPTION=VALUE
    -O, --output-fmt FORMAT[,OPT[=VAL]]...
                 Specify output format (SAM, BAM, CRAM)
        --output-fmt-option OPT[=VAL]
                 Specify a single output file format option in the form
                 of OPTION or OPTION=VALUE
    -T, --reference FILE
                 Reference sequence FASTA FILE [null]

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
