<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Login</title>
<jsp:include page="import.jsp" />
<script type="text/javascript">
 function login(){	
	 $.ajaxSetup({
			crossDomain: true
		}); 
 	$.ajax(baseurl + '/v1/noop', {
 		headers: {
 			'Authorization': "Basic " + btoa($('#ibmid').val() + ":" + $('#password').val()),
      		"X-IBM-Client-Id": $('#xclientid').val(),
		    "X-IBM-Client-Secret": $('#xclientsecret').val() 
    	},
 	statusCode: {
 	    401: function() {
 	      	alert( "Unauthorized!! Please enter user credentials again." );
 	    },
 	    204: function() {
  	      	localStorage.ibmid = $('#ibmid').val();
  	  		localStorage.password = $('#password').val();
  			localStorage.xclientid = $('#xclientid').val();
  			localStorage.xclientsecret = $('#xclientsecret').val();
  	    	window.location.href = 'settings.jsp';
  	    }
 	  }
	});
 }
</script>
</head>
<body>
<div>
Please login: <br>
<form id="login-form" name="login-form" action="javascript:login()">
<input type="hidden" name="action" value="LOGIN"/>
<table>
<tr>
<td>IBM Id:</td><td><input type="text" name="ibmid" id="ibmid" value="IBMid"></td>
</tr>
<tr>
<td>Password:</td><td><input type="password" name="password" id="password" value="IBMid Password"></td>
</tr>
<tr>
<td>X-Client Id:</td><td><input type="text" name="xclientid" id="xclientid" value="API Client Id"></td>
</tr>
<tr>
<td>X-Client Secret:</td><td><input type="password" name="xclientsecret" id="xclientsecret" value="API Client Secret"></td>
</tr>
<tr>
<td colspan=2 align="right"><input type="submit" name="loginButton" id="loginButton" value="Login"></td>
</tr>
</table>
</form>
</div>
</body>
</html>
