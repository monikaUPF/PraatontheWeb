package edu.upf.dtic.servlets;

import static java.nio.file.StandardCopyOption.REPLACE_EXISTING;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
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
import edu.upf.dtic.classes.TextgridsManager;
import edu.upf.dtic.classes.Utils;

@MultipartConfig
public class ViewerFormServlet extends HttpServlet{

	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		response.setContentType("text/html");
	
		//Initialization needed attributes
		request.setAttribute("audioData", AudiosManager.getInstance().getAudiosInfo());
		request.setAttribute("textGridsData", TextgridsManager.getInstance().getViewSamplesInfo());
		
		getServletContext().getRequestDispatcher("/ViewerForm.jsp")
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
		String audioSelection = request.getParameter("audioSelection");
		Part audioFilePart = request.getPart("audioFile");
		InputStream audioFileContent = null;
		String textgridSelection = request.getParameter("textgridSelection");
		Part textGridFilePart = request.getPart("textGridFile");
		InputStream textGridFileContent = null;
		
		//Data checks
		boolean audioFile = (audioFilePart != null && audioFilePart.getSize() > 0);
		boolean audioSelector = !audioSelection.equals("");
		boolean textgridFile = (textGridFilePart != null && textGridFilePart.getSize() > 0);
		if (!textgridFile && textgridSelection.equals("")) {
			request.setAttribute("download", false);
			request.setAttribute("audioData", AudiosManager.getInstance().getAudiosInfo());
			request.setAttribute("textGridsData", TextgridsManager.getInstance().getViewSamplesInfo());
			request.setAttribute("errorMessage", "No TextGrid provided.");
			request.getRequestDispatcher("/ViewerForm.jsp").forward(request, response);
			return;
		}
		
		//Obtain the input streams
		if(audioFile){
			audioFileContent = audioFilePart.getInputStream();
		}
		if(textgridFile){
			textGridFileContent = textGridFilePart.getInputStream();
		}

		long currentMilis = System.currentTimeMillis();
		String ref = request.getRemoteAddr().replace(".", "") + currentMilis;
		String temporalDirectory = SERVER_UPLOAD_LOCATION_FOLDER + ref + "/";
		String textGridFilePath = temporalDirectory + ref + ".TextGrid";
		String audioFilePath = temporalDirectory + ref + ".wav";
		
		File theDir = new File(SERVER_UPLOAD_LOCATION_FOLDER + request.getRemoteAddr().replace(".", "") + currentMilis);
		// if the temportal directory does not exist, create it
		if (!theDir.exists()) {
		    try{
		        theDir.mkdir();
		    }catch(SecurityException se){
		    	request.setAttribute("download", false);
		    	request.setAttribute("audioData", AudiosManager.getInstance().getAudiosInfo());
		    	request.setAttribute("textGridsData", TextgridsManager.getInstance().getViewSamplesInfo());
				request.setAttribute("errorMessage", "Unexpected error creating temporal directory.");
				request.getRequestDispatcher("/ViewerForm.jsp").forward(request, response);
		        return;
		    }        
		}
		
		//We save needed files to the temporal directory
		if(audioFile){
			Utils.saveFile(audioFileContent, audioFilePath);
		}else if(audioSelector){
			String audiosFolderPath = context.getRealPath("/samples/audio") + "/";
			String audioFileName = AudiosManager.getInstance().getAudiosInfo().get(audioSelection).getFileName();
			Files.copy(Paths.get(audiosFolderPath + audioFileName), Paths.get(audioFilePath), REPLACE_EXISTING);
		}
		if(textgridFile){
			Utils.saveFile(textGridFileContent, textGridFilePath);
		}else{
			String textgridFolderPath = context.getRealPath("/samples/textgrid") + "/";
			String textgridFileName = TextgridsManager.getInstance().getViewSamplesInfo().get(textgridSelection).getFileName();
			Files.copy(Paths.get(textgridFolderPath + textgridFileName), Paths.get(textGridFilePath), REPLACE_EXISTING);
		}
		
		//Extract Pitch and Intensity script
		List<String> command = new ArrayList<String>();
		command.add(Global.PRAAT_LOCATION);
		command.add("--run");
		command.add("--no-pref-files");
		command.add(SERVER_SCRIPTS_FOLDER + "extractPitchIntensity.praat");
		command.add(temporalDirectory);
		command.add(ref);
				
		//Execute Pitch and Intensity script
		List<String> command2 = new ArrayList<String>();
		command2.add(Global.PRAAT_LOCATION);
		command2.add("--run");
		command2.add("--no-pref-files");
		command2.add(SERVER_SCRIPTS_FOLDER + "pitchIntensityScript.praat");
		command2.add(temporalDirectory);
		command2.add(ref);
		try {
			if(audioFile || audioSelector){
				Utils.executeCommand(command, 300000);
				Utils.executeCommand(command2, 300000);
			}
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
		if(audioFile || audioSelector){
			request.setAttribute("audioFile", contextPath + "/tmp/" + ref + "/" + ref + ".wav");
			request.setAttribute("graphData", contextPath + "/tmp/" + ref + "/" + ref + ".graph");
		}
		request.setAttribute("resultFile", textGridFilePath);
		request.setAttribute("tmpGeneratedFolder", ref);
		request.setAttribute("download", 0);
		dispatcher.forward(request, response);
	}
}
