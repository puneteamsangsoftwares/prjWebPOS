<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Sales Report</title>
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
#tab_container {
	width: 100%;
	margin: 1;
	height: 500px;
	overflow: auto;
	float: right;
}

ul.tab li.active {
	background: -moz-linear-gradient(center top, #0F5495, #73ADDD) repeat
		scroll 0 0 #f18d05;
	border: 1px solid #0F5495;
	border-radius: 0 0px;
	transition: all 0.9s ease 0s;
}

ul.tab li {
	width: 100px;
	margin: 0;
	padding: 4px 4px;
	height: 25px;
	line-height: 16px;
	border: 1px solid #6DA9DB;
	border-left: none;
	background: #52A4D4;
	overflow: hidden;
	position: relative;
	border-radius: 4px;
	border-right: 1px solid #555;
	font-size: 12px;
	font-weight: bold;
	color: #fff;
}

</style>

<script type="text/javascript">
	var global;
	global = this;
	console.log(global);


    var gEnableShiftYN="${gEnableShiftYN}";
	$(document).ready(function() {
		document.all["divBillWise"].style.display = 'block';
		$(".tab_content").hide();
		$(".tab_content:first").show();

		$("ul.tabs li").click(function() {
			$("ul.tabs li").removeClass("active");
			$(this).addClass("active");
			$(".tab_content").hide();
			var activeTab = $(this).attr("data-state");
			$("#" + activeTab).fadeIn();
		});
		
		
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

	$(function() {

		//	funSetDate();
		var POSDate = "${POSDate}";
		var startDate = "${POSDate}";
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
		funSelectedReport('divBillWise');
		
		 
		
	});
		
	/**

	 * Open Help
	 **/
	 function funDateValidate() {
			if (!($("#txtFromDate").val() <= $("#txtToDate").val())) {
				$("#txtToDate").val($("#txtFromDate").val())
				confirmDialog("To Date is Wrong!");
			}
		}
	function funHelp(transactionName) {
		window.open("searchform.html?formname=" + transactionName
				+ "&searchText=", "",
				"dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	}

	function funSetData(code) {
		$("#txtCustomer").val(code);
	}
	function funSelectedReport(divID) {
		report=divID;
		var POSName = document.getElementById("cmbPOSName").value;
		var FromDate = document.getElementById("txtFromDate").value + ":"
				+ document.getElementById("txtHHFrom").value + "/"
				+ document.getElementById("txtMMFrom").value + "/"
				+ document.getElementById("txtAMPMFrom").value;
		var ToDate = document.getElementById("txtToDate").value + ":"
				+ document.getElementById("txtHHTo").value + "/"
				+ document.getElementById("txtMMTo").value + "/"
				+ document.getElementById("txtAMPMTo").value;
		var Operator = document.getElementById("txtOperator").value;
		var PayMode = document.getElementById("txtPayMode").value;

		var txtFromBillNo = document.getElementById("txtFromBillNo").value;
		var txtToBillNo = document.getElementById("txtToBillNo").value;
		var txtReportType = document.getElementById("txtReportType").value;
		var txtType = document.getElementById("txtType").value;
		var txtCustomer = document.getElementById("txtCustomer").value;
		var chkConsolidatePOS = document.getElementById("chkConsolidatePOS").checked;
		var txtOperationType = document.getElementById("txtOperationType").value;
		var txtAreaCode = document.getElementById("txtAreaCode").value;
		var hidReportName = divID;		
		
		
		$("#hidReportName").val(divID);
		funShowDiv(divID);

		switch (divID) {
		
		case 'divSettlementWise':
			funLoadSettlementWiseSalesReport(divID, POSName, FromDate,
					ToDate, Operator, PayMode, txtFromBillNo, txtToBillNo,
					txtReportType, txtType, txtCustomer, chkConsolidatePOS,
					hidReportName,txtAreaCode,txtOperationType);				
			break;
		case 'divBillWise':
			funLoadBillWiseSalesReport(divID, POSName, FromDate, ToDate,
					Operator, PayMode, txtFromBillNo, txtToBillNo,
					txtReportType, txtType, txtCustomer, chkConsolidatePOS,
					hidReportName,txtAreaCode,txtOperationType);
				
			break;
		case 'divItemWise':
			funLoadItemWiseSalesReport(divID, POSName, FromDate, ToDate,
					Operator, PayMode, txtFromBillNo, txtToBillNo,
					txtReportType, txtType, txtCustomer, chkConsolidatePOS,
					hidReportName,txtAreaCode,txtOperationType);
				
			break;

		case 'divMenuHeadWise':
			funLoadMenuHeadWiseSalesReport(divID, POSName, FromDate,
					ToDate, Operator, PayMode, txtFromBillNo, txtToBillNo,
					txtReportType, txtType, txtCustomer, chkConsolidatePOS,
					hidReportName,txtAreaCode,txtOperationType);
			break;
			
		case 'divGroupWise':
			funLoadGroupWiseSalesReport(divID, POSName, FromDate, ToDate,
					Operator, PayMode, txtFromBillNo, txtToBillNo,
					txtReportType, txtType, txtCustomer, chkConsolidatePOS,
					hidReportName,txtAreaCode,txtOperationType);
			break;

		case 'divSubGroupWise':
			funLoadSubGroupWiseSalesReport(divID, POSName, FromDate,
					ToDate, Operator, PayMode, txtFromBillNo, txtToBillNo,
					txtReportType, txtType, txtCustomer, chkConsolidatePOS,
					hidReportName,txtAreaCode,txtOperationType);
			break;
		case 'divCustWise':
			funLoadCustWiseSalesReport(divID, POSName, FromDate, ToDate,
					Operator, PayMode, txtFromBillNo, txtToBillNo,
					txtReportType, txtType, txtCustomer, chkConsolidatePOS,
					hidReportName,txtAreaCode,txtOperationType);
			break;
		case 'divWaiterWise':
			funLoadWaiterWiseSalesReport(divID, POSName, FromDate, ToDate,
					Operator, PayMode, txtFromBillNo, txtToBillNo,
					txtReportType, txtType, txtCustomer, chkConsolidatePOS,
					hidReportName,txtAreaCode,txtOperationType);
			break;

		case 'divDeliveryBoyWise':
			funLoadDeliveryBoyWiseSalesReport(divID, POSName, FromDate,
					ToDate, Operator, PayMode, txtFromBillNo, txtToBillNo,
					txtReportType, txtType, txtCustomer, chkConsolidatePOS,
					hidReportName,txtAreaCode,txtOperationType);
			break;

		case 'divCostCenterWise':
			funLoadCostCenterWiseSalesReport(divID, POSName, FromDate,
					ToDate, Operator, PayMode, txtFromBillNo, txtToBillNo,
					txtReportType, txtType, txtCustomer, chkConsolidatePOS,
					hidReportName,txtAreaCode,txtOperationType);
			break;

		case 'divHomeDeliveryWise':
			funLoadHomeDeliveryWiseSalesReport(divID, POSName, FromDate,
					ToDate, Operator, PayMode, txtFromBillNo, txtToBillNo,
					txtReportType, txtType, txtCustomer, chkConsolidatePOS,
					hidReportName,txtAreaCode,txtOperationType);
			break;
		case 'divTableWise':
			funLoadTableWiseSalesReport(divID, POSName, FromDate, ToDate,
					Operator, PayMode, txtFromBillNo, txtToBillNo,
					txtReportType, txtType, txtCustomer, chkConsolidatePOS,
					hidReportName,txtAreaCode,txtOperationType);
			break;
		case 'divHourlyWise':
			funLoadHourlyWiseSalesReport(divID, POSName, FromDate, ToDate,
					Operator, PayMode, txtFromBillNo, txtToBillNo,
					txtReportType, txtType, txtCustomer, chkConsolidatePOS,
					hidReportName,txtAreaCode,txtOperationType);
			break;

		case 'divAreaWise':
			funLoadAreaWiseSalesReport(divID, POSName, FromDate, ToDate,
					Operator, PayMode, txtFromBillNo, txtToBillNo,
					txtReportType, txtType, txtCustomer, chkConsolidatePOS,
					hidReportName,txtAreaCode,txtOperationType);
			break;

		case 'divDayWiseSales':
			funLoadDayWiseSalesReport(divID, POSName, FromDate, ToDate,
					Operator, PayMode, txtFromBillNo, txtToBillNo,
					txtReportType, txtType, txtCustomer, chkConsolidatePOS,
					hidReportName,txtAreaCode,txtOperationType);
			break;

		case 'divTaxWiseSales':
			funLoadTaxWiseSalesReport(divID, POSName, FromDate, ToDate,
					Operator, PayMode, txtFromBillNo, txtToBillNo,
					txtReportType, txtType, txtCustomer, chkConsolidatePOS,
					hidReportName,txtAreaCode,txtOperationType);
			break;

		case 'divTipReport':
			funLoadTipSalesReport(divID, POSName, FromDate, ToDate,
					Operator, PayMode, txtFromBillNo, txtToBillNo,
					txtReportType, txtType, txtCustomer, chkConsolidatePOS,
					hidReportName,txtAreaCode,txtOperationType);
			break;
		case 'divItemModifierWise':
			funLoadItemModifierWiseSalesReport(divID, POSName, FromDate,
					ToDate, Operator, PayMode, txtFromBillNo, txtToBillNo,
					txtReportType, txtType, txtCustomer, chkConsolidatePOS,
					hidReportName,txtAreaCode,txtOperationType);
			break;

		case 'divMenuHeadWiseWithModifier':
			funLoadMenuHeadWiseWithModifierSalesReport(divID, POSName,
					FromDate, ToDate, Operator, PayMode, txtFromBillNo,
					txtToBillNo, txtReportType, txtType, txtCustomer,
					chkConsolidatePOS, hidReportName,txtAreaCode,txtOperationType);
			break;

		case 'divItemHourlyWise':
			funLoadItemHourlyWiseSalesReport(divID, POSName, FromDate,
					ToDate, Operator, PayMode, txtFromBillNo, txtToBillNo,
					txtReportType, txtType, txtCustomer, chkConsolidatePOS,
					hidReportName,txtAreaCode,txtOperationType);
			break;

		case 'divOperatorWise':
			funLoadOperatorSalesReport(divID, POSName, FromDate, ToDate,
					Operator, PayMode, txtFromBillNo, txtToBillNo,
					txtReportType, txtType, txtCustomer, chkConsolidatePOS,
					hidReportName,txtAreaCode,txtOperationType);
			break;
		case 'divMonthlySalesFlash':
			funLoadMonthlySalesReport(divID, POSName, FromDate, ToDate,
					Operator, PayMode, txtFromBillNo, txtToBillNo,
					txtReportType, txtType, txtCustomer, chkConsolidatePOS,
					hidReportName,txtAreaCode,txtOperationType);
			break;
				

		}
		
	}

	/* divDeliveryBoyWise divCostCenterWise divHomeDeliveryWise divTableWise divHourlyWise divAreaWise divDayWiseSales
		divTaxWiseSales divTipReport divItemModifierWise  divMenuHeadWiseWithModifier divItemHourlyWise
		divOperatorWise divMonthlySalesFlash */
	function funShowDiv(divID) {
		$("#wait").css("display", "block");
		document.all["divSettlementWise"].style.display = 'none';
		document.all["divBillWise"].style.display = 'none';
		document.all["divItemWise"].style.display = 'none';
		document.all["divMenuHeadWise"].style.display = 'none';
		document.all["divGroupWise"].style.display = 'none';
		document.all["divSubGroupWise"].style.display = 'none';
		document.all["divCustWise"].style.display = 'none';
		document.all["divWaiterWise"].style.display = 'none';
		document.all["divDeliveryBoyWise"].style.display = 'none';
		document.all["divCostCenterWise"].style.display = 'none';
		document.all["divHomeDeliveryWise"].style.display = 'none';
		document.all["divTableWise"].style.display = 'none';
		document.all["divHourlyWise"].style.display = 'none';
		document.all["divAreaWise"].style.display = 'none';
		document.all["divDayWiseSales"].style.display = 'none';
		document.all["divTaxWiseSales"].style.display = 'none';
		document.all["divTipReport"].style.display = 'none';
		document.all["divItemModifierWise"].style.display = 'none';
		document.all["divMenuHeadWiseWithModifier"].style.display = 'none';
		document.all["divItemHourlyWise"].style.display = 'none';
		document.all["divOperatorWise"].style.display = 'none';
		document.all["divMonthlySalesFlash"].style.display = 'none';

		document.all[divID].style.display = 'block';

		/* funLoadSalesReport(); */
	}

	/*fill Settlement wise data */
	function funLoadSettlementWiseSalesReport(divID, POSName, FromDate, ToDate,
			Operator, PayMode, txtFromBillNo, txtToBillNo, txtReportType,
			txtType, txtCustomer, chkConsolidatePOS, hidReportName,txtAreaCode,txtOperationType) {
		//	document.forms["POSSalesReportForm"].submit();
		var shiftCode='1';
		if(gEnableShiftYN=='Y')
		{
			shiftCode=document.getElementById("txtShiftCode").value;
		}
		var searchurl = getContextPath()
				+ "/loadSettlementWiseSalesReport.html?POSName=" + POSName
				+ "&FromDate=" + FromDate + "&ToDate=" + ToDate + "&Operator="
				+ Operator + "&PayMode=" + PayMode + "&txtFromBillNo="
				+ txtFromBillNo + "&txtToBillNo=" + txtToBillNo
				+ "&txtReportType=" + txtReportType + "&txtType=" + txtType
				+ "&txtCustomer=" + txtCustomer + "&chkConsolidatePOS="
				+ chkConsolidatePOS + "&hidReportName=" + hidReportName+"&areaCode="
				+ txtAreaCode + "&operationType=" + txtOperationType+ "&gEnableShiftYN=" + gEnableShiftYN+ "&shiftCode=" + shiftCode;
		$
				.ajax({
					type : "POST",
					url : searchurl,
					dataType : "json",

					success : function(response) {
						funRemoveProductRows("tblSettlementWise");
						funRemoveProductRows("tblSettlementWiseTotal");
						$.each(response,function(i, item) {
											$("#wait").css("display", "none");
											if (i == 0) {
												var table = document
														.getElementById("tblSettlementWiseTotal");
												var rowCount = table.rows.length;
												var totalSubTotal;
												var totalSubTotal=Number(totalSubTotal).toFixed(2);
												var row = table
														.insertRow(rowCount);
												row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"70%\" width=\"60%\" style=\"text-align:right;font-size: 17px;font-weight: bold; \" id=\"Totfield1."
														+ (rowCount)
														+ "\" value=\"Total\" />";
												row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"30%\" width=\"50%\" style=\"align:right;font-size: 15px;\"  id=\"Totfield2."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalSubTotal
														+ "'/>";

											}

											var table = document
													.getElementById("tblSettlementWise");
											var rowCount = table.rows.length;
											var row = table.insertRow(rowCount);
											i = i + 1;
											row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"40%\" id=\"field1."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField1
													+ "'/>";
											row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"15%\" style=\"text-align:left;\" id=\"field2."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField2
													+ "'/>";
											row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"21%\"s tyle=\"text-align:right;\" id=\"field3."
													+ (rowCount)
													+ "\" style=\"text-align:right;\" value='"
													+ response[i].strField3
													+ "'/>";
											row.insertCell(3).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"18%\" style=\"text-align:right;\" id=\"field4."
													+ (rowCount)
													+ "\" style=\"text-align:right;\" value='"
													+ response[i].strField4
													+ "'/>"; //text-align: right;

										});

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
	}

	/*fill bill wise data */
	function funLoadBillWiseSalesReport(divID, POSName, FromDate, ToDate,
			Operator, PayMode, txtFromBillNo, txtToBillNo, txtReportType,
			txtType, txtCustomer, chkConsolidatePOS, hidReportName,txtAreaCode,txtOperationType) {
		var shiftCode='1';
		if(gEnableShiftYN=='Y')
		{
			shiftCode=document.getElementById("txtShiftCode").value;
		}
		var searchurl = getContextPath()
				+ "/loadBillWiseSalesReport.html?POSName=" + POSName
				+ "&FromDate=" + FromDate + "&ToDate=" + ToDate + "&Operator="
				+ Operator + "&PayMode=" + PayMode + "&txtFromBillNo="
				+ txtFromBillNo + "&txtToBillNo=" + txtToBillNo
				+ "&txtReportType=" + txtReportType + "&txtType=" + txtType
				+ "&txtCustomer=" + txtCustomer + "&chkConsolidatePOS="
				+ chkConsolidatePOS + "&hidReportName=" + hidReportName+"&areaCode="
				+ txtAreaCode + "&operationType=" + txtOperationType+ "&gEnableShiftYN=" + gEnableShiftYN+ "&shiftCode=" + shiftCode;;
		$
				.ajax({
					type : "POST",
					url : searchurl,
					dataType : "json",

					success : function(response) {
						funRemoveProductRows("tblBillWise");
						funRemoveProductRows("tblBillWiseTotal");
						$.each(response,function(i, item) {
											$("#wait").css("display", "none");
											if (i == 0) {
												var table = document
														.getElementById("tblBillWiseTotal");
												var rowCount = table.rows.length;
												var row = table
														.insertRow(rowCount);
												row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right; font-size: 17px;font-weight: bold;\" size=\"60%\" id=\"Totfield1."
														+ (rowCount)
														+ "\" value=\"Total\"  />";
												row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right; font-size: 15px;\" size=\"23%\" id=\"Totfield2."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalSubTotal
														+ "'/>";
												row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right; font-size: 15px;\" size=\"19%\" id=\"Totfield3."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalDiscAmt
														+ "'/>";
												row.insertCell(3).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right; font-size: 15px;\" size=\"18%\" id=\"Totfield4."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalTaxAmt
														+ "'/>";
												row.insertCell(4).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right; font-size: 15px;\" size=\"8%\" id=\"Totfield5."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalAdvAmt
														+ "'/>";
												row.insertCell(5).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right; font-size: 15px;\" size=\"8%\" id=\"Totfield6."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalSettleAmt
														+ "'/>";
												row.insertCell(6).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:left; font-size: 15px;\" size=\"8%\" id=\"Totfield7."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalRoundOffAmt
														+ "'/>";													
												row.insertCell(7).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right; font-size: 15px;\" size=\"12%\" id=\"Totfield8."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalTipAmt
														+ "'/>";
												row.insertCell(8).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right; font-size: 15px;\" size=\"38%\" id=\"Totfield9."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalPAX
														+ "'/>";
												
													
												

											}

											var table = document
													.getElementById("tblBillWise");
											var rowCount = table.rows.length;
											var row = table.insertRow(rowCount);
											i = i + 1;
											row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" id=\"field1."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField1
													+ "'/>";
											row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" style=\"text-align:left;\" id=\"field2."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField2
													+ "'/>";
											row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"5%\" style=\"text-align:left;\" id=\"field3."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField3
													+ "'/>";
											row.insertCell(3).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" style=\"text-align:left;\" id=\"field4."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField4
													+ "'/>";
											row.insertCell(4).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"15%\" style=\"text-align:left;\" id=\"field5."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField5
													+ "'/>";
											row.insertCell(5).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" style=\"text-align:left;\" id=\"field6."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField6
													+ "'/>";
											row.insertCell(6).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"2%\" style=\"text-align:right;\" id=\"field18."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField18
													+ "'/>";
											row.insertCell(7).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"13%\" style=\"text-align:left;\" id=\"field7."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField7
													+ "'/>";
											row.insertCell(8).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"8%\" style=\"text-align:right;\" id=\"field8."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField8
													+ "'/>";
											row.insertCell(9).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"8%\" style=\"text-align:right;\" id=\"field9."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField9
													+ "'/>";
											row.insertCell(10).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"8%\" style=\"text-align:right;\" id=\"field10."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField10
													+ "'/>";
											row.insertCell(11).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"8%\" style=\"text-align:right;\" id=\"field11."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField11
													+ "'/>";
											row.insertCell(12).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"8%\" style=\"text-align:right;\" id=\"field12."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField12
													+ "'/>";
											row.insertCell(13).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"7%\" style=\"text-align:right;\" id=\"field21."
													+ (rowCount)
													+ "\"  value='"
													+ response[i].strField21
													+ "'/>";
											row.insertCell(14).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"8%\" style=\"text-align:right;\" id=\"field13."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField13
													+ "'/>";															
											row.insertCell(15).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"7%\" style=\"text-align:right;\" id=\"field19."
													+ (rowCount)
													+ "\"  value='"
													+ response[i].strField19
													+ "'/>";
											row.insertCell(16).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"15%\" style=\"text-align:left;\"  id=\"field14."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField14
													+ "'/>";
											row.insertCell(17).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"7%\" style=\"text-align:right;\" id=\"field15."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField15
													+ "'/>";
											row.insertCell(18).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"15%\"  style=\"text-align:left;\"  id=\"field16."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField16
													+ "'/>";
											row.insertCell(19).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"15%\" style=\"text-align:left;id=\"field17."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField17
													+ "'/>";
											row.insertCell(20).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"7%\" style=\"text-align:center;id=\"field20."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField20
													+ "'/>";
											row.insertCell(21).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"7%\" style=\"text-align:center;id=\"field21."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField22
													+ "'/>";

										});

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
	}

	/*fill Item wise data */
	function funLoadItemWiseSalesReport(divID, POSName, FromDate, ToDate,
			Operator, PayMode, txtFromBillNo, txtToBillNo, txtReportType,
			txtType, txtCustomer, chkConsolidatePOS, hidReportName,txtAreaCode,txtOperationType) {
		var shiftCode='1';
		if(gEnableShiftYN=='Y')
		{
			shiftCode=document.getElementById("txtShiftCode").value;
		}
		var searchurl = getContextPath()
				+ "/loadItemWiseSalesReport.html?POSName=" + POSName
				+ "&FromDate=" + FromDate + "&ToDate=" + ToDate + "&Operator="
				+ Operator + "&PayMode=" + PayMode + "&txtFromBillNo="
				+ txtFromBillNo + "&txtToBillNo=" + txtToBillNo
				+ "&txtReportType=" + txtReportType + "&txtType=" + txtType
				+ "&txtCustomer=" + txtCustomer + "&chkConsolidatePOS="
				+ chkConsolidatePOS + "&hidReportName=" + hidReportName+"&areaCode="
				+ txtAreaCode + "&operationType=" + txtOperationType+ "&gEnableShiftYN=" + gEnableShiftYN+ "&shiftCode=" + shiftCode;;
		$
				.ajax({
					type : "POST",
					url : searchurl,
					dataType : "json",

					success : function(response) {
						funRemoveProductRows("tblItemWise");
						funRemoveProductRows("tblItemWiseTotal");
						$.each(response,function(i, item) {
											$("#wait").css("display", "none");
											if (i == 0) {
												var table = document
														.getElementById("tblItemWiseTotal");
												var rowCount = table.rows.length;
												var row = table
														.insertRow(rowCount);
												row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"80%\"  style=\"text-align:left;font-size: 17px;font-weight: bold;\" id=\"Totfield1."
														+ (rowCount)
														+ "\" value=\"Total\" />";
												row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right; font-size: 15px;\" size=\"49%\" id=\"Totfield2."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalQuantity
														+ "'/>";
												row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right; font-size: 15px;\" size=\"36%\" id=\"Totfield3."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalAmount
														+ "'/>";
												row.insertCell(3).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right; font-size: 15px;\" size=\"28%\" id=\"Totfield4."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalDiscAmt
														+ "'/>";
												row.insertCell(4).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right; font-size: 15px;\" size=\"13%\" id=\"Totfield5."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalSubTotal
														+ "'/>";
											}

											var table = document
													.getElementById("tblItemWise");
											var rowCount = table.rows.length;
											var row = table.insertRow(rowCount);
											i = i + 1;
											row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"75%\" id=\"field1."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField1
													+ "'/>";
											row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:left;\"  size=\"7%\" id=\"field2."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField2
													+ "'/>";
											row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right;\" size=\"32%\" id=\"field3."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField3
													+ "'/>";
											row.insertCell(3).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right;\" size=\"30%\" id=\"field4."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField6
													+ "'/>";
											row.insertCell(4).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right;\" size=\"23%\" id=\"field5."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField5
													+ "'/>";
											row.insertCell(5).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right;\" size=\"14%\" id=\"field6."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField4
													+ "'/>";

										});

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
	}

	/*fill Menu Head wise data */
	function funLoadMenuHeadWiseSalesReport(divID, POSName, FromDate, ToDate,
			Operator, PayMode, txtFromBillNo, txtToBillNo, txtReportType,
			txtType, txtCustomer, chkConsolidatePOS, hidReportName,txtAreaCode,txtOperationType) {
		var shiftCode='1';
		if(gEnableShiftYN=='Y')
		{
			shiftCode=document.getElementById("txtShiftCode").value;
		}
		var searchurl = getContextPath()
				+ "/loadMenuHeadWiseSalesReport.html?POSName=" + POSName
				+ "&FromDate=" + FromDate + "&ToDate=" + ToDate + "&Operator="
				+ Operator + "&PayMode=" + PayMode + "&txtFromBillNo="
				+ txtFromBillNo + "&txtToBillNo=" + txtToBillNo
				+ "&txtReportType=" + txtReportType + "&txtType=" + txtType
				+ "&txtCustomer=" + txtCustomer + "&chkConsolidatePOS="
				+ chkConsolidatePOS + "&hidReportName=" + hidReportName +"&areaCode="
				+ txtAreaCode + "&operationType=" + txtOperationType+ "&gEnableShiftYN=" + gEnableShiftYN+ "&shiftCode=" + shiftCode;
		$
				.ajax({
					type : "POST",
					url : searchurl,
					dataType : "json",

					success : function(response) {
						funRemoveProductRows("tblMenuHeadWise");
						funRemoveProductRows("tblMenuHeadWiseTotal");
						$
								.each(
										response,
										function(i, item) {
											$("#wait").css("display", "none");
											if (i == 0) {
												var table = document
														.getElementById("tblMenuHeadWiseTotal");
												var rowCount = table.rows.length;
												var row = table
														.insertRow(rowCount);
												row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"35%\"  style=\"text-align:left;font-size: 17px;font-weight: bold;\" id=\"Totfield1."
														+ (rowCount)
														+ "\" value=\"Total\" />";
												row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right;font-size: 15px\" size=\"17%\" id=\"Totfield2."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalQuantity
														+ "'/>";
												row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right;font-size: 15px\" size=\"14%\" id=\"Totfield3."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalAmount
														+ "'/>";
												row.insertCell(3).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right;font-size: 15px\" size=\"11%\" id=\"Totfield4."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalSubTotal
														+ "'/>";
												row.insertCell(4).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right;font-size: 15px\" size=\"9%\" id=\"Totfield5."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalDiscAmt
														+ "'/>";
											}

											var table = document
													.getElementById("tblMenuHeadWise");
											var rowCount = table.rows.length;
											var row = table.insertRow(rowCount);
											i = i + 1;
											row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"17%\" id=\"field1."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField1
													+ "'/>";
											row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:left;\" size=\"12%\" id=\"field2."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField2
													+ "'/>";
											row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right;\" size=\"19%\" id=\"field3."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField3
													+ "'/>";
											row.insertCell(3).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right;\" size=\"11%\" id=\"field4."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField4
													+ "'/>";
											row.insertCell(4).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right;\" size=\"18%\" id=\"field5."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField5
													+ "'/>";
											row.insertCell(5).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right;\" size=\"19.5%\" id=\"field6."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField6
													+ "'/>";
											row.insertCell(6).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right;\" width=\"22%\" size=\"10%\" id=\"field7."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField7
													+ "'/>";
										});

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
	}

	/*fill Group wise data */
	function funLoadGroupWiseSalesReport(divID, POSName, FromDate, ToDate,
			Operator, PayMode, txtFromBillNo, txtToBillNo, txtReportType,
			txtType, txtCustomer, chkConsolidatePOS, hidReportName,txtAreaCode,txtOperationType) {
		var shiftCode='1';
		if(gEnableShiftYN=='Y')
		{
			shiftCode=document.getElementById("txtShiftCode").value;
		}
		var searchurl = getContextPath()
				+ "/loadGroupWiseSalesReport.html?POSName=" + POSName
				+ "&FromDate=" + FromDate + "&ToDate=" + ToDate + "&Operator="
				+ Operator + "&PayMode=" + PayMode + "&txtFromBillNo="
				+ txtFromBillNo + "&txtToBillNo=" + txtToBillNo
				+ "&txtReportType=" + txtReportType + "&txtType=" + txtType
				+ "&txtCustomer=" + txtCustomer + "&chkConsolidatePOS="
				+ chkConsolidatePOS + "&hidReportName=" + hidReportName+ "&areaCode="
				+ txtAreaCode + "&operationType=" + txtOperationType+ "&gEnableShiftYN=" + gEnableShiftYN+ "&shiftCode=" + shiftCode;
		$
				.ajax({
					type : "POST",
					url : searchurl,
					dataType : "json",

					success : function(response) {
						funRemoveProductRows("tblGroupWise");
						funRemoveProductRows("tblGroupWiseTotal");
						$
								.each(
										response,
										function(i, item) {
											$("#wait").css("display", "none");
											if (i == 0) {
												var table = document
														.getElementById("tblGroupWiseTotal");
												var rowCount = table.rows.length;
												var row = table
														.insertRow(rowCount);
												row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"40%\" style=\"text-align:left;font-size: 17px;font-weight: bold;\" id=\"Totfield1."
														+ (rowCount)
														+ "\" value=\"Total\" />";
												row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"16%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield2."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalQuantity
														+ "'/>";
												row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"21%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield3."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalAmount
														+ "'/>";
												row.insertCell(3).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"14%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield4."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalSubTotal
														+ "'/>";
												row.insertCell(4).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"8%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield5."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalDiscAmt
														+ "'/>";
											}

											var table = document
													.getElementById("tblGroupWise");
											var rowCount = table.rows.length;
											var row = table.insertRow(rowCount);
											i = i + 1;
											row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"27.5%\" id=\"field1."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField1
													+ "'/>";
											row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"15%\" style=\"text-align:left;\" id=\"field2."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField2
													+ "'/>";
											row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"25.5%\" style=\"text-align:right;\" id=\"field3."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField3
													+ "'/>";
											row.insertCell(3).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"44%\" style=\"text-align:right;\" id=\"field4."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField4
													+ "'/>";
											row.insertCell(4).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"32%\" style=\"text-align:right;\" id=\"field5."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField5
													+ "'/>";
											row.insertCell(5).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"29%\" style=\"text-align:right;\" id=\"field6."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField6
													+ "'/>";
											row.insertCell(6).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"20%\" style=\"text-align:right;\" id=\"field7."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField7
													+ "'/>";
										});

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
	}

	/*fill Sub Group wise data */
	function funLoadSubGroupWiseSalesReport(divID, POSName, FromDate, ToDate,
			Operator, PayMode, txtFromBillNo, txtToBillNo, txtReportType,
			txtType, txtCustomer, chkConsolidatePOS, hidReportName,txtAreaCode,txtOperationType) {
		var shiftCode='1';
		if(gEnableShiftYN=='Y')
		{
			shiftCode=document.getElementById("txtShiftCode").value;
		}
		var searchurl = getContextPath()
				+ "/loadSubGroupWiseSalesReport.html?POSName=" + POSName
				+ "&FromDate=" + FromDate + "&ToDate=" + ToDate + "&Operator="
				+ Operator + "&PayMode=" + PayMode + "&txtFromBillNo="
				+ txtFromBillNo + "&txtToBillNo=" + txtToBillNo
				+ "&txtReportType=" + txtReportType + "&txtType=" + txtType
				+ "&txtCustomer=" + txtCustomer + "&chkConsolidatePOS="
				+ chkConsolidatePOS + "&hidReportName=" + hidReportName+ "&areaCode="
				+ txtAreaCode + "&operationType=" + txtOperationType+ "&gEnableShiftYN=" + gEnableShiftYN+ "&shiftCode=" + shiftCode;
		$
				.ajax({
					type : "POST",
					url : searchurl,
					dataType : "json",

					success : function(response) {
						funRemoveProductRows("tblSubGroupWise");
						funRemoveProductRows("tblSubGroupWiseTotal");
						$
								.each(
										response,
										function(i, item) {
											$("#wait").css("display", "none");
											if (i == 0) {
												var table = document
														.getElementById("tblSubGroupWiseTotal");
												var rowCount = table.rows.length;
												var row = table
														.insertRow(rowCount);
												row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"65%\" style=\"text-align:left;font-size: 17px;font-weight: bold;\" id=\"Totfield1."
														+ (rowCount)
														+ "\" value=\"Total\" />";
												row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right;font-size: 15px;\" size=\"32%\" id=\"Totfield2."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalQuantity
														+ "'/>";
												row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right;font-size: 15px;\" size=\"30%\" id=\"Totfield3."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalAmount
														+ "'/>";
												row.insertCell(3).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right;font-size: 15px;\" size=\"22%\" id=\"Totfield4."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalSubTotal
														+ "'/>";
												row.insertCell(4).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right;font-size: 15px;\" size=\"9%\" id=\"Totfield5."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalDiscAmt
														+ "'/>";
											}

											var table = document
													.getElementById("tblSubGroupWise");
											var rowCount = table.rows.length;
											var row = table.insertRow(rowCount);
											i = i + 1;
											row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"43%\" id=\"field1."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField1
													+ "'/>";
											row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"26%\" id=\"field2."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField2
													+ "'/>";
											row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right;\" size=\"21%\" id=\"field3."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField3
													+ "'/>";
											row.insertCell(3).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right;\" size=\"25%\" id=\"field4."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField4
													+ "'/>";
											row.insertCell(4).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right;\" size=\"25%\" id=\"field5."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField5
													+ "'/>";
											row.insertCell(5).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right;\" size=\"23%\" id=\"field6."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField6
													+ "'/>";
											row.insertCell(6).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right;\" size=\"18%\" id=\"field7."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField7
													+ "'/>";
										});

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
	}

	/*fill Cust wise data */
	function funLoadCustWiseSalesReport(divID, POSName, FromDate, ToDate,
			Operator, PayMode, txtFromBillNo, txtToBillNo, txtReportType,
			txtType, txtCustomer, chkConsolidatePOS, hidReportName,txtAreaCode,txtOperationType) {
		var shiftCode='1';
		if(gEnableShiftYN=='Y')
		{
			shiftCode=document.getElementById("txtShiftCode").value;
		}
		var searchurl = getContextPath()
				+ "/loadCustWiseSalesReport.html?POSName=" + POSName
				+ "&FromDate=" + FromDate + "&ToDate=" + ToDate + "&Operator="
				+ Operator + "&PayMode=" + PayMode + "&txtFromBillNo="
				+ txtFromBillNo + "&txtToBillNo=" + txtToBillNo
				+ "&txtReportType=" + txtReportType + "&txtType=" + txtType
				+ "&txtCustomer=" + txtCustomer + "&chkConsolidatePOS="
				+ chkConsolidatePOS + "&hidReportName=" + hidReportName+ "&areaCode="
				+ txtAreaCode + "&operationType=" + txtOperationType+ "&gEnableShiftYN=" + gEnableShiftYN+ "&shiftCode=" + shiftCode;
		$
				.ajax({
					type : "POST",
					url : searchurl,
					dataType : "json",

					success : function(response) {
						funRemoveProductRows("tblCustWise");
						funRemoveProductRows("tblCustWiseTotal");
						$
								.each(
										response,
										function(i, item) {
											$("#wait").css("display", "none");
											if (i == 0) {
												var table = document
														.getElementById("tblCustWiseTotal");
												var rowCount = table.rows.length;
												var row = table
														.insertRow(rowCount);
												row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"6%\"  style=\"text-align:left;font-size: 17px;font-weight: bold;\" id=\"Totfield1."
														+ (rowCount)
														+ "\" value=\"Total\" />";
												row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"62%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield2."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalQuantity
														+ "'/>";
												row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"53%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield3."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalAmount
														+ "'/>";
											}

											var table = document
													.getElementById("tblCustWise");
											var rowCount = table.rows.length;
											var row = table.insertRow(rowCount);
											i = i + 1;
											row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"30%\" id=\"field1."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField1
													+ "'/>";
													
											row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" style=\"text-align:right;\" id=\"field2."
													+ (rowCount)
													+ "\" value='"
													+ response[i].mobileNo
													+ "'/>";		
												
											row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"7%\" style=\"text-align:right;\" id=\"field2."
													+ (rowCount)
													+ "\" value='"
													+ response[i].dob
													+ "'/>";
													
											row.insertCell(3).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" style=\"text-align:right;\" id=\"field2."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField2
													+ "'/>";
											row.insertCell(4).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"35%\" style=\"text-align:right;\" id=\"field3."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField3
													+ "'/>";
											/* row.insertCell(3).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"45%\" id=\"field4."+(rowCount)+"\" value='"+response[i].strField4+"'/>";
											row.insertCell(4).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"45%\" id=\"field5."+(rowCount)+"\" value='"+response[i].strField5+"'/>";
											row.insertCell(5).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"45%\" id=\"field6."+(rowCount)+"\" value='"+response[i].strField6+"'/>";
											row.insertCell(6).innerHTML= "<input readonly=\"readonly\" class=\"Box\" size=\"45%\" id=\"field7."+(rowCount)+"\" value='"+response[i].strField7+"'/>"; */
										});
						console.log(response);

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
	}

	/*fill Waiter wise data */
	function funLoadWaiterWiseSalesReport(divID, POSName, FromDate, ToDate,
			Operator, PayMode, txtFromBillNo, txtToBillNo, txtReportType,
			txtType, txtCustomer, chkConsolidatePOS, hidReportName,txtAreaCode,txtOperationType) {
		var shiftCode='1';
		if(gEnableShiftYN=='Y')
		{
			shiftCode=document.getElementById("txtShiftCode").value;
		}
		var searchurl = getContextPath()
				+ "/loadWaiterWiseSalesReport.html?POSName=" + POSName
				+ "&FromDate=" + FromDate + "&ToDate=" + ToDate + "&Operator="
				+ Operator + "&PayMode=" + PayMode + "&txtFromBillNo="
				+ txtFromBillNo + "&txtToBillNo=" + txtToBillNo
				+ "&txtReportType=" + txtReportType + "&txtType=" + txtType
				+ "&txtCustomer=" + txtCustomer + "&chkConsolidatePOS="
				+ chkConsolidatePOS + "&hidReportName=" + hidReportName+ "&areaCode="
				+ txtAreaCode + "&operationType=" + txtOperationType+ "&gEnableShiftYN=" + gEnableShiftYN+ "&shiftCode=" + shiftCode;
		$
				.ajax({
					type : "POST",
					url : searchurl,
					dataType : "json",

					success : function(response) {
						funRemoveProductRows("tblWaiterWise");
						funRemoveProductRows("tblWaiterWiseTotal");
						$
								.each(
										response,
										function(i, item) {
											$("#wait").css("display", "none");
											if (i == 0) {
												var table = document
														.getElementById("tblWaiterWiseTotal");
												var rowCount = table.rows.length;
												var row = table
														.insertRow(rowCount);
												row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"130%\"  style=\"text-align:left;font-size: 17px;font-weight: bold;\" id=\"Totfield1."
														+ (rowCount)
														+ "\" value=\"Total\" />";
												row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"23%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield2."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalSubTotal
														+ "'/>";

											}

											console.log(response);
											var table = document
													.getElementById("tblWaiterWise");
											var rowCount = table.rows.length;
											var row = table.insertRow(rowCount);
											i = i + 1;
											row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"50%\" id=\"field1."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField1
													+ "'/>";
											row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"40%\" id=\"field2."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField3
													+ "'/>";
											row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"20%\"  style=\"text-align:left;\" id=\"field3."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField2
													+ "'/>";
											row.insertCell(3).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"32%\" style=\"text-align:right;\" id=\"field4."
													+ (rowCount)
													+ "\" value='"
													+ response[i].noOfBills
													+ "'/>";
											row.insertCell(4).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"32%\" style=\"text-align:right;\" id=\"field4."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField4
													+ "'/>";

										});

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
	}

	/*fill DeliveryBoy wise data */
	function funLoadDeliveryBoyWiseSalesReport(divID, POSName, FromDate,
			ToDate, Operator, PayMode, txtFromBillNo, txtToBillNo,
			txtReportType, txtType, txtCustomer, chkConsolidatePOS,
			hidReportName,txtAreaCode,txtOperationType) {
		var shiftCode='1';
		if(gEnableShiftYN=='Y')
		{
			shiftCode=document.getElementById("txtShiftCode").value;
		}
		var searchurl = getContextPath()
				+ "/loadDeliveryBoyWiseSalesReport.html?POSName=" + POSName
				+ "&FromDate=" + FromDate + "&ToDate=" + ToDate + "&Operator="
				+ Operator + "&PayMode=" + PayMode + "&txtFromBillNo="
				+ txtFromBillNo + "&txtToBillNo=" + txtToBillNo
				+ "&txtReportType=" + txtReportType + "&txtType=" + txtType
				+ "&txtCustomer=" + txtCustomer + "&chkConsolidatePOS="
				+ chkConsolidatePOS + "&hidReportName=" + hidReportName+ "&areaCode="
				+ txtAreaCode + "&operationType=" + txtOperationType+ "&gEnableShiftYN=" + gEnableShiftYN+ "&shiftCode=" + shiftCode;
		$
				.ajax({
					type : "POST",
					url : searchurl,
					dataType : "json",

					success : function(response) {
						funRemoveProductRows("tblDeliveryBoyWise");
						funRemoveProductRows("tblDeliveryBoyWiseTotal");
						$
								.each(
										response,
										function(i, item) {
											$("#wait").css("display", "none");
											if (i == 0) {
												var table = document
														.getElementById("tblDeliveryBoyWiseTotal");
												var rowCount = table.rows.length;
												var row = table
														.insertRow(rowCount);
												row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"98%\" style=\"text-align:left;font-size: 17px;font-weight: bold;\" id=\"Totfield1."
														+ (rowCount)
														+ "\" value=\"Total\" />";
												row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"42%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield2."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalSubTotal
														+ "'/>";

											}

											var table = document
													.getElementById("tblDeliveryBoyWise");
											var rowCount = table.rows.length;
											var row = table.insertRow(rowCount);
											i = i + 1;
											row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"45%\" id=\"field1."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField1
													+ "'/>";
											row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"45%\" id=\"field2."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField2
													+ "'/>";
											row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"45%\" style=\"text-align:right;\" id=\"field3."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField3
													+ "'/>";
											row.insertCell(3).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"45%\" style=\"text-align:right;\" id=\"field4."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField4
													+ "'/>";

										});

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
	}

	/*fill Cost Center  wise data */
	function funLoadCostCenterWiseSalesReport(divID, POSName, FromDate, ToDate,
			Operator, PayMode, txtFromBillNo, txtToBillNo, txtReportType,
			txtType, txtCustomer, chkConsolidatePOS, hidReportName,txtAreaCode,txtOperationType) {
		var shiftCode='1';
		if(gEnableShiftYN=='Y')
		{
			shiftCode=document.getElementById("txtShiftCode").value;
		}
		var searchurl = getContextPath()
				+ "/loadCostCenterWiseSalesReport.html?POSName=" + POSName
				+ "&FromDate=" + FromDate + "&ToDate=" + ToDate + "&Operator="
				+ Operator + "&PayMode=" + PayMode + "&txtFromBillNo="
				+ txtFromBillNo + "&txtToBillNo=" + txtToBillNo
				+ "&txtReportType=" + txtReportType + "&txtType=" + txtType
				+ "&txtCustomer=" + txtCustomer + "&chkConsolidatePOS="
				+ chkConsolidatePOS + "&hidReportName=" + hidReportName+ "&areaCode="
				+ txtAreaCode + "&operationType=" + txtOperationType+ "&gEnableShiftYN=" + gEnableShiftYN+ "&shiftCode=" + shiftCode;
		$
				.ajax({
					type : "POST",
					url : searchurl,
					dataType : "json",

					success : function(response) {
						funRemoveProductRows("tblCostCenterWise");
						funRemoveProductRows("tblCostCenterWiseTotal");
						$
								.each(
										response,
										function(i, item) {
											$("#wait").css("display", "none");
											if (i == 0) {
												var table = document
														.getElementById("tblCostCenterWiseTotal");
												var rowCount = table.rows.length;
												var row = table
														.insertRow(rowCount);
												row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"25%\"  style=\"text-align:left;font-size: 17px;font-weight: bold;\" id=\"Totfield1."
														+ (rowCount)
														+ "\" value=\"Total\" />";
												row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"23%\" style=\"text-align:right;font-size: 15px;\"  id=\"Totfield2."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalQuantity
														+ "'/>";
												row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"28%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield3."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalAmount
														+ "'/>";
												row.insertCell(3).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"25%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield4."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalSubTotal
														+ "'/>";
												row.insertCell(4).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"23%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield5."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalDiscAmt
														+ "'/>";
											}

											var table = document
													.getElementById("tblCostCenterWise");
											var rowCount = table.rows.length;
											var row = table.insertRow(rowCount);
											i = i + 1;
											row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"37%\" id=\"field1."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField1
													+ "'/>";
											row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"20%\" style=\"text-align:left;\" id=\"field2."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField2
													+ "'/>";
											row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"19%\" style=\"text-align:right;\" id=\"field3."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField3
													+ "'/>";
											row.insertCell(3).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"35%\" style=\"text-align:right;\" id=\"field4."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField4
													+ "'/>";
											row.insertCell(4).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"35%\" style=\"text-align:right;\" id=\"field5."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField5
													+ "'/>";
											row.insertCell(5).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"34%\" style=\"text-align:right;\" id=\"field6."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField6
													+ "'/>";
											row.insertCell(6).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"26%\" style=\"text-align:right;\" id=\"field7."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField7
													+ "'/>";
										});

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
	}

	/*fill Home delivery  wise data */
	function funLoadHomeDeliveryWiseSalesReport(divID, POSName, FromDate,
			ToDate, Operator, PayMode, txtFromBillNo, txtToBillNo,
			txtReportType, txtType, txtCustomer, chkConsolidatePOS,
			hidReportName,txtAreaCode,txtOperationType) 
	{
		var shiftCode='1';
		if(gEnableShiftYN=='Y')
		{
			shiftCode=document.getElementById("txtShiftCode").value;
		}
		var searchurl = getContextPath()
				+ "/loadHomeDelWiseSalesReport.html?POSName=" + POSName
				+ "&FromDate=" + FromDate + "&ToDate=" + ToDate + "&Operator="
				+ Operator + "&PayMode=" + PayMode + "&txtFromBillNo="
				+ txtFromBillNo + "&txtToBillNo=" + txtToBillNo
				+ "&txtReportType=" + txtReportType + "&txtType=" + txtType
				+ "&txtCustomer=" + txtCustomer + "&chkConsolidatePOS="
				+ chkConsolidatePOS + "&hidReportName=" + hidReportName+ "&areaCode="
				+ txtAreaCode + "&operationType=" + txtOperationType+ "&gEnableShiftYN=" + gEnableShiftYN+ "&shiftCode=" + shiftCode;
		$
				.ajax({
					type : "POST",
					url : searchurl,
					dataType : "json",

					success : function(response) {
						funRemoveProductRows("tblHomeDeliveryWise");
						funRemoveProductRows("tblHomeDeliveryWiseTotal");
						$
								.each(
										response,
										function(i, item) {
											$("#wait").css("display", "none");
											if (i == 0) {
												var table = document
														.getElementById("tblHomeDeliveryWiseTotal");
												var rowCount = table.rows.length;
												var row = table
														.insertRow(rowCount);
												row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"60%\" style=\"text-align:right;font-size: 17px;font-weight: bold;\" id=\"Totfield1."
														+ (rowCount)
														+ "\" value=\"Total\" />";
												row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"30%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield2."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalDiscAmt
														+ "'/>";
												row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"20%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield3."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalSubTotal
														+ "'/>";
												row.insertCell(3).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" style=\"text-align:left;font-size: 15px;\" id=\"Totfield4."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalAmount
														+ "'/>";
											}

											var table = document
													.getElementById("tblHomeDeliveryWise");
											var rowCount = table.rows.length;
											var row = table.insertRow(rowCount);
											i = i + 1;
											row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"17%\" id=\"field1."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField1
													+ "'/>";
											row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"14%\" id=\"field2."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField2
													+ "'/>";
											row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"14%\" style=\"text-align:left;\" id=\"field3."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField3
													+ "'/>";
											row.insertCell(3).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"34%\" id=\"field4."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField4
													+ "'/>";
											row.insertCell(4).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"11%\" style=\"text-align:left;\" id=\"field5."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField5
													+ "'/>";
											row.insertCell(5).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"13%\" style=\"text-align:left;\" id=\"field6."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField6
													+ "'/>";
											row.insertCell(6).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"13%\" style=\"text-align:left;\" id=\"field7."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField7
													+ "'/>";
											row.insertCell(7).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"13%\" style=\"text-align:left;\" id=\"field8."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField8
													+ "'/>";
											row.insertCell(8).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" style=\"text-align:left;\" id=\"field9."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField9
													+ "'/>";
											row.insertCell(9).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"20%\" style=\"text-align:left;\" id=\"field10."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField10
													+ "'/>";
											row.insertCell(10).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"20%\" style=\"text-align:left;\" id=\"field11."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField11
													+ "'/>";

										});

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
	}

	/*fill Table  wise data */
	function funLoadTableWiseSalesReport(divID, POSName, FromDate, ToDate,
			Operator, PayMode, txtFromBillNo, txtToBillNo, txtReportType,
			txtType, txtCustomer, chkConsolidatePOS, hidReportName,txtAreaCode,txtOperationType) {
		var shiftCode='1';
		if(gEnableShiftYN=='Y')
		{
			shiftCode=document.getElementById("txtShiftCode").value;
		}
		var searchurl = getContextPath()
				+ "/loadTableWiseSalesReport.html?POSName=" + POSName
				+ "&FromDate=" + FromDate + "&ToDate=" + ToDate + "&Operator="
				+ Operator + "&PayMode=" + PayMode + "&txtFromBillNo="
				+ txtFromBillNo + "&txtToBillNo=" + txtToBillNo
				+ "&txtReportType=" + txtReportType + "&txtType=" + txtType
				+ "&txtCustomer=" + txtCustomer + "&chkConsolidatePOS="
				+ chkConsolidatePOS + "&hidReportName=" + hidReportName+ "&areaCode="
				+ txtAreaCode + "&operationType=" + txtOperationType+ "&gEnableShiftYN=" + gEnableShiftYN+ "&shiftCode=" + shiftCode;
		$
				.ajax({
					type : "POST",
					url : searchurl,
					dataType : "json",

					success : function(response) {
						funRemoveProductRows("tblTableWise");
						funRemoveProductRows("tblTableWiseTotal");
						$
								.each(
										response,
										function(i, item) {
											$("#wait").css("display", "none");
											if (i == 0) {
												var table = document
														.getElementById("tblTableWiseTotal");
												var rowCount = table.rows.length;
												var row = table
														.insertRow(rowCount);
												row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"80%\" style=\"text-align:right;font-size: 17px;font-weight: bold;\" id=\"Totfield1."
														+ (rowCount)
														+ "\" value=\"Total\" />";
												row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"50%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield2."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalAmount
														+ "'/>";
											}

											var table = document
													.getElementById("tblTableWise");
											var rowCount = table.rows.length;
											var row = table.insertRow(rowCount);
											i = i + 1;
											row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"53%\" id=\"field1."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField1
													+ "'/>";
											row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"30%\" style=\"text-align:right;\" id=\"field2."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField2
													+ "'/>";
											row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"61%\" style=\"text-align:right;\" id=\"field3."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField3
													+ "'/>";

										});

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
	}

	/*fill Hourly wise data */
	function funLoadHourlyWiseSalesReport(divID, POSName, FromDate, ToDate,
			Operator, PayMode, txtFromBillNo, txtToBillNo, txtReportType,
			txtType, txtCustomer, chkConsolidatePOS, hidReportName,txtAreaCode,txtOperationType) {
		var shiftCode='1';
		if(gEnableShiftYN=='Y')
		{
			shiftCode=document.getElementById("txtShiftCode").value;
		}
		var searchurl = getContextPath()
				+ "/loadHourlyWiseSalesReport.html?POSName=" + POSName
				+ "&FromDate=" + FromDate + "&ToDate=" + ToDate + "&Operator="
				+ Operator + "&PayMode=" + PayMode + "&txtFromBillNo="
				+ txtFromBillNo + "&txtToBillNo=" + txtToBillNo
				+ "&txtReportType=" + txtReportType + "&txtType=" + txtType
				+ "&txtCustomer=" + txtCustomer + "&chkConsolidatePOS="
				+ chkConsolidatePOS + "&hidReportName=" + hidReportName+ "&areaCode="
				+ txtAreaCode + "&operationType=" + txtOperationType+ "&gEnableShiftYN=" + gEnableShiftYN+ "&shiftCode=" + shiftCode;
		$
				.ajax({
					type : "POST",
					url : searchurl,
					dataType : "json",

					success : function(response) {
						funRemoveProductRows("tblHourlyWise");
						funRemoveProductRows("tblHourlyWiseTotal");
						$
								.each(
										response,
										function(i, item) {
											$("#wait").css("display", "none");
											if (i == 0) {
												var table = document
														.getElementById("tblHourlyWiseTotal");
												var rowCount = table.rows.length;
												var row = table
														.insertRow(rowCount);
												row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"100%\" style=\"text-align:left;font-size: 17px;font-weight: bold;\" id=\"Totfield1."
														+ (rowCount)
														+ "\" value=\"Total\" />";													
												row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"8%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield2."
														+ (rowCount)
														+ "\" value='"
														+ response[i].noOfBills
														+ "'/>";															
												row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"9%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield2."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalPAX
														+ "'/>";
												row.insertCell(3).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"9%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield2."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalAmount
														+ "'/>";
											}

											var table = document
													.getElementById("tblHourlyWise");
											var rowCount = table.rows.length;
											var row = table.insertRow(rowCount);
											i = i + 1;
											row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"50%\" id=\"field1."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField1
													+ "'/>";
											row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"20%\" style=\"text-align:right;\" id=\"field2."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField2
													+ "'/>";
											row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"13%\" style=\"text-align:right;\" id=\"field3."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField5
													+ "'/>";
											row.insertCell(3).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"32%\" style=\"text-align:right;\" id=\"field4."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField3
													+ "'/>";
											row.insertCell(4).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"42%\" style=\"text-align:right;\" id=\"field4."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField4
													+ "'/>";

										});

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
	}

	/*fill Area wise data */
	function funLoadAreaWiseSalesReport(divID, POSName, FromDate, ToDate,
			Operator, PayMode, txtFromBillNo, txtToBillNo, txtReportType,
			txtType, txtCustomer, chkConsolidatePOS, hidReportName,txtAreaCode,txtOperationType) {
		var shiftCode='1';
		if(gEnableShiftYN=='Y')
		{
			shiftCode=document.getElementById("txtShiftCode").value;
		}
		var searchurl = getContextPath()
				+ "/loadAreaWiseSalesReport.html?POSName=" + POSName
				+ "&FromDate=" + FromDate + "&ToDate=" + ToDate + "&Operator="
				+ Operator + "&PayMode=" + PayMode + "&txtFromBillNo="
				+ txtFromBillNo + "&txtToBillNo=" + txtToBillNo
				+ "&txtReportType=" + txtReportType + "&txtType=" + txtType
				+ "&txtCustomer=" + txtCustomer + "&chkConsolidatePOS="
				+ chkConsolidatePOS + "&hidReportName=" + hidReportName+ "&areaCode="
				+ txtAreaCode + "&operationType=" + txtOperationType+ "&gEnableShiftYN=" + gEnableShiftYN+ "&shiftCode=" + shiftCode;
		$
				.ajax({
					type : "POST",
					url : searchurl,
					dataType : "json",

					success : function(response) {
						funRemoveProductRows("tblAreaWise");
						funRemoveProductRows("tblAreaWiseTotal");
						$
								.each(
										response,
										function(i, item) {
											$("#wait").css("display", "none");
											if (i == 0) {
												var table = document
														.getElementById("tblAreaWiseTotal");
												var rowCount = table.rows.length;
												var row = table
														.insertRow(rowCount);
												row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"90%\" style=\"text-align:right;font-size: 17px;font-weight: bold;\" id=\"Totfield1."
														+ (rowCount)
														+ "\" value=\"Total\" />";
												row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"43%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield2."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalAmount
														+ "'/>";
											}

											var table = document
													.getElementById("tblAreaWise");
											var rowCount = table.rows.length;
											var row = table.insertRow(rowCount);
											i = i + 1;
											row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"48%\" id=\"field1."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField1
													+ "'/>";
											row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"23%\"  style=\"text-align:left;\" id=\"field2."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField2
													+ "'/>";
											row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"52%\" style=\"text-align:right;\" id=\"field3."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField3
													+ "'/>";

										});

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
	}

	/*fill Day wise data */
	function funLoadDayWiseSalesReport(divID, POSName, FromDate, ToDate,
			Operator, PayMode, txtFromBillNo, txtToBillNo, txtReportType,
			txtType, txtCustomer, chkConsolidatePOS, hidReportName,txtAreaCode,txtOperationType) {
		var shiftCode='1';
		if(gEnableShiftYN=='Y')
		{
			shiftCode=document.getElementById("txtShiftCode").value;
		}
		var searchurl = getContextPath()
				+ "/loadDayWiseSalesReport.html?POSName=" + POSName
				+ "&FromDate=" + FromDate + "&ToDate=" + ToDate + "&Operator="
				+ Operator + "&PayMode=" + PayMode + "&txtFromBillNo="
				+ txtFromBillNo + "&txtToBillNo=" + txtToBillNo
				+ "&txtReportType=" + txtReportType + "&txtType=" + txtType
				+ "&txtCustomer=" + txtCustomer + "&chkConsolidatePOS="
				+ chkConsolidatePOS + "&hidReportName=" + hidReportName+ "&areaCode="
				+ txtAreaCode + "&operationType=" + txtOperationType+ "&gEnableShiftYN=" + gEnableShiftYN+ "&shiftCode=" + shiftCode;
		$
				.ajax({
					type : "POST",
					url : searchurl,
					dataType : "json",

					success : function(response) {
						funRemoveProductRows("tblDayWiseSales");
						funRemoveProductRows("tblDayWiseSalesTotal");
						$
								.each(
										response,
										function(i, item) {
											$("#wait").css("display", "none");
											if (i == 0) {
												var table = document
														.getElementById("tblDayWiseSalesTotal");
												var rowCount = table.rows.length;
												var row = table
														.insertRow(rowCount);
												row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"15%\" style=\"text-align:left;font-size: 17px;font-weight: bold;\" id=\"Totfield1."
														+ (rowCount)
														+ "\" value=\"Total\" />";
												row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"15%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield2."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalQuantity
														+ "'/>";
												row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"23%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield3."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalSubTotal
														+ "'/>";
												row.insertCell(3).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"18%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield4."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalDiscAmt
														+ "'/>";
												row.insertCell(4).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"20%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield5."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalTaxAmt
														+ "'/>";
												row.insertCell(5).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"27%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield6."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalAmount
														+ "'/>";
											}

											var table = document
													.getElementById("tblDayWiseSales");
											var rowCount = table.rows.length;
											var row = table.insertRow(rowCount);
											i = i + 1;
											row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"29%\" id=\"field1."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField1
													+ "'/>";
											row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"20%\" style=\"text-align:right;\" id=\"field2."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField2
													+ "'/>";
											row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"32%\" style=\"text-align:right;\" id=\"field3."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField3
													+ "'/>";
											row.insertCell(3).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"37%\" style=\"text-align:right;\" id=\"field4."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField4
													+ "'/>";
											row.insertCell(4).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"40%\" style=\"text-align:right;\" id=\"field5."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField5
													+ "'/>";
											row.insertCell(5).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"34%\" style=\"text-align:right;\" id=\"field6."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField6
													+ "'/>";

										});

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
	}

	/*fill Tax wise data */
	function funLoadTaxWiseSalesReport(divID, POSName, FromDate, ToDate,
			Operator, PayMode, txtFromBillNo, txtToBillNo, txtReportType,
			txtType, txtCustomer, chkConsolidatePOS, hidReportName,txtAreaCode,txtOperationType) {
		var shiftCode='1';
		if(gEnableShiftYN=='Y')
		{
			shiftCode=document.getElementById("txtShiftCode").value;
		}
		var searchurl = getContextPath()
				+ "/loadTaxWiseSalesReport.html?POSName=" + POSName
				+ "&FromDate=" + FromDate + "&ToDate=" + ToDate + "&Operator="
				+ Operator + "&PayMode=" + PayMode + "&txtFromBillNo="
				+ txtFromBillNo + "&txtToBillNo=" + txtToBillNo
				+ "&txtReportType=" + txtReportType + "&txtType=" + txtType
				+ "&txtCustomer=" + txtCustomer + "&chkConsolidatePOS="
				+ chkConsolidatePOS + "&hidReportName=" + hidReportName+ "&areaCode="
				+ txtAreaCode + "&operationType=" + txtOperationType+ "&gEnableShiftYN=" + gEnableShiftYN+ "&shiftCode=" + shiftCode;
		$
				.ajax({
					type : "POST",
					url : searchurl,
					dataType : "json",

					success : function(response) {
						funRemoveProductRows("tblTaxWiseSales");
						funRemoveProductRows("tblTaxWiseSalesTotal");
						$
								.each(
										response,
										function(i, item) {
											$("#wait").css("display", "none");
											if (i == 0) {
												var table = document
														.getElementById("tblTaxWiseSalesTotal");
												var rowCount = table.rows.length;
												var row = table
														.insertRow(rowCount);
												row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"90%\" style=\"text-align:right;font-size: 17px;font-weight: bold;\"  id=\"Totfield1."
														+ (rowCount)
														+ "\" value=\"Total\" />";
												row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"24%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield2."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalTaxAmt
														+ "'/>";
												row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"21%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield3."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalSubTotal
														+ "'/>";
											}

											var table = document
													.getElementById("tblTaxWiseSales");
											var rowCount = table.rows.length;
											var row = table.insertRow(rowCount);
											i = i + 1;
											row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"17%\" id=\"field1."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField1
													+ "'/>";
											row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"14%\" style=\"text-align:center;\" id=\"field2."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField2
													+ "'/>";
											row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"8%\"  style=\"text-align:left;\ id=\"field3."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField3
													+ "'/>";
											row.insertCell(3).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"26%\"  style=\"text-align:left;\ id=\"field4."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField4
													+ "'/>";
											row.insertCell(4).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"17%\" style=\"text-align:right;\" id=\"field5."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField5
													+ "'/>";
											row.insertCell(5).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"25%\" style=\"text-align:right;\" id=\"field6."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField6
													+ "'/>";
											row.insertCell(6).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"31%\" style=\"text-align:right;\" id=\"field7."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField7
													+ "'/>";
										});

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
	}

	/*fill Tip Sale wise data  */
	function funLoadTipSalesReport(divID, POSName, FromDate, ToDate, Operator,
			PayMode, txtFromBillNo, txtToBillNo, txtReportType, txtType,
			txtCustomer, chkConsolidatePOS, hidReportName,txtAreaCode,txtOperationType) {
		var shiftCode='1';
		if(gEnableShiftYN=='Y')
		{
			shiftCode=document.getElementById("txtShiftCode").value;
		}
		var searchurl = getContextPath()
				+ "/loadTipWiseSalesReport.html?POSName=" + POSName
				+ "&FromDate=" + FromDate + "&ToDate=" + ToDate + "&Operator="
				+ Operator + "&PayMode=" + PayMode + "&txtFromBillNo="
				+ txtFromBillNo + "&txtToBillNo=" + txtToBillNo
				+ "&txtReportType=" + txtReportType + "&txtType=" + txtType
				+ "&txtCustomer=" + txtCustomer + "&chkConsolidatePOS="
				+ chkConsolidatePOS + "&hidReportName=" + hidReportName+ "&areaCode="
				+ txtAreaCode + "&operationType=" + txtOperationType+ "&gEnableShiftYN=" + gEnableShiftYN+ "&shiftCode=" + shiftCode;
		$
				.ajax({
					type : "POST",
					url : searchurl,
					dataType : "json",

					success : function(response) {
						funRemoveProductRows("tblTipReport");
						funRemoveProductRows("tblTipReportTotal");
						$
								.each(
										response,
										function(i, item) {
											$("#wait").css("display", "none");
											if (i == 0) {
												var table = document
														.getElementById("tblTipReportTotal");
												var rowCount = table.rows.length;
												var row = table
														.insertRow(rowCount);
												row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"70%\"  style=\"text-align:right;font-size: 17px;font-weight: bold;\" id=\"Totfield1."
														+ (rowCount)
														+ "\" value=\"Total\" />";
												row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"19%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield2."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalDiscAmt
														+ "'/>";
												row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"16%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield3."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalSubTotal
														+ "'/>";
												row.insertCell(3).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"17%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield4."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalTaxAmt
														+ "'/>";
												row.insertCell(4).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"17%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield5."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalTipAmt
														+ "'/>";
												row.insertCell(5).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"15%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield6."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalAmount
														+ "'/>";
											}

											var table = document
													.getElementById("tblTipReport");
											var rowCount = table.rows.length;
											var row = table.insertRow(rowCount);
											i = i + 1;
											row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"14%\" id=\"field1."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField1
													+ "'/>";
											row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"14%\" style=\"text-align:center;\" id=\"field2."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField2
													+ "'/>";
											row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"14%\"  style=\"text-align:center;\"id=\"field3."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField3
													+ "'/>";
											row.insertCell(3).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"14%\" id=\"field4."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField4
													+ "'/>";
											row.insertCell(4).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"14%\" id=\"field5."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField5
													+ "'/>";
											row.insertCell(5).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"14%\" style=\"text-align:right;\" id=\"field6."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField6
													+ "'/>";
											row.insertCell(6).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"14%\" style=\"text-align:right;\" id=\"field7."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField7
													+ "'/>";
											row.insertCell(7).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"14%\" style=\"text-align:right;\" id=\"field8."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField8
													+ "'/>";
											row.insertCell(8).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"14%\" style=\"text-align:right;\" id=\"field9."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField9
													+ "'/>";
											row.insertCell(9).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"14%\" style=\"text-align:right;\" id=\"field10."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField10
													+ "'/>";
											row.insertCell(10).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"14%\" style=\"text-align:right;\" id=\"field11."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField11
													+ "'/>";

										});

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
	}

	/*fill Item Modifier  wise data */
	function funLoadItemModifierWiseSalesReport(divID, POSName, FromDate,
			ToDate, Operator, PayMode, txtFromBillNo, txtToBillNo,
			txtReportType, txtType, txtCustomer, chkConsolidatePOS,
			hidReportName,txtAreaCode,txtOperationType) {
		var shiftCode='1';
		if(gEnableShiftYN=='Y')
		{
			shiftCode=document.getElementById("txtShiftCode").value;
		}
		var searchurl = getContextPath()
				+ "/loadItemModifierWiseSalesReport.html?POSName=" + POSName
				+ "&FromDate=" + FromDate + "&ToDate=" + ToDate + "&Operator="
				+ Operator + "&PayMode=" + PayMode + "&txtFromBillNo="
				+ txtFromBillNo + "&txtToBillNo=" + txtToBillNo
				+ "&txtReportType=" + txtReportType + "&txtType=" + txtType
				+ "&txtCustomer=" + txtCustomer + "&chkConsolidatePOS="
				+ chkConsolidatePOS + "&hidReportName=" + hidReportName+ "&areaCode="
				+ txtAreaCode + "&operationType=" + txtOperationType+ "&gEnableShiftYN=" + gEnableShiftYN+ "&shiftCode=" + shiftCode;
		$
				.ajax({
					type : "POST",
					url : searchurl,
					dataType : "json",

					success : function(response) {
						funRemoveProductRows("tblItemModifierWise");
						funRemoveProductRows("tblItemModifierWiseTotal");
						$
								.each(
										response,
										function(i, item) {
											$("#wait").css("display", "none");
											if (i == 0) {
												var table = document
														.getElementById("tblItemModifierWiseTotal");
												var rowCount = table.rows.length;
												var row = table
														.insertRow(rowCount);
												row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:right;font-size: 17px;font-weight: bold;\" size=\"80%\" id=\"Totfield1."
														+ (rowCount)
														+ "\" value=\"Total\" />";
												row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"35%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield2."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalQuantity
														+ "'/>";
												row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"41%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield3."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalAmount
														+ "'/>";

											}

											var table = document
													.getElementById("tblItemModifierWise");
											var rowCount = table.rows.length;
											var row = table.insertRow(rowCount);
											i = i + 1;
											row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"60%\" id=\"field1."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField1
													+ "'/>";
											row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"15%\" style=\"text-align:left;\" id=\"field2."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField2
													+ "'/>";
											row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"29%\" style=\"text-align:right;\" id=\"field3."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField3
													+ "'/>";
											row.insertCell(3).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"54%\" style=\"text-align:right;\" id=\"field4."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField4
													+ "'/>";

										});

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
	}

	/*fill MenuHead Wise With Modifier SalesReport wise data *///
	function funLoadMenuHeadWiseWithModifierSalesReport(divID, POSName,
			FromDate, ToDate, Operator, PayMode, txtFromBillNo, txtToBillNo,
			txtReportType, txtType, txtCustomer, chkConsolidatePOS,
			hidReportName,txtAreaCode,txtOperationType) {
		var shiftCode='1';
		if(gEnableShiftYN=='Y')
		{
			shiftCode=document.getElementById("txtShiftCode").value;
		}
		var searchurl = getContextPath()
				+ "/loadMenuHeadWiseWithModSalesReport.html?POSName=" + POSName
				+ "&FromDate=" + FromDate + "&ToDate=" + ToDate + "&Operator="
				+ Operator + "&PayMode=" + PayMode + "&txtFromBillNo="
				+ txtFromBillNo + "&txtToBillNo=" + txtToBillNo
				+ "&txtReportType=" + txtReportType + "&txtType=" + txtType
				+ "&txtCustomer=" + txtCustomer + "&chkConsolidatePOS="
				+ chkConsolidatePOS + "&hidReportName=" + hidReportName+ "&areaCode="
				+ txtAreaCode + "&operationType=" + txtOperationType+ "&gEnableShiftYN=" + gEnableShiftYN+ "&shiftCode=" + shiftCode;
		$
				.ajax({
					type : "POST",
					url : searchurl,
					dataType : "json",

					success : function(response) {
						funRemoveProductRows("tblMenuHeadWiseWithModifier");
						funRemoveProductRows("tblMenuHeadWiseWithModifierTotal");
						$
								.each(
										response,
										function(i, item) {
											$("#wait").css("display", "none");
											if (i == 0) {
												var table = document
														.getElementById("tblMenuHeadWiseWithModifierTotal");
												var rowCount = table.rows.length;
												var row = table
														.insertRow(rowCount);
												row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"60%\" style=\"text-align:right;font-size: 17px;font-weight: bold;\" id=\"Totfield1."
														+ (rowCount)
														+ "\" value=\"Total\" />";
												row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"32%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield2."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalQuantity
														+ "'/>";
												row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"30%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield3."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalAmount
														+ "'/>";

											}

											var table = document
													.getElementById("tblMenuHeadWiseWithModifier");
											var rowCount = table.rows.length;
											var row = table.insertRow(rowCount);
											i = i + 1;
											row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"58%\" id=\"field1."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField1
													+ "'/>";
											row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\"  style=\"text-align:left;\"  size=\"27%\" id=\"field2."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField2
													+ "'/>";
											row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"30%\" style=\"text-align:right;\" id=\"field3."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField3
													+ "'/>";
											row.insertCell(3).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"59%\" style=\"text-align:right;\" id=\"field4."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField4
													+ "'/>";
										});

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
	}

	/*fill Item Hourly wise data */
	function funLoadItemHourlyWiseSalesReport(divID, POSName, FromDate, ToDate,
			Operator, PayMode, txtFromBillNo, txtToBillNo, txtReportType,
			txtType, txtCustomer, chkConsolidatePOS, hidReportName,txtAreaCode,txtOperationType) {
		var shiftCode='1';
		if(gEnableShiftYN=='Y')
		{
			shiftCode=document.getElementById("txtShiftCode").value;
		}
		var searchurl = getContextPath()
				+ "/loadItemHourlyWiseSalesReport.html?POSName=" + POSName
				+ "&FromDate=" + FromDate + "&ToDate=" + ToDate + "&Operator="
				+ Operator + "&PayMode=" + PayMode + "&txtFromBillNo="
				+ txtFromBillNo + "&txtToBillNo=" + txtToBillNo
				+ "&txtReportType=" + txtReportType + "&txtType=" + txtType
				+ "&txtCustomer=" + txtCustomer + "&chkConsolidatePOS="
				+ chkConsolidatePOS + "&hidReportName=" + hidReportName+ "&areaCode="
				+ txtAreaCode + "&operationType=" + txtOperationType+ "&gEnableShiftYN=" + gEnableShiftYN+ "&shiftCode=" + shiftCode;
		$
				.ajax({
					type : "POST",
					url : searchurl,
					dataType : "json",

					success : function(response) {
						funRemoveProductRows("tblItemHourlyWise");
						funRemoveProductRows("tblItemHourlyWiseTotal");
						$
								.each(
										response,
										function(i, item) {
											$("#wait").css("display", "none");
											if (i == 0) {
												var table = document
														.getElementById("tblItemHourlyWiseTotal");
												var rowCount = table.rows.length;
												var row = table
														.insertRow(rowCount);
												row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"20%\" style=\"text-align:left;font-size: 17px;font-weight: bold;\"  id=\"Totfield1."
														+ (rowCount)
														+ "\" value=\"Total\" />";
												row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"44%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield2."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalQuantity
														+ "'/>";
												row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"52%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield3."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalAmount
														+ "'/>";
												row.insertCell(3).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"33%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield3."
													+ (rowCount)
													+ "\" value='"
													+ response[i].totalDiscAmt
													+ "'/>";
											}

											var table = document
													.getElementById("tblItemHourlyWise");
											var rowCount = table.rows.length;
											var row = table.insertRow(rowCount);
											i = i + 1;
											row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"52%\" id=\"field1."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField1
													+ "'/>";
											row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"30%\" style=\"text-align:left;\" id=\"field2."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField2
													+ "'/>";
											row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"41%\" style=\"text-align:right;\" id=\"field3."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField3
													+ "'/>";
											row.insertCell(3).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"40%\" style=\"text-align:right;\" id=\"field5."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField5
													+ "'/>";
											row.insertCell(3).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"40%\" style=\"text-align:right;\" id=\"field5."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField4
													+ "'/>";

										});

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
	}

	/*fill Operator wise data */
	function funLoadOperatorSalesReport(divID, POSName, FromDate, ToDate,
			Operator, PayMode, txtFromBillNo, txtToBillNo, txtReportType,
			txtType, txtCustomer, chkConsolidatePOS, hidReportName,txtAreaCode,txtOperationType) {
		var shiftCode='1';
		if(gEnableShiftYN=='Y')
		{
			shiftCode=document.getElementById("txtShiftCode").value;
		}
		var searchurl = getContextPath()
				+ "/loadOperstorWiseSalesReport.html?POSName=" + POSName
				+ "&FromDate=" + FromDate + "&ToDate=" + ToDate + "&Operator="
				+ Operator + "&PayMode=" + PayMode + "&txtFromBillNo="
				+ txtFromBillNo + "&txtToBillNo=" + txtToBillNo
				+ "&txtReportType=" + txtReportType + "&txtType=" + txtType
				+ "&txtCustomer=" + txtCustomer + "&chkConsolidatePOS="
				+ chkConsolidatePOS + "&hidReportName=" + hidReportName+ "&areaCode="
				+ txtAreaCode + "&operationType=" + txtOperationType+ "&gEnableShiftYN=" + gEnableShiftYN+ "&shiftCode=" + shiftCode;
		$
				.ajax({
					type : "POST",
					url : searchurl,
					dataType : "json",

					success : function(response) {
						funRemoveProductRows("tblOperatorWise");
						funRemoveProductRows("tblOperatorWiseTotal");
						$
								.each(
										response,
										function(i, item) {
											$("#wait").css("display", "none");
											if (i == 0) {
												var table = document
														.getElementById("tblOperatorWiseTotal");
												var rowCount = table.rows.length;
												var row = table
														.insertRow(rowCount);
												row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"120%\" style=\"text-align:left;font-size: 17px;font-weight: bold;\" id=\"Totfield1."
														+ (rowCount)
														+ "\" value=\"Total\" />";
												row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"27%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield2."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalDiscAmt
														+ "'/>";
												row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"24%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield3."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalAmount
														+ "'/>";
											}

											var table = document
													.getElementById("tblOperatorWise");
											var rowCount = table.rows.length;
											var row = table.insertRow(rowCount);
											i = i + 1;
											row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"45%\" id=\"field1."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField1
													+ "'/>";
											row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"44%\" style=\"text-align:left;\" id=\"field2."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField2
													+ "'/>";
											row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"43%\" style=\"text-align:left;\" id=\"field3."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField3
													+ "'/>";
											row.insertCell(3).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"20%\" style=\"text-align:left;\" id=\"field4."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField4
													+ "'/>";
											row.insertCell(4).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"29%\" style=\"text-align:right;\" id=\"field5."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField5
													+ "'/>";
											row.insertCell(5).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"27%\" style=\"text-align:right;\" id=\"field6."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField6
													+ "'/>";

										});

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
	}

	/*fill Monthly sales wise data */
	function funLoadMonthlySalesReport(divID, POSName, FromDate, ToDate,
			Operator, PayMode, txtFromBillNo, txtToBillNo, txtReportType,
			txtType, txtCustomer, chkConsolidatePOS, hidReportName,txtAreaCode,txtOperationType) {
		var shiftCode='1';
		if(gEnableShiftYN=='Y')
		{
			shiftCode=document.getElementById("txtShiftCode").value;
		}
		var searchurl = getContextPath()
				+ "/loadMonthlyWiseSalesReport.html?POSName=" + POSName
				+ "&FromDate=" + FromDate + "&ToDate=" + ToDate + "&Operator="
				+ Operator + "&PayMode=" + PayMode + "&txtFromBillNo="
				+ txtFromBillNo + "&txtToBillNo=" + txtToBillNo
				+ "&txtReportType=" + txtReportType + "&txtType=" + txtType
				+ "&txtCustomer=" + txtCustomer + "&chkConsolidatePOS="
				+ chkConsolidatePOS + "&hidReportName=" + hidReportName + "&areaCode="
				+ txtAreaCode + "&operationType=" + txtOperationType+ "&gEnableShiftYN=" + gEnableShiftYN+ "&shiftCode=" + shiftCode;
		$
				.ajax({
					type : "POST",
					url : searchurl,
					dataType : "json",

					success : function(response) {
						funRemoveProductRows("tblMonthlySalesFlash");
						funRemoveProductRows("tblMonthlySalesFlashTotal");
						$
								.each(
										response,
										function(i, item) {
											$("#wait").css("display", "none");
											if (i == 0) {
												var table = document
														.getElementById("tblMonthlySalesFlashTotal");
												var rowCount = table.rows.length;
												var row = table
														.insertRow(rowCount);
												row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" style=\"text-align:left;font-size: 17px;font-weight: bold;\" size=\"110%\" id=\"Totfield1."
														+ (rowCount)
														+ "\" value=\"Total\" />";
												row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"38%\" style=\"text-align:right;font-size: 15px;\" id=\"Totfield2."
														+ (rowCount)
														+ "\" value='"
														+ response[i].totalAmount
														+ "'/>";

											}

											var table = document
													.getElementById("tblMonthlySalesFlash");
											var rowCount = table.rows.length;
											var row = table.insertRow(rowCount);
											i = i + 1;
											row.insertCell(0).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"20%\"  id=\"field1."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField1
													+ "'/>";
											row.insertCell(1).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"10%\" style=\"text-align:right;\" id=\"field2."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField2
													+ "'/>";
											row.insertCell(2).innerHTML = "<input readonly=\"readonly\" class=\"Box\" size=\"26%\" style=\"text-align:right;\" id=\"field3."
													+ (rowCount)
													+ "\" value='"
													+ response[i].strField3
													+ "'/>";

										});

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
	}
	

	function funRemoveProductRows(tableName) {
		var table = document.getElementById(tableName);
		var rowCount = table.rows.length;
		while (rowCount > 0) {
			table.deleteRow(0);
			rowCount--;
		}
	}
	
	
	/* function funExportReport()
 	{
		
		var POSName = document.getElementById("cmbPOSName").value;
		var FromDate = document.getElementById("txtFromDate").value + ":"
				+ document.getElementById("txtHHFrom").value + "/"
				+ document.getElementById("txtMMFrom").value + "/"
				+ document.getElementById("txtAMPMFrom").value;
		var ToDate = document.getElementById("txtToDate").value + ":"
				+ document.getElementById("txtHHTo").value + "/"
				+ document.getElementById("txtMMTo").value + "/"
				+ document.getElementById("txtAMPMTo").value;
		var Operator = document.getElementById("txtOperator").value;
		var PayMode = document.getElementById("txtPayMode").value;

		var txtFromBillNo = document.getElementById("txtFromBillNo").value;
		var txtToBillNo = document.getElementById("txtToBillNo").value;
		var txtReportType = document.getElementById("txtReportType").value;
		var txtType = document.getElementById("txtType").value;
		var txtCustomer = document.getElementById("txtCustomer").value;
		var chkConsolidatePOS = document.getElementById("chkConsolidatePOS").checked;
		var txtOperationType = document.getElementById("txtOperationType").value;
		var shiftCode=document.getElementById("txtShiftCode").value;
		
		var shiftCode='1';
		if(gEnableShiftYN=='Y')
		{
			shiftCode=document.getElementById("txtShiftCode").value;
		}
 	} */


</script>

</head>
<body>
	<br />
	<div id="formHeading" >
		<label>Sales Report</label>
	</div> 
	<s:form name="POSSalesReportForm" method="POST"
		action="rptPOSSalesReport.html" class="formoid-default-skyblue" 
		style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans',
		'Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;width:1366px; ">

		<div id="tab_container" style="height: 50%">
			<!-- <ul class="tabs">
				<li data-state="tab1"
					style="width: 10%; height: 10%;   padding-left: 2%; margin-left: 45px;"
					class="active">Data</li>
				<li data-state="tab2" style="width: 10%;height: 10%; padding-left: 1%">Advance
					Filter</li>

			</ul> -->
			<ul class="tabs" style="margin-left: 10%">
						<li class="active" data-state="tab1" style="width: 10%; padding-left: 4%; height: 25px; border-radius: 4px;background-color: #52A4D4">Data</li>
						<li data-state="tab2" style="width: 10%; padding-left: 2%; height: 25px; border-radius: 4px;background-color: #52A4D4">AdvanceFilter</li>
				</ul>
<!-- border: 7px solid #1b1918;border: 7px solid #1b1918; -->

			<div id="tab1" class="tab_content" style="height: 30%; " >

				<br /><br /> 
				<!-- <table>
				<tr>
				<td> -->
				<div class="row" style="background-color: #fff; display: block; margin-bottom: 10px; margin-left: 5%">
				
							<div class="element-input col-lg-6" style="width: 8%; margin-left:4; margin-top:8px"> 
		    					<label class="title">POS Name</label>
		    				</div>
		    				<div class="element-input col-lg-6" style="width: 10%;"> 
								<s:select id="cmbPOSName" name="cmbPOSName" path="strPOSName" items="${posList}" >
				 				</s:select>
							</div>
							<div class="element-input col-lg-6" style="width: 8%;margin-top:8px;margin-left: 2%"> 
		    					<label class="title">From Date</label>
		    				</div>
		    				<div class="element-input col-lg-6" style="width: 15%;"> 
								<s:input  id="txtFromDate" required="required" path="fromDate" pattern="\d{1,2}-\d{1,2}-\d{4}" style="width: 100%;" />
							</div>
							<div class="element-input col-lg-6" style="width: 8%;margin-top:8px"> 
		    					<label class="title">To Date</label>
		    				</div>
		    				<div class="element-input col-lg-6" style="width: 15%;"> 
								<s:input id="txtToDate" required="required" path="toDate" pattern="\d{1,2}-\d{1,2}-\d{4}"  style="width: 100%;" onChange="funDateValidate();"/>	
							</div>
							<div class="element-input col-lg-6" style="width: 15%; margin-left:30px;"> 
								<input type="submit" value="EXPORT" id="submit"  />
							</div>
					</div>	
					<!-- </td>
					</tr>
				</table> 	 -->	
					
		 <div style="width: 150%; margin-left: 5%;  background-color: #fff;">
			<table class="scroll">
				<tr>
					<td colspan="4">
						<!-- Settlement wise table -->
											
                     <div id="divSettlementWise"  
                           class="col-sm-9" style="width: 1200px; height: 580px; display: block; background-color: #fff; "> 
                     
                     <table class="scroll" style="height: 20px; border: #0F0; margin:auto; width:100%; font-size: 14px; font-weight: bold; ">
						<thead style="background: #2FABE9; color: white;">
							<tr>
									<td width="26%">POS</td>
									<td width="27.5%">Settlement Mode</td>
									<td width="26%">Sales Amount</td>
									<td width="26%">Sales (%)</td>
									<!-- align="right" --> 
								</tr>
								</thead>
					</table>
							
					<div class="row" style="display: block; height: 85%; margin: auto; border: 1px solid #ccc;overflow-x: hidden;overflow-y: scroll; width: 100%;">
						    <table  class="scroll" id="tblSettlementWise" 
							style="width: 100%; border: #0F0;">
							<tbody>
									<col style="width: 26.4%">
									<col style="width: 25%">
									<col style="width: 25%">
									<col style="width: 25%">
							</tbody>
							</table>
					</div>
							<div class=""
						           style="width:1170px; height: 60px;  overflow-x: hidden;overflow-y: hidden; display: block; ">
						    <table
							style="height: 20px; border: #0F0; width: 100%; font-size: 14px; font-weight: bold;">
							<tr style="background: #2FABE9; color: white;">
										<td width="7.8%"></td>
										<td width="6.7%">Sales Amount</td>
									</tr>
								</table>
								
					     <div
							style=" border: 1px solid #ccc; display: block; height: 28px; margin: auto; width: 99.80%;">
							<table class="scroll" id="tblSettlementWiseTotal"
								style="width: 100%; height: 50%; border: #0F0; table-layout: fixed;"
								class="transTablex col11-center">
								<tbody>
										<col style="width: 20%">
										<col align="right" style="width: 16%">
									</table>
								</div>
							</div>
						</div> <!-- Bill wise table -->
					
					<!-- <div id="divBillWise" class=""
							style="width: 56%; height: 500px; border: 1px solid black;background-color: #fff;"> -->
							<!-- <div id="divBillWise"  class="row" style="background-color: #fff;width: 56%; height: 500px; display: -webkit-box;"> -->
<!-- 									<div class="row" style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
 -->									
                	<div id="divBillWise"
                           class="col-sm-9" style="width: 57.5%; height: 580px; display: block;  background-color: #fff; overflow-x: scroll; overflow-y: hidden;margin-left: 0.8%;"> 
                          <table class="scroll" style="height: 20px; border: #0F0; width: 160%;  font-size: 14px; font-weight: bold; margin-left: -1.1%;">
						    <thead style="background: #2FABE9; color: white;">
						         <tr>
								<td width="3.1%">Bill No</td>
								<td align="left" width="3.5%">Date</td>
								<td align="left" width="3%">Bill time</td>
								<td align="left" width="4.7%">Table Name</td>
								<td align="left" width="5%">Cust Name</td>
								<td align="left" width="4%">POS</td>
								<td align="left" width="2.2%">Shift</td>
								<td align="left" width="4%">Pay Mode</td>
								<td align="left" width="3.5%">Delivery Charge</td>
								<td align="left" width="4%">Sub Total</td>
								<td align="left" width="3.5%">Disc %</td>
								<td align="left" width="3.5%">Disc Amt</td>
								<td align="left" width="3.5%">TAX Amt</td>
								<td align="left" width="3.5%">Adv. Amt</td>
								<td align="left" width="3.5%">Sales Amt</td>
								<td align="left" width="3.5%">Round Off</td>
								<td align="left" width="5.6%">Remarks</td>
								<td align="left" width="2%">Tip</td>
							    <td align="left" width="5%">Disc Remark</td>
								<td align="left" width="5%">Reason</td>
								<td align="left" width="3.4%">PAX</td>
								<td align="left" width="4%">Order Type</td>
								
							</tr>
						</thead>	
					</table>
			  
					 <div class="row" style="display: block; height: 85%; margin-left: -1.1%; border: 1px solid #ccc; overflow-x: hidden; overflow-y: scroll; width: 160%;">
						    <table  class="scroll" id="tblBillWise"
							  style="width: 100%; border: #0F0;">
									<tbody>
							<col style="width: 1%">
							<col style="width: 3.2%">
							<col style="width: 3.5%">
							<col style="width: 4.5%">
							<col style="width: 5.7%">
							<col style="width: 4.2%">
							<col style="width: 2.2%">
							<col style="width: 1.2%">
							<col style="width: 4%">
							<col style="width: 3.5%">
							<col style="width: 4%">
							<col style="width: 3.9%">
							<col style="width: 3.5%">
							<col style="width: 4%">
							<col style="width: 3.7%">
							<col style="width: 3.8%">
							<col style="width: 4.2%">
							<col style="width: 4%">
							<col style="width: 3%">
							<col style="width: 3%">
							<col style="width: 3%">
							<col style="width: 4.5%">
							</tbody>
						</table>
					</div>
					<div class=""
						           style="width:160%; height: 60px;  overflow-x: hidden;overflow-y: hidden; display: block; margin-left: -1.1%;">
						        <table
							       style="height: 20px; border: #0F0; width: 100%; font-size: 15px; font-weight: bold;">
							       <tr style="background: #2FABE9; color: white;">
								<td width="11.3%"></td>
								<td align="right" width="11.5%">Sub Total</td>
								<td width="1%"></td>
								<td align="right" width="3.2%">Disc</td>
								<td align="right" width="2.5%">Tax Total</td>
								<td align="right" width="2.5%">Adv. Total</td>
								<td align="right" width="2.5%">Sales Amt</td> 
								<td align="right" width="2.2%">Round Off</td>
								<td align="right" width="5%">Tip Amount</td>
								<td align="right" width="7%">PAX</td>
								<td align="right" width="4%"></td>
								

							</tr>
						</table>
					  <div  style=" border: 1px solid #ccc; display: block; height: 26px; margin: auto; width: 100%;">
							   <table class="scroll" id="tblBillWiseTotal"
								  style="width: 100%; height: 50%; border: #0F0; table-layout: fixed;"
								  class="transTablex col11-center">
								<tbody>
								<col style="width: 33%">
								<col style="width: 10%">
								<col style="width: 5%">
								<col style="width: 8%">
								<col style="width: 5%">
								<col style="width: 5.5%">
								<col style="width: 6%">
								<col style="width: 5%">

							</table>
						</div>
					</div>
				</div> <!-- Item wise table id="divItemWise"-->
										
                    	
                     <div id="divItemWise"
                           class="col-sm-9" style="width: 1200px; height: 580px; display: block; background-color: #fff;  "> 
                     
                       <table class="scroll" style="height: 20px; border: #0F0; width: 1170px; font-size: 14px; font-weight: bold;">
						<thead style="background: #2FABE9; color: white;">
						        <tr>
									<td align="left" width="10.7%">Item Name</td>
									<td align="right" width="2.5%">POS</td>
									<td align="right" width="9%">Quantity</td>
									<td align="right" width="5%">Sub Total</td>
									<td align="right" width="4.5%">Discount</td>
									<td align="center" width="4%">Net Total</td>
								</tr>
						</thead>
								
							</table>
							<div class="row" style="display: block; height: 85%;  border: 1px solid #ccc; margin: auto; overflow-x: hidden;overflow-y: scroll; width: 100%;">
						    <table  class="scroll" id="tblItemWise"
							           style="width: 100%; border: #0F0;">
								<tbody>
									 <col style="width: 9%">
									<col style="width: 10%">
									<col style="width: 10%">
									<col style="width: 10%">
									<col style="width: 10%">
									<col style="width: 8%">
								</tbody>
								</table>
							</div>
							<div class=""
						           style="width:1170px; height: 60px; overflow-x: hidden;overflow-y: hidden; display: block; ">
						    <table
							style="height: 20px; border: #0F0; width: 100%; font-size: 14px; font-weight: bold;">
							      <tr style="background: #2FABE9; color: white;">
										<td width="47%"></td>
										<td align="right" width="15%">Quantity</td>
										<td align="right" width="14%">SubTotal</td>
										<td align="right" width="13%">Discount</td>
										<td align="right" width="8%">Net Total</td>
										<td align="right" width="0%"></td>
										
									</tr>
								</table>
									 <div
							style=" border: 1px solid #ccc; display: block; height: 28px; margin: auto; width: 99.80%;">
							<table class="scroll" id="tblItemWiseTotal"
								style="width: 100%; height: 50%; border: #0F0; table-layout: fixed;"
								class="transTablex col11-center">
								<tbody>
										
										<col style="width: 45%">
										<col style="width: 35%">
										<col style="width: 25%">
										<col style="width: 27%">
										<col style="width: 17%">
									</table>
								</div>
							</div>
						</div> <!-- MenuHead Wise table -->
							
                     <div id="divMenuHeadWise"
                           class="col-sm-9" style="width: 1200px; height: 580px; display: block; background-color: #fff; "> 
                     
                     <table class="scroll" style="height: 20px; border: #0F0; width:  1170px; font-size: 14px; font-weight: bold;">
						<thead style="background: #2FABE9; color: white;">
						        <tr>
									<td width="6%">Menu Name</td>
									<td align="left" width="4%">POS</td>
									<td align="right" width="3%">Quantity</td>
									<td align="right" width="6%">Sub Total</td>
									<td align="right" width="6.5%">Net Total</td>
									<td align="right" width="6%">Discount</td>
									<td align="right" width="6%">Sales (%)</td>
									<td align="left" width="1.8%"></td>
								</tr>
							</thead>	
							</table>
							<div class="row" style="display: block; height: 85%; margin: auto;  border: 1px solid #ccc; overflow-x: hidden;overflow-y: scroll; width: 100%;">
						       <table  class="scroll" id="tblMenuHeadWise"
							           style="width: 100%; border: #0F0;">
									<tbody>
									<col style="width: 15%">
									<col style="width: 10%">
									<col style="width: 19%">
									<col style="width: -10%">
									<col style="width: 15%">
									<col style="width: 19%">
									<col style="width: 8.8%">
									</tbody>
								</table>
							</div>
							<div class=""
						           style="width:1170px; height: 60px;  overflow-x: hidden;overflow-y: hidden; display: block; ">
						      <table
							       style="height: 20px; border: #0F0; width: 100%; font-size: 14px; font-weight: bold;">
							       <tr style="background: #2FABE9; color: white;">
										<td width="15.4%"></td>
										<td align="right" width="15.9%">Quantity</td>
										<td align="right" width="13.5%">Sub Total</td>
										<td align="right" width="14.8%">Net Total</td>
										<td align="right" width="14.2%">Discount</td>
										<td width="17.9%"></td>

									</tr>
								</table>
								 <div
							style=" border: 1px solid #ccc; display: block; height: 28px; margin: auto; width: 99.80%;">
							<table class="scroll" id="tblMenuHeadWiseTotal"
								style="width: 100%; height: 50%; border: #0F0; table-layout: fixed;"
								class="transTablex col11-center">
								    <tbody>
										<col style="width: 24%">
										<col style="width: 19%">
										<col style="width: 20%">
										<col style="width: 18%">
										<col style="width: 28%">


									</table>
								</div>
							</div>
						</div> <!-- Group wise table -->
									
                     
						
						 <div id="divGroupWise"
                           class="col-sm-9" style="width: 1200px; height: 580px; display: block; background-color: #fff;  "> 
                     
                     <table class="scroll" style="height: 20px; border: #0F0; width: 1170px; font-size: 14px; font-weight: bold;">
						<thead style="background: #2FABE9; color: white;">
						<tr>
									<td width="5.82%">Group Name</td>
									<td width="6.5%">POS</td>
									<td align="left" width="5.5%">Quantity</td>
									<td align="right" width="5%">Sub Total</td>
									<td align="right" width="6.5%">Net Total</td>
									<td align="right" width="6%">Discount</td>
									<td align="right" width="4.5%">Sales (%)</td>
									<td align="left" width="1%"></td>
									</tr>
						</thead>
								
							</table>
										
					     <div class="row" style="display: block; height: 85%; border: 1px solid #ccc; margin: auto; overflow-x: hidden;overflow-y: scroll; width: 100%;">
						    <table  class="scroll" id="tblGroupWise"
							style="width: 100%; border: #0F0;">
									<tbody>
									  <col style="width: 12%">
									<col style="width: 7.9%">
									<col style="width: 9%">
									<col style="width: 9%">
									<col style="width: 10%">
									<col style="width: 10%">
									<col style="width: 7%">
									</tbody>
								</table>
							</div>
							<div class=""
						           style="width:1170px; height: 60px;  overflow-x: hidden;overflow-y: hidden; display: block; ">
						    <table
							style="height: 20px; border: #0F0; width: 100%; font-size: 14px; font-weight: bold;">
							     <tr style="background: #2FABE9; color: white;">
										<td width="18.5%"></td>
										<td align="right" width="11.5%"></td>
                                        <td width="1%" align="right"></td>
										<td align="right" width="16%">Sub Total</td>
                                        <td width="3%" align="right"></td>
										<td align="right" width="11%">Net Total</td>
                                        <td width="3.5%" align="right"></td>
										<td align="right" width="10%">Discount</td>
										<td width="11.5%"></td>

									</tr>
								</table>
										 <div
							style=" border: 1px solid #ccc; display: block; height: 28px; margin: auto; width: 99.80%;">
							<table class="scroll" id="tblGroupWiseTotal"
								style="width: 100%; height: 50%; border: #0F0; table-layout: fixed;"
								class="transTablex col11-center">
								    <tbody>
										<tbody>
										<col style="width: 15%">
										<col style="width: 12%">
										<col style="width: 13%">
										<col style="width: 13%">
										<col style="width: 12%">
									</table>
								</div>
							</div>
						</div> <!-- SubGroup wise table -->
						 <div id="divSubGroupWise"
                           class="col-sm-9" style="width: 1200px; height: 580px; display: block; background-color: #fff; "> 
                     
                         <table class="scroll" style="height: 20px; border: #0F0; width: 1170px; font-size: 14px; font-weight: bold;">
					 	   <thead style="background: #2FABE9; color: white;">
						        <tr>
									<td width="10.2%">SubGroup Name</td>
									<td width="6%">POS</td>
									<td align="right" width="4%">Quantity</td>
									<td align="right" width="6%">Sub Total</td>
									<td align="right" width="5.8%">Net Total</td>
									<td align="right" width="5.2%">Discount</td>
									<td align="right" width="4.8%">Sales (%)</td>
									<td align="left" width="1%"></td>
								</tr>	
							</thead>
								
					 </table>
					      <div class="row" style="display: block; height: 85%;  border: 1px solid #ccc; margin: auto; overflow-x: hidden;overflow-y: scroll; width: 100%;">
						      <table  class="scroll" id="tblSubGroupWise"
							    style="width: 100%; border: #0F0;">
									<tbody>
									<col style="width: 21%">
									<col style="width: 11%">
									<col style="width: 11%">
									<col style="width: 11%">
									<col style="width: 10.5%">
									<col style="width: 11.8%">
									<col style="width: 5%">
									</tbody>
								</table>
							</div>
							<div class=""
						           style="width:1170px; height: 60px;  overflow-x: hidden;overflow-y: hidden; display: block; ">
						       <table
							     style="height: 20px; border: #0F0; width: 100%; font-size: 14px; font-weight: bold;">
							       <tr style="background: #2FABE9; color: white;">
										<td width="26%"></td>
										<td align="right" width="10.5%">Quantity</td>
										<td align="right" width="10.5%">Sub Total</td>
										<td align="right" width="10.5%">Net Total</td>
										<td align="right" width="9.5%">Discount</td>
										<td width="10%"></td>

									</tr>
								</table>
								  <div
							         style=" border: 1px solid #ccc; display: block; height: 28px; margin: auto; width: 99.80%;">
							     <table class="scroll" id="tblSubGroupWiseTotal"
								        style="width: 100%; height: 50%; border: #0F0; table-layout: fixed;"
								        class="transTablex col11-center">
								    <tbody>
										<tbody>
										<col style="width: 27%">
										<col style="width: 16%">
										<col style="width: 18%">
										<col style="width: 20%">
										<col style="width: 20%">

									</table>
								</div>
							</div>
						</div> <!-- Customer Wise Bill-->
							
                        <div id="divCustWise"
                           class="col-sm-9" style="width: 1200px; height: 580px; display: block; background-color: #fff;  "> 
                     
                            <table class="scroll" style="height: 20px; border: #0F0; width: 1170px; font-size: 14px; font-weight: bold;">
						       <thead style="background: #2FABE9; color: white;">
								  <tr>
									<td width="12%">Customer Name</td>
									<td align="left" width="8%">Mobile No</td>
									<td align="left" width="7%">Date Of Birth</td>
									<td align="left" width="8%">No Of Bills</td>
									<!-- <td width="6%">Quantity</td> -->
									<td align="left" width="10%">Sales Amount</td>
								 </tr>
                              </thead>
								
							  </table>
											
					     <div class="row" style="display: block; height: 85%; margin: auto;  border: 1px solid #ccc; overflow-x: hidden;overflow-y: scroll; width: 100%;">
						      <table  class="scroll" id="tblCustWise"
							   style="width: 100%; border: #0F0;">
									<tbody>
									<col style="width: 27%">
									<col style="width: 18.5%">
									<col style="width: 13%">
									<col style="width: 11%">
									
									</tbody>
								</table>
							</div>
						 <div class=""
						            style="width:1170px; height: 60px; overflow-x: hidden;overflow-y: hidden; display: block; ">
						      <table
							        style="height: 20px; border: #0F0; width: 100%; font-size: 14px; font-weight: bold;">
							       <tr style="background: #2FABE9; color: white;">
										<td width="28%"></td>
										<td align="right" width="37%">No Of Bills</td>
										<td align="right" width="22%">Sales Amount</td>
										<td width="25%"></td>
									</tr>
								</table>
						 <div
							         style=" border: 1px solid #ccc; display: block; height: 28px; margin: auto; width: 99.80%;">
							  <table class="scroll" id="tblCustWiseTotal"
								     style="width: 100%; height: 50%; border: #0F0; table-layout: fixed;"
								     class="transTablex col11-center">
							   <tbody>
										<col style="width: 27%">
										<col style="width: 30%">
										<col style="width: 50%">
										
								</tbody>
									</table>
								</div>
							</div>
						</div> <!-- Waiter Wise -->
					 <div id="divWaiterWise"
                           class="col-sm-9" style="width: 1200px; height: 580px; display: block; background-color: #fff;  "> 
                     
                     <table class="scroll" style="height: 20px; border: #0F0; width: 1170px; font-size: 14px; font-weight: bold;">
						<thead style="background: #2FABE9; color: white;">
						         <tr>
									<td width="10.4%">POS</td>
									<td width="8.3%">Waiter Full Name</td>
									<td align="left" width="10.5%">Waiter Short Name</td>
									<td align="left" width="6%">No Of Bills</td>
									<td align="left" width="6%">Sales Amount</td>
									<td align="left" width="4%"></td>
									</tr>
							</thead>
								 
							</table>
					   				
					   <div class="row" style="display: block; height: 85%; margin: auto;  border: 1px solid #ccc; overflow-x: hidden;overflow-y: scroll; width: 100%;">
						    <table  class="scroll" id="tblWaiterWise"
							  style="width: 100%; border: #0F0;">
									<tbody>
									<col style="width: 3%">
									<col style="width: 1%">
									<col style="width: 12%">
									<col style="width: 5%">
									<col style="width: 25%">
									</tbody>
								</table>
							</div>
							<div class=""
						           style="width:1170px; height: 60px; overflow-x: hidden;overflow-y: hidden; display: block; ">
						        <table
							       style="height: 20px; border: #0F0; width: 100%; font-size: 14px; font-weight: bold;">
							       <tr style="background: #2FABE9; color: white;">
										<td width="38%"></td>
										<td align="right" width="6%">Sales Amount</td>
										<td width="8%"></td>
									</tr>
								</table>
							<div
							      style=" border: 1px solid #ccc; display: block; height: 28px; margin: auto; width: 99.80%;">
							   <table class="scroll" id="tblWaiterWiseTotal"
								  style="width: 100%; height: 50%; border: #0F0; table-layout: fixed;"
								  class="transTablex col11-center">
								<tbody>
										<col style="width: 35%">
										<col style="width: 15%">
								 </tbody>
									</table>
								</div>
							</div>
						</div> <!-- Delivery Boy Wise -->
						 <div id="divDeliveryBoyWise"
                                class="col-sm-9" style="width: 1200px; height: 580px; display: block; background-color: #fff; "> 
                     
                               <table class="scroll" style="height: 20px; border: #0F0; width: 1170px; font-size: 14px; font-weight: bold;">
						       <thead style="background: #2FABE9; color: white;">
						       <tr>
									<td width="14%">Delivery Boy Name</td>
									<td align="left" width="16%">POS</td>
									<td align="right" width="9%">Sales Amount</td>
									<td align="right" width="16%">Delivery Charges</td>
									<td align="left" width="1%"></td>
									</tr>
							    </thead>		

								
							</table>
					    <div class="row" style="display: block; height: 85%; margin: auto;  border: 1px solid #ccc; overflow-x: hidden;overflow-y: scroll; width: 100%;">
						     <table  class="scroll" id="tblDeliveryBoyWise"
							  style="width: 100%; border: #0F0;">
									<tbody>
									<col style="width: 6%">
									<col style="width: 6%">
									<col style="width: 6%">
									<col style="width: 6%">
									</tbody>
								    </table>
							</div>
						<div class=""
						           style="width:1170px; height: 60px; overflow-x: hidden;overflow-y: hidden; display: block; ">
						         <table
							       style="height: 20px; border: #0F0; width: 100%; font-size: 14px; font-weight: bold;">
							       <tr style="background: #2FABE9; color: white;">
										<td width="30%"></td>
										<td align="right" width="15%">Sales Amount</td>
										<td width="19%"></td>

									</tr>
								</table>
								 <div
							style=" border: 1px solid #ccc; display: block; height: 28px; margin: auto; width: 99.80%;">
							<table class="scroll" id="tblDeliveryBoyWiseTotal"
								style="width: 100%; height: 50%; border: #0F0; table-layout: fixed;"
								class="transTablex col11-center">
								   <tbody>
										<col style="width: 23%">
										<col style="width: 30%">
								   </tbody>		
									</table>
								</div>
							</div>
						</div> <!-- Cost Centre -->
						 <div id="divCostCenterWise"
                           class="col-sm-9" style="width: 1200px; height: 580px; display: block; background-color: #fff;  "> 
                     
                     <table class="scroll" style="height: 20px; border: #0F0; width: 1170px; font-size: 14px; font-weight: bold;">
						<thead style="background: #2FABE9; color: white;">
						         <tr>
									<td width="8%">Cost Centre Name</td>
									<td width="7.2%">POS</td>
									<td align="left" width="5%">Quantity</td>
									<td align="right" width="5%">SubTotal</td>
									<td align="right" width="8%">Sales Amount</td>
									<td align="right" width="7%">Discount</td>
									<td align="right" width="5.9%">Sales (%)</td>
									<td align="left" width="1%"></td>
								</tr>
								</thead>	
							</table>
						  <div class="row" style="display: block; height: 85%; margin: auto; overflow-x:  hidden; border: 1px solid #ccc;overflow-y: scroll; width: 100%;">
						    <table  class="scroll" id="tblCostCenterWise"
							  style="width: 100%; border: #0F0;">
									<tbody>
									<col style="width: 16%">
									<col style="width: 13%">
									<col style="width: 16%">
									<col style="width: 15%">
									<col style="width: 10%">
									<col style="width: 13%">
									<col style="width: 25%">
									</tbody>
								</table>
							</div>
							  <div class=""
						           style="width:1170px; height: 60px; overflow-x: hidden;overflow-y: hidden; display: block; ">
						      <table
							       style="height: 20px; border: #0F0; width: 100%; font-size: 14px; font-weight: bold;">
							     <tr style="background: #2FABE9; color: white;">
										<td width="21%"></td>
										<td align="right" width="15%">Quantity</td>
										<td align="right" width="17.5%">Sub Total</td>
										<td align="right" width="17%">Sales Amount</td>
										<td align="right" width="16%">Discount</td>
										<td width="18%"></td>
									</tr>
								</table>
								 <div
							style=" border: 1px solid #ccc; display: block; height: 28px; margin: auto; width: 99.80%;">
							<table class="scroll" id="tblCostCenterWiseTotal"
								style="width: 100%; height: 50%; border: #0F0; table-layout: fixed;"
								class="transTablex col11-center">
								    <tbody>
										<col style="width: 15%">
										<col style="width: 12%">
										<col style="width: 14%">
										<col style="width: 13%">
										<col style="width: 22%">
									</tbody>	
									</table>
								</div>
							</div>
						</div> <!-- Home Delivery Wise -->
						 <div id="divHomeDeliveryWise"
                             class="col-sm-9" style="width: 1200px; height: 580px; display: block; background-color:#fff; "> 
                             <table class="scroll" style="height: 20px; border: #0F0; width: 1170px; font-size: 14px; font-weight: bold;">
						     <thead style="background: #2FABE9; color: white;">
						        <tr>
									<td width="4.8%">Bill No</td>
									<td width="4%">POS</td>
									<td align="left" width="3.8%">Date</td>
									<td align="left" width="4.6%">Settle Mode</td>
									<td align="right" width="5%">Delivery Charges</td>
									<td align="right" width="4.5%">Disc Amt</td>
									<td align="right" width="3.6%">Tax Amt</td>
									<td align="center" width="6%">Amount</td>
									<td width="4%">Customer Name</td>
									<td align="right" width="1%">Building</td>
									<td align="right" width="7%">Delv Boy</td>
									<td align="left" width="2.5%"></td>
								</tr>
							 </thead>	
							</table>
					     <div class="row" style="display: block; height: 85%; margin: auto; overflow-x:hidden;overflow-y: scroll; border: 1px solid #ccc; width: 100%;">
						     <table  class="scroll" id="tblHomeDeliveryWise"
							     style="width: 100%; border: #0F0;">
									<tbody>
									<col style="width: 9.8%">
									<col style="width: 8%">
									<col style="width: 8%">
									<col style="width: 10%">
									<col style="width: 10%">
									<col style="width: 8%">
									<col style="width: 9%">
									<col style="width: 5%">
									<col style="width: 16%">
									<col style="width: 14%">
									<col style="width: 4%">
									</tbody>
								</table>
							</div>
							<div class=""
						           style="width:1170px; height: 60px;  overflow-x: hidden;overflow-y: hidden; display: block; ">
						      <table
							       style="height: 20px; border: #0F0; width: 100%; font-size: 14px; font-weight: bold;">
							     <tr style="background: #2FABE9; color: white;">
										<td width="23%"></td>
										<td align="right" width="3%">Discount</td>
										<td align="right" width="4%">Tax Total</td>
										<td align="right" width="5%">Sales Amount</td>
										<td width="18%"></td>
									</tr>
								</table>
			             
							 <div style=" border: 1px solid #ccc; display: block; height: 28px; margin: auto; width: 99.80%;">
							<table class="scroll" id="tblHomeDeliveryWiseTotal"
								style="width: 100%; height: 50%; border: #0F0; table-layout: fixed;"
								class="transTablex col11-center">
								<tbody>
										<col style="width: 40%">
										<col style="width: 19%">
										<col style="width: 22%">
										<col style="width: 53%">
									</table>	
									
								</div>
							</div>
							
						</div>
						 <!-- Table Wise -->
						<div id="divTableWise"
                           class="col-sm-9" style="width: 1200px; height: 580px; display: block; background-color: #fff;  "> 
                          <table class="scroll" style="height: 20px; border: #0F0; width: 1170px;  font-size: 14px; font-weight: bold;">
						   <thead style="background: #2FABE9; color: white;">
						         <tr>
									<td width="5.7%">POS</td>
									<td width="5.8%">Table Name</td>
									<td align="left" width="6%">Sales Amount</td>
									
							    </tr>
						 </thead>
								
							</table>
						 <div class="row" style="display: block; height: 85%; margin: auto; overflow-x:  hidden;overflow-y: scroll;  border: 1px solid #ccc;width: 100%;">
						    <table  class="scroll" id="tblTableWise"
							style="width: 100%; border: #0F0;">
									<tbody>
									<col style="width: 15%">
									<col style="width: 20%">
									<col style="width: 50%">
									</tbody>
								</table>
							</div>
							<div class=""
						           style="width:1170px; height: 60px;  overflow-x: hidden;overflow-y: hidden; display: block; ">
						    <table
							       style="height: 20px; border: #0F0; width: 100%; font-size: 14px; font-weight: bold;">
							        <tr style="background: #2FABE9; color: white;">
										<td width="25%"></td>
										<td align="right" width="15%">Sales Amount</td>
										<td width="14%"></td>
									</tr>
								</table>
							<div
							        style=" border: 1px solid #ccc; display: block; height: 28px; margin: auto; width: 99.80%;">
							  <table class="scroll" id="tblTableWiseTotal"
								    style="width: 100%; height: 50%; border: #0F0; table-layout: fixed;"
								    class="transTablex col11-center">
								    <tbody>
										<col style="width: 45%">
										<col style="width: 60%">
									</table>
								</div>
							</div>
						</div> <!-- Hourly Wise -->
						<div id="divHourlyWise"
                           class="col-sm-9" style="width: 1200px; height: 580px; display: block;  background-color: #fff;  "> 
                     
                        <table class="scroll" style="height: 20px; border: #0F0; width: 1170px; font-size: 14px; font-weight: bold;">
						  <thead style="background: #2FABE9; color: white;">
						         <tr>
									<td width="10%">Time Range</td>
									<td align="left" width="6%">No Of Bills</td>
									<td align="left" width="6%">No Of PAX</td>
									<td align="right" width="6%">Sales Amount</td>
									<td align="right" width="9%">Sales (%)</td>
									<td align="left" width="1%"></td>
								 </tr>
						   </thead>		
						   	</table>
			           <div class="row" style="display: block; height: 85%; margin: auto; overflow-x: hidden;overflow-y: scroll;   border: 1px solid #ccc; width: 100%;">
						    <table  class="scroll" id="tblHourlyWise"
							  style="width: 100%; border: #0F0;">
									<tbody>
									<col style="width: 19%">
									<col style="width: 20%">
									<col style="width: 20%">
									<col style="width: 20%">
									<col style="width: 40%">
									<col style="width: 20%">
								
								</table>
							</div>
							<div class=""
						             style="width:1170px; height: 60px;  overflow-x: hidden;overflow-y: hidden; display: block; ">
						        <table
							         style="height: 20px; border: #0F0; width: 100%; font-size: 14px; font-weight: bold;">
							     <tr style="background: #2FABE9; color: white;">
										<td width="20%"></td>
										<td align="left" width="12%">Total No Of Bills</td>
										<td align="left" width="18%">Total No Of PAX</td>
										<td align="left" width="15%">Sales Amount</td>
										<td width="10%"></td>
									</tr>
								</table>
								<div
							style=" border: 1px solid #ccc; display: block; height: 28px; margin: auto; width: 99.80%;">
							<table class="scroll" id="tblHourlyWiseTotal"
								style="width: 100%; height: 50%; border: #0F0; table-layout: fixed;"
								class="transTablex col11-left">
								    <tbody>
										<col style="width: 7.7%">
										<col style="width: 4.5%">
										<col style="width: 8%">
										<col style="width: 10%">
                                    </tbody>
									</table>
								</div>
							</div>
						</div> <!-- Area Wise -->
						<div id="divAreaWise"
                           class="col-sm-9" style="width: 1200px; height: 580px; display: block;  background-color: #fff; "> 
                        <table class="scroll" style="height: 20px; border: #0F0; width: 1170px; font-size: 14px;font-weight: bold;">
						  <thead style="background: #2FABE9; color: white;">
						         <tr>
									<td width="6%">POS</td>
									<td width="10%">Area Name</td>
									<td align="left" width="6%">Sales Amount</td>
									<td align="left" width="1%"></td>
									
								</tr>
							</table>
							<div class="row" style="display: block; height: 85%; margin: auto; overflow-x: hidden;overflow-y: scroll;  border: 1px solid #ccc; width: 100%;">
						    <table  class="scroll" id="tblAreaWise"
							  style="width: 100%; border: #0F0;">
									<tbody>
									<col style="width: 26.5%">
									<col style="width: 29%">
									<col style="width: 45%">
									</tbody>
								</table>
							</div>
							<div class=""
						             style="width:1170px; height: 60px; overflow-x: hidden;overflow-y: hidden; display: block; ">
						        <table
							         style="height: 20px; border: #0F0; width: 100%; font-size: 14px; font-weight: bold;">
							     <tr style="background: #2FABE9; color: white;">
										<td width="42%"></td>
										<td align="right" width="15%">Sales Amount</td>
										<td width="15%"></td>

									</tr>
								</table>
								<div
							style=" border: 1px solid #ccc; display: block; height: 28px; margin: auto; width: 99.80%;">
							<table class="scroll" id="tblAreaWiseTotal"
								style="width: 100%; height: 50%; border: #0F0; table-layout: fixed;"
								class="transTablex col11-center">
								    <tbody>
										<col style="width: 50%">
										<col style="width: 47%">
									</table>
								</div>
							</div>
						</div> <!-- Day Wise -->
						<div id="divDayWiseSales"
                           class="col-sm-9" style="width: 1200px; height: 580px; display: block;  background-color: #fff;  "> 
                        <table class="scroll" style="height: 20px; border: #0F0; width: 1170px; font-size: 14px; font-weight: bold;">
						  <thead style="background: #2FABE9; color: white;">
						         <tr>
									<td width="8%">Bill Date</td>
									<td align="left" width="6%">No Of Bill</td>
									<td align="right" width="5%">Sub Total</td>
									<td align="right" width="8%">Discount</td>
									<td align="right" width="8%">Tax Amount</td>
									<td align="right" width="8%">Grand Amount</td>
									<td align="right" width="1%"></td>
									
								</tr>
							</table>
							 <div class="row" style="display: block; height: 85%; margin: auto; overflow-x: hidden;overflow-y: scroll;   border: 1px solid #ccc; width: 100%;">
						    <table  class="scroll" id="tblDayWiseSales"
							  style="width: 100%; border: #0F0;">
									<tbody>
									<col style="width: 10%">
									<col style="width: 17%">
									<col style="width: 17%">
									<col style="width: 17%">
									<col style="width: 22%">
									<col style="width: 22%">
									</tbody>
								</table>
							</div>
								<div class=""
						             style="width:1170px; height: 60px;  overflow-x: hidden;overflow-y: hidden; display: block; ">
						        <table
							         style="height: 20px; border: #0F0; width: 100%; font-size: 14px; font-weight: bold;">
							     <tr style="background: #2FABE9; color: white;">
										<td width="3%"></td>
										<td align="right" width="13%">Total Bill</td>
										<td align="right" width="13%">Sub Total</td>
										<td align="right" width="14%">Total Discount</td>
										<td align="right" width="12%">Tax Total</td>
										<td align="right" width="12%">Total Amount</td>
										<td width="2%"></td>

									</tr>
								</table>
								<div
							style=" border: 1px solid #ccc; display: block; height: 28px; margin: auto; width: 99.80%;">
							<table class="scroll" id="tblDayWiseSalesTotal"
								style="width: 100%; height: 50%; border: #0F0; table-layout: fixed;"
								class="transTablex col11-center">
								    <tbody>
										<col style="width: 11%">
										<col style="width: 15%">
										<col style="width: 20%">
										<col style="width: 17%">
										<col style="width: 12%">
										<col style="width: 20%">
									</table>
								</div>
							</div>
						</div> <!-- Tax Wise -->
						<div id="divTaxWiseSales"
                           class="col-sm-9" style="width: 1200px; height: 580px; display: block;  background-color: #fff; "> 
                        <table class="scroll" style="height: 20px; border: #0F0; width: 1170px;font-size: 14px; font-weight: bold;">
						  <thead style="background: #2FABE9; color: white;">
						         <tr>
									<td width="5.6%">Bill No</td>
									<td align="left" width="6%">Bill Date</td>
									<td width="5%">Tax Code</td>
									<td align="right" width="5%">Tax Name</td>
									<td align="right" width="7.6%">Tax Percentage</td>
									<td align="right" width="8.6%">Taxable Amount</td>
									<td align="right" width="8.5%">Tax Amount</td>
									<td align="right" width="1%"></td>
									
								</tr>
								</thead>
							</table>
							 <div class="row" style="display: block; height: 85%; margin: auto; overflow-x:  hidden;overflow-y: scroll;  border: 1px solid #ccc; width: 100%;">
						    <table  class="scroll" id="tblTaxWiseSales"
							  style="width: 100%; border: #0F0;">
									<tbody>
									<col style="width: 10.5%">
									<col style="width: 14.4%">
									<col style="width: 15.9%">
									<col style="width: 13%">
									<col style="width: 15%">
									<col style="width: 15%">
									<col style="width: 15%">
									</tbody>
								</table>
							</div>
								<div class=""
						             style="width:1170px; height: 60px;  overflow-x: hidden;overflow-y: hidden; display: block; ">
						        <table
							         style="height: 20px; border: #0F0; width: 100%; font-size: 14px;font-weight: bold;">
							     <tr style="background: #2FABE9; color: white;">
										<td width="30%"></td>
										<td align="right" width="12%">Total Taxable</td>
										<td align="right" width="9%">Total Tax</td>
										<td width="1%"></td>
									</tr>
								</table>
									<div
							style=" border: 1px solid #ccc; display: block; height: 28px; margin: auto; width: 99.80%;">
							<table class="scroll" id="tblTaxWiseSalesTotal"
								style="width: 100%; height: 50%; border: #0F0; table-layout: fixed;"
								class="transTablex col11-center">
								    <tbody>
										<col style="width: 100%">
										<col style="width: 30%">
										<col style="width: 25%">
									</table>
								</div>
							</div>
						</div> <!-- Tip wise -->
						<div id="divTipReport"
                           class="col-sm-9" style="width: 1200px; height: 580px; display: block;  0px; background-color: #fff; "> 
                        <table class="scroll" style="height: 20px; border: #0F0; width: 1170px; font-size: 14px; font-weight: bold;">
						  <thead style="background: #2FABE9; color: white;">
						         <tr>
									<td width="6.8%">Bill No</td>
									<td width="6.7%">Date</td>
									<td width="4.3%">Bill Time</td>
									<td width="6%">POS Code</td>
									<td width="5%">Set Mode</td>
									<td align="right" width="5%">Disc %</td>
									<td align="right" width="6%">Disc Amt</td>
									<td align="right" width="7%">Sub Total</td>
									<td align="right" width="6%">Tax Amt</td>
									<td align="right" width="6%">Tip Amt</td>
									<td align="right" width="7%">Sales Amount</td>
									<td align="right" width="1%"></td>
									
								</tr>
							</thead>	
							</table>
				       <div class="row" style="display: block; height: 85%; margin: auto; overflow-x:hidden;overflow-y: scroll;   border: 1px solid #ccc;  width: 100%;">
						    <table  class="scroll" id="tblTipReport"
							  style="width: 100%; border: #0F0;">
									<tbody>
									<col style="width: 6%">
									<col style="width: 6%">
									<col style="width: 6%">
									<col style="width: 6%">
									<col style="width: 6%">
									<col style="width: 6%">
									<col style="width: 6%">
									<col style="width: 6%">
									<col style="width: 6%">
									<col style="width: 6%">
									<col style="width: 6%">
									</tbody>
								</table>
							</div>							
							<div class=""
						             style="width:1170px; height: 60px;  overflow-x: hidden;overflow-y: hidden; display: block; ">
						        <table
							         style="height: 20px; border: #0F0; width: 100%; font-size: 14px;font-weight: bold;">
							     <tr style="background: #2FABE9; color: white;">									
										<td align="right" width="53%">Discount</td>
										<td align="right" width="7%">Sub Total</td>
										<td align="right" width="9%">Tax Total</td>
										<td align="right" width="8%">Tip Amount</td>
										<td align="right" width="8%">Sales Amount</td>
										<td align="right" width="1%"></td>


									</tr>
								</table>
						    <div
							       style=" border: 1px solid #ccc; display: block; height: 28px; margin: auto; width: 99.80%;">
							    <table class="scroll" id="tblTipReportTotal"
								    style="width: 100%; height: 50%; border: #0F0; table-layout: fixed;"
								     class="transTablex col11-center">
								     <tbody>
										<col style="width: 93%">
										<col style="width: 19%">
										<col style="width: 19%">
										<col style="width: 18%">
										<col style="width: 18%">
										<col style="width: 25%">
									</table>
								</div>
							</div>
						</div> <!-- Item Modifier Wise -->
						<div id="divItemModifierWise"
                           class="col-sm-9" style="width: 1200px; height: 580px; display: block; margin-left: 2px;  margin-top: 0px; background-color: #fff;  "> 
                          <table class="scroll" style="height: 20px; border: #0F0; width: 1170px; font-size: 14px; font-weight: bold;">
						    <thead style="background: #2FABE9; color: white;">
						         <tr>
									<td width="12%">Modifier Name</td>
									<td width="8%">POS</td>
									<td align="right" width="5%">Quantity</td>
									<td align="right" width="11%">Sales Amount</td>
									<td align="right" width="1%"></td>
								</tr>
							</thead>	
							</table>
						 <div class="row" style="display: block; height: 85%; margin: auto; overflow-x: hidden;overflow-y: scroll;  border: 1px solid #ccc;  width: 100%;">
						    <table  class="scroll" id="tblItemModifierWise"
							  style="width: 100%; border: #0F0;">
									<tbody>
									<col style="width: 29%">
									<col style="width: 19%">
									<col style="width: 17%">
									<col style="width: 10%">
									</tbody>
								</table>
							</div>
						 <div class=""
						           style="width:1170px; height: 60px; overflow-x: hidden;overflow-y: hidden; display: block; ">
						        <table
							       style="height: 20px; border: #0F0; width: 100%; font-size: 14px; font-weight: bold;">
							       <tr style="background: #2FABE9; color: white;">
										<td width="30%"></td>
										<td align="right" width="13%">Quantity</td>
										<td align="right" width="18%">Sales Amount</td>
										<td width="1%"></td>


									</tr>
								</table>
						  <div
							      style=" border: 1px solid #ccc; display: block; height: 28px; margin: auto; width: 99.80%;">
							   <table class="scroll" id="tblItemModifierWiseTotal"
								  style="width: 100%; height: 50%; border: #0F0; table-layout: fixed;"
								  class="transTablex col11-center">
								<tbody>
										<col style="width: 55%">
										<col style="width: 30%">
										<col style="width: 35%">
									</table>
								</div>
							</div>
						</div> <!-- MenuHeadWiseWithModifier -->
					    <div id="divMenuHeadWiseWithModifier"
                            class="col-sm-9" style="width: 1200px; height: 580px; display: block; 0px; background-color: #fff;  "> 
                           <table class="scroll" style="height: 20px; border: #0F0; width: 1170px; font-size: 14px; font-weight: bold;">
						      <thead style="background: #2FABE9; color: white;">
						         <tr>
									<td width="13%">Menu Name</td>
									<td align="left" width="12%">POS</td>
									<td align="left" width="12%">Quantity</td>
									<td align="left" width="10.5%">Sales Amount</td>
									<td align="right" width="1%"></td>
								</tr>
							</table>
                       <div class="row" style="display: block; height: 85%; margin: auto; overflow-x:hidden;overflow-y: scroll;   border: 1px solid #ccc;  width: 100%;">
						    <table  class="scroll" id="tblMenuHeadWiseWithModifier"
							  style="width: 100%; border: #0F0;">
									<tbody>
									<col style="width: 15%">
									<col style="width: 15%">
									<col style="width: 15%">
									<col style="width: 40%">
									</tbody>
								</table>
							</div>
							 <div class=""
						           style="width:1170px; height: 60px; overflow-x: hidden;overflow-y: hidden; display: block; ">
						        <table
							       style="height: 20px; border: #0F0; width: 100%; font-size: 14px; font-weight: bold;">
							       <tr style="background: #2FABE9; color: white;">
										<td width="8%"></td>
										<td align="right" width="21%">Quantity</td>
										<td width="1%"></td>
										<td align="right" width="14%">Sales Amount</td>
										<td width="8%"></td>

									</tr>
								</table>
							<div
							     style=" border: 1px solid #ccc; display: block; height: 28px; margin: auto; width: 99.80%;">
							        <table class="scroll" id="tblMenuHeadWiseWithModifierTotal"
								   style="width: 100%; height: 50%; border: #0F0; table-layout: fixed;"
								   class="transTablex col11-center">
								     <tbody>
										<col style="width: 30%">
										<col style="width: 25%">
										<col style="width: 30%">
									</table>
								</div>
							</div>
						</div> <!-- Item Wise Hourly -->
						<div id="divItemHourlyWise"
                           class="col-sm-9" style="width: 1200px; height: 580px; display: block; background-color: #fff; "> 
                          <table class="scroll" style="height: 20px; border: #0F0; width: 1170px; font-size: 14px; font-weight: bold;">
						    <thead style="background: #2FABE9; color: white;">
						         <tr>
									<td width="14.5%">Time Range</td>
									<td align="left" width="16%">Item Name</td>
									<td align="right" width="4.5%">Quantity</td>
									<td width="7%"></td>
									<td align="right" width="5%">Item Amount</td>
									<td width="8%"></td>
									<td align="left" width="5%">Discount</td>
									<td align="right" width="1%"></td>
								</tr>
							</table>
						<div class="row" style="display: block; height: 85%; margin: auto; overflow-x: hidden;overflow-y: scroll;   border: 1px solid #ccc; width: 100%;">
						    <table  class="scroll" id="tblItemHourlyWise"
							  style="width: 100%; border: #0F0;">
									<tbody>
									<col style="width: 5%">
									<col style="width: 20%">
									<col style="width: 25%">
									<col style="width: 15%">
									<col style="width: 30%">
									</tbody>
								</table>
							</div>
							<div class=""
						           style="width:1170px; height: 60px; overflow-x: hidden;overflow-y: hidden; display: block; ">
						        <table
							       style="height: 20px; border: #0F0; width: 100%;font-size: 14px; font-weight: bold;">
							       <tr style="background: #2FABE9; color: white;">
										<td width="48%"></td>
										<td align="right" width="12%">Total Quantity</td>
										<td width="8%"></td>
										<td align="right" width="10%">Total Amount</td>
										<td width="8%"></td>
										<td align="right" width="10%">Total Discount</td>
										<td width="19%"></td>
									</tr>
								</table>
							<div
							      style=" border: 1px solid #ccc; display: block; height: 28px; margin: auto; width: 99.80%;">
							   <table class="scroll" id="tblItemHourlyWiseTotal"
								  style="width: 100%; height: 50%; border: #0F0; table-layout: fixed;"
								  class="transTablex col11-center">
								   <tbody>
										<col style="width: 30%">
										<col style="width: 15%">
										<col style="width: 30%">		
									</table>
								</div>
							</div>
						</div> <!-- Operator Wise -->
						<div id="divOperatorWise"
                           class="col-sm-9" style="width: 1200px; height: 580px; display: block; background-color: #fff;  "> 
                          <table class="scroll" style="height: 20px; border: #0F0; width: 1170px; font-size: 14px; font-weight: bold;">
						    <thead style="background: #2FABE9; color: white;">
						         <tr>
									<td width="19%">Operator Code</td>
									<td width="19%">Operator Name</td>
									<td width="18%">POS</td>
									<td width="15%">Payment Mode</td>
									<td align="right" width="8%">Disc Amount</td>
									<td width="5%"></td>
									<td align="left" width="9%">Sales Amount</td>
									<td align="right" width="1%"></td>
								</tr>
							</table>
						<div class="row" style="display: block; height: 85%; margin: auto; overflow-x:  hidden;overflow-y: scroll;border: 1px solid #ccc; width: 100%;">
						    <table  class="scroll" id="tblOperatorWise"
							  style="width: 100%; border: #0F0;">
									<tbody>
									<col style="width: 10%">
									<col style="width: 10%">
									<col style="width: 15%">
									<col style="width: 15%">
									<col style="width: 15%">
									<col style="width: 20%">
									</tbody>
								</table>
							</div>
							 <div class=""
						           style="width:1170px; height: 60px;overflow-x: hidden;overflow-y: hidden; display: block; ">
						        <table
							       style="height: 20px; border: #0F0; width: 100%; font-size: 14px; font-weight: bold;">
							       <tr style="background: #2FABE9; color: white;">
										<td width="54%"></td>
										<td align="right" width="25%">Discount Amount</td>
										<td align="right" width="12%">Sales Amount</td>
										<td width="1%"></td>

									</tr>
								</table>
							 <div
							      style=" border: 1px solid #ccc; display: block; height: 28px; margin: auto; width: 99.80%;">
							   <table class="scroll" id="tblOperatorWiseTotal"
								  style="width: 100%; height: 50%; border: #0F0; table-layout: fixed;"
								  class="transTablex col11-center">
								<tbody>
										<col style="width: 70%">
										<col style="width: 15%">
										<col style="width: 20%">
									</table>
								</div>
							</div>
						</div> <!-- Monthly Wise -->
					<div id="divMonthlySalesFlash"
                           class="col-sm-9" style="width: 1200px; height: 580px; display: block; background-color: #fff; "> 
                          <table class="scroll" style="height: 20px; border: #0F0; width: 1170px; font-size: 14px; font-weight: bold;">
						    <thead style="background: #2FABE9; color: white;">
						         <tr>
									<td  width="9%">Month</td>
									<td align="left" width="9%">Year</td>
									<td align="left" width="6%">Total Sales</td>
									<td align="right" width="1%"></td>
								</tr>
							</table>
						 <div class="row" style="display: block; height: 85%; margin: auto; overflow-x: hidden;overflow-y: scroll;  border: 1px solid #ccc;  width: 100%;">
						    <table  class="scroll" id="tblMonthlySalesFlash"
							  style="width: 100%; border: #0F0;">
									<tbody>
									<col style="width: 15%">
									<col style="width: 15%">
									<col style="width: 15%">
									</tbody>
								</table>
							</div>
							  <div class=""
						           style="width:1170px; height: 60px;  overflow-x: hidden;overflow-y: hidden; display: block; ">
						        <table
							       style="height: 20px; border: #0F0; width: 100%; font-size: 14px;font-weight: bold;">
							       <tr style="background: #2FABE9; color: white;">
										<td width="25%"></td>
										<td align="right" width="13%">Total Sale</td>
										<td width="10%"></td>

									</tr>
								</table>
							<div
							      style=" border: 1px solid #ccc; display: block; height: 28px; margin: auto; width: 99.80%;">
							   <table class="scroll" id="tblMonthlySalesFlashTotal"
								  style="width: 100%; height: 50%; border: #0F0; table-layout: fixed;"
								  class="transTablex col11-center">
								<tbody>
										<col style="width: 50%">
										<col style="width: 40%">
									</table>
								</div>
							</div>
						</div> <!-- All Tables End Here -->
					</td>
				</tr>
				<!-- <tr>
					<td colspan="4"></td>
				</tr>
				<tr>
					<td colspan="4">
						
				<tr> -->
				<tr>
					
					<td colspan="4">
						<div id="tableImg"
							style="width: 1170px; height: 120px; margin-left: 15px;border: 1px solid #ccc;overflow-x: scroll; overflow-y: hidden; ">
							<table class="">
								<!-- style="height:120px; border: #0F0;width: 100%;font-size:11px;overflow-x: scroll; font-weight: bold;"> -->
								

									<td style="padding-right: 12px;"id="divSettlementWiseee"><img
										src="../${pageContext.request.contextPath}/resources/images/imgSettlementWise.png"
										onclick="funSelectedReport('divSettlementWise')"></td> 
									<td style="text-align: center;padding-right: 12px;"><img
										src="../${pageContext.request.contextPath}/resources/images/imgBillWise.png"
										onclick="funSelectedReport('divBillWise','xyz')"></td>
									<td style="text-align: center;padding-right: 12px;"><img
										src="../${pageContext.request.contextPath}/resources/images/imgItemWise.png"
										onclick="funSelectedReport('divItemWise')"></td>
									<td style="text-align: center;padding-right: 12px;"><img
										src="../${pageContext.request.contextPath}/resources/images/imgMenuHeadWise.png"
										onclick="funSelectedReport('divMenuHeadWise')"></td>
									<td style="text-align: center;padding-right: 12px;"><img
										src="../${pageContext.request.contextPath}/resources/images/imgGroupWise.png"
										onclick="funSelectedReport('divGroupWise')"></td>
									<td style="text-align: center;padding-right: 12px;"><img
										src="../${pageContext.request.contextPath}/resources/images/imgSubGroupWise.png"
										onclick="funSelectedReport('divSubGroupWise')"></td>
									<td style="text-align: center;padding-right: 12px;"><img
										src="../${pageContext.request.contextPath}/resources/images/imgCustWise.png"
										onclick="funSelectedReport('divCustWise')"></td>
									<td style="text-align: center;padding-right: 12px;"><img
										src="../${pageContext.request.contextPath}/resources/images/imgWaiterWise.png"
										onclick="funSelectedReport('divWaiterWise')"></td>
									<td style="text-align: center;padding-right: 12px;"><img
										src="../${pageContext.request.contextPath}/resources/images/imgDeliveryBoyWise.png"
										onclick="funSelectedReport('divDeliveryBoyWise')"></td>
									<td style="text-align: center;padding-right: 12px;"><img
										src="../${pageContext.request.contextPath}/resources/images/imgCostCenterWise.png"
										onclick="funSelectedReport('divCostCenterWise')"></td>
									<td style="text-align: center;padding-right: 12px;"><img
										src="../${pageContext.request.contextPath}/resources/images/imgHomeDeliveryWise.png"
										onclick="funSelectedReport('divHomeDeliveryWise')"></td>
									<td style="text-align: center;padding-right: 12px;"><img
										src="../${pageContext.request.contextPath}/resources/images/imgTableWise.png"
										onclick="funSelectedReport('divTableWise')"></td>
									<td style="text-align: center;padding-right: 12px;"><img
										src="../${pageContext.request.contextPath}/resources/images/imgHourlyWise.png"
										onclick="funSelectedReport('divHourlyWise')"></td>
									<td style="text-align: center;padding-right: 12px;"><img
										src="../${pageContext.request.contextPath}/resources/images/imgAreaWise.png"
										onclick="funSelectedReport('divAreaWise')"></td>
									<td style="text-align: center;padding-right: 12px;"><img
										src="../${pageContext.request.contextPath}/resources/images/imgDayWiseSales.png"
										onclick="funSelectedReport('divDayWiseSales')"></td>
									<td style="text-align: center;padding-right: 12px;"><img
										src="../${pageContext.request.contextPath}/resources/images/imgTaxWiseSales.png"
										onclick="funSelectedReport('divTaxWiseSales')"></td>
									<td style="text-align: center;padding-right: 12px;"><img
										src="../${pageContext.request.contextPath}/resources/images/imgTipreport.png"
										onclick="funSelectedReport('divTipReport')"></td>
									<td style="text-align: center;padding-right: 12px;"><img
										src="../${pageContext.request.contextPath}/resources/images/imgItemModifierWise.png"
										onclick="funSelectedReport('divItemModifierWise')"></td>
									<td style="text-align: center;padding-right: 12px;"><img
										src="../${pageContext.request.contextPath}/resources/images/imgMenuHeadWiseWithModifier.png"
										onclick="funSelectedReport('divMenuHeadWiseWithModifier')"></td>
									<td style="text-align: center;padding-right: 12px;"><img
										src="../${pageContext.request.contextPath}/resources/images/imgItemHourlyWise.png"
										onclick="funSelectedReport('divItemHourlyWise')"></td>
									<td style="text-align: center;padding-right: 12px;"><img
										src="../${pageContext.request.contextPath}/resources/images/imgOperatorWise.png"
										onclick="funSelectedReport('divOperatorWise')"></td>
									<td style="text-align: center;padding-right: 12px;"><img
										src="../${pageContext.request.contextPath}/resources/images/imgMonthlySalesFlash.png"
										onclick="funSelectedReport('divMonthlySalesFlash')"></td> 
								
							</table>
						</div>
					</td>
				</tr>
			</table>
				</div>
				<br /> <br />
				
				
				
				
				<div id="wait"
					style="display: none; width: 60px; height: 60px; border: 0px solid black; position: absolute; top: 45%; left: 45%; padding: 2px;">
					<img
						src="../${pageContext.request.contextPath}/resources/images/ajax-loader-light.gif"
						width="60px" height="60px" />
				</div>
			</div>
			
			
			
			
			<div id="tab2" class="tab_content" style="height: 400px">

				<br /> <br />
						<div class="row" style="background-color: #fff; display: block;margin-bottom:30px;">
							<div class="element-input col-lg-6" style="width: 8%; margin-left:200px "> 
		    					<label class="title">Operator</label>
		    				</div>
		    				<div class="element-input col-lg-6" style="width: 24%;"> 
								<s:select id="txtOperator" name="txtOperator" path="strOperator" items="${Operator}" >
				 				</s:select>
							</div>
							
							<div class="element-input col-lg-6" style="width: 8%; margin-left:30px "> 
		    					<label class="title">Pay Mode</label>
		    				</div>
		    				<div class="element-input col-lg-6" style="width: 24%;"> 
								<s:select id="txtPayMode" name="txtPayMode" path="strPayMode" items="${PayMode}" >
				 				</s:select>
							</div>
							
						    </div>	
						
				


                 <div class="row" style="background-color: #fff; display: block; margin-bottom: 30px;">
							<div class="element-input col-lg-6" style="width: 8%; margin-left:200px "> 
		    					<label class="title">Time From</label>
		    				</div>
		    				<div class="element-input col-lg-6" style="width:8%;"> 
								<s:select id="txtHHFrom" name="txtHHFrom" path="strHHFrom" items="${HH}" >
				 				</s:select>
							</div>
								<div class="element-input col-lg-6" style="width: 8%;"> 
								<s:select id="txtMMFrom" name="txtMMFrom" path="strMMFrom" items="${MM}" >
				 				</s:select>
							</div>
								<div class="element-input col-lg-6" style="width: 8%;"> 
								<s:select id="txtAMPMFrom" name="txtAMPMFrom" path="strAMPMFrom" >
							        <option value="AM" >AM</option>
									<option value="PM" >PM</option>
								</s:select>
							     </div>
								 
							<div class="element-input col-lg-6" style="width: 8%; margin-left:30px "> 
		    					<label class="title">To Time</label>
		    				</div>
		    				<div class="element-input col-lg-6" style="width: 8%;"> 
								<s:select id="txtHHTo" name="txtHHTo" path="strHHTo" items="${HH}" >
				 				</s:select>	
							</div>
								<div class="element-input col-lg-6" style="width: 8%;"> 
								<s:select id="txtMMTo" name="txtMMTo" path="strMMTo" items="${MM}" >
				 				</s:select>
							</div>
							<div class="element-input col-lg-6" style="width: 8%;"> 
								<s:select id="txtAMPMTo" name="txtAMPMTo" path="strAMPMTo" >
                                    <option value="1" >AM</option>
									<option value="2" >PM</option>
							  </s:select>
							</div>
		 					
		</div>				

           <div class="row" style="background-color: #fff; display: block;margin-bottom:30px;">
			<div class="element-input col-lg-6" style="width: 8%; margin-left:200px "> 
    				<label class="title">From Bill No</label>
    			</div>	
    			<div class="element-input col-lg-6" style="width: 24%;"> 
					<s:input class="large" colspan="3" type="text" id="txtFromBillNo" path="strFromBillNo"  />
				</div>
			<div class="element-input col-lg-6" style="width: 8%; margin-left:30px "> 
					<label class="title">To Bill No</label>
				</div>	
			<div class="element-input col-lg-6" style="width: 24%;"> 
					<s:input class="large" colspan="3" type="text" id="txtToBillNo" path="strToBillNo"  />
				</div> 
				
</div>
					
  <div class="row" style="background-color: #fff; display: block; margin-bottom: 30px;">
							<div class="element-input col-lg-6" style="width: 8%; margin-left:200px "> 
		    					<label class="title">Report Type</label>
		    				</div>
		    				<div class="element-input col-lg-6" style="width: 24%;"> 
								<s:select id="txtReportType" name="txtReportType" path="strReportType"  >
                                    <option value="1" >Bill Wise</option>
									<option value="2" >Customer Wise</option>
									<option value="2" >Item Wise</option>
								</s:select>
							</div>
							<div class="element-input col-lg-6" style="width: 8%; margin-left:30px "> 
		    					<label class="title">Type</label>
		    				</div>
		    				<div class="element-input col-lg-6" style="width: 24%;"> 
								<s:select id="txtType" name="txtType" path="strType"  >
                                    <option value="1" >Data</option>
									<option value="2" >Chart</option>
								</s:select>
							</div>
							
					</div>		
					
				
    <div class="row" style="background-color: #fff; display: block; margin-bottom: 30px;">
							<div class="element-input col-lg-6"  style="width: 8%; margin-left:200px "> 
    				          <label class="title">Customer</label>
    				          </div>
    				         <div class="element-input col-lg-6" style="width: 24%;"> 
					           <s:input class="large" colspan="3" type="text" id="txtCustomer" path="strCustomer" ondblclick="funHelp('POSCustomerMaster')" />
				           </div>
							
							
					</div>		

   <div class="row" style="background-color: #fff; display: block;margin-bottom:30px;">
							<div class="element-input col-lg-6" style="width: 8%; margin-left:200px "> 
		    					<label class="title">Area</label>
		    				</div>
		    					<div class="element-input col-lg-6" style="width: 24%;"> 
								<s:select id="txtAreaCode" name="txtAreaCode" path="strAreaCode" items="${areaList}" >
				 				</s:select>
				 			</div>
				 			<div class="element-input col-lg-6" style="width: 8%; margin-left:30px "> 
		    					<label class="title">Shift</label>
		    				</div>
		    						<div class="element-input col-lg-6" style="width: 24%;"> 
								<s:select id="txtShiftCode" name="txtShiftCode" path="strShiftCode" items="${shiftList}">
				 				</s:select>
				 			</div>
</div>
				 			
<div class="row" style="background-color: #fff; display: block;margin-bottom:30px;">
							 <div class="element-input col-lg-6" style="width: 8%; margin-left:200px ">
		    					       <label class="title">Operation Type</label>
		    				      </div>
		    					<div class="element-input col-lg-6" style="width: 24%;"> 
								<s:select id="txtOperationType" name="txtOperationType" path="strOperationType" >
                                    <option value="All" >All</option>
									<option value="DineIn" >DineIn</option>
									<option value="DirectBiller" >DirectBiller</option>
									<option value="HomeDelivery" >HomeDelivery</option>
									<option value="TakeAway" >TakeAway</option>
								</s:select>
							
							</div>
					   <div class="element-input col-lg-6" style="width: 15%; margin-left:30px ">
							  
							    <label><s:input type="checkbox"  id="chkConsolidatePOS" path="strConsolidatePOS"  style="width: 10%" ></s:input>
							     Consolidate POS</label>
							
							
							
						</div>	 
							
							
							
		            </div>
							
			</div>			






</div>




		
			
		
		        <s:hidden id="hidReportName" path="strReportName"  />

	</s:form>

</body>
</html>




 