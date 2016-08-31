###########################################################################
#                                                                      	  #
#  Praat Script: Split features                                     	  #
#  Copyright (C) 2016  Mónica Domínguez-Bajo - Universitat Pompeu Fabra   #
#																		  #
#    This program is free software: you can redistribute it and/or modify #
#    it under the terms of the GNU General Public License as published by #
#    the Free Software Foundation, either version 3 of the License, or    #
#    (at your option) any later version.                                  #
#                                                                         #
#    This program is distributed in the hope that it will be useful,      #
#    but WITHOUT ANY WARRANTY; without even the implied warranty of       #
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        #
#    GNU General Public License for more details.                         #
#                                                                         #
#    You should have received a copy of the GNU General Public License    #
#    along with this program.  If not, see http://www.gnu.org/licenses/   #
#                                                                         #
###########################################################################
###### This script splits feature vectors in cloned tiers
###########################################################################
## Requirements: Extended Praat for feature annotation needs to be run 
###########################################################################
## A TextGrid with annotated features needs to be provided
## The script will use the feature name as tier name
## and the feature value as interval label
###########################################################################
clearinfo
form Parameters
	text directory
	text basename
	real number 1
endform

tier = number

Read from file: directory$ + basename$ + ".TextGrid"

check_tier = Is interval tier: tier
# Split interval tiers
if check_tier == 1
	numFeat_i = Get number of features in interval: tier, 2
	for i to numFeat_i
		tierName$ = Get label of feature in interval: tier, 2, i
		numTiers = Get number of tiers
		Duplicate tier: tier, numTiers+1, tierName$
	endfor

	n_int = Get number of intervals: tier
	for int to n_int
		for i to numFeat_i
			feat$ = Get label of feature in interval: tier, int, i
			label$ = Get feature from interval: tier, int, feat$
			n_tiers = Get number of tiers
			for t to n_tiers
				checktier$ = Get tier name: t
				if checktier$ = feat$
					Set interval text: t, int, label$
				endif
			endfor
		endfor
	endfor
# Split point tiers
else
	numFeat_p = Get number of features in point: tier, 2
	for i to numFeat_p
		tierName$ = Get label of feature in point: tier, 2, i
		numTiers = Get number of tiers
		Duplicate tier: tier, numTiers+1, tierName$
	endfor

	n_point = Get number of points: tier
	for p to n_point
		for i to numFeat_p
			feat$ = Get label of feature in point: tier, p, i
			label$ = Get feature from point: tier, p, feat$
			n_tiers = Get number of tiers
			for t to n_tiers
				checktier$ = Get tier name: t
				if checktier$ = feat$
					Set point text: t, p, label$
				endif
			endfor
		endfor
	endfor
endif

Write to text file: directory$ + basename$ + "_result.TextGrid"

appendInfoLine: "Features have been split in tiers"
