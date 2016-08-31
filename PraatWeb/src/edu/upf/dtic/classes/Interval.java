package edu.upf.dtic.classes;

import java.util.ArrayList;

public class Interval extends Segment{
	float initialPoint;
	float finalPoint;
	public float getInitialPoint() {
		return initialPoint;
	}
	public void setInitialPoint(float initialPoint) {
		this.initialPoint = initialPoint;
	}
	public float getFinalPoint() {
		return finalPoint;
	}
	public void setFinalPoint(float finalPoint) {
		this.finalPoint = finalPoint;
	}
	public Interval(){}
	public Interval(float initialPoint, float finalPoint, String content) {
		this.initialPoint = initialPoint;
		this.finalPoint = finalPoint;
		this.content = content;
		features = new ArrayList<Pair<String, String>>();
	}
	public void calculatePercentage(float totalLenght){
		percentage = (finalPoint - initialPoint) / totalLenght * 100;
	}
}
