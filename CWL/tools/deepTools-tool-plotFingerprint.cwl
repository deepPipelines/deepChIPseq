#!/usr/bin/env cwl-runner
# This tool description was generated automatically by argparse2tool ver. 0.4.3-2
# To generate again: $ plotFingerprint --generate_cwl_tool
# Help: $ plotFingerprint --help_arg2cwl

cwlVersion: "v1.0"

class: CommandLineTool
baseCommand: ['plotFingerprint']

id: "plotFingerprint"
label: "plotFingerprint"

doc: |
  This tool samples indexed BAM files and plots a profile of cumulative read coverages for each. All reads overlapping a window (bin) of the specified length are counted; these counts are sorted and the cumulative sum is finally plotted. 

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-5283-7633
    s:email: mailto:heleneluessem@gmail.com
    s:name: Helene Luessem

requirements:
  - class: InlineJavascriptRequirement

baseCommand: "plotFingerprint"


outputs:

  outputFile:
    type: File
    inputBinding:
      glob: $( inputs.plotTitle )

  outputFileQM:
    type: File
    inputBinding:
      glob: $( inputs.outQualityMetrics )

  outputFileRC:
    type: File
    inputBinding:
      glob: $( inputs.outRawCounts )


inputs:
  
  bamfiles:
    type:
      type: array
      items: File

    doc: List of indexed BAM files
    inputBinding:
      prefix: -b 

  plotFile:
    type: File?

    doc: File name of the output figure. The file ending will be used to determine the image format. The available options are typically - "png", "eps", "pdf" and "svg", e.g. - fingerprint.png.
    inputBinding:
      prefix: -plot 

  outRawCounts:
    type: ["null", File]
    doc: Output file name to save the read counts per bin.
    inputBinding:
      prefix: --outRawCounts 

  extendReads:
    type: ["null", int]
    default: False
    doc: This parameter allows the extension of reads to fragment size. If set, each read is extended, without exception. *NOTE* - This feature is generally NOT recommended for spliced-read data, such as RNA-seq, as it would extend reads over skipped regions. *Single-end* - Requires a user specified value for the final fragment length. Reads that already exceed this fragment length will not be extended. *Paired-end* - Reads with mates are always extended to match the fragment size defined by the two read mates. Unmated reads, mate reads that map too far apart (>4x fragment length) or even map to different chromosomes are treated like single-end reads. The input of a fragment length value is optional. If no value is specified, it is estimated from the data (mean of the fragment size of all mate reads). 
    inputBinding:
      prefix: -e 

  ignoreDuplicates:
    type: ["null", boolean]
    default: False
    doc: If set, reads that have the same orientation and start position will be considered only once. If reads are paired, the mate's position also has to coincide to ignore a read.
    inputBinding:
      prefix: --ignoreDuplicates 

  minMappingQuality:
    type: ["null", int]
    doc: If set, only reads that have a mapping quality score of at least this are considered.
    inputBinding:
      prefix: --minMappingQuality 

  centerReads:
    type: ["null", boolean]
    default: False
    doc: By adding this option, reads are centered with respect to the fragment length. For paired-end data, the read is centered at the fragment length defined by the two ends of the fragment. For single-end data, the given fragment length is used. This option is useful to get a sharper signal around enriched regions.
    inputBinding:
      prefix: --centerReads 

  samFlagInclude:
    type: ["null", int]
    doc: Include reads based on the SAM flag. For example, to get only reads that are the first mate, use a flag of 64. This is useful to count properly paired reads only once, as otherwise the second mate will be also considered for the coverage.
    inputBinding:
      prefix: --samFlagInclude 

  samFlagExclude:
    type: ["null", int]
    doc: Exclude reads based on the SAM flag. For example, to get only reads that map to the forward strand, use --samFlagExclude 16, where 16 is the SAM flag for reads that map to the reverse strand.
    inputBinding:
      prefix: --samFlagExclude 

  labels:
    type:
    - "null"
    - type: array
      items: string

    doc: List of labels to use in the output. If not given, the file names will be used instead. Separate the labels by spaces.
    inputBinding:
      prefix: -l 

  binSize:
    type: ["null", int]
    doc: Window size in base pairs to sample the genome.
    inputBinding:
      prefix: -bs 

  numberOfSamples:
    type: ["null", int]
    doc: Number of bins that sampled from the genome, for which the overlapping number of reads is computed. (default 500000.0)
    inputBinding: 
      prefix: --n

  plotFileFormat:
    type:
     - "null"
     - type: enum
       symbols: ['png', 'eps', 'pdf', 'svg']
    doc: image format type. If given, this option overrides the image format based on the ending given via --plotFile ending. The available options are "png", "eps", "pdf" and "svg" (default None)
    inputBinding:
      prefix: --plotFileFormat 

  plotTitle:
    type: ["null", string]
    doc: Title of the plot, to be printed on top of the generated image. Leave blank for no title.
    inputBinding:
      prefix: -T 

  skipZeros:
    type: ["null", boolean]
    doc: If set, then regions with zero overlapping readsfor *all* given BAM files are ignored. This will result in a reduced number of read counts than that specified in --numberOfSamples
    inputBinding:
      prefix: --skipZeros 

  region:
    type: ["null", string]
    doc: Region of the genome to limit the operation to - this is useful when testing parameters to reduce the computing time. The format is chr -start -end, for example --region chr10 or --region chr10 -456700 -891000.
    inputBinding:
      prefix: -r 

  blackListFileName:
    type: ["null", File]
    doc: A BED file containing regions that should be excluded from all analyses. Currently this works by rejecting genomic chunks that happen to overlap an entry. Consequently, for BAM files, if a read partially overlaps a blacklisted region or a fragment spans over it, then the read/fragment might still be considered.
    inputBinding:
      prefix: -bl 

  numberOfProcessors:
    type: 
    - "null"
    - type: enum
      symbols: ['max/2', 'max']
    inputBinding:
      position: 10
      prefix: -p
    doc: |
      Number of processors to use. Type "max/2" to use half the maximum number of processors or "max" to use all available processors. (default max/2)
 
  verbose:
    type: ["null", boolean]
    doc: Set to see processing messages.
    inputBinding:
      prefix: -v 

doc: |
  usage: An example usage is: plotFingerprint -b treatment.bam control.bam -plot fingerprint.png

  Required arguments:
    -b bam files [bam files ...]
      List of indexed BAM files (default None)

  Output:
    -plot    
      File name of the output figure. The file ending will
      be used to determine the image format. The available
      options are typically: "png", "eps", "pdf" and "svg",
      e.g. : fingerprint.png. (default: None)
    --outRawCounts      
      Output file name to save the read counts per bin.
      (default: None)

  Read processing options:
    -e [INT bp]
      This parameter allows the extension of reads to
      fragment size. If set, each read is extended, without
      exception. *NOTE*: This feature is generally NOT
      recommended for spliced-read data, such as RNA-seq, as
      it would extend reads over skipped regions. *Single-
      end*: Requires a user specified value for the final
      fragment length. Reads that already exceed this
      fragment length will not be extended. *Paired-end*:
      Reads with mates are always extended to match the
      fragment size defined by the two read mates. Unmated
      reads, mate reads that map too far apart (>4x fragment
      length) or even map to different chromosomes are
      treated like single-end reads. The input of a fragment
      length value is optional. If no value is specified, it
      is estimated from the data (mean of the fragment size
      of all mate reads). (default: False)
    --ignoreDuplicates   
      If set, reads that have the same orientation and start
      position will be considered only once. If reads are
      paired, the mate's position also has to coincide to
      ignore a read. (default: False)
    --minMappingQuality INT
      If set, only reads that have a mapping quality score
      of at least this are considered. (default: None)
    --centerReads
      By adding this option, reads are centered with respect
      to the fragment length. For paired-end data, the read
      is centered at the fragment length defined by the two
      ends of the fragment. For single-end data, the given
      fragment length is used. This option is useful to get
      a sharper signal around enriched regions. (default:
      False)
    --samFlagInclude INT 
      Include reads based on the SAM flag. For example, to
      get only reads that are the first mate, use a flag of
      64. This is useful to count properly paired reads only
      once, as otherwise the second mate will be also
      considered for the coverage. (default: None)
    --samFlagExclude INT  
      Exclude reads based on the SAM flag. For example, to
      get only reads that map to the forward strand, use
      --samFlagExclude 16, where 16 is the SAM flag for
      reads that map to the reverse strand. (default: None)

  Optional arguments:
    -l  [ ...]
      List of labels to use in the output. If not given, the
      file names will be used instead. Separate the labels
      by spaces. (default: None)
    -bs BINSIZE
      Window size in base pairs to sample the genome.
      (default: 500)
    -n NUMBEROFSAMPLES
      Number of bins that sampled from the genome, for which
      the overlapping number of reads is computed. (default:
      500000.0)
    --plotFileFormat
      image format type. If given, this option overrides the
      image format based on the ending given via --plotFile
      ending. The available options are: "png", "eps", "pdf"
      and "svg" (default: None)
    -T PLOTTITLE
      Title of the plot, to be printed on top of the
      generated image. Leave blank for no title. (default: )
    --skipZeros 
      If set, then regions with zero overlapping readsfor
      *all* given BAM files are ignored. This will result in
      a reduced number of read counts than that specified in
      --numberOfSamples (default: False)
    -r CHR:START:END
      Region of the genome to limit the operation to - this
      is useful when testing parameters to reduce the
      computing time. The format is chr:start:end, for
      example --region chr10 or --region
      chr10:456700:891000. (default: None)
    -bl BED file
      A BED file containing regions that should be excluded
      from all analyses. Currently this works by rejecting
      genomic chunks that happen to overlap an entry.
      Consequently, for BAM files, if a read partially
      overlaps a blacklisted region or a fragment spans over
      it, then the read/fragment might still be considered.
      (default: None)
    -p INT
      Number of processors to use. Type "max/2" to use half
      the maximum number of processors or "max" to use all
      available processors. (default: max/2)
    -v 
      Set to see processing messages. (default: False)


$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/
$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
