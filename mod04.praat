###########################################################################
#                                                                      	  #
#  Praat Script: PROSODY TAGGER                                     	  #
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
##### MODULE 4 ############################################################
###### Word segment export 												  #
###########################################################################
clearinfo
form Parameters
	text directory 
	text basename 
endform

Read from file: directory$ + basename$ + "_words.TextGrid"
Read from file: directory$ + basename$ + "_result.TextGrid"
Read from file: directory$ + basename$ + ".Intensity"
Read from file: directory$ + basename$ + ".Pitch"

# Variables for objects in Menu
text$ = "TextGrid " + basename$ + "_result"
pitch$ = "Pitch " + basename$
int$ = "Intensity " + basename$
merged$ = "TextGrid merged"
wordid$ = "TextGrid words"

# Export word tier to TextGrid
Read from file: directory$ + basename$ + "_words.TextGrid"
Extract one tier: 1
plusObject: text$
Merge

#######################################################################
# Annotate features at word level tier n.5
# relative to voiced segments at tier n.2
#######################################################################
totintWord = Get number of intervals: 5
for i to totintWord
	selectObject: merged$
	start = Get starting point: 5, i
	end = Get end point: 5, i
	time = end - start
	time$ = fixed$ (time, 2)
	centraltime = ((end - start)/2)+ start
	whichpph = Get interval at time: 2, centraltime
	start_pph = Get starting point: 2, whichpph
	end_pph = Get end point: 2, whichpph
	dur_pph = end_pph - start_pph
	rel_dur = (time / dur_pph) * 100
	rel_dur$ = fixed$ (rel_dur, 0)
	dur_all$ = Get feature from interval: 1, 1, "dur"
	dur_all = number(dur_all$)
	rel_dur_all = (time/dur_all) * 100
	rel_dur_all$ = fixed$ (rel_dur_all, 2)

	selectObject: pitch$
	meanf0 = Get mean: start, end, "Hertz"
	maxf0 = Get maximum: start, end, "Hertz", "Parabolic"
	t_maxf0 = Get time of maximum: start, end, "Hertz", "Parabolic"
	stdf0 = Get standard deviation: start, end, "Hertz"
	f0_pph = Get mean: start_pph, end_pph, "Hertz"
	stdf0_pph = Get standard deviation: start_pph, end_pph, "Hertz"

	selectObject: int$
	min = Get minimum: start, end, "Parabolic"
	t_min = Get time of minimum: start, end, "Parabolic"
	mean = Get mean: start, end, "dB"
	std = Get standard deviation: start, end
	int_pph = Get mean: start_pph, end_pph, "dB"
	stdint_pph = Get standard deviation: start_pph, end_pph

	# Calculate z-scores 
	z_int = (mean - int_pph) / stdint_pph
	z_int$ = fixed$ (z_int, 2)
	z_f0 = (meanf0 - f0_pph) / stdf0_pph
	z_f0$ = fixed$ (z_f0, 2)

	# Write features
	t_maxf0$ = fixed$ (t_maxf0, 2)
	t_min$ = fixed$ (t_min, 2)
	selectObject: merged$
	Insert feature to interval: 5, i, "t_min", t_min$
	Insert feature to interval: 5, i, "t_maxf0", t_maxf0$
	Insert feature to interval: 5, i, "z_int", z_int$
	Insert feature to interval: 5, i, "z_f0", z_f0$
	Insert feature to interval: 5, i, "dur", time$
	Insert feature to interval: 5, i, "dur_pph", rel_dur$ + "%"
	Insert feature to interval: 5, i, "dur_all", rel_dur_all$ + "%"
endfor

# Save changes to directory
selectObject: merged$
Write to text file: directory$ + basename$ + "_result.TextGrid"  

# clean Menu
select all
Remove

appendInfoLine: "Module 4 completed!"
#################### END OF MODULE 4 ####