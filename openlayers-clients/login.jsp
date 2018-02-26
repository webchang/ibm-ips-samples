<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Login</title>
<jsp:include page="base.jsp" />
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
<td>IBM Id:</td><td><input type="text" name="ibmid" id="ibmid" value="ips.app@outlook.com"></td>
</tr>
<tr>
<td>Password:</td><td><input type="password" name="password" id="password" value="ips.app1"></td>
</tr>
<tr>
<td>X-Client Id:</td><td><input type="text" name="xclientid" id="xclientid" value="5c20d153-09ad-40e3-9387-124cd132bc42"></td>
</tr>
<tr>
<td>X-Client Secret:</td><td><input type="password" name="xclientsecret" id="xclientsecret" value="R8qP7dF2kH4fH4iH3lH2iJ7uD3yI2fQ5oY0cH8pE2kY3eN0cJ8"></td>
</tr>
<tr>
<td colspan=2 align="right"><input type="submit" name="loginButton" id="loginButton" value="Login"></td>
</tr>
</table>
</form>
</div>
</body>
</html>