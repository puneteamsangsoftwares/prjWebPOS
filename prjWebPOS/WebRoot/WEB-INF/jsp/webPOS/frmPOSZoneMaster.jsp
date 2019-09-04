<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Zone Master</title>
<link rel="stylesheet" type="text/css"
	href="<spring:url value="/resources/css/jquery-confirm.min.css"/>" />
<script type="text/javascript"
	src="<spring:url value="/resources/js/jquery-confirm.min.js"/>"></script>
<script type="text/javascript"
	src="<spring:url value="/resources/js/confirm-prompt.js"/>"></script>

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
 	var fieldName;
 	 $(document).ready(function () {
	      $('input#txtZoneCode').mlKeyboard({layout: 'en_US'});
		  $('input#txtZoneName').mlKeyboard({layout: 'en_US'});
		}); 
 	 

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
		$("#txtZoneCode").val(code);
		 var searchurl=getContextPath()+"/loadPOSZoneMasterData.html?POSZoneCode="+code;
		 $.ajax({
			        type: "GET",
			        url: searchurl,
			        dataType: "json",
			        success: function(response)
			        {
			        	if(response.strZoneCode=='Invalid Code')
			        	{
			        		confirmDialog("Invalid Zone Code");
			        		$("#txtZoneCode").val('');
			        	}
			        	else
			        	{
				        	$("#txtZoneCode").val(response.strZoneCode);
				        	$("#txtZoneName").val(response.strZoneName);
				        	$("#txtZoneName").focus();
		
				        	
			        	} 
					},
			
		      });
	}
	
	
 		
	/**
	* Success Message After Saving Record
	**/
	$(document).ready(function()
	{
		var message='';
		<%if (session.getAttribute("success") != null) {
				if (session.getAttribute("successMessage") != null) {%>
				message='<%=session.getAttribute("successMessage").toString()%>';
<%session.removeAttribute("successMessage");
				}
				boolean test = ((Boolean) session.getAttribute("success"))
						.booleanValue();
				session.removeAttribute("success");
				if (test) {%>
	confirmDialog("Data Saved \n\n" + message, "");
<%}
			}%>
	$("form")
								.submit(
										function(event) {
											if ($("#txtZoneName").val().trim() == "") {
												confirmDialog(
														"Please Enter Zone Name",
														"");
												return false;
											}
											if ($("#txtZoneName").val().length > 30) {
												confirmDialog(
														"Zone Name length must be less than 30",
														"");
												return false;
											}

											else {
												flg = funCallFormAction();
												return flg;
											}
										});
					});

	function funCallFormAction() {
		var flg = true;

		var code = $('#txtZoneCode').val();
		var name = $('#txtZoneName').val();
		$.ajax({
			type : "GET",
			url : getContextPath() + "/checkZoneName.html?strZoneName=" + name
					+ "&strZoneCode=" + code,
			async : false,
			dataType : "text",
			success : function(response) {
				if (response == "false") {
					confirmDialog("Zone Name Already Exist!", "");
					$('#txtZoneName').focus();
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
<body>

	<div id="formHeading">
		<label>Zone Master</label>
	</div>

	<br />
	<br />

	<s:form name="ZoneMaster" method="POST"
		action="savePOSZoneMaster.html?saddr=${urlHits}"
		class="formoid-default-skyblue"
		style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans','Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;max-width:100%;min-width:50%;margin-top:2%;">
		<div class="title" style="margin-left: 25%;">
			<div class="row"
				style="background-color: #fff; margin-bottom: 10px; display: -webkit-box;">
				<div class="element-input col-lg-6"
					style="width: 20%; margin-left: 10%">
					<label class="title">Zone Code</label>
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
					<s:input class="large" type="text" id="txtZoneCode"
						path="strZoneCode" ondblclick="funHelp('POSZoneMaster')"
						readonly="true" style="width: 100%;" />
				</div>
			</div>
			<div class="row"
				style="background-color: #fff; margin-bottom: 10px; display: -webkit-box;">
				<div class="element-input col-lg-6"
					style="width: 20%; margin-left: 10%">
					<label class="title">Zone Name</label>
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
					<s:input class="large" type="text" id="txtZoneName"
						path="strZoneName" style="width: 100%;" />
				</div>
			</div>
		</div>
		

		<br />
		<br />
		<p align="center">
			<input type="submit" value="Submit" tabindex="3" /> <input
				type="reset" value="Reset" onclick="funResetFields()" />
		</p>

	</s:form>
</body>
</html>
