<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title></title>
<link rel="stylesheet" type="text/css"
	href="<spring:url value="/resources/css/jquery-confirm.min.css"/>" />
<script type="text/javascript"
	src="<spring:url value="/resources/js/jquery-confirm.min.js"/>"></script>
<script type="text/javascript"
	src="<spring:url value="/resources/js/confirm-prompt.js"/>"></script>
<script type="text/javascript">
	$(document).ready(function() 
	{
	  /* $('input#txtSettelmentCode').mlKeyboard({layout: 'en_US'});
	  $('input#txtSettelmentDesc').mlKeyboard({layout: 'en_US'});
	  $('input#txtConversionRatio').mlKeyboard({layout: 'en_US'});
	  $('input#txtAccountCode').mlKeyboard({layout: 'en_US'}); */
		$(".tab_content").hide();
		$(".tab_content:first").show();

		$("ul.tabs li").click(function() {
			$("ul.tabs li").removeClass("active");
			$(this).addClass("active");
			$(".tab_content").hide();

			var activeTab = $(this).attr("data-state");
			$("#" + activeTab).fadeIn();
		});
		
		
		  $("form").submit(function(event){
			  if($("#txtSettelmentDesc").val().trim()=="")
				{
				  confirmDialog("Please Enter Settlement Name","");
					return false;
				}
			  if($("#cmbPrinterType").val().trim()=="")
				{
				  confirmDialog("Please Enter Printer Type","");
					return false;
				}
			 
			  else{
				  flg=funCallFormAction();
				  return flg;
			  }
			});
	});
</script>
<script type="text/javascript">

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
								"Data Saved \n\n" + message, "");
<%}
			}%>
	});


	  
	  
	var fieldName;

	function funSetData(code) {

		switch (fieldName) {

		case 'POSSettlementMaster':
			funSetSettlement(code);
			break;
		case 'WebBooksAcountMaster':
			$("#txtAccountCode").val(code);
			break;
		}
	}

	function funSetSettlement(code) {

		$("#txtSettelmentCode").val(code);
		var searchurl = getContextPath()
				+ "/loadPOSSettlementMasterData.html?settlementCode=" + code;
		$
				.ajax({
					type : "GET",
					url : searchurl,
					dataType : "json",
					success : function(response) {
						
						if (response.strTableNo == 'Invalid Code') 
						{
							confirmDialog("Invalid Group Code", "");
							$("#txtSettelmentCode").val('');
						} 
						else {
							$("#txtSettelmentDesc").val(
									response.strSettelmentDesc);
							$("#cmbSettlementType").val(
									response.strSettelmentType);
							
							
							$("#cmbApplicable").val(response.strApplicable);
							
							
							$("#txtConversionRatio").val(
									response.dblConversionRatio);
							
							$("#cmbPrinterType").val(
									response.strPrinterType);
							//$("#txtSettelmentDesc").focus();
							
							if (response.strBilling == 'Y') {
								$("#chkBilling").prop('checked', true);
							}

							if (response.strAdvanceReceipt == 'Y') {
								$("#chkAdvanceReceipt").prop('checked', true);
							}

							if (response.strBillPrintOnSettlement == 'Y') {
								$("#chkBillPrintOnSettlement").prop('checked',
										true);
							}
							if (response.strCustomerSelectionOnBillSettlement == 'Y') {
								$('#chkSelectCustOnBillSettlement').prop(
										'checked', true)
							}
							
							if (response.strCreditReceiptYN == 'Y') {
								$('#chkCreditReceipt').prop('checked', true)
							}
							$("#txtAccountCode").val(response.strAccountCode);
							
							$("#txtThirdPartyComission").val(
									response.dblThirdPartyComission);
							
							
							$("#cmbComissionType").val(
									response.strComissionType);
							
							$("#cmbComissionOn").val(
									response.strComissionOn);
							//$("#txtAccountCode").val(response.strAccountCode); 
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
	}

	function funHelp(transactionName) {
		fieldName = transactionName;
		window.open("searchform.html?formname=" + transactionName
				+ "&searchText=", "",
				"dialogHeight:600px;dialogWidth:600px;dialogLeft:400px;")
	}
	
	
	 
	 
	function funCallFormAction() {
		var flg = true;

		var name = $('#txtSettelmentDesc').val();
		var code = $('#txtSettelmentCode').val();

		$.ajax({
			type : "GET",
			url : getContextPath() + "/checkSettlementName.html?name=" + name
					+ "&code=" + code,
			async : false,
			dataType : "text",
			success : function(response) {
				if (response == "false") {
					confirmDialog("Settlement Name Already Exist!", "");
					$('#txtSettelmentDesc').focus();
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
		<label>Settlement Master</label>
	</div>

	<br />
	<br />
	<!--  Mahesh -->
	<s:form name="POSSettlementMaster" method="POST"
		action="savePOSSettlementMaster.html" class="formoid-default-skyblue"
		style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans','Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;max-width:880px;min-width:150px;margin-top:2%;">

		<div class="title" style="margin-left: 10%;">

			<div id="tab_container"
				style="height: 60%; border: 0px solid black; width: 100%; overflow: hidden;">
				<ul class="tabs">
					<li class="active" data-state="tab1"
						style="width: 17%; padding-left: 4%; height: 25px; border-radius: 4px;">General</li>
					<li data-state="tab2"
						style="width: 17%; padding-left: 4%; height: 25px; border-radius: 4px;">Linkup</li>
				</ul>
				<br /> <br />

				<!-- 			Start Tab1 -->
				<br />
				<div id="tab1" class="tab_content">

					<div class="row" style="background-color: #fff;">
						<div class="element-input col-lg-6" style="width: 40%;">
							<label class="title">Settlement Code</label>
						</div>
						<div class="element-input col-lg-6" style="margin-bottom: 10px;">
							<s:input class="large" colspan="3" type="text"
								id="txtSettelmentCode" path="strSettelmentCode"
								ondblclick="funHelp('POSSettlementMaster')" readonly="true" />
						</div>
					</div>

					<div class="row" style="background-color: #fff;">
						<div class="element-input col-lg-6" style="width: 40%;">
							<label class="title">Settlement Name</label>
						</div>
						<div class="element-input col-lg-6" style="margin-bottom: 10px;">
							<s:input class="large" colspan="3" type="text"
								id="txtSettelmentDesc" path="strSettelmentDesc"
								style="width:230px;" />
						</div>
					</div>

					<div class="row" style="background-color: #fff;">
						<div class="element-input col-lg-6" style="width: 40%;">
							<label class="title">Settlement Type</label>
						</div>
						<div class="element-input col-lg-6" style="margin-bottom: 10px;">
							<s:select id="cmbSettlementType" path="strSettelmentType">
								<option value="Cash">Cash</option>
								<option value="Credit Card">Credit Card</option>
								<option value="Debit Card">Debit Card</option>
								<option value="Credit">Credit</option>
								<option value="Coupon">Coupon</option>
								<option value="Complementary">Complementary</option>
								<option value="Gift Voucher">Gift Voucher</option>
								<option value="Loyalty Points">Loyalty Points</option>
								<option value="Member">Member</option>
								<option value="Room">Room</option>
							</s:select>
						</div>
					</div>

					<div class="row"
						style="background-color: #fff; display: block; margin-bottom: 10px;">
						<div class="element-input col-lg-6"
							style="width: 20%; margin-left: 12px;">
							<label class="title" style="width: 100%">Applicable For</label>
						</div>
						<div class="element-input col-lg-6"
							style="width: 60%; margin-left: 1%; margin-bottom: 10px;">
							<s:input type="checkbox" id="chkBilling" path="strBilling" checked="checked"
								style="width:7%;"></s:input>
							Billing &nbsp;
							<s:input type="checkbox" id="chkAdvanceReceipt"
								path="strAdvanceReceipt" style="width:7%;"></s:input>
							Advance Receipt &nbsp;
							<s:input type="checkbox" id="chkBillPrintOnSettlement"
								path="strBillPrintOnSettlement" style="width:7%;"></s:input>
							Bill Print On Settlement
						</div>


						<div class="element-input col-lg-6"
							style="width: 60%; margin-left: 22.5%; margin-bottom: 10px;">
							<s:input type="checkbox" id="chkCreditReceipt"
								path="strCreditReceiptYN" style="width:7%;"></s:input>
							Credit Receipt
							<s:input type="checkbox" id="chkSelectCustOnBillSettlement"
								path="strCustomerSelectionOnBillSettlement" style="width:7%;"></s:input>
							Select Customer On Bill Settlement
						</div>

					</div>

					<div class="row" style="background-color: #fff;">
						<div class="element-input col-lg-6"
							style="width: 29%; margin-bottom: 30px;">
							<label class="title">Applicable</label>
						</div>

						<div class="element-input col-lg-6" style="width: 25%;">
							<s:select id="cmbApplicable" path="strApplicable">
								<option value="Y">Yes</option>
								<option value="N">No</option>
							</s:select>

						</div>


					</div>

					<div class="row" style="background-color: #fff;">
						<div class="element-input col-lg-6"
							style="width: 29%; margin-bottom: 30px;">
							<label class="title">Conversion Rate</label>
						</div>
						<div class="element-input col-lg-6" style="width: 25%;">
							<s:input class="large" colspan="3" type="number"
								id="txtConversionRatio" value="1" path="dblConversionRatio" />
						</div>
					</div>

					<div class="row" style="background-color: #fff;">
						<div class="element-input col-lg-6"
							style="width: 29%; margin-bottom: 30px;">
							<label class="title">Third Party Commision</label>
						</div>

						<div class="element-input col-lg-6" style="width: 20%;">
							<s:input class="large" colspan="3" type="number"
								id="txtThirdPartyComission" path="dblThirdPartyComission" />
						</div>

						<div class="element-input col-lg-6" style="width: 25%;">
							<s:select id="cmbComissionType" path="strComissionType">
								<option value="Per">Per</option>
								<option value="Amt">Amt</option>
							</s:select>
						</div>
						<div class="element-input col-lg-6" style="width: 25%;">
							<s:select id="cmbComissionOn" path="strComissionOn">
								<option value="Net Amount">Net Amount</option>
								<option value=" Gross Amount">Gross Amount</option>
								<option value="No. of Pax">No. of Paxt</option>
							</s:select>

						</div>
					</div>

					<div class="row" style="background-color: #fff;">
						<div class="element-input col-lg-6"
							style="width: 29%; margin-bottom: 30px;">
							<label class="title">Printer Type</label>
						</div>
						<div class="element-input col-lg-6" style="width: 25%;">
							<s:select id="cmbPrinterType" path="strPrinterType" items="${printerList}">

							</s:select>
						</div>
					</div>
					</div>

					<!-- 			End Of Tab1 -->

					<!-- 			Start Tab2 -->

					<div id="tab2" class="tab_content">

						<div class="row" style="background-color: #fff;">
							<div class="element-input col-lg-6">
								<label class="title">Account Code</label>
							</div>
							<div class="element-input col-lg-6" style="margin-bottom: 10px;">
								<s:input class="large" colspan="3" type="text"
									id="txtAccountCode" path="strAccountCode" readonly="true"
									ondblclick="funHelp('WebBooksAcountMaster')" />
							</div>
						</div>

					</div>

					<!-- 			End Of Tab2 -->

				</div>

				<div class="col-lg-10 col-sm-10 col-xs-10"
					style="width: 60%; margin-left: 20%; border: 0px solid black;">
					<p align="center">
					<div class="submit col-lg-4 col-sm-4 col-xs-4">
						<input type="submit" value="Submit" />
					</div>

					<div class="submit col-lg-4 col-sm-4 col-xs-4">
						<input type="reset" value="Reset" onclick="funResetFields()">
					</div>
					</p>
				</div>

			</div>
			<!-- 	<table -->
			<!-- 				style="border: 0px solid black; width: 70%; margin-left: auto; margin-right: auto;background-color:#C0E4FF;"> -->
			<!-- 				<tr> -->
			<!-- 					<td> -->
			<!-- 						<div id="tab_container"> -->
			<!-- 							<ul class="tabs"> -->
			<!-- 								<li class="active" data-state="tab1">General</li> -->
			<!-- 								<li data-state="tab2">Linkup</li> -->


			<!-- 							</ul> -->
			<!-- 							<br /> <br /> -->

			<!-- 							 Start of Generals tab -->

			<!-- 							<div id="tab1" class="tab_content"> -->
			<!-- 								<table  class="masterTable"> -->

			<!-- 								<tr> -->
			<!-- 				<td> -->
			<!-- 					<label>Settlement Code</label> -->
			<!-- 				</td> -->
			<%-- 				<td>	<s:input colspan="3" type="text" id="txtSettelmentCode" path="strSettelmentCode" cssClass="searchTextBox jQKeyboard form-control" ondblclick="funHelp('POSSettlementMaster')" /> --%>


			<!-- 				</td> -->
			<!-- 				</tr> -->
			<!-- 				<tr> -->
			<!-- 				<td> -->
			<!-- 					<label>Settlement Name</label> -->
			<!-- 				</td> -->
			<%-- 				<td>	<s:input colspan="" type="text" id="txtSettelmentDesc" path="strSettelmentDesc" cssClass="longTextBox jQKeyboard form-control" /> --%>
			<!-- 				</td> -->
			<!-- 			</tr> -->
			<!-- 			<tr> -->
			<!-- 			<td><label>Settlement Type</label></td> -->
			<%-- 				<td><s:select id="cmbSettlementType" name="cmbSettlementType" path="strSettelmentType" cssClass="BoxW124px" > --%>
			<!-- 				<option value="Cash">Cash</option> -->
			<!-- 				 <option value="Credit Card">Credit Card</option> -->
			<!-- 				 <option value="Debit Card">Debit Card</option> -->
			<!--  				 <option value="Credit">Credit</option> -->
			<!--  				 <option value="Coupon">Coupon</option> -->
			<!--  				 <option value="Complementary">Complementary</option> -->
			<!--  				 <option value="Gift Voucher">Gift Voucher</option> -->
			<!--  				 <option value="Loyalty Points">Loyalty Points</option> -->
			<!--  				  <option value="Member">Member</option> -->
			<!--  				   <option value="Room">Room</option> -->
			<%-- 				 </s:select></td> --%>

			<!-- 			</tr> -->
			<!-- 			<tr> -->
			<!-- 				<td><label>Applicable For</label></td> -->
			<%-- 				<td><s:checkbox element="li" id="chkBilling" path="strBilling" --%>
			<%-- 									value="Yes" />&nbsp;&nbsp;&nbsp;<label>Billing</label> --%>
			<!-- 									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -->
			<%-- 									<s:checkbox element="li" id="chkAdvanceReceipt" path="strAdvanceReceipt" --%>
			<%-- 									value="Yes" />&nbsp;&nbsp;&nbsp;<label>Advance Receipt</label> --%>
			<!-- 									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -->
			<%-- 									<s:checkbox element="li" id="chkBillPrintOnSettlement" path="strBillPrintOnSettlement" --%>
			<%-- 									value="Yes" />&nbsp;&nbsp;&nbsp;<label>Bill Print On Settlement</label></td> --%>
			<!-- 									<td></td> -->
			<!-- 			</tr> -->

			<!-- 			<tr> -->
			<!-- 			<td><label>Applicable</label></td> -->
			<%-- 				<td><s:select id="cmbApplicable" name="cmbApplicable" path="strApplicable" cssClass="BoxW124px" > --%>
			<!-- 				<option value="Y">Yes</option> -->
			<!-- 				 <option value="N">No</option> -->

			<%-- 				 </s:select></td> --%>

			<!-- 			</tr> -->

			<!-- 			<tr> -->

			<!-- 			<td><label>Conversion Rate</label></td> -->

			<%-- 				<td><s:input colspan="" type="text" id="txtConversionRatio" value="1" --%>
			<%-- 						name="txtConversionRatio" path="dblConversionRatio"  --%>
			<%-- 						cssStyle="text-transform: uppercase;" cssClass="longTextBox jQKeyboard form-control" />  --%>
			<!-- 		       </td> -->
			<!-- 		       <td></td> -->
			<!-- 		       <td></td> -->
			<!-- 			</tr> -->
			<!-- 						</table> -->
			<!-- 							</div> -->
			<!-- 							 End of  Generals tab -->


			<!-- 							Start of Settlement tab -->

			<!-- 							<div id="tab2" class="tab_content"> -->
			<!-- 						<table  class="masterTable"> -->

			<!-- 									<tr> -->
			<!-- 				<td width="140px">Account Code</td> -->
			<%-- 				<td><s:input id="txtAccountCode" path="strAccountCode" --%>
			<%-- 						cssClass="searchTextBox jQKeyboard form-control" ondblclick="funHelp('WebBooksAcountMaster')" /></td> --%>
			<!-- 			</tr> -->

			<!-- 						</table> -->
			<!-- 			</div> -->
			<!-- 							End of Settlement tab -->




			<!-- 						</div> -->
			<!-- 					</td> -->
			<!-- 				</tr> -->
			<!-- 			</table> -->




			<!-- 		<br /> -->
			<!-- 		<br /> -->
			<!-- 		<p align="center"> -->
			<!-- 			<input type="submit" value="Submit" tabindex="3" class="form_button" /> -->
			<!-- 			<input type="reset" value="Reset" class="form_button" onclick="funResetFields()"/> -->
			<!-- 		</p> -->
	</s:form>
</body>
</html>
