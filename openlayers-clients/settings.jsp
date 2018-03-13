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


function getHtmlRow(name, value, info) {
	var html = '<tr>';
	html += '<td>' + name + '</td>';
	html += '<td>' + value + '</td>';
	html += '<td>' + info + '</td>';
	html += '</tr>';
	return html;
}

function getHtmlRows(name, value, info) {
	var html = '<tr>';
	html += '<td>' + name + '</td>';
	html += '<td>';
	html += '<table>';
	for(var i=0; i < value.length; i++) { 
		html += '<tr><td>' + value[i] + '</td></tr>';
	}
	html += '</table></td>';
	html += '<td>' + info + '</td>';
	html += '</tr>';
	return html;
}

function getHtmlComplexRows(name, value, info) {
	var html = '<tr>';
	html += '<td>' + name + '</td>';
	html += '<td>';
	html += '<table><thead><th>Id</th><th>Name</th><th>Usage</th></thead>';
	for(var i=0; i < value.length; i++) { 
		html += '<tr><td>' + value[i].id + '</td><td>' + value[i].name + '</td><td>' + value[i].usage +'</td></tr>';
	}
	html += '</table></td>';
	html += '<td>' + info + '</td>';
	html += '</tr>';
	return html;
}

// Populate Settings
function populateSettings() {    
		$.getJSON(baseurl + '/v1/settings', {
			ajax : 'true',
			
		}, function(retdata) {
			var data = retdata.setting;
			var html = '<table width="97%">';
			html += '<thead>';
			html += '<th>Name</th>';
			html += '<th>Value</th>';
			html += '<th>Info</th>';
			html += '</thead>';
			if(data.requester != undefined)
				html += getHtmlRow("requester", data.requester.value, data.requester.info);
			if(data.client != undefined)
				html += getHtmlRow("client", data.client.value, data.client.info);			
			if(data.subscription != undefined)
				html += getHtmlRow("subscription", data.subscription.value, data.subscription.info);
			if(data.region != undefined)
				html += getHtmlRow("region", data.region.value, data.region.info);
			if(data.admin != undefined)
				html += getHtmlRows("admin", data.admin.value, data.admin.info);
			if(data.corpuses != undefined)
                html += getHtmlRows("corpuses", data.corpuses.value, data.corpuses.info);
			if(data["corpus-policy"] != undefined)
                html += getHtmlComplexRows("corpus-policy", data["corpus-policy"].value, data["corpus-policy"].info);
			if(data["customer-policy"] != undefined)
                html += getHtmlComplexRows("customer-policy", data["customer-policy"].value, data["customer-policy"].info);
			if(data["dataset-policy"] != undefined)
                html += getHtmlComplexRows("dataset-policy", data["dataset-policy"].value, data["dataset-policy"].info);
			html += '</table>';
			$('#settingsDiv').html(html);
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
			populateSettings();
		});
		

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
<div>

<h3>Settings</h3>
<div id="settingsDiv">
	
</div>

</div>
</body>
</html>