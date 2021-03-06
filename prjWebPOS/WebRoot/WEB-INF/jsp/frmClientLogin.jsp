<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ page session="True" %>
<!DOCTYPE html>
<html>
  <head>
  <title>SanguinePOS</title>
  <!-- 
	  	<script type="text/javascript" src="<spring:url value="/resources/js/jquery-3.0.0.min.js"/>"></script>
	  	<script type="text/javascript" src="<spring:url value="/resources/js/jQKeyboard.js"/>"> </script>
	  	<script type="text/javascript" src="<spring:url value="/resources/js/slideKeyboard/jquery.ml-keyboard.js"/>"></script>
	
		<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/jQKeyboard.css "/>" />
		<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/slideKeyboard/jquery.ml-keyboard.css"/>"/>
		<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/slideKeyboard/jquery.ml-keyboard.css"/>"/>	
	  -->
	 
	 <!-- New js and css start  -->
	 
	 	<script src="<spring:url value="/resources/newdesign/vendor/jquery/jquery-3.2.1.min.js"/>"/></script>
		<script src="<spring:url value="/resources/newdesign/vendor/animsition/js/animsition.min.js"/>"/></script>
		<script src="<spring:url value="/resources/newdesign/vendor/bootstrap/js/popper.js"/>"/></script>
		<script src="<spring:url value="/resources/newdesign/vendor/bootstrap/js/bootstrap.min.js"/>"/></script>
		<script src="<spring:url value="/resources/newdesign/vendor/select2/select2.min.js"/>"/></script>
		<script src="<spring:url value="/resources/newdesign/vendor/daterangepicker/moment.min.js"/>"/></script>
		<script src="<spring:url value="/resources/newdesign/vendor/daterangepicker/daterangepicker.js"/>"/></script>
		<script src="<spring:url value="/resources/newdesign/vendor/countdowntime/countdowntime.js"/>"/></script>
		<script src="<spring:url value="/resources/newdesign/js/main.js"/>"/></script>
		
		
		
	<script type="text/javascript">
  	
	  	/**
		 *  Set Focus
		**/
	  	$(document).ready(function()
	  	{
	    	$('#username').focus();
	       	var strTouchScreenMode=localStorage.getItem("lsTouchScreenMode");
	       	if (strTouchScreenMode == null) 
			{
				localStorage.setItem("lsTouchScreenMode", "N");
			}   
			if(strTouchScreenMode=='Y')
			{
				$('input#username').mlKeyboard({layout: 'en_US'});
			   	$('input#password').mlKeyboard({layout: 'en_US'});
			   	$('#username').focus();
			}
	  	});
	  	
	  	
	  	function funKeyBoard()
	  	{
			var lsKeyBoardYN= localStorage.getItem("lsTouchScreenMode");
	  		if(lsKeyBoardYN=='Y')
	  		{
	  			localStorage.setItem("lsTouchScreenMode", "N");
	  		}
	  		if(lsKeyBoardYN=='N')
	  		{
	  			localStorage.setItem("lsTouchScreenMode", "Y");
	  		}
	  	}
  	
	</script>
	
	 
	 	<link rel="icon" type="image/png" href="/resources/newdesign/images/icons/favicon.ico"/>
	 	<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/newdesign/vendor/bootstrap/css/bootstrap.min.css"/>"/>
	 	<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/newdesign/fonts/font-awesome-4.7.0/css/font-awesome.min.css"/>"/>
		<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/newdesign/fonts/Linearicons-Free-v1.0.0/icon-font.min.css"/>"/>	
		<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/newdesign/vendor/animate/animate.css"/>"/>
		<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/newdesign/vendor/css-hamburgers/hamburgers.min.css"/>"/>	
		<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/newdesign/vendor/animsition/css/animsition.min.css"/>"/>
		<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/newdesign/vendor/select2/select2.min.css"/>"/>
		<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/newdesign/vendor/daterangepicker/daterangepicker.css"/>"/>	
		<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/newdesign/css/util.css"/>"/>
		<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/newdesign/css/main.css"/>"/>

    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <title>Web Stocks</title>
</head>

<body style="background-color: #666666;">
	
	<div class="limiter">
		<div class="container-login100">
			<div class="wrap-login100">
				<s:form name="login" method="POST" action="validateClient.html" class="login100-form validate-form">
				
					<span class="login100-form-title p-b-43">
						Login
					</span>
					
					<label>Email ID : </label>
					<div class="wrap-input100 validate-input" >
						
						<s:input cssClass="input100" name="usercode" placeholder="UserName"
							path="strClientCode" autocomplete="off" id="username" required="true" pattern='\S+@\S+\.\S+'
							cssStyle="text-transform: uppercase;" /> 
						<s:errors path="strClientCode"></s:errors>
						
						<span class="focus-input100"></span>
						<span class="label-input100"></span>
					</div>
					
					<label>Password : </label>
					<div class="wrap-input100 validate-input" data-validate="Password is required">
						<s:input type="password" required="true" cssClass="input100" name="pass" placeholder="Password"
							path="strPassword" id="password" /> 
						<s:errors path="strPassword"></s:errors>
						<span class="focus-input100"></span>
						<span class="label-input100"></span>
					</div>

<!-- 					<div class="flex-sb-m w-full p-t-3 p-b-32"> -->
<!-- 						<div class="contact100-form-checkbox"> -->
<!-- 							<input class="input-checkbox100" id="ckb1" type="checkbox" name="remember-me"> -->
<!-- 							<label class="label-checkbox100" for="ckb1"> -->
<!-- 								Remember me -->
<!-- 							</label> -->
<!-- 						</div> -->

<!-- 						<div> -->
<!-- 							<a href="#" class="txt1"> -->
<!-- 								Forgot Password? -->
<!-- 							</a> -->
<!-- 						</div> -->
<!-- 					</div> -->
			
<br>
					<div class="container-login100-form-btn">
						<input type="submit" value="Login" class="login100-form-btn" />
					</div>
				</s:form>

				<div class="login100-more" style="background-image: url('../${pageContext.request.contextPath}/resources/newdesign/images/bg-01.png');background-size: contain;"> 
				<!-- <div class="login100-more" style="background-size: contain;">
					<img  src="../${pageContext.request.contextPath}/resources/newdesign/images/bg-01.png" width="100%" height="500px" style="background-size: contain;">  -->
				</div>
				
				
				
			</div>
		</div>
	</div>
	
	<c:if test="${!empty invalid}">
		<script type="text/javascript">
		alert("Invalid Login");
		</script>
	</c:if>
	 
	<c:if test="${!empty LicenceExpired}">
		<script type="text/javascript">
			alert("Licence is Expired \n Please Contact Technical Support");
		</script>
	</c:if>
	
	 
</body>
</html>