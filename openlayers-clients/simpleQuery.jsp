<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Query</title>
<jsp:include page="base.jsp" />
<jsp:include page="import.jsp" />

<script type="text/javascript">
// Populate DatasetLists
function populateDatasetList() {    
		$.getJSON(baseurl + '/v1/datasets', {
			ajax : 'true',
			
		}, function(retdata) {
			var data = retdata.dataset;
			var html = '';
			var len = data.length;
			var desc;
			html += '<option title="Select a dataset">' 
			+ 'Select a dataset'
			+ '</option>';	
			for ( var i = 0; i < len; i++) {
				html += '<option value="' + data[i].id 
					+ '" title="' + data[i].name + '">' 
					+ data[i].name
					+ '</option>';
			}
			html += '</option>';
			$('#datasetList0').html(html);
			console.log('populateDatasetList finished');
		});
} 


// Populate DatalayerLists
function changeDatasetList(elem){
	var index = $(elem).attr('index');
	$.getJSON(baseurl + '/v1/datalayers', {
		parent : $(elem).val(),
		ajax : 'true'
	}, function(retdata) {
		var data = retdata.datalayer;
		var html = '';
		var len = data.length;
		
		for ( var i = 0; i < len; i++) {
			html += '<option value="' + data[i].id + '" title="' + data[i].name + '">'
					+ data[i].name + '</option>';
		}
		console.log('#datalayerList' + index + ' will now have ' + html);
		$('#datalayerList' + index).html(html);
	});
}


$(document)
.ready(
		function() {
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
		    $('#aoiText').autocomplete({
		    	source: function( request, response ) {
		            $.ajax({
		                dataType: "json",
		                type : 'Get',
		                url: baseurl + '/v1/polygons',
		                data: {"name" : request.term},
		                success: function(retdata) {
		                	if(retdata != null && retdata != "") {
		    	            	var data = retdata.polygon;
		    	            	var len = data.length;
		    	            	var items = [];
		    	            	for ( var i = 0; i < len; i++) {
		    	            		items[i] = { label: data[i].name, value: data[i].id };
		    	            	}
		    	            	response(items);
		                	}
		                }						            
		            });
		        },
		    	appendTo: '#polygonDiv',
		    	select: function( event, ui ) {
		    		event.preventDefault();
		    		$('#aoiText').val(ui.item.label + ' (' + ui.item.value + ')' );
		    		$('#aoiText').removeClass('ui-autocomplete-loading');
		    		$('#aoi').val(ui.item.value);
		    	},
		        error: function(data) {
		            $('#aoiText').removeClass('ui-autocomplete-loading');  
		        },
		    	delay: 800,
		    	minLength: 3
		    });

			populateDatasetList();
			$('#btnSubmit').click(function() {
				submitQuery();
			});
		});
		
function submitQuery() {
	var queryParams = new Object();
	var queryType = $('input[name=spatial]:checked').val();
	queryParams.name = '';
	var spatialParams = new Object();
	
	var dataLayerParams = [];
	var temporalParams = [];
	var layerParams = [];
	
	if(queryType == 'point') {
		spatialParams.type = 'point';
		var latLons = [];
		var latLonObj = new Object();
		latLonObj.lat = $('#lat').val();
		latLonObj.long = $('#long').val();
		latLons[0] = latLonObj;
		spatialParams.point = latLons;
	} else {
		spatialParams.type = 'polygon';
		if(queryType == 'rectangle') {
			var rect = new Object();
			rect.latsw = $('#swlat').val();
			rect.longsw = $('#swlong').val();
			rect.latne = $('#nelat').val();
			rect.longne = $('#nelong').val();
			var poly = new Object();
			poly.rectangle = rect;
			spatialParams.polygon = poly;				
		} else {
			var poly = new Object();
			poly.id = $('#aoi').val();
			spatialParams.polygon = poly;
		}
	}
	queryParams.spatial = spatialParams;
	if($('input[name=temporal0]:checked').val() == 'snapshot') {
		temporalParams[0] = $('#time0').val();
	} else {
		temporalParams[0] = $('#time1').val();
		temporalParams[1] = $('#time2').val();
	}
	layerParams[0] = temporalParams;
	dataLayerParams[0] = new Object();
	dataLayerParams[0].id = $('#datalayerList0').val();
	dataLayerParams[0].temporal = layerParams;
	
	queryParams.datalayer = dataLayerParams;
	queryParams.mime = 'x-ibm-wms';
	var queryJSON = JSON.stringify(queryParams);
	//alert(queryJSON);
	$.ajax(baseurl + '/v1/queries', {
		data : queryJSON,
		type: "post"
	}).done(function(data) {
		alert("Query succeeded! Job Id: " + data.query[0].job.id + " has status: " + data.query[0].job.status + " " + data.query[0].job.message);
	}).fail(function(xhr, textStatus, errorThrown) {
		alert("Query failed! " + textStatus + " " + errorThrown);
	});
	alert("Please wait for query to process..");
	return false;
}

function changeSpatial(spatial) {
	if(spatial == 'point') {
		$('#pointDiv').show();
		$('#rectangleDiv').hide();
		$('#polygonDiv').hide();
	} else if(spatial == 'rectangle') {
		$('#pointDiv').hide();
		$('#rectangleDiv').show();
		$('#polygonDiv').hide();
	} else {
		$('#pointDiv').hide();
		$('#rectangleDiv').hide();
		$('#polygonDiv').show();
	}
}


function changeInterval(index, temporal) {
	if(temporal == 'snapshot') {
		$('#snapshotDiv'+index).show();
		$('#intervalDiv'+index).hide();
	} else {
		$('#snapshotDiv'+index).hide();
		$('#intervalDiv'+index).show();
	}
}
</script>
</head>
<body>
<div class="menuPages" id="menuPagesDiv">
  <a href="${pageContext.request.contextPath}/settings.jsp">Settings</a>
  <a href="${pageContext.request.contextPath}/colorSettings.jsp">Color Settings</a>
  <a href="${pageContext.request.contextPath}/simpleQuery.jsp">Query</a>
  <a href="${pageContext.request.contextPath}/simpleJobs.jsp">Jobs</a>
</div>
<div>
<form id="queryForm" name="queryForm">
<div>
<h3>Spatial Coverage:</h3>
<div>
  <input type="radio" name="spatial" value="point" onclick="changeSpatial('point');"> Point
  <input type="radio" name="spatial" value="rectangle" onclick="changeSpatial('rectangle');"> Rectangle
  <input type="radio" name="spatial" value="polygon" onclick="changeSpatial('polygon');" checked> Polygon
</div>
<div id="pointDiv" style="display: none">
   Latitude: <input type="text" id="lat" name="lat"><br>
   Longitude: <input type="text" id="long" name="long">
   
</div>
<div id="rectangleDiv" style="display: none">
	SW Latitude: <input type="text" id="swlat" name="swlat"><br>
    SW Longitude: <input type="text" id="swlong" name="swlong"><br>
    NE Latitude: <input type="text" id="nelat" name="nelat"><br>
    NE Longitude: <input type="text" id="nelong" name="nelong">
</div>
<div id="polygonDiv" style="display: block">
	Polygon's AOI Id: <input type="text" name="aoiText" id="aoiText"><input type="hidden" name="aoi" id="aoi">
</div>
</div>
<div>
<h3>Data Coverage:</h3>
<div id="dataDiv0">
	<table>
		<tr>
			<td colspan="3">Datasets<br> 
			<select id="datasetList0" name="dataset0" index="0" onchange="changeDatasetList(this)" style="width: 300px;"></select>
			</td>
		</tr>
		<tr>
			<td style="width: 300px;">Datalayers<br> 
			<select id="datalayerList0" name="datalayer0" style="width: 300px;"></select>
			</td>
		</tr>
		<tr>
			<td>Temporal Coverage<br> </td>
		</tr>
		<tr>
			<td colspan=2>
			<input type="radio" name="temporal0" value="snapshot" onclick="changeInterval('0', 'snapshot')">Snapshot
  			<input type="radio" name="temporal0" value="interval" onclick="changeInterval('0', 'interval')" checked>Interval
			</td>
		</tr>
	</table>
		<div id="intervalDiv0" style="display: block">
		<table>
		<tr>
			<td>
			From
			</td>
			<td>
			To
			</td>
		</tr>
		
		<tr>
			<td>
			<input type="text" name="time1" id="time1" style="width:200px"/>
			</td>
			<td>
			<input type="text" name="time2" id="time2" style="width:200px"/>
			</td>
		</tr>	
		</table>
		</div>	
		<div id="snapshotDiv0" style="display: none">
		<table>
			<tr>
				<td colspan=2 align="center">
				Snapshot:
				</td>
			</tr>		
			<tr>
				<td colspan=2 align="center">
				<input type="text" name="time0" id="time0" style="width:200px"/>
				</td>
			</tr>	
			</table>	
		</div>	
		
</div>	
</div>
	<div>
		<input type="submit" id="btnSubmit" value="Submit">
	</div>
</form>
</div>
</body>
</html>