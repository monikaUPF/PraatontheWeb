<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<%@ page import="java.util.ArrayList" %>
		<%@ page import="edu.upf.dtic.classes.Tier" %>
		<%@ page import="edu.upf.dtic.classes.IntervalTier" %>
		<%@ page import="edu.upf.dtic.classes.PointTier" %>
		<%@ page import="edu.upf.dtic.classes.Segment" %>
		<%@ page import="edu.upf.dtic.classes.Interval" %>
		<%@ page import="edu.upf.dtic.classes.Point" %>
		<%@ page import="edu.upf.dtic.classes.Pair" %>
		<%@ page import="edu.upf.dtic.classes.Utils" %>
	
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
		<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
		<link href="viewer.css" rel="stylesheet" type="text/css"/>
		<link href="general.css" rel="stylesheet" type="text/css"/>
		<title>Praat viewer</title>
		
	</head>
	<body class="bg-color0" >
		<%
			String audioFile = (String)request.getAttribute("audioFile");
			Integer downloadButton = (Integer)request.getAttribute("download");
			if(downloadButton == null) downloadButton = 1;
			String file = (String)request.getAttribute("resultFile");
			String ref = (String)request.getAttribute("tmpGeneratedFolder");
			boolean isAudio = audioFile != null && !audioFile.equals("");
		%>
		<div class="container">
			<div class="page-header">
			    <h1 class="left">Viewer</h1>
			     <a href="${pageContext.servletContext.contextPath}/index.jsp" class="right back">Back to Menu <span class="glyphicon glyphicon-hand-left"></span></a>
			</div>
			<div class="page-subheader">
			    <h3 class="left">
				    <ul>
					    <li>To zoom in and zoom out, use the amplifying sliding bar below</li>
					    <%if(isAudio){%>
							<li>To playback the whole sound, use the play/pause button below</li>
							<li>To listen to an interval segment, double click on the interval and click on the oscilogram</li>
							<li>To move along the sound or TextGrid file, use the slide bar below the waveform</li>
						<%}else{ %>
							<li>To move along the TextGrid file, use the slide bar below the tiers</li>
						<%} %>
					</ul>
				</h3>
			</div>
			<div id="tooltip" class="bg-color1 border-color5 color5">
				<span id="title" class="medium-font">FEATURES:</span>
				<span id="features" class="medium-font"></span>
			</div>
			<div class="container-fluid" style="text-align: center">
				<p class= "row">
					<div class="textgrid-overflow col-xs-12">
						<div id="waveform"></div>
						<div id="waveform-timeline"></div>
						<div id="drawings" class="arial medium-font">
							<svg  id = "axis"></svg>
							<div id="chart"></div>
						</div>
						<div id="textgrid-outside">
						<%
						ArrayList<Tier> resultFile = (ArrayList<Tier>)request.getAttribute("tiers");
						for(int i = 0; i < resultFile.size(); i++){
							int top = 20 + i*60;
							%><div class="tier-title large-font serif" style="top:<%=top%>px;"><span><%=resultFile.get(i).getName()%></span></div><%
						}
						%>
							<div id="textgrid-overflow">
								<div id="textgrid-resize">
									<%
									//ArrayList<Tier> resultFile = (ArrayList<Tier>)request.getAttribute("tiers");
									int nt = 1;
									for(Tier t: resultFile){
										%>
										<div class=<%
										if(t instanceof IntervalTier){
											%>"textgrid-tier bg-color2"<%
										}else if(t instanceof PointTier){
											%>"textgrid-tier bg-color2 border-color4"<%
										}
										int ns = 1;
											for(int j = 0; j < t.getSegments().size(); j++){
												Segment s = t.getSegments().get(j);
												if(s instanceof Interval){
													String id = "i" + nt + "s" + ns;
													ArrayList<Pair<String, String>> features = s.getFeatures();
													String featuresString = "";
													for(int i = 0; i < features.size(); i++){
														featuresString += features.get(i).getFirst() + ": " + features.get(i).getSecond();
														if(i < features.size()-1)
															featuresString += "\n";
													}
													%>
													><span id="<%=id%>" data-tooltip="<%=featuresString%>" startSec="<%=((Interval)s).getInitialPoint()%>" finalSec="<%=((Interval)s).getFinalPoint()%>" origsize = "<%=s.getPercentage()%>" style= "width: <%=s.getPercentage()%>%;" class= "textgrid-segment serif large-font border-color0" ><%=s.getTitle()%></span
													<%
												}else if(s instanceof Point){
													String id = "p" + nt + "s" + ns;
													ArrayList<Pair<String, String>> features = s.getFeatures();
													String featuresString = "";
													for(int i = 0; i < features.size(); i++){
														featuresString += features.get(i).getFirst() + ": " + features.get(i).getSecond();
														if(i < features.size()-1)
															featuresString += "\n";
													}
													
													if(((Point)s).isGapPoint()){
													%>
													><div id="<%=id%>" class="supra gap border-color0 <%if(j==0){%><!--left-border--><%}else if(j==t.getSegments().size()-1){%><!--right-border--><%}%>" data-tooltip="<%=featuresString%>" second="<%=((Point)s).getPoint()%>" origsize = "<%=s.getPercentage()%>" style= "width: <%=s.getPercentage()%>%;">
													<%
													}else{
													%>
													><div id="<%=id%>" class="supra border-color0 <%if(j==0){%><!-- left-border--><%}else if(j==t.getSegments().size()-1){%><!--right-border--><%}%>" data-tooltip="<%=featuresString%>" second="<%=((Point)s).getPoint()%>" origsize = "<%=s.getPercentage()%>" style= "width: <%=s.getPercentage()%>%;">
													<div class="phantom-div">
														<div class="phantom-area"></div>
													</div>
													<div class="vertical-line border-color0"></div>
													<span class= "textgrid-point-out" ></span>
													<span class= "textgrid-point serif large-font bg-color2" ><%=s.getTitle()%></span>
													<span class= "textgrid-point-out" ></span>
													<%
													}
													%>
													</div
													<%
												}
												ns++;
											}
										%>
										></div>
										<%
										nt++;
									}
									%>
								</div>
							</div>
						</div>
					</div>
					
				</p>
				<p class="row">
					<div class="col-xs-1">
						<i class="glyphicon glyphicon-zoom-out icon-large"></i>
					</div>
					<div class="col-xs-10">
						<input id="slider" type="range" min="50" max="1250" value="50" style="width: 100%" />
					</div>
					<div class="col-xs-1">
						<i class="glyphicon glyphicon-zoom-in icon-large"></i>
					</div>
				</p>
				<% 
				if(isAudio){
				%>
				
				<p class= "row">
					<%if(downloadButton==1){ %>
					<div class="col-xs-6">
					<%}else{%>
					<div class="col-xs-12">
					<%}%>
						<button id="playPause" class="btn btn-textgrid btn-lg" onclick="wavesurfer.playPause()">
							<span class="glyphicon glyphicon-play"></span> Play
						</button>
					</div>
					<%if(downloadButton==1){ %>
						<div class="col-xs-6">
							<form action="Viewer" method="post" enctype="multipart/form-data" id="downloadForm">
								<input type="hidden" id="ref" name="ref" value="<%=ref%>"/>
								<input type="button" id="download" class="btn btn-textgrid btn-lg" onClick="downloadTextgrid()" value="Download and Back to Menu"/>
							</form>
						</div>
					<%}%>
				</p>
				<%}else{
					if(downloadButton==1){%>
					<p class= "row">
						<div class="col-xs-12">
							<form action="Viewer" method="post" enctype="multipart/form-data" id="downloadForm">
								<input type="hidden" id="ref" name="ref" value="<%=ref%>"/>
								<input type="button" id="download" class="btn btn-textgrid btn-lg" onClick="downloadTextgrid()" value="Download and Back to Menu"/>
							</form>
						</div>
					</p>
				<%	}
				  }%>
			</div>
		
		</div>

		<!-- <script src="//cdnjs.cloudflare.com/ajax/libs/wavesurfer.js/1.0.52/wavesurfer.min.js"></script> -->
		<script src="wavesurfer.js"></script>
		<script src="wavesurfer.regions.js"></script>
		<script src="wavesurfer.timeline.js"></script>
		<script src="//d3js.org/d3.v3.js"></script>
		<script type="text/javascript">
			<%
			if(isAudio){
			%>
				var soundSeconds = 0;
				var timeline;
				
				var margin, width, height;
				var parseTime
				var x, y0, y1;
				var xAxis, yAxisLeft, yAxisRight;
				var valueline, valueline2;
				var svg;
			
				var wavesurfer = WaveSurfer.create({
					height:150,
				    container: '#waveform',
				    scrollParent: true,
				    waveColor: '#3fb0ac',
				    progressColor: '#547980',
				    fillParent:false
				});
				wavesurfer.load('<%=audioFile%>');
	
				wavesurfer.on('ready', function () {
					soundSeconds = wavesurfer.getDuration();
					var minPxPerSec = wavesurfer.params.minPxPerSec;
					
					var totalPixels = $("#waveform").innerWidth() - 140;
					var pxPerSec = totalPixels/soundSeconds;
					wavesurfer.zoom(pxPerSec);
					$('#textgrid-resize').css("width", (totalPixels) + "px");

					setGraphParams(totalPixels);
					initializeGraph();
					$('#slider').attr("min", pxPerSec);
					$('#slider').val(pxPerSec);
					
					timeline = Object.create(WaveSurfer.Timeline);
					timeline.init({
					  wavesurfer: wavesurfer,
					  container: '#waveform-timeline'
					});
					
					$("#waveform").children("wave").children("canvas").addClass("bg-colorWhite");
					
				});
				
				wavesurfer.on('zoom', function (pxPerSec) {
					$('#textgrid-resize').css("width", (soundSeconds*pxPerSec) + "px");
				});

				wavesurfer.on('scroll', function (scrollEvent) {
					var scroll = scrollEvent.target.scrollLeft;
					var elems = $('.textgrid-segment');
					for (var i = 0, len = elems.length; i < len; i++) {
						$("#"+elems[i].id).css("left", -scroll);
					}
					var elems = $('.supra');
					for (var i = 0, len = elems.length; i < len; i++) {
						$("#"+elems[i].id).css("left", -scroll);
					}
					$("#myCanvas").css("left", -scroll);
					$("#lines").css("left", -scroll);
				});

				wavesurfer.on('region-click', function (region, mouseEvent) {
					if(wavesurfer.isPlaying()){
						wavesurfer.pause();
					}
					mouseEvent.stopPropagation();
					region.play();
				});

				wavesurfer.on('play', function (){
					$("#playPause").html("<i class='glyphicon glyphicon-pause'></i> Pause");
				});

				wavesurfer.on('pause', function (){
					$("#playPause").html("<i class='glyphicon glyphicon-play'></i> Play");
				});
				
				$(".textgrid-segment").dblclick(
					function(){
						clearSelection();
						
						var found = false;
						if (wavesurfer.regions) {
							var regions = wavesurfer.regions.list;
							for(region in regions){
								if(region === this.id){
									found = true;
									break;
								}
							}
						}
						
						wavesurfer.clearRegions();
						
						if(found == false){
							var start = $(this).attr("startSec");
							var end = $(this).attr("finalSec");
							var point = start/soundSeconds;
							wavesurfer.addRegion({
								id: $(this).attr("id"),
							    start: start,
							    end: end,
							    drag: false,
							    resize: false,
							    color: "rgba(33, 77, 130, 0.1)"
							});
							wavesurfer.seekAndCenter(point);
							if(wavesurfer.isPlaying()){
								wavesurfer.pause();
								wavesurfer.regions.list[this.id].play();
							}
						}else{
							if(wavesurfer.isPlaying()){
								wavesurfer.pause();
								wavesurfer.play();
							}
						}
					}
				);
				
				$(".phantom-area").dblclick(
					function(){
						clearSelection();
						wavesurfer.clearRegions();
						var parent = $(this).parent().parent();
						var second = parent.attr("second");
						var point = second/soundSeconds;
						wavesurfer.seekAndCenter(point);
					}
				);
				
				var slider = document.querySelector('#slider');
				slider.oninput = function () {
				  var zoomLevel = Number(slider.value);
				  wavesurfer.zoom(zoomLevel);
				  zoom(soundSeconds*zoomLevel);
				};
				
				function setGraphParams(newWidth){
					margin = {top: 20, right: 40, bottom: 30, left: 100},
					    width = newWidth /*- margin.left - margin.right*/,
					    height = 158 /*- margin.top*/ - margin.bottom;
					
					parseTime = d3.time.format("%S.%L").parse;
					
					x = d3.time.scale().range([0, width]);
					y0 = d3.scale.linear().range([height, 0]);
					y1 = d3.scale.linear().range([height, 0]);
					
					xAxis = d3.svg.axis().scale(x)
					    .orient("bottom").ticks(d3.time.seconds, 1)
					    .tickFormat(d3.time.format("%M:%S"));
					
					yAxisLeft = d3.svg.axis().scale(y0)
				    .orient("left").ticks(2);
		
					yAxisRight = d3.svg.axis().scale(y1)
				    .orient("right").ticks(2); 
					
					valueline = d3.svg.line()
					    .interpolate("basis")
					    .defined(function(d) {return d.pitch != null && d.pitch != undefined && !isNaN(d.pitch);})
					    .x(function(d) { return x(d.time); })
					    .y(function(d) { return y0(d.pitch); });
					
					valueline2 = d3.svg.line()
						.interpolate("basis")
						.defined(function(d) {return d.intensity != null && d.intensity != undefined && !isNaN(d.intensity);})
					    .x(function(d) { return x(d.time); })
					    .y(function(d) { return y1(d.intensity); });
					
					svg = d3.select("#chart").append("svg")
					    .attr("width", width /*+ margin.left + margin.right*/)
					    .attr("height", height /*+ margin.top*/ + margin.bottom)
					    .attr("id", "lines")
					    .attr("class", "bg-colorWhite")
					  .append("g");
					    //.attr("transform", "translate(" + margin.left + "," + margin.top + ")");
				}
				
				function initializeGraph(){ 
					d3.tsv("<%=(String)request.getAttribute("graphData")%>", function(error, data) {
					if (error) throw error;
					
					data.forEach(function(d) {
						d.time = parseTime(d.time);
						d.pitch = +d.pitch;
						d.intensity = +d.intensity;
					});
					
					x.domain(d3.extent(data, function(d) { return d.time; }));
					y0.domain([Math.min(d3.min(data, function(d) {return Math.min(d.pitch);}), 75), Math.max(d3.max(data, function(d) {return Math.max(d.pitch);}), 500)]); 
					y1.domain([Math.min(d3.min(data, function(d) {return Math.min(d.intensity);}), 50), Math.max(d3.max(data, function(d) {return Math.max(d.intensity);}), 100)]);
					
					svg.append("g")
				      .attr("class", "x axis")
				      .attr("transform", "translate(0," + height + ")")
				      .call(xAxis);
					
					d3.select("#axis").append("g")
				      .attr("class", "y axis a-left fill-color2")
				      .call(yAxisLeft)
				    .append("text")
				      .attr("transform", "rotate(-90)")
				      .attr("y", 6)
				      .attr("dy", ".71em")
				      .style("text-anchor", "end")
				      .text("Hz");
					  
					d3.select("#axis").append("g")
				      .attr("class", "y axis a-right fill-color3")
				      .attr("transform", "translate(" + width + " ,0)")
				      .call(yAxisRight)
				    .append("text")
				      .attr("transform", "rotate(90)")
				      .attr("y", 6)
				      .attr("dy", ".71em")
				      .text("dB");
					  
					svg.append("path")
				      .datum(data)
				      .attr("class", "line2 color3")
				      .attr("d", valueline2);
					  
					svg.append("path")
				      .datum(data)
				      .attr("class", "line1 color2")
				      .attr("d", valueline);
					});
				};
				
				function zoom(value){ 
					$("svg").attr("width", value + "px");
					width = value;
					x = d3.time.scale().range([0, width]);
					xAxis = d3.svg.axis().scale(x)
				    .orient("bottom").ticks(d3.time.seconds, 1)
				    .tickFormat(d3.time.format("%M:%S"));
					
					$(".y.axis.a-right").attr("transform", "translate(" + Math.min($("#lines").outerWidth(), $("#chart").outerWidth()) + " ,0)");
					
					d3.tsv("<%=(String)request.getAttribute("graphData")%>", function(error, data) {
						var svg = d3.select("#drawings").transition();
							
						data.forEach(function(d) {
							  d.time = parseTime(d.time);
							  d.pitch = +d.pitch;
							  d.intensity = +d.intensity;
						  });
						
						x.domain(d3.extent(data, function(d) { return d.time; }));
						
						svg.select(".line1")
							.duration(0)
			            	.attr("d", valueline(data));
						
						svg.select(".line2")
						.duration(0)
		            	.attr("d", valueline2(data));
							
						svg.select(".x.axis") // change the x axis
			            .duration(0)
			            .call(xAxis);
					});
				}
				
				$(window).resize(function() {
					$(".y.axis.a-right").attr("transform", "translate(" + Math.min($("#lines").outerWidth(), $("#chart").outerWidth()) + " ,0)");
					var totalPixels = $("#waveform").innerWidth() - 90;
					var pxPerSec = totalPixels/soundSeconds;
					wavesurfer.zoom(pxPerSec);
					$('#textgrid-resize').css("width", (totalPixels) + "px");
					zoom(totalPixels);
					$('#slider').attr("min", pxPerSec);
					$('#slider').val(pxPerSec);
				});
			
			<%
			}else{
			%>
				$("#waveform").css("display", "none");
				$("#waveform-timeline").css("display", "none");
				$("#drawings").css("display", "none");
				$("#textgrid-overflow").css("overflow", "auto");
				$("#textgrid-resize").css("width", "100%");
				$("#slider").attr("min", 100);
				$("#slider").attr("max", 2000);
				$('#slider').val(100);
			
				var slider = document.querySelector('#slider');
				slider.oninput = function () {
				  $("#textgrid-resize").css("width", slider.value + "%");
				};
			<%
			}
			%>
			
			function downloadTextgrid(){
				document.getElementById("downloadForm").submit();
				$("#download").attr("disabled", true);
				 setTimeout(function () {
			        document.location.pathname = "${pageContext.servletContext.contextPath}/index.jsp";
			    }, 1000);
			}
		</script>
		<script src="viewer.js"></script>
		
	</body>
</html>