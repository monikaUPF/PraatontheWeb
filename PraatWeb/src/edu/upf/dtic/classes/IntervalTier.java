package edu.upf.dtic.classes;

import java.util.ArrayList;

/**
 * Interval tier class
 *
 */
public class IntervalTier extends Tier {
	public IntervalTier(){
		segments = new ArrayList<Segment>();
	}
	
	public void addSegment(Interval i){
		segments.add(i);
	}
}
