package edu.upf.dtic.classes;

import java.util.ArrayList;

public class Point extends Segment{
	private boolean gapPoint = false;
	private float initialPercentage;
	private float finalPercentage;
	private float point;
	private float pointSeconds;
	public float getPoint() {
		return point;
	}
	public void setPoint(float point) {
		this.point = point;
	}
	public float getPointSeconds() {
		return pointSeconds;
	}
	public void setPointSeconds(float pointSeconds) {
		this.pointSeconds = pointSeconds;
	}
	public float getInitialPercentage() {
		return initialPercentage;
	}
	public void setInitialPercentage(float initialPercentage) {
		this.initialPercentage = initialPercentage;
	}
	public float getFinalPercentage() {
		return finalPercentage;
	}
	public void setFinalPercentage(float finalPercentage) {
		this.finalPercentage = finalPercentage;
	}
	public boolean isGapPoint() {
		return gapPoint;
	}
	public void setGapPoint(boolean gapPoint) {
		this.gapPoint = gapPoint;
	}
	public Point(){}
	public Point(float point, String content) {
		this.point = point;
		this.content = content;
		features = new ArrayList<Pair<String, String>>();
	}
	public void calculatePercentage(float totalLenght, Point pPoint, Point nPoint, ArrayList<Segment> tempCopy){
		float previousPoint = 0;
		float nextPoint = totalLenght;
		float previousFinalPercentage = 0;
		float finalWidth = 0;
		
		if(pPoint != null){
			previousPoint = pPoint.getPoint();
			previousFinalPercentage = pPoint.getFinalPercentage();
		}
		
		if(nPoint != null){
			nextPoint = nPoint.getPoint();
		}
		
		float distancePrevious = point - previousPoint;
		float distanceNext = nextPoint - point;
		
		float res = Math.min(distancePrevious, distanceNext);
		
		if(res == distancePrevious){
			initialPercentage = point-res/2;
			float gap = initialPercentage - previousFinalPercentage;
			if(gap > 0){
				finalWidth = Math.min(res+gap*2, distanceNext);
			}else{
				finalWidth = res;
			}
		}else{
			finalWidth = res;
		}
		
		initialPercentage = point - finalWidth/2;
		finalPercentage = point + finalWidth/2;
		
		if(initialPercentage - previousFinalPercentage > 0){
			Point gapPoint = new Point((initialPercentage - previousFinalPercentage)/2, "");
			gapPoint.setPercentage((initialPercentage - previousFinalPercentage) / totalLenght * 100);
			gapPoint.setGapPoint(true);
			tempCopy.add(gapPoint);
		}
		
		percentage = finalWidth / totalLenght * 100;
		
		tempCopy.add(this);
		
		if(nPoint == null && finalPercentage < totalLenght){
			Point gapPoint = new Point((totalLenght - finalPercentage)/2, "");
			gapPoint.setPercentage((totalLenght - finalPercentage) / totalLenght * 100);
			gapPoint.setGapPoint(true);
			tempCopy.add(gapPoint);
		}
		
	}
	
	/*public void calculatePercentage(float totalLenght){
		percentage = point / totalLenght * 100;
	}*/
	
}
