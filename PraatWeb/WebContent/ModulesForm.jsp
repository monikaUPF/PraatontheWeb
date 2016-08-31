<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Strict//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
	<%@ page import="java.util.HashMap" %>
	<%@ page import="edu.upf.dtic.classes.FileFormInfo" %>
	<%@ page import="java.util.Map.Entry" %>

	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
	<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
	<link href="forms.css" rel="stylesheet" type="text/css"/>
	<link href="general.css" rel="stylesheet" type="text/css"/>
	<title>Demo 2: Modular Scripting</title>
</head>
<body>
	<div class="container">
		<div class="page-header">
		    <h1 class="left">Demo 2: Modular Scripting</h1>
		     <a href="${pageContext.servletContext.contextPath}/index.jsp" class="right back">Back to Menu <span class="glyphicon glyphicon-hand-left"></span></a>
		</div>
		<div class="page-subheader">
		    <h3 class="left">
		    	A prosody tagger implemented as a modular pipeline is used as an example of modular scripting using features. Users can upload their own speech files for segmentation in prosodic phrases and prominence detection or use sample files. Two possible configurations are shown:
		    	<ul class="with-style">
				    <li>with prediction on words segments: a TextGrid with the word segmentation on tier number 1 must be uploaded for this configuration</li>
				    <li>with prediction on raw speech: prominence is outputted as peak points.</li>
			    </ul>
		    	Users can furthermore select if they want to visualize all tiers generated from each module or only the final prediction (i.e., prosodic phrases and prominence).
		    </h3>
		</div>
		<div class="form" id="formDiv">
			<form action="Modules" method="post" enctype="multipart/form-data" id="runForm">
				<div class="row">
	  				<div class="col-sm-5">
		  				<div class="praat-group">
			  				<div class="related-praat-group">
								<label for="audioFile">Upload your audio file or select a sample file:</label>
								<input type="file" id="audioFile" name="audioFile" size="50" class="fileInput"/>
							</div>
							<div >
							 	<select class="form-control" id="audioSel" name="audioSelection">
							 		<option value="" selected="selected">Select an option</option>
							 		<%
								 		HashMap<String, FileFormInfo> audioData = (HashMap<String, FileFormInfo>)request.getAttribute("audioData");
										if(audioData != null){
											for(Entry<String, FileFormInfo> entry : audioData.entrySet()) {
									   			String key = entry.getKey();
									   			String value = entry.getValue().getDescription();
									   			%><option value="<%=key%>"><%=value%></option><%
											}
										}
							 		%>
								</select>
							</div>
						</div>
						
						<div class="row praat-group" >
							<div class="col-sm-12">
								<label for="modulesSelector">Select a pipeline configuration:</label>
							</div>
			  				<div class="col-sm-6">
			  					<input type="button" class="btn btn-textgrid btn-lg" onClick="def1();" value="Word Segments"/>
			  				</div>
			  				<div class="col-sm-6">
			  					<input type="button" class="btn btn-textgrid btn-lg right" onClick="def2();" value="Raw Speech"/>
			  				</div>
						</div>
						<div class="praat-hidden" id="textgridDiv">
							<div class="praat-group">
				  				<div class="related-praat-group">
									<label for="textGridFile">Upload your TextGrid file or select a sample file: </label> 
									<input type="file" id="textGridFile" name="textGridFile" size="50" class="fileInput"/>
				  				</div>
				  				<div >
								 	<select class="form-control" id="tgSel" name="textgridSelection">
								 		<option value="" selected="selected">Select an option</option>
								 		<%
									 		HashMap<String, FileFormInfo> textGridData = (HashMap<String, FileFormInfo>)request.getAttribute("textGridsData");
											if(textGridData != null){
												for(Entry<String, FileFormInfo> entry : textGridData.entrySet()) {
										   			String key = entry.getKey();
										   			String value = entry.getValue().getDescription();
										   			%><option value="<%=key%>"><%=value%></option><%
												}
											}
								 		%>
									</select>
				  				</div>
				  			</div>
						</div>
				
						<div class="praat-hidden" id="checkboxDiv">
			  				<div class="praat-group">
			  					<label for="justFinalTiers">Select visualization mode:</label>
				  				<div class="checkbox">
									<label><input type="checkbox" id="justFinalTiers" name="justFinalTiers" class="large-checkbox" value="1" > Only predicted tiers</label>
								</div>
			  				</div>
			  			</div>
					</div>
					<div class="col-sm-2"></div>
	  				<div class="col-sm-5">
	  					<div class="praat-group">
			  				<div data-force="30" class="layer block" style="width: 100%;">
								<div class="layer title">Selected modules</div>
								<ul id="selected" class="block__list block__list_words">
								</ul>
							</div>
	  					</div>
		  				<div class="praat-group" style="display:none">
		  					<div data-force="18" class="layer block" style="width: 100%;">
								<div class="layer title">Available modules</div>
								<ul id="available" class="block__list block__list_words">
								<%
									HashMap<String, FileFormInfo> scriptsData = (HashMap<String, FileFormInfo>)request.getAttribute("scriptsData");
									if(scriptsData != null){
										for(Entry<String, FileFormInfo> entry : scriptsData.entrySet()) {
								   			String key = entry.getKey();
											out.println("<li data-id=\"" + key + "\"><span class='drag-handle'>&#9776;</span>" + entry.getValue().getDescription() + "</li>");
										}
									}
								%>
								</ul>
							</div>
		  				</div>
		  				<input type="hidden" id="scripsOrder" name="scripsOrder"/>
						<input type="hidden" id="wtd" name="wtd"/>
					</div>
				</div>
				
				<div class="row">
					<div class="col-sm-7"></div>
					<div class="col-sm-5">
						<div class="praat-group">
							<div id="errorMessage" style="color: #FF0000;">${errorMessage}</div>
		  					<input type="button" class="btn btn-textgrid btn-lg" onClick=" if(checkAll())run();" value="Run" />
		  				</div>
	  				</div>
				</div>
			</form>
		</div>
	</div>
	
	<script src="Sortable.js"></script>
	<script src="modules.js"></script>
	
</body>
</html>