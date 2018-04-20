class: CommandLineTool

id: "sambamba_view"
label: "sambamba view"

cwlVersion: "v1.0"

doc: |
    A Docker container containing ...TODO

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-5283-7633
    s:email: mailto:heleneluessem@gmail.com
    s:name: Helene Luessem

requirements:
  - class: InlineJavascriptRequirement

baseCommand: ["sambamba", "view"]

stdout: $( inputs.outputFileName )

outputs:
  
  outputBamFile:
    type: stdout

inputs:

  inputFile:
    type: File
    inputBinding:
      position: 10

  filter:
    type: string?
    inputBinding:
      position: 5
      prefix: -F
    doc: |
      set custom filter for alignments
      

  numFilter:
    type: string?
    inputBinding:
      position: 5
      prefix: --num-filter=
      separate: false
    doc: |
      filter flag bits; 'i1/i2' corresponds to -f i1 -F i2 samtools arguments;
      either of the numbers can be omitted

  format:
    type:
      - 'null' 
      - type: enum
        symbols: [sam, bam, cram , json]
    inputBinding:
      position: 5
      prefix: -f
    doc: |
      specify which format to use for output (default is SAM)
 
  withHeader:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -h
    doc: |
      print header before reads (always done for BAM output)
      
  header:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -H
    doc: |
      output only header to stdout (if format=bam, the header is printed as SAM)
      
  referenceInfo:
    type: boolean?
    inputBinding: 
      position: 5
      prefix: -I
    doc: |
      output to stdout only reference names and lengths in JSON
      
  regions:
    type: File?
    inputBinding:
      position: 15
      prefix: -L
    doc: |
      output only reads overlapping one of regions from the BED file
      
  count:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -c
    doc: |
      output to stdout only count of matching records, hHI are ignored
      
  valid:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -v
    doc: |
      output only valid alignments
      
  samInput:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -S
    doc: |
      specify that input is in SAM format
      
  cramInput:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -C
    doc: |
      specify that input is in CRAM format
   
  refFileName:
    type: File?
    inputBinding:
      position: 5
      prefix: -T
    doc: |
      specify reference for writing CRAM

  showProgress:
    type: boolean?
    inputBinding: 
      position: 5
      prefix: -p
    doc: |
      show progressbar in STDERR (works only for BAM files with no regions specified)

  compressionLevel:
    type: int?
    inputBinding:
      position: 5
      prefix: -l
    doc: |
      specify compression level (from 0 to 9, works only for BAM output)
    
  outputFileName:
    type: string?
    inputBinding:
      position: 5
      prefix: -o
    doc: |
      specify output filename

  nThreads:
    type: int?
    inputBinding:
      position: 5
      prefix: -t
    doc: |
      maximum number of threads to use

  subsample:
    type: File?
    inputBinding:
      position: 5
      prefix: -s
    doc: |
      subsample reads (read pairs)
    
  subsamplingSeed:
    type: File?
    inputBinding:
      position: 5
      prefix: --subsampling-seed=
      separate: false
    doc: |
      set seed for subsampling
 
    

doc: |
  Usage: sambamba-view [options] <input.bam | input.sam> [region1 [...]]

  Options: 
      -F      set custom filter for alignments
      --num-filter=NUMFILTER
              filter flag bits; 'i1/i2' corresponds to -f i1 -F i2 samtools arguments;
              either of the numbers can be omitted
      -f      specify which format to use for output (default is SAM)
      -h      print header before reads (always done for BAM output)
      -H      output only header to stdout (if format=bam, the header is printed as SAM)
      -I      output to stdout only reference names and lengths in JSON
      -L      output only reads overlapping one of regions from the BED file
      -c      output to stdout only count of matching records, hHI are ignored
      -v      output only valid alignments
      -S      specify that input is in SAM format
      -C      specify that input is in CRAM format
      -T      specify reference for writing CRAM
      -p      show progressbar in STDERR (works only for BAM files with no regions specified)
      -l      specify compression level (from 0 to 9, works only for BAM output)
      -o      specify output filename
      -t      maximum number of threads to use
      -s      subsample reads (read pairs)
      --subsampling-seed=SEED
              set seed for subsampling


$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
