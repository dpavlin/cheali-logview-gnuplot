(
#echo "		s	V	mA	mAh				temp	Vinput	V1	V2	V3	V4	V5	V6	R1	R2	R3	R4	R5	R6	Rb	Rw			"
                                             echo -e "t	V	mA	mAh	temp	Vinput	V1	V2	V3	V4	V5	V6	R1	R2	R3	R4	R5	R6	Rb	Rw			"
grep '$1' cheali.log | sed 's/;/ /g' | \
awk '{ print $3 "\t" $4 / 100 "\t" $5 "\t" $6 "\t" $10 / 100 "\t" $11 / 100 "\t" $12 "\t"  $13 "\t"  $14 "\t"  $15 "\t"  $16 "\t"  $17 "\t"  $18 "\t"  $19 "\t"  $20 "\t"  $21 "\t"  $22 "\t"  $23 "\t"  $24 "\t"  $25 }' \
	| tail -n `grep '$1' cheali.log | wc -l | awk '{ print $1 - 2000 }'`

) \
 | tee logview.tsv | xclip -selection clipboard -i
#| less
