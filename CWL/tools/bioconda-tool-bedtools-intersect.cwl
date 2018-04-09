class: CommandLineTool

id: "bedtools_intersect"
label: "bedtools intersect"

cwlVersion: "v1.0"

doc: TODO 


s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-5283-7633
    s:email: mailto:heleneluessem@gmail.com
    s:name: Helene Luessem

requirements:
  - class: InlineJavascriptRequirement

baseCommand: ["bedtools", "intersect"]
stdout: $( inputs.outFileName )

outputs:

  outputFile:
    type: stdout

inputs:

  fileA:
    type: File
    inputBinding:
      position: 2
      prefix: -a
    doc: |
      Format is bed/gff/vcf/bam.

  fileB:
    type: File
    inputBinding:
      position: 3
      prefix: -b
    doc: |
      Format is bed/gff/vcf/bam.

  originalEntryA:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -wa
    doc: |
      Write the original entry in A for each overlap.

  originalEntryB:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -wb
    doc: |
      Write the original entry in B for each overlap.

  leftOuterJoin:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -loj
    doc: |
      Perform a "left outer join". That is, for each feature in A report each overlap with B.  If no overlaps are found, report a NULL feature for B.

  originalAB1:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -wo
    doc: |
      Write the original A and B entries plus the number of base pairs of overlap between the two features. 
      - Overlaps restricted by -f and -r. Only A features with overlap are reported.

  originalAB2:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -wao
    doc: |
      Write the original A and B entries plus the number of base pairs of overlap between the two features.
      - Overlapping features restricted by -f and -r. However, A features w/o overlap are also reported with a NULL B feature and overlap = 0.

  orginalAOnce:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -u
    doc: |
      Write the original A entry _once_ if _any_ overlaps found in B.
      - In other words, just report the fact >=1 hit was found.
      - Overlaps restricted by -f and -r.

  forAllAOverlaps:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -c
    doc: |
      For each entry in A, report the number of overlaps with B.
      - Reports 0 for A entries that have no overlap with B.
      - Overlaps restricted by -f and -r.

  allAWithoutOverlap:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -v
    doc: |
      Only report those entries in A that have _no overlaps_ with B.
      - Similar to "grep -v" (an homage).

  uncompressedBAM:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -ubam
    doc: |
      Write uncompressed BAM output. Default writes compressed BAM.

  requireSameStrandedness:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -s
    doc: |
      Require same strandedness.  That is, only report hits in B that overlap A on the _same_ strand.
      - By default, overlaps are reported without respect to strand.

  requireDiffStrandedness:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -S
    doc: |
      Require different strandedness.  That is, only report hits in B that overlap A on the _opposite_ strand.
      - By default, overlaps are reported without respect to strand.

  minOverlapReqA:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -f
    doc: |
      Minimum overlap required as a fraction of A.
      - Default is 1E-9 (i.e., 1bp).
      - FLOAT (e.g. 0.50)

  minOverlapReqB:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -F
    doc: |
      Minimum overlap required as a fraction of B.
      - Default is 1E-9 (i.e., 1bp).
      - FLOAT (e.g. 0.50)

  reciprocalOverlapAB:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -r
    doc: |
      Require that the fraction overlap be reciprocal for A AND B.
      - In other words, if -f is 0.90 and -r is used, this requires that B overlap 90% of A and A _also_ overlaps 90% of B.

  minFractionAOrB:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -e
    doc: |
      Require that the minimum fraction be satisfied for A OR B.
      - In other words, if -e is used with -f 0.90 and -F 0.10 this requires that either 90% of A is covered OR 10% of  B is covered. Without -e, both fractions would have to be satisfied.

  split:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -split
    doc: |
      Treat "split" BAM or BED12 entries as distinct BED intervals.

  genome:
    type: File?
    inputBinding:
      position: 5
      prefix: -g
    doc: |
      Provide a genome file to enforce consistent chromosome sort order across input files. Only applies when used with -sorted option.

  noNameCheck:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -nonamecheck
    doc: |
      For sorted data, don't throw an error if the file has different naming conventions for the same chromosome. ex. "chr1" vs "chr01".

  sorted:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -sorted
    doc: |
      Use the "chromsweep" algorithm for sorted (-k1,1 -k2,2n) input.

  names:
    type:
    - "null"
    - type: array
      items: string
    inputBinding:
      position: 5
      prefix: -names
    doc: |
      When using multiple databases, provide an alias for each that will appear instead of a fileId when also printing the DB record.

  fileNames:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -filenames
    doc: |
      When using multiple databases, show each complete filename instead of a fileId when also printing the DB record.

  sortOut:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -sortout
    doc: |
      When using multiple databases, sort the output DB hits for each record.

  bed:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -bed
    doc: |
      If using BAM input, write output as BED.

  header:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -header
    doc: |
      Print the header from the A file prior to results.

  noBuf:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -nobuf
    doc: |
      Disable buffered output. Using this option will cause each line of output to be printed as it is generated, rather than saved in a buffer. This will make printing large output files noticeably slower, but can be useful in conjunction with other software tools and scripts that need to process one line of bedtools output at a time.

  iobuf:
    type: boolean?
    inputBinding:
      position: 5
      prefix: -iobuf
    doc: |
      Specify amount of memory to use for input buffer.	Takes an integer argument. Optional suffixes K/M/G supported. Note: currently has no effect with compressed files.


doc: |
  Usage:   bedtools intersect [OPTIONS] -a <bed/gff/vcf/bam> -b <bed/gff/vcf/bam>

  Note: -b may be followed with multiple databases and/or 
  wildcard (*) character(s). 

  Options: 
    -wa    Write the original entry in A for each overlap.
    -wb	   Write the original entry in B for each overlap.
           - Useful for knowing _what_ A overlaps. Restricted by -f and -r.
    -loj   Perform a "left outer join". That is, for each feature in A
           report each overlap with B.  If no overlaps are found, 
           report a NULL feature for B.
    -wo    Write the original A and B entries plus the number of base
           pairs of overlap between the two features.
           - Overlaps restricted by -f and -r.
           Only A features with overlap are reported.
    -wao   Write the original A and B entries plus the number of base
           pairs of overlap between the two features.
           - Overlapping features restricted by -f and -r.
           However, A features w/o overlap are also reported
           with a NULL B feature and overlap = 0.
    -u	   Write the original A entry _once_ if _any_ overlaps found in B.
           - In other words, just report the fact >=1 hit was found.
           - Overlaps restricted by -f and -r.
    -c	   For each entry in A, report the number of overlaps with B.
           - Reports 0 for A entries that have no overlap with B.
           - Overlaps restricted by -f and -r.
    -v 	   Only report those entries in A that have _no overlaps_ with B.
           - Similar to "grep -v" (an homage).
    -ubam  Write uncompressed BAM output. Default writes compressed BAM.
    -s     Require same strandedness.  That is, only report hits in B
           that overlap A on the _same_ strand.
           - By default, overlaps are reported without respect to strand.
    -S	   Require different strandedness.  That is, only report hits in B
           that overlap A on the _opposite_ strand.
           - By default, overlaps are reported without respect to strand.
    -f     Minimum overlap required as a fraction of A.
           - Default is 1E-9 (i.e., 1bp).
           - FLOAT (e.g. 0.50)
    -F      Minimum overlap required as a fraction of B.
           - Default is 1E-9 (i.e., 1bp).
           - FLOAT (e.g. 0.50)
    -r      Require that the fraction overlap be reciprocal for A AND B.
           - In other words, if -f is 0.90 and -r is used, this requires
           that B overlap 90% of A and A _also_ overlaps 90% of B.
    -e	   Require that the minimum fraction be satisfied for A OR B.
           - In other words, if -e is used with -f 0.90 and -F 0.10 this requires
           that either 90% of A is covered OR 10% of  B is covered.
           Without -e, both fractions would have to be satisfied.
    -spli  Treat "split" BAM or BED12 entries as distinct BED intervals.
    -g     Provide a genome file to enforce consistent chromosome sort order
           across input files. Only applies when used with -sorted option.
    -nonamecheck	
           For sorted data, don't throw an error if the file has different naming conventions
           for the same chromosome. ex. "chr1" vs "chr01".
    -sorted
           Use the "chromsweep" algorithm for sorted (-k1,1 -k2,2n) input.
    -names When using multiple databases, provide an alias for each that
           will appear instead of a fileId when also printing the DB record.
    -filenames	
           When using multiple databases, show each complete filename
           instead of a fileId when also printing the DB record.
    -sortout	
           When using multiple databases, sort the output DB hits
           for each record.
    -bed   If using BAM input, write output as BED.
    -heade Print the header from the A file prior to results.
    -nobuf Disable buffered output. Using this option will cause each line
           of output to be printed as it is generated, rather than saved
           in a buffer. This will make printing large output files 
           noticeably slower, but can be useful in conjunction with
           other software tools and scripts that need to process one
           line of bedtools output at a time.
    -iobuf Specify amount of memory to use for input buffer.
           Takes an integer argument. Optional suffixes K/M/G supported.
           Note: currently has no effect with compressed files.

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
