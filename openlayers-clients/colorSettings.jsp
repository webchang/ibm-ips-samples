<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Query</title>
<jsp:include page="base.jsp" />
<jsp:include page="import.jsp" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/settings.css">
<script type="text/javascript">

function updateColorSettings() {
	localStorage.color = $('#color').val();
    localStorage.no_data = $('#no_data').val();
}


function changeColorList(color) {
    $('#color').val(color);
    $('#colorTableList').val(color);
    document.getElementById("settingsTable").rows[1].cells[2].innerHTML = getColorRow(color);
}


function getColorRow(color) {
	var red = ["#FFFFB2","#FECC5C","#FD8D3C","#F03B20","#BD0026"];
	var blue = ["#DAD9FF","#D9F7FF","#8A8AFF","#5D52FF","#0516FF","#12089E","#00000D"];
	var green = ["#F7FCF5","#C9E9C2","#7AC77B","#29924A","#00441B"];
	var hd = ["#FF784F","#FFDA82","#FFE019","#A9FF47","#0DFF25","#4FE8FF","#19C2FF","#0810FF"];
	var spectral = ["#FF1921","#FF7C3B","#FFF787","#84F588","#153A91"];
	var html = '<table><tr>';
	var colors = red;
	if(color == 'red') {
		colors = red;
	} else if(color == 'blue') {
		colors = blue;
	} else if(color == 'green') {
		colors = green;
	} else if(color == 'hd') {
		colors = hd;
	} else {
		colors = spectral;
	}
	html = '<table><tr>';
	for(var i=0; i< colors.length; i++) {
		html += '<td style="width: 200px; height:20px; top:5px; padding: 0px; align=left" bgcolor="' + colors[i] + '"></td>';
	}
	html += '</tr></table>';
	return html;
}

$(document)
.ready(
		function() {
		    var color = localStorage.color;
		    var no_data = localStorage.no_data;
		    if(color == undefined) {
		    	color = 'spectral';
		    	no_data = -9999;
		    }
		    $('#color').val(color);
		    changeColorList(color);
		    $('#no_data').val(no_data);
		});
		

</script>
</head>
<body>
<div class="menuPages" id="menuPagesDiv">
  <a href="${pageContext.request.contextPath}/settings.jsp">Settings</a>
  <a href="${pageContext.request.contextPath}/simpleQuery.jsp">Query</a>
  <a href="${pageContext.request.contextPath}/simpleJobs.jsp">Jobs</a>
</div>
<div>

<h3>Color Settings</h3>
<div id="colorSettingsDiv">
	<table id="settingsTable" width="97%">
		<thead>
		<th style="width: 150px">Property</th>
		<th style="width: 150px">Value</th>
		</thead>
		<tr>
			<td>Color</td>
			<td><select id="colorTableList" index="0" onchange="changeColorList(this.options[this.selectedIndex].value)">
				<option value="red">red</option>
				<option value="blue">blue</option>
				<option value="green">green</option>
				<option value="hd">hd</option>
				<option value="spectral">spectral</option>
				</select>
				<input type="hidden" name="color" id="color" value="red"></td>
			<td></td>
    	</tr>
	    <tr>
	        <td>No Data</td>
	         <td><input type="text" name="no_data" id="no_data" value="-9999"></td>
	    </tr>
	</table>
	<p>
	<input type="button" name="okButton" id="okButton" value="Update" onclick="updateColorSettings();">
</div>

</div>
</body>
</html>
