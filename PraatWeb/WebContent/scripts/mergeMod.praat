clearinfo

form Parameters
	text directory
	text basename
	#comment Tiers to merge
	real from_tier 4
	real to_tier 10
	#comment Annotate features to tier
	real number 1
endform

Read from file: directory$ + basename$ + ".TextGrid"

check_tier = Is interval tier: number
# Merge interval tiers
if check_tier == 1
	int_tier = Get number of intervals: number
	for i from from_tier to to_tier
		int_i = Get number of intervals: i
		#Check if tiers to merge have the same number of intervals as tier to annotate features
		if int_tier == int_i
			feature$ = Get tier name: i
			for i_lab to int_i
				value$ = Get label of interval: i, i_lab
				Insert feature to interval: number, i_lab, feature$, value$
			endfor
		else
			appendInfoLine: "number of intervals in tier ", i, " does not match to tier ", number
		endif
	endfor
# Merge point tiers
else
	point_tier = Get number of points: number
	for t from from_tier to to_tier
		point_t = Get number of intervals: t
		#Check if tiers to merge have the same number of intervals as tier to annotate features
		if int_tier == point_t
			feature$ = Get tier name: t
			for p_lab to point_t
				value$ = Get label of interval: t, p_lab
				Insert feature to interval: number, p_lab, feature$, value$
			endfor
		else
			appendInfoLine: "number of points in tier ", t, " does not match to tier ", number
		endif
	endfor
endif

for r from from_tier to to_tier
	Remove tier: r
endfor

Write to text file: directory$ + basename$ + "_result.TextGrid"

appendInfoLine: "Features have been annotated to tier ", number
