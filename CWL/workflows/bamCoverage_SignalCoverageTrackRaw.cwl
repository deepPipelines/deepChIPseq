cwlVersion: v1.0
class: Workflow

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-5283-7633
    s:email: mailto:heleneluessem@gmail.com
    s:name: Helene Luessem

inputs:

  deeptoolsParallel:
    type: int

  bamFile:
    type: File
 
  outName:
    type: string

  normalize:
    type: int


outputs:

  signalCovTrack:
    type: File


steps:
  
  generateSignalCovTrack:
    run: ../tools/deepTools-tool-bamCoverage.cwl
    in:
      numberOfProcessors: deeptoolsParallel
      binSize: 
        valueFrom: $( 25)
      bam: bamFile
      outFileName: outName
      outFileFormat: 
        valueFrom: bigwig
      normalizeTo1x: normalize
    out:
      - outputFile


$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl

