
class: CommandLineTool

id: "sambamba_view"
label: "sambamba view"

cwlVersion: "v1.0"

doc: |
    A Docker container containing ...

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-5283-7633
    s:email: mailto:heleneluessem@gmail.com
    s:name: Helene Luessem

requirements:
  - class: InlineJavascriptRequirement

baseCommand: ["sambamba", "view"]

stdout: $( inputs.output_filename )

outputs:
  
  outputBamFile:
    type: stdout

inputs:

  input:
    type: File
    inputBinding:
      position: TODO


  filter:
    type: TODO?
    inputBinding:
      position: TODO
      prefix: -F
    doc: |
      set custom filter for alignments
      

  numFilter:
    type: TODO?
    inputBinding:
      position: TODO
      prefix: --num-filter=
      separate: false
    doc: |
      filter flag bits; 'i1/i2' corresponds to -f i1 -F i2 samtools arguments;
      either of the numbers can be omitted

  format:
    type: string?
    inputBinding:
      position: TODO
      prefix: -f
   doc: |
     specify which format to use for output (default is SAM)
 
  withHeader:
    type: boolean?
    inputBinding:
      position: TODO
      prefix: -h
    doc: |
      print header before reads (always done for BAM output)
      
  header:
    type: boolean?
    inputBinding:
      position: TODO
      prefix: -H
    doc: |
      output only header to stdout (if format=bam, the header is printed as SAM)
      
  referenceInfo:
    type: boolean?
    inputBinding: 
      position: TODO
      prefix: -I
    doc: |
      output to stdout only reference names and lengths in JSON
      
  regions:
    type: File?
    inputBinding:
      position: TODO
      prefix: -L
    doc: |
      output only reads overlapping one of regions from the BED file
      
  count:
    type: boolean?
    inputBinding:
      position: TODO
      prefix: -c
    doc: |
      output to stdout only count of matching records, hHI are ignored
      
  valid:
    type: boolean?
    inputBinding:
      position: TODO
      prefix: -v
    doc: |
      output only valid alignments
      
  samInput:
    type: boolean?
    inputBinding:
      position: TODO
      prefix: -S
    doc: |
      specify that input is in SAM format
      
  cramInput:
    type: boolean
    inputBinding:
      position: TODO
      prefix: -C
    doc: |
      specify that input is in CRAM format
   
  refFileName:
    type: File
    inputBinding:
      position: TODO
      prefix: -T
    doc: |
      specify reference for writing CRAM

  showProgress:
    type: boolean
    inputBinding: 
      position: TODO
      prefix: -p
    doc: |
      show progressbar in STDERR (works only for BAM files with no regions specified)

  compressionLevel:
    type: int
    inputBinding:
      position: TODO
      prefix: -l
    doc: |
      specify compression level (from 0 to 9, works only for BAM output)
    
  outputFileName:
    type: string
    inputBinding:
      position: TODO
      prefix: -o
    doc: |
      specify output filename

  nThreads:
    type: int
    inputBinding:
      position: TODO
      prefix: -t
    doc: |
      maximum number of threads to use

  subsample:
    type: TODO
    inputBinding:
      position: TODO
      prefix: -s
    doc: |
      subsample reads (read pairs)
    
  subsamplingSeed:
    type: TODO
    inputBinding:
      position: TODO
      prefix: --subsampling-seed=
      separate: false
    doc: |
      set seed for subsampling
 
    

doc: |
  Usage: sambamba-view [options] <input.bam | input.sam> [region1 [...]]

  Options: -F, --filter=FILTER
                    set custom filter for alignments
         --num-filter=NUMFILTER
                    filter flag bits; 'i1/i2' corresponds to -f i1 -F i2 samtools arguments;
                    either of the numbers can be omitted
         -f, --format=sam|bam|cram|json
                    specify which format to use for output (default is SAM)
         -h, --with-header
                    print header before reads (always done for BAM output)
         -H, --header
                    output only header to stdout (if format=bam, the header is printed as SAM)
         -I, --reference-info
                    output to stdout only reference names and lengths in JSON
         -L, --regions=FILENAME
                    output only reads overlapping one of regions from the BED file
         -c, --count
                    output to stdout only count of matching records, hHI are ignored
         -v, --valid
                    output only valid alignments
         -S, --sam-input
                    specify that input is in SAM format
         -C, --cram-input
                    specify that input is in CRAM format
         -T, --ref-filename=FASTA
                    specify reference for writing CRAM
         -p, --show-progress
                    show progressbar in STDERR (works only for BAM files with no regions specified)
         -l, --compression-level
                    specify compression level (from 0 to 9, works only for BAM output)
         -o, --output-filename
                    specify output filename
         -t, --nthreads=NTHREADS
                    maximum number of threads to use
         -s, --subsample=FRACTION
                    subsample reads (read pairs)
         --subsampling-seed=SEED
                    set seed for subsampling

