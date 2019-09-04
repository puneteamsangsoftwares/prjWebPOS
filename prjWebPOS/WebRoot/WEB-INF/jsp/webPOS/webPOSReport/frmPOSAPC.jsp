<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>


<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Average Per Cover Report</title>
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
		<label>Average Per Cover Report</label>
	</div>
	<s:form name="POSAvgPerCoverReportForm" method="POST"
		class="formoid-default-skyblue"
		style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans','Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;margin-top:2%;max-width:100%;min-width:150px;"
		action="rptPOSAvgPerCover.html?saddr=${urlHits}" target="_blank">

		<br />
		<br />
		<div class="title" style="margin-left: 40%;">
			<div class="row" style="background-color: #fff; display: block;">
				<div class="element-input col-lg-6" style="width: 15%;">
					<label class="title">POS Name</label>
				</div>
				<div class="element-input col-lg-6"
					style="margin-bottom: 10px; width: 25%">
					<s:select id="cmbPOSName" path="strPOSName" items="${posList}">
					</s:select>
				</div>
			</div>
			<div class="row" style="background-color: #fff; display: block;">

				<div class="element-input col-lg-6" style="width: 15%;">
					<label class="title">From Date</label>
				</div>
				<div class="element-input col-lg-6"
					style="margin-bottom: 10px; width: 25%">
					<s:input id="txtFromDate" required="required" path="fromDate"
						pattern="\d{1,2}-\d{1,2}-\d{4}" style="width: 100%;" />
				</div>
			</div>

			<div class="row" style="background-color: #fff; display: block;">

				<div class="element-input col-lg-6" style="width: 15%;">
					<label class="title">To Date</label>
				</div>
				<div class="element-input col-lg-6"
					style="margin-bottom: 10px; width: 25%">
					<s:input id="txtToDate" required="required" path="toDate"
						pattern="\d{1,2}-\d{1,2}-\d{4}" style="width: 100%;" />
				</div>
			</div>
			<div class="row" style="background-color: #fff; display: block;">
				<div class="element-input col-lg-6" style="width: 15%;">
					<label class="title">Pos Wise</label>
				</div>
				<div class="element-input col-lg-6"
					style="width: 25%; margin-bottom: 10px;">
					<s:select id="cmbPosWise" path="strPosWise">
						<s:option value="NO">NO</s:option>
						<s:option value="YES">YES</s:option>


					</s:select>
				</div>
			</div>
			<div class="row" style="background-color: #fff; display: block;">
				<div class="element-input col-lg-6" style="width: 15%;">
					<label class="title">Date Wise</label>
				</div>
				<div class="element-input col-lg-6"
					style="width: 25%; margin-bottom: 10px;">
					<s:select id="cmbDateWise" path="strDateWise">
						<s:option value="NO">NO</s:option>
						<s:option value="YES">YES</s:option>


					</s:select>
				</div>
			</div>
			<div class="row" style="background-color: #fff; display: block;">
				<div class="element-input col-lg-6" style="width: 15%;">
					<label class="title">Waiter Wise</label>
				</div>
				<div class="element-input col-lg-6"
					style="width: 25%; margin-bottom: 10px;">
					<s:select id="cmbWaiterWise" path="strWShortName"
						items="${waiterlist}">
					</s:select>
				</div>
			</div>
				<div class="row" style="background-color: #fff; display: block;">
				<div class="element-input col-lg-6" style="width: 15%;">
					<label class="title">Report type</label>
				</div>
				<div class="element-input col-lg-6"
					style="width: 25%; margin-bottom: 10px;">
					<s:select id="cmbDocType" path="strDocType">
						<s:option value="PDF">PDF</s:option>
						<s:option value="XLS">EXCEL</s:option>
					</s:select>
				</div>
			</div>

			<div class="row" style="background-color: #fff; display: block;">
				<div class="element-input col-lg-6" style="width: 15%;">
					<label class="title">Report Mode</label>
				</div>
				<div class="element-input col-lg-6"
					style="width: 25%; margin-bottom: 10px;">
					<s:select id="cmbReportMode" path="strReportType">
						<s:option value="Summary">Summary</s:option>
						<s:option value="Detail">Detail</s:option>

					</s:select>
				</div>
			</div>
			<div class="row" style="background-color: #fff; display: block;">
				<div class="element-input col-lg-6" style="width: 15%;">
					<label class="title">APC On</label>
				</div>
				<div class="element-input col-lg-6"
					style="width: 25%; margin-bottom: 10px;">
					<s:select id="cmbAPCOn" path="strViewType">
						<s:option value="Net Sale">Net Sale</s:option>
						<s:option value="Gross Sale">Gross Sale</s:option>
					</s:select>
				</div>
			</div>

		</div>

		<br />
		<br />
		<p align="center">
			<input type="submit" value="Submit" tabindex="3" /> <input
				type="reset" value="Reset" onclick="funResetFields()" style="margin-left: 2%" />
		</p>
	</s:form>

</body>
</html>