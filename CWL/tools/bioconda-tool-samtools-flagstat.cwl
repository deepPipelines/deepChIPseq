#!/usr/bin/env cwl-runner

class: CommandLineTool

id: "samtools_flagstat"
label: "samtools flagstat"

cwlVersion: "v1.0"

doc: |
    A Docker container containing samtools flagstat. See the [htslib](http://www.htslib.org/) webpage for more information.

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

baseCommand: ["samtools", "flagstat"]

stdout: $( inputs.outputName )

outputs:
  flagstat:
    type: stdout

inputs:

  input:
    type: File
    inputBinding:
      position: 10
      
  outputName:
    type: string

  inputFmtOption:
    type: string?
    inputBinding:
      position: 5
      prefix: "--input-fmt-option"
    doc: |
      "--input-fmt-option OPT=VAL"


$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
