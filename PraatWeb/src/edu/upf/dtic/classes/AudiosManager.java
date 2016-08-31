package edu.upf.dtic.classes;

import java.util.HashMap;

public class AudiosManager {
	private static AudiosManager instance = null;
	HashMap<String, FileFormInfo> audiosInfo = null;
	
	private AudiosManager(){
		audiosInfo = new HashMap<String, FileFormInfo>();
		audiosInfo.put("1", new FileFormInfo("sample01.wav", "AS01: Audio Sample 01"));
	}
	
	public static AudiosManager getInstance(){
		if(instance == null)
			instance = new AudiosManager();
		return instance;
	}
	
	public HashMap<String, FileFormInfo> getAudiosInfo(){
		return audiosInfo;
	}
	
}
