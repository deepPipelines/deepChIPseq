#!usr/bin/env cwl-runner

class: CommandLineTool

id: "samtools_sort"
label: "samtools sort"

cwlVersion: "v1.0"

doc: |
  Sorts alignments by leftmost coordinates or by read name. Additionally, a sort order header tag will be added or an existing one updated if necessary.

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-7816-2363
    s:email: mailto:wiebkeschmitt@outlook.de
    s:name: Wiebke Schmitt

requirements:
  - class: InlineJavascriptRequirement

hints:
  - class: ResourceRequirement
    coresMin: 1
    ramMin: 4092
    outdirMin: 512000
  - class: DockerRequirement
    dockerPull: "quay.io/biocontainers/samtools:1.3.1--5"

baseCommand: ["samtools", "sort"]

stdout: $( inputs.outputFileName )

outputs: 

  bamFile:
    type: stdout

inputs:

  input:
    type: File
    inputBinding:
      position: 10

  outputFileName:
    type: string
    inputBinding: 
      position: 15
    doc: |
      output file name

  sortByReadName:
    type: boolean? 
    inputBinding: 
      position: 5
      prefix: -n
    doc: |
      sort by name rather than by chromosomal coordinates

  useOutPrefixInsteadOfPrefix:
    type: boolean?
    inputBinding: 
      position: 5
      prefix: -f
    doc: |
      use <out.prefix> as full file name instead of prefix

  OutputToStdOut: 
    type: boolean?
    inputBinding: 
      position: 5
      prefix: -o
    doc: |
      put final output to stdout

  compressionLevel:
    type: int?
    inputBinding:
      position: 5
      prefix: -l
    doc: |
      compression level, from 0 to 9 [-1]

  numberOfThreads:
    type: int?
    inputBinding:
      position: 5
      prefix: --threads
    doc: |
      number of BAM compression threads to use in addition to main thread [0].

  maxMemoryPerThread:
     type: string?
     inputBinding:
       position: 5
       prefix: -m
     doc: |
       Approximately the maximum required memory per thread, specified either in bytes or with a K, M or G suffix [768 MiB]

doc: |
  Usage: samtools sort [options] <in.bam> <out.prefix>

  Options:
    -n        Sort by read name
    -f        use <out.prefix> as full file name instead of prefix
    -o        final output to stdout
    -l INT    compression level, from 0 to 9 [-1]
    -@ INT    number of sorting and compression threads [1]
    -m INT    max memory per thread; suffix K/M/G recognized
 
$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - https://edamontology.org/EDAM_1.18.owl
