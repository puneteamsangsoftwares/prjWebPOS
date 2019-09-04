<%-- <%@page import="org.json.simple.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<script type="text/javascript">
var selectedRowIndex=0;

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
	alert("Data Saved \n\n" + message);
<%}
			}%>
	});

	function funGetSelectedRowIndex(obj) {
		var index = obj.parentNode.parentNode.rowIndex;
		var table = document.getElementById("tblData");

		if ((selectedRowIndex > 0) && (index != selectedRowIndex)) {
			if (selectedRowIndex % 2 == 0) {
				row = table.rows[selectedRowIndex];
				row.style.backgroundColor = '#A3D0F7';
				selectedRowIndex = index;
				row = table.rows[selectedRowIndex];
				row.style.backgroundColor = '#ffd966';
				row.hilite = true;
			} else {
				row = table.rows[selectedRowIndex];
				row.style.backgroundColor = '#C0E4FF';
				selectedRowIndex = index;
				row = table.rows[selectedRowIndex];
				row.style.backgroundColor = '#ffd966';
				row.hilite = true;
			}

		} else {
			selectedRowIndex = index;
			row = table.rows[selectedRowIndex];
			row.style.backgroundColor = '#ffd966';
			row.hilite = true;
		}
	}

	//FOr Equal Split
	function funEqualSplit(splitQty) {
    	var billNo = $("#txtBillNo").val();
	var searchurl = getContextPath() + "/loadEqualSplitData.html?billNo="
				+ billNo + "&splitQty=" + splitQty;

		$.ajax({
			type : "GET",

			url : searchurl,
			dataType : "json",
			async : false,
			success : function(response) {
				funEqualSplitRowData(response.MenuList, response.TaxList,
						response.TotalList);

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
	
	
	//Item Type Wise Split
	function funItemTypeSplit() {
    	var billNo = $("#txtBillNo").val();
	var searchurl = getContextPath() + "/loadItemTypeWiseSplit.html?billNo="
				+ billNo;

		$.ajax({
			type : "GET",

			url : searchurl,
			dataType : "json",
			async : false,
			success : function(response) {
				funEqualSplitRowData(response.MenuList, response.TaxList,
						response.TotalList);

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
	function funRemoveTableRows(tblId) {
		var table = document.getElementById(tblId);
		var rowCount = table.rows.length;
		while (rowCount > 1) {
			table.deleteRow(1);
			rowCount--;
		}
	}

	function funSetData(code) {
		$("#txtBillNo").val(code);
		var searchurl = getContextPath() + "/loadPOSSplitBillData.html?billNo="
				+ code;
		$.ajax({
			type : "GET",
			url : searchurl,
			dataType : "json",

			success : function(response) {

				funAddFullRow(response.MenuList, response.TaxList,
						response.TotalList);

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
	function funEqualSplitRowData(MenuList, TaxList, TotalList) {
		var row = 0;
		var tableId = "tblItemTable";
		var tblTableDtl = document.getElementById('tblItemTable');
		var rowCount = tblTableDtl.rows.length;
		var totalQty = 0, totalAmt = 0;
		for (var i = 0; i < MenuList.length; i++) {
			row = table.insertRow(rowCount);
			var rowItemData = MenuList[i];

			row.insertCell(0).innerHTML = "<input name=\readonly=\"readonly\" class=\"Box \" size=\"30%\" id=\""
					+ rowItemData[0] + "\" value='" + rowItemData[0] + "' / >";
			row.insertCell(0).innerHTML = "<input name=\readonly=\"readonly\" class=\"Box \" size=\"30%\" id=\""
					+ rowItemData[0] + "\" value='" + rowItemData[0] + "' / >";
			row.insertCell(1).innerHTML = "<input name=\readonly=\"readonly\" class=\"Box \" size=\"15%\" id=\""
					+ rowItemData[1] + "\" value='" + rowItemData[1] + "'/>";
			row.insertCell(2).innerHTML = "<input name=\readonly=\"readonly\" class=\"Box \" size=\"15%\" id=\""
					+ rowItemData[2] + "\" value='" + rowItemData[2] + "' />";
			row.insertCell(3).innerHTML = "<input name=\readonly=\"readonly\" class=\"Box \" size=\"15%\" id=\""
					+ rowItemData[3] + "\" value='" + rowItemData[3] + "' />";
			/* row.insertCell(4).innerHTML = "<input name=\readonly=\"readonly\" class=\"Box \" size=\"15%\" id=\""
					+ rowItemData[4] + "\" value='" + rowItemData[4] + "' />"; */
		}
	}

	//Fill data in the table grid
	function funAddFullRow(MenuList, TaxList, TotalList) {
		$('#tblData tbody').empty();
		var table = document.getElementById("tblData");
		var rowCount = table.rows.length;

		var row = table.insertRow(rowCount);

		for (var i = 0; i < MenuList.length; i++) {
			row = table.insertRow(rowCount);
			var rowItemData = MenuList[i];

			row.insertCell(0).innerHTML = "<input name=\readonly=\"readonly\" class=\"Box \" size=\"30%\" id=\""
					+ rowItemData[0]
					+ "\" value='"
					+ rowItemData[0]
					+ "' onclick=\"funGetSelectedRowIndex(this)\"/ >";
			row.insertCell(1).innerHTML = "<input name=\readonly=\"readonly\" class=\"Box \" size=\"15%\" id=\""
					+ rowItemData[1]
					+ "\" value='"
					+ rowItemData[1]
					+ "'onclick=\"funGetSelectedRowIndex(this)\"/>";
			row.insertCell(2).innerHTML = "<input name=\readonly=\"readonly\" class=\"Box \" size=\"15%\" id=\""
					+ rowItemData[2]
					+ "\" value='"
					+ rowItemData[2]
					+ "'onclick=\"funGetSelectedRowIndex(this)\" />";

			rowCount++;
		}

		//To Print Tax 
		for (var i = 0; i < TaxList.length; i++) {
			row = table.insertRow(rowCount);
			var rowItemData = TaxList[i];

			row.insertCell(0).innerHTML = "<input name=\readonly=\"readonly\" class=\"Box \" size=\"30%\" id=\""
					+ rowItemData[0]
					+ "\" value='"
					+ rowItemData[0]
					+ "' onclick=\"funGetSelectedRowIndex(this)\"/ >";
			row.insertCell(1).innerHTML = "<input name=\readonly=\"readonly\" class=\"Box \" size=\"15%\" id=\""
					+ rowItemData[1]
					+ "\" value='"
					+ rowItemData[1]
					+ "'onclick=\"funGetSelectedRowIndex(this)\"/>";
			row.insertCell(2).innerHTML = "<input name=\readonly=\"readonly\" class=\"Box \" size=\"15%\" id=\""
					+ rowItemData[2]
					+ "\" value='"
					+ rowItemData[2]
					+ "'onclick=\"funGetSelectedRowIndex(this)\" />";

			rowCount++;
		}

		$("#lblSubTotal").val(TotalList[1]);
		$("#lblDiscount").val(TotalList[4]);
		$("#lblNetAmount").val(
				parseFloat(TotalList[1]) + parseFloat(TotalList[4]));

	}

	function funHelp(transactionName) {
		window.open("searchform.html?formname=" + transactionName
				+ "&searchText=", "",
				"dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	}

	//Split Bill Button Clicked Pratiksha 08-05-2019
	function funSplitBillClicked(g, t) {
		
	
    	var tableName = document.getElementById("tblData");
    	
		
		var splitType = document.getElementById(g);
		var selsplitType = splitType.options[splitType.selectedIndex].text;

		var splitQty = document.getElementById(t);
		var selsplitQty = splitQty.options[splitQty.selectedIndex].text;

		if (selsplitType == " ") {
			alert("Please Select The Split Type");
			return;
		} else if (selsplitType == "Equal Split") {
			funEqualSplit(selsplitQty);
		} else if (selsplitType == "Group Wise") {
			funGroupSplit();
		} else if (selsplitType == "Item Type Wise") {
			funItemTypeSplit();
		} else if (selsplitType == "Item Wise") {
			funItemTypeSplit();
		}
	}
</script>
</head>
<body>
	<div id="formHeading">
		<label>Split Bill</label>
	</div>

	<s:form name="frmPOSSplitBill" method="POST"
		action="frmPOSSplitBill.html" class="formoid-default-skyblue"
		style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans','Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;max-width:100%;min-width:150px;margin-top:2%;">

		<div class="title" style="width: 100%;">
			<div class="row"
				style="background-color: #fff; margin-bottom: 10px; display: -webkit-box;">
				<div class="element-input col-lg-6" style="width: 7%;">
					<label class="title">Bill No:</label>
				</div>
				<div class="element-input col-lg-6" style="width: 15%;">
					<s:input class="large" type="text" id="txtBillNo" path="strBillNo"
						ondblclick="funHelp('POSSplitBill')" style="width: 100%;"
						readonly="true" />

				</div>
				<div class="element-input col-lg-3 col-sm-3 col-xs-3"
					style="width: 15%;">
					<label class="title">Select Split Type</label>
				</div>
				<div class="element-input col-lg-3 col-sm-3 col-xs-3"
					style="width: 15%;">
					<s:select id="cmbSplitType" path="strSplitType"
						items="${splitTypeList}">


					</s:select>
				</div>
				<div class="element-input col-lg-3 col-sm-3 col-xs-3"
					style="width: 15%;">
					<label class="title">Enter Split QTY</label>
				</div>

				<div class="element-input col-lg-3 col-sm-3 col-xs-3"
					style="width: 10%;">

					<s:select colspan="1" type="text" items="${splitTypeQty}"
						id="cmbSplitQty" path="strSplitQty">
					</s:select>
				</div>

			</div>

			<div class="column" style="width: 52%;">

				<div class="row"
					style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">

					<div
						style="border: 1px solid #ccc; display: block; height: 400px; overflow-x: scroll; overflow-y: scroll; width: 65%; margin-left: 10%;">

						<table
							style="width: 100%; overflow: scroll; background: #2FABE9; color: white;">
							<thead>
								<tr>
									<td
										style="border-right: 1px solid black; width: 10%; height: 20px;">Description</td>
									<td style="border-right: 1px solid black; width: 10%">Qty</td>
									<td style="border-right: 1px solid black; width: 10%">Amount</td>
									<td style="border-right: 1px solid black; width: 10%">Code</td>

									<td style="border-right: 1px solid black; width: 10%">Discount</td>

								</tr>
							</thead>
						</table>

						<table id="tblData" style="width: 65%">
							<tbody></tbody>

						</table>

					</div>

				</div>
				<div class="row"
					style="background-color: #fff; display: -webkit-box; margin-bottom: 10px; margin-left: -40%;">
					<div class="element-input col-lg-6"
						style="width: 70%; text-align: right;">
						<label class="title">Sub Total</label>
					</div>
					<div class="element-input col-lg-6"
						style="width: 30%; font-style: bold;">
						<input type="text" id="lblSubTotal" readonly="true"
							style="text-transform: uppercase; width: 100px; height: 25px; margin-left: -2%;" />

					</div>
				</div>
				<div class="row"
					style="background-color: #fff; display: -webkit-box; margin-bottom: 10px; margin-left: -40%;">
					<div class="element-input col-lg-6"
						style="width: 70%; text-align: right;">
						<label class="title">Discount</label>
					</div>
					<div class="element-input col-lg-6" style="width: 30%;">
						<input type="text" id="lblDiscount" readonly="true"
							style="text-transform: uppercase; width: 100px; height: 25px; margin-left: -2%;" />

					</div>
				</div>
				<div class="row"
					style="background-color: #fff; display: -webkit-box; margin-bottom: 10px; margin-left: -40%;">
					<div class="element-input col-lg-6"
						style="width: 70%; text-align: right;">
						<label class="title">Net Amount</label>
					</div>
					<div class="element-input col-lg-6" style="width: 30%;">
						<input type="text" id="lblNetAmount" readonly="true"
							style="text-transform: uppercase; width: 100px; height: 25px; margin-left: -2%;" />

					</div>
				</div>
			</div>
			<div class="column" style="width: 42%;">

				<div class="row"
					style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">

					<div
						style="border: 1px solid #ccc; display: block; height: 220px; margin: auto; overflow-x: scroll; overflow-y: scroll; width: 50%;">

						<table>

							<thead>
								<tr>
									<td style="border: 1px white solid; width: 20%"><label>Desc</label></td>
									<td style="border: 1px white solid; width: 10%"><label>Qty</label></td>
									<td style="border: 1px white solid; width: 10%"><label>Amt</label></td>
									<td style="border: 1px white solid; width: 10%"><label></label></td>

								</tr>
							</thead>

						</table>

					</div>

				</div>



				<table id="tblItemTable" class="transFormTable"">

				</table>
				<div class="row"
					style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">

					<div
						style="border: 1px solid #ccc; display: block; height: 220px; margin: auto; overflow-x: scroll; overflow-y: scroll; width: 50%;">

						<table>

							<thead>
								<tr>
									<td style="border: 1px white solid; width: 20%"><label>Desc</label></td>
									<td style="border: 1px white solid; width: 10%"><label>Qty</label></td>
									<td style="border: 1px white solid; width: 10%"><label>Amt</label></td>
									<td style="border: 1px white solid; width: 10%"><label></label></td>

								</tr>
							</thead>

						</table>

					</div>

				</div>



				<table id="tblItemTable" class="transFormTable"">

				</table>
			</div>
			<div class="col-lg-10 col-sm-10 col-xs-10" style="width: 150%;">
				<p align="center">
				<div class="submit col-lg-4 col-sm-4 col-xs-4">
					<input id="SplitButton" type="submit" value="SPLIT BILL"
						style="margin-left: 50%;"
						onclick="funSplitBillClicked('cmbSplitType','cmbSplitQty')"></input>
				</div>
				<div class="submit col-lg-4 col-sm-4 col-xs-4">
					<input id="btnDown" type="reset" value="RESET"
						"style="margin-left: 100%;" onclick="funResetFields();"></input>
				</div>
				</p>
			</div>
		</div>



	</s:form>
</body>
</html> --%>