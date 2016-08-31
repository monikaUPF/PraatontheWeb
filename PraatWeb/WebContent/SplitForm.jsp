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
	<title>Demo 4: Splitting Features in Tiers</title>
</head>
<body>
	<div class="container">
		<div class="page-header">
		    <h1 class="left">Demo 4: Splitting Features in Tiers</h1>
		     <a href="${pageContext.servletContext.contextPath}/index.jsp" class="right back">Back to Menu <span class="glyphicon glyphicon-hand-left"></span></a>
		</div>
		<div class="page-subheader">
		    <h3 class="left">This functionality reverses the feature annotation to separate tiers. A TextGrid annotated with features is split in tiers. Segments must contain the same number of features located in the same position. Feature labels will be used as tier names and feature values as segment labels.</h3>
		</div>  
		<div class="form" id="formDiv">
			<form action="Split" method="post" enctype="multipart/form-data" id="runForm">
				<div class="row">
	  				<div class="col-sm-5">
		  				<div class="praat-group">
			  				<div class="related-praat-group">
								<label for="audioFile">(Optional) Upload your audio file or select a sample file:</label>
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
			  			
			  			<div class="praat-group">
							<label for="tierNumber">Select tier number for splitting features:</label>
					    	<input type="text" class="form-control" id="tierNumber" name="tierNumber">
				  		</div>
					</div>
					<div class="col-sm-2"></div>
	  				<div class="col-sm-5">
	  					<div class="praat-group">
	  						<img src="${pageContext.servletContext.contextPath}/images/pic1.png" class="thumbnail"/>
	  					</div>
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
	
	<script src="split.js"></script>
	
</body>
</html>