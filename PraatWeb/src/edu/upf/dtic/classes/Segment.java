package edu.upf.dtic.classes;

import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public abstract class Segment {
	protected float percentage;
	protected String content;
	protected String title;
	protected ArrayList<Pair<String, String>> features;
	public float getPercentage() {
		return percentage;
	}
	public void setPercentage(float percentage) {
		this.percentage = percentage;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public void addFeature(Pair<String, String> feature){
		features.add(feature);
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public ArrayList<Pair<String, String>> getFeatures() {
		return features;
	}
	public void setFeatures(ArrayList<Pair<String, String>> features) {
		this.features = features;
	}
	public void generateFeatures(){
		features = new ArrayList<Pair<String, String>>();
		Pattern p = Pattern.compile("(.*)@\\{@(.*)@\\}@");
		Matcher matcher = p.matcher(content);
		if(matcher.find())
		{
		    title=matcher.group(1);
		    String featuresString = matcher.group(2);
		    String[] parts = featuresString.trim().split("(?<!\\\\),");
		    for(int i = 0; i < parts.length; i++){
		    	parts[i] = parts[i].trim();
		    	parts[i] = parts[i].replaceAll("\\\"", "\"");
		    	parts[i] = parts[i].replaceAll("\\\\", "\\");
		    	parts[i] = parts[i].replaceAll("\"\"", "\"");
		    	//parts[i] = parts[i].replaceAll("^\"(.*)\"$", "$1");
		    	String head = parts[i].replaceAll("^\"(.*)\" = \"(.*)\"$", "$1");
		    	String value = parts[i].replaceAll("^\"(.*)\" = \"(.*)\"$", "$2");
		    	features.add(new Pair<String, String>(head, value));
		    }

		}else{
			title=content;
		}
	}
	public void calculatePercentage(float totalLenght){
		
	}
	
}
