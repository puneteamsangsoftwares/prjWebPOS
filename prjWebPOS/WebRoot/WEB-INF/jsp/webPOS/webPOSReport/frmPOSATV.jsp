<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>


<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Average Ticket Value Report</title>
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
	/*On form Load It Reset form :Ritesh 22 Nov 2014*/
/* 	$(function() {
		$("#txtFromDate").datepicker({
			dateFormat : 'dd-mm-yy'
		});
		$("#txtFromDate").datepicker('setDate', 'today');
		$("#txtToDate").datepicker({
			dateFormat : 'dd-mm-yy'
		});
		$("#txtToDate").datepicker('setDate', 'today');

	}); */
	
	
	
	$(function() 
			{	
				 	var gEnableShiftYN="${gEnableShiftYN}";
					var POSDate="${POSDate}"
			   		 var startDate="${POSDate}";
				  	var Date = startDate.split(" ");
					var arr = Date[0].split("-");
					Dat=arr[2]+"-"+arr[1]+"-"+arr[0];	
				 			$("#txtFromDate" ).datepicker({ dateFormat: 'dd-mm-yy' });		
					$("#txtFromDate" ).datepicker('setDate', Dat); 
					$("#txtToDate").datepicker({ dateFormat: 'dd-mm-yy' });
					$("#txtToDate" ).datepicker('setDate', Dat);  

					if(gEnableShiftYN=='Y')
					{
						document.getElementById("lblShift").style.visibility = "visible"; 
						document.getElementById("txtShiftCode").style.visibility = "visible"; 
					}
					else
					{
						document.getElementById("lblShift").style.visibility = "hidden";
						document.getElementById("txtShiftCode").style.visibility = "hidden"; 
						
					}	
							
			}); 

	/**
	* Reset The Item Name TextField
	**/
	function funResetFields()
	{
			location.reload();
	}
</script>


</head>

<body>
	<div id="formHeading">
		<label>Average Ticket Value Report</label>
	</div>
	<s:form name="POSAvgTicketValueReportForm" method="POST"
		class="formoid-default-skyblue"
		style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans','Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;margin-top:2%;max-width:100%;min-width:150px;"
		action="rptPOSAverageTicketValueReport.html?saddr=${urlHits}" target="_blank">

		<br />
		<br />
		<div class="title" style="margin-left: 35%; width: 50%">
			<div class="row"
				style="background-color: #fff; margin-bottom: 10px; display: block; width: 50%">
				<div class="element-input col-lg-6">
					<label class="title">POS Name</label>
				</div>
				<div class="element-input col-lg-6"
					style="width: 50%; margin-left: -10%">
					<s:select id="cmbPOSName" name="cmbPOSName" path="strPOSName"
						items="${posList}"></s:select>
				</div>
			</div>
			<div class="row"
				style="background-color: #fff; margin-bottom: 10px; display: block; width: 50%">
				<div class="element-input col-lg-6">
					<label class="title">From Date</label>
				</div>
				<div class="element-input col-lg-6"
					style="width: 50%; margin-left: -10%">
					<s:input id="txtFromDate" required="required" path="fromDate"
						pattern="\d{1,2}-\d{1,2}-\d{4}" />
				</div>
			</div>
			<div class="row"
				style="background-color: #fff; margin-bottom: 10px; display: block; width: 50%">
				<div class="element-input col-lg-6">
					<label class="title">To Date</label>
				</div>
				<div class="element-input col-lg-6"
					style="width: 50%; margin-left: -10%">
					<s:input id="txtToDate" required="required" path="toDate"
						pattern="\d{1,2}-\d{1,2}-\d{4}" />
				</div>
			</div>
			<div class="row"
				style="background-color: #fff; margin-bottom: 10px; display: block; width: 50%">
				<div class="element-input col-lg-6">
					<label class="title">Pos Wise</label>
				</div>
				<div class="element-input col-lg-6"
					style="width: 50%; margin-left: -10%">
					<s:select id="cmbPosWise" path="strPosWise">
						<s:option value="NO">NO</s:option>
						<s:option value="YES">YES</s:option>

					</s:select>
				</div>
			</div>
			<div class="row"
				style="background-color: #fff; margin-bottom: 10px; display: block; width: 50%">
				<div class="element-input col-lg-6">
					<label class="title">Date Wise</label>
				</div>
				<div class="element-input col-lg-6"
					style="width: 50%; margin-left: -10%">
					<s:select id="cmbDateWise" path="strDateWise">
						<s:option value="NO">NO</s:option>
						<s:option value="YES">YES</s:option>
					</s:select>
				</div>
			</div>
			<div class="row"
				style="background-color: #fff; margin-bottom: 10px; display: block; width: 50%">
				<div class="element-input col-lg-6">
					<label class="title">Report Type</label>
				</div>
				<div class="element-input col-lg-6"
					style="width: 50%; margin-left: -10%">
					<s:select id="cmbDocType" path="strDocType">
						<s:option value="PDF">PDF</s:option>
						<s:option value="XLS">EXCEL</s:option>

					</s:select>
				</div>
			</div>
			<div class="row"
				style="background-color: #fff; margin-bottom: 10px; display: block; width: 50%">
				<div class="element-input col-lg-6">
					<label class="title">Shift</label>
				</div>
				<div class="element-input col-lg-6"
					style="width: 50%; margin-left: -10%">
					<s:select items="${shiftList}" id="txtShiftCode"
						path="strShiftCode">

					</s:select>
				</div>
			</div>
		</div>

		<br />
		<br />
		<p align="center">
			<input type="submit" value="Submit" tabindex="3"
				style="margin-left: -2%" /> <input type="reset" value="Reset"
				onclick="funResetFields()" style="margin-left: 2%" />
		</p>
	</s:form>

</body>
</html>