#!/usr/bin/env cwl-runner

class: CommandLineTool

id: "Picard_CollectMultipleMetrics"
label: "Picard CollectMultipleMetrics"

cwlVersion: "v1.0"

doc: |
  A Docker container containing the Picard jar file. See the [Picard](http://broadinstitue.github.io/picard/) webpage for more information

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
    dockerPull: "quay.io/biocontainers/picard:2.17.2--py36_0"

baseCommand: ["picard", "CollectMultipleMetrics"]

outputs:

  summaryFiles:
    type: File[]
    outputBinding:
      glob: $(inputs.OUTPUT + "*")

#  AlignmentSummarymetrics:
#    type: File
#    outputBinding:
#      glob: $(inputs.OUTPUT)

#  InsertSizemetrics:
#    type: File
#    outputBinding: 
#      glob: $(inputs.OUTPUT)

#  QualityByCyclemetrics:
#    type: File
#    outputBinding: 
#      glob: $(inputs.OUTPUT)

#  QualityDistributionmetrics:
#    type: File
#    outputBinding:
#      glob: $(inputs.OUTPUT)

#  QualityByCyclemetricsTwo:
#    type: File
#    outputBinding:
#       glob: $(inputs.OUTPUT)

#  QualityDistributionmetricsTwo:
#    type: File
#    outputBinding:
#       glob: $(inputs.OUTPUT)

inputs:
  
  ASSUME_SORTED:
    inputBinding:
      position: 5
      prefix: "ASSUME_SORTED=true"
      separate: false
    type: boolean?
    doc: |
      if true (default), then the sort order in the header file will be ignored. Default value: true. This option can be set to 'null' to clear the default value. Possible values: [true, false]

  STOP_AFTER:
    inputBinding: 
      position: 5
      prefix: "STOP_AFTER="
      separate: false
    type: int?
    doc: |
      Stop after processing N reads, mainly for debugging. Default value: 0. This option can be set to 'null' to clear the default value.

  METRIC_ACCUMULATION_LEVEL:
    inputBinding: 
      position: 5
      prefix: "METRIC_ACCUMULATION_LEVEL="
      separate: false
    type:
      - 'null'
      - type: enum
        symbols: [ALL_READS, SAMPLE, LIBRARY, READ_GROUP]
    doc: |
      The level(s) at wich to accumulate metrics. Default value: [ALL_READS]. This option can be set to 'null' to clear the default value. Possible values: [ALL_READS, SAMPLE, LIBRARY, READ_GROUP]. This option may be specified 0 or more times. This option can be set to 'null' to clear the default list.

  FILE_EXTENSION:
    inputBinding: 
      position: 5
      prefix: "FILE_EXTENSION="
      separate: false
    type: string?
    doc: |
      Append the given file extension to all metric file names (ex. OUTPUT.insert_size_metrics.EXT). None if null. Default value: null

  PROGRAM:
    inputBinding: 
      position: 10
    type:
     - 'null'
     - type: array
       items: string
       inputBinding:
         prefix: "PROGRAM="
         separate: false
#       items:  
#         type: enum
#         symbols: 
#           - CollectAlignmentSummaryMetrics
#           - CollectInsertSizeMetrics
#           - QualityScoreDistribution
#           - MeanQualityByCycle
#           - CollectBaseDistributionByCycle
#           - CollectGcBiasMetrics
#           - RnaSeqMetrics
#           - CollectSequencingArtifactMetrics
#           - CollectQualityYieldMetrics
    doc: |
      Set of metrics programs to apply during the pass through the SAM file. Default value: [CollectAlignmentSummaryMetrics, CollectSizeMetrics, MeanQualityByCycle, QualityScoreDistribution]. This option can be set to 'null' to clear the default value. Possible values: [CollectAlignmentSummaryMetrics, CollectInsertSizeMetrics, QualityScoreDistribution, MeanQualityByCycle, CollectBaseDistributionByCycle, CollectGcBiasMetrics, RnaSeqMetrics, CollectSequencingArtifactMetrics, CollectQualityYieldMetrics]. This option may be specified 0 or more times. This option can be set to 'null' to clear the default list.
  
  INTERVALS:
    inputBinding: 
      position: 5
      prefix: "INTERVALS="
      separate: false
    type: File?
    doc: |
      An optional list of intervals to restrict analysis to. Only pertains to some of the PROGRAMs. Programs whose stand-alone CLP does not have an INTERVALS argument will silently ignore this argument. Default value: null

  DB_SNP:
    inputBinding: 
      position: 5
      prefix: "DB_SNP="
      separate: false
    type: File?
    doc: |
      VCF format dbSNP file, used to exclude regions around known polymorphisms from analysis by some PROGRAMs; PROGRAMs whose CLP doesn't alllow for this argument will quietly ignore it. Default value: null.

  INCLUDE_UNPAIRED:
    inputBinding: 
      position: 5
      prefix: "INCLUDE_UNPAIRED=true"
      separate: false
    type: boolean?
    doc: |
      Include unpaired reads in CollectSequencingArtifactMetrics. If set to true then all paired reads will be included as well - MINIMUM_INSERT_SIZE and MAXIMUM_INSERT_SIZE will be ignored in CollectSequencingArtifactMetrics. Default value: false. This option can be set to 'null' to clear the default value. Possible values: [true, false]

  INPUT: 
    inputBinding: 
      position: 5
      prefix: "INPUT="
      separate: false
    type: 
      - File
      - type: array
        items:  File
        inputBinding:
          itemSeparator: "INPUT="
    doc: |
      Input SAM or BAM file. Required.
    
  OUTPUT: 
    inputBinding: 
      position: 5
      prefix: "OUTPUT="
      separate: false
    type: string
    doc: |
      Base name of output files. Required.

  TMP_DIR:
    inputBinding:
      position: 5
      prefix: "TMP_DIR="
      separate: false
    type: string?
    doc: |
       One or more directories with space available to be used by this program for temporary storage of working files Default value: null. This option may be specified 0 or more times. 

  VERBOSITY:
    inputBinding:
      position: 5
      prefix: "VERBOSITY="
      separate: false
    type:
      - 'null'
      - type: enum
        symbols: [ERROR, WARNING, INFO, DEBUG]
    doc: |
       Control verbosity of logging. Default value: INFO. This option can be set to 'null' to clear the default value. Possible values: {ERROR, WARNING, INFO, DEBUG} 

  QUIET:
    inputBinding:
      position: 5
      prefix: "QUIET=true"
      separate: false
    type: boolean?
    doc: |
       Whether to suppress job-summary info on System.err. Default value: false. This option can be set to 'null' to clear the default value. Possible values: {true, false} 

  VALIDATION_STRINGENCY:
    inputBinding:
      position: 5
      prefix: "VALIDATION_STRINGENCY="
      separate: false
    type:
      - 'null'
      - type: enum
        symbols: [STRICT, LENIENT, SILENT]
    doc: |
       Validation stringency for all SAM files read by this program. Setting stringency to SILENT can improve performance when processing a BAM file in which variable-length data (read, qualities, tags) do not otherwise need to be decoded. Default value: STRICT. This option can be set to 'null' to clear the default value. Possible values: {STRICT, LENIENT, SILENT} 

  COMPRESSION_LEVEL:
    inputBinding:
      position: 5
      prefix: "COMPRESSION_LEVEL="
      separate: false
    type: int?
    doc: |
       Compression level for all compressed files created (e.g. BAM and VCF). Default value: 5. This option can be set to 'null' to clear the default value. 

  MAX_RECORDS_IN_RAM:
    inputBinding:
      position: 5
      prefix: "MAX_RECORDS_IN_RAM="
      separate: false
    type: int?
    doc: |
       When writing files that need to be sorted, this will specify the number of records stored in RAM before spilling to disk. Increasing this number reduces the number of file handles needed to sort the file, and increases the amount of RAM needed. Default value: 500000. This option can be set to 'null' to clear the default value. 

  CREATE_INDEX:
    inputBinding:
      position: 5
      prefix: "CREATE_INDEX=true"
      separate: false
    type: boolean?
    doc: |
       Whether to create a BAM index when writing a coordinate-sorted BAM file. Default value: false. This option can be set to 'null' to clear the default value. Possible values: {true, false} 

  CREATE_MD5_FILE:
    inputBinding:
      position: 5
      prefix: "CREATE_MD5_FILE=true"
      separate: false
    type: boolean?
    doc: |
       Whether to create an MD5 digest for any BAM or FASTQ files created. Default value: false. This option can be set to 'null' to clear the default value. Possible values: {true, false} 

  REFERENCE_SEQUENCE:
    inputBinding:
      position: 5
      prefix: "REFERENCE_SEQUENCE="
      separate: false
    type: File?
    doc: |
       Reference sequence file. Default value: null. 

  GA4GH_CLIENT_SECRETS:
    inputBinding:
      position: 5
      prefix: "GA4GH_CLIENT_SECRETS="
      separate: false
    type: File?
    doc: |
       Google Genomics API client_secrets.json file path. Default value: client_secrets.json. This option can be set to 'null' to clear the default value. 

  USE_JDK_DEFLATER:
    inputBinding:
      position: 5
      prefix: "USE_JDK_DEFLATER=true"
      separate: false
    type: boolean?
    doc: |
       Use the JDK Inflater instead of the Intel Inflater for reading compressed input Default value: false. This option can be set to 'null' to clear the default value. Possible values: {true, false}

  USE_JDK_INFLATER:
    inputBinding:
      position: 5
      prefix: "USE_JDK_INFLATER=true"
      separate: false
    type: boolean?
    doc: |
       Use the JDK Inflater instead of the Intel Inflater for reading compressed input Default value: false. This option can be set to 'null' to clear the default value. Possible values: {true, false} 

  OPTIONS_FILE:
    inputBinding:
      position: 5
      prefix: "OPTIONS_FILE="
      separate: false
    type: File?
    doc: |
       File of OPTION_NAME=value pairs. No positional parameters allowed. Unlike command-line options, unrecognized options are ignored. A single-valued option set in an options file may be overridden by a subsequent command-line option. A line starting with '#' is considered a comment. Required. 

$namespaces: 
  s: https://schema.org/
  edam: http://edamontology.org/

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
