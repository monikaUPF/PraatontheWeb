package edu.upf.dtic.classes;

import java.util.HashMap;

public class ScriptsManager {
	private static ScriptsManager instance = null;
	HashMap<String, FileFormInfo> modulesInfo = null;
	HashMap<String, FileFormInfo> splitInfo = null;
	HashMap<String, FileFormInfo> mergeInfo = null;
	
	private ScriptsManager(){
		modulesInfo = new HashMap<String, FileFormInfo>();
		modulesInfo.put("1", new FileFormInfo("mod01.praat", "Module 1: Intensity peak detection"));
		modulesInfo.put("2", new FileFormInfo("mod02.praat", "Module 2: Intensity valley detection"));
		modulesInfo.put("3", new FileFormInfo("mod03.praat", "Module 3: Feature annotation"));
		modulesInfo.put("4", new FileFormInfo("mod04.praat", "Module 4: Word segment export"));
		modulesInfo.put("5", new FileFormInfo("mod05a.praat", "Module 5: PPh boundary detection (word serments)"));
		modulesInfo.put("6", new FileFormInfo("mod05b.praat", "Module 5: PPh boundary detection (raw speech)"));
		modulesInfo.put("7", new FileFormInfo("mod06a.praat", "Module 6: PPh prominence detection (word serments)"));
		modulesInfo.put("8", new FileFormInfo("mod06b.praat", "Module 6: PPh prominence detection (raw speech)"));
		
		splitInfo = new HashMap<String, FileFormInfo>();
		splitInfo.put("1", new FileFormInfo("splitMod.praat", "SS: Split tier"));
		
		mergeInfo = new HashMap<String, FileFormInfo>();
		mergeInfo.put("1", new FileFormInfo("mergeMod.praat", "MS: Merge tiers"));
	}
	
	public static ScriptsManager getInstance(){
		if(instance == null)
			instance = new ScriptsManager();
		return instance;
	}
	
	public HashMap<String, FileFormInfo> getModulesScriptsInfo(){
		return modulesInfo;
	}
	
	public HashMap<String, FileFormInfo> getSplitScriptsInfo(){
		return splitInfo;
	}
	
	public HashMap<String, FileFormInfo> getMergeScriptsInfo(){
		return mergeInfo;
	}
	
}
