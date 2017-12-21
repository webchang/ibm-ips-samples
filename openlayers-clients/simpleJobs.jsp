<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Jobs</title>
<jsp:include page="import.jsp" /> 
<script src="http://dev.openlayers.org/OpenLayers.js"></script>
<style>


 html, body {
                margin: 0;
                width: 100%;
                height: 100%;
            }
#mapDiv {
position: relative;
    width: 100%;
    height: 100%;
    margin-right: auto;
    margin-left: auto;
    background-color: #FFF;
    padding: 0px 0px 0px 0px;
    font: 12px "Helvetica Neue", Helvetica, Arial, sans-serif;
    color: #888;
    border:0px solid #D8DC63;
    border-radius: 0px;
    -webkit-border-radius: 0px;
    -moz-border-radius: 0px;
    overflow:visible;

            }
#jobsDiv, #ongoingJobsDiv {
    position: absolute;
    top:200px;
    left:0px;
    width: 220px;
    height: 210px;
    margin-right: 0;
    margin-left: 0;
    background-color: #FFF;
    opacity: 0.85;
    padding: 5px 5px 5px 5px;
    font: 12px "Helvetica Neue", Helvetica, Arial, sans-serif;
    color: #888;
    border:1px solid #e17009;
    border-radius: 0px;
    -webkit-border-radius: 0px;
    -moz-border-radius: 0px;
    z-index:9999;
    overflow:scroll;

            }
            
#jobsDiv {
   top:420px;
}

#popupJobContainer {
 position: absolute;
    top:200px;
    left:270px;
    width: 320px;
    height: 375px;
    margin-right: 0;
    margin-left: 0;
    background-color: #FFF;
    padding: 5px 5px 5px 5px;
    font: 12px "Helvetica Neue", Helvetica, Arial, sans-serif;
    color: #888;
    border:1px solid #e17009;
    border-radius: 0px;
    -webkit-border-radius: 0px;
    -moz-border-radius: 0px;
    z-index:9999;
    overflow:scroll;

}

.menuPages {
  overflow: hidden;
  background-color: #333;
}

.menuPages a {
  float: left;
  display: block;
  color: #e17009;
  text-align: center;
  padding: 14px 16px;
  text-decoration: none;
  font-size: 17px;
}

.menuPages a:hover {
  background-color: #ddd;
  color: black;
}

.menuPages a.active {
    background-color: #4CAF50;
    color: white;
}
</style>
<script type="text/javascript">
var map;
var osm = new OpenLayers.Layer.OSM("Base Map");
$(document)
.ready(
		function() {
			map = new OpenLayers.Map(
                    {
                            div: "mapDiv",
                            layers: [osm],
                            controls: [ new OpenLayers.Control.Navigation({ dragPanOptions: { enableKinetic: true } }),
                                   new OpenLayers.Control.PanZoom(),
                                   new OpenLayers.Control.LayerSwitcher(),
                                   new OpenLayers.Control.ScaleLine({div: document.getElementById("scale")}),
                                   new OpenLayers.Control.Attribution()],
                                                        center: [0, 0],
                                                        zoom: 3
                    });
			var ibmid = localStorage.ibmid;
		    var password = localStorage.password;
		    var xclientid = localStorage.xclientid;
		    var xclientsecret = localStorage.xclientsecret;
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
});

function removeAllLayers(){
    var num = map.getNumLayers();
    for (var i = num - 1; i>= 0; i--) {
            map.removeLayer(map.layers[i]);
    }
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
				html += '<a href="javascript:populateQueryjob(\'' + data[i].id + '\');">' + data[i].job.id + '</a><br>';
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
     map.addLayer(osm);
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
	   		  			if(retdata.query[0].result.objref[0].mime == 'application/x-ips-wms') {
	   		  					var data = retdata.query[0].result.objref[0];
			   		  			
			   		  			var geoserverUrl = data.geoserver;
			   		  			var workspace = data.workspace;
			   		  			var format = data.format;
			   		  			var len = data.layers.length;
			   		  			alert("Geoserver: " + geoserverUrl + " workspace: " + workspace + " format: " + format + " layers len: " + len);
			   		  			for ( var i = 0; i < len; i++) {	
			   		  				layerName = data.layers[i];
				   		  			var newLayer = new OpenLayers.Layer.WMS(
				   						layerName, geoserverUrl,
				   					        {
				   					            layers: workspace + ":" + layerName,
				   					            format: format,
				   					            transparent: true
				   					        },
				   					        {
				   					            buffer: 0,
				   							            displayOutsideMaxExtent: true,
				   							         displayInLayerSwitcher : true,
				   							            isBaseLayer: false,
				   							            yx : {'EPSG:4326' : true},
				   							           visibility: true
				   							        } 
				   							    );
				   					map.addLayer(newLayer);
			   		  			}
	   		  				} else {
	   		  					alert("Mime type: " + retdata.query[0].result.objref[0].mime + ", geoserver is " + retdata.query[0].result.objref[0].geoserver);
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
  <a href="${pageContext.request.contextPath}/simpleQuery.jsp">Query</a>
  <a href="${pageContext.request.contextPath}/simpleJobs.jsp">Jobs</a>
</div>
<div id="jobsDiv">
<h3>Completed Jobs</h3><br>
</div>

<div id="ongoingJobsDiv"><h3>Ongoing Jobs</h3><br></div>
<div id="mapDiv"></div>
<div id="popupJobContainer" style="display:none">
<div id="popupJobDetails">
</div>
<input type="button" value="Ok" onclick="closePopup();">
</div>
</body>
</html>
