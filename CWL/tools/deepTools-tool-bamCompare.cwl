#!/usr/bin/env cwl-runner
# This tool description was generated automatically by argparse2tool ver. 0.4.3-2
# To generate again: $ bamCompare --generate_cwl_tool
# Help: $ bamCompare --help_arg2cwl

cwlVersion: "v1.0"

id: "bamCompare"
label: "bamCompare"

class: CommandLineTool
baseCommand: ['bamCompare']

doc: |
  This tool compares two BAM files based on the number of mapped reads. To compare the BAM files, the genome is partitioned into bins of equal size, then the number of reads found in each bin is counted per file, and finally a summary value is reported. This value can be the ratio of the number of reads per bin, the log2 of the ratio, or the difference. This tool can normalize the number of reads in each BAM file using the SES method proposed by Diaz et al. (2012) "Normalization, bias correction, and peak calling for ChIP-seq". Statistical Applications in Genetics and Molecular Biology, 11(3). Normalization based on read counts is also available. The output is either a bedgraph or bigWig file containing the bin location and the resulting comparison value. By default, if reads are paired, the fragment length reported in the BAM file is used. Each mate, however, is treated independently to avoid a bias when a mixture of concordant and discordant pairs is present. This means that *each end* will be extended to match the fragment length.

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-5283-7633
    s:email: mailto:heleneluessem@gmail.com
    s:name: Helene Luessem

requirements:
- class: InlineJavascriptRequirement

stdout: $( inputs.outFileName )

outputs:

  out:
    type: stdout

inputs:
  
  bamfile1:
#   type: string
    type: File

    doc: Sorted BAM file 1. Usually the BAM file for the treatment.
    inputBinding:
      prefix: -b1 

  bamfile2:
#   type: string
    type: File

    doc: Sorted BAM file 2. Usually the BAM file for the control.
    inputBinding:
      prefix: -b2 

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
    default: bigwig
    doc: Output file type. Either "bigwig" or "bedgraph".
    inputBinding:
      prefix: -of 

  scaleFactorsMethod:
    type:
    - "null"
    - type: enum
      symbols: ['readCount', 'SES']
    default: readCount
    doc: Method to use to scale the samples. Default "readCount".
    inputBinding:
      prefix: --scaleFactorsMethod 

  sampleLength:
    type: ["null", int]
    default: 1000
    doc: Only relevant when SES is chosen for the scaleFactorsMethod. To compute the SES, specify the length (in bases) of the regions (see --numberOfSamples) that will be randomly sampled to calculate the scaling factors. If you do not have a good sequencing depth for your samples consider increasing the sampling regions' size to minimize the probability that zero-coverage regions are used.
    inputBinding:
      prefix: -l 

  numberOfSamples:
    type: ["null", int]
    default: 100000.0
    doc: Only relevant when SES is chosen for the scaleFactorsMethod. Number of samplings taken from the genome to compute the scaling factors.
    inputBinding:
      prefix: -n 

  scaleFactors:
    type: ["null", string]
    doc: Set this parameter manually to avoid the computation of scaleFactors. The format is scaleFactor1 -scaleFactor2.For example, --scaleFactor 0.7 -1 will cause the first BAM file tobe multiplied by 0.7, while not scaling the second BAM file (multiplication with 1).
    inputBinding:
      prefix: --scaleFactors 

  ratio:
    type:
    - "null"
    - type: enum
      symbols: ['log2', 'ratio', 'subtract', 'add', 'reciprocal_ratio']
    default: log2
    doc: The default is to output the log2ratio of the two samples. The reciprocal ratio returns the the negative of the inverse of the ratio if the ratio is less than 0. The resulting values are interpreted as negative fold changes. *NOTE* - Only with --ratio subtract can --normalizeTo1x or --normalizeUsingRPKM be used.
    inputBinding:
      prefix: --ratio 

  pseudocount:
    type: ["null", float]
    default: 1
    doc: small number to avoid x/0. Only useful together with --ratio log2 or --ratio ratio .
    inputBinding:
      prefix: --pseudocount 

  binSize:
    type: ["null", int]
    default: 50
    doc: Size of the bins, in bases, for the output of the bigwig/bedgraph file.
    inputBinding:
      prefix: -bs 

  region:
    type: ["null", string]
    doc: Region of the genome to limit the operation to - this is useful when testing parameters to reduce the computing time. The format is chr -start -end, for example --region chr10 or --region chr10 -456700 -891000.
    inputBinding:
      prefix: -r 

  blackListFileName:
#   type: ["null", string]
    type: [File, "null"]
    doc: A BED file containing regions that should be excluded from all analyses. Currently this works by rejecting genomic chunks that happen to overlap an entry. Consequently, for BAM files, if a read partially overlaps a blacklisted region or a fragment spans over it, then the read/fragment might still be considered.
    inputBinding:
      prefix: -bl 

  numberOfProcessors:
#   type: ["null", string]
    type: ["null", int]
    default: max/2
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
    default: False
    doc: Use Reads Per Kilobase per Million reads to normalize the number of reads per bin. The formula is - RPKM (per bin) = number of reads per bin / ( number of mapped reads (in millions) * bin length (kb) ). Each read is considered independently,if you want to only count either of the mate pairs inpaired-end data, use the --samFlag option.
    inputBinding:
      prefix: --normalizeUsingRPKM 

  ignoreForNormalization:
    type:
    - "null"
    - type: array
      items: string
#     items: array

    doc: A list of space-delimited chromosome names containing those chromosomes that should be excluded for computing the normalization. This is useful when considering samples with unequal coverage across chromosomes, like male samples. An usage examples is --ignoreForNormalization chrX chrM.
    inputBinding:
      prefix: -ignore 

  skipNonCoveredRegions:
    type: ["null", boolean]
    default: False
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
    default: False
    doc: This parameter allows the extension of reads to fragment size. If set, each read is extended, without exception. NOTE; This feature is generally NOT recommended for spliced-read data, such as RNA-seq, as it would extend reads over skipped regions. Single-end; Requires a user specified value for the final fragment length. Reads that already exceed this fragment length will not be extended. Paired-end; Reads with mates are always extended to match the fragment size defined by the two read mates. Unmated reads, mate reads that map too far apart (>4x fragment length) or even map to different chromosomes are treated like single-end reads. The input of a fragment length value is optional. If no value is specified, it is estimated from the data (mean of the fragment size of all mate reads). (default False) 

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


$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
