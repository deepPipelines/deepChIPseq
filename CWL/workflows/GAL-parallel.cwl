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
  bamFile: File

outputs:
  logFiles:
    type: File[]
    outputSource: GAL-part2/logFiles

steps:
  GAL-part1:
    run: GAL-part1.cwl
    in:
      fq1file: fq1file
      fq2file: fq2file
      reference_genome: reference_genome
      outputName: outputName
      prefix: prefix
    out: [samtoolsViewBamFile]

  GAL-part2:
    requirements:
     - class: InitialWorkDirRequirement
       listing:
        - entryname: inputs.outputName + "_sort"
          entry: |
            "Hallo Welt!"
    run: GAL-part2.cwl
    in:
      outputName: outputName
      bamFile: GAL-part1/samtoolsViewBamFile
    out: [logFiles]
