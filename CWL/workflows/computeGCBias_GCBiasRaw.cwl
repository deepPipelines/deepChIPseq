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

  genomeSize:
    type: int

  genome:
    type: File

  fragmentLength:
    type: int

  gcFreqFile:
    type: string

  biasPlot:
   type: string


outputs:

  signalCovTrack:
    type: File


steps:
  
  generateSignalCovTrack:
    run: ../tools/deepTools-tool-computeGCBias.cwl
    in:
      numberOfProcessors: deeptoolsParallel
      bamfile: bamFile
      effectiveGenomeSize: genomeSize
      genome: genome
      sampleSize: 50000000.0
      fragmentLength: fragmentLength
      GCbiasFrequenciesFile: gcFreqFile
      biasPlot: biasPlot
      plotFileFormat: "svg"
    out:
      - GCbiasFrequenciesFile_out
      

$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
