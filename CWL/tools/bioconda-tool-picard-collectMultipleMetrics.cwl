#!/usr/bin/env cwl-runner

class: CommandLineTool

id: "Picard_CollectMultipleMetrics"
label: "Picard CollectMultipleMetrics

cwlVersion: "v1.0"

doc: |
	A Docker container containing the Picard jar file. See the [Picard](http://broadinstitue.github.io/picard/) webpage for more information

s:author:
	-class: s:Person
	 s:identifier: https://orcid.org/0000-0001-6231-4417
	 s:email: mailto:karl.nordstroem@uni-saarland.de
	 s:name: Karl Nordström

requirements:
	-class: InlineJavascriptRequirement

hints:
	-class: ResourceRequirement
	 coresMin: 1
	 ramMin: 4092
	 outdirMin: 512000
	-class: DockerRequirement
	 dockerPull: "quay.io/biocontainers/picard:2.17.2--py36_0"

baseCommand: ["picard", "CollectMultipleMetrics"]

outputs:

	OUTPUT_output:
		type: File
		outputBinding:
			glob: $(inputs.OUTPUT)



inputs:
	
	ASSUME_SORTED
	inputBinding:
		position: 5
		prefix: "ASSUME_SORTED"
		separate: false
	type: boolean?
	doc: |
		if true (default), then the sort order in the header file will be ignored. Default value: true. This option can be set to 'null' to clear the default value. Possible values: [true, false]

	STOP_AFTER
	inputBinding: 
		position: 5
		prefix: "STOP_AFTER"
		separate: false
	type: int?
	doc: |
		Stop after processing N reads, mainly for debugging. Default value: 0. This option can be set to 'null' to clear the default value.

	METRIC_ACCUMULATION_LEVEL
	inputBinding: 
		position: 5
		prefix "METRIC_ACCUMULATION_LEVEL"
		separate: false
	type: MetricAccumulationLevel??
	doc: |
		The level(s) at wich to accumulate metrics. Default value: [ALL_READS]. This option can be set to 'null' to clear the default value. Possible values: [ALL_READS, SAMPLE, LIBRARY, READ_GROUP]. This option may be specified 0 or more times. This option can be set to 'null' to clear the default list.

	FILE_EXTENSION
	inputBinding: 
		position: 5
		prefix "FILE_EXTENSION"
		separate: false
	type: string?
	doc: |
		Append the given file extension to all metric file names (ex. OUTPUT.insert_size_metrics.EXT). None if null. Default value: null

	PROGRAM
	inputBinding: 
		position: 5
		prefix "PROGRAM"
		separate: false
	type: Program??		
	doc: |
		Set of metrics programs to apply during the pass through the SAM file. Default value: [CollectAlignmentSummaryMetrics, CollectSizeMetrics, MeanQualityByCycle, QualityScoreDistribution]. This option can be set to 'null' to clear the default value. Possible values: [CollectAlignmentSummaryMetrics, CollectInsertSizeMetrics, QualityScoreDistribution, MeanQualityByCycle, CollectBaseDistributionByCycle, CollectGcBiasMetrics, RnaSeqMetrics, CollectSequencingArtifactMetrics, CollectQualityYieldMetrics]. This option may be specified 0 or more times. This option can be set to 'null' to clear the default list.
	
	INTERVALS
	inputBinding: 
		position: 5
		prefix "INTERVALS"
		separate: false
	type: File?
	doc: |
		An optional list of intervals to restrict analysis to. Only pertains to some of the PROGRAMs. Programs whose stand-alone CLP does not have an INTERVALS argument will silently ignore this argument. Default value: null

	DB_SNP
	inputBinding: 
		position: 5
		prefix: "DB_SNP"
		separate: false
	type: File?
	doc: |
		VCF format dbSNP file, used to exclude regions around known polymorphisms from analysis by some PROGRAMs; PROGRAMs whose CLP doesn't alllow for this argument will quietly ignore it. Default value: null.

	INCLUDE_UNPAIRED
	inputBinding: 
		position: 5
		prefix: "INCLUDE_UNPAIRED"
		separate: false
	type: boolean?
	doc: |
		Include unpaired reads in CollectSequencingArtifactMetrics. If set to true then all paired reads will be included as well - MINIMUM_INSERT_SIZE and MAXIMUM_INSERT_SIZE will be ignored in CollectSequencingArtifactMetrics. Default value: false. This option can be set to 'null' to clear the default value. Possible values: [true, false]

	#is this correct? Can there be more than one input file?
	INPUT: 
	inputBinding: 
		position: 5
		prefix: "INPUT="
		separate: false
	type: 
		- File
		- type array
		items: File
		inputBinding:
			itemSeparator: "INPUT="
	doc: |
		Input SAM or BAM file. Required.
	
	#is this correct? 	
	OUTPUT: 
		inputBinding: 
			position: 5
			prefix: "OUTPUT="
			separate: false
		type: string
		doc: |
			Base name of output files. Required.

$namespaces: 
	s: https://schema.org/
	edam: http://edamontology.org/

$schemas:
	- https://schema.org/docs/schema_org_rdfa.html
	- http://edamontology.org/EDAM_1.18.owl
