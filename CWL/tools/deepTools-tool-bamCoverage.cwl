#!/usr/bin/env cwl-runner
#This tool description was generated automatically by argparse2tool ver. 0.4.3-2
# To generate again: $ bamCoverage --generate_cwl_tool
# Help: $ bamCoverage --help_arg2cwl

cwlVersion: "v1.0"

class: CommandLineTool
baseCommand: ['bamCoverage']

id: "bamCoverage"
label: "bamCoverage"

doc: |
  This tool takes an alignment of reads or fragments as input (BAM file) and generates a coverage track (bigWig or bedGraph) as output. The coverage is calculated as the number of reads per bin, where bins are short consecutive counting windows of a defined size. It is possible to extended the length of the reads to better reflect the actual fragment length. *bamCoverage* offers normalization by scaling factor, Reads Per Kilobase per Million mapped reads (RPKM), and 1x depth (reads per genome coverage, RPGC).


s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-5283-7633
    s:email: mailto:heleneluessem@gmail.com
    s:name: Helene Luessem

requirements:
  - class: InlineJavascriptRequirement

baseCommand: "bamCoverage"


outputs:

  outputFile:
    type: File
    outputBinding:
      glob: $( inputs.outFileName )

inputs:

  bam:
    type: File

    doc: BAM file to process
    inputBinding:
      prefix: -b

  outFileName:
    type: string

    doc: Output file name.
    inputBinding:
      prefix: -o

  outFileFormat:
    type:
    - "null"
    - type: enum
      symbols: ['bigwig', 'bedgraph']
    doc: Output file type. Either "bigwig" or "bedgraph".
    inputBinding:
      prefix: -of

  scaleFactor:
    type: ["null", float]
    doc: Indicate a number that you would like to use. When used in combination with --normalizeTo1x or --normalizeUsingRPKM, the computed scaling factor will be multiplied by the given scale factor.
    inputBinding:
      prefix: --scaleFactor

  MNase:
    type: ["null", boolean]
    doc: Determine nucleosome positions from MNase-seq data. Only 3 nucleotides at the center of each fragment are counted. The fragment ends are defined by the two mate reads. Only fragment lengthsbetween 130 - 200 bp are considered to avoid dinucleosomes or other artifacts.*NOTE* - Requires paired-end data. A bin size of 1 is recommended.
    inputBinding:
      prefix: --MNase

  offset:
    type: ["null", int]
    doc: Uses this offset inside of each read as the signal. This is useful in cases like RiboSeq or GROseq, where the signal is 12, 15 or 0 bases past the start of the read. This can be paired with the --filterRNAstrand option. Note that negative values indicate offsets from the end of each read. A value of 1 indicates the first base of the alignment (taking alignment orientation into account). Likewise, a value of -1 is the last base of the alignment. An offset of 0 is not permitted. If two values are specified, then they will be used to specify a range of positions. Note that specifying something like --Offset 5 -1 will result in the 5th through last position being used, which is equivalent to trimming 4 bases from the 5-prime end of alignments. (default None)
    inputBinding:
      prefix: --Offset

  filterRNAstrand:
    type:
    - "null"
    - type: enum
      symbols: ['forward', 'reverse']
    doc: Selects RNA-seq reads (single-end or paired-end) in the given strand.
    inputBinding:
      prefix: --filterRNAstrand

  binSize:
    type: ["null", int]
    doc: Size of the bins, in bases, for the output of the bigwig/bedgraph file.
    inputBinding:
      prefix: -bs

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
    type: ["null", int]
    doc: Number of processors to use. Type "max/2" to use half the maximum number of processors or "max" to use all available processors.
    inputBinding:
      prefix: -p

  verbose:
    type: ["null", boolean]
    default: False
    doc: Set to see processing messages.
    inputBinding:
      prefix: -v

  normalizeTo1x:
    type: ["null", int]
    doc: Report read coverage normalized to 1x sequencing depth (also known as Reads Per Genomic Content (RPGC)). Sequencing depth is defined as - (total number of mapped reads * fragment length) / effective genome size. The scaling factor used is the inverse of the sequencing depth computed for the sample to match the 1x coverage. To use this option, the effective genome size has to be indicated after the option. The effective genome size is the portion of the genome that is mappable. Large fractions of the genome are stretches of NNNN that should be discarded. Also, if repetitive regions were not included in the mapping of reads, the effective genome size needs to be adjusted accordingly. Common values are - mm9 - 2,150,570,000; hg19 -2,451,960,000; dm3 -121,400,000 and ce10 -93,260,000. See Table 2 of http -//www.plosone.org/article/info -doi/10.1371/journal.pone.0030377 or http -//www.nature.com/nbt/journal/v27/n1/fig_tab/nbt.1518_T1.html for several effective genome sizes.
    inputBinding:
      prefix: --normalizeTo1x

  normalizeUsingRPKM:
    type: ["null", boolean]
    doc: Use Reads Per Kilobase per Million reads to normalize the number of reads per bin. The formula is - RPKM (per bin) = number of reads per bin / ( number of mapped reads (in millions) * bin length (kb) ). Each read is considered independently,if you want to only count either of the mate pairs inpaired-end data, use the --samFlag option.
    inputBinding:
      prefix: --normalizeUsingRPKM

  ignoreForNormalization:
    type:
    - "null"
    - type: array
      items: string

    doc: A list of space-delimited chromosome names containing those chromosomes that should be excluded for computing the normalization. This is useful when considering samples with unequal coverage across chromosomes, like male samples. An usage examples is --ignoreForNormalization chrX chrM.
    inputBinding:
      prefix: -ignore

  skipNonCoveredRegions:
    type: ["null", boolean]
    doc: This parameter determines if non-covered regions (regions without overlapping reads) in a BAM file should be skipped. The default is to treat those regions as having a value of zero. The decision to skip non-covered regions depends on the interpretation of the data. Non-covered regions may represent, for example, repetitive regions that should be skipped.
    inputBinding:
      prefix: --skipNAs

  smoothLength:
    type: ["null", int]
    doc: The smooth length defines a window, larger than the binSize, to average the number of reads. For example, if the --binSize is set to 20 and the --smoothLength is set to 60, then, for each bin, the average of the bin and its left and right neighbors is considered. Any value smaller than --binSize will be ignored and no smoothing will be applied.
    inputBinding:
      prefix: --smoothLength

  extendReads:
    type: ["null", int]
    doc: This parameter allows the extension of reads to fragment size. If set, each read is extended, without exception. *NOTE* - This feature is generally NOT recommended for spliced-read data, such as RNA-seq, as it would extend reads over skipped regions. *Single-end* - Requires a user specified value for the final fragment length. Reads that already exceed this fragment length will not be extended. *Paired-end* - Reads with mates are always extended to match the fragment size defined by the two read mates. Unmated reads, mate reads that map too far apart (>4x fragment length) or even map to different chromosomes are treated like single-end reads. The input of a fragment length value is optional. If no value is specified, it is estimated from the data (mean of the fragment size of all mate reads).
    inputBinding:
      prefix: -e

  ignoreDuplicates:
    type: ["null", boolean]
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

  minFragmentLength:
    type: ["null", int]
    doc: The minimum fragment length needed for read/pair inclusion. This option is primarily useful in ATACseq experiments, for filtering mono- or di-nucleosome fragments. (default 0)
    inputBinding:
      prefix: --minFragmentLength

  maxFragmentLength:
    type: ["null", int]
    doc: The minimum fragment length needed for read/pair inclusion. (default 0)
    inputBinding:
      prefix: --maxFragmentLength

doc: |
  usage: An example usage is:$ bamCoverage -b reads.bam -o coverage.bw

  Required arguments:
    -b BAM file
      BAM file to process (default: None)

  Output:
    -o FILENAME
      Output file name. (default: None)
    -of {bigwig,bedgraph}
      Output file type. Either "bigwig" or "bedgraph".
      (default: bigwig)

  Optional arguments:
    --scaleFactor SCALEFACTOR
      The computed scaling factor (or 1, if not applicable)
      will be multiplied by this. (default: 1.0)
    --MNase   
      Determine nucleosome positions from MNase-seq data.
      Only 3 nucleotides at the center of each fragment are
      counted. The fragment ends are defined by the two mate
      reads. Only fragment lengthsbetween 130 - 200 bp are
      considered to avoid dinucleosomes or other artifacts.
      By default, any fragments smaller or larger than this
      are ignored. To over-ride this, use the
      --minFragmentLength and --maxFragmentLength options,
      which will default to 130 and 200 if not otherwise
      specified in the presence of --MNase. *NOTE*: Requires
      paired-end data. A bin size of 1 is recommended.
      (default: False)
    --Offset INT [INT ...]
      Uses this offset inside of each read as the signal.
      This is useful in cases like RiboSeq or GROseq, where
      the signal is 12, 15 or 0 bases past the start of the
      read. This can be paired with the --filterRNAstrand
      option. Note that negative values indicate offsets
      from the end of each read. A value of 1 indicates the
      first base of the alignment (taking alignment
      orientation into account). Likewise, a value of -1 is
      the last base of the alignment. An offset of 0 is not
      permitted. If two values are specified, then they will
      be used to specify a range of positions. Note that
      specifying something like --Offset 5 -1 will result in
      the 5th through last position being used, which is
      equivalent to trimming 4 bases from the 5-prime end of
      alignments. (default: None)
    --filterRNAstrand {forward,reverse}
      Selects RNA-seq reads (single-end or paired-end) in
      the given strand. (default: None)
    -bs INT bp
      Size of the bins, in bases, for the output of the
      bigwig/bedgraph file. (default: 50)
    -r CHR:START:END
      Region of the genome to limit the operation to - this
      is useful when testing parameters to reduce the
      computing time. The format is chr:start:end, for
      example --region chr10 or --region
      chr10:456700:891000. (default: None)
    -bl BED file [BED file ...]
      A BED or GTF file containing regions that should be
      excluded from all analyses. Currently this works by
      rejecting genomic chunks that happen to overlap an
      entry. Consequently, for BAM files, if a read
      partially overlaps a blacklisted region or a fragment
      spans over it, then the read/fragment might still be
      considered. Please note that you should adjust the
      effective genome size, if relevant. (default: None)
    -p INT
      Number of processors to use. Type "max/2" to use half
      the maximum number of processors or "max" to use all
      available processors. (default: max/2)
    -v         
      Set to see processing messages. (default: False)

  Read coverage normalization options:
    --normalizeTo1x EFFECTIVE GENOME SIZE LENGTH
      Report read coverage normalized to 1x sequencing depth
      (also known as Reads Per Genomic Content (RPGC)).
      Sequencing depth is defined as: (total number of
      mapped reads * fragment length) / effective genome
      size. The scaling factor used is the inverse of the
      sequencing depth computed for the sample to match the
      1x coverage. To use this option, the effective genome
      size has to be indicated after the option. The
      effective genome size is the portion of the genome
      that is mappable. Large fractions of the genome are
      stretches of NNNN that should be discarded. Also, if
      repetitive regions were not included in the mapping of
      reads, the effective genome size needs to be adjusted
      accordingly. Common values are: mm9: 2,150,570,000;
      hg19:2,451,960,000; dm3:121,400,000 and
      ce10:93,260,000. See Table 2 of http://www.plosone.org
      /article/info:doi/10.1371/journal.pone.0030377 or http
      ://www.nature.com/nbt/journal/v27/n1/fig_tab/nbt.1518_
      T1.html for several effective genome sizes. (default:
      None)
    --normalizeUsingRPKM
      Use Reads Per Kilobase per Million reads to normalize
      the number of reads per bin. The formula is: RPKM (per
      bin) = number of reads per bin / ( number of mapped
      reads (in millions) * bin length (kb) ). Each read is
      considered independently,if you want to only count
      either of the mate pairs inpaired-end data, use the
      --samFlag option. (default: False)
    -ignore IGNOREFORNORMALIZATION [IGNOREFORNORMALIZATION ...]
      A list of space-delimited chromosome names containing
      those chromosomes that should be excluded for
      computing the normalization. This is useful when
      considering samples with unequal coverage across
      chromosomes, like male samples. An usage examples is
      --ignoreForNormalization chrX chrM. (default: None)
    --skipNAs
      This parameter determines if non-covered regions
      (regions without overlapping reads) in a BAM file
      should be skipped. The default is to treat those
      regions as having a value of zero. The decision to
      skip non-covered regions depends on the interpretation
      of the data. Non-covered regions may represent, for
      example, repetitive regions that should be skipped.
      (default: False)
    --smoothLength INT bp
      The smooth length defines a window, larger than the
      binSize, to average the number of reads. For example,
      if the --binSize is set to 20 and the --smoothLength
      is set to 60, then, for each bin, the average of the
      bin and its left and right neighbors is considered.
      Any value smaller than --binSize will be ignored and
      no smoothing will be applied. (default: None)

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
    --ignoreDuplicates    If set, reads that have the same orientation and start
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
    --minFragmentLength INT
      The minimum fragment length needed for read/pair
      inclusion. This option is primarily useful in ATACseq
      experiments, for filtering mono- or di-nucleosome
      fragments. (default: 0)
    --maxFragmentLength INT
      The maximum fragment length needed for read/pair
      inclusion. (default: 0)


$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/
$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
