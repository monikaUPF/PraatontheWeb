#########################################################
##### MODULE PITCH AND INTENSITY ##########################################
#########################################################
clearinfo
form Parameters
	text directory
	text basename
endform

Read from file: directory$ + basename$ + ".Intensity"
Read from file: directory$ + basename$ + ".Pitch"

# objects in Menu
pitch$ = "Pitch " + basename$
int$ = "Intensity " + basename$

selectObject: pitch$

start = Get start time
end = Get end time

writeFileLine: directory$ + basename$ + ".graph", "time", tab$, "pitch", tab$, "intensity"
i = start
while i <= end
	selectObject: pitch$
	resPitch = Get value at time: i,  "Hertz", "Linear"
	selectObject: int$
	resInt = Get value at time: i,  "Cubic"
	appendFileLine: directory$ + basename$ + ".graph", fixed$ (i, 3), tab$, fixed$ (resPitch, 2), tab$, fixed$ (resInt, 2)
	i = i + 0.01
endwhile

