class: CommandLineTool

id: "multiBamSummary_bins"
label: "multiBamSummary bins"

cwlVersion: "v1.0"

doc: |
  ``multiBamSummary`` computes the read coverages for genomic regions for typically two or more BAM files. The analysis can be performed for the entire genome by running the program in 'bins' mode. If you want to count the read coverage for specific regions only, use the ``BED-file`` mode instead. The standard output of ``multiBamSummary`` is a compressed numpy array (``.npz``). It can be directly used to calculate and visualize pairwise correlation values between the read coverages using the tool 'plotCorrelation'. Similarly, ``plotPCA`` can be used for principal component analysis of the read coverages using the .npz file. Note that using a single bigWig file is only recommended if you want to produce a bedGraph file (i.e., with the ``--outRawCounts`` option; the default output file cannot be used by ANY deepTools program if only a single file was supplied!).

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-5283-7633
    s:email: mailto:heleneluessem@gmail.com
    s:name: Helene Luessem

requirements:
  - class: InlineJavascriptRequirement

baseCommand: ["multiBamSummary", "bins"]


outputs:

  outputFile:
    type: File
    outputBinding:
      glob: $ ( inputs.outFileName )

inputs:

  bamfiles:
    type:
    - type: array
      items: File
    inputBinding:
      position: 5
      prefix: -b
    doc: |
      List of indexed bam files separated by spaces. (default: None)

  outFileName:
    type: string
    inputBinding:
      position: 5
      prefix: -out
    doc: |
      File name to save the coverage matrix. This matrix can be subsequently plotted using plotCorrelation or or plotPCA. (default: None)

  labels:
    type:
    - "null"
    - type: array
      items: string
    inputBinding:
      position: 10
      prefix: -l
    doc: |
      User defined labels instead of default labels from file names. Multiple labels have to be separated by a space, e.g. --labels sample1 sample2 sample3 (default: None)

  binSize:
    type: int?
    inputBinding:
      position: 10
      prefix: -bs
    doc: |
      Length in bases of the window used to sample the genome. (default: 10000)

  distanceBetweenBins:
    type: int?
    inputBinding:
      position: 10
      prefix: -n
    doc: |
      By default, multiBamSummary considers consecutive bins of the specified --binSize. However, to reduce the computation time, a larger distance between bins can by given. Larger distances result in fewer bins considered. (default: 0)

  region:
    type: string?
    inputBinding:
      position: 10
      prefix: -r
    doc: |
      Region of the genome to limit the operation to - this is useful when testing parameters to reduce the computing time. The format is chr:start:end, for example --region chr10 or --region chr10:456700:891000. (default: None)

  blackListFileName:
    type: File?
    inputBinding:
      position: 10
      prefix: -bl
    doc: |
      A BED file containing regions that should be excluded from all analyses. Currently this works by rejecting genomic chunks that happen to overlap an entry. Consequently, for BAM files, if a read partially overlaps a blacklisted region or a fragment spans over it, then the read/fragment might still be considered. (default: None)

  numberOfProcessors:
    type: int?
    inputBinding:
      position: 10
      prefix: -p
    doc: |
      Number of processors to use. Type "max/2" to use half the maximum number of processors or "max" to use all available processors. (default: max/2)

  verbose:
    type: boolean?
    inputBinding:
      position: 10
      prefix: -v
    doc: |
      Set to see processing messages. (default: False)

  outRawCounts:
    type: File?
    inputBinding:
      position: 10
      prefix: --outRawCounts
    doc: |
      Save the counts per region to a tab-delimited file. (default: None)

  extendReads:
    type: boolean?
    inputBinding:
      position: 10
      prefix: -e
    doc: |
      This parameter allows the extension of reads to fragment size. If set, each read is extended, without exception. *NOTE*: This feature is generally NOT recommended for spliced-read data, such as RNA-seq, as it would extend reads over skipped regions. *Single-end*: Requires a user specified value for the final fragment length. Reads that already exceed this fragment length will not be extended. *Paired-end*: Reads with mates are always extended to match the fragment size defined by the two read mates. Unmated reads, mate reads that map too far apart (>4x fragment length) or even map to different chromosomes are treated like single-end reads. The input of a fragment length value is optional. If no value is specified, it is estimated from the data (mean of the fragment size of all mate reads). (default: False)

  ignoreDuplicates:
    type: boolean?
    inputBinding:
      position: 10
      prefix: --ignoreDuplicates
    doc: |
      If set, reads that have the same orientation and start position will be considered only once. If reads are paired, the mate's position also has to coincide toignoreDuplicates ignore a read. (default: False)

  minMappingQuality:
    type: int?
    inputBinding:
      position: 10
      prefix: --minMappingQuality
    doc: |
      If set, only reads that have a mapping quality score of at least this are considered. (default: None)

  centerReads:
    type: boolean?
    inputBinding:
      position: 10
      prefix: --centerReads
    doc: |
      By adding this option, reads are centered with respect to the fragment length. For paired-end data, the read is centered at the fragment length defined by the two ends of the fragment. For single-end data, the given fragment length is used. This option is useful to get a sharper signal around enriched regions. (default: False)

  samFlagInclude:
    type: int?
    inputBinding:
      position: 10
      prefix: --samFlagInclude
    doc: |
      Include reads based on the SAM flag. For example, to get only reads that are the first mate, use a flag of 64. This is useful to count properly paired reads only once, as otherwise the second mate will be also considered for the coverage. (default: None)

  samFlagExclude:
    type: int?
    inputBinding:
      position: 10
      prefix: --samFlagExclude
    doc: |
      Exclude reads based on the SAM flag. For example, to get only reads that map to the forward strand, use --samFlagExclude 16, where 16 is the SAM flag for reads that map to the reverse strand. (default: None)


doc: |
  usage: multiBamSummary bins --bamfiles file1.bam file2.bam -out results.npz 

  Required arguments:
    -b FILE1 FILE2 [FILE1 FILE2 ...]
      List of indexed bam files separated by spaces.
      (default: None)
    -out OUTFILENAME
      File name to save the coverage matrix. This matrix can
      be subsequently plotted using plotCorrelation or or
      plotPCA. (default: None)

  Optional arguments:
    -l sample1 sample2 [sample1 sample2 ...]
      User defined labels instead of default labels from
      file names. Multiple labels have to be separated by a
      space, e.g. --labels sample1 sample2 sample3 (default:
      None)
    -bs INT
      Length in bases of the window used to sample the
      genome. (default: 10000)
    -n INT
      By default, multiBamSummary considers consecutive bins
      of the specified --binSize. However, to reduce the
      computation time, a larger distance between bins can
      by given. Larger distances result in fewer bins
      considered. (default: 0)
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

  Output optional options:
    --outRawCounts FILE   
      Save the counts per region to a tab-delimited file.
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


$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
