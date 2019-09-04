<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Notification Master</title>
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
	 var startDate="${gPOSDate}";
	  	var Date = startDate.split(" ");
		var arr = Date[0].split("-");
		Dat=arr[2]+"-"+arr[1]+"-"+arr[0];	
		$("#txtFromDate").datepicker({ dateFormat: 'dd-mm-yy'  });
		$("#txtFromDate" ).datepicker('setDate', Dat);
		
		$("#txtToDate").datepicker({ dateFormat: 'dd-mm-yy'  });
		$("#txtToDate" ).datepicker('setDate', Dat);
		  $("form").submit(function(event){
			 
			/*   var fromDate = $("#txtFromDate").val();
			  var toDate = $("#txtToDate").val();
			  var frmDate= fromDate.split('-');
				 Dat=frmDate[0]+frmDate[1]+frmDate[2];	
				 fDate = Dat;

				    var tDate= toDate.split('-');
					 Dat=tDate[0]+tDate[1]+tDate[2];	
					t1Date =  Dat; */
					
					
			  if($("#cmbNotificationType").val().trim()=="")
				{
				  confirmDialog("Please Enter Notification Type");
					return false;
				}
			   if($("#txtNotificationText").val().trim().length < 1)
				{
				  confirmDialog("Please Enter Notification Text");
					return false;
				} 
			  else{
				  flg=funCallFormAction();
				  return flg;
			  }
			});
		}); 

	/**
	* Reset  Form
	**/
	function funResetFields()
	{
		$("#cmbNotificationType").focus();
		
 }
	function funSetData(code)
	{
		$("#txtNotificationCode").val(code);
		var searchurl=getContextPath()+"/loadNotificationMasterData.html?POSNotificationCode="+code;		
		 $.ajax({
		        type: "GET",
		        url: searchurl,
		        dataType: "json",
		        async: false,
		        success: function(response)
		        {
		        	if(response.strNotificationCode=='Invalid Code')
		        	{
		        		alert("Invalid Group Code");
		        		$("#txtNotificationCode").val('');
		        	}
		        	else
		        	{
		        		$("#txtNotificationCode").val(response.strNotificationCode);
			        	$("#txtFromDate").val(response.dteFromDate);
			        	$("#txtToDate").val(response.dteToDate);
			        	$("#txtNotificationText").val(response.strNotificationText);
			        	$("#cmbNotificationType").val(response.strNotificationType);
			        	$("#cmbAreaCode").val(response.strAreaCode);

			        	$("#cmbPOSName").val(response.strPOSCode);
			 
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
		* Open Help
		**/
		function funHelp(transactionName)
		{	       
	       window.open("searchform.html?formname="+transactionName+"&searchText=","","dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
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
	confirmDialog(
								'Message !', 'Data Saved' + message);
<%}
			}%>
	});

	$(function() {
		var POSDate = "${gPOSDate}"
		var startDate = "${gPOSDate}";
		var Date = startDate.split(" ");
		var arr = Date[0].split("-");
		Dat = arr[2] + "-" + arr[1] + "-" + arr[0];
		$("#txtFromDate").datepicker({
			dateFormat : 'dd-mm-yy'
		});
		$("#txtFromDate").datepicker('setDate', Dat);
		$("#txtToDate").datepicker({
			dateFormat : 'dd-mm-yy'
		});
		$("#txtToDate").datepicker('setDate', Dat);
	});
</script>
</head>
<body>
	<div id="formHeading">
		<label>Notification Master</label>
	</div>
	<s:form name="AreaForm" method="POST"
		action="saveNotificationMaster.html" class="formoid-default-skyblue"
		style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans','Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;max-width:100%;min-width:50%;margin-top:2%;">

		<div class="title" style="margin-left: 25%;">

			<div class="row"
				style="background-color: #fff; margin-bottom: 10px; display: -webkit-box;">
				<div class="element-input col-lg-6"
					style="width: 20%; margin-left: 10%">
					<label class="title">Notification Code</label>
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
					<s:input class="large" type="text" id="txtNotificationCode"
						path="strNotificationCode"
						ondblclick="funHelp('POSNotificationMaster')" readonly="true"
						style="width: 100%;" />
				</div>
			</div>
			<div class="row"
				style="background-color: #fff; margin-bottom: 10px; display: -webkit-box;">
				<div class="element-input col-lg-6"
					style="width: 20%; margin-left: 10%">
					<label class="title">POS Name</label>
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
					<s:select id="cmbPOSCode" path="strPOSCode" items="${posList}"
						style="width: 100%;" />
				</div>

			</div>
			<div class="row"
				style="background-color: #fff; margin-bottom: 10px; display: -webkit-box;">
				<div class="element-input col-lg-6"
					style="width: 20%; margin-left: 10%">
					<label class="title">From Date</label>
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
					<s:input type="text" id="txtFromDate" path="dteFromDate"
						pattern="\d{1,2}-\d{1,2}-\d{4}" style="width: 100%; " />
				</div>
				<div class="element-input col-lg-6" style="width: 12%;">
					<label class="title">To Date</label>
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
					<s:input type="text" id="txtToDate" path="dteToDate"
						pattern="\d{1,2}-\d{1,2}-\d{4}" style="width: 100%;" />
				</div>
			</div>
			<div class="row"
				style="background-color: #fff; margin-bottom: 10px; display: -webkit-box;">
				<div class="element-input col-lg-6"
					style="width: 20%; margin-left: 10%">
					<label class="title">Notification Type</label>
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
					<s:select id="cmbNotificationType" path="strNotificationType"
						style="width: 100%; ">
						<s:option value="KOT Message">KOT Message</s:option>
					</s:select>
				</div>

			</div>
			<div class="row"
				style="background-color: #fff; margin-bottom: 10px; display: -webkit-box;">
				<div class="element-input col-lg-6"
					style="width: 20%; margin-left: 10%">
					<label class="title">Area</label>
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
					<s:select id="cmbAreaCode" path="strAreaCode" items="${areaList}"
						style="width: 100%;" />

				</div>

			</div>
			<div class="row"
				style="background-color: #fff; margin-bottom: 10px; display: -webkit-box;">
				<div class="element-input col-lg-6"
					style="width: 20%; margin-left: 10%">
					<label class="title">Message</label>
				</div>
				<div class="element-input col-lg-6" style="width: 20%;">
					<s:textarea colspan="10" rowspan="5" path="strNotificationText"
						style="width: 100%;" />

				</div>

			</div>
			<div class="col-lg-10 col-sm-10 col-xs-10" style="width: 100%;">
				<p align="center">
				<div class="submit col-lg-4 col-sm-4 col-xs-4">
					<input type="submit" value="SUBMIT" style="margin-top: 30%;margin-left: 45%;" />
				</div>

				<div class="submit col-lg-4 col-sm-4 col-xs-4">
					<input type="reset" value="RESET" style="margin-top: 30%;margin-left: -18%;"
						onclick="funResetFields()">
				</div>
				</p>
			</div>

		</div>
	</s:form>
</body>
</html>