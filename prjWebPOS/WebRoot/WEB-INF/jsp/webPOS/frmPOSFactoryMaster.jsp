<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Factory Master</title>
<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/jquery-confirm.min.css"/>"/>
<script type="text/javascript" src="<spring:url value="/resources/js/jquery-confirm.min.js"/>"></script>
<script type="text/javascript" src="<spring:url value="/resources/js/confirm-prompt.js"/>"></script>
<style>
.ui-autocomplete {
    max-height: 200px;
    overflow-y: auto;
    /* prevent horizontal scrollbar */
    overflow-x: hidden;
    /* add padding to account for vertical scrollbar */
    padding-right: 20px;
}
/* IE 6 doesn't support max-height
 * we use height instead, but this forces the menu to always be this tall
 */
* html .ui-autocomplete {
    height: 200px;
}
</style>

<script type="text/javascript">

 	$(document).ready(function () {
	  $('input#txtFactoryName').mlKeyboard({layout: 'en_US'});
	  
	  $("form").submit(function(event){
		  if($("#txtFactoryName").val().trim()=="")
			{
			  confirmDialog("Please Enter Factory Name","");
				return false;
			}
		  if($("#txtFactoryName").val().length > 30)
			{
				alert("Factory Name length must be less than 30","");
				return false;
			}
		  else{
			  flg=funCallFormAction();
			  return flg;
		  }
		});
	}); 



	/**
	* Reset The Group Name TextField
	**/
	function funResetFields()
	{
		$("#txtFactoryName").val("");
    }
	
	
		/**
		* Open Help
		**/
		function funHelp(transactionName)
		{	       
			window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	    }
		
		/**
		* Get and Set data from help file and load data Based on Selection Passing Value(Group Code)
		**/
		function funSetData(code)
		{
			$("#txtFactoryCode").val(code);
			var searchurl=getContextPath()+"/loadPOSFactoryMasterData.html?POSFactoryCode="+code;
			 $.ajax({
				        type: "GET",
				        url: searchurl,
				        dataType: "json",
				        success: function(response)
				        {
				        	if(response.strFactoryCode=='Invalid Code')
				        	{
				        		alert("Invalid Area Code");
				        		$("#txtFactoryCode").val('');
				        	}
				        	else
				        	{
					        	$("#txtFactoryCode").val(response.strFactoryCode);
					        	$("#txtFactoryName").val(response.strFactoryName);
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
		}
		
		
		$(function()
		{
			$('#txtFactoryName').blur(function () {
				 var strFName=$('#txtFactoryName').val();
			      var st = strFName.replace(/\s{2,}/g, ' ');
			      $('#txtFactoryName').val(st);
				});
			
		});
		
	
		/**
		* Success Message After Saving Record
		**/
		$(document).ready(function()
		{
			var message='';
			<%if (session.getAttribute("success") != null) 
			{
				if(session.getAttribute("successMessage") != null)
				{%>
					message='<%=session.getAttribute("successMessage").toString()%>';
				    <%
				    session.removeAttribute("successMessage");
				}
				boolean test = ((Boolean) session.getAttribute("success")).booleanValue();
				session.removeAttribute("success");
				if (test) 
				{
					%>confirmDialog("Data Saved \n\n"+message,"");<%
				}
			}%>
		});
		
		
		/**
		*  Check Validation Before Saving Record
		**/
		
		
		function funCallFormAction() 
		{
			var flg=true;
			var factoryCode = $('#txtFactoryCode').val();
			var factoryName = $('#txtFactoryName').val();
			
				 $.ajax({
				        type: "GET",
				        url: getContextPath()+"/checkFactoryName.html?strFactoryCode="+factoryCode+"&strFactoryName="+factoryName,
				        async: false,
				        dataType: "text",
				        success: function(response)
				        {
				        	if(response=="false")
				        		{
				        		confirmDialog("Factory Name Already Exist!");
				        			$('#txtAreaName').focus();
				        			flg= false;
					    		}
					    	else
					    		{
					    			flg=true;
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
		
		/**
		*  Check Validation Before Saving Record
		**/
		
</script>
</head>

<body >
	<div id="formHeading">
		<label>Factory Master</label>
	</div>
	<s:form name="Factory Master" method="POST" action="savePOSFactoryMaster.html?saddr=${urlHits}" class="formoid-default-skyblue" style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans','Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;max-width:880px;min-width:150px;margin-top:2%;" > 
	

		<br />
		<br />
		 <div class="title" style="margin-left: 25%;">
	 
	 	<div class="row" style="background-color: #fff;margin-bottom:  10px;display: -webkit-box; ">
			<div class="element-input col-lg-6" style="width: 20%; margin-left: 10%"> 
    			<label class="title">Factory Code</label>
    		</div>
    		<div class="element-input col-lg-6"  style="width: 30%;"> 
				<s:input class="large" type="text" id="txtFactoryCode" path="strFactoryCode"  ondblclick="funHelp('POSFactoryMaster')"  readonly="true" style="width: 100%;"/>
			</div>
		</div>
		
		
			
		<div class="row" style="background-color: #fff;margin-bottom:  10px;display: -webkit-box;">	
			<div class="element-input col-lg-6" style="width: 20%; margin-left: 10%">
					<label class="title">Factory Name</label>
			</div>
			<div class="element-input col-lg-6"  style="width: 30%;">
					<s:input class="large" type="text" id="txtFactoryName" path="strFactoryName"   style="width: 100%;"/>
			</div>
			
		</div>
		
			 <div class="col-lg-10 col-sm-10 col-xs-10" style="width: 60%;">
     			<p align="center">
            		<div class="submit col-lg-4 col-sm-4 col-xs-4"  ><input type="submit" value="SUBMIT" style="margin-top: 30%; margin-left: 60%"/></div>
          
            		<div class="submit col-lg-4 col-sm-4 col-xs-4" ><input type="reset" value="RESET" style="margin-top: 30%; margin-left: 70%"onclick="funResetFields()"></div>
     			</p>
   			</div>
   			
		</div>
		<%-- <table class="masterTable">

			<tr>
				<td width="140px">Factory Code</td>
				<td><s:input id="txtFactoryCode" path="strFactoryCode"
					 readonly="true" ondblclick="funHelp('POSFactoryMaster')" /></td>
			</tr>
			<tr>
				<td><label>Factory Name</label></td>
				<td><s:input colspan="3" type="text" id="txtFactoryName" 
						name="txtFactoryName" path="strFactoryName" required="true"
						  /> 
		</td></tr>
			
			
			
		</table> --%>
		<br />
		<br />
		
	</s:form>

</body>
</html>


