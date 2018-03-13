<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Sample Jobs</title>
<jsp:include page="import.jsp" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/settings.css">
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

<h3>Sample Jobs</h3>
<div id="videosDiv">
	<table id="videosTable" width="97%">
		<thead>
		<th style="width: 150px">Name</th>
		<th style="width: 150px">Link</th>
		</thead>
		<tr>
			<td>Crops Info Iowa Greene County</td>
			<td><a href="${pageContext.request.contextPath}/cropsTest_jobs2.mov" target="_blank">Crops Info Iowa Greene County Demo</a></td>
    	</tr>
	    <tr>
			<td>Crops Info California Napa County</td>
			<td><a href="${pageContext.request.contextPath}/cropsTest_jobs2_napa.mov" target="_blank">Crops Info California Napa County Demo</a></td>
    	</tr>
	</table>
</div>

</div>
</body>
</html>
