cwlVersion: v1.0
class: Workflow

#s:author:
#  - class: s:Person
#    s:identifier: https://orcid.org/0000-0002-5283-7633
#    s:email: mailto:heleneluessem@gmail.com
#    s:name: Helene Luessem

requirements:
  - class: ScatterFeatureRequirement
  - class: SubworkflowFeatureRequirement
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement

inputs:

#---------- Number of Processors------------------------------------

  deeptoolsParallel_nWF: int

  sambambaParallel_nWF : int


#---------- Files and Prefixes -------------------------------------

  # Filtered bamfile GALvX_Histone
  filteredBamFile_nWF: File

  # Filtered input bamfile: GALvX_Input
  filteredBamFile_Input_nWF: File


  filePrefix_nWF: string


#---------- Genome size --------------------------------------------

  genomeSize_nWF: int


#---------- Blacklist Regions --------------------------------------

  blacklistRegions_nWF: File



outputs:

  # DEEPID.PROC.DATE.ASSM.filt.bamcov
  - id: out_step1
    type: File
    outputSource: "#generateCoverageForFilteredBam/outputFile"
   
  # DEEPID.PROC.DATE.ASSM.macs.out
  - id: out_step10.1
    type: File
    outputSource: "#zipMacsFilesN/outputZipFile"
   
#-------------------------------------------------------------------
# ---------------------------------------------------------------
  
   
steps:

#---------- Step 11: histoneHMM ------------------------------------
# TODO: Missing


#---------- Step 12: makeHistoneHMMBedLike -------------------------
# TODO: Missing


#---------- Step 13: zipSecHistoneHMMFiles -------------------------
# TODO: Missing


#---------- Step 16: intersectHistoneHMMFiles ----------------------

  intersectHistoneHMMFiles:
    run: ../tools/bioconda-tool-bedtools-intersect.cwl
    in:
      originalAOnce:
        valueFrom: $( 1==1 )
      fileA:
        valueFrom: dummyFileA    # TODO: Which file? 
      fileB:
        valueFrom: dummyFileB    # TODO: Which file?
#      outFileName: TODO: Which name?

      # ~Additional inputs~
      # TODO
      
    out:
      - outputFile


$namespaces:
  s: https://schema.org/
  edam: http://edamontology.org/

$schemas:
  - https://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl
            
