package edu.upf.dtic.servlets;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import edu.upf.dtic.classes.AudiosManager;
import edu.upf.dtic.classes.Global;
import edu.upf.dtic.classes.ScriptsManager;
import edu.upf.dtic.classes.TextgridsManager;
import edu.upf.dtic.classes.Utils;

import static java.nio.file.StandardCopyOption.*;

@MultipartConfig
public class ModulesServlet extends HttpServlet{

	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		response.setContentType("text/html");
		
		//Initialization needed attributes
		request.setAttribute("scriptsData", ScriptsManager.getInstance().getModulesScriptsInfo());
		request.setAttribute("audioData", AudiosManager.getInstance().getAudiosInfo());
		request.setAttribute("textGridsData", TextgridsManager.getInstance().getWordsSamplesInfo());
		
		getServletContext().getRequestDispatcher("/ModulesForm.jsp")
	    .forward(request, response);      
	}
	
	private static String SERVER_UPLOAD_LOCATION_FOLDER;
	private static String SERVER_SCRIPTS_FOLDER;
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		
		ServletContext context = getServletContext();
		String tmpPath = context.getRealPath("/tmp");
		SERVER_UPLOAD_LOCATION_FOLDER =  tmpPath + "/";
		
		String scriptsPath = context.getRealPath("/scripts");
		SERVER_SCRIPTS_FOLDER =  scriptsPath + "/";
		
		//We recover form parameters
		String scriptOrder = request.getParameter("scripsOrder");
		String[] order = scriptOrder.split(",");
		List<String> orderList = Arrays.asList(order);
		if (scriptOrder == null || scriptOrder.trim().equals("")) {
			request.setAttribute("scriptsData", ScriptsManager.getInstance().getModulesScriptsInfo());
			request.setAttribute("audioData", AudiosManager.getInstance().getAudiosInfo());
			request.setAttribute("textGridsData", TextgridsManager.getInstance().getWordsSamplesInfo());
			request.setAttribute("errorMessage", "You must select at least one module tu run.");
			request.getRequestDispatcher("/ModulesForm.jsp").forward(request, response);
			return;
		}
		String justFinalTiers = request.getParameter("justFinalTiers");
		if(justFinalTiers == null) justFinalTiers = "0";
		String audioSelection = request.getParameter("audioSelection");
		Part audioFilePart = request.getPart("audioFile");
		InputStream audioFileContent = null;
		String textgridSelection = request.getParameter("textgridSelection");
		Part textGridFilePart = request.getPart("textGridFile");
		InputStream textGridFileContent = null;
		
		//Data checks
		Boolean textgrid = false;
		boolean audioFile = (audioFilePart != null && audioFilePart.getSize() > 0);
		if (!audioFile && audioSelection.equals("")) {
			request.setAttribute("scriptsData", ScriptsManager.getInstance().getModulesScriptsInfo());
			request.setAttribute("audioData", AudiosManager.getInstance().getAudiosInfo());
			request.setAttribute("textGridsData", TextgridsManager.getInstance().getWordsSamplesInfo());
			request.setAttribute("errorMessage", "No audio provided.");
			request.getRequestDispatcher("/ModulesForm.jsp").forward(request, response);
			return;
		}
		boolean textgridFile = (textGridFilePart != null && textGridFilePart.getSize() > 0);
		if (textgridFile || !textgridSelection.equals("")) {
			textgrid = true;
		}else if(orderList.contains("4")){
			request.setAttribute("scriptsData", ScriptsManager.getInstance().getModulesScriptsInfo());
			request.setAttribute("audioData", AudiosManager.getInstance().getAudiosInfo());
			request.setAttribute("textGridsData", TextgridsManager.getInstance().getWordsSamplesInfo());
			request.setAttribute("errorMessage", "No TextGrid provided.");
			request.getRequestDispatcher("/ModulesForm.jsp").forward(request, response);
			return;
		}
		
		//Obtain the input streams
		if(audioFile){
			audioFileContent = audioFilePart.getInputStream();
		}
		if(textgrid){
			if(textgridFile){
				textGridFileContent = textGridFilePart.getInputStream();
			}
		}
		
		long currentMilis = System.currentTimeMillis();
		String ref = request.getRemoteAddr().replace(".", "") + currentMilis;
		String temporalDirectory = SERVER_UPLOAD_LOCATION_FOLDER + ref + "/";
		String textGridFilePath = temporalDirectory + ref + "_words.TextGrid";
		String audioFilePath = temporalDirectory + ref + ".wav";
		String resultFilePath = temporalDirectory + ref + "_result.TextGrid";
		
		File theDir = new File(SERVER_UPLOAD_LOCATION_FOLDER + request.getRemoteAddr().replace(".", "") + currentMilis);
		// if the temportal directory does not exist, create it
		if (!theDir.exists()) {
		    try{
		        theDir.mkdir();
		    }catch(SecurityException se){
		    	request.setAttribute("scriptsData", ScriptsManager.getInstance().getModulesScriptsInfo());
				request.setAttribute("audioData", AudiosManager.getInstance().getAudiosInfo());
				request.setAttribute("textGridsData", TextgridsManager.getInstance().getWordsSamplesInfo());
				request.setAttribute("errorMessage", "Unexpected error creating temporal directory.");
				request.getRequestDispatcher("/ModulesForm.jsp").forward(request, response);
		        return;
		    }        
		}
		
		//We save needed files to the temporal directory
		if(audioFile){
			Utils.saveFile(audioFileContent, audioFilePath);
		}else{
			String audiosFolderPath = context.getRealPath("/samples/audio") + "/";
			String audioFileName = AudiosManager.getInstance().getAudiosInfo().get(audioSelection).getFileName();
			Files.copy(Paths.get(audiosFolderPath + audioFileName), Paths.get(audioFilePath), REPLACE_EXISTING);
		}
		if(textgrid){
			if(textgridFile){
				Utils.saveFile(textGridFileContent, textGridFilePath);
			}else{
				String textgridFolderPath = context.getRealPath("/samples/textgrid") + "/";
				String textgridFileName = TextgridsManager.getInstance().getWordsSamplesInfo().get(textgridSelection).getFileName();
				Files.copy(Paths.get(textgridFolderPath + textgridFileName), Paths.get(textGridFilePath), REPLACE_EXISTING);
			}
		}
		
		//Execute all modular scripts sequentialy
		for(int i = 0; i < order.length; i++){
			String scriptName = ScriptsManager.getInstance().getModulesScriptsInfo().get(order[i]).getFileName();
		
			List<String> command = new ArrayList<String>();
			command.add(Global.PRAAT_LOCATION);
			command.add("--run");
			command.add("--no-pref-files");
			command.add(SERVER_SCRIPTS_FOLDER + scriptName);
			command.add(temporalDirectory);
			command.add(ref);
			command.add(justFinalTiers);
			
			try {
				Utils.executeCommand(command, 300000);
			} catch (Exception e1) {
				e1.printStackTrace();
				
				Utils.deleteFolderAndContent(temporalDirectory);
				PrintWriter out = response.getWriter();
				response.setContentType("text/html");
				out.println(e1.getMessage());
				return;
			}
		}
		
		//Execute Pitch and Intensity script
		List<String> command = new ArrayList<String>();
		command.add(Global.PRAAT_LOCATION);
		command.add("--run");
		command.add("--no-pref-files");
		command.add(SERVER_SCRIPTS_FOLDER + "pitchIntensityScript.praat");
		command.add(temporalDirectory);
		command.add(ref);
		try {
			Utils.executeCommand(command, 300000);
		} catch (Exception e1) {
			e1.printStackTrace();
			Utils.deleteFolderAndContent(temporalDirectory);
			PrintWriter out = response.getWriter();
			response.setContentType("text/html");
			out.println(e1.getMessage());
			return;
		}
		
		//Forward to viewer
		RequestDispatcher dispatcher = request.getRequestDispatcher("/Viewer");
		String contextPath = context.getContextPath();
		request.setAttribute("audioFile", contextPath + "/tmp/" + ref + "/" + ref + ".wav");
		request.setAttribute("resultFile", resultFilePath);
		request.setAttribute("graphData", contextPath + "/tmp/" + ref + "/" + ref + ".graph");
		request.setAttribute("tmpGeneratedFolder", ref);
		dispatcher.forward(request, response);
		
	}
	
}
