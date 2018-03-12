#!/usr/bin/env cwl-runner
# This tool description was generated automatically by argparse2tool ver. 0.4.3-2
# To generate again: $ computeGCBias --generate_cwl_tool
# Help: $ computeGCBias --help_arg2cwl

cwlVersion: "v1.0"

id: "computeGCBias"
label: "computeGCBias"

class: CommandLineTool
baseCommand: ['computeGCBias']

doc: |
  Computes the GC-bias using Benjamini's method [Benjamini & Speed (2012). Nucleic Acids Research, 40(10). doi: 10.1093/nar/gks001]. The GC-bias is visualized and the resulting table can be used tocorrect the bias with `correctGCBias`.

requirements:
  - class: InlineJavascriptRequirement

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-5283-7633
    s:email: mailto:heleneluessem@gmail.com
    s:name: Helene Luessem

requirements:
  - class: InlineJavascriptRequirement


stdout: $( inputs.GCbiasFrequenciesFile.path )

outputs:

  GCbiasFrequenciesFile_out:
    type: stdout

    doc: Path to save the file containing the observed and expected read frequencies per %%GC-content. This file is needed to run the correctGCBias tool. This is a text file.
    #  outputBinding:
    #  glob: $(inputs.GCbiasFrequenciesFile.path)

inputs:
  
  bamfile:
    type: string

    doc: Sorted BAM file. 
    inputBinding:
      prefix: -b 

  effectiveGenomeSize:
    type: int

    doc: The effective genome size is the portion of the genome that is mappable. Large fractions of the genome are stretches of NNNN that should be discarded. Also, if repetitive regions were not included in the mapping of reads, the effective genome size needs to be adjusted accordingly. Common values are - mm9 - 2150570000, hg19 -2451960000, dm3 -121400000 and ce10 -93260000. See Table 2 of http -//www.plosone.org/article/info -doi/10.1371/journal.pone.0030377 or http -//www.nature.com/nbt/journal/v27/n1/fig_tab/nbt.1518_T1.html for several effective genome sizes. This value is needed to detect enriched regions that, if not discarded can bias the results.
    inputBinding:
      prefix: --effectiveGenomeSize 

  genome:
    type : File
        # string

    doc: Genome in two bit format. Most genomes can be found here - http -//hgdownload.cse.ucsc.edu/gbdb/ Search for the .2bit ending. Otherwise, fasta files can be converted to 2bit using the UCSC programm called faToTwoBit available for different plattforms at http -//hgdownload.cse.ucsc.edu/admin/exe/
    inputBinding:
      prefix: -g 

  fragmentLength:
    type: int

    doc: Fragment length used for the sequencing. If paired-end reads are used, the fragment length is computed based from the bam file
    inputBinding:
      prefix: -l 

  sampleSize:
    type: ["null", float]
                 # int
    default: 50000000.0
    doc: Number of sampling points to be considered.
    inputBinding:
      prefix: --sampleSize 

  extraSampling:
    type: ["null", File]
    doc: BED file containing genomic regions for which extra sampling is required because they are underrepresented in the genome.
    inputBinding:
      prefix: --extraSampling 

  GCbiasFrequenciesFile:
    type: string
        # File

    doc: Path to save the file containing the observed and expected read frequencies per %%GC-content. This file is needed to run the correctGCBias tool. This is a text file.
    inputBinding:
      prefix: -freq 

  biasPlot:
    type: ["null", string]
    doc: If given, a diagnostic image summarizing the GC-bias will be saved.
    inputBinding:
      prefix: --biasPlot 

  regionSize:
    type: ["null", int]
    default: 300
    doc: To plot the reads per %%GC over a regionthe size of the region is required. By default, the bin size is set to 300 bases, which is close to the standard fragment size for Illumina machines. However, if the depth of sequencing is low, a larger bin size will be required, otherwise many bins will not overlap with any read
    inputBinding:
      prefix: --regionSize 

  plotFileFormat:
    type:
    - "null"
    - type: enum
      symbols: ['png', 'pdf', 'svg', 'eps']
    doc: image format type. If given, this option overrides the image format based on the plotFile ending. The available options are - "png", "eps", "pdf" and "svg"
    inputBinding:
      prefix: --plotFileFormat 

  region:
    type: ["null", string]
    doc: Region of the genome to limit the operation to - this is useful when testing parameters to reduce the computing time. The format is chr -start -end, for example --region chr10 or --region chr10 -456700 -891000.
    inputBinding:
      prefix: -r 

  blackListFileName:
    type: ["null", File]
                 # string
    doc: A BED file containing regions that should be excluded from all analyses. Currently this works by rejecting genomic chunks that happen to overlap an entry. Consequently, for BAM files, if a read partially overlaps a blacklisted rebin size is set to 300 bases, which is close to the standard fragment size for Illumina machines. However, if the depth of sequencing is low, a larger bin size will be required, otherwise many bins will not overlap with any read
    inputBinding:
      prefix: --regionSize 

  plotFileFormat:
    type:
    - "null"
    - type: enum
      symbols: ['png', 'pdf', 'svg', 'eps']
    doc: image format type. If given, this option overrides the image format based on the plotFile ending. The available options are - "png", "eps", "pdf" and "svg"
    inputBinding:
      prefix: --plotFileFormat 

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
