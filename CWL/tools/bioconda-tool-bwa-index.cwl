#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: "v1.0"

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0001-6231-4417
    s:email: mailto:karl.nordstroem@uni-saarland.de
    s:name: Karl Nordström

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing: input

hints:
  - class: ResourceRequirement
    coresMin: 1
    ramMin: 4092
    outdirMin: 512000
  - class: DockerRequirement
    dockerPull: "quay.io/biocontainers/bwa:0.6.2--1"

inputs:

  input:
    type: File
    inputBinding:
      position: 3

  algorithm:
    type: string?
    doc: |
      BWT construction algorithm: bwtsw or is (Default: auto)
    inputBinding:
      position: 2
      prefix: "-a"

  outPrefix:
    type: string?
    doc: |
      Prefix of the index (Default: same as fasta name)
    inputBinding:
      position: 2
      prefix: "-p"

  blockSize:
    type: int?
    doc: |
      Block size for the bwtsw algorithm (effective with -a bwtsw) (Default: 10000000)
    inputBinding:
      position: 2
      prefix: "-b"

  altSuffix:
    type: boolean?
    doc: |
      Index files named as <in.fasta>.64.* instead of <in.fasta>.*
    inputBinding:
      position: 2
      prefix: "-6"

outputs:
 # - id: output
#  index:
#    type: File
#    outputBinding:
#      glob: $( inputs.input )
#    secondaryFiles: 
#      - ".amb"
#      - ".ann"
#      - ".bwt"
#      - ".pac"
#      - ".sa"
  #  type: { type: array, items: File }
  #  outputBinding:
  #    glob:
  #        - ${
  #            if (inputs.p) {
  #              return inputs.p + ".amb"
  #            } else {
  #              if (inputs._6 == true) {
  #                return inputs.input.path + ".64.amb"
  #              } else {
  #                return inputs.input.path + ".amb"
  #              }
  #            }
  #          }
  #        - ${
  #            if (inputs.p) {
  #              return inputs.p + ".ann"
  #            } else {
  #              if (inputs._6 == true) {
  #                return inputs.input.path + ".64.ann"
  #              } else {
  #                return inputs.input.path + ".ann"
  #              }
  #            }
  #          }
  #        - ${
  #            if (inputs.p) {
  #              return inputs.p + ".bwt"
  #            } else {
  #              if (inputs._6 == true) {
  #                return inputs.input.path + ".64.bwt"
  #              } else {
  #                return inputs.input.path + ".bwt"
  #              }
  #            }
  #          }
  #        - ${
  #            if (inputs.p) {
  #              return inputs.p + ".pac"
  #            } else {
  #              if (inputs._6 == true) {
  #                return inputs.input.path + ".64.pac"
  #              } else {
  #                return inputs.input.path + ".pac"
  #              }
  #            }
  #          }
  #        - ${
  #            if (inputs.p) {
  #              return inputs.p + ".sa"
  #            } else {
  #             if (inputs._6 == true) {
  #                return inputs.input.path + ".64.sa"
  #              } else {
  #                return inputs.input.path + ".sa"
  #              }
  #            }
  #          }

baseCommand:
  - bwa
  - index

doc: |
  Usage:   bwa index [options] <in.fasta>

  Options: -a STR    BWT construction algorithm: bwtsw or is [auto]
           -p STR    prefix of the index [same as fasta name]
           -b INT    block size for the bwtsw algorithm (effective with -a bwtsw) [10000000]
           -6        index files named as <in.fasta>.64.* instead of <in.fasta>.*

  Warning: `-a bwtsw' does not work for short genomes, while `-a is' and
           `-a div' do not work not for long genomes.

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
