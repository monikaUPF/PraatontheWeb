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
##### MODULE 2 ############################################################
###### Intensity valley detection										  #
###########################################################################
clearinfo
form Parameters
	text directory 
	text basename 
endform

Read from file: directory$ + basename$ + "_result.TextGrid"
Read from file: directory$ + basename$ + ".Intensity"

# Variables for objects in Menu
text$ = "TextGrid " + basename$ + "_result"
int$ = "Intensity " + basename$
intvall$ = "IntensityTier " + basename$

# Create tier for valleys #4
selectObject: text$
Insert point tier: 3, "valleys"

## Extract intensity parameters of the whole sound
selectObject: int$
meanint = Get mean: 0, 0, "dB"
stdint = Get standard deviation: 0, 0

# Create an Intensity Valleys object
To IntensityTier (valleys)

n_vall = Get number of points
for i from 1 to n_vall
	selectObject: intvall$
	t = Get time from index: i
	value = Get value at index: i

	# Extract intensity parameters from reference voiced segment
	selectObject: text$
	whichintval = Get interval at time: 1, t
	pph_lab$ = string$ (whichintval)
	start = Get starting point: 1, whichintval
	end = Get end point: 1, whichintval
	pph$ = Get label of interval: 1, whichintval
	w_int$ = string$(whichintval)

	selectObject: int$
	int_pph = Get mean: start, end, "dB"
	stdint_pph = Get standard deviation: start, end

	# Calculate z-scores
	z_int = (value - int_pph) / stdint_pph
	z_int$ = fixed$ (z_int, 2)
	z_all = (value - meanint)/ stdint
	z_all$ = fixed$(z_all, 2)
	# Annotate normalized features to selected intensity valleys
	if pph$ = ""
		if z_all < 0
			selectObject: text$
			Insert point: 3, t, w_int$
			ind = Get low index from time: 3, t
			Insert feature to point: 3, ind, "z_int", z_int$
			Insert feature to point: 3, ind, "z_all", z_all$
			# Check distance to previous point and z_int to decide which intensity valleys are created
			pre_ind = ind -1
			if pre_ind <> 0
				pre_t = Get time of point: 3, pre_ind
				dif_t = t - pre_t
				if dif_t < 0.30
					pre_z$ = Get feature from point: 3, pre_ind, "z_int"
					pre_z = number (pre_z$)
					if pre_z < z_int 
						Remove point: 3, pre_ind
					else
						Remove point: 3, ind
					endif
				endif
			endif
		endif
	endif
endfor 

# Save temporal file
selectObject: text$
Write to text file: directory$ + basename$ + "_result.TextGrid"

# clean Menu
select all
Remove

appendInfoLine: "Module 2 completed!"

#################### END OF MODULE 2 ####