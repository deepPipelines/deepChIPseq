#!/usr/bin/env cwl-runner
# This tool description was generated automatically by argparse2tool ver. 0.4.3-2
# To generate again: $ multiBamSummary --generate_cwl_tool
# Help: $ multiBamSummary --help_arg2cwl

cwlVersion: "v1.0"

id: "multiBamSummary"
label: "multiBamSummary"

class: CommandLineTool
baseCommand: ['multiBamSummary']

doc: |
  None

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-5283-7633
    s:email: mailto:heleneluessem@gmail.com
    s:name: Helene Luessem

requirements:
- class: InlineJavascriptRequirement


stdout: $( inputs.outFileName )

outputs:

  outputFile:
    type: stdout

#  outFileName_out:
#    type: File

    doc: File name to save the coverage matrix. This matrix can be subsequently plotted using plotCorrelation or or plotPCA.
#    outputBinding:
#      glob: $(inputs.outFileName.path)


#  outRawCounts_out:
#    type: File

#    doc: Save the counts per region to a tab-delimited file.
#    outputBinding:
#      glob: $(inputs.outRawCounts.path)


inputs:
  
  bamfiles:
    type:
    -  type: array
       items: string
#    items: string

    doc: List of indexed bam files separated by spaces.
    inputBinding:
      prefix: -b 

  outFileName:
    type: string
#    type: File

    doc: File name to save the coverage matrix. This matrix can be subsequently plotted using plotCorrelation or or plotPCA.
    inputBinding:
      prefix: -out 

  labels:
    type:
    -  "null"
    -  type: array
       items: string

    doc: User defined labels instead of default labels from file names. Multiple labels have to be separated by a space, e.g. --labels sample1 sample2 sample3
    inputBinding:
      prefix: -l 

  binSize:
    type: ["null", int]
    default: 10000
    doc: ==SUPPRESS==
    inputBinding:
      prefix: -bs 

  distanceBetweenBins:
    type: ["null", int]
    default: 0
    doc: ==SUPPRESS==
    inputBinding:
      prefix: -n 

  BED:
    type: File

    doc: Limits the coverage analysis to the regions specified in this file.
    inputBinding:
      prefix: --BED 

  outRawCounts:
    type: ["null", File]
    doc: Save the counts per region to a tab-delimited file.
    inputBinding:
      prefix: --outRawCounts 

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
