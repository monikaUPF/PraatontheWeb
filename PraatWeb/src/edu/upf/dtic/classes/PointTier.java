package edu.upf.dtic.classes;

import java.util.ArrayList;

/**
 * Point tier class
 *
 */
public class PointTier extends Tier {
	public PointTier(){
		segments = new ArrayList<Segment>();
	}
	
	public void addSegment(Point p){
		segments.add(p);
	}
	
	public void calculatePercentages(){
		ArrayList<Segment> tempCopy = new ArrayList<Segment>();
		for(int i = 0; i < segments.size(); i++){
			if(i == 0){
				((Point)segments.get(i)).calculatePercentage(totalLenght, null, (Point)segments.get(i+1), tempCopy);
			}else if(i == segments.size()-1){
				((Point)segments.get(i)).calculatePercentage(totalLenght, (Point)segments.get(i-1), null, tempCopy);
			}else{
				((Point)segments.get(i)).calculatePercentage(totalLenght, (Point)segments.get(i-1), (Point)segments.get(i+1), tempCopy);
			}
		}
		segments = tempCopy;
		//timeLeft = (totalLenght - previousPoint) / totalLenght * 100;
	}
}
