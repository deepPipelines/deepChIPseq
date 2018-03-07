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

  #is a complementBamFile needed here? 

inputs:

  input:
    type: File
    inputBinding:
      position: 10
      #where does the position come from?

  outputFileName:
    type: string
    inputBinding: 
      position: 5
    doc: |
      output file name

   



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
