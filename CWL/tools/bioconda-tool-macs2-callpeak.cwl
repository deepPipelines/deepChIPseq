class: CommandLineTool

id: "macs2_callpeak"
label: "macs2 callpeak"

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

baseCommand: ["macs2", "callpeak"]

stdout: $( inputs.outputFileName )

outputs:
  
  outputBamFile:
    type: stdout

inputs:

  tFile:
    type: File
    inputBinding:
      position: 10 
      prefix: -t
    doc: |
      ChIP-seq treatment file. If multiple files are given as '-t A B C', then they will all be read and pooled  together. REQUIRED.

  cFile:
    type: File?
    inputBinding:
      position: 15
      prefix: -c
    doc: |
      Control file. If multiple files are given as '-c A B C', they will be pooled to estimate ChIP-seq background noise.

  format:
    type: 
      - 'null'
      - type: enum
        symbols: [AUTO, BAM, SAM, BED, ELAND, ELANDMULTI, ELANDEXPORT, BOWTIE, BAMPE, BEDPE]
    inputBinding:
      position: 20
      prefix: -f
    doc: |
      Format of tag file, "AUTO", "BED" or "ELAND" or "ELANDMULTI" or "ELANDEXPORT" or "SAM" or "BAM" or "BOWTIE" or "BAMPE" or "BEDPE". The default AUTO option will let MACS decide which format (except for BAMPE and BEDPE which should be implicitly set) the file is. Please check the definition in README. Please note that if the format is set as BAMPE or BEDPE, MACS2 will call its special Paired-end mode to call peaks by piling up the actual ChIPed fragments defined by both aligned ends, instead of predicting the fragment size first and extending reads. Also please note that the BEDPE only contains three columns, and is NOT the same BEDPE format used by BEDTOOLS. DEFAULT: "AUTO"

  gSize:
    type: string?
    inputBinding:
      position: 25
      prefix: -g
    doc: |
      Effective genome size. It can be 1.0e+9 or 1000000000, or shortcuts:'hs' for human (2.7e9), 'mm' for mouse (1.87e9), 'ce' for C. elegans (9e7) and 'dm' for fruitfly (1.2e8), Default:hs
  
  keepDup:   
    type: File?
    inputBinding:
      position: 30
      prefix: --keep-dup
    doc: |
      It controls the MACS behavior towards duplicate tags at the exact same location -- the same coordination and the same strand. The 'auto' option makes MACS calculate the maximum tags at the exact same location based on binomal distribution using 1e-5 as pvalue cutoff; and the 'all' option keeps every tags. If an integer is given, at most this number of tags will be kept at the same location. Note, if you've used samtools or picard to flag reads as 'PCR/Optical duplicate' in bit 1024, MACS2 will still read them although the reads may be decided by MACS2 as duplicate later. The default is to keep one tag at the same location. Default: 1
  
  bufferSize:
    type: int?
    inputBinding:
      position: 35
      prefix: --buffer-size
    doc: |
      Buffer size for incrementally increasing internal array size to store reads alignment information. In most cases, you don't have to change this parameter. However, if there are large number of chromosomes/contigs/scaffolds in your alignment, it's recommended to specify a smaller buffer size in order to decrease memory usage (but it will take longer time to read alignment files). Minimum memory requested for reading an alignment file is about # of CHROMOSOME * BUFFER_SIZE * 2 Bytes. DEFAULT: 100000
  
  outDir:
    type: string?
    inputBinding:
      position: 40
      prefix: --outdir
    doc: |
      If specified all output files will be written to that directory. Default: the current working directory

  name:
    type: string?
    inputBinding:
      position: 45
      prefix: -n
    doc: |
      Experiment name, which will be used to generate output file names. DEFAULT: "NA"
  
  bdg:
    type: boolean?
    inputBinding:
      position: 50
      prefix: -B
    doc: |
      Whether or not to save extended fragment pileup, and local lambda tracks (two files) at every bp into a bedGraph file. DEFAULT: False

  verbose:
    type: int?
    inputBinding:
      position: 55
      prefix: --verbose
    doc: |
      Set verbose level of runtime message. 0: only show critical message, 1: show additional warning message, 2: show process information, 3: show debug messages. DEFAULT:2  

  trackline:
    type: boolean?
    inputBinding:
      position: 60
      prefix: -trackline
    doc: |
      Tells MACS to include trackline with bedGraph files. To include this trackline while displaying bedGraph at UCSC genome browser, can show name and description of the file as well. However my suggestion is to convert bedGraph to bigWig, then show the smaller and faster binary bigWig file at UCSC genome browser, as well as downstream analysis. Require -B to be set. Default: Not include trackline.
   
  spmr:
    type: boolean?
    inputBinding:
      position: 65
      prefix: --SPMR
    doc: |
      If True, MACS will save signal per million reads for fragment pileup profiles. Require -B to be set. Default: False
  
  tSize:
    type: int?
    inputBinding:
      position: 70
      prefix: -s
    doc: |
      Tag size. This will override the auto detected tag size. DEFAULT: Not set

  bw:
    type: int?
    inputBinding:
      position: 75
      prefix: --bw
    doc: |
      Band width for picking regions to compute fragment size. This value is only used while building the shifting model. DEFAULT: 300
  
  mFold:
    type: string?
    inputBinding:
      position: 80
      prefix: -m
    doc: |
      Select the regions within MFOLD range of high-confidence enrichment ratio against background to build model. Fold-enrichment in regions must be lower than upper limit, and higher than the lower limit. Use as "-m 10 30". DEFAULT:5 50
  
  fixBimodal:
    type: boolean?
    inputBinding:
      position: 85
      prefix: --fix-bimodal
    doc: |
      Whether turn on the auto pair model process. If set, when MACS failed to build paired model, it will use the nomodel settings, the --exsize parameter to extend each tags towards 3' direction. Not to use this automate fixation is a default behavior now. DEFAULT: False

  noModel:
    type: boolean?
    inputBinding:
      position: 90
      prefix: --nomodel
    doc: |
      Whether or not to build the shifting model. If True, MACS will not build model. by default it means shifting size = 100, try to set extsize to change it. DEFAULT: False

  shift:
    type: int?
    inputBinding:
      position: 95
      prefix: --shift
    doc: |
      (NOT the legacy --shiftsize option!) The arbitrary shift in bp. Use discretion while setting it other than default value. When NOMODEL is set, MACS will use this value to move cutting ends (5') towards 5'->3' direction then apply EXTSIZE to extend them to fragments. When this value is negative, ends will be moved toward 3'->5' direction. Recommended to keep it as default 0 for ChIP-Seq datasets, or -1 * half of EXTSIZE together with EXTSIZE option for detecting enriched cutting loci such as certain DNAseI-Seq datasets. Note, you can't set values other than 0 if format is BAMPE or BEDPE for paired-end data. DEFAULT: 0.
  
  extSize:
    type: int?
    inputBinding:
      position: 100
      prefix: --extsize
    doc: |
      (NOT the legacy --shiftsize option!) The arbitrary shift in bp. Use discretion while setting it other than default value. When NOMODEL is set, MACS will use this value to move cutting ends (5') towards 5'->3' direction then apply EXTSIZE to extend them to fragments. When this value is negative, ends will be moved toward 3'->5' direction. Recommended to keep it as default 0 for ChIP-Seq datasets, or -1 * half of EXTSIZE together with EXTSIZE option for detecting enriched cutting loci such as certain DNAseI-Seq datasets. Note, you can't set values other than 0 if format is BAMPE or BEDPE for paired-end data. DEFAULT: 0.
  
  qValue:
    type: float?
    inputBinding:
      position: 105
      prefix: -q
    doc: |
      Minimum FDR (q-value) cutoff for peak detection. DEFAULT: 0.05. -q, and -p are mutually exclusive.
  
  pValue:
    type: float?
    inputBinding:
      position: 110
      prefix: -p
    doc: |
      Pvalue cutoff for peak detection. DEFAULT: not set. -q, and -p are mutually exclusive. If pvalue cutoff is set, qvalue will not be calculated and reported as -1 in the final .xls file.
  
  toLarge:
    type: boolean?
    inputBinding:
      position: 115
      prefix: --to-large
    doc: |
       When set, scale the small sample up to the bigger sample. By default, the bigger dataset will be scaled down towards the smaller dataset, which will lead to smaller p/qvalues and more specific results. Keep in mind that scaling down will bring down background noise more. DEFAULT: False
  
  ratio:
    type: float?
    inputBinding:
      position: 120
      prefix: --ratio
    doc: |
      When set, use a custom scaling ratio of ChIP/control (e.g. calculated using NCIS) for linear scaling. DEFAULT: ingore
  
  downSample:
    type: boolean?
    inputBinding:
      position: 125
      prefix: --down-sample
    doc: |
      When set, random sampling method will scale down the bigger sample. By default, MACS uses linear scaling. Warning: This option will make your result unstable and irreproducible since each time, random reads would be selected. Consider to use 'randsample' script instead. <not implmented>If used together with --SPMR, 1 million unique reads will be randomly picked.</not implemented> Caution: due to the implementation, the final number of selected reads may not be as you expected! DEFAULT: False

  seed:
    type: int?
    inputBinding:
      position: 130
      prefix: --seed
    doc: |
      Set the random seed while down sampling data. Must be a non-negative integer in order to be effective. DEFAULT: not set

  tempDir:
    type: string?
    inputBinding:
      position: 135
      prefix: --tempdir
    doc: |
      Optional directory to store temp files. DEFAULT: /tmp
  
  noLambda:
    type: boolean?
    inputBinding:
      position: 140
      prefix: --nolambda
    doc: |
      If True, MACS will use fixed background lambda as local lambda for every peak region. Normally, MACS calculates a dynamic local lambda to reflect the local bias due to potential chromatin structure.

  sLocal:
    type: int?
    inputBinding:
      position: 145
      prefix: --slocal
    doc: |
      The small nearby region in basepairs to calculate dynamic lambda. This is used to capture the bias near the peak summit region. Invalid if there is no control data. If you set this to 0, MACS will skip slocal lambda calculation. *Note* that MACS will always perform a d-size local lambda calculation. The final local bias should be the maximum of the lambda value from d, slocal, and llocal size windows. DEFAULT: 1000

  lLocal:
    type: int?
    inputBinding:
      position: 150
      prefix: --llocal
    doc: |
      The large nearby region in basepairs to calculate dynamic lambda. This is used to capture the surround bias. If you set this to 0, MACS will skip llocal lambda calculation. *Note* that MACS will always perform a d-size local lambda calculation. The final local bias should be the maximum of the lambda value from d, slocal, and llocal size windows. DEFAULT: 10000.
  
  broad:
    type: boolean?
    inputBinding:
      position: 155
      prefix: --broad
    doc: |
      If set, MACS will try to call broad peaks by linking nearby highly enriched regions. The linking region is controlled by another cutoff through --linking-cutoff. The maximum linking region length is 4 times of d from MACS. DEFAULT: False
  
  broadCutoff:
    type: float?
    inputBinding:
      position: 160
      prefix: --broad-cutoff
    doc: |
      Cutoff for broad region. This option is not available unless --broad is set. If -p is set, this is a pvalue cutoff, otherwise, it's a qvalue cutoff. DEFAULT: 0.1

  cutoffAnalysis:
    type: boolean?
    inputBinding:
      position: 165
      prefix: --cutoff-analysis
    doc: |
      While set, MACS2 will analyze number or total length of peaks that can be called by different p-value cutoff then output a summary table to help user decide a better cutoff. The table will be saved in NAME_cutoff_analysis.txt file. Note, minlen and maxgap may affect the results. WARNING: May take ~30 folds longer time to finish. DEFAULT: False
  
  callSummits:
    type: boolean?
    inputBinding:
      position: 170
      prefix: --call-summits
    doc: |
      If set, MACS will use a more sophisticated signal processing approach to find subpeak summits in each enriched peak region. DEFAULT: False

  feCutoff:
    type: float?
    inputBinding:
      position: 175
      prefix: --fe-cutoff
    doc: |
      When set, the value will be used to filter out peaks with low fold-enrichment. Note, MACS2 use 1.0 as pseudocount while calculating fold-enrichment. DEFAULT: 1.0

doc: |
  usage: macs2 callpeak [-h] -t TFILE [TFILE ...] [-c [CFILE [CFILE ...]]]
                      [-f {AUTO,BAM,SAM,BED,ELAND,ELANDMULTI,ELANDEXPORT,BOWTIE,BAMPE,BEDPE}]
                      [-g GSIZE] [--keep-dup KEEPDUPLICATES]
                      [--buffer-size BUFFER_SIZE] [--outdir OUTDIR] [-n NAME]
                      [-B] [--verbose VERBOSE] [--trackline] [--SPMR]
                      [-s TSIZE] [--bw BW] [-m MFOLD MFOLD] [--fix-bimodal]
                      [--nomodel] [--shift SHIFT] [--extsize EXTSIZE]
                      [-q QVALUE | -p PVALUE] [--to-large] [--ratio RATIO]
                      [--down-sample] [--seed SEED] [--tempdir TEMPDIR]
                      [--nolambda] [--slocal SMALLLOCAL] [--llocal LARGELOCAL]
                      [--broad] [--broad-cutoff BROADCUTOFF]
                      [--cutoff-analysis] [--call-summits]
                      [--fe-cutoff FECUTOFF]
  optional arguments:
       -h                    show this help message and exit                       
  Input files arguments:
       -t TFILE [TFILE ...]  ChIP-seq treatment file. If multiple files are given 
                             as '-t A B C', then they will all be read and pooled 
                             together. REQUIRED.
       -c [CFILE [CFILE ...]]Control file. If multiple files are given as '-c A B
                             C', they will be pooled to estimate ChIP-seq
                             background noise.
       -f {AUTO,BAM,SAM,BED,ELAND,ELANDMULTI,ELANDEXPORT,BOWTIE,BAMPE,BEDPE}
                             Format of tag file, "AUTO", "BED" or "ELAND" or
                             "ELANDMULTI" or "ELANDEXPORT" or "SAM" or "BAM" or
                             "BOWTIE" or "BAMPE" or "BEDPE". The default AUTO
                             option will let MACS decide which format (except for
                             BAMPE and BEDPE which should be implicitly set) the
                             file is. Please check the definition in README. Please
                             note that if the format is set as BAMPE or BEDPE,
                             MACS2 will call its special Paired-end mode to call
                             peaks by piling up the actual ChIPed fragments defined
                             by both aligned ends, instead of predicting the
                             fragment size first and extending reads. Also please
                             note that the BEDPE only contains three columns, and
                             is NOT the same BEDPE format used by BEDTOOLS.
                             DEFAULT: "AUTO"
       -g GSIZE              Effective genome size. It can be 1.0e+9 or 1000000000,
                             or shortcuts:'hs' for human (2.7e9), 'mm' for mouse
                             (1.87e9), 'ce' for C. elegans (9e7) and 'dm' for
                             fruitfly (1.2e8), Default:hs
       --keep-dup KEEPDUPLICATES
                             It controls the MACS behavior towards duplicate tags
                             at the exact same location -- the same coordination
                             and the same strand. The 'auto' option makes MACS
                             calculate the maximum tags at the exact same location
                             based on binomal distribution using 1e-5 as pvalue
                             cutoff; and the 'all' option keeps every tags. If an
                             integer is given, at most this number of tags will be
                             kept at the same location. Note, if you've used
                             samtools or picard to flag reads as 'PCR/Optical
                             duplicate' in bit 1024, MACS2 will still read them
                             although the reads may be decided by MACS2 as
                             duplicate later. The default is to keep one tag at the
                             same location. Default: 1
       --buffer-size BUFFER_SIZE
                             Buffer size for incrementally increasing internal
                             array size to store reads alignment information. In
                             most cases, you don't have to change this parameter.
                             However, if there are large number of
                             chromosomes/contigs/scaffolds in your alignment, it's
                             recommended to specify a smaller buffer size in order
                             to decrease memory usage (but it will take longer time
                             to read alignment files). Minimum memory requested for
                             reading an alignment file is about # of CHROMOSOME *
                             BUFFER_SIZE * 2 Bytes. DEFAULT: 100000
  Output arguments:
       --outdir OUTDIR       If specified all output files will be written to that
                             directory. Default: the current working directory
       -n NAME               Experiment name, which will be used to generate output
                             file names. DEFAULT: "NA"
       -B                    Whether or not to save extended fragment pileup, and
                             local lambda tracks (two files) at every bp into a
                             bedGraph file. DEFAULT: False
       --verbose VERBOSE     Set verbose level of runtime message. 0: only show
                             critical message, 1: show additional warning message,
                             2: show process information, 3: show debug messages.
                             DEFAULT:2
       --trackline           Tells MACS to include trackline with bedGraph files.
                             To include this trackline while displaying bedGraph at
                             UCSC genome browser, can show name and description of
                             the file as well. However my suggestion is to convert
                             bedGraph to bigWig, then show the smaller and faster
                             binary bigWig file at UCSC genome browser, as well as
                             downstream analysis. Require -B to be set. Default:
                             Not include trackline.
       --SPMR                If True, MACS will save signal per million reads for
                             fragment pileup profiles. Require -B to be set.
                             Default: False
  Shifting model arguments:
       -s TSIZE              Tag size. This will override the auto detected tag
                             size. DEFAULT: Not set
       --bw BW               Band width for picking regions to compute fragment
                             size. This value is only used while building the
                             shifting model. DEFAULT: 300
       -m MFOLD MFOLD        Select the regions within MFOLD range of high-
                             confidence enrichment ratio against background to
                             build model. Fold-enrichment in regions must be lower
                             than upper limit, and higher than the lower limit. Use
                             as "-m 10 30". DEFAULT:5 50
       --fix-bimodal         Whether turn on the auto pair model process. If set,
                             when MACS failed to build paired model, it will use
                             the nomodel settings, the --exsize parameter to extend
                             each tags towards 3' direction. Not to use this
                             automate fixation is a default behavior now. DEFAULT:
                             False
       --nomodel             Whether or not to build the shifting model. If True,
                             MACS will not build model. by default it means
                             shifting size = 100, try to set extsize to change it.
                             DEFAULT: False
       --shift SHIFT         (NOT the legacy --shiftsize option!) The arbitrary
                             shift in bp. Use discretion while setting it other
                             than default value. When NOMODEL is set, MACS will use
                             this value to move cutting ends (5') towards 5'->3'
                             direction then apply EXTSIZE to extend them to
                             fragments. When this value is negative, ends will be
                             moved toward 3'->5' direction. Recommended to keep it
                             as default 0 for ChIP-Seq datasets, or -1 * half of
                             EXTSIZE together with EXTSIZE option for detecting
                             enriched cutting loci such as certain DNAseI-Seq
                             datasets. Note, you can't set values other than 0 if
                             format is BAMPE or BEDPE for paired-end data. DEFAULT:
                             0.
       --extsize EXTSIZE     The arbitrary extension size in bp. When nomodel is
                             true, MACS will use this value as fragment size to
                             extend each read towards 3' end, then pile them up.
                             It's exactly twice the number of obsolete SHIFTSIZE.
                             In previous language, each read is moved 5'->3'
                             direction to middle of fragment by 1/2 d, then
                             extended to both direction with 1/2 d. This is
                             equivalent to say each read is extended towards 5'->3'
                             into a d size fragment. DEFAULT: 200. EXTSIZE and
                             SHIFT can be combined when necessary. Check SHIFT
                             option.
  Peak calling arguments:
       -q QVALUE             Minimum FDR (q-value) cutoff for peak detection.
                             DEFAULT: 0.05. -q, and -p are mutually exclusive.
       -p PVALUE             Pvalue cutoff for peak detection. DEFAULT: not set.
                             -q, and -p are mutually exclusive. If pvalue cutoff is
                             set, qvalue will not be calculated and reported as -1
                             in the final .xls file.
       --to-large            When set, scale the small sample up to the bigger
                             sample. By default, the bigger dataset will be scaled
                             down towards the smaller dataset, which will lead to
                             smaller p/qvalues and more specific results. Keep in
                             mind that scaling down will bring down background
                             noise more. DEFAULT: False
       --ratio RATIO         When set, use a custom scaling ratio of ChIP/control
                             (e.g. calculated using NCIS) for linear scaling.
                             DEFAULT: ingore
       --down-sample         When set, random sampling method will scale down the
                             bigger sample. By default, MACS uses linear scaling.
                             Warning: This option will make your result unstable
                             and irreproducible since each time, random reads would
                             be selected. Consider to use 'randsample' script
                             instead. <not implmented>If used together with --SPMR,
                             1 million unique reads will be randomly picked.</not
                             implemented> Caution: due to the implementation, the
                             final number of selected reads may not be as you
                             expected! DEFAULT: False
       --seed SEED           Set the random seed while down sampling data. Must be
                             a non-negative integer in order to be effective.
                             DEFAULT: not set
       --tempdir TEMPDIR     Optional directory to store temp files. DEFAULT: /tmp
       --nolambda            If True, MACS will use fixed background lambda as
                             local lambda for every peak region. Normally, MACS
                             calculates a dynamic local lambda to reflect the local
                             bias due to potential chromatin structure.
       --slocal SMALLLOCAL   The small nearby region in basepairs to calculate
                             dynamic lambda. This is used to capture the bias near
                             the peak summit region. Invalid if there is no control
                             data. If you set this to 0, MACS will skip slocal
                             lambda calculation. *Note* that MACS will always
                             perform a d-size local lambda calculation. The final
                             local bias should be the maximum of the lambda value
                             from d, slocal, and llocal size windows. DEFAULT: 1000
       --llocal LARGELOCAL   The large nearby region in basepairs to calculate
                             dynamic lambda. This is used to capture the surround
                             bias. If you set this to 0, MACS will skip llocal
                             lambda calculation. *Note* that MACS will always
                             perform a d-size local lambda calculation. The final
                             local bias should be the maximum of the lambda value
                             from d, slocal, and llocal size windows. DEFAULT:
                             10000.
       --broad               If set, MACS will try to call broad peaks by linking
                             nearby highly enriched regions. The linking region is
                             controlled by another cutoff through --linking-cutoff.
                             The maximum linking region length is 4 times of d from
                             MACS. DEFAULT: False
       --broad-cutoff BROADCUTOFF
                             Cutoff for broad region. This option is not available
                             unless --broad is set. If -p is set, this is a pvalue
                             cutoff, otherwise, it's a qvalue cutoff. DEFAULT: 0.1
       --cutoff-analysis     While set, MACS2 will analyze number or total length
                             of peaks that can be called by different p-value
                              cutoff then output a summary table to help user decide
                             a better cutoff. The table will be saved in
                             NAME_cutoff_analysis.txt file. Note, minlen and maxgap
                             may affect the results. WARNING: May take ~30 folds
                             longer time to finish. DEFAULT: False
  Post-processing options:
       --call-summits        If set, MACS will use a more sophisticated signal
                             processing approach to find subpeak summits in each
                             enriched peak region. DEFAULT: False
       --fe-cutoff FECUTOFF  When set, the value will be used to filter out peaks
                             with low fold-enrichment. Note, MACS2 use 1.0 as
                             pseudocount while calculating fold-enrichment.
                             DEFAULT: 1.0

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
