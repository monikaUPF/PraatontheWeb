package edu.upf.dtic.classes;

import java.util.HashMap;

public class TextgridsManager {
	private static TextgridsManager instance = null;
	HashMap<String, FileFormInfo> viewSamples = null;
	HashMap<String, FileFormInfo> wordsSamples = null;
	HashMap<String, FileFormInfo> splitSamples = null;
	HashMap<String, FileFormInfo> mergeSamples = null;
	
	private TextgridsManager(){
		viewSamples = new HashMap<String, FileFormInfo>();
		viewSamples.put("1", new FileFormInfo("viewSample01_result.TextGrid", "TX01: TextGrid Sample 01"));
		
		wordsSamples = new HashMap<String, FileFormInfo>();
		wordsSamples.put("1", new FileFormInfo("sample01_words.TextGrid", "TX01: TextGrid Sample 01"));
		
		splitSamples = new HashMap<String, FileFormInfo>();
		splitSamples.put("1", new FileFormInfo("splitMod_sample.TextGrid", "TX01: TextGrid Sample 01"));
		
		mergeSamples = new HashMap<String, FileFormInfo>();
		mergeSamples.put("1", new FileFormInfo("mergeMod_sample.TextGrid", "TX01: TextGrid Sample 01"));
	}
	
	public static TextgridsManager getInstance(){
		if(instance == null)
			instance = new TextgridsManager();
		return instance;
	}
	
	public HashMap<String, FileFormInfo> getViewSamplesInfo(){
		return viewSamples;
	}
	
	public HashMap<String, FileFormInfo> getWordsSamplesInfo(){
		return wordsSamples;
	}
	
	public HashMap<String, FileFormInfo> getSplitSamplesInfo(){
		return splitSamples;
	}
	
	public HashMap<String, FileFormInfo> getMergeSamplesInfo(){
		return mergeSamples;
	}
	
}
