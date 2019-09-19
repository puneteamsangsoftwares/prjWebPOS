<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Property Setup</title>
<link rel="stylesheet" type="text/css"
	href="<spring:url value="/resources/css/jquery-confirm.min.css"/>" />
<script type="text/javascript"
	src="<spring:url value="/resources/js/jquery-confirm.min.js"/>"></script>
<script type="text/javascript"
	src="<spring:url value="/resources/js/confirm-prompt.js"/>"></script>

<style>
#tab_container {
	width: 100%;
	margin: 1;
	height: 100%;
	overflow: auto;
	float: right;
}

ul.tab li.active {
	background: -moz-linear-gradient(center top, #0F5495, #73ADDD) repeat
		scroll 0 0 #f18d05;
	border: 1px solid #0F5495;
	border-radius: 0 0px;
	transition: all 0.9s ease 0s;
	background: black;
	color: white;
}

ul.tab li {
	width: 100px;
	margin: 0;
	margin-top: 3px;
	padding: 6px 6px;
	height: 30px;
	line-height: 16px;
	border: 1px solid #6DA9DB;
	border-left: none;
	background: #227db1;
	overflow: hidden;
	position: relative;
	border-radius: 4px;
	border-right: 1px solid #555;
	font-size: 12px;
	font-weight: bold;
	color: #fff;
	cursor: pointer; //
	background: red;
	
	
}

ul.tab li.a:FOCUS {
	background-color: black;
}

.active:HOVER {
	background-color: black;
	color: white;
}

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
	$(document).ready(function() {
		
			$('input#txtTaxDesc').mlKeyboard({layout: 'en_US'});
		  	$('input#txtTaxShortName').mlKeyboard({layout: 'en_US'});
		 	$('input#txtAmount').mlKeyboard({layout: 'en_US'});
		  	$('input#txtPercent').mlKeyboard({layout: 'en_US'});
		
		  	$("#txtdteValidFrom").datepicker({ dateFormat: 'yy-mm-dd' });
			$("#txtdteValidFrom" ).datepicker('setDate', 'today');
			$("#txtdteValidFrom").datepicker();
			
			$("#dteHOServerDate").datepicker({ dateFormat: 'yy-mm-dd' });
			$("#dteHOServerDate" ).datepicker('setDate', 'today');
			$("#dteHOServerDate").datepicker();
			
			
	        $("#txtdteValidTo").datepicker({ dateFormat: 'yy-mm-dd' });
	        $("#txtdteValidTo" ).datepicker('setDate', 'today');
	        $("#txtdteValidTo").datepicker();
	            

		$(".tab_content").hide();
		$(".tab_content:first").show();

		$("ul.tab li").click(function() {
			$("ul.tab li").removeClass("active");
			$(this).addClass("active");
			$(".tab_content").hide();
			var activeTab = $(this).attr("data-state");
			$("#" + activeTab).fadeIn();
		});
	    
		 $("#cmbPosCode").change(function() 
		   {
			    funSetSaveUpdateBtn();
			 
		   });
		/*  $("form").submit(function(event){
			 if($("#cmbRFIDSetup").val() == 'Y')
				{
				if($("#txtRFIDServerName").val().trim() == '')
					{
					alert("Please Enter the Server Name");
					return ;
					}
				 }
			
		 }); */
			

		/* $("#cmbConsolidatedKOTPrinterPort").change(function()
		   {
			 var printer=$('#cmbConsolidatedKOTPrinterPort').val();
			 $("#txtConsolidatedKOTPrinterPort").val($("#cmbConsolidatedKOTPrinterPort").val());
		   }); */
			
		  
		   $("#cmbSelectedType").change(function() {
			   funFillSelectedTypeDtlTable();
		         });
			//$('#clientImage').attr('src', getContextPath()+"/resources/images/company_Logo.png");
		   //$('#clientImage').attr('src', getContextPath()+"/resources/images/imgClientImage.jpg");
	});
	
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
	confirmDialog(message, "");
<%}
			}%>
	});

	function funSetSaveUpdateBtn() {
		var posCode = $('#cmbPosCode').val();
		var searchurl = getContextPath() + "/funGetPos.html?posCode=" + posCode;
		$.ajax({
			type : "GET",
			url : searchurl,
			dataType : "json",
			async : true,
			success : function(response) {
				if (response.count == 0){
					$('#submitBtn').val("Save");
				}
				else{
					$('#submitBtn').val("Update");

					
				 
				}
				funFillPOSWiseData();
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
	//Fill Pos wise data when we change the posname
	function funFillPOSWiseData() {
		var code = $("#cmbPosCode").val();
		var searchurl = getContextPath()
				+ "/loadPOSWisePropertySetupData.html?posCode="
				+ $("#cmbPosCode").val();
		$.ajax({
					type : "GET",
					url : searchurl,
					dataType : "json",
					async : true,
					success : function(response) {

						$("#cmbCity").val(response.strCity);

						$("#txtClientCode").val(response.strClientCode);
						$("#txtClientName").val(response.strClientName);
						$("#txtAddrLine1").val(response.strAddrLine1);
						$("#txtAddrLine2").val(response.strAddrLine2);
						$("#txtAddrLine3").val(response.strAddrLine3);
						$("#txtPinCode").val(response.strPinCode);
						$("#cmbState").val(response.strState);
						$("#cmbCountry").val(response.strCountry);
						$("#txtTelephone").val(response.strTelephone);
						$("#txtEmail").val(response.strEmail);
						$("#cmbNatureOfBussness").val(
								response.strNatureOfBussness);

						$("#txtBillFooter").val(response.strBillFooter);
						$("#cmbBillPaperSize").val(response.intBiilPaperSize);
						$("#cmbPrintMode").val(response.strBillPrintMode);
						$("#cmbColumnSize").val(response.intColumnSize);
						$("#cmbPrintType").val(response.strPrintingType);
						$("#cmbBillFormatType").val(response.strBillFormatType);

						if (response.chkShowBills == 'Y') {
							$("#chkShowBills").prop('checked', true);
						} else
							$("#chkShowBills").prop('checked', false);
						if (response.chkNegBilling == 'Y') {
							$("#chkNegBilling").prop('checked', true);
						} else
							$("#chkNegBilling").prop('checked', false);

						if (response.chkPrintKotForDirectBiller == 'Y') {
							$("#chkPrintKotForDirectBiller").prop('checked',
									true);
						}

						else
							$("#chkPrintKotForDirectBiller").prop('checked',
									false);
						if (response.chkEnableKOT == 'Y') {
							$("#chkEnableKOT").prop('checked', true);
						} else
							$("#chkEnableKOT").prop('checked', false);

						if (response.chkMultiBillPrint == 'Y') {
							$("#chkMultiBillPrint").prop('checked', true);
						} else
							$("#chkMultiBillPrint").prop('checked', false);

						if (response.chkDayEnd == 'Y') {
							$("#chkDayEnd").prop('checked', true);
						} else
							$("#chkDayEnd").prop('checked', false);

						if (response.chkPrintShortNameOnKOT == 'Y') {
							$("#chkPrintShortNameOnKOT").prop('checked', true);
						} else
							$("#chkPrintShortNameOnKOT").prop('checked', false);

						if (response.chkMultiKOTPrint == 'Y') {
							$("#chkMultiKOTPrint").prop('checked', true);
						} else
							$("#chkMultiKOTPrint").prop('checked', false);

						if (response.chkPrintInvoiceOnBill == 'Y') {
							$("#chkPrintInvoiceOnBill").prop('checked', true);
						} else
							$("#chkPrintInvoiceOnBill").prop('checked', false);

						if (response.chkPrintTDHItemsInBill == 'Y') {
							$("#chkPrintTDHItemsInBill").prop('checked', true);
						} else
							$("#chkPrintTDHItemsInBill").prop('checked', false);

						if (response.chkManualBillNo == 'Y') {
							$("#chkManualBillNo").prop('checked', true);
						} else
							$("#chkManualBillNo").prop('checked', false);

						if (response.chkPrintInclusiveOfAllTaxesOnBill == 'Y') {
							$("#chkPrintInclusiveOfAllTaxesOnBill").prop(
									'checked', true);
						} else
							$("#chkPrintInclusiveOfAllTaxesOnBill").prop(
									'checked', false);

						if (response.chkEffectOnPSP == 'Y') {
							$("#chkEffectOnPSP").prop('checked', true);
						} else
							$("#chkEffectOnPSP").prop('checked', false);

						if (response.chkPrintVatNo == 'Y') {
							$("#chkPrintVatNo").prop('checked', true);
						}

						else
							$("#chkPrintVatNo").prop('checked', false);
						$("#txtVatNo").val(response.strVatNo);

						$("#txtNoOfLinesInKOTPrint").val(
								response.intNoOfLinesInKOTPrint);
						if (response.chkServiceTaxNo == 'Y') {
							$("#chkServiceTaxNo").prop('checked', true);
						} else
							$("#chkServiceTaxNo").prop('checked', false);

						$("#txtServiceTaxNo").val(response.strServiceTaxNo);

						$("#cmbShowBillsDtlType").val(
								response.strShowBillsDtlType);
						$("#txtAdvRecPrintCount").val(
								response.strAdvRecPrintCount);

						$("#cmbPOSType").val(response.strPOSType);
						$("#cmbDataSendFrequency").val(
								response.strDataSendFrequency);
						$("#txtWebServiceLink").val(response.strWebServiceLink);
						$("#dteHOServerDate").val(response.dteHOServerDate);
						$("#dblMaxDiscount").val(response.dblMaxDiscount);
						$("#cmbChangeTheme").val(response.strChangeTheme);
						$("#cmbDirectArea").val(response.strDirectArea);

						if (response.chkAreaWisePricing == 'Y') {
							$("#chkAreaWisePricing").prop('checked', true);
						} else
							$("#chkAreaWisePricing").prop('checked', false);

						$("#txtCustSeries").val(response.longCustSeries);

						if (response.chkSlabBasedHomeDelCharges == 'Y') {
							$("#chkSlabBasedHomeDelCharges").prop('checked',
									true);
						} else
							$("#chkSlabBasedHomeDelCharges").prop('checked',
									false);

						if (response.chkEditHomeDelivery == 'Y') {
							$("#chkEditHomeDelivery").prop('checked', true);
						}

						else
							$("#chkEditHomeDelivery").prop('checked', false);
						if (response.chkPrintForVoidBill == 'Y') {
							$("#chkPrintForVoidBill").prop('checked', true);
						}

						else
							$("#chkPrintForVoidBill").prop('checked', false);
						if (response.chkDirectKOTPrintMakeKOT == 'Y') {
							$("#chkDirectKOTPrintMakeKOT")
									.prop('checked', true);
						}

						else
							$("#chkDirectKOTPrintMakeKOT").prop('checked',
									false);
						if (response.chkSkipPaxSelection == 'Y') {
							$("#chkSkipPaxSelection").prop('checked', true);
						}

						else
							$("#chkSkipPaxSelection").prop('checked', false);
						if (response.chkPrintInvoiceOnBill == 'Y') {
							$("#chkPrintInvoiceOnBill").prop('checked', true);
						}

						else
							$("#chkPrintInvoiceOnBill").prop('checked', false);
						if (response.chkAreaMasterCompulsory == 'Y') {
							$("#chkAreaMasterCompulsory").prop('checked', true);
						}

						else
							$("#chkAreaMasterCompulsory")
									.prop('checked', false);
						if (response.chkPostSalesDataToMMS == 'Y') {
							$("#chkPostSalesDataToMMS").prop('checked', true);
						}

						else
							$("#chkPostSalesDataToMMS").prop('checked', false);
						$("#cmbItemType").val(response.strItemType);

						if (response.chkPrinterErrorMessage == 'Y') {
							$("#chkPrinterErrorMessage").prop('checked', true);
						}

						else
							$("#chkPrinterErrorMessage").prop('checked', false);
						if (response.chkActivePromotions == 'Y') {
							$("#chkActivePromotions").prop('checked', true);
						}

						else
							$("#chkActivePromotions").prop('checked', false);
						if (response.chkPrintKOTYN == 'Y') {
							$("#chkPrintKOTYN").prop('checked', true);
						}

						else
							$("#chkPrintKOTYN").prop('checked', false);
						if (response.chkChangeQtyForExternalCode == 'Y') {
							$("#chkChangeQtyForExternalCode").prop('checked',
									true);
						} else
							$("#chkChangeQtyForExternalCode").prop('checked',
									false);

						$("#cmbStockInOption").val(response.strStockInOption);

						if (response.chkShowItemStkColumnInDB == 'Y') {
							$("#chkShowItemStkColumnInDB")
									.prop('checked', true);
						} else
							$("#chkShowItemStkColumnInDB").prop('checked',
									false);

						$("#cmbPriceFrom").val(response.strPriceFrom);

						if (response.chkPrintBill == 'Y') {
							$("#chkPrintBill").prop('checked', true);
						} else
							$("#chkPrintBill").prop('checked', false);

						$("#cmbApplyDiscountOn").val(
								response.strApplyDiscountOn);

						if (response.chkUseVatAndServiceNoFromPos == 'Y') {
							$("#chkUseVatAndServiceNoFromPos").prop('checked',
									true);
						} else
							$("#chkUseVatAndServiceNoFromPos").prop('checked',
									false);

						if (response.chkManualAdvOrderCompulsory == 'Y') {
							$("#chkManualAdvOrderCompulsory").prop('checked',
									true);
						} else
							$("#chkManualAdvOrderCompulsory").prop('checked',
									false);

						if (response.chkPrintManualAdvOrderOnBill == 'Y') {
							$("#chkPrintManualAdvOrderOnBill").prop('checked',
									true);
						} else
							$("#chkPrintManualAdvOrderOnBill").prop('checked',
									false);
						if (response.chkPrintModifierQtyOnKOT == 'Y') {
							$("#chkPrintModifierQtyOnKOT")
									.prop('checked', true);
						} else
							$("#chkPrintModifierQtyOnKOT").prop('checked',
									false);
						if (response.chkBoxAllowNewAreaMasterFromCustMaster == 'Y') {
							$("#chkBoxAllowNewAreaMasterFromCustMaster").prop(
									'checked', true);
						} else
							$("#chkBoxAllowNewAreaMasterFromCustMaster").prop(
									'checked', false);

						$("#cmbMenuItemSortingOn").val(
								response.strMenuItemSortingOn);

						if (response.chkAllowToCalculateItemWeight == 'Y') {
							$("#chkAllowToCalculateItemWeight").prop('checked',
									true);
						} else
							$("#chkAllowToCalculateItemWeight").prop('checked',
									false);

						$("#cmbMenuItemDisSeq").val(response.strMenuItemDisSeq);

						if (response.chkItemWiseKOTPrintYN == 'Y') {
							$("#chkItemWiseKOTPrintYN").prop('checked', true);
						} else
							$("#chkItemWiseKOTPrintYN").prop('checked', false);
						if (response.chkItemQtyNumpad == 'Y') {
							$("#chkItemQtyNumpad").prop('checked', true);
						} else
							$("#chkItemQtyNumpad").prop('checked', false);
						if (response.chkSlipNoForCreditCardBillYN == 'Y') {
							$("#chkSlipNoForCreditCardBillYN").prop('checked',
									true);
						} else
							$("#chkSlipNoForCreditCardBillYN").prop('checked',
									false);
						if (response.chkPrintKOTToLocalPrinter == 'Y') {
							$("#chkPrintKOTToLocalPrinter").prop('checked',
									true);
						} else
							$("#chkPrintKOTToLocalPrinter").prop('checked',
									false);

						if (response.chkExpDateForCreditCardBillYN == 'Y') {
							$("#chkExpDateForCreditCardBillYN").prop('checked',
									true);
						} else
							$("#chkExpDateForCreditCardBillYN").prop('checked',
									false);
						if (response.chkDelBoyCompulsoryOnDirectBiller == 'Y') {
							$("#chkDelBoyCompulsoryOnDirectBiller").prop(
									'checked', true);
						} else
							$("#chkDelBoyCompulsoryOnDirectBiller").prop(
									'checked', false);
						if (response.chkSelectWaiterFromCardSwipe == 'Y') {
							$("#chkSelectWaiterFromCardSwipe").prop('checked',
									true);
						} else
							$("#chkSelectWaiterFromCardSwipe").prop('checked',
									false);
						if (response.chkEnableSettleBtnForDirectBillerBill == 'Y') {
							$("#chkEnableSettleBtnForDirectBillerBill").prop(
									'checked', true);
						} else
							$("#chkEnableSettleBtnForDirectBillerBill").prop(
									'checked', false);

						if (response.chkMultipleWaiterSelectionOnMakeKOT == 'Y') {
							$("#chkMultipleWaiterSelectionOnMakeKOT").prop(
									'checked', true);
						} else
							$("#chkMultipleWaiterSelectionOnMakeKOT").prop(
									'checked', false);

						if (response.chkDontShowAdvOrderInOtherPOS == 'Y') {
							$("#chkDontShowAdvOrderInOtherPOS").prop('checked',
									true);
						} else
							$("#chkDontShowAdvOrderInOtherPOS").prop('checked',
									false);

						if (response.chkMoveTableToOtherPOS == 'Y') {
							$("#chkMoveTableToOtherPOS").prop('checked', true);
						} else
							$("#chkMoveTableToOtherPOS").prop('checked', false);

						if (response.chkPrintZeroAmtModifierInBill == 'Y') {
							$("#chkPrintZeroAmtModifierInBill").prop('checked',
									true);
						} else
							$("#chkPrintZeroAmtModifierInBill").prop('checked',
									false);
						if (response.chkMoveKOTToOtherPOS == 'Y') {
							$("#chkMoveKOTToOtherPOS").prop('checked', true);
						} else
							$("#chkMoveKOTToOtherPOS").prop('checked', false);
						if (response.chkPointsOnBillPrint == 'Y') {
							$("#chkPointsOnBillPrint").prop('checked', true);
						} else
							$("#chkPointsOnBillPrint").prop('checked', false);
						if (response.chkCalculateTaxOnMakeKOT == 'Y') {
							$("#chkCalculateTaxOnMakeKOT")
									.prop('checked', true);
						} else
							$("#chkCalculateTaxOnMakeKOT").prop('checked',
									false);

						if (response.chkCalculateDiscItemWise == 'Y') {
							$("#chkCalculateDiscItemWise")
									.prop('checked', true);
						} else
							$("#chkCalculateDiscItemWise").prop('checked',
									false);

						if (response.chkTakewayCustomerSelection == 'Y') {
							$("#chkTakewayCustomerSelection").prop('checked',
									true);
						} else
							$("#chkTakewayCustomerSelection").prop('checked',
									false);
						if (response.chkSelectCustAddressForBill == 'Y') {
							$("#chkSelectCustAddressForBill").prop('checked',
									true);
						} else
							$("#chkSelectCustAddressForBill").prop('checked',
									false);
						if (response.chkGenrateMI == 'Y') {
							$("#chkGenrateMI").prop('checked', true);
						} else
							$("#chkGenrateMI").prop('checked', false);

						if (response.chkPopUpToApplyPromotionsOnBill == 'Y') {
							$("#chkPopUpToApplyPromotionsOnBill").prop(
									'checked', true);
						} else
							$("#chkPopUpToApplyPromotionsOnBill").prop(
									'checked', false);
						$("#txtWSClientCode").val(response.strWSClientCode);

						if (response.chkCheckDebitCardBalOnTrans == 'Y') {
							$("#chkCheckDebitCardBalOnTrans").prop('checked',
									true);
						} else
							$("#chkCheckDebitCardBalOnTrans").prop('checked',
									false);

						$("#txtDaysBeforeOrderToCancel").val(
								response.intDaysBeforeOrderToCancel);

						if (response.chkSettlementsFromPOSMaster == 'Y') {
							$("#chkSettlementsFromPOSMaster").prop('checked',
									true);
						} else
							$("#chkSettlementsFromPOSMaster").prop('checked',
									false);

						$("#txtNoOfDelDaysForAdvOrder").val(
								response.intNoOfDelDaysForAdvOrder);

						if (response.chkShiftWiseDayEnd == 'Y') {
							$("#chkShiftWiseDayEnd").prop('checked', true);
						} else
							$("#chkShiftWiseDayEnd").prop('checked', false);

						$("#txtNoOfDelDaysForUrgentOrder").val(
								response.intNoOfDelDaysForUrgentOrder);

						if (response.chkProductionLinkup == 'Y') {
							$("#chkProductionLinkup").prop('checked', true);
						} else
							$("#chkProductionLinkup").prop('checked', false);

						if (response.chkSetUpToTimeForAdvOrder == 'Y') {
							$("#chkSetUpToTimeForAdvOrder").prop('checked',
									true);
						} else
							$("#chkSetUpToTimeForAdvOrder").prop('checked',
									false);

						if (response.chkLockDataOnShift == 'Y') {
							$("#chkLockDataOnShift").prop('checked', true);
						} else
							$("#chkLockDataOnShift").prop('checked', false);

						$("#cmbHH").val(response.strHours);
						$("#cmbMM").val(response.strMinutes);
						$("#cmbAMPM").val(response.strAMPM);
						if (response.strPropertyWiseSalesOrderYN == 'Y') {
							$("#strPropertyWiseSalesOrderYN").prop('checked',
									true);
						} else
							$("#strPropertyWiseSalesOrderYN").prop('checked',
									false);
						if (response.strEnableBillSeries == 'Y') {
							$("#chkEnableBillSeries").prop('checked', true);
						} else
							$("#chkEnableBillSeries").prop('checked', false);

						if (response.chkSetUpToTimeForUrgentOrder == 'Y') {
							$("#chkSetUpToTimeForUrgentOrder").prop('checked',
									true);
						} else
							$("#chkSetUpToTimeForUrgentOrder").prop('checked',
									false);

						if (response.chkEnablePMSIntegration == 'Y') {
							$("#chkEnablePMSIntegration").prop('checked', true);
						} else
							$("#chkEnablePMSIntegration")
									.prop('checked', false);

						$("#cmbHoursUrgentOrder").val(
								response.strHoursUrgentOrder);
						$("#cmbMinutesUrgentOrder").val(
								response.strMinutesUrgentOrder);
						$("#cmbToAMPM").val(response.strAMPMUrgent);

						if (response.chkPrintTimeOnBill == 'Y') {
							$("#chkPrintTimeOnBill").prop('checked', true);
						} else
							$("#chkPrintTimeOnBill").prop('checked', false);

						if (response.chkCarryForwardFloatAmtToNextDay == 'Y') {
							$("#chkCarryForwardFloatAmtToNextDay").prop(
									'checked', true);
						} else
							$("#chkCarryForwardFloatAmtToNextDay").prop(
									'checked', false);

						if (response.chkPrintRemarkAndReasonForReprint == 'Y') {
							$("#chkPrintRemarkAndReasonForReprint").prop(
									'checked', true);
						} else
							$("#chkPrintRemarkAndReasonForReprint").prop(
									'checked', false);

						if (response.chkShowItemDtlsForChangeCustomerOnBill == 'Y') {
							$("#chkShowItemDtlsForChangeCustomerOnBill").prop(
									'checked', true);
						} else
							$("#chkShowItemDtlsForChangeCustomerOnBill").prop(
									'checked', false);

						if (response.chkEnableBothPrintAndSettleBtnForDB == 'Y') {
							$("#chkEnableBothPrintAndSettleBtnForDB").prop(
									'checked', true);
						} else
							$("#chkEnableBothPrintAndSettleBtnForDB").prop(
									'checked', false);

						if (response.chkShowPopUpForNextItemQuantity == 'Y') {
							$("#chkShowPopUpForNextItemQuantity").prop(
									'checked', true);
						} else
							$("#chkShowPopUpForNextItemQuantity").prop(
									'checked', false);

						if (response.chkOpenCashDrawerAfterBillPrint == 'Y') {
							$("#chkOpenCashDrawerAfterBillPrint").prop(
									'checked', true);
						} else
							$("#chkOpenCashDrawerAfterBillPrint").prop(
									'checked', false);

						if (response.chkPropertyWiseSalesOrder == 'Y') {
							$("#chkPropertyWiseSalesOrder").prop('checked',
									true);
						} else
							$("#chkPropertyWiseSalesOrder").prop('checked',
									false);
						$("#txtShowPopItemsOfDays").val(
								response.intShowPopItemsOfDays);
						$("#txtRoundOff").val(response.dblRoundOff);
						$("#txtSenderEmailId").val(response.strSenderEmailId);
						$("#txtEmailPassword").val(response.strEmailPassword);
						$("#txtEmailConfirmPassword").val(
								response.strEmailPassword);
						$("#cmbEmailServerName").val(
								response.strEmailServerName);
						$("#txtReceiverEmailId").val(
								response.strReceiverEmailId);
						$("#txtDBBackupReceiverEmailId").val(response.strDBBackupReceiverEmailId);
						$("#txtBodyPart").val(response.strBodyPart);

						$("#cmbCardIntfType").val(response.strCardIntfType);
						$("#cmbRFIDSetup").val(response.strRFIDSetup);
						
					
						$("#txtRFIDServerName").val(response.strRFIDServerName);
						$("#txtRFIDUserName").val(response.strRFIDUserName);
						$("#txtRFIDPassword").val(response.strRFIDPassword);
						$("#txtRFIDDatabaseName").val(
								response.strRFIDDatabaseName);

						$("#cmbCRM").val(response.strCRM);
						$("#txtGetWebservice").val(response.strGetWebservice);
						$("#txtPostWebservice").val(response.strPostWebservice);
						$("#txtOutletUID").val(response.strOutletUID);
						$("#txtPOSID").val(response.strPOSID);

						$("#cmbSMSType").val(response.strSMSType);
						$("#txtAreaSMSApi").val(response.strAreaSMSApi);
						if (response.chkHomeDelSMS == 'Y') {
							$("#chkHomeDelSMS").prop('checked', true);
						} else
							$("#chkHomeDelSMS").prop('checked', false);

						$("#txtAreaSendHomeDeliverySMS").val(
								response.strAreaSendHomeDeliverySMS);
						if (response.chkBillSettlementSMS == 'Y') {
							$("#chkBillSettlementSMS").prop('checked', true);
						} else
							$("#chkBillSettlementSMS").prop('checked', false);

						$("#txtAreaBillSettlementSMS").val(
								response.strAreaBillSettlementSMS);

						$("#txtFTPAddress").val(response.strFTPAddress);
						$("#txtFTPServerUserName").val(
								response.strFTPServerUserName);
						$("#txtFTPServerPass").val(response.strFTPServerPass);

						$("#cmbCMSIntegrationYN").val(
								response.strCMSIntegrationYN);
						$("#txtCMSWesServiceURL").val(
								response.strCMSWesServiceURL);
						if (response.chkMemberAsTable == 'Y') {
							$("#chkMemberAsTable").prop('checked', true);
						} else
							$("#chkMemberAsTable").prop('checked', false);

						if (response.chkMemberCodeForKOTJPOS == 'Y') {
							$("#chkMemberCodeForKOTJPOS").prop('checked', true);
						} else
							$("#chkMemberCodeForKOTJPOS")
									.prop('checked', false);

						if (response.chkMemberCodeForKotInMposByCardSwipe == 'Y') {
							$("#chkMemberCodeForKotInMposByCardSwipe").prop(
									'checked', true);
						} else
							$("#chkMemberCodeForKotInMposByCardSwipe").prop(
									'checked', false);

						if (response.chkMemberCodeForMakeBillInMPOS == 'Y') {
							$("#chkMemberCodeForMakeBillInMPOS").prop(
									'checked', true);
						} else
							$("#chkMemberCodeForMakeBillInMPOS").prop(
									'checked', false);

						if (response.chkMemberCodeForKOTMPOS == 'Y') {
							$("#chkMemberCodeForKOTMPOS").prop('checked', true);
						} else
							$("#chkMemberCodeForKOTMPOS")
									.prop('checked', false);

						if (response.chkSelectCustomerCodeFromCardSwipe == 'Y') {
							$("#chkSelectCustomerCodeFromCardSwipe").prop(
									'checked', true);
						} else
							$("#chkSelectCustomerCodeFromCardSwipe").prop(
									'checked', false);

						$("#cmbCMSPostingType").val(response.strCMSPostingType);
						$("#cmbPOSForDayEnd").val(response.strPOSForDayEnd);

						$("#cmbInrestoPOSIntegrationYN").val(
								response.strInrestoPOSIntegrationYN);
						$("#txtInrestoPOSWesServiceURL").val(
								response.strInrestoPOSWesServiceURL);
						$("#txtInrestoPOSId").val(response.strInrestoPOSId);
						$("#txtInrestoPOSKey").val(response.strInrestoPOSKey);

						$("#cmbJioPOSIntegrationYN").val(
								response.strJioPOSIntegrationYN);
						$("#txtJioPOSWesServiceURL").val(
								response.strJioPOSWesServiceURL);

						if (response.chkNewBillSeriesForNewDay == 'Y') {
							$("#chkNewBillSeriesForNewDay").prop('checked',
									true);
						} else
							$("#chkNewBillSeriesForNewDay").prop('checked',
									false);

						if (response.chkShowReportsPOSWise == 'Y') {
							$("#chkShowReportsPOSWise").prop('checked', true);
						} else
							$("#chkShowReportsPOSWise").prop('checked', false);

						if (response.chkEnableDineIn == 'Y') {
							$("#chkEnableDineIn").prop('checked', true);
						} else
							$("#chkEnableDineIn").prop('checked', false);

						if (response.chkAutoAreaSelectionInMakeKOT == 'Y') {
							$("#chkAutoAreaSelectionInMakeKOT").prop('checked',
									true);
						} else
							$("#chkAutoAreaSelectionInMakeKOT").prop('checked',
									false);

						$("#txtJioMID").val(response.strJioMID);
						$("#txtJioTID").val(response.strJioTID);
						$("#txtJioActivationCode").val(
								response.strJioActivationCode);
						$("#txtJioDeviceID").val(response.strJioDeviceID);

						if (response.strAreaWiseCostCenterKOTPrinting == 'Y') {
							$("#chkAreaWiseCostCenterKOTPrinting").prop(
									'checked', true);
						} else
							$("#chkAreaWiseCostCenterKOTPrinting").prop(
									'checked', false);

						$("#cmbDineInAreaForDirectBiller").val(
								response.strDineInAreaForDirectBiller);
						$("#cmbHomeDeliAreaForDirectBiller").val(
								response.strHomeDeliAreaForDirectBiller);
						$("#cmbTakeAwayAreaForDirectBiller").val(
								response.strTakeAwayAreaForDirectBiller);

						if (response.chkRoundOffBillAmount == 'Y') {
							$("#chkRoundOffBillAmount").prop('checked', true);
						} else
							$("#chkRoundOffBillAmount").prop('checked', false);

						if (response.chkPrintItemsOnMoveKOTMoveTable == 'Y') {
							$("#chkPrintItemsOnMoveKOTMoveTable").prop(
									'checked', true);
						} else
							$("#chkPrintItemsOnMoveKOTMoveTable").prop(
									'checked', false);

						$("#txtNoOfDecimalPlaces").val(
								response.intNoOfDecimalPlaces);

						if (response.chkPrintMoveTableMoveKOT == 'Y') {
							$("#chkPrintMoveTableMoveKOT")
									.prop('checked', true);
						} else
							$("#chkPrintMoveTableMoveKOT").prop('checked',
									false);

						if (response.chkSendDBBackupOnMail == 'Y') {
							$("#chkSendDBBackupOnMail").prop('checked', true);
						} else
							$("#chkSendDBBackupOnMail").prop('checked', false);

						if (response.chkPrintQtyTotal == 'Y') {
							$("#chkPrintQtyTotal").prop('checked', true);
						} else
							$("#chkPrintQtyTotal").prop('checked', false);

						if (response.chkPrintOrderNoOnBill == 'Y') {
							$("#chkPrintOrderNoOnBill").prop('checked', true);
						} else
							$("#chkPrintOrderNoOnBill").prop('checked', false);

						if (response.chkAutoAddKOTToBill == 'Y') {
							$("#chkAutoAddKOTToBill").prop('checked', true);
						} else
							$("#chkAutoAddKOTToBill").prop('checked', false);

						if (response.chkPrintDeviceUserDtlOnKOT == 'Y') {
							$("#chkPrintDeviceUserDtlOnKOT").prop('checked',
									true);
						} else
							$("#chkPrintDeviceUserDtlOnKOT").prop('checked',
									false);

						if (response.chkFireCommunication == 'Y') {
							$("#chkFireCommunication").prop('checked', true);
						} else
							$("#chkFireCommunication").prop('checked', false);

						if (response.chkLockTableForWaiter == 'Y') {
							$("#chkLockTableForWaiter").prop('checked', true);
						} else
							$("#chkLockTableForWaiter").prop('checked', false);
						if (response.strAreaWiseCostCenterKOTPrintingYN == 'Y') {
							$("#strAreaWiseCostCenterKOTPrintingYN").prop(
									'checked', true);
						} else
							$("#strAreaWiseCostCenterKOTPrintingYN").prop(
									'checked', false);
						if (response.strMergeAllKOTSToBill == 'Y') {
							$("#strMergeAllKOTSToBill").prop('checked', true);
						} else
							$("#strMergeAllKOTSToBill").prop('checked', false);
						if (response.strPrintOriginalOnBill == 'Y') {
							$("#chkPrintOriginalOnBill").prop('checked', true);
						} else
							$("#chkPrintOriginalOnBill").prop('checked', false);

						$("#cmbRemoveServiceChargeTaxCode").val(
								response.strRemoveServiceChargeTaxCode);
						$("#cmbShowReportsInCurrency").val(
								response.strShowReportsInCurrency);
						$("#cmbPOSToMMSPostingCurrency").val(
								response.strPOSToMMSPostingCurrency);
						$("#cmbPOSToWebBooksPostingCurrency").val(
								response.strPOSToWebBooksPostingCurrency);
						$("#txtUSDCrrencyConverionRate").val(
								response.dblUSDCrrencyConverionRate);

						$("cmbBenowPOSIntegrationYN").val(
								response.strBenowPOSIntegrationYN);
						$("#txtMerchantCode").val(response.strMerchantCode);
						$("#txtXEmail").val(response.strXEmail);
						$("#txtAuthenticationKey").val(
								response.strAuthenticationKey);
						$("#txtSalt").val(response.strSalt);

						$("#txtWERAMerchantOutletId").val(
								response.strWERAMerchantOutletId);
						$("#cmbPostMMSSalesEffectCostOrLoc").val(
								response.strPostMMSSalesEffectCostOrLoc);
						if (response.chkEnableNFCInterface == 'Y') {
							$("#chkEnableNFCInterface").prop('checked', true);
						} else
							$("#chkEnableNFCInterface").prop('checked', false);

						if (response.strUserWiseShowBill == 'Y') {
							$("#strUserWiseShowBill").prop('checked', true);
						} else
							$("#strUserWiseShowBill").prop('checked', false);

						$("#cmbHomeDeliveryAreaForDirectBiller").val(
								response.strHomeDeliveryAreaForDirectBiller);
						$("#cmbEffectOfSales").val(response.strEffectOfSales);

						if (response.strSkipWaiterAndPax == 'Y') {
							$("#strSkipWaiterAndPax").prop('checked', true);
						} else {
							$("#strSkipWaiterAndPax").prop('checked', false);
						}
						if (response.strShortNameOnDirectBillerAndBill == 'Y') {
							$("#strShortNameOnDirectBillerAndBill").prop(
									'checked', true);
						} else {
							$("#strShortNameOnDirectBillerAndBill").prop(
									'checked', false);
						}

						if (response.strClearAllTrasactionAtDayEnd == 'Y') {
							$("#strClearAllTrasactionAtDayEnd").prop('checked',
									true);
						} else {
							$("#strClearAllTrasactionAtDayEnd").prop('checked',
									false);
						}

						if (response.strCashDenominationCompulsary == 'Y') {
							$("#strCashDenominationCompulsary").prop('checked',
									true);
						} else {
							$("#strCashDenominationCompulsary").prop('checked',
									false);
						}

						if (response.strCashManagementCompulsary == 'Y') {
							$("#strCashManagementCompulsary").prop('checked',
									true);
						} else {
							$("#strCashManagementCompulsary").prop('checked',
									false);
						}
						if(response.strPrintFullVoidBill == 'Y'){
							$("#strPrintFullVoidBill").prop('checked',
									true);
						} else {
							$("#strPrintFullVoidBill").prop('checked',
									false);
						}
						if(response.strShowNotificationsOnTransaction == 'Y'){
							$("#strShowNotificationsOnTransaction").prop('checked',
									true);
						} else {
							$("#strShowNotificationsOnTransaction").prop('checked',
									false);
						}
						
						if (response.strVoidBill == 'Y') {
							$("#chkVoidBill").prop('checked', true);
						} else
							$("#chkVoidBill").prop('checked', false);
						if (response.strSettleBill == 'Y') {
							$("#chkSettleBill").prop('checked', true);
						} else
							$("#chkSettleBill").prop('checked', false);
						if (response.strModifyBill == 'Y') {
							$("#chkModifyBill").prop('checked', true);
						} else
							$("#chkModifyBill").prop('checked', false);
						if (response.strComplimentaryBill == 'Y') {
							$("#chkComplimentaryBill").prop('checked', true);
						} else
							$("#chkComplimentaryBill").prop('checked', false);

						if (response.strDayEndSMSYN == 'Y') {
							$("#chkDayEndSMSYN").prop('checked', true);
						} else
							$("#chkDayEndSMSYN").prop('checked', false);

						if (response.strVoidKOTSMSYN == 'Y') {
							$("#chkVoidKOTSMSYN").prop('checked', true);
						} else
							$("#chkVoidKOTSMSYN").prop('checked', false);

						if (response.strNCKOTSMSYN == 'Y') {
							$("#chkNCKOTSMSYN").prop('checked', true);
						} else
							$("#chkNCKOTSMSYN").prop('checked', false);
						if (response.strVoidAdvOrderSMSYN == 'Y') {
							$("#chkVoidAdvOrderSMSYN").prop('checked', true);
						} else
							$("#chkVoidAdvOrderSMSYN").prop('checked', false);
						
						$("#txtEmailSmtpPort").val(response.strEmailSmtpPort);
						$("#txtEmailSmtpHost").val(response.strEmailSmtpHost);

						

						funLoadPrinterDtl();
						//funSetSelectedBillSeries();

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

	function btnAdd_onclick() {
		var table = document.getElementById("tblSelectedTypeDtl");
		var rowCount = table.rows.length;
		var flag = false;
		var code;
		var name;
		if (rowCount > 0) {
			$('#tblSelectedTypeDtl tr').each(
					function() {

						var checkbox = $(this).find("input[type='checkbox']");

						if (checkbox.prop("checked")) {
							if (!flag) {
								code = $(this).find("input[name='strCode']")
										.val();
								name = $(this).find("input[name='strName']")
										.val();
							} else {
								code = code
										+ ","
										+ $(this).find("input[name='strCode']")
												.val();
								name = name
										+ ","
										+ $(this).find("input[name='strName']")
												.val();

							}
							flag = true;

						}

					});
			$('#tblSelectedTypeDtl tr').has("input[type='checkbox']:checked")
					.remove()

			if (!flag) {
				alert("Please Select The Item.");
				return false;
			} else {
				funAddBillseriesDtlRow(code, name);
			}
		}

	}
	var cnt = 0;
	function btnRemove_onclick() {
		var table = document.getElementById("tblBillseriesDtl");
		var rowCount = table.rows.length;
		var flag = false;

		if (rowCount > 0) {
			$('#tblBillseriesDtl tr').each(
					function() {

						var checkbox = $(this).find("input[id='chkRemove']");
						var i = parseInt($(this).find("input[name='serialNo']")
								.val());
						if (checkbox.prop("checked")) {
							var code = $(this).find(
									"input[name='listBillSeriesDtl[" + (i - 1)
											+ "].strCodes']").val();
							var name = $(this).find(
									"input[name='listBillSeriesDtl[" + (i - 1)
											+ "].strNames']").val();

							funAddSelectedTypeRow(code, name);
							flag = true;

							cnt++;
						}

					});
			$('#tblBillseriesDtl tr').has("input[id='chkRemove']:checked")
					.remove()
			var table = document.getElementById("tblBillseriesDtl");
			var rowCount = table.rows.length;
			if (rowCount == 0)
				document.getElementById("cmbSelectedType").disabled = false;
			if (!flag) {
				alert("Please Select The Item.");
				return false;
			}

		}

	}
	function funGetSelectedRowIndex(obj) {
		selectedRowIndex = obj.parentNode.parentNode.rowIndex;
	}

	//Load the data when we open the form
	function funFillPOSData() {

		var searchurl = getContextPath() + "/loadPOSPropertySetupData.html";
		$.ajax({
					type : "GET",
					url : searchurl,
					dataType : "json",
					success : function(response) {
						$("#cmbPosCode").val(response.strPosCode);
						$("#cmbCity").val(response.strCity);

						$("#txtClientCode").val(response.strClientCode);
						$("#txtClientName").val(response.strClientName);
						$("#txtAddrLine1").val(response.strAddrLine1);
						$("#txtAddrLine2").val(response.strAddrLine2);
						$("#txtAddrLine3").val(response.strAddrLine3);
						$("#txtPinCode").val(response.strPinCode);
						$("#cmbState").val(response.strState);
						$("#cmbCountry").val(response.strCountry);
						$("#txtTelephone").val(response.strTelephone);
						$("#txtEmail").val(response.strEmail);
						$("#cmbNatureOfBussness").val(
								response.strNatureOfBussness);

						$("#txtBillFooter").val(response.strBillFooter);

						$("#cmbBillPaperSize").val(response.intBiilPaperSize);
						$("#cmbPrintMode").val(response.strBillPrintMode);
						$("#cmbColumnSize").val(response.intColumnSize);
						$("#cmbPrintType").val(response.strPrintingType);
						$("#cmbBillFormatType").val(response.strBillFormatType);

						if (response.chkShowBills == 'Y') {
							$("#chkShowBills").prop('checked', true);
						}
						if (response.chkNegBilling == 'Y') {
							$("#chkNegBilling").prop('checked', true);
						}
						if (response.chkPrintKotForDirectBiller == 'Y') {
							$("#chkPrintKotForDirectBiller").prop('checked',
									true);
						}
						if (response.chkEnableKOT == 'Y') {
							$("#chkEnableKOT").prop('checked', true);
						}
						if (response.chkMultiBillPrint == 'Y') {
							$("#chkMultiBillPrint").prop('checked', true);
						}
						if (response.chkDayEnd == 'Y') {
							$("#chkDayEnd").prop('checked', true);
						}
						if (response.chkPrintShortNameOnKOT == 'Y') {
							$("#chkPrintShortNameOnKOT").prop('checked', true);
						}
						if (response.chkMultiKOTPrint == 'Y') {
							$("#chkMultiKOTPrint").prop('checked', true);
						}
						if (response.chkPrintInvoiceOnBill == 'Y') {
							$("#chkPrintInvoiceOnBill").prop('checked', true);
						}

						if (response.chkPrintTDHItemsInBill == 'Y') {
							$("#chkPrintTDHItemsInBill").prop('checked', true);
						}
						if (response.chkManualBillNo == 'Y') {
							$("#chkManualBillNo").prop('checked', true);
						}
						if (response.chkPrintInclusiveOfAllTaxesOnBill == 'Y') {
							$("#chkPrintInclusiveOfAllTaxesOnBill").prop(
									'checked', true);
						}
						if (response.chkEffectOnPSP == 'Y') {
							$("#chkEffectOnPSP").prop('checked', true);
						}
						if (response.chkPrintVatNo == 'Y') {
							$("#chkPrintVatNo").prop('checked', true);
						}
						$("#txtVatNo").val(response.strVatNo);

						$("#txtNoOfLinesInKOTPrint").val(
								response.intNoOfLinesInKOTPrint);
						if (response.chkServiceTaxNo == 'Y') {
							$("#chkServiceTaxNo").prop('checked', true);
						}

						$("#txtServiceTaxNo").val(response.strServiceTaxNo);

						$("#cmbShowBillsDtlType").val(
								response.strShowBillsDtlType);
						$("#txtAdvRecPrintCount").val(
								response.strAdvRecPrintCount);

						$("#cmbPOSType").val(response.strPOSType);
						$("#cmbDataSendFrequency").val(
								response.strDataSendFrequency);
						$("#txtWebServiceLink").val(response.strWebServiceLink);
						$("#dteHOServerDate").val(response.dteHOServerDate);
						$("#cmbChangeTheme").val(response.strChangeTheme);
						$("#cmbDirectArea").val(response.strDirectArea);

						if (response.chkAreaWisePricing == 'Y') {
							$("#chkAreaWisePricing").prop('checked', true);
						}
						$("#txtCustSeries").val(response.longCustSeries);

						if (response.chkSlabBasedHomeDelCharges == 'Y') {
							$("#chkSlabBasedHomeDelCharges").prop('checked',
									true);
						}
						if (response.chkEditHomeDelivery == 'Y') {
							$("#chkEditHomeDelivery").prop('checked', true);
						}
						if (response.chkPrintForVoidBill == 'Y') {
							$("#chkPrintForVoidBill").prop('checked', true);
						}
						if (response.chkDirectKOTPrintMakeKOT == 'Y') {
							$("#chkDirectKOTPrintMakeKOT")
									.prop('checked', true);
						}
						if (response.chkSkipPaxSelection == 'Y') {
							$("#chkSkipPaxSelection").prop('checked', true);
						}
						if (response.chkPrintInvoiceOnBill == 'Y') {
							$("#chkPrintInvoiceOnBill").prop('checked', true);
						}
						if (response.chkAreaMasterCompulsory == 'Y') {
							$("#chkAreaMasterCompulsory").prop('checked', true);
						}
						if (response.chkPostSalesDataToMMS == 'Y') {
							$("#chkPostSalesDataToMMS").prop('checked', true);
						}
						$("#cmbItemType").val(response.strItemType);

						if (response.chkPrinterErrorMessage == 'Y') {
							$("#chkPrinterErrorMessage").prop('checked', true);
						}
						if (response.chkActivePromotions == 'Y') {
							$("#chkActivePromotions").prop('checked', true);
						}
						if (response.chkPrintKOTYN == 'Y') {
							$("#chkPrintKOTYN").prop('checked', true);
						}
						if (response.chkChangeQtyForExternalCode == 'Y') {
							$("#chkChangeQtyForExternalCode").prop('checked',
									true);
						}

						$("#cmbStockInOption").val(response.strStockInOption);

						if (response.chkShowItemStkColumnInDB == 'Y') {
							$("#chkShowItemStkColumnInDB")
									.prop('checked', true);
						}

						$("#cmbPriceFrom").val(response.strPriceFrom);

						if (response.chkPrintBill == 'Y') {
							$("#chkPrintBill").prop('checked', true);
						}

						$("#cmbApplyDiscountOn").val(
								response.strApplyDiscountOn);

						if (response.chkUseVatAndServiceNoFromPos == 'Y') {
							$("#chkUseVatAndServiceNoFromPos").prop('checked',
									true);
						}

						if (response.chkManualAdvOrderCompulsory == 'Y') {
							$("#chkManualAdvOrderCompulsory").prop('checked',
									true);
						}

						if (response.chkPrintManualAdvOrderOnBill == 'Y') {
							$("#chkPrintManualAdvOrderOnBill").prop('checked',
									true);
						}
						if (response.chkPrintModifierQtyOnKOT == 'Y') {
							$("#chkPrintModifierQtyOnKOT")
									.prop('checked', true);
						}
						if (response.chkBoxAllowNewAreaMasterFromCustMaster == 'Y') {
							$("#chkBoxAllowNewAreaMasterFromCustMaster").prop(
									'checked', true);
						}
						$("#cmbMenuItemSortingOn").val(
								response.strMenuItemSortingOn);

						if (response.chkAllowToCalculateItemWeight == 'Y') {
							$("#chkAllowToCalculateItemWeight").prop('checked',
									true);
						}

						$("#cmbMenuItemDisSeq").val(response.strMenuItemDisSeq);

						if (response.chkItemWiseKOTPrintYN == 'Y') {
							$("#chkItemWiseKOTPrintYN").prop('checked', true);
						}
						if (response.chkItemQtyNumpad == 'Y') {
							$("#chkItemQtyNumpad").prop('checked', true);
						}
						if (response.chkSlipNoForCreditCardBillYN == 'Y') {
							$("#chkSlipNoForCreditCardBillYN").prop('checked',
									true);
						}
						if (response.chkPrintKOTToLocalPrinter == 'Y') {
							$("#chkPrintKOTToLocalPrinter").prop('checked',
									true);
						}

						if (response.chkExpDateForCreditCardBillYN == 'Y') {
							$("#chkExpDateForCreditCardBillYN").prop('checked',
									true);
						}
						if (response.chkDelBoyCompulsoryOnDirectBiller == 'Y') {
							$("#chkDelBoyCompulsoryOnDirectBiller").prop(
									'checked', true);
						}
						if (response.chkSelectWaiterFromCardSwipe == 'Y') {
							$("#chkSelectWaiterFromCardSwipe").prop('checked',
									true);
						}
						if (response.chkEnableSettleBtnForDirectBillerBill == 'Y') {
							$("#chkEnableSettleBtnForDirectBillerBill").prop(
									'checked', true);
						}

						if (response.chkMultipleWaiterSelectionOnMakeKOT == 'Y') {
							$("#chkMultipleWaiterSelectionOnMakeKOT").prop(
									'checked', true);
						}

						if (response.chkDontShowAdvOrderInOtherPOS == 'Y') {
							$("#chkDontShowAdvOrderInOtherPOS").prop('checked',
									true);
						}

						if (response.chkMoveTableToOtherPOS == 'Y') {
							$("#chkMoveTableToOtherPOS").prop('checked', true);
						}

						if (response.chkPrintZeroAmtModifierInBill == 'Y') {
							$("#chkPrintZeroAmtModifierInBill").prop('checked',
									true);
						}
						if (response.chkMoveKOTToOtherPOS == 'Y') {
							$("#chkMoveKOTToOtherPOS").prop('checked', true);
						}
						if (response.chkPointsOnBillPrint == 'Y') {
							$("#chkPointsOnBillPrint").prop('checked', true);
						}
						if (response.chkCalculateTaxOnMakeKOT == 'Y') {
							$("#chkCalculateTaxOnMakeKOT")
									.prop('checked', true);
						}
						if (response.chkCalculateDiscItemWise == 'Y') {
							$("#chkCalculateDiscItemWise")
									.prop('checked', true);
						}
						if (response.chkTakewayCustomerSelection == 'Y') {
							$("#chkTakewayCustomerSelection").prop('checked',
									true);
						}
						if (response.chkSelectCustAddressForBill == 'Y') {
							$("#chkSelectCustAddressForBill").prop('checked',
									true);
						}
						if (response.chkGenrateMI == 'Y') {
							$("#chkGenrateMI").prop('checked', true);
						}

						if (response.chkPopUpToApplyPromotionsOnBill == 'Y') {
							$("#chkPopUpToApplyPromotionsOnBill").prop(
									'checked', true);
						}
						$("#txtWSClientCode").val(response.strWSClientCode);

						if (response.chkCheckDebitCardBalOnTrans == 'Y') {
							$("#chkCheckDebitCardBalOnTrans").prop('checked',
									true);
						} else
							$("#chkCheckDebitCardBalOnTrans").prop('checked',
									false);

						$("#txtDaysBeforeOrderToCancel").val(
								response.intDaysBeforeOrderToCancel);

						if (response.chkSettlementsFromPOSMaster == 'Y') {
							$("#chkSettlementsFromPOSMaster").prop('checked',
									true);
						}

						/* $("#txtNoOfDelDaysForUrgentOrder").val(
								response.intNoOfDelDaysForUrgentOrder); */
						$("#txtNoOfDelDaysForAdvOrder").val(
								response.intNoOfDelDaysForAdvOrder);

						if (response.chkShiftWiseDayEnd == 'Y') {
							$("#chkShiftWiseDayEnd").prop('checked', true);
						}
						$("#txtNoOfDelDaysForUrgentOrder").val(
								response.intNoOfDelDaysForUrgentOrder);

						if (response.chkProductionLinkup == 'Y') {
							$("#chkProductionLinkup").prop('checked', true);
						} else
							$("#chkProductionLinkup").prop('checked', false);

						if (response.chkSetUpToTimeForAdvOrder == 'Y') {
							$("#chkSetUpToTimeForAdvOrder").prop('checked',
									true);
						}
						if (response.chkLockDataOnShift == 'Y') {
							$("#chkLockDataOnShift").prop('checked', true);
						}

						//$("#cmbSendTableReservation").val(response.strHours);

						$("#cmbHH").val(response.strHours);
						$("#cmbMM").val(response.strMinutes);
						$("#cmbAMPM").val(response.strAMPM);
						$("#txtSMSMobileNo").val(response.longSMSMobileNo);

						$("#cmbHomeDeliveryAreaForDirectBiller").val(
								response.strHomeDeliveryAreaForDirectBiller);

						if (response.strEnableBillSeries == 'Y') {
							$("#chkEnableBillSeries").prop('checked', true);
						}
						if (response.chkSetUpToTimeForUrgentOrder == 'Y') {
							$("#chkSetUpToTimeForUrgentOrder").prop('checked',
									true);
						}

						if (response.chkEnablePMSIntegration == 'Y') {
							$("#chkEnablePMSIntegration").prop('checked', true);
						}
						$("#cmbHoursUrgentOrder").val(
								response.strHoursUrgentOrder);
						$("#cmbMinutesUrgentOrder").val(
								response.strMinutesUrgentOrder);
						$("#cmbToAMPM").val(response.strAMPMUrgent);

						if (response.chkPrintTimeOnBill == 'Y') {
							$("#chkPrintTimeOnBill").prop('checked', true);
						}
						if (response.chkCarryForwardFloatAmtToNextDay == 'Y') {
							$("#chkCarryForwardFloatAmtToNextDay").prop(
									'checked', true);
						}
						if (response.chkPrintRemarkAndReasonForReprint == 'Y') {
							$("#chkPrintRemarkAndReasonForReprint").prop(
									'checked', true);
						}

						if (response.chkShowItemDtlsForChangeCustomerOnBill == 'Y') {
							$("#chkShowItemDtlsForChangeCustomerOnBill").prop(
									'checked', true);
						}

						if (response.chkEnableBothPrintAndSettleBtnForDB == 'Y') {
							$("#chkEnableBothPrintAndSettleBtnForDB").prop(
									'checked', true);
						}

						if (response.chkShowPopUpForNextItemQuantity == 'Y') {
							$("#chkShowPopUpForNextItemQuantity").prop(
									'checked', true);
						}

						if (response.chkOpenCashDrawerAfterBillPrint == 'Y') {
							$("#chkOpenCashDrawerAfterBillPrint").prop(
									'checked', true);
						}
						if (response.chkPropertyWiseSalesOrder == 'Y') {
							$("#chkPropertyWiseSalesOrder").prop('checked',
									true);
						}

						$("#txtSenderEmailId").val(response.strSenderEmailId);
						$("#txtEmailPassword").val(response.strEmailPassword);
						$("#txtEmailConfirmPassword").val(
								response.strEmailPassword);
						$("#cmbEmailServerName").val(
								response.strEmailServerName);
						$("#txtReceiverEmailId").val(
								response.strReceiverEmailId);
						$("#txtDBBackupReceiverEmailId").val(response.strDBBackupReceiverEmailId);
						$("#txtBodyPart").val(response.strBodyPart);

						$("#cmbCardIntfType").val(response.strCardIntfType);
						$("#cmbRFIDSetup").val(response.strRFIDSetup);
						$("#txtRFIDServerName").val(response.strRFIDServerName);
						$("#txtRFIDUserName").val(response.strRFIDUserName);
						$("#txtRFIDPassword").val(response.strRFIDPassword);
						$("#txtRFIDDatabaseName").val(
								response.strRFIDDatabaseName);

						$("#cmbCRM").val(response.strCRM);
						$("#txtGetWebservice").val(response.strGetWebservice);
						$("#txtPostWebservice").val(response.strPostWebservice);
						$("#txtOutletUID").val(response.strOutletUID);
						$("#txtPOSID").val(response.strPOSID);

						$("#cmbSMSType").val(response.strSMSType);
						$("#txtAreaSMSApi").val(response.strAreaSMSApi);
						if (response.chkHomeDelSMS == 'Y') {
							$("#chkHomeDelSMS").prop('checked', true);
						}

						$("#txtAreaSendHomeDeliverySMS").val(
								response.strAreaSendHomeDeliverySMS);
						if (response.chkBillSettlementSMS == 'Y') {
							$("#chkBillSettlementSMS").prop('checked', true);
						}

						$("#txtAreaBillSettlementSMS").val(
								response.strAreaBillSettlementSMS);

						$("#txtFTPAddress").val(response.strFTPAddress);
						$("#txtFTPServerUserName").val(
								response.strFTPServerUserName);
						$("#txtFTPServerPass").val(response.strFTPServerPass);

						$("#cmbCMSIntegrationYN").val(
								response.strCMSIntegrationYN);
						$("#txtCMSWesServiceURL").val(
								response.strCMSWesServiceURL);
						if (response.chkMemberAsTable == 'Y') {
							$("#chkMemberAsTable").prop('checked', true);
						}
						if (response.chkMemberCodeForKOTJPOS == 'Y') {
							$("#chkMemberCodeForKOTJPOS").prop('checked', true);
						}
						if (response.chkMemberCodeForKotInMposByCardSwipe == 'Y') {
							$("#chkMemberCodeForKotInMposByCardSwipe").prop(
									'checked', true);
						}
						if (response.chkMemberCodeForMakeBillInMPOS == 'Y') {
							$("#chkMemberCodeForMakeBillInMPOS").prop(
									'checked', true);
						}
						if (response.chkMemberCodeForKOTMPOS == 'Y') {
							$("#chkMemberCodeForKOTMPOS").prop('checked', true);
						}
						if (response.chkSelectCustomerCodeFromCardSwipe == 'Y') {
							$("#chkSelectCustomerCodeFromCardSwipe").prop(
									'checked', true);
						}
						$("#cmbCMSPostingType").val(response.strCMSPostingType);
						$("#cmbPOSForDayEnd").val(response.strPOSForDayEnd);

						$("#cmbInrestoPOSIntegrationYN").val(
								response.strInrestoPOSIntegrationYN);
						$("#txtInrestoPOSWesServiceURL").val(
								response.strInrestoPOSWesServiceURL);
						$("#txtInrestoPOSId").val(response.strInrestoPOSId);
						$("#txtInrestoPOSKey").val(response.strInrestoPOSKey);

						$("#cmbJioPOSIntegrationYN").val(
								response.strJioPOSIntegrationYN);
						$("#txtJioPOSWesServiceURL").val(
								response.strJioPOSWesServiceURL);

						if (response.chkNewBillSeriesForNewDay == 'Y') {
							$("#chkNewBillSeriesForNewDay").prop('checked',
									true);
						}
						if (response.chkShowReportsPOSWise == 'Y') {
							$("#chkShowReportsPOSWise").prop('checked', true);
						}
						if (response.chkEnableDineIn == 'Y') {
							$("#chkEnableDineIn").prop('checked', true);
						}
						if (response.chkAutoAreaSelectionInMakeKOT == 'Y') {
							$("#chkAutoAreaSelectionInMakeKOT").prop('checked',
									true);
						}
						$("#txtJioMID").val(response.strJioMID);
						$("#txtJioTID").val(response.strJioTID);
						$("#txtJioActivationCode").val(
								response.strJioActivationCode);
						$("#txtJioDeviceID").val(response.strJioDeviceID);

						$("#cmbDineInAreaForDirectBiller").val(
								response.strDineInAreaForDirectBiller);
						$("#cmbHomeDeliAreaForDirectBiller").val(
								response.strHomeDeliAreaForDirectBiller);
						$("#cmbTakeAwayAreaForDirectBiller").val(
								response.strTakeAwayAreaForDirectBiller);

						if (response.chkRoundOffBillAmount == 'Y') {
							$("#chkRoundOffBillAmount").prop('checked', true);
						} else
							$("#chkRoundOffBillAmount").prop('checked', false);

						if (response.chkPrintItemsOnMoveKOTMoveTable == 'Y') {
							$("#chkPrintItemsOnMoveKOTMoveTable").prop(
									'checked', true);
						} else
							$("#chkPrintItemsOnMoveKOTMoveTable").prop(
									'checked', false);

						$("#txtNoOfDecimalPlaces").val(
								response.intNoOfDecimalPlaces);

						if (response.chkPrintMoveTableMoveKOT == 'Y') {
							$("#chkPrintMoveTableMoveKOT")
									.prop('checked', true);
						} else
							$("#chkPrintMoveTableMoveKOT").prop('checked',
									false);

						if (response.chkSendDBBackupOnMail == 'Y') {
							$("#chkSendDBBackupOnMail").prop('checked', true);
						} else
							$("#chkSendDBBackupOnMail").prop('checked', false);

						if (response.chkPrintQtyTotal == 'Y') {
							$("#chkPrintQtyTotal").prop('checked', true);
						} else
							$("#chkPrintQtyTotal").prop('checked', false);

						if (response.chkPrintOrderNoOnBill == 'Y') {
							$("#chkPrintOrderNoOnBill").prop('checked', true);
						} else
							$("#chkPrintOrderNoOnBill").prop('checked', false);

						if (response.chkAutoAddKOTToBill == 'Y') {
							$("#chkAutoAddKOTToBill").prop('checked', true);
						} else
							$("#chkAutoAddKOTToBill").prop('checked', false);

						if (response.chkPrintDeviceUserDtlOnKOT == 'Y') {
							$("#chkPrintDeviceUserDtlOnKOT").prop('checked',
									true);
						} else
							$("#chkPrintDeviceUserDtlOnKOT").prop('checked',
									false);

						if (response.chkFireCommunication == 'Y') {
							$("#chkFireCommunication").prop('checked', true);
						} else
							$("#chkFireCommunication").prop('checked', false);

						if (response.chkLockTableForWaiter == 'Y') {
							$("#chkLockTableForWaiter").prop('checked', true);
						} else
							$("#chkLockTableForWaiter").prop('checked', false);
						if (response.strPrintOpenItemsOnBill == 'Y') {
							$("#chkPrintOpenItemsOnBill").prop('checked', true);
						} else
							$("#chkPrintOpenItemsOnBill")
									.prop('checked', false);

						if (response.strShowUnSettlementForm == 'Y') {
							$("#strShowUnSettlementForm").prop('checked', true);
						} else
							$("#strShowUnSettlementForm")
									.prop('checked', false);

						if (response.strScanQRYN == 'Y') {
							$("#strScanQRYN").prop('checked', true);
						} else
							$("#strScanQRYN").prop('checked', false);

						if (response.strAreaWisePromotions == 'Y') {
							$("#chkAreaWisePromotions").prop('checked', true);
						} else
							$("#chkAreaWisePromotions").prop('checked', false);

						if (response.strPrintHomeDeliveryYN == 'Y') {
							$("#chkPrintHomeDeliveryYN").prop('checked', true);
						} else
							$("#chkPrintHomeDeliveryYN").prop('checked', false);

						if (response.strShowPurRateInDirectBiller == 'Y') {
							$("#chkShowPurRateInDirectBiller").prop('checked',
									true);
						} else
							$("#chkShowPurRateInDirectBiller").prop('checked',
									false);

						if (response.strEnableTableReservationForCustomer == 'Y') {
							$("#chkEnableTableReservationForCustomer").prop(
									'checked', true);
						} else
							$("#chkEnableTableReservationForCustomer").prop(
									'checked', false);

						$("#cmbEffectOfSales").val(response.strEffectOfSales);

						if (response.strEnableLockTable == 'Y') {
							$("#chkEnableLockTable").prop('checked', true);
						} else
							$("#chkEnableLockTable").prop('checked', false);

						if (response.strReprintOnSettleBill == 'Y') {
							$("#chkReprintOnSettleBill").prop('checked', true);
						} else
							$("#chkReprintOnSettleBill").prop('checked', false);

						if (response.strPOSWiseItemToMMSProductLinkUpYN == 'Y') {
							$("#chkPOSWiseItemToMMSProductLinkUpYN").prop(
									'checked', true);
						} else
							$("#chkPOSWiseItemToMMSProductLinkUpYN").prop(
									'checked', false);
						if (response.strEnableMasterDiscount == 'Y') {
							$("#chkEnableMasterDiscount").prop('checked', true);
						} else
							$("#chkEnableMasterDiscount")
									.prop('checked', false);

						$("#txtTableReservationSMS").val(
								response.strTableReservationSMS);
						if (response.strSendTableReservationSMS == 'Y') {
							$("#chkSendTableReservationSMS").prop('checked',
									true);
						} else
							$("#chkSendTableReservationSMS").prop('checked',
									false);

						if (response.strAutoShowPopItems == 'Y') {
							$("#chkAutoShowPopItems").prop('checked', true);
						} else
							$("#chkAutoShowPopItems").prop('checked', false);

						$("#txtShowPopItemsOfDays").val(
								response.intShowPopItemsOfDays);
						$("#txtConsolidatedKOTPrinterPort").val(
								response.strConsolidatedKOTPrinterPort);
						$("#cmbConsolidatedKOTPrinterPort").val(
								response.strConsolidatedKOTPrinterPort);
						$("#txtRoundOff").val(response.dblRoundOff);

						$("#cmbRemoveServiceChargeTaxCode").val(
								response.strRemoveServiceChargeTaxCode);
						$("#cmbShowReportsInCurrency").val(
								response.strShowReportsInCurrency);
						$("#cmbPOSToMMSPostingCurrency").val(
								response.strPOSToMMSPostingCurrency);
						$("#cmbPOSToWebBooksPostingCurrency").val(
								response.strPOSToWebBooksPostingCurrency);
						$("#txtUSDCrrencyConverionRate").val(
								response.dblUSDCrrencyConverionRate);

						$("#cmbBenowPOSIntegrationYN").val(
								response.strBenowPOSIntegrationYN);

						$("#txtSalt").val(response.strSalt);
						$("#txtEmail").val(response.strEmail);

						/* $("cmbWeraIntegrationYN").val(
								response.strWERAOnlineOrderIntegration);
						$("txtWERAAuthenticationAPIKey").val(
								response.strWERAAuthenticationAPIKey); 
						 */

						//alert(response.strWERAAuthenticationAPIKey);
						$("#cmbWeraIntegrationYN").val(
								response.strWERAOnlineOrderIntegration);

						/* 	$("txtWeraMerchantOutletId").val(
									response.strWeraMerchantOutletId); */
						$("#txtSuperMerchantCode").val(
								response.strSuperMerchantCode);
						$("#cmbPostMMSSalesEffectCostOrLoc").val(
								response.strPostMMSSalesEffectCostOrLoc);
						if (response.chkEnableNFCInterface == 'Y') {
							$("#chkEnableNFCInterface").prop('checked', true);
						} else
							$("#chkEnableNFCInterface").prop('checked', false);
						if (response.strVoidBill == 'Y') {
							$("#chkVoidBill").prop('checked', true);
						} else
							$("#chkVoidBill").prop('checked', false);
						if (response.strSettleBill == 'Y') {
							$("#chkSettleBill").prop('checked', true);
						} else
							$("#chkSettleBill").prop('checked', false);
						if (response.strModifyBill == 'Y') {
							$("#chkModifyBill").prop('checked', true);
						} else
							$("#chkModifyBill").prop('checked', false);
						if (response.strComplimentaryBill == 'Y') {
							$("#chkComplimentaryBill").prop('checked', true);
						} else
							$("#chkComplimentaryBill").prop('checked', false);

						if (response.strDayEndSMSYN == 'Y') {
							$("#chkDayEndSMSYN").prop('checked', true);
						} else
							$("#chkDayEndSMSYN").prop('checked', false);

						if (response.strVoidKOTSMSYN == 'Y') {
							$("#chkVoidKOTSMSYN").prop('checked', true);
						} else
							$("#chkVoidKOTSMSYN").prop('checked', false);

						if (response.strNCKOTSMSYN == 'Y') {
							$("#chkNCKOTSMSYN").prop('checked', true);
						} else
							$("#chkNCKOTSMSYN").prop('checked', false);
						if (response.strVoidAdvOrderSMSYN == 'Y') {
							$("#chkVoidAdvOrderSMSYN").prop('checked', true);
						} else
							$("#chkVoidAdvOrderSMSYN").prop('checked', false);
						$("#txtAuthenticationKey").val(
								response.strAuthenticationKey);
						$("#txtMerchantCode").val(response.strMerchantCode);
						$("#txtXEmail").val(response.strXEmail);
						$("#cmbShowBillsDtlType").val(
								response.strShowBillsDtlType);
						$("#txtEmailSmtpPort").val(response.strEmailSmtpPort);
						$("#txtEmailSmtpHost").val(response.strEmailSmtpHost);

						if (response.strShowNotificationsOnTransaction == 'Y') {
							$("#strShowNotificationsOnTransaction").prop(
									'checked', true);
						} else
							$("#strShowNotificationsOnTransaction").prop(
									'checked', false);

						if (response.strPrintOriginalOnBill == 'Y') {
							$("#chkPrintOriginalOnBill").prop('checked', true);
						} else
							$("#chkPrintOriginalOnBill").prop('checked', false);
						if (response.strBlankDayEndPrint == 'Y') {
							$("#strBlankDayEndPrint").prop('checked', true);
						} else
							$("#strBlankDayEndPrint").prop('checked', false);
						if (response.strOnlineOrderNotification == 'Y') {
							$("#strOnlineOrderNotification").prop('checked',
									true);
						} else
							$("#strOnlineOrderNotification").prop('checked',
									false);

						if (response.strPostRoundOffToWebBooks == 'Y') {
							$("#chkPostRoundOffToWebBooks").prop('checked',
									true);
						} else
							$("#chkPostRoundOffToWebBooks").prop('checked',
									false);
						if (response.strDisplayTotalShowBill == 'Y') {
							$("#strDisplayTotalShowBill").prop('checked', true);
						} else
							$("#strDisplayTotalShowBill")
									.prop('checked', false);
						if (response.strPostSalesDataToExcise == 'Y') {
							$("#chkPostSalesDataToExcise")
									.prop('checked', true);
						} else
							$("#chkPostSalesDataToExcise").prop('checked',
									false);
						if (response.strMergeAllKOTSToBill == 'Y') {
							$("#strMergeAllKOTSToBill").prop('checked', true);
						} else
							$("#strMergeAllKOTSToBill").prop('checked', false);
						if (response.strAreaWiseCostCenterKOTPrintingYN == 'Y') {
							$("#strAreaWiseCostCenterKOTPrintingYN").prop(
									'checked', true);
						} else
							$("#strAreaWiseCostCenterKOTPrintingYN").prop(
									'checked', false);
						if (response.strPOSWiseItemToMMSProductLinkUpYN == 'Y') {
							$("#strPOSWiseItemToMMSProductLinkUpYN").prop(
									'checked', true);
						} else
							$("#strPOSWiseItemToMMSProductLinkUpYN").prop(
									'checked', false);
						if (response.strSkipWaiterAndPax == 'Y') {
							$("#strSkipWaiterAndPax").prop('checked', true);
						} else
							$("#strSkipWaiterAndPax").prop('checked', false);
						if (response.strPropertyWiseSalesOrderYN == 'Y') {
							$("#strPropertyWiseSalesOrderYN").prop('checked',
									true);
						} else
							$("#strPropertyWiseSalesOrderYN").prop('checked',
									false);

						if (response.strMultipleBillPrinting == 'Y') {
							$("#strMultipleBillPrinting").prop('checked', true);
						} else
							$("#strMultipleBillPrinting")
									.prop('checked', false);
						if (response.strMultipleKOTPrintYN == 'Y') {
							$("#strMultipleKOTPrintYN").prop('checked', true);
						} else
							$("#strMultipleKOTPrintYN").prop('checked', false);
						if (response.strUserWiseShowBill == 'Y') {
							$("#strUserWiseShowBill").prop('checked', true);
						} else
							$("#strUserWiseShowBill").prop('checked', false);
						$("#dblMaxDiscount").val(response.dblMaxDiscount);

						if (response.strShortNameOnDirectBillerAndBill == 'Y') {
							$("#strShortNameOnDirectBillerAndBill").prop(
									'checked', true);
						} else {
							$("#strShortNameOnDirectBillerAndBill").prop(
									'checked', false);
						}

						if (response.strClearAllTrasactionAtDayEnd == 'Y') {
							$("#strClearAllTrasactionAtDayEnd").prop('checked',
									true);
						} else {
							$("#strClearAllTrasactionAtDayEnd").prop('checked',
									false);
						}

						if (response.strCashDenominationCompulsary == 'Y') {
							$("#strCashDenominationCompulsary").prop('checked',
									true);
						} else {
							$("#strCashDenominationCompulsary").prop('checked',
									false);
						}

						if (response.strCashManagementCompulsary == 'Y') {
							$("#strCashManagementCompulsary").prop('checked',
									true);
						} else {
							$("#strCashManagementCompulsary").prop('checked',
									false);
						}
						if(response.strPrintFullVoidBill == 'Y'){
							$("#strPrintFullVoidBill").prop('checked',
									true);
						} else {
							$("#strPrintFullVoidBill").prop('checked',
									false);
						}

						funLoadPrinterDtl();

						//funSetSelectedBillSeries();
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

	function funLoadPrinterDtl() {
		funRemoveTableRows("tblPrinterDtl");

		var searchurl = getContextPath() + "/loadPrinterDtl.html";
		$.ajax({
			type : "GET",
			url : searchurl,
			dataType : "json",
			async : false,
			success : function(response) {
				$.each(response.listPrinterDtl, function(i, item) {
					funFillPrinterDtl(item.strCostCenterCode,
							item.strCostCenterName, item.strPrimaryPrinterPort,
							item.strSecondaryPrinterPort,
							item.strPrintOnBothPrintersYN);
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

	function funFillPrinterDtl(strCode, strName, primaryPrinter,
			secondaryPrinter, strPrintOnBothPrintersYN) {
		var table = document.getElementById("tblPrinterDtl");
		var rowCount = table.rows.length;
		var row = table.insertRow(rowCount);

		row.insertCell(0).innerHTML = "<input type=\"hidden\" name=\"listPrinterDtl["
				+ (rowCount)
				+ "].strCostCenterCode\" readonly=\"readonly\" class=\"Box \" size=\"0%\" id=\"strCodes."
				+ (rowCount) + "\" value='" + strCode + "'>";

		row.insertCell(1).innerHTML = "<input name=\"listPrinterDtl["
				+ (rowCount)
				+ "].strCostCenterName\" readonly=\"readonly\" class=\"Box \" size=\"40%\" id=\"strCostCenterName."
				+ (rowCount) + "\" value='" + strName + "'>";
		row.insertCell(2).innerHTML = "<input name=\"listPrinterDtl["
				+ (rowCount)
				+ "].strPrimaryPrinterPort\" readonly=\"readonly\" class=\"Box \" size=\"20%\" id=\"strPrimaryPrinterPort."
				+ (rowCount) + "\" value='" + primaryPrinter + "'>";
		row.insertCell(3).innerHTML = "<input name=\"listPrinterDtl["
				+ (rowCount)
				+ "].strSecondaryPrinterPort\" readonly=\"readonly\" class=\"Box \" size=\"20%\" id=\"strSecondaryPrinterPort."
				+ (rowCount) + "\" value='" + secondaryPrinter + "'>";
		if (strPrintOnBothPrintersYN == "Y") {
			row.insertCell(4).innerHTML = "<input type=\"checkbox\" name=\"listPrinterDtl["
					+ (rowCount)
					+ "].strPrintOnBothPrintersYN\" size=\"20%\" id=\"chkApplicable."
					+ (rowCount) + "\" checked=\"checked\">";
		} else {
			row.insertCell(4).innerHTML = "<input type=\"checkbox\" name=\"listPrinterDtl["
					+ (rowCount)
					+ "].strPrintOnBothPrintersYN\" size=\"20%\" id=\"chkApplicable."
					+ (rowCount) + "\"value='" + true + "'>";
		}
	}

	function funSetSelectedBillSeries() {
		var posCode = $('#cmbPosCode').val();
		var searchurl = getContextPath()
				+ "/loadOldSBillSeriesSetup.html?posCode=" + posCode;
		$.ajax({
			type : "GET",
			url : searchurl,
			dataType : "text",
			async : false,
			success : function(response) {
				if (response == "") {
					$("#cmbSelectedType").val("Group");
					funFillSelectedTypeDtlTable("Group");
				} else {
					$("#cmbSelectedType").val(response);
					document.getElementById("cmbSelectedType").disabled = true;

					funLoadOldBillSeries();
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
	function funRemoveTableRows(tblId) {

		var table = document.getElementById(tblId);
		var rowCount = table.rows.length;

		while (rowCount > 0) {
			table.deleteRow(0);
			rowCount--;
		}
	}
	function funFillSelectedTypeDtlTable() {
		funRemoveTableRows("tblSelectedTypeDtl");
		var strType = $('#cmbSelectedType').val();
		var searchurl = getContextPath()
				+ "/loadSelectedTypeDtlTable.html?strType=" + strType;
		$.ajax({
			type : "GET",

			url : searchurl,
			dataType : "json",
			success : function(response) {
				switch (strType) {
				case "Group":
					$.each(response, function(i, item) {

						funFillSelectedTypeDtl(strType, item.strGroupCode,
								item.strGroupName);
					});
					break;
				case "Sub Group":
					$.each(response, function(i, item) {
						funFillSelectedTypeDtl(strType, item.strSubGroupCode,
								item.strSubGroupName);
					});
					break;
				case "Menu Head":
					$.each(response, function(i, item) {
						funFillSelectedTypeDtl(strType, item.strMenuCode,
								item.strMenuName);
					});
					break;
				case "Revenue Head":
					$.each(response, function(i, item) {
						funFillSelectedTypeDtl(strType, item, item);
					});
					break;
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

	function funFillSelectedTypeDtl(strType, strCode, strName) {
		var table = document.getElementById("tblSelectedTypeDtl");
		var rowCount = table.rows.length;
		var row = table.insertRow(rowCount);

		row.insertCell(0).innerHTML = "<input  readonly=\"readonly\" class=\"Box \" size=\"30%\" id=\"txtSettlementCode."
				+ (rowCount) + "\" value='" + strType + "'>";
		row.insertCell(1).innerHTML = "<input name=\"strName\" readonly=\"readonly\" class=\"Box \" size=\"30%\" id=\"txtSettlementDesc."
				+ (rowCount) + "\" value='" + strName + "'>";
		row.insertCell(2).innerHTML = "<input name=\"strCode\" readonly=\"readonly\" class=\"Box \" size=\"30%\" id=\"txtSettlementDesc."
				+ (rowCount) + "\" value='" + strCode + "'>";
		row.insertCell(3).innerHTML = "<input type=\"checkbox\"  size=\"10%\" id=\"chkApplicable."
				+ (rowCount) + "\" value='" + true + "'>";

	}
	function funLoadOldBillSeries() {
		var posCode = $('#cmbPosCode').val();
		var searchurl = getContextPath() + "/loadOldBillSeries.html?posCode="
				+ posCode;
		$.ajax({
			type : "GET",

			url : searchurl,
			dataType : "json",
			success : function(response) {

				$.each(response.listBillSeriesDtl, function(i, item) {

					funLoadBillSeriesDataForUpdate(item.strCodes,
							item.strBillSeries, item.strNames,
							item.strPrintGTOfOtherBills,
							item.strPrintInclusiveOfTaxOnBill);

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
	function btnFetchID_onclick() {

		var searchurl = getContextPath() + "/fetchDeviceID.html";
		$.ajax({
			type : "GET",

			url : searchurl,
			dataType : "json",
			success : function(response) {

				$('#txtJioDeviceID').val(response.deviceID);
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
	function funAddSelectedTypeRow(codes, names) {

		var itemCode = codes.split(",");
		var itemName = names.split(",");
		for (var i = 0; i < itemCode.length; i++) {
			var table = document.getElementById("tblSelectedTypeDtl");
			var rowCount = table.rows.length;
			var row = table.insertRow(rowCount);
			var strType = $('#cmbSelectedType').val();

			row.insertCell(0).innerHTML = "<input  readonly=\"readonly\" class=\"Box \" size=\"30%\" id=\"txtSettlementCode."
					+ (rowCount) + "\" value='" + strType + "'>";
			row.insertCell(1).innerHTML = "<input name=\"strName\" readonly=\"readonly\" class=\"Box \" size=\"30%\" id=\"txtSettlementDesc."
					+ (rowCount) + "\" value='" + itemName[i] + "'>";
			row.insertCell(2).innerHTML = "<input name=\"strCode\" readonly=\"readonly\" class=\"Box \" size=\"30%\" id=\"txtSettlementDesc."
					+ (rowCount) + "\" value='" + itemCode[i] + "'>";
			row.insertCell(3).innerHTML = "<input type=\"checkbox\"  size=\"10%\" id=\"chkApplicable."
					+ (rowCount) + "\" value='" + true + "'>";

		}

	}
	function funAddBillseriesDtlRow(codes, names) {

		var table = document.getElementById("tblBillseriesDtl");
		var rowCount = table.rows.length;
		var row = table.insertRow(rowCount);
		var cnt = (parseInt(rowCount)) + 1;
		row.insertCell(0).innerHTML = "<input type=\"hidden\" name=\"listBillSeriesDtl["
				+ (rowCount)
				+ "].strCodes\" readonly=\"readonly\" class=\"Box \" size=\"0%\" id=\"strCodes."
				+ (rowCount) + "\" value='" + codes + "'>";
		row.insertCell(1).innerHTML = "<input name=\"serialNo\" readonly=\"readonly\" class=\"Box \" size=\"10%\" value='"
				+ cnt + "'>";
		row.insertCell(2).innerHTML = "<input type=\"text\" name=\"listBillSeriesDtl["
				+ (rowCount)
				+ "].strBillSeries\"  class=\"Box \" size=\"10%\" id=\"strBillSeries."
				+ (rowCount) + "\" >";
		row.insertCell(3).innerHTML = "<input name=\"listBillSeriesDtl["
				+ (rowCount)
				+ "].strNames\" readonly=\"readonly\" class=\"Box \" size=\"30%\" id=\"strNames."
				+ (rowCount) + "\" value='" + names + "'>";
		row.insertCell(4).innerHTML = "<input type=\"checkbox\"  size=\"10%\" id=\"chkRemove\" value='"
				+ true + "'>";
		row.insertCell(5).innerHTML = "<input type=\"checkbox\" name=\"listBillSeriesDtl["
				+ (rowCount)
				+ "].strPrintGTOfOtherBills\" size=\"20%\" id=\"chkApplicable."
				+ (rowCount) + "\"value='" + true + "'>";
		row.insertCell(6).innerHTML = "<input type=\"checkbox\" name=\"listBillSeriesDtl["
				+ (rowCount)
				+ "].strPrintInclusiveOfTaxOnBill\" size=\"20%\" id=\"chkApplicable."
				+ (rowCount) + "\"value='" + true + "'>";

		rowCount = table.rows.length;
		if (rowCount > 0)
			document.getElementById("cmbSelectedType").disabled = true;
	}
	function funLoadBillSeriesDataForUpdate(codes, billSeries, names,
			strPrintGTOfOtherBills, strPrintInclusiveOfTaxOnBill) {

		var table = document.getElementById("tblBillseriesDtl");
		var rowCount = table.rows.length;
		var row = table.insertRow(rowCount);
		var cnt = (parseInt(rowCount)) + 1;
		row.insertCell(0).innerHTML = "<input type=\"hidden\" name=\"listBillSeriesDtl["
				+ (rowCount)
				+ "].strCodes\" readonly=\"readonly\" class=\"Box \" size=\"0%\" id=\"strCodes."
				+ (rowCount) + "\" value='" + codes + "'>";
		row.insertCell(1).innerHTML = "<input name=\"serialNo\" readonly=\"readonly\" class=\"Box \" size=\"10%\" value='"
				+ cnt + "'>";
		row.insertCell(2).innerHTML = "<input name=\"listBillSeriesDtl["
				+ (rowCount)
				+ "].strBillSeries\" readonly=\"readonly\" class=\"Box \" size=\"10%\" id=\"strBillSeries."
				+ (rowCount) + "\" value='" + billSeries + "'>";
		row.insertCell(3).innerHTML = "<input name=\"listBillSeriesDtl["
				+ (rowCount)
				+ "].strNames\" readonly=\"readonly\" class=\"Box \" size=\"30%\" id=\"strNames."
				+ (rowCount) + "\" value='" + names + "'>";
		row.insertCell(4).innerHTML = "<input type=\"checkbox\"  size=\"10%\" id=\"chkRemove\" value='"
				+ true + "'>";
		if (strPrintGTOfOtherBills == "Y") {
			row.insertCell(5).innerHTML = "<input type=\"checkbox\" name=\"listBillSeriesDtl["
					+ (rowCount)
					+ "].strPrintGTOfOtherBills\" size=\"20%\" id=\"chkApplicable."
					+ (rowCount) + "\" checked=\"checked\">";
		} else {
			row.insertCell(5).innerHTML = "<input type=\"checkbox\" name=\"listBillSeriesDtl["
					+ (rowCount)
					+ "].strPrintGTOfOtherBills\" size=\"20%\" id=\"chkApplicable."
					+ (rowCount) + "\"value='" + true + "'>";
		}

		if (strPrintInclusiveOfTaxOnBill == "Y") {
			row.insertCell(6).innerHTML = "<input type=\"checkbox\" name=\"listBillSeriesDtl["
					+ (rowCount)
					+ "].strPrintInclusiveOfTaxOnBill\" size=\"20%\" id=\"chkApplicable."
					+ (rowCount) + "\" checked=\"checked\">";
		} else {
			row.insertCell(6).innerHTML = "<input type=\"checkbox\" name=\"listBillSeriesDtl["
					+ (rowCount)
					+ "].strPrintInclusiveOfTaxOnBill\" size=\"20%\" id=\"chkApplicable."
					+ (rowCount) + "\"value='" + true + "'>";
		}

	}

	function btnAddDelSMS_onclick() {
		var firstvalue = "";
		if ($("#txtAreaSendHomeDeliverySMS").val().trim() == "") {
			firstvalue = "%%" + $("#cmbSendHomeDelivery").val();
			$("#txtAreaSendHomeDeliverySMS").val(firstvalue);
		} else {
			firstvalue = "%%" + $("#cmbSendHomeDelivery").val();
			var getValue = $("#txtAreaSendHomeDeliverySMS").val();
			$("#txtAreaSendHomeDeliverySMS").val(getValue + firstvalue);
		}
	}

	function btnAddSettleSMS_onclick() {
		var firstvalue = "";
		if ($("#txtAreaBillSettlementSMS").val().trim() == "") {
			firstvalue = "%%" + $("#cmbBillSettlement").val();
			$("#txtAreaBillSettlementSMS").val(firstvalue);
		} else {
			firstvalue = "%%" + $("#cmbBillSettlement").val();
			var getValue = $("#txtAreaBillSettlementSMS").val();
			$("#txtAreaBillSettlementSMS").val(getValue + firstvalue);
		}
	}

	function btnAddBtnFor_Send_Table_Reservation() {
		var firstvalue = "";

		if ($("#txtTableReservationSMS").val().trim() == "") {
			firstvalue = "%%" + $("#cmbSendTableReservation").val();
			$("#txtTableReservationSMS").val(firstvalue);
		} else {
			firstvalue = "%%" + $("#cmbSendTableReservation").val();
			var getValue = $("#txtTableReservationSMS").val();
			$("#txtTableReservationSMS").val(getValue + firstvalue);

		}
	}

	function funShowImagePreview(input) {

		if (input.files && input.files[0]) {
			var filerdr = new FileReader();
			filerdr.onload = function(e) {
				$('#clientImage').attr('src', e.target.result);
			}
			filerdr.readAsDataURL(input.files[0]);

		}
	}

	function funTestPrinterStatus() {
		if ($("#txtConsolidatedKOTPrinterPort").val() == '') {
			alert("Please Select Printer Name.");
			return;
		}

		var PrinterName = $("#txtConsolidatedKOTPrinterPort").val();
		var searchurl = getContextPath()
				+ "/testPrinterStatus.html?PrinterName=" + PrinterName;
		$.ajax({
			type : "GET",
			url : searchurl,
			dataType : "json",
			success : function(response) {
				//alert(response.Status);
			},
			error : function(e) {
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

	function funCheckSMSSendingStatus() {
		if ($("#txtAreaSMSApi").val() == '') {
			alert("Please Enter SMS API.");
			return;
		}
		if ($("#txtSMSMobileNo").val() == '') {
			alert("Please Enter Mobile No.");
			return;
		}

		var mobileNos = $("#txtSMSMobileNo").val().split(",");
		for (var i = 0; i < mobileNos.length; i++) {
			if (mobileNos[i].length > 10 || mobileNos[i].length < 10) {
				alert("Please Enter Valid Mobile Number.");
				return;
			}
		}

		var searchurl = getContextPath() + "/testSendSMS.html?testMobileNo="
				+ mobileNos;
		$.ajax({
			type : "GET",
			url : searchurl,
			dataType : "json",
			success : function(response) {
				alert(response.Status);
				$("#txtAreaSMSApi").val("");
			},
			error : function(e) {
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
 


	function funCheckEmailSendingStatus() {
		if ($("#txtSenderEmailId").val() == '') {
			alert("Please Enter Sender Email Id.");
			return;
		}
		if ($("#txtReceiverEmailId").val() == '') {
			alert("Please Enter Receiver Email Id");
			return;
		}
		if ($("#txtEmailConfirmPassword").val() == '') {
			alert("Please Enter Confirmed Password.");
			return;
		}
		if ($("#txtEmailPassword").val() == '') {
			alert("Please Enter Password.");
			return;
		}
		if ($("#txtBodyPart").val() == '') {
			alert("Please Add some message to send mail.");
			return;
		}

		var receiverMailId = $("#txtReceiverEmailId").val();
		var senderMailId = $("#txtSenderEmailId").val();
		var password = $("#txtEmailPassword").val();
		var confirmedPassword = $("#txtEmailConfirmPassword").val();
		var mailBody = $("#txtBodyPart").val();

		var searchurl = getContextPath()
				+ "/testSendEmail.html?receiverEmailId=" + receiverMailId
				+ "&senderEmailId=" + senderMailId + "&emailPassword="
				+ password + "&confirmedPassword=" + confirmedPassword
				+ "&mailBody=" + mailBody;
		$.ajax({
			type : "GET",
			url : searchurl,
			dataType : "json",
			success : function(response) {
				alert(response.Status);
				$("#txtAreaSMSApi").val("");
			},
			error : function(e) {
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

	function funTestWebServiceStatus() {
		if ($("#txtWebServiceLink").val() == '') {
			alert("Please Enter The Web Service Link.");
			return;
		}
		var webServiceURL = $("#txtWebServiceLink").val();
		var searchurl = getContextPath()
				+ "/testWebServiceConnection.html?webServiceURL="
				+ webServiceURL;
		$.ajax({
			type : "GET",
			url : searchurl,
			dataType : "json",
			success : function(response) {
				alert(response.Status);
			},
			error : function(e) {
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
</script>
</head>

<body onload="funFillPOSData()">
	<div id="formHeading">
		<label>Property Setup</label>
	</div>
	<s:form name="POSForm" method="POST" action="savePOSPropertySetup.html"
		class="formoid-default-skyblue"
		style="background-color:#FFFFFF;font-size:14px;font-family:'Open Sans','Helvetica Neue','Helvetica',Arial,Verdana,sans-serif;color:#666666;max-width:100%;min-width:100%;margin-top:0%;"
		enctype="multipart/form-data">

		<br />
		<br />

		<div class="row" style="background-color: #fff; display: -webkit-box;">
			<div class="element-input col-lg-6"
				style="width: 15%; margin-left: 2%">
				<label class="title">POS Name</label>
			</div>
			<div class="element-input col-lg-6"
				style="margin-bottom: 10px; width: 20%; margin-left: -8%;">
				<s:select id="cmbPosCode" path="strPosCode" items="${posList}"></s:select>
			</div>
		</div>
		<table
			style="border: 0px solid black; width: 100%; height: 130%; margin-left: auto; margin-right: auto;">

			<tr>
				<td>
					<div id="tab_container">
						<div style="float: left;">
							<ul class="tab">
								<li class="active" data-state="tab1"
									style="border: 1px solid black; width: 100%;">Property
									Setup</li>
								<li data-state="tab2"
									style="border: 1px solid black; width: 100%;">Bill Setup</li>
								<li data-state="tab3"
									style="border: 1px solid black; width: 100%;">POS Setup 1</li>
								<li data-state="tab4"
									style="border: 1px solid black; width: 100%;">POS Setup 2</li>
								<li data-state="tab5"
									style="border: 1px solid black; width: 100%;">POS Setup 3</li>
								<li data-state="tab6"
									style="border: 1px solid black; width: 100%;">POS Setup 4</li>
								<li data-state="tab7"
									style="border: 1px solid black; width: 100%;">Email Setup</li>
								<li data-state="tab8"
									style="border: 1px solid black; width: 100%;">Card
									Interface</li>
								<li data-state="tab9"
									style="border: 1px solid black; width: 100%;">CRM
									Interface</li>
								<li data-state="tab10"
									style="border: 1px solid black; width: 100%;">SMS Setup</li>
								<li data-state="tab11"
									style="border: 1px solid black; width: 100%;">FTP Setup</li>
								<li data-state="tab12"
									style="border: 1px solid black; width: 100%;">CMS
									Integration</li>
								<li data-state="tab13"
									style="border: 1px solid black; width: 100%;">Printer
									Setup</li>
								<li data-state="tab14"
									style="border: 1px solid black; width: 100%;">Debit Card
									Setup</li>
								<li data-state="tab15"
									style="border: 1px solid black; width: 100%;">Inresto
									Integration</li>
								<li data-state="tab16"
									style="border: 1px solid black; width: 100%;">Jio Money
									Integration</li>
								<li data-state="tab17"
									style="border: 1px solid black; width: 100%;">Benow
									Integration</li>
								<li data-state="tab18"
									style="border: 1px solid black; width: 100%;">WERA Online
									Order Integration</li>

							</ul>
						</div>

						<!--  Start of Property Setup tab-->

						<div id="tab1" class="tab_content">
							<br> <br>
							<div style="float: left; margin-left: 10%; margin-top: -3%;">
								<div class="row"
									style="background-color: #fff; display: -webkit-box;">
									<div class="element-input col-lg-6" style="width: 30%;">
										<label class="title">Client Code Name</label>
									</div>
									<div class="element-input col-lg-6"
										style="margin-bottom: 10px; width: 30%;">
										<s:input class="large" colspan="3" type="text"
											id="txtClientCode" path="strClientCode"
											ondblclick="funHelp('POSTaxMaster.a')" readonly="true" />
									</div>

									<div class="element-input col-lg-6"
										style="margin-bottom: 10px; width: 30%;">
										<s:input class="large" colspan="3" type="text"
											id="txtClientName" path="strClientName" readonly="true" />
									</div>

									<div style="width: 70%; height: 50%">
										<table style="width: 90px;">
											<tr style="width: 90px;">
												<td><img id="clientImage" src="" width="100px"
													height="100px" alt="Client Image" /></td>
											</tr>
											<tr>
												<td><input style="width: 90px;" id="companyLogo"
													name="companyLogo" type="file" accept="image/png"
													onchange="funShowImagePreview(this);" /></td>
											</tr>
										</table>
									</div>
								</div>
								<div class="row"
									style="background-color: #fff; display: -webkit-box;">
									<div class="element-input col-lg-6" style="width: 30%;">
										<label class="title">Address Line 1</label>
									</div>
									<div class="element-input col-lg-6"
										style="margin-bottom: 10px; width: 30%;">
										<s:input class="large" colspan="3" type="text"
											id="txtAddrLine1" path="strAddrLine1" />
									</div>
								</div>
								<div class="row"
									style="background-color: #fff; display: -webkit-box;">
									<div class="element-input col-lg-6" style="width: 30%;">
										<label class="title">Address Line 2</label>
									</div>
									<div class="element-input col-lg-6"
										style="margin-bottom: 10px; width: 30%;">
										<s:input class="large" colspan="3" type="text"
											id="txtAddrLine2" path="strAddrLine2" />
									</div>
								</div>
								<div class="row"
									style="background-color: #fff; display: -webkit-box;">
									<div class="element-input col-lg-6" style="width: 30%;">
										<label class="title">Address Line 3</label>
									</div>
									<div class="element-input col-lg-6"
										style="margin-bottom: 10px; width: 30%;">
										<s:input class="large" colspan="3" type="text"
											id="txtAddrLine3" path="strAddrLine3" />
									</div>

								</div>
								<div class="row"
									style="background-color: #fff; display: -webkit-box;">
									<div class="element-input col-lg-6" style="width: 30%;">
										<label class="title">City &amp; PIN Code</label>
									</div>
									<div class="element-input col-lg-6"
										style="margin-bottom: 10px; width: 30%">
										<s:select id="cmbCity" path="strCity">
											<option value="Pune">Pune</option>
											<option value="Agalgaon">Agalgaon</option>
											<option value="Agartala">Agartala</option>
											<option value="Agra">Agra</option>
											<option value="Ahmedabad">Ahmedabad</option>
											<option value="Ahmednagar">Ahmednagar</option>
											<option value="Ajmer">Ajmer</option>
											<option value="Akluj">Akluj</option>
											<option value="Akola">Akola</option>
											<option value="Akot">Akot</option>
											<option value="Allahabad">Allahabad</option>
											<option value="Allepey">Allepey</option>
											<option value="Amalner">Amalner</option>
											<option value="Ambernath">Ambernath</option>
											<option value="Amravati">Amravati</option>
											<option value="Amritsar">Amritsar</option>
											<option value="Anand">Anand</option>
											<option value="Arvi">Arvi</option>
											<option value="Asansol">Asansol</option>
											<option value="Ashta">Ashta</option>
											<option value="Aurangabad">Aurangabad</option>
											<option value="Aziwal">Aziwal</option>
											<option value="Baddi">Baddi</option>
											<option value="Bangalore">Bangalore</option>
											<option value="Bansarola">Bansarola</option>
											<option value="Baramati">Baramati</option>
											<option value="Bareilly">Bareilly</option>
											<option value="Baroda">Baroda</option>
											<option value="Barshi">Barshi</option>
											<option value="Beed">Beed</option>
											<option value="Belgum">Belgum</option>
											<option value="Bellary">Bellary</option>
											<option value="Bhandara">Bhandara</option>
											<option value="Bhilai">Bhilai</option>
											<option value="Bhivandi">Bhivandi</option>
											<option value="Bhopal">Bhopal</option>
											<option value="Bhubaneshwar">Bhubaneshwar</option>
											<option value="Bhusawal">Bhusawal</option>
											<option value="Bikaner">Bikaner</option>
											<option value="Bokaro">Bokaro</option>
											<option value="Bombay">Bombay</option>
											<option value="Buldhana">Buldhana</option>
											<option value="Burhanpur">Burhanpur</option>
											<option value="Chandigarh">Chandigarh</option>
											<option value="Chattisgad">Chattisgad</option>
											<option value="Chennai(Madras)">Chennai(Madras)</option>
											<option value="Cochin">Cochin</option>
											<option value="Coimbature">Coimbature</option>
											<option value="Dehradun">Dehradun</option>
											<option value="Delhi">Delhi</option>
											<option value="Dhanbad">Dhanbad</option>
											<option value="Dhule">Dhule</option>
											<option value="Faridabad">Faridabad</option>
											<option value="Goa">Goa</option>
											<option value="Gujrat">Gujrat</option>
											<option value="Gurgaon">Gurgaon</option>
											<option value="Guwahati">Guwahati</option>
											<option value="Gwalior">Gwalior</option>
											<option value="Hyderabad">Hyderabad</option>
											<option value="Ichalkaranji">Ichalkaranji</option>
											<option value="Indapur">Indapur</option>
											<option value="Indore">Indore</option>
											<option value="Jabalpur">Jabalpur</option>
											<option value="Jaipur">Jaipur</option>
											<option value="Jalandhar">Jalandhar</option>
											<option value="Jalgaon">Jalgaon</option>
											<option value="Jalna">Jalna</option>
											<option value="Jamshedpur">Jamshedpur</option>
											<option value="Kalamnuri">Kalamnuri</option>
											<option value="Kanpur">Kanpur</option>
											<option value="Karad">Karad</option>
											<option value="Kochi(Cochin)">Kochi(Cochin)</option>
											<option value="Kolhapur">Kolhapur</option>
											<option value="Kolkata(Calcutta)">Kolkata(Calcutta)</option>
											<option value="Kozhikode(Calicut)">Kozhikode(Calicut)</option>
											<option value="Latur">Latur</option>
											<option value="Lucknow">Lucknow</option>
											<option value="Ludhiana">Ludhiana</option>
											<option value="Mumbai">Mumbai</option>
											<option value="Madurai">Madurai</option>
											<option value="Mangalvedha">Mangalvedha</option>
											<option value="Manmad">Manmad</option>
											<option value="Meerut">Meerut</option>
											<option value="Mumbai(Bombay)">Mumbai(Bombay)</option>
											<option value="Mysore">Mysore</option>
											<option value="Nagpur">Nagpur</option>
											<option value="Nanded">Nanded</option>
											<option value="Nandurbar">Nandurbar</option>
											<option value="Nashik">Nashik</option>
											<option value="Orisa">Orisa</option>
											<option value="Osmanabad">Osmanabad</option>
											<option value="Pachora">Pachora</option>
											<option value="Pandharpur">Pandharpur</option>
											<option value="Parbhani">Parbhani</option>
											<option value="Patna">Patna</option>
											<option value="Pratapgad">Pratapgad</option>
											<option value="Raipur">Raipur</option>
											<option value="Rajasthan">Rajasthan</option>
											<option value="Rajkot">Rajkot</option>
											<option value="Ranchi">Ranchi</option>
											<option value="Ratnagiri">Ratnagiri</option>
											<option value="Salem">Salem</option>
											<option value="Sangamner">Sangamner</option>
											<option value="Sangli">Sangli</option>
											<option value="Satara">Satara</option>
											<option value="Sawantwadi">Sawantwadi</option>
											<option value="Secunderabad">Secunderabad</option>
											<option value="Shirdi">Shirdi</option>
											<option value="Sindhudurga">Sindhudurga</option>
											<option value="Solapur">Solapur</option>
											<option value="Srinagar">Srinagar</option>
											<option value="Surat">Surat</option>
											<option value="Tiruchirapalli">Tiruchirapalli</option>
											<option value="Vadodara(Baroda)">Vadodara(Baroda)</option>
											<option value="Varanasi(Benares)">Varanasi(Benares)</option>
											<option value="Vijayawada">Vijayawada</option>
											<option value="Visakhapatnam">Visakhapatnam</option>
											<option value="Yawatmal">Yawatmal</option>
											<option value="Other">Other</option>
										</s:select>

									</div>
									<div class="element-input col-lg-6"
										style="margin-bottom: 10px; width: 0%;">
										<s:input colspan="" type="text" id="txtPinCode"
											path="strPinCode" />
									</div>
								</div>
								<div class="row"
									style="background-color: #fff; display: -webkit-box;">
									<div class="element-input col-lg-6" style="width: 30%;">
										<label class="title">State And Country</label>
									</div>
									<div class="element-input col-lg-6"
										style="margin-bottom: 10px; width: 30%">
										<s:select id="cmbState" path="strState">
											<option value="Maharashtra">Maharashtra</option>
											<option value="Delhi">Delhi</option>
											<option value="Karnataka">Karnataka</option>
											<option value="Telangana">Telangana</option>
											<option value="TamilNadu">TamilNadu</option>
											<option value="Gujrat">Gujrat</option>
											<option value="Punjab">Punjab</option>
											<option value="Rajasthan">Rajasthan</option>
										</s:select>
									</div>
									<div class="element-input col-lg-6"
										style="margin-bottom: 10px; width: 30%;">


										<s:select id="cmbCountry" path="strCountry">
											<option value="India">India</option>
											<option value="China">China</option>
											<option value="USA">USA</option>
											<option value="England">England</option>
										</s:select>
									</div>

								</div>


								<div class="row"
									style="background-color: #fff; display: -webkit-box;">
									<div class="element-input col-lg-6" style="width: 30%;">
										<label class="title">Telephone</label>
									</div>
									<div class="element-input col-lg-6"
										style="margin-bottom: 10px; width: 30%;">
										<s:input class="large" colspan="3" type="text"
											id="txtTelephone" path="strTelephone" />
									</div>

								</div>

								<div class="row"
									style="background-color: #fff; display: -webkit-box;">
									<div class="element-input col-lg-6" style="width: 30%;">
										<label class="title">E-Mail Address</label>
									</div>
									<div class="element-input col-lg-6"
										style="margin-bottom: 10px; width: 30%;">
										<s:input class="large" colspan="3" type="text" id="txtEmail"
											path="strEmail" />
									</div>

								</div>

								<div class="row"
									style="background-color: #fff; display: -webkit-box;">
									<div class="element-input col-lg-6" style="width: 30%;">
										<label class="title">Nature Of Business</label>
									</div>
									<div class="element-input col-lg-6"
										style="margin-bottom: 10px; width: 30%">


										<s:select id="cmbNatureOfBussness" path="strNatureOfBussness">
											<option value="Retail">Retail</option>
											<option value="F&B">F &amp; B</option>
										</s:select>
									</div>
								</div>


							</div>



						</div>

					</div> <!--  End of  Property Setup tab--> <!-- Start of Bill Setup tab -->

					<div id="tab2" class="tab_content">
						<div style="float: left; margin-left: 20%; margin-top: -48%">
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 28%;">
									<label class="title">Bill Footer</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 40%;">
									<%-- <s:textarea id="txtBillFooter" path="strBillFooter" />--%>

									<s:textarea class="large" type="text" id="txtBillFooter"
										path="strBillFooter" style="height:100px" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 30%; margin-left: 10%">
									<label class="title">Column Size</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 20%; margin-left: -10%">
									<s:select id="cmbColumnSize" path="intColumnSize">

										<option value=40>40</option>
										<option value=48>48</option>
									</s:select>
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 28%;">
									<label class="title">Bill Paper Size</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 20%;">
									<s:select id="cmbBillPaperSize" path="intBiilPaperSize">

										<option value=2>2</option>
										<option value=3>3</option>
									</s:select>
								</div>
								<div class="element-input col-lg-6" style="width: 30%;">
									<label class="title">Print Mode</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 20%;">
									<s:select id="cmbPrintMode" path="strBillPrintMode">

										<option value="Portrait">Portrait</option>
										<option value="Landscape">Landscape</option>
									</s:select>
								</div>


							</div>

							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 28%;">
									<label class="title">Doc Printing Type</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 20%;">
									<s:select id="cmbPrintType" path="strPrintingType">

										<option value="Jasper">Jasper</option>
										<option value="Text File">Text File</option>
									</s:select>
								</div>
								<div class="element-input col-lg-6" style="width: 30%;">
									<label class="title">Bill Format</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 20%;">
									<s:select id="cmbBillFormatType" name="cmbBillFormatType"
										path="strBillFormatType">

										<option value="Jasper 1">Jasper 1</option>
										<option value="Jasper 2">Jasper 2</option>
										<option value="Jasper 3">Jasper 3</option>
										<option value="Jasper 4">Jasper 4</option>
										<option value="Jasper 5">Jasper 5</option>
										<option value="Jasper 6">Jasper 6</option>
										<option value="Jasper 7">Jasper 7</option>
										<option value="Jasper 8">Jasper 8</option>
										<option value="Jasper 9">Jasper 9</option>
										<option value="Jasper 10">Jasper 10</option>
										<option value="Jasper 11">Jasper 11</option>
									</s:select>
								</div>
								<div class="element-input col-lg-6" style="width: 25%;">
									<label class="title">Show Doc</label>
								</div>
								<div class="element-input col-lg-6" style="width: 20%;">
									<s:checkbox element="li" id="chkShowBills" path="chkShowBills"
										value="Yes" />
								</div>

							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 28%;">
									<label class="title">Allow Negative Billing</label>
								</div>
								<div class="element-input col-lg-6" style="width: 20%;">
									<s:checkbox element="li" id="chkNegBilling"
										path="chkNegBilling" value="Yes" />
								</div>
								<div class="element-input col-lg-6" style="width: 30%;">
									<label class="title">Enable KOT Printing For Direct
										Biller</label>
								</div>
								<div class="element-input col-lg-6" style="width: 20%;">
									<s:checkbox element="li" id="chkPrintKotForDirectBiller"
										path="chkPrintKotForDirectBiller" value="Yes" />
								</div>

								<div class="element-input col-lg-6" style="width: 25%;">
									<label class="title">Enable KOT Printing</label>
								</div>
								<div class="element-input col-lg-6" style="width: 20%;">
									<s:checkbox element="li" id="chkEnableKOT" path="chkEnableKOT"
										value="Yes" />
								</div>
							</div>

							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 28%;">
									<label class="title">Multiple Bill Printing</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px;">
									<s:checkbox element="li" id="strMultipleBillPrinting"
										path="strMultipleBillPrinting" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 30%; margin-bottom: 10px;">
									<label class="title">Day End (Mandatory)</label>
								</div>
								<div class="element-input col-lg-6" style="width: 20%;">
									<s:checkbox element="li" id="chkDayEnd" path="chkDayEnd"
										value="Yes" />
								</div>

								<div class="element-input col-lg-6" style="width: 25%;">
									<label class="title">Print Short Name On KOT</label>
								</div>
								<div class="element-input col-lg-6" style="width: 20%;">
									<s:checkbox element="li" id="chkPrintShortNameOnKOT"
										path="chkPrintShortNameOnKOT" value="Yes" />
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 28%;">
									<label class="title">Multiple KOT Printing</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px;">
									<s:checkbox element="li" id="strMultipleKOTPrintYN"
										path="strMultipleKOTPrintYN" value="Yes" />
								</div>
								<div class="element-input col-lg-6" style="width: 30%;">
									<label class="title">Print TAX Invoice On Bill</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px;">
									<s:checkbox element="li" id="chkPrintInvoiceOnBill"
										path="chkPrintInvoiceOnBill" value="Yes" />
								</div>

								<div class="element-input col-lg-6" style="width: 25%;">
									<label class="title">Print TDH Items In Bill</label>
								</div>
								<div class="element-input col-lg-6" style="width: 20%;">
									<s:checkbox element="li" id="chkPrintTDHItemsInBill"
										path="chkPrintTDHItemsInBill" value="Yes" />
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 28%;">
									<label class="title">Manual Bill No.</label>
								</div>
								<div class="element-input col-lg-6" style="width: 20%;">
									<s:checkbox element="li" id="chkManualBillNo"
										path="chkManualBillNo" value="Yes" />
								</div>
								<div class="element-input col-lg-6" style="width: 30%;">
									<label class="title">Print Inclusive Of All Taxes On
										Bill</label>
								</div>
								<div class="element-input col-lg-6" style="width: 20%;">
									<s:checkbox element="li" id="chkPrintInclusiveOfAllTaxesOnBill"
										path="chkPrintInclusiveOfAllTaxesOnBill" value="Yes" />
								</div>
								<div class="element-input col-lg-6" style="width: 25%;">
									<label class="title">Effect On PSP </label>
								</div>
								<div class="element-input col-lg-6" style="width: 20%;">
									<s:checkbox element="li" id="chkEffectOnPSP"
										path="chkEffectOnPSP" value="Yes" />
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<%-- 	<div class="element-input col-lg-6" style="width: 30%;">
									<label class="title">Effect On PSP </label>
								</div>
								<div class="element-input col-lg-6" style="width: 20%;">
									<s:checkbox element="li" id="chkEffectOnPSP"
										path="chkEffectOnPSP" value="Yes" />
								</div> --%>
								<div class="element-input col-lg-6" style="width: 28%;">
									<label class="title">Print VAT No.</label>
								</div>
								<div class="element-input col-lg-6" style="width: 20%;">
									<s:checkbox element="li" id="chkPrintVatNo"
										path="chkPrintVatNo" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px; margin-left: -10%;">
									<s:input type="text" id="txtVatNo" name="txtVatNo"
										path="strVatNo" />
								</div>

							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 28%;">
									<label class="title">No Of Lines In KOT Print</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 20%;">
									<s:input type="text" id="txtNoOfLinesInKOTPrint"
										path="intNoOfLinesInKOTPrint" />
								</div>

								<div class="element-input col-lg-6" style="width: 30%;">
									<label class="title">Print Service Tax No </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px;">
									<s:checkbox element="li" id="chkServiceTaxNo"
										path="chkServiceTaxNo" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px;">
									<s:input type="text" id="txtServiceTaxNo"
										path="strServiceTaxNo" />
								</div>

							</div>

							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6"
									style="width: 28%; margin-bottom: 10px;">
									<label class="title">Show Bills Detail Type</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px;">
									<s:select id="cmbShowBillsDtlType" name="cmbShowBillsDtlType"
										path="strShowBillsDtlType">

										<option value="Table Detail Wise">Table Detail Wise</option>
										<option value="Delivery Detail Wise">Delivery Detail
											Wise</option>
									</s:select>
								</div>

								<div class="element-input col-lg-6"
									style="width: 30%; margin-bottom: 10px;">
									<label class="title">No Of Advance Receipt Print</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px">
									<s:input type="text" id="txtAdvRecPrintCount"
										path="strAdvRecPrintCount" />
								</div>
							</div>

						</div>
					</div>


					</div> <!-- End of Bill Setup tab --> <!-- Start of POS Setup 1 tab -->

					<div id="tab3" class="tab_content">


						<div style="float: left; margin-left: 20%; margin-top: -48%">
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 20%;">
									<label class="title">Property Type</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 25%;">
									<s:select id="cmbPOSType" path="strPOSType">

										<option value="Stand Alone-HOPOS">Stand Alone-HOPOS</option>
										<option value="Stand Alone">Stand Alone</option>
										<option value="HOPOS">HOPOS</option>
										<option value="Client POS">Client POS</option>
										<option value="DebitCard POS">DebitCard POS</option>

									</s:select>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 35%; margin-left: 2%">
									<label class="title">Data Posting Frequency</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 30%; margin-left: -10%">
									<s:select id="cmbDataSendFrequency" path="strDataSendFrequency">

										<option value="After Every Bill">After Every Bill</option>
										<option value="After Day End">After Day End</option>
										<option value="Manual">Manual</option>
									</s:select>
								</div>

							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
								<div class="element-input col-lg-6" style="width: 20%;">
									<label class="title" style="width: 100%">Web Service
										Link</label>
								</div>
								<div class="element-input col-lg-6" style="width: 60%;">
									<s:input class="large" colspan="3" type="text"
										id="txtWebServiceLink" path="strWebServiceLink"
										style="width: 100%" />
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 30%; margin-left: -1%">
									<input type="Button" value="TEST" style="margin-left: 10%;"
										onclick="funTestWebServiceStatus();" />
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
								<div class="element-input col-lg-6" style="width: 20%;">
									<label class="title">HO Server Date</label>
								</div>
								<div class="element-input col-lg-6" style="width: 20%;">
									<s:input id="dteHOServerDate" path="dteHOServerDate" />
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 35%; margin-left: 2%">
									<label class="title">Enable Master Discount</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 25%; margin-left: -10%">
									<s:checkbox element="li" id="chkEnableMasterDiscount"
										path="strEnableMasterDiscount" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 35%; margin-left: -20%">
									<label class="title">Max. discount</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 30%; margin-left: -20%">
									<s:input type="number" id="dblMaxDiscount"
										path="dblMaxDiscount" />
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
								<div class="element-input col-lg-6" style="width: 20%;">
									<label class="title">Change Theme</label>
								</div>
								<div class="element-input col-lg-6" style="width: 23%;">
									<s:select id="cmbChangeTheme" path="strChangeTheme">

										<option value="Default">Default</option>
										<option value="Tiles">Tiles</option>
										<option value="Color">Color</option>

									</s:select>
								</div>
								<%-- 		<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 40%;margin-left: 20%">
									<label class="title">Select Area For Direct Biller</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 30%; margin-left: -10%">
									<s:select id="cmbDirectArea"
										path="strDirectArea" items="${areaList}" /> 
								</div>	
 --%>

								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 35%; margin-left: -1%">
									<label class="title">Reprint On Settle Bill</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 30%; margin-left: -10%">
									<s:checkbox element="li" id="chkReprintOnSettleBill"
										path="strReprintOnSettleBill" value="Yes" />
								</div>

								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 35%; margin-left: -20%">
									<label class="title">Show Item StK Column in DB </label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 30%; margin-left: -5%">
									<s:checkbox element="li" id="chkShowItemStkColumnInDB"
										path="chkShowItemStkColumnInDB" value="Yes" />
								</div>
							</div>

							<div class="row"
								style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
								<div class="element-input col-lg-6" style="width: 20%;">
									<label class="title">Customer Series</label>
								</div>
								<div class="element-input col-lg-6" style="width: 20%;">
									<s:input type="number" id="txtCustSeries" path="longCustSeries"  />
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 35%; margin-left: 2%">
									<label class="title">Print KOT</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 30%; margin-left: -10%">
									<s:checkbox element="li" id="chkPrintKOTYN"
										path="chkPrintKOTYN" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 35%; margin-left: -20%">
									<label class="title">Slab Based Home Delivery Charges</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 40%; margin-left: -5%">
									<s:checkbox element="li" id="chkSlabBasedHomeDelCharges"
										path="chkSlabBasedHomeDelCharges" value="Yes" />
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
								<div class="element-input col-lg-6" style="width: 20%;">
									<label class="title">Edit Home Delivery</label>
								</div>
								<div class="element-input col-lg-6" style="width: 20%;">
									<s:checkbox element="li" id="chkEditHomeDelivery"
										path="chkEditHomeDelivery" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 35%; margin-left: 2%">
									<label class="title">Print For Void Bill</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 30%; margin-left: -10%">
									<s:checkbox element="li" id="chkPrintForVoidBill"
										path="chkPrintForVoidBill" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 35%; margin-left: -20%">
									<label class="title">Direct KOT Print from Make KOT</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 40%; margin-left: -5%">
									<s:checkbox element="li" id="chkDirectKOTPrintMakeKOT"
										path="chkDirectKOTPrintMakeKOT" value="Yes" />
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
								<div class="element-input col-lg-6" style="width: 20%;">
									<label class="title">Skip Waiter Selection</label>
								</div>
								<div class="element-input col-lg-6" style="width: 20%;">
									<s:checkbox element="li" id="strSkipWaiterAndPax"
										path="strSkipWaiterAndPax" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 35%; margin-left: 2%">
									<label class="title">Skip Pax Selection </label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 30%; margin-left: -10%">
									<s:checkbox element="li" id="chkSkipPaxSelection"
										path="chkSkipPaxSelection" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 35%; margin-left: -20%">
									<label class="title">Compulsory Customer Area Master</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 40%; margin-left: -5%">
									<s:checkbox element="li" id="chkAreaMasterCompulsory"
										path="chkAreaMasterCompulsory" value="Yes" />
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
								<div class="element-input col-lg-6" style="width: 20%;">
									<label class="title">Post Sales Data to MMS</label>
								</div>
								<div class="element-input col-lg-6" style="width: 20%;">
									<s:checkbox element="li" id="chkPostSalesDataToMMS"
										path="chkPostSalesDataToMMS" value="Yes" />
								</div>

								<div class="element-input col-lg-6"
									style="width: 18%; margin-left: -15%">
									<s:select id="cmbItemType" path="strItemType">

										<option value="Both">Both</option>
										<option value="Liquor">Liquor</option>
										<option value="Food">Food</option>

									</s:select>
								</div>

								<div class="element-input col-lg-6"
									style="width: 25%; margin-left: -1%">
									<label class="title">Show Printer Error Message</label>
								</div>

								<div class="element-input col-lg-6" style="width: 20%;">
									<s:checkbox element="li" id="chkPrinterErrorMessage"
										path="chkPrinterErrorMessage" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 30%; margin-left: -10%">
									<label class="title">Pick Up Price From</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 18%; margin-left: -10%">
									<s:select id="cmbPriceFrom" path="strPriceFrom">

										<option value="Menu Pricing">Menu Pricing</option>
										<option value="Item Master">Item Master</option>
									</s:select>
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
								<div class="element-input col-lg-6" style="width: 20%;">
									<label class="title">Active Promotions</label>
								</div>
								<div class="element-input col-lg-6" style="width: 20%;">
									<s:checkbox element="li" id="chkActivePromotions"
										path="chkActivePromotions" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 40%; margin-left: 2%">
									<label class="title">Change Quantity For External Code</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 25%; margin-left: -10%">
									<s:checkbox element="li" id="chkChangeQtyForExternalCode"
										path="chkChangeQtyForExternalCode" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 35%; margin-left: -20%">
									<label class="title">Ask For Print Bill Popup</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 40%; margin-left: -5%">
									<s:checkbox element="li" id="chkPrintBill" path="chkPrintBill"
										value="Yes" />
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
								<div class="element-input col-lg-6" style="width: 20%;">
									<label class="title">Use Vat And Service No From POS</label>
								</div>
								<div class="element-input col-lg-6" style="width: 20%;">
									<s:checkbox element="li" id="chkUseVatAndServiceNoFromPos"
										path="chkUseVatAndServiceNoFromPos" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 40%; margin-left: 2%">
									<label class="title">POS Wise Item LinkedUp To MMS
										Product</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 25%; margin-left: -5%">
									<s:checkbox element="li"
										id="strPOSWiseItemToMMSProductLinkUpYN"
										path="strPOSWiseItemToMMSProductLinkUpYN" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 30%; margin-left: -20%">
									<label class="title">Enable Lock Tables</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 40%; margin-left: -5%">
									<s:checkbox element="li" id="chkEnableLockTable"
										path="strEnableLockTable" value="Yes" />
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 30%;">
									<label class="title">Stock In Options</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 22%; margin-left: -10%">
									<s:select id="cmbStockInOption" path="strStockInOption">

										<option value="ItemWise">ItemWise</option>
										<option value="MenuHeadWise">MenuHeadWise</option>

									</s:select>
								</div>
								<div class="element-input col-lg-6" style="width: 28%;">
									<label class="title">Post MMS Sales Effect</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 20%; margin-left: -10%">
									<s:select id="cmbPostMMSSalesEffectCostOrLoc"
										path="strPostMMSSalesEffectCostOrLoc">
										<option value="Cost Center">Cost Center</option>
										<option value="WS Location">WS Location</option>
									</s:select>
								</div>
								<div class="element-input col-lg-6" style="width: 23%;">
									<label class="title">Discount On</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 20%; margin-left: -10%">
									<s:select id="cmbApplyDiscountOn" path="strApplyDiscountOn">

										<option value="SubTotal">SubTotal</option>
										<option value="SubTotalTax">SubTotalTax</option>
									</s:select>
								</div>

							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 20%;">
									<label class="title">Clear All Transaction AT Day End</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 30%; ">
									<s:checkbox element="li" id="strClearAllTrasactionAtDayEnd"
										path="strClearAllTrasactionAtDayEnd" value="Yes" />
								</div>
							</div>
						</div>


					</div> <!-- End of POS Setup 1 tab --> <!-- Start of POS Setup 2 tab -->

					<div id="tab4" class="tab_content">
						<div style="float: left; margin-left: 20%; margin-top: -48%">
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 45%;">
									<label class="title">Manual Advance Order No Compulsory
									</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 28%; margin-bottom: 10px;">
									<s:checkbox element="li" id="chkManualAdvOrderCompulsory"
										path="chkManualAdvOrderCompulsory" value="Yes" />
								</div>
								<div class="element-input col-lg-6" style="width: 50%;">
									<label class="title">Print Manual Advance Order No On
										Bill </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 30%; margin-bottom: 10px;">
									<s:checkbox element="li" id="chkPrintManualAdvOrderOnBill"
										path="chkPrintManualAdvOrderOnBill" value="Yes" />
								</div>


							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 45%;">
									<label class="title">Print Modifier Quantity On KOT </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 28%; margin-bottom: 10px;">
									<s:checkbox element="li" id="chkPrintModifierQtyOnKOT"
										path="chkPrintModifierQtyOnKOT" value="Yes" />
								</div>
								<div class="element-input col-lg-6" style="width: 50%;">
									<label class="title">Allow New Area Master From
										Customer Master </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 30%; margin-bottom: 10px;">
									<s:checkbox element="li"
										id="chkBoxAllowNewAreaMasterFromCustMaster"
										path="chkBoxAllowNewAreaMasterFromCustMaster" value="Yes" />
								</div>


							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 35%;">
									<label class="title">Menu Item Sorting </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 38%; margin-bottom: 10px;">
									<s:select id="cmbMenuItemSortingOn" path="strMenuItemSortingOn">

										<option value="SELECT">SELECT</option>
										<option value="subGroupWise">SUB GROUP WISE</option>
										<option value="subMenuHeadWise">SUB MENU HEAD WISE</option>

									</s:select>
								</div>
								<div class="element-input col-lg-6" style="width: 50%;">
									<label class="title">Allow To Calculate Item Weight </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 30%; margin-bottom: 10px;">
									<s:checkbox element="li" id="chkAllowToCalculateItemWeight"
										path="chkAllowToCalculateItemWeight" value="Yes" />
								</div>


							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 35%;">
									<label class="title">Menu Item Display Sequence </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 38%; margin-bottom: 10px;">
									<s:select id="cmbMenuItemDisSeq" path="strMenuItemDisSeq">

										<option value="Ascending">Ascending</option>
										<option value="As Entered">As Entered</option>

									</s:select>
								</div>
								<div class="element-input col-lg-6" style="width: 50%;">
									<label class="title">Item Wise KOT Y/N : </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 30%; margin-bottom: 10px;">
									<s:checkbox element="li" id="chkItemWiseKOTPrintYN"
										path="chkItemWiseKOTPrintYN" value="Yes" />
								</div>

							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 45%;">
									<label class="title">Item Quantiy Numeric Pad </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 28%; margin-bottom: 10px;">
									<s:checkbox element="li" id="chkItemQtyNumpad"
										path="chkItemQtyNumpad" value="Yes" />
								</div>
								<div class="element-input col-lg-6" style="width: 50%;">
									<label class="title">Slip No Compulsory For Credit Card
										Bill </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 30%; margin-bottom: 10px;">
									<s:checkbox element="li" id="chkSlipNoForCreditCardBillYN"
										path="chkSlipNoForCreditCardBillYN" value="Yes" />
								</div>

							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 45%;">
									<label class="title">Print KOT To Local Printer </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 28%; margin-bottom: 10px;">
									<s:checkbox element="li" id="chkPrintKOTToLocalPrinter"
										path="chkPrintKOTToLocalPrinter" value="Yes" />
								</div>
								<div class="element-input col-lg-6" style="width: 50%;">
									<label class="title">Expiry date Compulsory For Credit
										Card Bill</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 30%; margin-bottom: 10px;">
									<s:checkbox element="li" id="chkExpDateForCreditCardBillYN"
										path="chkExpDateForCreditCardBillYN" value="Yes" />
								</div>

							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 45%;">
									<label class="title">Delivery Boy Compulsory On Direct
										Biller </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 28%; margin-bottom: 10px;">
									<s:checkbox element="li" id="chkDelBoyCompulsoryOnDirectBiller"
										path="chkDelBoyCompulsoryOnDirectBiller" value="Yes" />
								</div>
								<div class="element-input col-lg-6" style="width: 50%;">
									<label class="title">Select Waiter From Card Swipe </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 30%; margin-bottom: 10px;">
									<s:checkbox element="li" id="chkSelectWaiterFromCardSwipe"
										path="chkSelectWaiterFromCardSwipe" value="Yes" />
								</div>

							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 45%;">
									<label class="title">Enable Settle Button For Direct
										Biller Bill </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 28%; margin-bottom: 10px;">
									<s:checkbox element="li"
										id="chkEnableSettleBtnForDirectBillerBill"
										path="chkEnableSettleBtnForDirectBillerBill" value="Yes" />
								</div>
								<div class="element-input col-lg-6" style="width: 50%;">
									<label class="title">Multiple Waiter Selection On Make
										KOT </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 30%; margin-bottom: 10px;">
									<s:checkbox element="li"
										id="chkMultipleWaiterSelectionOnMakeKOT"
										path="chkMultipleWaiterSelectionOnMakeKOT" value="Yes" />
								</div>

							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 45%;">
									<label class="title">Don't Show Advance Order In Other
										POS </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 28%; margin-bottom: 10px;">
									<s:checkbox element="li" id="chkDontShowAdvOrderInOtherPOS"
										path="chkDontShowAdvOrderInOtherPOS" value="Yes" />
								</div>
								<div class="element-input col-lg-6" style="width: 50%;">
									<label class="title">Move Table From One POS To Other
										POS </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 30%; margin-bottom: 10px;">
									<s:checkbox element="li" id="chkMoveTableToOtherPOS"
										path="chkMoveTableToOtherPOS" value="Yes" />
								</div>

							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 45%;">
									<label class="title">Print Zero Amount Modifiers In
										Bill </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 28%; margin-bottom: 10px;">
									<s:checkbox element="li" id="chkPrintZeroAmtModifierInBill"
										path="chkPrintZeroAmtModifierInBill" value="Yes" />
								</div>
								<div class="element-input col-lg-6" style="width: 50%;">
									<label class="title">Move KOT From One POS To Other POS
									</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 30%; margin-bottom: 10px;">
									<s:checkbox element="li" id="chkMoveKOTToOtherPOS"
										path="chkMoveKOTToOtherPOS" value="Yes" />
								</div>

							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 45%;">
									<label class="title">Points On Bill Print </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 28%; margin-bottom: 10px;">
									<s:checkbox element="li" id="chkPointsOnBillPrint"
										path="chkPointsOnBillPrint" value="Yes" />
								</div>
								<div class="element-input col-lg-6" style="width: 50%;">
									<label class="title">Calculate Tax on Make KOT </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 30%; margin-bottom: 10px;">
									<s:checkbox element="li" id="chkCalculateTaxOnMakeKOT"
										path="chkCalculateTaxOnMakeKOT" value="Yes" />
								</div>

							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 45%;">
									<label class="title">Calculate Discount Item Wise </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 28%; margin-bottom: 10px;">
									<s:checkbox element="li" id="chkCalculateDiscItemWise"
										path="chkCalculateDiscItemWise" value="Yes" />
								</div>
								<div class="element-input col-lg-6" style="width: 50%;">
									<label class="title">Take Away Customer Selection </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 30%; margin-bottom: 10px;">
									<s:checkbox element="li" id="chkTakewayCustomerSelection"
										path="chkTakewayCustomerSelection" value="Yes" />
								</div>

							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 45%;">
									<label class="title">Customer Address Selection For
										Billing</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 28%; margin-bottom: 10px;">
									<s:checkbox element="li" id="chkSelectCustAddressForBill"
										path="chkSelectCustAddressForBill" value="Yes" />
								</div>
								<div class="element-input col-lg-6" style="width: 50%;">
									<label class="title">Generate MI With DayEnd </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 30%; margin-bottom: 10px;">
									<s:checkbox element="li" id="chkGenrateMI" path="chkGenrateMI"
										value="Yes" />
								</div>

							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 45%;">
									<label class="title">Area Wise Promotion</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 28%; margin-bottom: 10px;">
									<s:checkbox element="li" id="chkAreaWisePromotions"
										path="strAreaWisePromotions" value="Yes" />
								</div>
								<div class="element-input col-lg-6" style="width: 50%;">
									<label class="title">Scan Or Y/N </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 30%; margin-bottom: 10px;">
									<s:checkbox element="li" id="strScanQRYN" path="strScanQRYN"
										value="Yes" />
								</div>

							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 45%;">
									<label class="title">Show Purchase Rate On Direct
										Biller</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 28%; margin-bottom: 10px;">
									<s:checkbox element="li" id="chkShowPurRateInDirectBiller"
										path="strShowPurRateInDirectBiller" value="Yes" />
								</div>
								<div class="element-input col-lg-6" style="width: 50%;">
									<label class="title">Enable Table reservation For
										Customer </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 30%; margin-bottom: 10px;">
									<s:checkbox element="li"
										id="chkEnableTableReservationForCustomer"
										path="strEnableTableReservationForCustomer" value="Yes" />
								</div>

							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 45%;">
									<label class="title">Print Home Delivery</label>
								</div>
								<div class="element-input col-lg-6" style="width: 28%;">
									<s:checkbox element="li" id="chkPrintHomeDeliveryYN"
										path="strPrintHomeDeliveryYN" value="Yes" />
								</div>
								<div class="element-input col-lg-6" style="width: 50%;">
									<label class="title">Effects Of Sale </label>
								</div>
								<div class="element-input col-lg-6" style="width: 15%;">
									<s:select id="cmbEffectOfSales" path="strEffectOfSales">
										<option value="Yes">Yes</option>
										<option value="No">No</option>
									</s:select>
								</div>

							</div>

						</div>


					</div> <!-- End of POS Setup 2 tab --> <!-- Start of POS Setup 3 tab -->

					<div id="tab5" class="tab_content">
						<div style="float: left; margin-left: 20%; margin-top: -48%">
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 49%;">
									<label class="title">Pop Up to Apply Promotions on Bill</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 8%; margin-bottom: 10px; margin-left: -20%">
									<s:checkbox element="li" id="chkPopUpToApplyPromotionsOnBill"
										path="chkPopUpToApplyPromotionsOnBill" value="Yes" />
								</div>
								<div class="element-input col-lg-6" style="width: 38%;">
									<label class="title">WebStock /HO Client Code</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 15%; margin-bottom: 10px;">
									<s:input type="text" id="txtWSClientCode"
										name="txtWSClientCode" path="strWSClientCode" />
								</div>

							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 49%;">
									<label class="title">Check Debit Card Bal on
										Transactions</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 8%; margin-bottom: 10px; margin-left: -20%">
									<s:checkbox element="li" id="chkCheckDebitCardBalOnTrans"
										path="strCheckDebitCardBalOnTransactions" value="Yes" />
								</div>
								<div class="element-input col-lg-6" style="width: 38%;">
									<label class="title">Days Before Order Can Be Cancelled</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 15%; margin-bottom: 10px;">
									<s:input type="text" id="txtDaysBeforeOrderToCancel"
										path="intDaysBeforeOrderToCancel" />
								</div>

							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 49%;">
									<label class="title">Pick Settlements from POS Master</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 8%; margin-bottom: 10px; margin-left: -20%">
									<s:checkbox element="li" id="chkSettlementsFromPOSMaster"
										path="chkSettlementsFromPOSMaster" value="Yes" />
								</div>
								<div class="element-input col-lg-6" style="width: 38%;">
									<label class="title">Dont allow Adv Order for next how
										many days</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 15%; margin-bottom: 10px;">
									<s:input type="text" id="txtNoOfDelDaysForAdvOrder"
										path="intNoOfDelDaysForAdvOrder" />
								</div>

							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 49%;">
									<label class="title">Enable Shift</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 8%; margin-bottom: 10px; margin-left: -20%">
									<s:checkbox element="li" id="chkShiftWiseDayEnd"
										path="chkShiftWiseDayEnd" value="Yes" />
								</div>
								<div class="element-input col-lg-6" style="width: 38%;">
									<label class="title">Allow Urgent Order for next how
										many days</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 15%; margin-bottom: 10px;">
									<s:input type="text" id="txtNoOfDelDaysForUrgentOrder"
										path="intNoOfDelDaysForUrgentOrder" />
								</div>

							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 49%;">
									<label class="title">Production Link Up</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 8%; margin-bottom: 10px; margin-left: -20%">
									<s:checkbox element="li" id="chkProductionLinkup"
										path="chkProductionLinkup" value="Yes" />
								</div>
								<div class="element-input col-lg-6" style="width: 38%;">
									<label class="title">Set UpTo Time For Adv Order </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 15%; margin-bottom: 10px;">
									<s:checkbox element="li" id="chkSetUpToTimeForAdvOrder"
										path="chkSetUpToTimeForAdvOrder" value="Yes" />
								</div>

							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 49%;">
									<label class="title">Lock Data On Shift</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 8%; margin-bottom: 10px; margin-left: -20%">
									<s:checkbox element="li" id="chkLockDataOnShift"
										path="chkLockDataOnShift" value="Yes" />
								</div>
								<div class="element-input col-lg-6" style="width: 38%;">
									<label class="title">Enable Bill Series</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px;">
									<s:checkbox element="li" id="chkEnableBillSeries"
										path="strEnableBillSeries" value="Yes" />
								</div>

							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 37%;">
									<label class="title">UpTo Time To Punch Adv Order</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 10%; margin-left: -9%">
									<s:select id="cmbHH" path="strHours">
										<option value="HH">HH</option>
										<option value="1">1</option>
										<option value="2">2</option>
										<option value="3">3</option>
										<option value="4">4</option>
										<option value="5">5</option>
										<option value="6">6</option>
										<option value="7">7</option>
										<option value="8">8</option>
										<option value="9">9</option>
										<option value="10">10</option>
										<option value="11">11</option>
										<option value="12">12</option>
									</s:select>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 10%;">
									<s:select id="cmbMM" path="strMinutes">
										<option value="MM">MM</option>
										<option value="00">00</option>
										<option value="01">01</option>
										<option value="02">02</option>
										<option value="03">03</option>
										<option value="04">04</option>
										<option value="05">05</option>
										<option value="06">06</option>
										<option value="07">07</option>
										<option value="08">08</option>
										<option value="09">09</option>
										<option value="10">10</option>
										<option value="11">11</option>
										<option value="12">12</option>
										<option value="13">13</option>
										<option value="14">14</option>
										<option value="15">15</option>
										<option value="16">16</option>
										<option value="17">17</option>
										<option value="18">18</option>
										<option value="19">19</option>
										<option value="20">20</option>
										<option value="21">21</option>
										<option value="22">22</option>
										<option value="23">23</option>
										<option value="24">24</option>
										<option value="25">25</option>
										<option value="26">26</option>
										<option value="27">27</option>
										<option value="28">28</option>
										<option value="29">29</option>
										<option value="30">30</option>
										<option value="31">31</option>
										<option value="32">32</option>
										<option value="33">33</option>
										<option value="34">34</option>
										<option value="35">35</option>
										<option value="36">36</option>
										<option value="37">37</option>
										<option value="38">38</option>
										<option value="39">39</option>
										<option value="41">41</option>
										<option value="42">42</option>
										<option value="43">43</option>
										<option value="44">44</option>
										<option value="45">45</option>
										<option value="46">46</option>
										<option value="47">47</option>
										<option value="48">48</option>
										<option value="49">49</option>
										<option value="50">50</option>
										<option value="51">51</option>
										<option value="52">52</option>
										<option value="53">53</option>
										<option value="54">54</option>
										<option value="55">55</option>
										<option value="56">56</option>
										<option value="57">57</option>
										<option value="58">58</option>
										<option value="59">59</option>
									</s:select>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 10%;">
									<s:select id="cmbAMPM" path="strAMPM">
										<option value="AM">AM</option>
										<option value="PM">PM</option>
									</s:select>
								</div>
                              </div>
                              <div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 37%; ">
									<label class="title">UpTo Time To Punch Urgent Order</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 10%; margin-left: -9%">
									<s:select id="cmbHoursUrgentOrder" path="strHoursUrgentOrder">
										<option value="HH">HH</option>
										<option value="1">1</option>
										<option value="2">2</option>
										<option value="3">3</option>
										<option value="4">4</option>
										<option value="5">5</option>
										<option value="6">6</option>
										<option value="7">7</option>
										<option value="8">8</option>
										<option value="9">9</option>
										<option value="10">10</option>
										<option value="11">11</option>
										<option value="12">12</option>
									</s:select>
								</div>
								<div class="element-input col-lg-6" style="width: 10%;">
									<s:select id="cmbMinutesUrgentOrder"
										path="strMinutesUrgentOrder">
										<option value="MM">MM</option>
										<option value="00">00</option>
										<option value="01">01</option>
										<option value="02">02</option>
										<option value="03">03</option>
										<option value="04">04</option>
										<option value="05">05</option>
										<option value="06">06</option>
										<option value="07">07</option>
										<option value="08">08</option>
										<option value="09">09</option>
										<option value="10">10</option>
										<option value="11">11</option>
										<option value="12">12</option>
										<option value="13">13</option>
										<option value="14">14</option>
										<option value="15">15</option>
										<option value="16">16</option>
										<option value="17">17</option>
										<option value="18">18</option>
										<option value="19">19</option>
										<option value="20">20</option>
										<option value="21">21</option>
										<option value="22">22</option>
										<option value="23">23</option>
										<option value="24">24</option>
										<option value="25">25</option>
										<option value="26">26</option>
										<option value="27">27</option>
										<option value="28">28</option>
										<option value="29">29</option>
										<option value="30">30</option>
										<option value="31">31</option>
										<option value="32">32</option>
										<option value="33">33</option>
										<option value="34">34</option>
										<option value="35">35</option>
										<option value="36">36</option>
										<option value="37">37</option>
										<option value="38">38</option>
										<option value="39">39</option>
										<option value="41">41</option>
										<option value="42">42</option>
										<option value="43">43</option>
										<option value="44">44</option>
										<option value="45">45</option>
										<option value="46">46</option>
										<option value="47">47</option>
										<option value="48">48</option>
										<option value="49">49</option>
										<option value="50">50</option>
										<option value="51">51</option>
										<option value="52">52</option>
										<option value="53">53</option>
										<option value="54">54</option>
										<option value="55">55</option>
										<option value="56">56</option>
										<option value="57">57</option>
										<option value="58">58</option>
										<option value="59">59</option>
									</s:select>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 10%;">
									<s:select id="cmbToAMPM" path="strAMPMUrgent">
										<option value="AM">AM</option>
										<option value="PM">PM</option>
									</s:select>
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 29%;">
									<label class="title">Enable PMS Integration</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 5%; margin-bottom: 10px;">
									<s:checkbox element="li" id="chkEnablePMSIntegration"
										path="chkEnablePMSIntegration" value="Yes" />
								</div>



								<div class="element-input col-lg-6"
									style="width: 30%; margin-left: 3%">
									<label class="title">Print Time On Bill</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 8%; margin-bottom: 5px;">
									<s:checkbox element="li" id="chkPrintTimeOnBill"
										path="chkPrintTimeOnBill" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 30%; margin-left: 0%">
									<label class="title">Print Remark And Reason For
										Reprint</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 10%; margin-bottom: 5px; margin-left: -5%">
									<s:checkbox element="li" id="chkPrintRemarkAndReasonForReprint"
										path="chkPrintRemarkAndReasonForReprint" value="Yes" />
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 29%;">
									<label class="title">Carry Forward Float Amt to Next
										Day</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 5%; margin-bottom: 10px;">
									<s:checkbox element="li" id="chkCarryForwardFloatAmtToNextDay"
										path="chkCarryForwardFloatAmtToNextDay" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 30%; margin-left: 3%">
									<label class="title">Show Item Details Grid For Change
										Customer On Bill</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 8%; margin-bottom: 5px;">
									<s:checkbox element="li"
										id="chkShowItemDtlsForChangeCustomerOnBill"
										path="chkShowItemDtlsForChangeCustomerOnBill" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 30%; margin-left: 0%">
									<label class="title">Enable Dine In</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 10%; margin-bottom: 5px; margin-left: -5%">
									<s:checkbox element="li" id="chkEnableDineIn"
										path="chkEnableDineIn" value="Yes" />
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 29%;">
									<label class="title">Enable Both Print And Settle Btn
										For DB</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 5%; margin-bottom: 10px;">
									<s:checkbox element="li"
										id="chkEnableBothPrintAndSettleBtnForDB"
										path="chkEnableBothPrintAndSettleBtnForDB" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 30%; margin-left: 3%">
									<label class="title">Show Pop Up For Next Item Quantity
									</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 8%; margin-bottom: 5px;">
									<s:checkbox element="li" id="chkShowPopUpForNextItemQuantity"
										path="chkShowPopUpForNextItemQuantity" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 30%; margin-left: 0%">
									<label class="title">New Bill Series For New Day</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 10%; margin-bottom: 5px; margin-left: -5%">
									<s:checkbox element="li" id="chkNewBillSeriesForNewDay"
										path="chkNewBillSeriesForNewDay" value="Yes" />
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 29%;">
									<label class="title">Open Cash Drawer After Bill Print</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 5%; margin-bottom: 10px;">
									<s:checkbox element="li" id="chkOpenCashDrawerAfterBillPrint"
										path="chkOpenCashDrawerAfterBillPrint" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 30%; margin-left: 3%">
									<label class="title">Property Wise Sales Order </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 8%; margin-bottom: 5px;">
									<s:checkbox element="li" id="strPropertyWiseSalesOrderYN"
										path="strPropertyWiseSalesOrderYN" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 30%; margin-left: 0%">
									<label class="title">Show Only Login POS Reports</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 10%; margin-bottom: 5px; margin-left: -5%">
									<s:checkbox element="li" id="chkShowReportsPOSWise"
										path="chkShowReportsPOSWise" value="Yes" />
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 29%;">
									<label class="title">Auto Area Selection In Make KOT</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 5%; margin-bottom: 10px;">
									<s:checkbox element="li" id="chkAutoAreaSelectionInMakeKOT"
										path="chkAutoAreaSelectionInMakeKOT" value="Yes" />
								</div>

								<div class="element-input col-lg-6"
									style="width: 30%; margin-left: 3%">
									<label class="title">Show UnSettlement Form</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 8%; margin-bottom: 5px;">
									<s:checkbox element="li" id="strShowUnSettlementForm"
										path="strShowUnSettlementForm" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 30%; margin-left: 0%">
									<label class="title">Print Open Items On Bill</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 10%; margin-bottom: 5px; margin-left: -5%">
									<s:checkbox element="li" id="chkPrintOpenItemsOnBill"
										path="strPrintOpenItemsOnBill" value="Yes" />
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 25%;">
									<label class="title">Rounding Off To</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 5%; margin-bottom: 10px;">
									<s:input type="text" id="txtRoundOff" path="dblRoundOff" />
								</div>

								<div class="element-input col-lg-6"
									style="width: 30%; margin-left: 10%">
									<label class="title">Auto Show Popular items for last</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 10%; margin-bottom: 5px;">
									<s:input type="text" id="txtShowPopItemsOfDays"
										path="intShowPopItemsOfDays" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 30%; margin-left: 10%">
									<s:checkbox element="li" id="chkAutoShowPopItems"
										path="strAutoShowPopItems" value="Yes" />
								</div>

							</div>
						</div>

					</div> <!-- End of POS Setup 3 tab --> <!-- 	Start of property setup tab 4 -->
					<div id="tab6" class="tab_content">
						<div style="float: left; margin-left: 20%; margin-top: -48%">

							<div class="row"
								style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
								<div class="element-input col-lg-6" style="width: 20%;">
									<label class="title">Area Wise Pricing </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 8%; margin-left: 5%">
									<s:checkbox element="li" id="chkAreaWisePricing"
										path="chkAreaWisePricing" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 35%; margin-left: 0%">
									<label class="title">Area Wise Cost Center KOT Printing</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 25%; margin-left: -10%">
									<s:checkbox element="li"
										id="strAreaWiseCostCenterKOTPrintingYN"
										path="strAreaWiseCostCenterKOTPrintingYN" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 40%; margin-left: -20%">
									<label class="title">Round Off Bill Final Amount</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 40%; margin-left: -15%">
									<s:checkbox element="li" id="chkRoundOffBillAmount"
										path="chkRoundOffBillAmount" value="Yes" />
								</div>
							</div>

							<div class="row"
								style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
								<div class="element-input col-lg-6" style="width: 20%;">
									<label class="title">Print Quantity Total</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 8%; margin-left: 5%">
									<s:checkbox element="li" id="chkPrintQtyTotal"
										path="chkPrintQtyTotal" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 35%; margin-left: 0%">
									<label class="title">Print Order No On Bill</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 25%; margin-left: -10%">
									<s:checkbox element="li" id="chkPrintOrderNoOnBill"
										path="chkPrintOrderNoOnBill" value="Yes" />
								</div>

								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 40%; margin-left: -20%">
									<label class="title">Auto Add KOT To Bill</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 40%; margin-left: -15%">
									<s:checkbox element="li" id="chkAutoAddKOTToBill"
										path="chkAutoAddKOTToBill" value="Yes" />
								</div>
							</div>

							<div class="row"
								style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
								<div class="element-input col-lg-6" style="width: 30%;">
									<label class="title">Send Database Backup On Mail</label>
								</div>

								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 33%; margin-left: -5%">
									<s:checkbox element="li" id="chkSendDBBackupOnMail"
										path="chkSendDBBackupOnMail" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 25%; margin-left: -25%">
									<label class="title">Print Move Table,Move KOT</label>
								</div>

								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 35%; margin-left: 0%">
									<s:checkbox element="li" id="chkPrintMoveTableMoveKOT"
										path="chkPrintMoveTableMoveKOT" value="Yes" />
								</div>

								<div class="element-input col-lg-6"
									style="width: 30%; margin-left: -30%">
									<label class="title">Print Device,User Detail on KOT</label>
								</div>

								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 40%; margin-left: -5%">
									<s:checkbox element="li" id="chkPrintDeviceUserDtlOnKOT"
										path="chkPrintDeviceUserDtlOnKOT" value="Yes" />
								</div>


							</div>

							<div class="row"
								style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
								<div class="element-input col-lg-6" style="width: 30%;">
									<label class="title">Fire Communication</label>
								</div>

								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 33%; margin-left: -5%">
									<s:checkbox element="li" id="chkFireCommunication"
										path="chkFireCommunication" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 25%; margin-left: -25%">
									<label class="title">Merge All KOTs TO Bill</label>
								</div>

								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 35%; margin-left: 0%">
									<s:checkbox element="li" id="strMergeAllKOTSToBill"
										path="strMergeAllKOTSToBill" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 30%; margin-left: -30%">
									<label class="title">Lock Table For Waiter</label>
								</div>

								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 40%; margin-left: -5%">
									<s:checkbox element="li" id="chkLockTableForWaiter"
										path="chkLockTableForWaiter" value="Yes" />
								</div>


							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 40%;">
									<label class="title">Dine In Area For Direct Biller</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 20%; margin-left: -15%">
									<s:select id="cmbDineInAreaForDirectBiller"
										path="strDineInAreaForDirectBiller" items="${areaList}">
									</s:select>
								</div>

								<div class="element-input col-lg-6" style="width: 35%;">
									<label class="title">Home Delivery Area For Direct
										Biller</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 22%; margin-left: -10%">
									<s:select id="cmbHomeDeliveryAreaForDirectBiller"
										path="strHomeDeliveryAreaForDirectBiller" items="${areaList}">

									</s:select>
								</div>

							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 40%;">
									<label class="title">Take Away Area For Direct Biller</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 20%; margin-left: -15%">
									<s:select id="cmbTakeAwayAreaForDirectBiller"
										path="strTakeAwayAreaForDirectBiller" items="${areaList}">
									</s:select>
								</div>

								<div class="element-input col-lg-6" style="width: 35%;">
									<label class="title">Service Charge Tax </label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 22%; margin-left: -10%">
									<s:select id="cmbRemoveServiceChargeTaxCode"
										path="strRemoveServiceChargeTaxCode" items="${taxList}">

									</s:select>
								</div>

							</div>

							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 25%;">
									<label class="title">Show Reports In Currency</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 11%; margin-left: -5%">
									<s:select id="cmbShowReportsInCurrency"
										path="strShowReportsInCurrency">
										<option value="BASE">BASE</option>
										<option value="USD">USD</option>
									</s:select>
								</div>

								<div class="element-input col-lg-6" style="width: 24%;">
									<label class="title">POS To MMS Posting Currency</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 11%;">
									<s:select id="cmbPOSToMMSPostingCurrency"
										path="strPOSToMMSPostingCurrency">
										<option value="BASE">BASE</option>
										<option value="USD">USD</option>
									</s:select>
								</div>

								<div class="element-input col-lg-6" style="width: 22%;">
									<label class="title">POS To WebBook Posting Currency</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 11%;">
									<s:select id="cmbPOSToWebBooksPostingCurrency"
										path="strPOSToWebBooksPostingCurrency">
										<option value="BASE">BASE</option>
										<option value="USD">USD</option>
									</s:select>
								</div>

							</div>

							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 30%;">
									<label class="title">No Of Decimal Places</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 20%; margin-left: -5%; size: 1%;">
									<s:input type="text" id="txtNoOfDecimalPlaces"
										path="intNoOfDecimalPlaces" />
								</div>

								<div class="element-input col-lg-6" style="width: 27%;">
									<label class="title">USD Currency Convertion Rate</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 20%;">
									<s:input type="text" id="txtUSDCrrencyConverionRate"
										path="dblUSDCrrencyConverionRate" />
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
								<div class="element-input col-lg-6" style="width: 30%;">
									<label class="title">Print Items On Move KOT,Move
										Table,Move KOT Items</label>
								</div>

								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 33%; margin-left: -5%">
									<s:checkbox element="li" id="chkPrintItemsOnMoveKOTMoveTable"
										path="chkPrintItemsOnMoveKOTMoveTable" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 25%; margin-left: -25%">
									<label class="title">Print Original On Bill</label>
								</div>

								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 35%; margin-left: 0%">
									<s:checkbox element="li" id="chkPrintOriginalOnBill"
										path="strPrintOriginalOnBill" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 30%; margin-left: -30%">
									<label class="title">Show Notifications On Transaction</label>
								</div>

								 	<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 40%; margin-left: -5%">
									<s:checkbox element="li" id="strShowNotificationsOnTransaction"
										path="strShowNotificationsOnTransaction" value="Yes" />
								</div> 


							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
								<div class="element-input col-lg-6" style="width: 30%;">
									<label class="title">Blank Day End Print </label>
								</div>

								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 33%; margin-left: -5%">
									<s:checkbox element="li" id="strBlankDayEndPrint"
										path="strBlankDayEndPrint" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 25%; margin-left: -25%">
									<label class="title">Online Order Notification</label>
								</div>

								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 35%; margin-left: 0%">
									<s:checkbox element="li" id="strOnlineOrderNotification"
										path="strOnlineOrderNotification" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 30%; margin-left: -30%">
									<label class="title">Post Round Off To WebBooks</label>
								</div>

								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 40%; margin-left: -5%">
									<s:checkbox element="li" id="chkPostRoundOffToWebBooks"
										path="strPostRoundOffToWebBooks" value="Yes" />
								</div>


							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
								<div class="element-input col-lg-6" style="width: 30%;">
									<label class="title">Display Total Show Bill </label>
								</div>

								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 33%; margin-left: -5%">
									<s:checkbox element="li" id="strDisplayTotalShowBill"
										path="strDisplayTotalShowBill" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 25%; margin-left: -25%">
									<label class="title">User Wise Show Bill</label>
								</div>

								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 35%; margin-left: 0%">
									<s:checkbox element="li" id="strUserWiseShowBill"
										path="strUserWiseShowBill" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 30%; margin-left: -30%">
									<label class="title">Post Sales Data To Excise</label>
								</div>

								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 40%; margin-left: -5%">
									<s:checkbox element="li" id="chkPostSalesDataToExcise"
										path="strPostSalesDataToExcise" value="Yes" />
								</div>


							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
								<div class="element-input col-lg-6" style="width: 30%;">
									<label class="title">Cash Denomination Compulsory on
										Blank Day End</label>
								</div>

								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 33%; margin-left: -5%">
									<s:checkbox element="li" id="strCashDenominationCompulsary"
										path="strCashDenominationCompulsary" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 25%; margin-left: -25%">
									<label class="title">Cash Management Compulsory on
										Blank Day End</label>
								</div>

								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 35%; margin-left: 0%">
									<s:checkbox element="li" id="strCashManagementCompulsary"
										path="strCashManagementCompulsary" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 30%; margin-left: -30%">
									<label class="title">Print Full Void Bill </label>
								</div>

								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 40%; margin-left: -5%">
									<s:checkbox element="li" id="strPrintFullVoidBill"
										path="strPrintFullVoidBill" value="Yes" />
								</div>
								
                                
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
								<div class="element-input col-lg-6" style="width: 28%;">
									<label class="title">Item Short Name on Direct Biller &
										Bill</label>
								</div>

								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 40%; margin-left: -3%">
									<s:checkbox element="li" id="strShortNameOnDirectBillerAndBill"
										path="strShortNameOnDirectBillerAndBill" value="Yes" />
								</div>

							</div>

						</div>
					</div> <!-- End of POS Setup 4 tab --> <!-- 	Start of Email Setup tab -->

					<div id="tab7" class="tab_content">
						<div style="float: left; margin-left: 25%; margin-top: -47%">
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">Sender Email Id</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input class="large" type="text" id="txtSenderEmailId"
										path="strSenderEmailId" />
								</div>
							</div>

							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">Password</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input class="large" type="password" id="txtEmailPassword"
										path="strEmailPassword" />
								</div>
							</div>

							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">Confirm Password</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input class="large" type="password" id="txtEmailConfirmPassword"
										path="" />
								</div>
							</div>


							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">SMTP Server Name</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:select id="cmbEmailServerName" path="strEmailServerName">
										<option value="smtp.gmail.com">Gmail</option>
										<option value="smtp.mail.yahoo.com">Yahoo</option>

									</s:select>
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">SMTP Host</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input class="large" type="text" id="txtEmailSmtpHost"
										path="strEmailSmtpHost" />
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">SMTP Port</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input class="large" type="text" id="txtEmailSmtpPort"
										path="strEmailSmtpPort" />
								</div>
							</div>

							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">Receiver Email Id</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input class="large" type="text" id="txtReceiverEmailId"
										path="strReceiverEmailId" />
								</div>
							</div>

							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">DB Backup Receiver</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input class="large" type="text"
										id="txtDBBackupReceiverEmailId" path="strDBBackupReceiverEmailId" />
								</div>
							</div>

							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">Mail Body</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:textarea class="large" type="text" id="txtBodyPart"
										path="strBodyPart" style="height:100px" />
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<input id="btnSendTestEMail" type="button" value="Test Email"
										onclick="funCheckEmailSendingStatus();"></input>
								</div>

							</div>

						</div>
					</div> <!-- 	End of Email Setup tab --> <!-- 	Start of Card Interface tab -->

					<div id="tab8" class="tab_content">
						<div style="float: left; margin-left: 25%; margin-top: -47%">

							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">Card Interface Type</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:select id="cmbCardIntfType" path="strCardIntfType">
										<option value="Customer Card">Customer Card</option>
										<option value="Member Card">Member Card</option>
									</s:select>
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">Card Interface</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:select id="cmbRFIDSetup" path="strRFIDSetup">
										<option value="N">NO</option>
										<option value="Y">YES</option>

									</s:select>
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">Server Name</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input class="large" colspan="3" type="text"
										id="txtRFIDServerName" path="strRFIDServerName" />
								</div>
							</div>

							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">User Name</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input class="large" colspan="3" type="text"
										id="txtRFIDUserName" path="strRFIDUserName" />
								</div>
							</div>


							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">Password</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input class="large" colspan="3" type="text"
										id="txtRFIDPassword" path="strRFIDPassword" />
								</div>
							</div>

							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">Database Name</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input class="large" colspan="3" type="text"
										id="txtRFIDDatabaseName" path="strRFIDDatabaseName" />
								</div>
							</div>
						</div>

					</div> <!-- 	End of Card Interface tab --> <!-- 	Start of CRM Interface tab -->

					<div id="tab9" class="tab_content">
						<div style="float: left; margin-left: 25%; margin-top: -47%">
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">CRM Interface</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:select id="cmbCRM" path="strCRM">
										<option value="SQY">SQY CRM Interface</option>
										<option value="PMAM">PMAM CRM Interface</option>
										<option value="JPOS">JPOS CRM Interface</option>
									</s:select>
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">SQY WebService URL(GET)</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input class="large" colspan="3" type="text"
										id="txtGetWebservice" path="strGetWebservice" />
								</div>
							</div>

							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">SQY WebService URL(POST)</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input class="large" colspan="3" type="text"
										id="txtPostWebservice" path="strPostWebservice" />
								</div>
							</div>

							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">SQY Outlet UID</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input class="large" colspan="3" type="text"
										id="txtOutletUID" path="strOutletUID" />
								</div>
							</div>

							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">SQY POS ID</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input class="large" colspan="3" type="text" id="txtPOSID"
										path="strPOSID" />
								</div>
							</div>

						</div>


					</div> <!-- 	End of CRM Interface tab --> <!-- 	Start of SMS Setup tab -->

					<div id="tab10" class="tab_content">
						<div style="float: left; margin-left: 20%; margin-top: -47%">


							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 28%;">
									<label class="title">SMS Type</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 26%; margin-left: -5%;">
									<s:select id="cmbSMSType" path="strSMSType">
										<option value="SINFINI">SINFINI</option>
										<option value="CELLX">CELLX</option>
										<option value="INFYFLYER">INFYFLYER</option>
									</s:select>
								</div>
								<div class="element-input col-lg-6"
									style="width: 30%; margin-left: -0.5%">
									<label class="title">SMS API</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%; margin-left: -15%;">
									<s:textarea id="txtAreaSMSApi" path="strAreaSMSApi"
										style="height:30px" />
								</div>


							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
								<div class="element-input col-lg-6" style="width: 38%;">
									<label class="title" style="width: 100%">Mobile Nos. </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 60%; margin-left: -15%;">
									<s:input class="large" colspan="3" type="text"
										id="txtSMSMobileNo" path="longSMSMobileNo" style="width: 40%" />
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%; margin-left: 12%">
									<input type="Button" style="margin-left: -79%;"
										value="Send Test SMS" onclick="funCheckSMSSendingStatus();" />
								</div>
							</div>

							<div class="row"
								style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
								<div class="element-input col-lg-6" style="width: 38%;">
									<label class="title" style="width: 100%">Home Delivery
										SMS </label>
								</div>

								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px; margin-left: -15%;">
									<s:input type="checkbox" id="chkHomeDelSMS"
										path="chkHomeDelSMS"></s:input>
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px; margin-left: -12%">
									<s:select id="cmbSendHomeDelivery" path="">
										<option value="BILL NO">BILL NO</option>
										<option value="CUSTOMER NAME">CUSTOMER NAME</option>
										<option value="DATE">DATE</option>
										<option value="DELIVERY BOY">DELIVERY BOY</option>
										<option value="ITEMS">ITEMS</option>
										<option value="BILL AMT">BILL AMT</option>
										<option value="USER">USER</option>
										<option value="TIME">TIME</option>
									</s:select>
								</div>
								<div class="element-input col-lg-6"
									style="width: 22%; margin-bottom: 10px">
									<input id="btnAddDelSMS" type="button" value=">>"
										onclick="return btnAddDelSMS_onclick();"></input>
								</div>
								<div class="element-input col-lg-6"
									style="width: 50%; margin-bottom: 10px">
									<s:textarea id="txtAreaSendHomeDeliverySMS"
										path="strAreaSendHomeDeliverySMS" style="height:100px" />
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
								<div class="element-input col-lg-6" style="width: 38%;">
									<label class="title" style="width: 100%">Bill
										Settlement SMS </label>
								</div>

								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px; margin-left: -15%;">
									<s:checkbox element="li" id="chkBillSettlementSMS"
										path="chkBillSettlementSMS" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px; margin-left: -12%">
									<s:select id="cmbBillSettlement" path="">
										<option value="BILL NO">BILL NO</option>
										<option value="CUSTOMER NAME">CUSTOMER NAME</option>
										<option value="DATE">DATE</option>
										<option value="DELIVERY BOY">DELIVERY BOY</option>
										<option value="ITEMS">ITEMS</option>
										<option value="BILL AMT">BILL AMT</option>
										<option value="USER">USER</option>
										<option value="TIME">TIME</option>

									</s:select>
								</div>
								<div class="element-input col-lg-6"
									style="width: 22%; margin-bottom: 10px">
									<input id="btnAddSettleSMS" type="button" value=">>"
										onclick="return btnAddSettleSMS_onclick();"></input>
								</div>
								<div class="element-input col-lg-6"
									style="width: 50%; margin-bottom: 10px">
									<s:textarea id="txtAreaBillSettlementSMS"
										path="strAreaBillSettlementSMS" style="height:100px" />
								</div>
							</div>

							<div class="row"
								style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
								<div class="element-input col-lg-6" style="width: 38%;">
									<label class="title" style="width: 100%">Table
										Reservation SMS </label>
								</div>

								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px; margin-left: -15%;">
									<s:checkbox element="li" id="chkSendTableReservationSMS"
										path="strSendTableReservationSMS" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px; margin-left: -12%">
									<s:select id="cmbSendTableReservation" path="">
										<option value="RESERVATION TIME">RESERVATION TIME</option>
										<option value="PAX NUMBER">PAX NUMBER</option>
										<option value="RESERVEATION DATE">RESERVEATION DATE</option>
										<option value="CUSTOMER NAME">CUSTOMER NAME</option>
										<option value="POS NAME">POS NAME</option>
										<option value="TABLE NAME">TABLE NAME</option>
										<option value="USER">USER</option>
										<option value="TIME">TIME</option>

									</s:select>
								</div>
								<div class="element-input col-lg-6"
									style="width: 22%; margin-bottom: 10px">
									<input id="btnAddTAbleReservationSMS" type="button" value=">>"
										onclick="return btnAddBtnFor_Send_Table_Reservation();"></input>
								</div>
								<div class="element-input col-lg-6"
									style="width: 50%; margin-bottom: 10px">
									<s:textarea id="txtTableReservationSMS"
										path="strTableReservationSMS" style="height:100px" />
								</div>
							</div>

							<div class="row"
								style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">
								<div class="element-input col-lg-6" style="width: 38%;">
									<label class="title" style="width: 100%">Audit SMS </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px; margin-left: -15%;">
									<label class="title" style="width: 100%"> Day End </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px; margin-left: -5%;">
									<s:checkbox element="li" id="chkDayEndSMSYN"
										path="strDayEndSMSYN" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px; margin-left: -15%;">
									<label class="title" style="width: 100%"> Void KOT </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px; margin-left: -5%;">
									<s:checkbox element="li" id="chkVoidKOTSMSYN"
										path="strVoidKOTSMSYN" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px; margin-left: -15%;">
									<label class="title" style="width: 100%">NC KOT </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px; margin-left: -5%;">
									<s:checkbox element="li" id="chkNCKOTSMSYN"
										path="strNCKOTSMSYN" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px; margin-left: -15%;">
									<label class="title" style="width: 100%">Void Advance
										Order </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px; margin-left: -5%;">
									<s:checkbox element="li" id="chkVoidAdvOrderSMSYN"
										path="strVoidAdvOrderSMSYN" value="Yes" />
								</div>

							</div>

							<div class="row"
								style="background-color: #fff; display: -webkit-box; margin-bottom: 10px;">

								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px; margin-left: 23%;">
									<label class="title" style="width: 100%"> Void Bill </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px; margin-left: -5%;">
									<s:checkbox element="li" id="chkVoidBill" path="strVoidBill"
										value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px; margin-left: -15%;">
									<label class="title" style="width: 100%"> Complimentary
										Bill </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px; margin-left: -5%;">
									<s:checkbox element="li" id="chkComplimentaryBill"
										path="strComplimentaryBill" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px; margin-left: -15%;">
									<label class="title" style="width: 100%">Settle Bill </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px; margin-left: -5%;">
									<s:checkbox element="li" id="chkSettleBill"
										path="strSettleBill" value="Yes" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px; margin-left: -15%;">
									<label class="title" style="width: 100%">Modify Bill
										Order </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px; margin-left: -5%;">
									<s:checkbox element="li" id="chkModifyBill"
										path="strModifyBill" value="Yes" />
								</div>

							</div>
						</div>
						<%-- <table>
							
							
									<div>
										<label>Bill Settlement SMS</label>
										<s:checkbox element="li" id="chkBillSettlementSMS"
											path="chkBillSettlementSMS" value="Yes" />
										<br>
										<s:select id="cmbBillSettlement" path="">
											<option value="BILL NO">BILL NO</option>
											<option value="CUSTOMER NAME">CUSTOMER NAME</option>
											<option value="DATE">DATE</option>
											<option value="DELIVERY BOY">DELIVERY BOY</option>
											<option value="ITEMS">ITEMS</option>
											<option value="BILL AMT">BILL AMT</option>
											<option value="USER">USER</option>
											<option value="TIME">TIME</option>

										</s:select>
										<br> <br> <input id="btnAddSettleSMS" type="button"
											class="smallButton" value=">>"
											onclick="return btnAddSettleSMS_onclick();"></input>
									</div>
								</td>

								<td><s:textarea id="txtAreaBillSettlementSMS"
										path="strAreaBillSettlementSMS" style="height:100px" /></td>
							</tr>
							<tr>
								<td>
									<div>
										<label>Table Reservation SMS</label>
										<s:checkbox element="li" id="chkSendTableReservationSMS"
											path="strSendTableReservationSMS" value="Yes" />
										<br>
										<s:select id="cmbSendTableReservation" path="">
											<option value="BILL NO">RESERVATION TIME</option>
											<option value="CUSTOMER NAME">PAX NUMBER</option>
											<option value="DATE">RESERVEATION DATE</option>
											<option value="DELIVERY BOY">CUSTOMER NAME</option>
											<option value="ITEMS">POS NAME</option>
											<option value="BILL AMT">TABLE NAME</option>
											<option value="USER">USER</option>
											<option value="TIME">TIME</option>

										</s:select>
										<br> <br> <input id="btnAddTAbleReservationSMS"
											type="button" class="smallButton" value=">>"></input>
									</div>
								</td>

								<td><s:textarea id="txtTableReservationSMS"
										path="strTableReservationSMS" style="height:100px" /></td>
							</tr>


							<tr>
								<td><label>Audit SMS</label></td>

								<td><label>Day End</label> <s:checkbox element="li"
										id="chkDayEndSMSYN" path="strDayEndSMSYN" value="Yes" /> <label>Void
										KOT</label> <s:checkbox element="li" id="chkVoidKOTSMSYN"
										path="strVoidKOTSMSYN" value="Yes" /> <label>NC KOT</label> <s:checkbox
										element="li" id="chkNCKOTSMSYN" path="strNCKOTSMSYN"
										value="Yes" /> <label>Void Advance Order</label> <s:checkbox
										element="li" id="chkVoidAdvOrderSMSYN"
										path="strVoidAdvOrderSMSYN" value="Yes" /> <label>Void
										Bill</label> <s:checkbox element="li" id="chkVoidBill"
										path="strVoidBill" value="Yes" /> <label>Complimentary
										Bill</label> <s:checkbox element="li" id="chkComplimentaryBill"
										path="strComplimentaryBill" value="Yes" /> <label>Settle
										Bill</label> <s:checkbox element="li" id="chkSettleBill"
										path="strSettleBill" value="Yes" /> <label>Modify
										Bill</label> <s:checkbox element="li" id="chkModifyBill"
										path="strModifyBill" value="Yes" /></td>
							</tr>


						</table> --%>

					</div> <!-- 	End of SMS Setup tab --> <!-- 	Start of FTP Setup tab -->

					<div id="tab11" class="tab_content">

						<div style="float: left; margin-left: 25%; margin-top: -47%">
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">FTP Server Address</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input class="large" colspan="3" type="text"
										id="txtFTPAddress" path="strFTPAddress" />
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">FTP Server User Name</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input class="large" colspan="3" type="text"
										id="txtFTPServerUserName" path="strFTPServerUserName" />
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">FTP Server Password</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input class="large" colspan="3" type="text"
										id="txtFTPServerPass" path="strFTPServerPass" />
								</div>
							</div>
						</div>


					</div> <!-- 	End of FTP Setup tab --> <!-- 	Start of CMS Integration tab -->

					<div id="tab12" class="tab_content">

						<div style="float: left; margin-left: 25%; margin-top: -47%">
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">CMS Integration</label>
								</div>

								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 20%; margin-left: -20%; margin-bottom: 10px">
									<s:select id="cmbCMSIntegrationYN" path="strCMSIntegrationYN">
										<option value="N">No</option>
										<option value="Y">Yes</option>
									</s:select>
								</div>

							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">Web Service URL</label>
								</div>

								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 50%; margin-left: -20%; margin-bottom: 10px">
									<s:input class="large" colspan="3" type="text"
										id="txtCMSWesServiceURL" path="strCMSWesServiceURL" />
								</div>

							</div>

							<div class="row"
								style="background-color: #fff; display: -webkit-box; margin-bottom: 10px">

								<div class="element-input col-lg-6" style="width: 80%;">
									<label class="title">Treat Member As Table</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 8%; margin-left: -30%; margin-bottom: 10px">
									<s:input type="checkbox" id="chkMemberAsTable"
										path="chkMemberAsTable"></s:input>
								</div>
								<div class="element-input col-lg-6" style="width: 75%;">
									<label class="title">Member Code For KOT In MPOS</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-left: -30%">
									<s:input type="checkbox" id="chkMemberCodeForKOTMPOS"
										path="chkMemberCodeForKOTMPOS"></s:input>
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box; margin-bottom: 10px">

								<div class="element-input col-lg-6" style="width: 80%;">
									<label class="title">Member Code For KOT In JPOS</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 8%; margin-left: -30%">
									<s:input type="checkbox" id="chkMemberCodeForKOTJPOS"
										path="chkMemberCodeForKOTJPOS"></s:input>
								</div>

								<div class="element-input col-lg-6" style="width: 75%;">
									<label class="title">Member Code For Make Bill In MPOS</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-left: -30%">
									<s:input type="checkbox" id="chkMemberCodeForMakeBillInMPOS"
										path="chkMemberCodeForMakeBillInMPOS"></s:input>
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box; margin-bottom: 10px">

								<div class="element-input col-lg-6" style="width: 50%;">
									<label class="title">Member Code For KOT In MPOS By
										Card Swipe</label>
								</div>
								<div class="element-input col-lg-6" style="width: 8%;">
									<s:input type="checkbox"
										id="chkMemberCodeForKotInMposByCardSwipe"
										path="chkMemberCodeForKotInMposByCardSwipe"></s:input>
								</div>
								<div class="element-input col-lg-6" style="width: 75%;">
									<label class="title">Select Customer Code From Card
										Swipe</label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-left: -30%">
									<s:input type="checkbox"
										id="chkMemberCodeForKotInMposByCardSwipe"
										path="chkMemberCodeForKotInMposByCardSwipe"></s:input>
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box; margin-bottom: 10px">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">CMS Posting Type </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-left: -20%">
									<s:select id="cmbCMSPostingType" path="strCMSPostingType">
										<option value="Sanguine CMS">Sanguine CMS</option>
										<option value="Others">Others</option>
									</s:select>
								</div>
							</div>
						</div>
					</div> <!-- 	End of CMS Integration tab --> <!-- 	Start of Printer Setup tab -->

					<div id="tab13" class="tab_content">
						<div style="float: left; margin-left: 25%; margin-top: -47%">

							<table border="1" style="width: 100%; margin: auto;">

								<tr>

									<td
										style="width: 30%; border: #c0c0c0 1px solid; background: #2FABE9; color: white;">Cost
										Center Name</td>
									<td
										style="width: 25%; border: #c0c0c0 1px solid; background: #2FABE9; color: white;">Primary
										Printer</td>
									<td
										style="width: 25%; border: #c0c0c0 1px solid; background: #2FABE9; color: white;">Secondary
										Printer</td>
									<td
										style="width: 60%; border: #c0c0c0 1px solid; background: #2FABE9; color: white;">Print
										On Both Printer</td>
								</tr>
							</table>
							<div
								style="border: 1px solid #ccc; display: block; height: 380px; margin: auto; overflow-x: hidden; overflow-y: scroll; width: 100%; margin-bottom: 10px">
								<table id="tblPrinterDtl"
									style="width: 100%; margin-bottom: 10px">
									<tbody>
									<col style="width: 0%">
									<!--  COl1   -->
									<col style="width: 30%">
									<!--  COl1   -->
									<col style="width: 25%">
									<!--  COl2   -->
									<col style="width: 25%">
									<!--  COl2   -->
									<col style="width: 60%">
									<!--  COl3   -->

									</tbody>
								</table>


							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6"
									style="width: 60%; margin-bottom: 10px">
									<label class="title">Consolidated KOT Printer </label>
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px; margin-left: -35%">
									<s:select id="cmbConsolidatedKOTPrinterPort"
										name="cmbConsolidatedKOTPrinterPort"
										path="strConsolidatedKOTPrinterPort" items="${printerList}" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px">
									<s:input type="text" id="txtConsolidatedKOTPrinterPort" path="" />
								</div>
								<div class="element-input col-lg-6"
									style="width: 20%; margin-bottom: 10px; margin-left: 10%">
									<input id="btnTestConsolidatedKOTPrinter" type="button"
										value="Test" onclick="funTestPrinterStatus();"></input>
								</div>
							</div>
						</div>
					</div> <!-- 	End of Printer Setup tab --> <!-- 	Start of Debit Card Setup tab -->

					<div id="tab14" class="tab_content">
						<div style="float: left; margin-left: 25%; margin-top: -47%">

							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 90%;">
									<label class="title">Last POS Day For Day End</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%; margin-left: 0%">
									<s:select id="cmbPOSForDayEnd" path="strPOSForDayEnd"
										items="${posListForDayEnd}">

									</s:select>
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 90%;">
									<label class="title">Enable NFC Interface</label>
								</div>
								<div class="element-input col-lg-6" style="width: 20%;">
									<s:input type="checkbox" id="chkEnableNFCInterface"
										path="chkEnableNFCInterface"></s:input>
								</div>
							</div>
						</div>



					</div> <!-- 	End of Debit Card Setup tab --> <!-- 	Start of Inresto Integration Setup tab -->

					<div id="tab15" class="tab_content">

						<div style="float: left; margin-left: 25%; margin-top: -47%">
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">Inresto Integration</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%; margin-left: 0%">
									<s:select id="cmbInrestoPOSIntegrationYN"
										path="strInrestoPOSIntegrationYN">
										<option value="N">No</option>
										<option value="Y">Yes</option>
									</s:select>
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">Web Service URL</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input class="large" colspan="3" type="text"
										id="txtInrestoPOSWesServiceURL"
										path="strInrestoPOSWesServiceURL" />
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">Inresto POS ID</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input class="large" colspan="3" type="text"
										id="txtInrestoPOSId" path="strInrestoPOSId" />
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">Inresto POS KEY</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input class="large" colspan="3" type="text"
										id="txtInrestoPOSKey" path="strInrestoPOSKey" />
								</div>
							</div>
						</div>
					</div> <!-- 	End of Inresto Integration Setup tab --> <!-- 	Start of Jio Integration Setup tab -->

					<div id="tab16" class="tab_content">


						<div style="float: left; margin-left: 25%; margin-top: -47%">
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6">
									<label class="title">JIOMoney Integration</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%; margin-left: 10%">
									<s:select id="cmbJioPOSIntegrationYN"
										path="strJioPOSIntegrationYN">
										<option value="N">No</option>
										<option value="Y">Yes</option>
									</s:select>
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">Web Service URL</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input class="large" colspan="3" type="text"
										id="txtJioPOSWesServiceURL" path="strJioPOSWesServiceURL" />
								</div>
							</div>

							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">JioMoney Merchant ID</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input class="large" colspan="3" type="text" id="txtJioMID"
										path="strJioMID" />
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">JioMoney Terminal ID</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input class="large" colspan="3" type="text" id="txtJioTID"
										path="strJioTID" />
								</div>
							</div>


							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">Activation Code</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input class="large" colspan="3" type="text"
										id="txtJioActivationCode" path="strJioActivationCode" />
								</div>
							</div>

							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">Device ID</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input class="large" colspan="3" type="text"
										id="txtJioDeviceID" path="strJioDeviceID" />
								</div>

								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input type="button" colspan="3" id="btnFetchID"
										path="strSuperMerchantCode" value="Fetch ID"
										onclick="return btnFetchID_onclick();" />


								</div>


							</div>

						</div>
					</div> <!-- 	End of Jio Integration Setup tab --> <!-- 	Start of Benow Integration Setup tab -->

					<div id="tab17" class="tab_content">
						<br> <br>
						<div style="float: left; margin-left: 25%; margin-top: -47%">
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">Benow Integration Y/N</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%; margin-left: 0%">
									<s:select id="cmbBenowPOSIntegrationYN"
										path="strBenowPOSIntegrationYN">
										<option value="N">No</option>
										<option value="Y">Yes</option>
									</s:select>
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">X-Email</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input class="large" colspan="3" type="text" id="txtXEmail"
										path="strXEmail" />
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">Super Merchant Code</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input class="large" colspan="3" type="text"
										id="txtSuperMerchantCode" path="strSuperMerchantCode" />


								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input type="button" colspan="3" id="txtSuperMerchantCode"
										path="strSuperMerchantCode" value="Authenticate"
										onclick="return btnFetchID_onclick();" />


								</div>
							</div>

							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">Merchant Code</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input class="large" colspan="3" type="text"
										id="txtMerchantCode" path="strMerchantCode" />
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">Authentication Key</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input class="large" colspan="3" type="text"
										id="txtAuthenticationKey" path="strAuthenticationKey" />
								</div>
							</div>
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">Salt</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input class="large" colspan="3" type="text" id="txtSalt"
										path="strSalt" />
								</div>
							</div>
						</div>

					</div> <!-- 	End of Benow Integration Setup tab --> <!-- 	Start of WERA Online Order Integration Setup tab -->

					<div id="tab18" class="tab_content">
						<br> <br>

						<div style="float: left; margin-left: 25%; margin-top: -47%">
							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">WERA Integration Y/N</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:select id="cmbWeraIntegrationYN"
										path="strWERAOnlineOrderIntegration">
										<option value="N">No</option>
										<option value="Y">Yes</option>
									</s:select>
								</div>
							</div>

							<div class="row"
								style="background-color: #fff; display: -webkit-box;">

								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">Authentication API Key</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input class="large" colspan="3" type="text"
										id="txtWERAAuthenticationAPIKey"
										path="strWERAAuthenticationAPIKey" />
								</div>
							</div>

							<div class="row"
								style="background-color: #fff; display: -webkit-box;">
								<div class="element-input col-lg-6" style="width: 60%;">
									<label class="title">Outlet Id/WERA Merchant</label>
								</div>
								<div class="element-input col-lg-6"
									style="margin-bottom: 10px; width: 60%;">
									<s:input class="large" colspan="3" type="text"
										id="txtWERAMerchantOutletId" path="strWERAMerchantOutletId" />
								</div>
							</div>


						</div>

					</div> <!-- 	End of WERA Online Order Integration Setup tab -->




					</div>
				</td>
			</tr>
		</table>
		<br />
		<br />
		<p align="center">
			<input id="submitBtn" type="submit" value="UPDATE"  />


		</p>
	</s:form>

</body>
</html>