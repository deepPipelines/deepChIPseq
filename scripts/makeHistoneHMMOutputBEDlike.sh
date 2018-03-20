#!/usr/bin/env bash

stdName="DEEPID.PROC.DATE.ASSM.hhmm.emfit"

cut -f 1,4,5,9 DEEPID-regions.gff | sort -V -k1,2 > DEEPID.hmm.bed && mv DEEPID-zinba-emfit.pdf $stdName
