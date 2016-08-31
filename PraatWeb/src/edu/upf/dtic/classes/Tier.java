package edu.upf.dtic.classes;

import java.util.ArrayList;

/**
 * Abstract Tier class
 *
 */
public abstract class Tier {
	protected String name;
	protected float totalLenght;
	protected ArrayList<Segment> segments;
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public float getTotalLenght() {
		return totalLenght;
	}
	public void setTotalLenght(float totalLenght) {
		this.totalLenght = totalLenght;
	}
	public ArrayList<Segment> getSegments() {
		return segments;
	}
	public void setSegments(ArrayList<Segment> segments) {
		this.segments = segments;
	} 
	public void addSegment(Segment s){
		segments.add(s);
	}
	public void calculatePercentages(){
		for(Segment s : segments){
			s.calculatePercentage(totalLenght);
		}
	}
	public void generateFeatures(){
		for(Segment s : segments){
			s.generateFeatures();
		}
	}
	
}
