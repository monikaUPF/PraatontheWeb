package edu.upf.dtic.classes;

/**
 * Class with the structure of a file path and its description
 *
 */
public class FileFormInfo {
	private String description;
	private String fileName;
	
	public FileFormInfo(String fileName, String description) {
		this.description = description;
		this.fileName = fileName;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	
}
