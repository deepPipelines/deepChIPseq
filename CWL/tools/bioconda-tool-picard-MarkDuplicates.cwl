#!/usr/bin/env cwl-runner

class: CommandLineTool

id: "Picard_MarkDuplicates"
label: "Picard MarkDuplicates"

cwlVersion: "v1.0"

doc: |
    ![build_status](https://quay.io/repository/karl616/dockstore-tool-picard/status)
    A Docker container containing the Picard jar file. See the [Picard](http://broadinstitute.github.io/picard/) webpage for more information.

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
    dockerPull: "quay.io/biocontainers/picard:2.17.2--py36_0"

baseCommand: ["picard", "MarkDuplicates"]

outputs:

  OUTPUT_output:
    type: File
    outputBinding:
      glob: $( inputs.OUTPUT )

  METRICS_FILE_output:
    type: File
    outputBinding:
      glob: $( inputs.METRICS_FILE )

inputs:

  MAX_SEQUENCES_FOR_DISK_READ_ENDS_MAP:
    inputBinding:
      position: 5
      prefix: "MAX_SEQUENCES_FOR_DISK_READ_ENDS_MAP="
      separate: false
    type: int?
    doc: |
       This option is obsolete. ReadEnds will always be spilled to disk. Default value: 50000. This option can be set to 'null' to clear the default value. 

  MAX_FILE_HANDLES_FOR_READ_ENDS_MAP:
    inputBinding:
      position: 5
      prefix: "MAX_FILE_HANDLES_FOR_READ_ENDS_MAP="
      separate: false
    type: int?
    doc: |
       Maximum number of file handles to keep open when spilling read ends to disk. Set this number a little lower than the per-process maximum number of file that may be open. This number can be found by executing the 'ulimit -n' command on a Unix system. Default value: 8000. This option can be set to 'null' to clear the default value. 

  SORTING_COLLECTION_SIZE_RATIO:
    inputBinding:
      position: 5
      prefix: "SORTING_COLLECTION_SIZE_RATIO="
      separate: false
    type: double?
    doc: |
       This number, plus the maximum RAM available to the JVM, determine the memory footprint used by some of the sorting collections. If you are running out of memory, try reducing this number. Default value: 0.25. This option can be set to 'null' to clear the default value. 

  BARCODE_TAG:
    inputBinding:
      position: 5
      prefix: "BARCODE_TAG="
      separate: false
    type: string?
    doc: |
       Barcode SAM tag (ex. BC for 10X Genomics) Default value: null. 

  READ_ONE_BARCODE_TAG:
    inputBinding:
      position: 5
      prefix: "READ_ONE_BARCODE_TAG="
      separate: false
    type: string?
    doc: |
       Read one barcode SAM tag (ex. BX for 10X Genomics) Default value: null. 

  READ_TWO_BARCODE_TAG:
    inputBinding:
      position: 5
      prefix: "READ_TWO_BARCODE_TAG="
      separate: false
    type: string?
    doc: |
       Read two barcode SAM tag (ex. BX for 10X Genomics) Default value: null. 

  TAG_DUPLICATE_SET_MEMBERS:
    inputBinding:
      position: 5
      prefix: "TAG_DUPLICATE_SET_MEMBERS=true"
      separate: false
    type: boolean?
    doc: |
       If a read appears in a duplicate set, add two tags. The first tag, DUPLICATE_SET_SIZE_TAG (DS), indicates the size of the duplicate set. The smallest possible DS value is 2 which occurs when two reads map to the same portion of the reference only one of which is marked as duplicate. The second tag, DUPLICATE_SET_INDEX_TAG (DI), represents a unique identifier for the duplicate set to which the record belongs. This identifier is the index-in-file of the representative read that was selected out of the duplicate set. Default value: false. This option can be set to 'null' to clear the default value. Possible values: {true, false} 

  REMOVE_SEQUENCING_DUPLICATES:
    inputBinding:
      position: 5
      prefix: "REMOVE_SEQUENCING_DUPLICATES=true"
      separate: false
    type: boolean?
    doc: |
       If true remove 'optical' duplicates and other duplicates that appear to have arisen from the sequencing process instead of the library preparation process, even if REMOVE_DUPLICATES is false. If REMOVE_DUPLICATES is true, all duplicates are removed and this option is ignored. Default value: false. This option can be set to 'null' to clear the default value. Possible values: {true, false} 

  TAGGING_POLICY:
    inputBinding:
      position: 5
      prefix: "TAGGING_POLICY="
      separate: false
    type:
      - "null"
      - type: enum
        symbols: [DontTag, OpticalOnly, All]
    doc: |
       Determines how duplicate types are recorded in the DT optional attribute. Default value: DontTag. This option can be set to 'null' to clear the default value. Possible values: {DontTag, OpticalOnly, All} 

  CLEAR_DT:
    inputBinding:
      position: 5
      prefix: "CLEAR_DT=false"
      separate: false
    type: boolean?
    doc: |
       Clear DT tag from input SAM records. Should be set to false if input SAM doesn't have this tag. Default true Default value: true. This option can be set to 'null' to clear the default value. Possible values: {true, false} 

  ADD_PG_TAG_TO_READS:
    inputBinding:
      position: 5
      prefix: "ADD_PG_TAG_TO_READS=false"
      separate: false
    type: boolean?
    doc: |
       Add PG tag to each read in a SAM or BAM Default value: true. This option can be set to 'null' to clear the default value. Possible values: {true, false} 

  INPUT:
    inputBinding:
      position: 5
      prefix: "INPUT="
      separate: false
    type:
      - File
      - type: array
        items: File
        inputBinding:
          itemSeparator: " INPUT="
    doc: |
       One or more input SAM or BAM files to analyze. Must be coordinate sorted. Default value: null. This option may be specified 0 or more times. 

  OUTPUT:
    inputBinding:
      position: 5
      prefix: "OUTPUT="
      separate: false
    type: string
    doc: |
       The output file to write marked records to Required. 

  METRICS_FILE:
    inputBinding:
      position: 5
      prefix: "METRICS_FILE="
      separate: false
    type: string
    doc: |
       File to write duplication metrics to Required. 

  REMOVE_DUPLICATES:
    inputBinding:
      position: 5
      prefix: "REMOVE_DUPLICATES=true"
      separate: false
    type: boolean?
    doc: |
       If true do not write duplicates to the output file instead of writing them with appropriate flags set. Default value: false. This option can be set to 'null' to clear the default value. Possible values: {true, false} 

  ASSUME_SORTED:
    inputBinding:
      position: 5
      prefix: "ASSUME_SORTED=true"
      separate: false
    type: boolean?
    doc: |
       If true, assume that the input file is coordinate sorted even if the header says otherwise. Deprecated, used ASSUME_SORT_ORDER=coordinate instead. Default value: false. This option can be set to 'null' to clear the default value. Possible values: {true, false} Cannot be used in conjuction with option(s) ASSUME_SORT_ORDER (ASO)

  ASSUME_SORT_ORDER:
    inputBinding:
      position: 5
      prefix: "ASSUME_SORT_ORDER="
      separate: false
    type:
      - 'null'
      - type: enum
        symbols: [unsorted, queryname, coordinate, duplicate, unknown]
    doc: |
       If not null, assume that the input file has this order even if the header says otherwise. Default value: null. Possible values: {unsorted, queryname, coordinate, duplicate, unknown} Cannot be used in conjuction with option(s) ASSUME_SORTED (AS)

  DUPLICATE_SCORING_STRATEGY:
    inputBinding:
      position: 5
      prefix: "DUPLICATE_SCORING_STRATEGY="
      separate: false
    type:
      - 'null'
      - type: enum
        symbols: [SUM_OF_BASE_QUALITIES, TOTAL_MAPPED_REFERENCE_LENGTH, RANDOM]
    doc: |
       The scoring strategy for choosing the non-duplicate among candidates. Default value: SUM_OF_BASE_QUALITIES. This option can be set to 'null' to clear the default value. Possible values: {SUM_OF_BASE_QUALITIES, TOTAL_MAPPED_REFERENCE_LENGTH, RANDOM} 

  PROGRAM_RECORD_ID:
    inputBinding:
      position: 5
      prefix: "PROGRAM_RECORD_ID="
      separate: false
    type: string?
    doc: |
       The program record ID for the @PG record(s) created by this program. Set to null to disable PG record creation. This string may have a suffix appended to avoid collision with other program record IDs. Default value: MarkDuplicates. This option can be set to 'null' to clear the default value. 

  PROGRAM_GROUP_VERSION:
    inputBinding:
      position: 5
      prefix: "PROGRAM_GROUP_VERSION="
      separate: false
    type: string?
    doc: |
       Value of VN tag of PG record to be created. If not specified, the version will be detected automatically. Default value: null. 

  PROGRAM_GROUP_COMMAND_LINE:
    inputBinding:
      position: 5
      prefix: "PROGRAM_GROUP_COMMAND_LINE="
      separate: false
    type: string?
    doc: |
       Value of CL tag of PG record to be created. If not supplied the command line will be detected automatically. Default value: null. 

  PROGRAM_GROUP_NAME:
    inputBinding:
      position: 5
      prefix: "PROGRAM_GROUP_NAME="
      separate: false
    type: string?
    doc: |
       Value of PN tag of PG record to be created. Default value: MarkDuplicates. This option can be set to 'null' to clear the default value. 

  COMMENT:
    inputBinding:
      position: 5
      prefix: "COMMENT="
      separate: false
    type: string?
    doc: |
       Comment(s) to include in the output file's header. Default value: null. This option may be specified 0 or more times. 

  READ_NAME_REGEX:
    inputBinding:
      position: 5
      prefix: "READ_NAME_REGEX="
      separate: false
    type: string?
    doc: |
       Regular expression that can be used to parse read names in the incoming SAM file. Read names are parsed to extract three variables: tile/region, x coordinate and y coordinate. These values are used to estimate the rate of optical duplication in order to give a more accurate estimated library size. Set this option to null to disable optical duplicate detection, e.g. for RNA-seq or other data where duplicate sets are extremely large and estimating library complexity is not an aim. Note that without optical duplicate counts, library size estimation will be inaccurate. The regular expression should contain three capture groups for the three variables, in order. It must match the entire read name. Note that if the default regex is specified, a regex match is not actually done, but instead the read name is split on colon character. For 5 element names, the 3rd, 4th and 5th elements are assumed to be tile, x and y values. For 7 element names (CASAVA 1.8), the 5th, 6th, and 7th elements are assumed to be tile, x and y values. Default value: <optimized capture of last three ':' separated fields as numeric values>. This option can be set to 'null' to clear the default value. 

  OPTICAL_DUPLICATE_PIXEL_DISTANCE:
    inputBinding:
      position: 5
      prefix: "OPTICAL_DUPLICATE_PIXEL_DISTANCE="
      separate: false
    type: int?
    doc: |
       The maximum offset between two duplicate clusters in order to consider them optical duplicates. The default is appropriate for unpatterned versions of the Illumina platform. For the patterned flowcell models, 2500 is moreappropriate. For other platforms and models, users should experiment to find what works best. Default value: 100. This option can be set to 'null' to clear the default value. 

  MAX_OPTICAL_DUPLICATE_SET_SIZE:
    inputBinding:
      position: 5
      prefix: "MAX_OPTICAL_DUPLICATE_SET_SIZE="
      separate: false
    type: long?
    doc: |
       This number is the maximum size of a set of duplicate reads for which we will attempt to determine which are optical duplicates. Please be aware that if you raise this value too high and do encounter a very large set of duplicate reads, it will severely affect the runtime of this tool. To completely disable this check, set the value to -1. Default value: 300000. This option can be set to 'null' to clear the default value. 

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
       Use the JDK Deflater instead of the Intel Deflater for writing compressed output Default value: false. This option can be set to 'null' to clear the default value. Possible values: {true, false} 

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
