package edu.upf.dtic.classes;

import java.util.ArrayList;

/**
 * Tier features class
 *
 */
public class TierFeatures {
	String text;
	ArrayList<String> features;
	public TierFeatures() {
	}
	public TierFeatures(String text) {
		this.text = text;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	public ArrayList<String> getFeatures() {
		return features;
	}
	public void setFeatures(ArrayList<String> features) {
		this.features = features;
	}
	public void addFeature(String feature){
		features.add(feature);
	}
}
