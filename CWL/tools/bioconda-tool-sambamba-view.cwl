cwlVersion: cwl:draft-3
class: CommandLineTool
baseCommand: [sambamba, view]
inputs:
- id: bamfile
  type: File
  inputBinding:
    position: 1
- id: format
  type: string
  inputBinding:
    position: 2
    prefix: --format=
    separate: false
- id: output_filename
  type: string
  inputBinding:
    position: 3
    prefix: --output-filename
- id: filter
  type: string
  inputBinding:
    position: 4
    prefix: --filter=
    separate: false

outputs:
- id: outputfile
  type: File
  outputBinding:
    glob: test1.bam
