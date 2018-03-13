<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Jobs</title>
<jsp:include page="base.jsp" />
<jsp:include page="import.jsp" />
<script src="http://dev.openlayers.org/OpenLayers.js"></script>
 <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyD_K7a_keDsx4GsavNGTpPv_4a-ikBFyfc"></script>

<style>
#fullDiv {
position: relative;
    width: 100%;
    height: 800px;
    margin-right: auto;
    margin-left: auto;
    background-color: #FFF;
    padding: 0px 0px 0px 0px;
    font: 12px "Helvetica Neue", Helvetica, Arial, sans-serif;
    color: blue;
    border:0px solid #D8DC63;
    border-radius: 0px;
    -webkit-border-radius: 0px;
    -moz-border-radius: 0px;
    overflow:visible;
}
#mapDiv {
    width: 100%;
    height: 800px;
    margin-right: auto;
    margin-left: auto;
    background-color: #FFF;
    padding: 0px 0px 0px 0px;
    font: 12px "Helvetica Neue", Helvetica, Arial, sans-serif;
    color: blue;
    border:0px solid #D8DC63;
    border-radius: 0px;
    -webkit-border-radius: 0px;
    -moz-border-radius: 0px;
    overflow:visible;
}           

#jobsDiv, #ongoingJobsDiv {
/* 	position: absolute
	top: 200px;
	width: 220px;
	left: 0px;
	height: 210px;
    background-color: #000;
    opacity: 1;
    padding: 5px 5px 5px 5px;
    font: 12px "Helvetica Neue", Helvetica, Arial, sans-serif;
    color: #e17009;
	z-index: 99;
	overflow: scroll; */
	position: absolute;
        top:130px;
        left:0px;
    width: 220px;
    height: 200px;
    margin-right: 0;
    margin-left: 0;
    background-color: #FFF;
    opacity: 0.85;
    padding: 5px 5px 5px 5px;
    font: 12px "Helvetica Neue", Helvetica, Arial, sans-serif;
    color: blue;
    border:1px solid #D8DC63;
    border-radius: 0px;
    -webkit-border-radius: 0px;
    -moz-border-radius: 0px;
    z-index:9999;
    overflow:scroll;
}

#jobsDiv {
	top: 350px;
}

/* #rightDiv {
    position: absolute;
    top: 49px;
    right: 0px;
    width: 220px;
    height: 530px;
    margin-right: 0;
    margin-left: 0;
    background-color: #000;
    opacity: 1;
    padding: 5px 5px 5px 5px;
    font: 12px "Helvetica Neue", Helvetica, Arial, sans-serif;
    color: #e17009;
    z-index:9999;
    overflow:scroll;

            } */
#queryDiv, #layersDiv, #timestampsDiv, #legendDiv, #unitsDiv {
/*     position: absolute;
    top:49px;
    right: 0px;
    width: 220px;
    height: 40px;
    margin-right: 0;
    margin-left: 1;
    background-color: #000;
    opacity: 0.85;
    padding: 5px 5px 5px 5px;
    font: 12px "Helvetica Neue", Helvetica, Arial, sans-serif;
    color: #e17009;
    z-index:9999;
    overflow:scroll; */
position: absolute;
        top:50px;
        right:0px;
    width: 220px;
    height: 40px;
    margin-right: 0;
    margin-left: 0;
    background-color: #FFF;
    opacity: 0.85;
    padding: 5px 5px 5px 5px;
    font: 12px "Helvetica Neue", Helvetica, Arial, sans-serif;
    color: blue;
    border:1px solid #D8DC63;
    border-radius: 0px;
    -webkit-border-radius: 0px;
    -moz-border-radius: 0px;
    z-index:9999;
    overflow:scroll;

            }
            
#layersDiv {
   top:110px;
   height: 40px;
}

#timestampsDiv {
   top:170px;
   height: 40px;
}

#unitsDiv {
   top:230px;
   height: 40px;
}

#legendDiv {
	top: 290px;
	height: 150px;
}

.label {
  float: left;
  display: block;
  color: blue;
  text-align: left;
  padding: 14px 16px;
  text-decoration: bold;
  font-size: 14px;
}


#popupJobContainer {
	position: absolute;
	top: 200px;
	left: 270px;
	width: 320px;
	height: 375px;
	margin-right: 0;
	margin-left: 0;
	background-color: #FFF;
	padding: 5px 5px 5px 5px;
	font: 12px "Helvetica Neue", Helvetica, Arial, sans-serif;
	color: blue;
	border: 1px solid #e17009;
	border-radius: 0px;
	-webkit-border-radius: 0px;
	-moz-border-radius: 0px;
	z-index: 9999;
	overflow: scroll;
}

</style>
<script type="text/javascript">
var map;
var osm = new OpenLayers.Layer.OSM("Base Map");
var gsat;
var base = gsat;
var color;
var no_data;
var mapLayers = [];

$(document)
.ready(
		function() {
			initMap();
			map = new OpenLayers.Map(
                    {
                            div: "mapDiv",
                            //allOverlays: true,
                            projection: 'EPSG:4326',
                            displayProjection: new OpenLayers.Projection("EPSG:900913"),
                            layers: [gsat],
                            controls: [ new OpenLayers.Control.Navigation({ dragPanOptions: { enableKinetic: true } }),
                                   new OpenLayers.Control.PanZoom(),
                                   new OpenLayers.Control.ScaleLine({div: document.getElementById("scale")}),
                                   new OpenLayers.Control.Attribution()],
                                   center: new OpenLayers.LonLat(-94,42)
										.transform('EPSG:4326', 'EPSG:900913'),
                                                        zoom: 7
                    });
			var ibmid = localStorage.ibmid;
		    var password = localStorage.password;
		    var xclientid = localStorage.xclientid;
		    var xclientsecret = localStorage.xclientsecret;
		    color = localStorage.color;
            no_data = localStorage.no_data;
            if(color == undefined) {
                color = 'spectral';
            }
            if(no_data == undefined) {
                no_data = -9999;
            }
		    $.ajaxSetup({
				crossDomain: true,
		 		headers: {
		 			'Authorization': "Basic " + btoa(ibmid + ":" + password),
		      		"X-IBM-Client-Id": xclientid,
				    "X-IBM-Client-Secret": xclientsecret,
				    "Content-Type": "application/json"
		    	}
		    });
			populateJobs();
			// update jobs list evry 10s
			setInterval(function() { populateJobs();}, 10000);
});

function initMap() {
	gsat = new OpenLayers.Layer.Google(
	        "Google Satellite",
	        {type: google.maps.MapTypeId.SATELLITE, numZoomLevels: 22, visibility: true}
	    );
}

function removeAllLayers(){
    var num = map.getNumLayers();
    for (var i = num - 1; i> 0; i--) {
            map.removeLayer(map.layers[i]);
    }
}

function hideAllLayers(){
    var num = map.getNumLayers();
    for (var i = num - 1; i> 0; i--) {
        map.layers[i].setVisibility(false);
    }
}

function selectLayer(layer){
	hideAllLayers();
	map.getLayersByName("Base Map")[0].setVisibility(true);
	map.getLayersByName(layer)[0].setVisibility(true);
}

function getMapLayer(layerName) {
	for(var i=0; i<mapLayers.length; i++) {
		if(mapLayers[i].name == layerName) {
			return mapLayers[i];
		}
	}
	return null;
}


function changeDataLayer(elem) {
	var layerName = $(elem).val();
	var layer = map.getLayersByName(layerName)[0];
	var mapLayer = getMapLayer(layerName);
    hideAllLayers();
    gsat.setVisibility(true);
	layer.setVisibility(true);
	document.getElementById('legendImg').src = mapLayer.legendUrl;
	document.getElementById('unitsDiv').innerHTML = "<label>Units</label><br><label>" + mapLayer.unit.symbol + "(" + mapLayer.unit.name + ")" + "</label>";
}

function populateJobs(){
	$.getJSON(baseurl + '/v1/queries', {
		done : 'true'
	}, function(retdata) {
		var data = retdata.query;
		var html = '<h3>Completed Jobs</h4>';
		var len = data.length;
		if(len > 250) {
			len =250;
		}
		
		for ( var i = 0; i < len; i++) {
			if(data[i].job.deleted == true) {
				//deleted job so skipping it.
			} else {
				if(data[i].request.mime == 'x-ibm-wms') {
					html += '<a href="javascript:populateQueryjob(\'' + data[i].id + '\');">' + data[i].job.id + '</a><br>';
				} else {
				// different mime type, lets not show
				}
			}
		}
		$('#jobsDiv').html(html);
	});
	
	
	$.getJSON(baseurl + '/v1/queries', {
		done : 'false'
	}, function(retdata) {
		var data = retdata.query;
		var html = '<h3>Ongoing Jobs</h4>';
		var len = data.length;
		if(len > 250) {
			len =250;
		}
		
		for ( var i = 0; i < len; i++) {
			var details = JSON.stringify(data[i].request);
			html += '<a href="javascript:showDetails(\'' + data[i].id + '\');">' + data[i].job.id + '</a><br>';					
		}
		$('#ongoingJobsDiv').html(html);
	});
}

 function populateQueryjob(id) {		 
     removeAllLayers();
     //map.addLayer(gsat);
     //gsat.setVisibility(true);
     var layerName;
     var url;
     $.ajax(baseurl + '/v1/queries/'+id, {
	  	statusCode: {
	  	    401: function() {
	  	      	alert( "Unauthorized!! Please enter user credentials again." );
	  	    },
	  	    200: function(retdata) {
	  	    	var status = retdata.query[0].job.status;
  				if(status == "200" || status =="201") {
   		  			if(retdata.query[0].result.refs[0].mime == 'application/x-ibm-wms') {
   		  					var data = retdata.query[0].result.refs[0];		   		  			
		   		  			var geoserverUrl = data.geoserver;
		   		  			var workspace = data.workspace;
		   		  			var format = data.format;
		   		  			var len = data.layers.length;
		   		  			var html = '';
		   		  		html += '<option title="Select a datalayer">' 
		   					+ 'Select a datalayer'
		   					+ '</option>';	
							for ( var i = 0; i < len; i++) {	
		   		  				layerName = data.layers[i].name;
		   		  				var sld = gsurl + '/getSld?layer=' + workspace + ":" + layerName + '&color=' + color + '&min=' + data.layers[i].min + '&max=' + data.layers[i].max + '&no_data=' + no_data;
		   		  				var legendUrl = "http://169.48.109.215:31053/geoserver/wms?REQUEST=GetLegendGraphic&VERSION=1.0.0&FORMAT=image/png&WIDTH=20&HEIGHT=15&LAYER=" +workspace + ":" + layerName +
	"&type=raster&LEGEND_OPTIONS=forceRule:True;dx:1.0;dy:1.0;mx:1.0;my:1.0;borderColor:0000ff;border:true;fontColor:000000;fontSize:10&SLD=" + 
	gsurl + '/getSld?layer%3D' + workspace + ":" + layerName + '%26color%3D' + color + '%26min%3D' + data.layers[i].min + '%26max%3D' + data.layers[i].max + '%26no_data%3D' + no_data +
			"&legend_options=bgcolor=0x000000";

		   		  				var mapLayer = {name:layerName, legendUrl:legendUrl, color:color, min:data.layers[i].min, max:data.layers[i].max, unit:data.layers[i].unit};
		   						mapLayers.push(mapLayer);
		   						var newLayer = new OpenLayers.Layer.WMS(
			   						layerName, geoserverUrl,
			   					        {
			   					            layers: workspace + ":" + layerName,
			   					            format: format,
			   					            sld: sld,
			   					            transparent: true
			   					        },
			   					        {
			   					            buffer: 0,
			   							            displayOutsideMaxExtent: true,
			   							         displayInLayerSwitcher : true,
			   							            isBaseLayer: false,
			   							            yx : {'EPSG:4326' : true},
			   							           visibility: false
			   							        } 
			   							    );
			   					map.addLayer(newLayer);
			   					
			   					html += '<option value="' + layerName + '" title="' + layerName + '">'
								+ layerName + '</option>';
		   		  			}
		   		  		$('#datalayerList').html(html);
		   		  		document.getElementById('queryDiv').innerHTML = "<label>Query</label><br><label>" + retdata.query[0].name + "</label>";

   		  				} else {
   		  					alert("Mime type: " + retdata.query[0].result.refs[0].mime + ", geoserver is " + retdata.query[0].result.refs[0].geoserver);
   		  				}
   		  			} else {
   		  				alert("Job was not successful! " + retdata.query[0].job.message);
   		  			}
  	  }
 	}
 });
} 
 
function showDetails(id) {
	$.getJSON(baseurl + '/v1/queries/'+id, {
		done : 'false'
	}, function(retdata) {
		var data = retdata.query;
		var query = JSON.stringify(data[0].request, null, 2);
		var html = '';
		html += 'Query: ' + data[0].name + '<br>';
		html += '<pre>' + query + '</pre><br>';
		html += 'Status:' + data[0].job.status + '<br>';
		html += 'Message:' + data[0].job.message + '<br><br>';
					
		$('#popupJobDetails').html(html);
		$('#popupJobContainer').show();
	});
}
 
function closePopup() {
	$('#popupJobContainer').hide();
}
	
	
</script>
</head>
<body>
<div class="menuPages" id="menuPagesDiv">
  <a href="${pageContext.request.contextPath}/settings.jsp">Settings</a>
  <a href="${pageContext.request.contextPath}/colorSettings.jsp">Color Settings</a>
  <a href="${pageContext.request.contextPath}/simpleQuery.jsp">Query</a>
  <a href="${pageContext.request.contextPath}/simpleJobs.jsp">Jobs</a>
  <a href="${pageContext.request.contextPath}/simpleJobs2.jsp">Jobs 2</a>
  <a href="${pageContext.request.contextPath}/videos.jsp">Sample Jobs</a>
</div> 
<div id="fullDiv">

<div id="mapDiv"></div>
<div id="ongoingJobsDiv"><h3>Ongoing Jobs</h3><br></div>

<div id="jobsDiv">
<h3>Completed Jobs</h3><br>
</div>



<div id="queryDiv">
<label>Query</label><br>
</div>
<div id="layersDiv">
<label>DataLayers</label><br>
<select id="datalayerList" name="datalayer" onchange="changeDataLayer(this)" style="color: blue;width: 200px;"></select>
</div>
<div id="timestampsDiv">
<label>Time Stamps</label><br>
<div id="timesDiv"></div>
</div>
<div id="unitsDiv">
<label>Units</label><br>
</div>
<div id="legendDiv">
<label>Legend</label><br>
<img id="legendImg" src=""></img>
</div>


</div>

<!-- <div id="mapDiv"></div> -->
<div id="popupJobContainer" style="display:none">
<div id="popupJobDetails">
</div>
<input type="button" value="Ok" onclick="closePopup();">
</div>
</body>
</html>