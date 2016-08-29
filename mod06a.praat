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
###### PPh prominence detection (with word segments)					  #
###########################################################################
clearinfo
form Parameters
	text directory 
	text basename 
endform

Read from file: directory$ + basename$ + "_result.TextGrid"

# Variables for objects in Menu
text$ = "TextGrid " + basename$ + "_result"

# Create new tier for Prominence annotation
selectObject: text$
Insert interval tier: 7, "Prominence(L3)"

# Look for most prominent word within voiced interval
n_voiced = Get number of intervals: 2
for i_v from 1 to n_voiced
	selectObject: text$
	f0_word = 0
	int_word = 0
	start_w = 0
	end_w = 0
	start_v = Get starting point: 2, i_v
	end_v = Get end point: 2, i_v
	dur_v = end_v - start_v
	if dur_v > 1
		Extract part: start_v, end_v, "yes"
		n_words = Get number of intervals: 5
		for i_w to n_words
			f0_w$[i_w] = Get feature from interval: 5, i_w, "z_f0"
			if f0_w$[i_w] != "--undefined--"
				f0_w[i_w] = number (f0_w$[i_w])
				int_w$[i_w] = Get feature from interval: 5, i_w, "z_int"
				int_w[i_w] = number (int_w$[i_w])
				st_w[i_w] = Get starting point: 5, i_w
				ed_w[i_w] = Get end point: 5, i_w
				if f0_w[i_w] > f0_word && int_w[i_w] > int_word
					f0_word = f0_w[i_w]
					int_word = int_w[i_w]
					start_v = st_w[i_w]
					end_v = ed_w[i_w]
				endif
			endif
		endfor
		# Write most prominent word at L2 (voiced segment level)
		selectObject: text$
		int_w = Get low interval at time: 5, end_w
		if int_w != 0 && start_w != 0 && end_w != 0
			lab_w$ = Get label of interval: 5, int_w
			check01 = Get interval boundary from time: 7, start_w
			check02 = Get interval boundary from time: 7, end_w
			if check01 = 0 && check02 = 0 
				Insert boundary: 7, start_w
				Insert boundary: 7, end_w
				new_int01 = Get interval at time: 7, start_w
				Set interval text: 7, new_int01, lab_w$
			endif
		endif
	endif
endfor

# Use intensity peaks for filtering prominent ones within detected pph intervals (Level 3)
n_pph = Get number of intervals: 6
for i_int from 1 to n_pph
	selectObject: text$
	max_f0 = 0
	max2_f0 = 0
	max_int = 0
	max2_int = 0
	time_max = 0
	time_max2 = 0
	start_pph = Get starting point: 6, i_int
	end_pph = Get end point: 6, i_int
	dur_pph = end_pph - start_pph
	# Save values to array
	Extract part: start_pph, end_pph, "yes"
	n_syll = Get number of points: 3
	for i to n_syll
		int$[i] = Get feature from point: 3, i, "z_int"
		int[i] = number (int$[i])
		f0$[i] = Get feature from point: 3, i, "z_f0"
		f0[i] = number (f0$[i])
		time[i] = Get time of point: 3, i
		p_label$[i] = Get label of point: 3, i
		# Find the maximum value in the array within each PPh (L3)
		if f0[i] > max2_f0 && int[i] > max2_int
			if f0[i] > max_f0 && int[i] > max_int
				max_f0 = f0[i]
				max_int = int[i]
				time_max = time[i]
			else
				max2_f0 = f0[i]
				max2_int = int[i]
				time_max2 = time[i]
			endif
		endif
	endfor
	
	# Look for word containing most prominent peak and write it to prominence tier
	selectObject: text$
	int_word = Get interval at time: 5, time_max
	int_word2 = Get interval at time: 5, time_max2
	if int_word > 0
		startWord = Get starting point: 5, int_word
		endWord = Get end point: 5, int_word
		labWord$ = Get label of interval: 5, int_word
		check1 = Get interval boundary from time: 7, startWord
		check2 = Get interval boundary from time: 7, endWord
		if startWord!= 0 && check1 = 0 && check2 = 0 
			Insert boundary: 7, startWord
			Insert boundary: 7, endWord
			new_int = Get interval at time: 7, startWord
			Set interval text: 7, new_int, labWord$
		endif
		# Insert second/third peak if pph is longer than 4 seconds
		if dur_pph > 3 && int_word2 > 0
			startWord2 = Get starting point: 5, int_word2
			endWord2 = Get end point: 5, int_word2
			labWord2$ = Get label of interval: 5, int_word2
			check3 = Get interval boundary from time: 7, startWord2
			check4 = Get interval boundary from time: 7, endWord2
			if startWord2 != 0 && check3 = 0 && check4 = 0
				Insert boundary: 7, startWord2
				Insert boundary: 7, endWord2
				new_int2 = Get interval at time: 7, startWord2
				Set interval text: 7, new_int2, labWord2$
			endif
		endif
	endif
endfor

# Save changes to directory
if complete == 0
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

appendInfoLine: "Module 6 default 2 completed!"
appendInfoLine: "The Automatic Prosody Tagger has automatically labeled PPh phrases and prominence of your wav file"

#################### END OF MODULE 6dPA ####