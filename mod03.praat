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
##### MODULE 3 ############################################################
###### Acoustic feature annotation										  #
###########################################################################
clearinfo
form Parameters
	text directory
	text basename
endform

Read from file: directory$ + basename$ + "_result.TextGrid"
Read from file: directory$ + basename$ + ".Intensity"
Read from file: directory$ + basename$ + ".Pitch"

# Variables for objects in Menu
text$ = "TextGrid " + basename$ + "_result"
pitch$ = "Pitch " + basename$
int$ = "Intensity " + basename$

# Extract acoustic features from the whole soundfile
selectObject: int$
meanint = Get mean: 0, 0, "dB"
stdint = Get standard deviation: 0, 0

selectObject: pitch$
meanF0 = Get mean: 0, 0, "Hertz"
stdF0 = Get standard deviation: 0, 0, "Hertz"
############################################################
# Write features to a general tier "utterance(L1)" n.1
############################################################
selectObject: text$
dur = Get total duration
dur$ = fixed$(dur, 2)
meanint$ = fixed$ (meanint, 0)
stdint$ = fixed$ (stdint, 2)
meanF0$ = fixed$ (meanF0, 0)
stdF0$ = fixed$ (stdF0, 2)
Insert interval tier: 1, "utterance(L1)"
Insert feature to interval: 1, 1, "meanInt", meanint$
Insert feature to interval: 1, 1, "stdInt", stdint$
Insert feature to interval: 1, 1, "meanF0", meanF0$
Insert feature to interval: 1, 1, "stdF0", stdF0$
Insert feature to interval: 1, 1, "dur", dur$

#############################################################
# Write features for voiced intervals at silence tier n.2
#############################################################
selectObject: text$
n_int = Get number of intervals: 2
count_sound = 0
count_sil = 0
for i from 1 to n_int
	selectObject: text$
	start = Get starting point: 2, i
	end = Get end point: 2, i
	dur_pph[i] = end - start
	int_label$ = Get label of interval: 2, i
	
	selectObject: int$
	int_pph[i] = Get mean: start, end, "dB"
	stdint_pph[i] = Get standard deviation: start, end

	selectObject: pitch$
	f0_pph[i] = Get mean: start, end, "Hertz"
	stdF0_pph[i] = Get standard deviation: start, end, "Hertz"

	# Calculate z-scores of each pph (reference to extracted values from the whole sound)
	z_intpph[i] = (int_pph[i] - meanint) / stdint
	z_f0pph[i] = (f0_pph[i] - meanF0) / stdF0
	z_durpph[i] = (dur_pph[i] / dur) * 100
	# Relative duration of interval compared to total duration of file (NB. not z-score)
	# Write features
	selectObject: text$
	# at voiced intervals
	if int_label$ = ""
		count_sound += 1
		count_sound$ = string$ (count_sound)
		z_intpph$ = fixed$ (z_intpph[i], 2)
		f0_pph$ = fixed$ (f0_pph[i], 2)
		stdF0_pph$ = fixed$ (stdF0_pph[i], 2)
		z_f0pph$ = fixed$ (z_f0pph[i], 2)
		dur_pph$ = fixed$ (dur_pph[i], 2)
		z_durpph$ = fixed$ (z_durpph[i], 2)
		Insert feature to interval: 2, i, "z_intpph", z_intpph$
		Insert feature to interval: 2, i, "f0pph", f0_pph$
		Insert feature to interval: 2, i, "stdf0pph", stdF0_pph$
		Insert feature to interval: 2, i, "z_f0pph", z_f0pph$
		Insert feature to interval: 2, i, "dur", dur_pph$
		Insert feature to interval: 2, i, "rel_dur", z_durpph$ + "%"
		Insert feature to interval: 2, i, "pph_sil", count_sound$
	# at silence intervals
	else
		count_sil += 1
		dur_pph$ = fixed$ (dur_pph[i], 2)
		z_durpph$ = fixed$ (z_durpph[i], 2)
		Insert feature to interval: 2, i, "dur", dur_pph$
		Insert feature to interval: 2, i, "rel_dur", z_durpph$
	endif
endfor

######################################################
# Write normalized features to IntensityPeak tier n.3
# relative to voiced segments
######################################################
selectObject: text$
n_points = Get number of points: 3
for i from 1 to n_points
	p_point = i - 1
	selectObject: text$
	time = Get time of point: 3, i
	i_sound = Get interval at time: 2, time

	selectObject: int$
	int_point[i] = Get value at time: time, "Cubic"

	selectObject: pitch$
	f0_point[i] = Get value at time: time, "Hertz", "Linear"

	# Calculate z-scores of each point (reference to extracted values from silence tier
	z_intpoint[i] = (int_point[i] - int_pph[i_sound]) / stdint_pph[i_sound]
	z_f0point[i] = (f0_point[i] - f0_pph[i_sound]) / stdF0_pph[i_sound]

	# Write features
	selectObject: text$
	z_intpoint$ = fixed$ (z_intpoint[i], 2)
	z_f0point$ = fixed$ (z_f0point[i], 2)
	Insert feature to point: 3, i, "z_int", z_intpoint$
	Insert feature to point: 3, i, "z_f0", z_f0point$
	# Distance to previous point annotation
	if p_point > 0
		p_time = Get time of point: 3, p_point
		dist = time - p_time
		dist$ = fixed$ (dist, 2)
		Insert feature to point: 3, i, "dist_p", dist$
	else
	# Calculate the distance of the first syllable to the beginning of the voiced segment
		pph_int = Get interval at time: 2, time
		pph_time = Get starting point: 2, pph_int
		dist = time - pph_time
		dist$ = fixed$ (dist, 2)
		Insert feature to point: 3, i, "dist_p", dist$			
	endif
endfor
#########################################################
### Annotate features at IntensityValleys tier n.4
#########################################################
selectObject: text$
n_valls = Get number of points: 4
for i from 1 to n_valls
	p_vall = i - 1
	selectObject: text$
	time_v = Get time of point: 4, i
	i_pph = Get interval at time: 2, time_v
	# Extract pph count for array writen as feature pph_sil
	f_pph$ = Get feature from interval: 2, i_pph, "pph_sil"
	f_pph = number(f_pph$)

	selectObject: pitch$
	f0_vall[i] = Get value at time: time_v, "Hertz", "Linear"
	
	selectObject: text$
	# Calculate f0 z-scores if f0 value exists
	if f0_vall[i] = undefined
		Insert feature to point: 4, i, "z_f0", "--undefined--"
	else 
		z_f0vall[i] = (f0_vall[i] - f0_pph[f_pph]) / stdF0_pph[f_pph]
		z_f0vall$ = fixed$ (z_f0vall[i], 2)
		Insert feature to point: 4, i, "z_f0", z_f0vall$
	endif
	# Distance to previous point annotation
	if p_vall > 0
		p_time = Get time of point: 4, p_vall
		dist = time_v - p_time
		dist$ = fixed$ (dist, 2)
		Insert feature to point: 4, i, "dist_p", dist$
	else
	# Calculate the distance of the first syllable to the beginning of the voiced segment
		pph_int = Get interval at time: 2, time_v
		pph_time = Get starting point: 2, pph_int
		dist = time_v - pph_time
		dist$ = fixed$ (dist, 2)
		Insert feature to point: 4, i, "dist_p", dist$			
	endif
endfor

# Save changes to directory
Write to text file: directory$ + basename$ + "_result.TextGrid"

# clean Menu
select all
Remove

appendInfoLine: "Module 3 completed!"

### END OF MODULE 3 #################