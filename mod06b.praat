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
##### MODULE 6 ############################################################
###### PPh prominence detection (on raw speech)							  #
###########################################################################
clearinfo
form Parameters
	text directory
	text basename
endform

Read from file: directory$ + basename$ + "_result.TextGrid"

# Variables for objects in Menu
sound$ = "Sound " + basename$
text$ = "TextGrid " + basename$ + "_result"

# Create new point tier for annotation of Prominence
selectObject: text$
Insert point tier: 6, "Prominence(L3)"

# Look for prominent peaks by looping on detected pph intervals (Level 3)
n_pph = Get number of intervals: 5
for i_int from 1 to n_pph
	selectObject: text$
	max_f0 = 0
	max2_f0 = 0
	max_int = 0
	max2_int = 0
	time_max = 0
	time_max2 = 0
	label_p$ = ""
	label_p2$ = ""

	start_pph = Get starting point: 5, i_int
	end_pph = Get end point: 5, i_int
	dur_pph = end_pph - start_pph
	# Loop over intensity peaks contained in that pph and save values to array
	Extract part: start_pph, end_pph, "yes"
	n_syll2 = Get number of points: 3
	if n_syll2 > 2
		for i to n_syll2
			int2$[i] = Get feature from point: 3, i, "z_int"
			int2[i] = number (int2$[i])
			f02$[i] = Get feature from point: 3, i, "z_f0"
			f02[i] = number (f02$[i])
			time2[i] = Get time of point: 3, i
			p_label2$[i] = Get label of point: 3, i
			# Find the maximum value in the array (within each pph)
			if f02[i] > max2_f0 && int2[i] > max2_int
				if f02[i] > max_f0 && int2[i] > max_int
					max_f0 = f02[i]
					max_int = int2[i]
					time_max = time2[i]
					label_p$ = p_label2$[i]
				else
					max2_f0 = f02[i]
					max2_int = int2[i]
					time_max2 = time2[i]
					label_p2$ = p_label2$[i]
				endif
			endif
		endfor
	endif
	# Mark and annotate most prominent peak at L3
	selectObject: text$
	if time_max != 0 
		pcheck3 = Get nearest index from time: 6, time_max
		if pcheck3 = 0
			Insert point: 6, time_max, label_p$

		else
			tcheck3 = Get time of point: 6, pcheck3
			check3 = abs(time_max - pcheck3)
			if check3 != 0
				Insert point: 6, time_max, label_p$
			endif
		endif
		# Insert a second prominent point if PPh is longer than 1 second
		if dur_pph > 1 && time_max2 != 0
			pcheck4 = Get nearest index from time: 6, time_max2
			if pcheck4 = 0
				Insert point: 6, time_max2, label_p2$
			else
				tcheck4 = Get time of point: 6, pcheck4
				check4 = abs(time_max2 - pcheck4)
				if check4 != 0
					Insert point: 6, time_max2, label_p2$
				endif
			endif
		endif
	endif
endfor

if complete == 0
# Save changes to directory
	Write to text file: directory$ + basename$ + "_result.TextGrid"
elif complete == 1
	# Delete calculation tiers for final version
	Remove tier: 1
	Remove tier: 1
	Remove tier: 1
	Remove tier: 1
	Write to text file: directory$ + basename$ + "_result.TextGrid"
endif

# clean Menu
select all
Remove

appendInfoLine: "Module 6 def 1 completed!"
appendInfoLine: "The Automatic Prosody Tagger has automatically labeled the prosody of your wav file"

#################### END OF MODULE 6dPA ####
