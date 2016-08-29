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
##### MODULE 5 ############################################################
###### PPh boundary Prediction (with word segments)						  #
###########################################################################
clearinfo
form Parameters
	text directory 
	text basename 
endform

Read from file: directory$ + basename$ + ".Pitch"
Read from file: directory$ + basename$ + ".Intensity"
Read from file: directory$ + basename$ + "_result.TextGrid"


# Variables for objects in Menu
text$ = "TextGrid " + basename$ + "_result"
int$ = "Intensity " + basename$
pitch$ = "Pitch " + basename$

# Create new tier for BT annotation
Insert interval tier: 6, "PPh(L3)"
n_pph = Get number of intervals: 2
for i_int from 1 to n_pph
	selectObject: text$
	min_Int = 0
	min_Int$ = ""
	min2 = 0
	min2$ = ""
	time_min = 0
	m_lab$ = ""
	time_min2 = 0
	m_lab2$ = ""
	start_pph = Get starting point: 2, i_int
	end_pph = Get end point: 2, i_int
	dur_pph$ = Get feature from interval: 2, i_int, "dur"
	dur_pph = number (dur_pph$)
	sr_pph = 0
	sr_pph$ = ""
	time_e = 0
	time_s = 0
	# Writes complete phrases to PPh tier n.6 (voiced + SIL segments)
	check1 = Get interval boundary from time: 6, start_pph
	check_lab$ = Get head of interval: 2, i_int
	if start_pph != 0 && check1 = 0 && check_lab$ = ""
		Insert boundary: 6, start_pph
	endif
	# Only voiced segments
	if check_lab$ = ""
		Extract part: start_pph, end_pph, "yes"
		# Calculate and annotate speech rate in that interval
		tot_peaks = Get number of points: 3
		sr_pph = tot_peaks / dur_pph
		sr_pph$ = fixed$(sr_pph, 2)
		# Loop over intensity valleys contained in that voiced segment and save values to array
		n_vall = Get number of points: 4
		for i from 1 to n_vall
			int$[i] = Get feature from point: 4, i, "z_int"
			int[i] = number (int$[i])
			time[i] = Get time of point: 4, i
			p_label$[i] = Get head of point: 4, i
			# Find the minimum and second minimum value in the array
			if int[i] < min2
				if int[i] < min_Int
					min_Int = int[i]
					time_min = time[i]
					m_lab$ = p_label$[i]
				else
					min2 = int[i]
					time_min2 = time[i]
					m_lab2$ = p_label$[i]
				endif
			endif
		endfor

		# Write minimum valley point as boundary in BT tier
		if time_min != 0 
			selectObject: text$
			Insert boundary: 6, time_min
			Insert feature to interval: 2, i_int, "SR", sr_pph$
		else
			selectObject: text$
			Insert feature to interval: 2, i_int, "SR", sr_pph$				
		endif
		if time_min2 != 0 && dur_pph > 4
			selectObject: text$
			Insert boundary: 6, time_min2
		endif
	endif
endfor

# Correct boundary using word segmentation
##### ANOTHER DAY



## Annotate features of the predicted PPh intervals
count = 0
n_pph2 = Get number of intervals: 6
for i_pph to n_pph2
	count += 1
	selectObject: text$
	start = Get starting point: 6, i_pph
	end = Get end point: 6, i_pph
	time = end - start
	time$ = fixed$ (time, 2)
	centraltime = ((end - start)/2)+ start
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
	count$ = string$(count)
	selectObject: text$
	Set interval head text: 6, i_pph, count$
	Insert feature to interval: 6, i_pph, "t_min", t_min$
	Insert feature to interval: 6, i_pph, "t_maxf0", t_maxf0$
	Insert feature to interval: 6, i_pph, "z_int", z_int$
	Insert feature to interval: 6, i_pph, "z_f0", z_f0$
	Insert feature to interval: 6, i_pph, "dur", time$
	Insert feature to interval: 6, i_pph, "dur_all", rel_dur_all$ + "%"		
endfor
# Save changes to directory
Write to text file: directory$ + basename$ + "_result.TextGrid"


# clean before quit
select all
Remove

appendInfoLine: "Module 5 (default 2) completed"

#################### END OF MODULE 5 ####