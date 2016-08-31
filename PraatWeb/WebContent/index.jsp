<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
	<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
	<link href="index.css" rel="stylesheet" type="text/css"/>
	<link href="general.css" rel="stylesheet" type="text/css"/>
<title>Praat on the Web Demo</title>
</head>
<body>
	<div class="container">
	  <div class="page-header">
	  	<h1 class="left big">Praat on the Web Demo</h1>
	  </div>
	  <div class="page-subheader">
		<h3 class="left">This website demonstrates two Praat on the Web functionalities: web visualization (demo 1) and modular scripting using features (demo 2). Two further demos on feature annotation are available for merging tiers as feature vectors (demo 3) and splitting features into tiers (demo 4).<br/>To access each demo, click on the Enter Demo button.</h3>
	  </div>
	  <div class="jumbotron">
	    <div class="left-content">
		    <h2>Visualization Tool</h2>
		    <p>This functionality allows users to upload their own speech samples and TextGrids for online visualization and audio playback. Sample files are also available.</p>
		    <a href="${pageContext.servletContext.contextPath}/ViewerForm" role="button" class="btn btn-textgrid btn-lg">Enter Demo 1</a>
	    </div>
	    <div class="right-content">
	    	<img src="${pageContext.servletContext.contextPath}/images/pic2.png" class="thumbnail"/>
	    </div>
	  </div>
	  
	  <div class="jumbotron">
	    <div class="left-content">
		    <h2>Modular Scripting Using Features</h2>
		    <p>This demo includes a prosody tagger which has been scripting in as a modular pipeline, thanks to the functionality of feature annotation. Users can test two possible pipeline configurations to perform prosodic phrases and prominence prediction on word segments or on raw audio. A TextGrid with the word segmentation of the file needs to be uploaded in case the prediction on word segments is selected. Sample files are also available.</p>
		    <a href="${pageContext.servletContext.contextPath}/Modules" role="button" class="btn btn-textgrid btn-lg">Enter Demo 2</a>
	    </div>
	    <div class="right-content">
	    	<img src="${pageContext.servletContext.contextPath}/images/pic2.png" class="thumbnail"/>
	    </div>
	  </div>
	  
	  <div class="jumbotron">
	    <div class="left-content">
		    <h2>Feature Annotation: Merging Tiers</h2>
		    <p>This functionality allows to compare visualization capabilities of standard Praat annotation and feature annotation. Users can upload their TextGrid files containing several tiers (with the same number of intervals) to be merged as features to one main tier or run sample file demos.</p>
		    <a href="${pageContext.servletContext.contextPath}/Merge" role="button" class="btn btn-textgrid btn-lg">Enter Demo 3</a>
	    </div>
	    <div class="right-content">
	    	<img src="${pageContext.servletContext.contextPath}/images/pic2.png" class="thumbnail"/>
	    </div>
	  </div>
	  
	  <div class="jumbotron">
	    <div class="left-content">
		    <h2>Feature Annotation: Splitting Features</h2>
		    <p>This functionality allows reversing feature annotation. Users can upload previously generated TextGrids annotated with features (i.e., from the prosody tagger in demo 2) and split features to different intervals.</p>
		    <a href="${pageContext.servletContext.contextPath}/Split" role="button" class="btn btn-textgrid btn-lg">Enter Demo 4</a>
	    </div>
	    <div class="right-content">
	    	<img src="${pageContext.servletContext.contextPath}/images/pic2.png" class="thumbnail"/>
	    </div>
	  </div>
	  
	</div>
</body>
</html>