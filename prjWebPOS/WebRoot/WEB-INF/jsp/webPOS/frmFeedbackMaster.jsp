<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Payment Setup</title>
<link rel="stylesheet" type="text/css" href="<spring:url value="/resources/css/jquery-confirm.min.css"/>"/>
<script type="text/javascript" src="<spring:url value="/resources/js/jquery-confirm.min.js"/>"></script>
<script type="text/javascript" src="<spring:url value="/resources/js/confirm-prompt.js"/>"></script>
<script type="text/javascript" src="<spring:url value="/resources/js/jquery.autocomplete.min.js"/>"></script>
		
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
	
 
	/**
	* Reset  Form
	**/
	function funResetFields()
	{
		document.reload();
    }
	
	function funHelp(transactionName)
	{	  
     
       window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
    }
	

	
	function funSetData(strQuestionCode)
	{
		 $("#txtQuestionCode").val(strQuestionCode);
		var searchurl=getContextPath()+"/loadFeedbackMaster.html?queCode="+strQuestionCode;
		 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(response.strChannelName=='Invalid Code')
			        	{
			        		alert("Invalid Channel Name");
			        	}
			        	else
			        	{
				        	$("#txtQuestionCode").val(response.strQuestionCode);
				        	$("#cmbPOSName").val(response.strPOSCode);
				        	$("#txtQuestion").val(response.strQuestion);
				        	$("#cmbType").val(response.strType);
				        	
				        	$("#txtRating").val(response.intRating);
				        	$("#txtSequence").val(response.intSequence);
				        	
				        	$("#txtChannelID").val(response.strChannelID);
				        	if(response.strOperational=='Y')
			        		{
				        		$("#chkOperational").prop('checked',true);
			        		}
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
				%>confirmDialog('Message !','Data Saved'+ message);<%
			}
		}%>
	});
	</script>


</head>

<body>
	<div id="formHeading">
		<label>Feedback Master</label>
	</div>

	<s:form name="FeedbackMaster" method="POST" action="saveFeedbackMaster.html"  class="formoid-default-skyblue" style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans','Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;max-width:880px;min-width:150px;margin-top:2%;" > 
		<br />
		<br />
		
		 <div class="title" style="margin-left: 25%;">
		 	<div class="row" style="background-color: #fff;margin-bottom:  10px;display: -webkit-box; ">
				<div class="element-input col-lg-6" style="width: 20%; margin-left: 10%"> 
	    			<label class="title">Question Code</label>
	    		</div>
	    		    <div class="element-input col-lg-6" style="margin-bottom:  10px;width: 30%;"> 
					<s:input class="large" colspan="3" type="text" id="txtQuestionCode" path="strQuestionCode"  ondblclick="funHelp('feedbackMaster')" readonly="true"/>
				</div>
	    		
			</div>
			<div class="row" style="background-color: #fff;margin-bottom:  10px;display: -webkit-box;">	
				<div class="element-input col-lg-6" style="width: 20%; margin-left: 10%">
						<label class="title">POS Name</label>
				</div>
				<div class="element-input col-lg-6"  style="width: 30%;">
						<s:select id="cmbPOSName" path="strPOSCode" items="${posList}"  style="width: 100%;"/>
				</div>
			</div>
			
			<div class="row" style="background-color: #fff;margin-bottom:  10px;display: -webkit-box;">
				<div class="element-input col-lg-6" style="width: 20%; margin-left: 10%" >
					<label class="title">Question</label>
				</div>
				<div class="element-input col-lg-6"  style="width: 30%;">
					<s:input class="large" type="text" id="txtQuestion" path="strQuestion"   style="width: 100%;"/>
				</div> 
			</div>
			
			<%-- <div class="row" style="background-color: #fff;margin-bottom:  10px;display: -webkit-box;">
				<div class="element-input col-lg-6" style="width: 20%; margin-left: 10%" >
					<label class="title">Answer</label>
				</div>
				<div class="element-input col-lg-6"  style="width: 30%;">
					<s:input class="large" type="checkbox" id="chkOperational" path="strOperational"   style="width: 100%;"/>
				</div> 
			</div> --%>
				
			
				<div class="row" style="background-color: #fff;margin-bottom:  10px;display: -webkit-box;">
				<div class="element-input col-lg-6" style="width: 20%; margin-left: 10%" >
					<label class="title">Question Type</label>
				</div>
				<div class="element-input col-lg-6"  style="width: 30%;">
					<%-- <s:input class="large" type="text" id="txtType" path="strType"   style="width: 100%;"/> --%>
					<s:select id="cmbType"  path="strType">

											<option value="Star">Stars</option>
											<option value="Options">Options</option>
											<option value="Text">Text</option>
											<option value="BarRating">BarRating</option>
					</s:select>
				</div> 
			</div>
			
				<div class="row" style="background-color: #fff;margin-bottom:  10px;display: -webkit-box;">
				<div class="element-input col-lg-6" style="width: 20%; margin-left: 10%" >
					<label class="title">Rating Limit</label>
				</div>
				<div class="element-input col-lg-6"  style="width: 30%;">
					<s:input class="large" type="text" id="txtRating" path="intRating"   style="width: 100%;"/>
				</div> 
			</div>
	
		 	<div class="row" style="background-color: #fff;margin-bottom:  10px;display: -webkit-box;">
				<div class="element-input col-lg-6" style="width: 20%; margin-left: 10%" >
					<label class="title">Sequence</label> 
				</div>
				<div class="element-input col-lg-6"  style="width: 30%;">
					<s:input class="large" type="text" id="txtSequence" path="intSequence"   style="width: 100%;"/>
				</div> 
			</div>
			
			<div class="row" style="background-color: #fff;margin-bottom:  10px;display: -webkit-box;">
				<div class="element-input col-lg-6" style="width: 20%; margin-left: 10%" >
					<label class="title">Operational</label>
				</div>
				<div class="element-input col-lg-6"  style="width: 30%;">
					<s:input type="checkbox"  id="chkOperational"  path="strOperational"></s:input>
					
				</div> 
			</div>
			
			
			 <div class="col-lg-10 col-sm-10 col-xs-10" style="width: 60%;">
	    			<p align="center">
	           		<div class="submit col-lg-4 col-sm-4 col-xs-4"  ><input type="submit" value="SUBMIT" style="margin-top: 30%; margin-left: 60%"/></div>
	         
	           		<div class="submit col-lg-4 col-sm-4 col-xs-4" ><input type="reset" value="RESET" style="margin-top: 30%; margin-left: 70%" onclick="funResetFields()" ></div>
	    			</p>
	  		</div>
	   			
		</div>
	</s:form>

</body>
</html>
