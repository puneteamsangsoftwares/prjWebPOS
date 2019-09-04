<%@ page language="java" contentType="text/html; charset=ISO-8859-1" 
	pageEncoding="ISO-8859-1"%> 
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title> Change Password </title>
<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/jquery-confirm.min.css"/>"/>
<script type="text/javascript" src="<spring:url value="/resources/js/jquery-confirm.min.js"/>"></script>
<script type="text/javascript" src="<spring:url value="/resources/js/confirm-prompt.js"/>"></script>
<script>
	
$(document).ready(function() {

	 $('input#txtOldPass').mlKeyboard({layout: 'en_US'});
	  $('input#txtNewPass').mlKeyboard({layout: 'en_US'});
	 
	  $("form").submit(function(event){
		  if($("#txtOldPass").val().trim()=="")
			{
				alert("Invalid Old Password.");
				return false;
			}
		  if($("#txtNewPass").val().trim()=="")
			{
				alert("Invalid New Password.");
				return false;
			}
 		flg = funChekPassword();
 		 return flg;
		});
	  
	 
	});


function funChekPassword() 
{
	var flg=true;
	

		var userCode = $('#txtUserCode').val();
		var oldPass = $('#txtOldPass').val();
		var newPass = $('#txtNewPass').val();
		 $.ajax({
		        type: "GET",
		        data : {
		        	userCode : userCode,
		        	oldPass : oldPass,
		        	
				},
		        url: getContextPath()+"/checkUserName.html",
		        async: false,
		        dataType: "text",
		        success: function(response)
		        {
		        	if(response!="Success")
	        		{
	        			alert(response);
	        			$('#txtOldPass').focus();
	        			flg= false;
		    		}
		    		else
		    		{
		    		document.frmChangePassword.action="savrOrUpdateUserPassword.html";
		    		document.frmChangePassword.submit();
		    		alert("Password Saved Successfully");
		    		}
		        
				},
				error: function(jqXHR, exception) {
		            if (jqXHR.status === 0) {
		                alert('Not connect.n Verify Network.');
		            } else if (jqXHR.status == 404) {
		                alert('Requested page not found. [404]');
		            } else if (jqXHR.status == 500) {
		                alert('Internal Server Error [500].');
		            } else if (exception === 'parsererror') {
		                alert('Requested JSON parse failed.');
		            } else if (exception === 'timeout') {
		                alert('Time out error.');
		            } else if (exception === 'abort') {
		                alert('Ajax request aborted.');
		            } else {
		                alert('Uncaught Error.n' + jqXHR.responseText);
		            }		            
		        }
				
	      });
	
	
	return flg;
} 

function funResetFields()
{
	$("#txtOldPass").focus();
	
}
</script>
</head>

        <body>
<div id="formHeading">
		<label>Change Password</label>
	</div>
	<s:form name="frmChangePassword" method="POST" action="savePOSAreaMaster.html"  class="formoid-default-skyblue" style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans','Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;max-width:880px;min-width:150px;margin-top:2%;" > 
 
  <div class="title" style="margin-left: 25%;">
	 
	 	<div class="row" style="background-color: #fff;margin-bottom:  10px;display: -webkit-box; ">
			<div class="element-input col-lg-6" style="width: 20%; margin-left: 10%"> 
    			<label class="title">User Code</label>
    		</div>
    		<div class="element-input col-lg-6"  style="width: 30%;"> 
				<s:input class="large" type="text" id="txtUserCode" path="strUserCode"  value="${userCode}" style="width: 100%;" readonly="TRUE"/>
			</div>

		</div>
		
		<div class="row" style="background-color: #fff;margin-bottom:  10px;display: -webkit-box;">
			<div class="element-input col-lg-6" style="width: 20%; margin-left: 10%" >
				<label class="title">Old Password</label>
			</div>
			<div class="element-input col-lg-6"  style="width: 30%;">
				<s:input class="large" type="text" id="txtOldPass" path="strOldPass"   style="width: 100%;"/>
			</div> 
		</div>
		
		<div class="row" style="background-color: #fff;margin-bottom:  10px;display: -webkit-box;">
			<div class="element-input col-lg-6" style="width: 20%; margin-left: 10%" >
				<label class="title">New Password</label>
			</div>
			<div class="element-input col-lg-6"  style="width: 30%;">
				<s:input class="large" type="text" id="txtNewPass" path="strNewPass"   style="width: 100%;"/>
			</div> 
		</div>
	
			<div class="row" style="background-color: #fff;margin-bottom: 10px;display: -webkit-box;">
						
				<p align="center">
				<div class="row" style="background-color: #fff; margin-top:2%; margin-left: 1%;display: -webkit-box; margin-left: 20%;">
		     		     <input id="btnSave" type="submit" value="Update" style="margin-left: -12%;" ></input>
		                 <input id="btnReset" type="reset" value="Reset" onclick="funResetFields()" style="margin-left: 12%;"></input>
		            
  		 			 </div>
		     	 </p>
	
   		   </div>
		
		</div>
 </s:form>

		<br />
		<br />
<%-- <s:form name="frmChangePassword" method="POST" action="">
<table class="masterTable">
<tr align="center">
	<td width="140px">User Code
	<s:input size="40" type="text" id="txtUserCode" path="strUserCode" cssClass="BoxW124px" value="${userCode}"/>
	</td>
</tr>	
<tr align="center">
	<td width="140px">Old Password	
	<s:input colspan="40" type="text" id="txtOldPass" name="txtOldPass" path="strOldPass" cssClass="BoxW124px"/> 
	</td>
</tr>
<tr align="center">
	<td width="140px">New Password
	<s:input size="40" type="text" name="txtNewPass" id="txtNewPass" path="strNewPass" cssClass="BoxW124px"  />
	</td>
</tr>
</table>	
<br/>
<br/>	
		<p align="center">
			<input type="submit" value="Submit" tabindex="3" class="form_button" />
			<input type="button" value="Close" tabindex="3" class="form_button" />
			<input type="reset" value="Reset" class="form_button" onclick="funResetFields()" />
				
		</p>
		
		
	</s:form>
  --%>

</body>

</html>