package edu.upf.dtic.servlets;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import edu.upf.dtic.classes.Interval;
import edu.upf.dtic.classes.IntervalTier;
import edu.upf.dtic.classes.Point;
import edu.upf.dtic.classes.PointTier;
import edu.upf.dtic.classes.Segment;
import edu.upf.dtic.classes.TextGridStatus;
import edu.upf.dtic.classes.Tier;
import edu.upf.dtic.classes.Utils;

/**
 * Servlet implementation class ResultViewer
 */
@MultipartConfig
public class ViewerServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ArrayList<Tier> tiers;
       
    public ViewerServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		tiers = new ArrayList<Tier>();
		
		//Get information from textgrid and do the necessary calculations for its printing.
		String result = (String)request.getAttribute("resultFile");
		readTextGridFile(result);
		for(Tier t : tiers){
			t.calculatePercentages();
			t.generateFeatures();
		}
		request.setAttribute("tiers", tiers);
		
		getServletContext().getRequestDispatcher("/Viewer.jsp").forward(request, response);  
		tiers.clear();
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String resultFile = (String)request.getAttribute("resultFile");
		if(resultFile!= null && !resultFile.equals("")){ //If we come from a form
			doGet(request, response);
		}else{ //If we come from the download button
			String ref = request.getParameter("ref");
			
			ServletContext context = getServletContext();
			String tmpPath = context.getRealPath("/tmp");
			String temporalDirectory = tmpPath + "/" + ref + "/";
			String resultFilePath = temporalDirectory + ref + "_result.TextGrid";
			
			//We retrieve the result textgrid file
			response.setContentType("application/octet-stream");
	        response.setHeader("Content-Disposition","attachment;filename=result.TextGrid");
			ServletOutputStream outFile = response.getOutputStream();
			response.setContentType("multipart/form-data");
			FileInputStream in = new FileInputStream(resultFilePath);
			byte[] buffer = new byte[4096];
			int length;
			while ((length = in.read(buffer)) > 0){
				outFile.write(buffer, 0, length);
			}
			in.close();
			outFile.flush();
			outFile.close();
			
			//We delete the temporal folder containing the created files
			Utils.deleteFolderAndContent(temporalDirectory);
		}
	}
	
	/**
	 * Status machine that extracts information from the textgrid and save it in an ArrayList<Tier> object
	 * @param result
	 * @return
	 */
	private void readTextGridFile(String result){
		Pattern p1 = Pattern.compile("text = \\\"(.*)\\\"");
		Pattern p2 = Pattern.compile("mark = \\\"(.*)\\\"");
		try (BufferedReader br = new BufferedReader(new FileReader(result)))
		{
			Segment currentSegment = null;
			Tier currentTier = null;
			int totalSegments = 0;
			int currentSegmentNumber = 0;
			int totalTiers = 0;
			int currentTierNumber = 0;
			int status = TextGridStatus.INITIAL;
			String sCurrentLine;
			while ((sCurrentLine = br.readLine()) != null) {
				if(sCurrentLine == null || sCurrentLine.length() == 0 || sCurrentLine.equals("")){
				}else{
					String[] parts = sCurrentLine.trim().split(" ");
					switch(status){
					case TextGridStatus.INITIAL:
						if(parts[0].equals("size")){
							totalTiers = Integer.parseInt(parts[2]);
						}else if(parts[0].equals("item")){
							status = TextGridStatus.READING_ITEMS;
						}
						break;
					case TextGridStatus.READING_ITEMS:
						currentSegmentNumber = 0;
						if(parts[0].equals("class")){
							currentTierNumber++;
							if(parts[2].equals("\"IntervalTier\"")){
								status = TextGridStatus.INTERVAL_HEADER;
								currentTier = new IntervalTier();
							}else if(parts[2].equals("\"TextTier\"")){
								status = TextGridStatus.POINT_HEADER;
								currentTier = new PointTier();
							}
						}
						break;
					case TextGridStatus.INTERVAL_HEADER:
						String name1;
						float totalTime1;
						if(parts[0].equals("name")){
							name1 = parts[2].substring(1, parts[2].length()-1);
							currentTier.setName(name1);
						}else if(parts[0].equals("xmax")){
							totalTime1 = Float.valueOf(parts[2]);
							currentTier.setTotalLenght(totalTime1);
						}else if(parts[0].equals("intervals:")){
							totalSegments = Integer.valueOf(parts[3]);
						}else if(parts[0].equals("intervals")){
							currentSegmentNumber++;
							currentSegment = new Interval();
							status = TextGridStatus.INTERVAL_CONTENT;
						}
						break;
					case TextGridStatus.INTERVAL_CONTENT:
						float min = 0, max = 0;
						String text = "";
						Matcher m1 = p1.matcher(sCurrentLine.trim());
						if(parts[0].equals("xmin")){
							min = Float.valueOf(parts[2]);
							((Interval)currentSegment).setInitialPoint(min);
						}else if(parts[0].equals("xmax")){
							max = Float.valueOf(parts[2]);
							((Interval)currentSegment).setFinalPoint(max);
						}else if(parts[0].equals("text") && m1.find()){
							text = m1.group(1);
							currentSegment.setContent(text);
							currentTier.addSegment(((Interval)currentSegment));
							if(currentSegmentNumber >= totalSegments){
								tiers.add(currentTier); 
								currentTier = null; 
								if(currentTierNumber >= totalTiers){
									status = TextGridStatus.END;
								}else{
									status = TextGridStatus.READING_ITEMS;
								}
							}else
								status = TextGridStatus.INTERVAL_HEADER;
						}
						break;
					case TextGridStatus.POINT_HEADER:
						String name2;
						float totalTime2;
						if(parts[0].equals("name")){
							name2 = parts[2].substring(1, parts[2].length()-1);
							currentTier.setName(name2);
						}else if(parts[0].equals("xmax")){
							totalTime2 = Float.valueOf(parts[2]);
							currentTier.setTotalLenght(totalTime2);
						}else if(parts[0].equals("points:")){
							totalSegments = Integer.valueOf(parts[3]);
						}else if(parts[0].equals("points")){
							currentSegmentNumber++;
							currentSegment = new Point();
							status = TextGridStatus.POINT_CONTENT;
						}
						break;
					case TextGridStatus.POINT_CONTENT:
						float number = 0;
						String mark = "";
						Matcher m2 = p2.matcher(sCurrentLine.trim());
						if(parts[0].equals("number")){
							number = Float.valueOf(parts[2]);
							((Point)currentSegment).setPoint(number);
						}else if(parts[0].equals("mark") && m2.find()){	
							mark = m2.group(1);
							currentSegment.setContent(mark);
							currentTier.addSegment(((Point)currentSegment));
							if(currentSegmentNumber >= totalSegments){
								tiers.add(currentTier); 
								currentTier = null; 
								if(currentTierNumber >= totalTiers){
									status = TextGridStatus.END;
								}else{
									status = TextGridStatus.READING_ITEMS;
								}
							}else
								status = TextGridStatus.POINT_HEADER;
						}
						break;
					case TextGridStatus.END:
						break;
					}
					
				}
			}
		}catch(Exception e){
			System.out.println("Error: " + e.getMessage());
			e.printStackTrace();
		}
	}

}
