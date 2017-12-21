<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Query</title>
<jsp:include page="import.jsp" />
<style>
body {margin:0;}

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

        table {
        padding: 20px;
        margin-left: 20px;
        }
        table,th,td {
    border-collapse: collapse;
    border: 1px solid #e17009;
    
        }
        th, td {
    padding: 15px;
    vertical-align: top;
    }
       
        </style>
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

// Populate DatasetLists
function populateSettings(datasets) {    
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
			html += getHtmlRow("requesterId", data.requesterId.value, data.requesterId.info);
			html += getHtmlRow("clientId", data.clientId.value, data.clientId.info);
			html += getHtmlRow("subscriptionId", data.subscriptionId.value, data.subscriptionId.info);
			html += getHtmlRow("ownerId", data.ownerId.value, data.ownerId.info);
if(data.corpusIds != undefined)
			html += getHtmlRows("corpusIds", data.corpusIds.value, data.corpusIds.info);
if(data.corpusPolicy != undefined)
			html += getHtmlComplexRows("corpusPolicy", data.corpusPolicy.value, data.corpusPolicy.info);
if(data.customerPolicy != undefined)
			html += getHtmlComplexRows("customerPolicy", data.customerPolicy.value, data.customerPolicy.info);
if(data.datasetPolicy != undefined)
			html += getHtmlComplexRows("datasetPolicy", data.datasetPolicy.value, data.datasetPolicy.info);
			
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
		    $.getJSON(baseurl + '/v1/datasets', {
				ajax : 'true',
				
			}, function(retdata) {
				var datasets = new Object();
				var data = retdata.dataset;
				var len = data.length;
				
				for ( var k = 0; k < len; k++) {
					var dataid = data[k].id;
					datasets[dataid] = data[k].name;
					
				}
				populateSettings(datasets);
			});
		    
		    
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

<h3>Settings</h3>
<div id="settingsDiv">
	
</div>

</div>
</body>
</html>
