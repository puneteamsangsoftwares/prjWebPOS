<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>GROUP MASTER</title>
<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/jquery-confirm.min.css"/>"/>
<script type="text/javascript" src="<spring:url value="/resources/js/jquery-confirm.min.js"/>"></script>
<script type="text/javascript" src="<spring:url value="/resources/js/confirm-prompt.js"/>"></script>

<script type="text/javascript">

$(document).ready(function () {
	  $('input#txtGroupCode').mlKeyboard({layout: 'en_US'});
	  $('input#txtGroupName').mlKeyboard({layout: 'en_US'});
	  
	  $("form").submit(function(event){
		  if($("#txtGroupName").val().trim()=="")
		  {
			  confirmDialog("Please Enter Group Name","");
				return false;
		  }
		 else
		 {
			
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
		$("#txtGroupName").focus();
		$("#txtOperationType").val('N');
    }
	
	
		/**
		* Open Help
		**/
		function funHelp(transactionName)
		{	       
	       // window.showModalDialog("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	       window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	    }
		
		/**
		* Get and Set data from help file and load data Based on Selection Passing Value(Group Code)
		**/
		function funSetData(code)
		{
			$("#txtGroupCode").val(code);
			var searchurl=getContextPath()+"/loadPOSGroupMasterData.html?POSGroupCode="+code;
			 $.ajax({
				 type: "GET",
			        url: searchurl,
			        dataType: "json",
			       
				        success: function(response)
				        {
				        	if(response.strGCode=='Invalid Code')
				        	{
				        		confirmDialog("Invalid Group Code","");
				        		$("#txtGroupCode").val('');
				        	}
				        	else
				        	{
					        	$("#txtGroupCode").val(response.strGroupCode);
					        	$("#txtGroupName").val(response.strGroupName);
					        	$("#txtGroupName").focus();
					        	$("#txtShortName").val(response.strShortName);
					        	
					        	if(response.strOperational=='Y')
				        		{
					        		$("#chkOperational").prop('checked',true);
				        		}
					        	else
					        		$("#chkOperational").prop('checked',false);
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
			/**
			* On Blur Event on TextField
			**/
// 			$('#txtGroupCode').blur(function() 
// 			{
// 					var code = $('#txtGroupCode').val();
// 					if (code.trim().length > 0 && code !="?" && code !="/")
// 					{				
// 						funSetData(code);							
// 					}
// 			});
			
			$('#txtGroupName').blur(function () {
				 var strGName=$('#txtGroupName').val();
			      var st = strGName.replace(/\s{2,}/g, ' ');
			      $('#txtGroupName').val(st);
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
<%session.removeAttribute("successMessage");
				}
				boolean test = ((Boolean) session.getAttribute("success")).booleanValue();
				session.removeAttribute("success");
				if (test) 
				{%>
				confirmDialog("Data Saved \n\n"
								+ message);
<%}
			}%>
	});

	/**
	 *  Check Validation Before Saving Record
	 **/
	function funCallFormAction(actionName, object) {
		var flg = true;

		var name = $('#txtGroupName').val();
		var code = $('#txtGroupCode').val();

		$.ajax({
			type : "GET",
			url : getContextPath() + "/CheckPosGroupName.html?name=" + name
					+ "&code=" + code,
			async : false,
			dataType : "text",
			success : function(response) {
				if (response == "false") {
					alert("Group Name Already Exist!");
					$('#txtGroupName').focus();
					flg = false;
				} else {
					flg = true;
				}
			},
			error : function(jqXHR, exception) {
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
</script>
</head>

<body onload="funResetFields()">
	<s:form name="grpForm" method="POST" action="saveGroupMaster.html">
	<div class="title" style="margin-left: 25%;">
	 
	 	<div class="row" style="background-color: #fff;margin-bottom:  10px;display: -webkit-box; ">
			<div class="element-input col-lg-6" style="width: 20%; margin-left: 10%"> 
    			<label class="title">Area Code</label>
    		</div>
    		<div class="element-input col-lg-6"  style="width: 30%;"> 
				<s:input class="large" type="text" id="txtAreaCode" path="strAreaCode"  ondblclick="funHelp('POSAreaMaster')" readonly="true" style="width: 100%;"/>
			</div>
		</div>
		
		<div class="row" style="background-color: #fff;margin-bottom:  10px;display: -webkit-box;">
			<div class="element-input col-lg-6" style="width: 20%; margin-left: 10%" >
				<label class="title">Area Name</label>
			</div>
			<div class="element-input col-lg-6"  style="width: 30%;">
				<s:input class="large" type="text" id="txtAreaName" path="strAreaName"   style="width: 100%;"/>
			</div> 
		</div>
			
		<div class="row" style="background-color: #fff;margin-bottom:  10px;display: -webkit-box;">	
			<div class="element-input col-lg-6" style="width: 20%; margin-left: 10%">
					<label class="title">POS Name</label>
			</div>
			<div class="element-input col-lg-6"  style="width: 30%;">
					<s:select id="cmbPOSName" path="strPOSName" items="${posList}"  style="width: 100%;"/>
			</div>
			
		</div>
		
			 <div class="col-lg-10 col-sm-10 col-xs-10" style="width: 60%;">
     			<p align="center">
            		<div class="submit col-lg-4 col-sm-4 col-xs-4"  ><input type="submit" value="SUBMIT" style="margin-top: 30%; margin-left: 60%"/></div>
          
            		<div class="submit col-lg-4 col-sm-4 col-xs-4" ><input type="reset" value="RESET" style="margin-top: 30%; margin-left: 70%"onclick="funResetFields()"></div>
     			</p>
   			</div>
   			
		</div>
		<%-- <table>
			<tr></tr>
			<tr>
				<td align="right"><a id="baseUrl" href="attachDoc.html">
						Attach Documents </a></td>
			</tr>

			<tr>
				<td><s:label path="strGCode">GroupCode:</s:label></td>
				<td><s:input id="txtGroupCode" name="txtGroupCode"
						path="strGCode" readonly="true" value=""
						ondblclick="funHelp('group')" /></td>
			</tr>

			<tr>
				<td><s:label path="strGName">Group Name:</s:label></td>
				<td><s:input type="text" id="txtGroupName" name="txtGroupName"
						path="strGName" tabindex="1" required="true" /> <s:errors
						path="strGName"></s:errors></td>
			</tr>

			<tr>
				<td><s:label path="strGDesc">Description:</s:label></td>
				<td><s:input id="txtGroupDesc" name="txtGroupDesc"
						path="strGDesc" tabindex="2" /> <s:errors path="strGDesc"></s:errors>
				</td>
			</tr>

			<tr>
				<td colspan="1"><input type="submit" value="Submit"
					tabindex="3" onclick="return funValidateFields()" /></td>
				<td colspan="1"><input type="reset" value="Reset" /></td>
			</tr>
		</table> --%>
	</s:form>
</body>
</html>