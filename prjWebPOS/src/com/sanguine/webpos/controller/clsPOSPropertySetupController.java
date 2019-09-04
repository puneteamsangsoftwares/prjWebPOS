package com.sanguine.webpos.controller;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.lang.reflect.Array;
import java.net.HttpURLConnection;
import java.net.Socket;
import java.net.URL;
import java.sql.Blob;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import javax.persistence.Column;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.sanguine.base.service.intfBaseService;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.webpos.bean.clsPOSBillSeriesDtlBean;
import com.sanguine.webpos.bean.clsPOSCreditBillReceiptBean;
import com.sanguine.webpos.bean.clsPOSPropertySetupBean;
import com.sanguine.webpos.bean.clsPOSPrinterSetupBean;
import com.sanguine.webpos.bean.clsPOSSMSSetupBean;
import com.sanguine.webpos.bean.clsPOSSettlementDetailsBean;
import com.sanguine.webpos.model.clsAreaMasterModel;
import com.sanguine.webpos.model.clsBillSeriesHdModel;
import com.sanguine.webpos.model.clsBillSeriesModel_ID;
import com.sanguine.webpos.model.clsGroupMasterModel;
import com.sanguine.webpos.model.clsPOSSMSSetupModel;
import com.sanguine.webpos.model.clsPrinterSetupHdModel;
import com.sanguine.webpos.model.clsPrinterSetupModel_ID;
import com.sanguine.webpos.model.clsSettlementMasterModel;
import com.sanguine.webpos.model.clsSetupHdModel;
import com.sanguine.webpos.model.clsSetupModel_ID;
import com.sanguine.webpos.sevice.clsPOSMasterService;
import com.sanguine.webpos.util.clsPOSUtilityController;

@Controller
public class clsPOSPropertySetupController
{
	@Autowired
	private clsGlobalFunctions objGlobal;
	@Autowired
	private clsPOSGlobalFunctionsController objPOSGlobal;

	@Autowired
	clsPOSUtilityController obUtilityController;

	@Autowired
	private ServletContext servletContext;

	@Autowired
	private intfBaseService objBaseService;

	@Autowired
	clsPOSMasterService objMasterService;

	Date dte = new Date();
	int yy = dte.getYear() + 1900;
	int mm = dte.getMonth() + 1;
	int dd = dte.getDate();
	String dteEndDate = yy + "-" + mm + "-" + dd;
	boolean JioDeviceIDFound = false;
	String JioDeviceIDFromDB = "";
	

	@RequestMapping(value = "/frmPOSPropertySetup", method = RequestMethod.GET)
	public ModelAndView funOpenForm(@ModelAttribute("command") @Valid clsPOSPropertySetupBean objBean, BindingResult result, Map<String, Object> model, HttpServletRequest request) throws Exception
	{

		Map mapPOS = new HashMap();
		Map mapPOSForDayEnd = new HashMap();
		
		Map mapArea = new HashMap<>();
		Map mapTax = new HashMap<>();
		String clientCode = request.getSession().getAttribute("gClientCode").toString();
		String posCode = request.getSession().getAttribute("loginPOS").toString();

		List list = objMasterService.funFullPOSCombo(clientCode);
		mapPOS.put("All", "All");
		for (int cnt = 0; cnt < list.size(); cnt++)
		{
			Object obj = list.get(cnt);
			mapPOSForDayEnd.put(Array.get(obj, 0).toString(), Array.get(obj, 1).toString());
			mapPOS.put(Array.get(obj, 0).toString(), Array.get(obj, 1).toString());
		}
		Map<String, String> mapPosData = new TreeMap<String, String>(mapPOS);
		model.put("posList", mapPosData);
		model.put("posListForDayEnd", mapPOSForDayEnd);

		mapArea = funLoadAreaList(posCode);
		model.put("areaList", mapArea);

		mapTax = funLoadTaxList();
		model.put("taxList", mapTax);

		// Consolidate Printer
		Map mapOfPrinterList = new HashMap();
		List<String> printerList = new ArrayList<String>();
		mapOfPrinterList = obUtilityController.funGetPrinterList();
		printerList = (ArrayList) mapOfPrinterList.get("printerList");
		model.put("printerList", printerList);

		// UpTo Time To Punch Adv Order
		List listHH = new ArrayList();
		listHH.add("HH");
		for (int i = 1; i <= 12; i++)
		{
			listHH.add(i);
		}
		model.put("HH", listHH);

		List listMM = new ArrayList();
		listMM.add("MM");
		for (int i = 1; i <= 60; i++)
		{
			listMM.add(i);
		}
		model.put("MM", listMM);

		// UpTo Time To Punch Urgent Order

		List listToHH = new ArrayList();
		listToHH.add("HH");
		for (int i = 1; i <= 12; i++)
		{
			listToHH.add(i);
		}
		model.put("ToHH", listToHH);

		List listToMM = new ArrayList();
		listToMM.add("MM");
		for (int i = 1; i <= 60; i++)
		{
			listToMM.add(i);
		}
		model.put("ToMM", listToMM);

		// Load Moble for SMS

		return new ModelAndView("frmPOSPropertySetup");

	}
    
	//load the data when select the posname
	@RequestMapping(value = "/loadPOSWisePropertySetupData", method = RequestMethod.GET)
	public @ResponseBody clsPOSPropertySetupBean funSetPOSWiseData(@RequestParam("posCode") String posCode, HttpServletRequest request)
	{
		String clientCode = request.getSession().getAttribute("gClientCode").toString();
		clsPOSPropertySetupBean objBean = new clsPOSPropertySetupBean();

		FileOutputStream fileOuputStream = null;
		clsSetupModel_ID ob = new clsSetupModel_ID(clientCode, posCode);
		clsSetupHdModel objSetupHdModel = new clsSetupHdModel();
		try
		{
			List list = objBaseService.funLoadAllPOSWise(objSetupHdModel, clientCode, posCode);

			for (int cnt = 0; cnt < list.size(); cnt++)
			{
				objSetupHdModel = (clsSetupHdModel) list.get(cnt);
				if (objSetupHdModel.getStrPOSCode().equals(posCode))
				{

					if (objSetupHdModel.getBlobReportImage() != null)
					{
						Blob blob = objSetupHdModel.getBlobReportImage();
						byte[] byteContent = blob.toString().getBytes();
						String imagePath = servletContext.getRealPath("/resources/images");
						int blobLength = (int) blob.length();
						fileOuputStream = new FileOutputStream(imagePath + "/imgClientImage.jpg");
						fileOuputStream.write(byteContent);
						fileOuputStream.close();
					}

					objBean.setStrPosCode(objSetupHdModel.getStrPOSCode());
					objBean.setStrPrintingType(objSetupHdModel.getStrPrintType());
					objBean.setIntColumnSize(objSetupHdModel.getIntColumnSize());
					objBean.setDblMaxDiscount(objSetupHdModel.getDblMaxDiscount());

					objBean.setChkAreaWisePricing(objSetupHdModel.getStrAreaWisePricing());
					objBean.setStrChangeTheme(objSetupHdModel.getStrChangeTheme());
					objBean.setStrClientCode(objSetupHdModel.getStrClientCode());
					objBean.setStrClientName(objSetupHdModel.getStrClientName());
					objBean.setStrAddrLine1(objSetupHdModel.getStrAddressLine1());
					objBean.setStrAddrLine2(objSetupHdModel.getStrAddressLine2());
					objBean.setStrAddrLine3(objSetupHdModel.getStrAddressLine3());
					objBean.setStrEmail(objSetupHdModel.getStrEmail());
					objBean.setStrBillFooter(objSetupHdModel.getStrBillFooter());
					objBean.setIntBiilPaperSize((long) objSetupHdModel.getIntBillPaperSize());
					objBean.setChkNegBilling(objSetupHdModel.getStrNegativeBilling());
					objBean.setChkDayEnd(objSetupHdModel.getStrDayEnd());
					
					objBean.setStrSkipWaiterAndPax(objSetupHdModel.getStrSkipWaiterAndPax());
					
					objBean.setStrBillPrintMode(objSetupHdModel.getStrPrintMode());
					objBean.setStrCity(objSetupHdModel.getStrCityName());
					objBean.setStrState(objSetupHdModel.getStrState());
					objBean.setStrCountry(objSetupHdModel.getStrCountry());
					objBean.setStrTelephone((long) objSetupHdModel.getIntTelephoneNo());
					objBean.setStrNatureOfBussness(objSetupHdModel.getStrNatureOfBusinnes());
					objBean.setChkMultiBillPrint(objSetupHdModel.getStrMultipleBillPrinting());
					objBean.setChkEnableKOT(objSetupHdModel.getStrEnableKOT());
					objBean.setChkEffectOnPSP(objSetupHdModel.getStrEffectOnPSP());
					objBean.setChkPrintVatNo(objSetupHdModel.getStrPrintVatNo());
					objBean.setStrVatNo(objSetupHdModel.getStrVatNo());
					objBean.setChkShowBills(objSetupHdModel.getStrShowBill());
					objBean.setChkServiceTaxNo(objSetupHdModel.getStrPrintServiceTaxNo());
					objBean.setStrServiceTaxNo(objSetupHdModel.getStrServiceTaxNo());
					objBean.setChkManualBillNo(objSetupHdModel.getStrManualBillNo());
					objBean.setStrMenuItemDisSeq(objSetupHdModel.getStrMenuItemDispSeq());
					objBean.setStrSenderEmailId(objSetupHdModel.getStrSenderEmailId());
					objBean.setStrEmailPassword(objSetupHdModel.getStrEmailPassword());
					objBean.setStrBodyPart(objSetupHdModel.getStrBody());
					objBean.setStrEmailServerName(objSetupHdModel.getStrEmailServerName());
					objBean.setStrAreaSMSApi(objSetupHdModel.getStrSMSApi());
					objBean.setStrDirectArea(objSetupHdModel.getStrDirectAreaCode());

					objBean.setStrPOSType(objSetupHdModel.getStrPOSType());
					objBean.setStrWebServiceLink(objSetupHdModel.getStrWebServiceLink());
					objBean.setStrDataSendFrequency(objSetupHdModel.getStrDataSendFrequency());
					objBean.setStrRFIDSetup(objSetupHdModel.getStrRFID());
					objBean.setStrRFIDServerName(objSetupHdModel.getStrServerName());
					objBean.setStrRFIDUserName(objSetupHdModel.getStrDBUserName());
					objBean.setStrRFIDPassword(objSetupHdModel.getStrDBPassword());
					objBean.setStrRFIDDatabaseName(objSetupHdModel.getStrDatabaseName());
					objBean.setChkPrintKotForDirectBiller(objSetupHdModel.getStrEnableKOTForDirectBiller());
					objBean.setStrPinCode((long) objSetupHdModel.getIntPinCode());
					objBean.setStrMenuItemSortingOn(objSetupHdModel.getStrMenuItemSortingOn());
					objBean.setChkEditHomeDelivery(objSetupHdModel.getStrEditHomeDelivery());
					objBean.setChkSlabBasedHomeDelCharges(objSetupHdModel.getStrSlabBasedHDCharges());
					objBean.setChkSkipWaiterSelection(objSetupHdModel.getStrSkipWaiter());
					objBean.setChkDirectKOTPrintMakeKOT(objSetupHdModel.getStrDirectKOTPrintMakeKOT());
					objBean.setChkSkipPaxSelection(objSetupHdModel.getStrSkipPax());
					objBean.setStrCRM(objSetupHdModel.getStrCRMInterface());
					objBean.setStrGetWebservice(objSetupHdModel.getStrGetWebserviceURL());
					objBean.setStrPostWebservice(objSetupHdModel.getStrPostWebserviceURL());
					objBean.setStrOutletUID(objSetupHdModel.getStrOutletUID());
					objBean.setStrPOSID(objSetupHdModel.getStrPOSID());
					objBean.setStrStockInOption(objSetupHdModel.getStrStockInOption());
					objBean.setLongCustSeries(objSetupHdModel.getLongCustSeries());

					objBean.setStrAdvRecPrintCount((long) objSetupHdModel.getIntAdvReceiptPrintCount());
					objBean.setStrAreaSendHomeDeliverySMS(objSetupHdModel.getStrHomeDeliverySMS());
					objBean.setStrAreaBillSettlementSMS(objSetupHdModel.getStrBillStettlementSMS());
					objBean.setChkActivePromotions(objSetupHdModel.getStrActivePromotions());
					objBean.setChkHomeDelSMS(objSetupHdModel.getStrSendHomeDelSMS());
					objBean.setChkBillSettlementSMS(objSetupHdModel.getStrSendBillSettlementSMS());
					objBean.setStrSMSType(objSetupHdModel.getStrSMSType());
					objBean.setChkPrintShortNameOnKOT(objSetupHdModel.getStrPrintShortNameOnKOT());
					objBean.setChkPrintForVoidBill(objSetupHdModel.getStrPrintOnVoidBill());
					objBean.setChkPostSalesDataToMMS(objSetupHdModel.getStrPostSalesDataToMMS());
					objBean.setChkAreaMasterCompulsory(objSetupHdModel.getStrCustAreaMasterCompulsory());
					objBean.setStrPriceFrom(objSetupHdModel.getStrPriceFrom());
					objBean.setChkPrinterErrorMessage(objSetupHdModel.getStrShowPrinterErrorMessage());
					objBean.setChkChangeQtyForExternalCode(objSetupHdModel.getStrChangeQtyForExternalCode());
					objBean.setChkPointsOnBillPrint(objSetupHdModel.getStrPointsOnBillPrint());
					objBean.setStrCardIntfType(objSetupHdModel.getStrCardInterfaceType());
					objBean.setStrCMSIntegrationYN(objSetupHdModel.getStrCMSIntegrationYN());
					objBean.setStrCMSWesServiceURL(objSetupHdModel.getStrCMSWebServiceURL());
					objBean.setChkManualAdvOrderCompulsory(objSetupHdModel.getStrPrintManualAdvOrderNoOnBill());
					objBean.setChkPrintManualAdvOrderOnBill(objSetupHdModel.getStrManualAdvOrderNoCompulsory());
					objBean.setChkPrintModifierQtyOnKOT(objSetupHdModel.getStrPrintModifierQtyOnKOT());
					objBean.setIntNoOfLinesInKOTPrint((long) objSetupHdModel.getStrNoOfLinesInKOTPrint());
					objBean.setChkMultiKOTPrint(objSetupHdModel.getStrMultipleKOTPrintYN());
					objBean.setChkItemQtyNumpad(objSetupHdModel.getStrItemQtyNumpad());
					objBean.setChkMemberAsTable(objSetupHdModel.getStrTreatMemberAsTable());
					objBean.setChkPrintKOTToLocalPrinter(objSetupHdModel.getStrKOTToLocalPrinter());
					objBean.setChkEnableSettleBtnForDirectBillerBill(objSetupHdModel.getStrSettleBtnForDirectBillerBill());
					objBean.setChkDelBoyCompulsoryOnDirectBiller(objSetupHdModel.getStrDelBoySelCompulsoryOnDirectBiller());
					objBean.setChkMemberCodeForKOTJPOS(objSetupHdModel.getStrCMSMemberForKOTJPOS());
					objBean.setChkMemberCodeForKOTMPOS(objSetupHdModel.getStrCMSMemberForKOTMPOS());
					objBean.setChkDontShowAdvOrderInOtherPOS(objSetupHdModel.getStrDontShowAdvOrderInOtherPOS());
					objBean.setChkPrintZeroAmtModifierInBill(objSetupHdModel.getStrPrintZeroAmtModifierInBill());
					objBean.setChkPrintKOTYN(objSetupHdModel.getStrPrintKOTYN());
					objBean.setChkSlipNoForCreditCardBillYN(objSetupHdModel.getStrCreditCardSlipNoCompulsoryYN());
					objBean.setChkExpDateForCreditCardBillYN(objSetupHdModel.getStrCreditCardExpiryDateCompulsoryYN());
					objBean.setChkSelectWaiterFromCardSwipe(objSetupHdModel.getStrSelectWaiterFromCardSwipe());
					objBean.setChkMultipleWaiterSelectionOnMakeKOT(objSetupHdModel.getStrMultiWaiterSelectionOnMakeKOT());
					objBean.setChkMoveTableToOtherPOS(objSetupHdModel.getStrMoveTableToOtherPOS());
					objBean.setChkMoveKOTToOtherPOS(objSetupHdModel.getStrMoveKOTToOtherPOS());
					objBean.setChkCalculateTaxOnMakeKOT(objSetupHdModel.getStrCalculateTaxOnMakeKOT());
					objBean.setStrReceiverEmailId(objSetupHdModel.getStrReceiverEmailId());
					objBean.setChkCalculateDiscItemWise(objSetupHdModel.getStrCalculateDiscItemWise());
					objBean.setChkTakewayCustomerSelection(objSetupHdModel.getStrTakewayCustomerSelection());
					objBean.setChkShowItemStkColumnInDB(objSetupHdModel.getStrShowItemStkColumnInDB());
					objBean.setStrItemType(objSetupHdModel.getStrItemType());
					objBean.setChkBoxAllowNewAreaMasterFromCustMaster(objSetupHdModel.getStrAllowNewAreaMasterFromCustMaster());
					objBean.setChkSelectCustAddressForBill(objSetupHdModel.getStrCustAddressSelectionForBill());
					objBean.setChkGenrateMI(objSetupHdModel.getStrGenrateMI());
					objBean.setStrFTPAddress(objSetupHdModel.getStrFTPAddress());
					objBean.setStrFTPServerUserName(objSetupHdModel.getStrFTPServerUserName());
					objBean.setStrFTPServerPass(objSetupHdModel.getStrFTPServerPass());
					objBean.setChkAllowToCalculateItemWeight(objSetupHdModel.getStrAllowToCalculateItemWeight());
					objBean.setStrShowBillsDtlType(objSetupHdModel.getStrShowBillsDtlType());
					objBean.setChkPrintInvoiceOnBill(objSetupHdModel.getStrPrintTaxInvoiceOnBill());
					objBean.setChkPrintInclusiveOfAllTaxesOnBill(objSetupHdModel.getStrPrintInclusiveOfAllTaxesOnBill());
					objBean.setStrApplyDiscountOn(objSetupHdModel.getStrApplyDiscountOn());
					objBean.setChkMemberCodeForKotInMposByCardSwipe(objSetupHdModel.getStrMemberCodeForKotInMposByCardSwipe());
					objBean.setChkPrintBill(objSetupHdModel.getStrPrintBillYN());
					objBean.setChkUseVatAndServiceNoFromPos(objSetupHdModel.getStrVatAndServiceTaxFromPos());
					objBean.setChkMemberCodeForMakeBillInMPOS(objSetupHdModel.getStrMemberCodeForMakeBillInMPOS());
					objBean.setChkItemWiseKOTPrintYN(objSetupHdModel.getStrItemWiseKOTYN());
					objBean.setStrPOSForDayEnd(objSetupHdModel.getStrLastPOSForDayEnd());
					objBean.setStrCMSPostingType(objSetupHdModel.getStrCMSPostingType());
					objBean.setChkPopUpToApplyPromotionsOnBill(objSetupHdModel.getStrPopUpToApplyPromotionsOnBill());
					objBean.setChkSelectCustomerCodeFromCardSwipe(objSetupHdModel.getStrSelectCustomerCodeFromCardSwipe());
					objBean.setChkCheckDebitCardBalOnTrans(objSetupHdModel.getStrCheckDebitCardBalOnTransactions());
					objBean.setChkSettlementsFromPOSMaster(objSetupHdModel.getStrSettlementsFromPOSMaster());
					objBean.setChkShiftWiseDayEnd(objSetupHdModel.getStrShiftWiseDayEndYN());
					objBean.setChkProductionLinkup(objSetupHdModel.getStrProductionLinkup());
					objBean.setChkLockDataOnShift(objSetupHdModel.getStrLockDataOnShift());
					objBean.setStrWSClientCode(objSetupHdModel.getStrWSClientCode());
					objBean.setChkEnableBillSeries(objSetupHdModel.getStrEnableBillSeries());
					objBean.setChkEnablePMSIntegration(objSetupHdModel.getStrEnablePMSIntegrationYN());
					objBean.setChkPrintTimeOnBill(objSetupHdModel.getStrPrintTimeOnBill());
					objBean.setChkPrintTDHItemsInBill(objSetupHdModel.getStrPrintTDHItemsInBill());
					objBean.setChkPrintRemarkAndReasonForReprint(objSetupHdModel.getStrPrintRemarkAndReasonForReprint());
					objBean.setIntDaysBeforeOrderToCancel((long) objSetupHdModel.getIntDaysBeforeOrderToCancel());
					objBean.setIntNoOfDelDaysForAdvOrder((long) objSetupHdModel.getIntNoOfDelDaysForAdvOrder());
					objBean.setIntNoOfDelDaysForUrgentOrder((long) objSetupHdModel.getIntNoOfDelDaysForUrgentOrder());
					objBean.setChkSetUpToTimeForAdvOrder(objSetupHdModel.getStrSetUpToTimeForAdvOrder());
					objBean.setChkSetUpToTimeForUrgentOrder(objSetupHdModel.getStrSetUpToTimeForUrgentOrder());
					
					String upToTimeForAdvOrder = (objSetupHdModel.getStrUpToTimeForAdvOrder()).split(" ")[0];
					objBean.setStrHours(upToTimeForAdvOrder.split(":")[0].trim());
					objBean.setStrMinutes(upToTimeForAdvOrder.split(":")[1].trim());
					objBean.setStrAMPM((objSetupHdModel.getStrUpToTimeForAdvOrder()).split(" ")[1]);
					
					String upToTimeForUrgentOrder = (objSetupHdModel.getStrUpToTimeForUrgentOrder()).split(" ")[0];
					objBean.setStrHoursUrgentOrder(upToTimeForUrgentOrder.split(":")[0].trim());
					objBean.setStrMinutesUrgentOrder(upToTimeForUrgentOrder.split(":")[1].trim());
					objBean.setStrAMPMUrgent((objSetupHdModel.getStrUpToTimeForUrgentOrder()).split(" ")[1]);
					
					objBean.setChkEnableBothPrintAndSettleBtnForDB(objSetupHdModel.getStrEnableBothPrintAndSettleBtnForDB());
					objBean.setStrInrestoPOSIntegrationYN(objSetupHdModel.getStrInrestoPOSIntegrationYN());
					objBean.setStrInrestoPOSWesServiceURL(objSetupHdModel.getStrInrestoPOSWebServiceURL());
					objBean.setStrInrestoPOSId(objSetupHdModel.getStrInrestoPOSId());
					objBean.setStrInrestoPOSKey(objSetupHdModel.getStrInrestoPOSKey());
					objBean.setChkCarryForwardFloatAmtToNextDay(objSetupHdModel.getStrCarryForwardFloatAmtToNextDay());
					objBean.setChkOpenCashDrawerAfterBillPrint(objSetupHdModel.getStrOpenCashDrawerAfterBillPrintYN());
					objBean.setChkPropertyWiseSalesOrder(objSetupHdModel.getStrPropertyWiseSalesOrderYN());
					objBean.setChkShowItemDtlsForChangeCustomerOnBill(objSetupHdModel.getStrShowItemDetailsGrid());
					objBean.setChkShowPopUpForNextItemQuantity(objSetupHdModel.getStrShowPopUpForNextItemQuantity());
					objBean.setStrJioPOSIntegrationYN(objSetupHdModel.getStrJioMoneyIntegration());
					objBean.setStrJioPOSWesServiceURL(objSetupHdModel.getStrJioWebServiceUrl());
					objBean.setStrJioMID(objSetupHdModel.getStrJioMID());
					objBean.setStrJioTID(objSetupHdModel.getStrJioTID());
					objBean.setStrJioActivationCode(objSetupHdModel.getStrJioActivationCode());
					objBean.setStrJioDeviceID(objSetupHdModel.getStrJioDeviceID());
					if (!objSetupHdModel.getStrJioDeviceID().toString().isEmpty())
					{
						JioDeviceIDFound = true;
						JioDeviceIDFromDB = objSetupHdModel.getStrJioDeviceID().toString();
					}
					objBean.setChkNewBillSeriesForNewDay(objSetupHdModel.getStrNewBillSeriesForNewDay());
					objBean.setChkShowReportsPOSWise(objSetupHdModel.getStrShowReportsPOSWise());
					objBean.setChkEnableDineIn(objSetupHdModel.getStrEnableDineIn());
					objBean.setChkAutoAreaSelectionInMakeKOT(objSetupHdModel.getStrAutoAreaSelectionInMakeKOT());
					objBean.setStrAreaWiseCostCenterKOTPrintingYN(objSetupHdModel.getStrAreaWiseCostCenterKOTPrintingYN());
					objBean.setStrHomeDeliAreaForDirectBiller(objSetupHdModel.getStrHomeDeliveryAreaForDirectBiller());
					objBean.setStrTakeAwayAreaForDirectBiller(objSetupHdModel.getStrTakeAwayAreaForDirectBiller());
					objBean.setChkRoundOffBillAmount(objSetupHdModel.getStrRoundOffBillFinalAmt());
					objBean.setChkPrintItemsOnMoveKOTMoveTable(objSetupHdModel.getStrPrintItemsOnMoveKOTMoveTable());
					objBean.setIntNoOfDecimalPlaces(objSetupHdModel.getDblNoOfDecimalPlace());
					objBean.setChkPrintMoveTableMoveKOT(objSetupHdModel.getStrPrintMoveTableMoveKOTYN());
					objBean.setChkSendDBBackupOnMail(objSetupHdModel.getStrSendDBBackupOnClientMail());
					objBean.setChkPrintQtyTotal(objSetupHdModel.getStrPrintQtyTotal());
					objBean.setChkPrintOrderNoOnBill(objSetupHdModel.getStrPrintOrderNoOnBillYN());
					objBean.setChkAutoAddKOTToBill(objSetupHdModel.getStrAutoAddKOTToBill());
					objBean.setChkPrintDeviceUserDtlOnKOT(objSetupHdModel.getStrPrintDeviceAndUserDtlOnKOTYN());
					objBean.setChkFireCommunication(objSetupHdModel.getStrFireCommunication());
					
					objBean.setStrRemoveServiceChargeTaxCode(objSetupHdModel.getStrRemoveSCTaxCode());
					objBean.setChkLockTableForWaiter(objSetupHdModel.getStrLockTableForWaiter());
					
					objBean.setDblUSDCrrencyConverionRate(objSetupHdModel.getDblUSDConverionRate());
					objBean.setStrShowReportsInCurrency(objSetupHdModel.getStrShowReportsInCurrency());
					objBean.setStrPOSToMMSPostingCurrency(objSetupHdModel.getStrPOSToMMSPostingCurrency());
					objBean.setStrPOSToWebBooksPostingCurrency(objSetupHdModel.getStrPOSToWebBooksPostingCurrency());
					objBean.setStrBenowPOSIntegrationYN(objSetupHdModel.getStrBenowIntegrationYN());
					objBean.setStrEmail(objSetupHdModel.getStrXEmail());
					objBean.setStrMerchantCode(objSetupHdModel.getStrMerchantCode());
					objBean.setStrAuthenticationKey(objSetupHdModel.getStrAuthenticationKey());
					objBean.setStrSalt(objSetupHdModel.getStrSalt());
					objBean.setStrWERAOnlineOrderIntegration(objSetupHdModel.getStrWERAOnlineOrderIntegration());
					objBean.setStrWERAMerchantOutletId(objSetupHdModel.getStrWERAMerchantOutletId());
					objBean.setStrWERAAuthenticationAPIKey(objSetupHdModel.getStrWERAAuthenticationAPIKey());
					objBean.setStrPostMMSSalesEffectCostOrLoc(objSetupHdModel.getStrPostSalesCostOrLoc());
					objBean.setChkEnableNFCInterface(objSetupHdModel.getStrEnableNFCInterface());
					objBean.setStrPrintOpenItemsOnBill(objSetupHdModel.getStrPrintOpenItemsOnBill());

					objBean.setStrShowUnSettlementForm(objSetupHdModel.getStrShowUnSettlementForm());

					objBean.setDblRoundOff(objSetupHdModel.getDblRoundOff());
					
				    objBean.setIntShowPopItemsOfDays(Integer.parseInt(String.valueOf(objSetupHdModel.getIntShowPopItemsOfDays())));

					objBean.setStrScanQRYN(objSetupHdModel.getStrScanQRYN());

					objBean.setStrAreaWisePromotions(objSetupHdModel.getStrAreaWisePromotions());

					objBean.setStrPrintHomeDeliveryYN(objSetupHdModel.getStrPrintHomeDeliveryYN());

					objBean.setStrShowPurRateInDirectBiller(objSetupHdModel.getStrShowPurRateInDirectBiller());

					objBean.setStrEffectOfSales(objSetupHdModel.getStrEffectOfSales());

					objBean.setStrEnableTableReservationForCustomer(objSetupHdModel.getStrEnableTableReservationForCustomer());

					objBean.setStrAutoShowPopItems(objSetupHdModel.getStrAutoShowPopItems());

					objBean.setStrEnableBillSeries(objSetupHdModel.getStrEnableBillSeries());

					objBean.setStrEnableLockTable(objSetupHdModel.getStrEnableLockTable());

					objBean.setStrReprintOnSettleBill(objSetupHdModel.getStrReprintOnSettleBill());

					objBean.setStrPOSWiseItemToMMSProductLinkUpYN(objSetupHdModel.getStrPOSWiseItemToMMSProductLinkUpYN());

					objBean.setStrEnableMasterDiscount(objSetupHdModel.getStrEnableMasterDiscount());

					objBean.setStrTableReservationSMS(objSetupHdModel.getStrTableReservationSMS());

					objBean.setStrSendTableReservationSMS(objSetupHdModel.getStrSendTableReservationSMS());
					objBean.setStrCheckDebitCardBalOnTransactions(objSetupHdModel.getStrCheckDebitCardBalOnTransactions());
					objBean.setStrPrintOriginalOnBill(objSetupHdModel.getStrPrintOriginalOnBill());
					objBean.setStrUserWiseShowBill(objSetupHdModel.getStrUserWiseShowBill());
					objBean.setStrPropertyWiseSalesOrderYN(objSetupHdModel.getStrPropertyWiseSalesOrderYN());
					
					//changes mahesh 21/06/2019
					objBean.setStrDineInAreaForDirectBiller(objSetupHdModel.getStrDirectAreaCode());
					objBean.setStrHomeDeliveryAreaForDirectBiller(objSetupHdModel.getStrHomeDeliveryAreaForDirectBiller());
					objBean.setStrTakeAwayAreaForDirectBiller(objSetupHdModel.getStrTakeAwayAreaForDirectBiller());

				
					dteEndDate = objSetupHdModel.getDteEndDate();
				}

			}

		}
		catch (Exception e)
		{

		}

		return objBean;
	}

	@RequestMapping(value = "/funGetPos", method = RequestMethod.GET)
	public @ResponseBody String funGetPos(@RequestParam("posCode") String posCode, HttpServletRequest request)
	{
		String count = "0";
		try
		{
			String sqlBillSeries = "select count(*) from tblsetup where strPOSCode='" + posCode + "' ";
			List list = objBaseService.funGetList(new StringBuilder(sqlBillSeries), "sql");
			if (list.size() > 0)
			{
				count = list.get(0).toString();
			}

		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return count;
	}

	// Loading the data when we open the form
	@RequestMapping(value = "/loadPOSPropertySetupData", method = RequestMethod.GET)
	public @ResponseBody clsPOSPropertySetupBean funSetSearchFields(HttpServletRequest request)
	{
		String clientCode = request.getSession().getAttribute("gClientCode").toString();
		String posCode = request.getSession().getAttribute("loginPOS").toString();

		clsPOSPropertySetupBean objBean = new clsPOSPropertySetupBean();
		FileOutputStream fileOuputStream = null;
		clsSetupModel_ID ob = new clsSetupModel_ID(clientCode, posCode);
		clsSetupHdModel objSetupHdModel = new clsSetupHdModel();

		try
		{
			List list = objBaseService.funLoadAll(objSetupHdModel, clientCode);

			for (int cnt = 0; cnt < list.size(); cnt++)
			{
				objSetupHdModel = (clsSetupHdModel) list.get(cnt);
				if (objSetupHdModel.getStrPOSCode().equals(posCode))
				{
					if (objSetupHdModel.getBlobReportImage() != null)
					{
						Blob blob = objSetupHdModel.getBlobReportImage();
						byte[] byteContent = blob.toString().getBytes();
						String imagePath = servletContext.getRealPath("/resources/images");
						int blobLength = (int) blob.length();

						fileOuputStream = new FileOutputStream(imagePath + "/imgClientImage.jpg");
						fileOuputStream.write(byteContent);
						fileOuputStream.close();
					}
				}
			}
			objBean.setStrPosCode(objSetupHdModel.getStrPOSCode());
			objBean.setStrPrintingType(objSetupHdModel.getStrPrintType());
			objBean.setIntColumnSize(objSetupHdModel.getIntColumnSize());
			objBean.setDblMaxDiscount(objSetupHdModel.getDblMaxDiscount());
			objBean.setChkAreaWisePricing(objSetupHdModel.getStrAreaWisePricing());
			objBean.setStrChangeTheme(objSetupHdModel.getStrChangeTheme());
			objBean.setStrClientCode(objSetupHdModel.getStrClientCode());
			objBean.setStrClientName(objSetupHdModel.getStrClientName());
			objBean.setStrAddrLine1(objSetupHdModel.getStrAddressLine1());
			objBean.setStrAddrLine2(objSetupHdModel.getStrAddressLine2());
			objBean.setStrAddrLine3(objSetupHdModel.getStrAddressLine3());
			objBean.setStrEmail(objSetupHdModel.getStrEmail());
			objBean.setStrBillFooter(objSetupHdModel.getStrBillFooter());
			objBean.setIntBiilPaperSize((long) objSetupHdModel.getIntBillPaperSize());
			objBean.setChkNegBilling(objSetupHdModel.getStrNegativeBilling());
			objBean.setChkDayEnd(objSetupHdModel.getStrDayEnd());
			objBean.setStrBillPrintMode(objSetupHdModel.getStrPrintMode());
			objBean.setStrCity(objSetupHdModel.getStrCityName());
			objBean.setStrState(objSetupHdModel.getStrState());
			objBean.setStrCountry(objSetupHdModel.getStrCountry());
			objBean.setStrTelephone((long) objSetupHdModel.getIntTelephoneNo());
			objBean.setStrNatureOfBussness(objSetupHdModel.getStrNatureOfBusinnes());
			objBean.setChkMultiBillPrint(objSetupHdModel.getStrMultipleBillPrinting());
			objBean.setChkEnableKOT(objSetupHdModel.getStrEnableKOT());
			objBean.setChkEffectOnPSP(objSetupHdModel.getStrEffectOnPSP());
			objBean.setChkPrintVatNo(objSetupHdModel.getStrPrintVatNo());
			objBean.setStrVatNo(objSetupHdModel.getStrVatNo());
			objBean.setChkShowBills(objSetupHdModel.getStrShowBill());
			objBean.setChkServiceTaxNo(objSetupHdModel.getStrPrintServiceTaxNo());
			objBean.setStrServiceTaxNo(objSetupHdModel.getStrServiceTaxNo());
			objBean.setChkManualBillNo(objSetupHdModel.getStrManualBillNo());
			objBean.setStrMenuItemDisSeq(objSetupHdModel.getStrMenuItemDispSeq());
			objBean.setStrSenderEmailId(objSetupHdModel.getStrSenderEmailId());
			objBean.setStrEmailPassword(objSetupHdModel.getStrEmailPassword());
			objBean.setStrBodyPart(objSetupHdModel.getStrBody());
			objBean.setStrSkipWaiterAndPax(objSetupHdModel.getStrSkipWaiterAndPax());
			
			objBean.setStrEmailServerName(objSetupHdModel.getStrEmailServerName());
			objBean.setStrAreaSMSApi(objSetupHdModel.getStrSMSApi());
			objBean.setDteHOServerDate(objSetupHdModel.getDteHOServerDate());
			objBean.setStrDirectArea(objSetupHdModel.getStrDirectAreaCode());
			objBean.setStrPOSType(objSetupHdModel.getStrPOSType());
			objBean.setStrWebServiceLink(objSetupHdModel.getStrWebServiceLink());
			objBean.setStrDataSendFrequency(objSetupHdModel.getStrDataSendFrequency());
			objBean.setStrRFIDSetup(objSetupHdModel.getStrRFID());
			objBean.setStrRFIDServerName(objSetupHdModel.getStrServerName());
			objBean.setStrRFIDUserName(objSetupHdModel.getStrDBUserName());
			objBean.setStrRFIDPassword(objSetupHdModel.getStrDBPassword());
			objBean.setStrRFIDDatabaseName(objSetupHdModel.getStrDatabaseName());
			objBean.setChkPrintKotForDirectBiller(objSetupHdModel.getStrEnableKOTForDirectBiller());
			objBean.setStrPinCode((long) objSetupHdModel.getIntPinCode());
			objBean.setStrMenuItemSortingOn(objSetupHdModel.getStrMenuItemSortingOn());
			objBean.setChkEditHomeDelivery(objSetupHdModel.getStrEditHomeDelivery());
			objBean.setChkSlabBasedHomeDelCharges(objSetupHdModel.getStrSlabBasedHDCharges());
			objBean.setChkSkipWaiterSelection(objSetupHdModel.getStrSkipWaiter());
			objBean.setChkDirectKOTPrintMakeKOT(objSetupHdModel.getStrDirectKOTPrintMakeKOT());
			objBean.setChkSkipPaxSelection(objSetupHdModel.getStrSkipPax());
			objBean.setStrCRM(objSetupHdModel.getStrCRMInterface());
			objBean.setStrGetWebservice(objSetupHdModel.getStrGetWebserviceURL());
			objBean.setStrPostWebservice(objSetupHdModel.getStrPostWebserviceURL());
			objBean.setStrOutletUID(objSetupHdModel.getStrOutletUID());
			objBean.setStrPOSID(objSetupHdModel.getStrPOSID());
			objBean.setStrStockInOption(objSetupHdModel.getStrStockInOption());
			objBean.setLongCustSeries(objSetupHdModel.getLongCustSeries());
			objBean.setStrAdvRecPrintCount((long) objSetupHdModel.getIntAdvReceiptPrintCount());
			objBean.setStrAreaSendHomeDeliverySMS(objSetupHdModel.getStrHomeDeliverySMS());
			objBean.setStrAreaBillSettlementSMS(objSetupHdModel.getStrBillStettlementSMS());
			objBean.setChkActivePromotions(objSetupHdModel.getStrActivePromotions());
			objBean.setChkHomeDelSMS(objSetupHdModel.getStrSendHomeDelSMS());
			objBean.setChkBillSettlementSMS(objSetupHdModel.getStrSendBillSettlementSMS());
			objBean.setStrSMSType(objSetupHdModel.getStrSMSType());
			objBean.setChkPrintShortNameOnKOT(objSetupHdModel.getStrPrintShortNameOnKOT());
			objBean.setChkPrintForVoidBill(objSetupHdModel.getStrPrintOnVoidBill());
			objBean.setChkPostSalesDataToMMS(objSetupHdModel.getStrPostSalesDataToMMS());
			objBean.setChkAreaMasterCompulsory(objSetupHdModel.getStrCustAreaMasterCompulsory());
			objBean.setStrPriceFrom(objSetupHdModel.getStrPriceFrom());
			objBean.setChkPrinterErrorMessage(objSetupHdModel.getStrShowPrinterErrorMessage());
			objBean.setChkChangeQtyForExternalCode(objSetupHdModel.getStrChangeQtyForExternalCode());
			objBean.setChkPointsOnBillPrint(objSetupHdModel.getStrPointsOnBillPrint());
			objBean.setStrCardIntfType(objSetupHdModel.getStrCardInterfaceType());
			objBean.setStrCMSIntegrationYN(objSetupHdModel.getStrCMSIntegrationYN());
			objBean.setStrCMSWesServiceURL(objSetupHdModel.getStrCMSWebServiceURL());
			objBean.setChkManualAdvOrderCompulsory(objSetupHdModel.getStrPrintManualAdvOrderNoOnBill());
			objBean.setChkPrintManualAdvOrderOnBill(objSetupHdModel.getStrManualAdvOrderNoCompulsory());
			objBean.setChkPrintModifierQtyOnKOT(objSetupHdModel.getStrPrintModifierQtyOnKOT());
			objBean.setIntNoOfLinesInKOTPrint((long) objSetupHdModel.getStrNoOfLinesInKOTPrint());
			objBean.setChkMultiKOTPrint(objSetupHdModel.getStrMultipleKOTPrintYN());
			objBean.setChkItemQtyNumpad(objSetupHdModel.getStrItemQtyNumpad());
			objBean.setChkMemberAsTable(objSetupHdModel.getStrTreatMemberAsTable());
			objBean.setChkPrintKOTToLocalPrinter(objSetupHdModel.getStrKOTToLocalPrinter());
			objBean.setChkEnableSettleBtnForDirectBillerBill(objSetupHdModel.getStrSettleBtnForDirectBillerBill());
			objBean.setChkDelBoyCompulsoryOnDirectBiller(objSetupHdModel.getStrDelBoySelCompulsoryOnDirectBiller());
			objBean.setChkMemberCodeForKOTJPOS(objSetupHdModel.getStrCMSMemberForKOTJPOS());
			objBean.setChkMemberCodeForKOTMPOS(objSetupHdModel.getStrCMSMemberForKOTMPOS());
			objBean.setChkDontShowAdvOrderInOtherPOS(objSetupHdModel.getStrDontShowAdvOrderInOtherPOS());
			objBean.setChkPrintZeroAmtModifierInBill(objSetupHdModel.getStrPrintZeroAmtModifierInBill());
			objBean.setChkPrintKOTYN(objSetupHdModel.getStrPrintKOTYN());
			objBean.setChkSlipNoForCreditCardBillYN(objSetupHdModel.getStrCreditCardSlipNoCompulsoryYN());
			objBean.setChkExpDateForCreditCardBillYN(objSetupHdModel.getStrCreditCardExpiryDateCompulsoryYN());
			objBean.setChkSelectWaiterFromCardSwipe(objSetupHdModel.getStrSelectWaiterFromCardSwipe());
			objBean.setChkMultipleWaiterSelectionOnMakeKOT(objSetupHdModel.getStrMultiWaiterSelectionOnMakeKOT());
			objBean.setChkMoveTableToOtherPOS(objSetupHdModel.getStrMoveTableToOtherPOS());
			objBean.setChkMoveKOTToOtherPOS(objSetupHdModel.getStrMoveKOTToOtherPOS());
			objBean.setChkCalculateTaxOnMakeKOT(objSetupHdModel.getStrCalculateTaxOnMakeKOT());
			objBean.setStrReceiverEmailId(objSetupHdModel.getStrReceiverEmailId());
			objBean.setChkCalculateDiscItemWise(objSetupHdModel.getStrCalculateDiscItemWise());
			objBean.setChkTakewayCustomerSelection(objSetupHdModel.getStrTakewayCustomerSelection());
			objBean.setChkShowItemStkColumnInDB(objSetupHdModel.getStrShowItemStkColumnInDB());
			objBean.setStrItemType(objSetupHdModel.getStrItemType());
			objBean.setChkBoxAllowNewAreaMasterFromCustMaster(objSetupHdModel.getStrAllowNewAreaMasterFromCustMaster());
			objBean.setChkSelectCustAddressForBill(objSetupHdModel.getStrCustAddressSelectionForBill());
			objBean.setChkGenrateMI(objSetupHdModel.getStrGenrateMI());
			objBean.setStrFTPAddress(objSetupHdModel.getStrFTPAddress());
			objBean.setStrFTPServerUserName(objSetupHdModel.getStrFTPServerUserName());
			objBean.setStrFTPServerPass(objSetupHdModel.getStrFTPServerPass());
			objBean.setChkAllowToCalculateItemWeight(objSetupHdModel.getStrAllowToCalculateItemWeight());
			objBean.setStrShowBillsDtlType(objSetupHdModel.getStrShowBillsDtlType());
			objBean.setChkPrintInvoiceOnBill(objSetupHdModel.getStrPrintTaxInvoiceOnBill());
			objBean.setChkPrintInclusiveOfAllTaxesOnBill(objSetupHdModel.getStrPrintInclusiveOfAllTaxesOnBill());
			objBean.setStrApplyDiscountOn(objSetupHdModel.getStrApplyDiscountOn());
			objBean.setChkMemberCodeForKotInMposByCardSwipe(objSetupHdModel.getStrMemberCodeForKotInMposByCardSwipe());
			objBean.setChkPrintBill(objSetupHdModel.getStrPrintBillYN());
			objBean.setChkUseVatAndServiceNoFromPos(objSetupHdModel.getStrVatAndServiceTaxFromPos());
			objBean.setChkMemberCodeForMakeBillInMPOS(objSetupHdModel.getStrMemberCodeForMakeBillInMPOS());
			objBean.setChkItemWiseKOTPrintYN(objSetupHdModel.getStrItemWiseKOTYN());
			objBean.setStrPOSForDayEnd(objSetupHdModel.getStrLastPOSForDayEnd());
			objBean.setStrCMSPostingType(objSetupHdModel.getStrCMSPostingType());
			objBean.setChkPopUpToApplyPromotionsOnBill(objSetupHdModel.getStrPopUpToApplyPromotionsOnBill());
			objBean.setChkSelectCustomerCodeFromCardSwipe(objSetupHdModel.getStrSelectCustomerCodeFromCardSwipe());
			objBean.setChkCheckDebitCardBalOnTrans(objSetupHdModel.getStrCheckDebitCardBalOnTransactions());
			objBean.setChkSettlementsFromPOSMaster(objSetupHdModel.getStrSettlementsFromPOSMaster());
			objBean.setChkShiftWiseDayEnd(objSetupHdModel.getStrShiftWiseDayEndYN());
			objBean.setChkProductionLinkup(objSetupHdModel.getStrProductionLinkup());
			objBean.setChkLockDataOnShift(objSetupHdModel.getStrLockDataOnShift());
			objBean.setStrWSClientCode(objSetupHdModel.getStrWSClientCode());
			objBean.setStrEnableBillSeries(objSetupHdModel.getStrEnableBillSeries());
			objBean.setChkEnablePMSIntegration(objSetupHdModel.getStrEnablePMSIntegrationYN());
			objBean.setChkPrintTimeOnBill(objSetupHdModel.getStrPrintTimeOnBill());
			objBean.setChkPrintTDHItemsInBill(objSetupHdModel.getStrPrintTDHItemsInBill());
			objBean.setChkPrintRemarkAndReasonForReprint(objSetupHdModel.getStrPrintRemarkAndReasonForReprint());
			objBean.setIntDaysBeforeOrderToCancel((long) objSetupHdModel.getIntDaysBeforeOrderToCancel());
			objBean.setIntNoOfDelDaysForAdvOrder((long) objSetupHdModel.getIntNoOfDelDaysForAdvOrder());
			objBean.setIntNoOfDelDaysForUrgentOrder((long) objSetupHdModel.getIntNoOfDelDaysForUrgentOrder());
			objBean.setChkSetUpToTimeForAdvOrder(objSetupHdModel.getStrSetUpToTimeForAdvOrder());
			objBean.setChkSetUpToTimeForUrgentOrder(objSetupHdModel.getStrSetUpToTimeForUrgentOrder());
			
			String upToTimeForAdvOrder = (objSetupHdModel.getStrUpToTimeForAdvOrder()).split(" ")[0];
			objBean.setStrHours(upToTimeForAdvOrder.split(":")[0].trim());
			objBean.setStrMinutes(upToTimeForAdvOrder.split(":")[1].trim());
			objBean.setStrAMPM((objSetupHdModel.getStrUpToTimeForAdvOrder()).split(" ")[1]);
			
			String upToTimeForUrgentOrder = (objSetupHdModel.getStrUpToTimeForUrgentOrder()).split(" ")[0];
			objBean.setStrHoursUrgentOrder(upToTimeForUrgentOrder.split(":")[0].trim());
			objBean.setStrMinutesUrgentOrder(upToTimeForUrgentOrder.split(":")[1].trim());
			objBean.setStrAMPMUrgent((objSetupHdModel.getStrUpToTimeForUrgentOrder()).split(" ")[1]);
			
			objBean.setChkEnableBothPrintAndSettleBtnForDB(objSetupHdModel.getStrEnableBothPrintAndSettleBtnForDB());
			objBean.setStrInrestoPOSIntegrationYN(objSetupHdModel.getStrInrestoPOSIntegrationYN());
			objBean.setStrInrestoPOSWesServiceURL(objSetupHdModel.getStrInrestoPOSWebServiceURL());
			objBean.setStrInrestoPOSId(objSetupHdModel.getStrInrestoPOSId());
			objBean.setStrInrestoPOSKey(objSetupHdModel.getStrInrestoPOSKey());
			objBean.setChkCarryForwardFloatAmtToNextDay(objSetupHdModel.getStrCarryForwardFloatAmtToNextDay());
			objBean.setChkOpenCashDrawerAfterBillPrint(objSetupHdModel.getStrOpenCashDrawerAfterBillPrintYN());
			objBean.setStrPropertyWiseSalesOrderYN(objSetupHdModel.getStrPropertyWiseSalesOrderYN());
			objBean.setChkShowItemDtlsForChangeCustomerOnBill(objSetupHdModel.getStrShowItemDetailsGrid());
			objBean.setChkShowPopUpForNextItemQuantity(objSetupHdModel.getStrShowPopUpForNextItemQuantity());
			objBean.setStrJioPOSIntegrationYN(objSetupHdModel.getStrJioMoneyIntegration());
			objBean.setStrJioPOSWesServiceURL(objSetupHdModel.getStrJioWebServiceUrl());
			objBean.setStrJioMID(objSetupHdModel.getStrJioMID());
			objBean.setStrJioTID(objSetupHdModel.getStrJioTID());
			objBean.setStrJioActivationCode(objSetupHdModel.getStrJioActivationCode());
			objBean.setStrJioDeviceID(objSetupHdModel.getStrJioDeviceID());
			if (!objSetupHdModel.getStrJioDeviceID().toString().isEmpty())
			{
				JioDeviceIDFound = true;
				JioDeviceIDFromDB = objSetupHdModel.getStrJioDeviceID().toString();
			}
			objBean.setChkNewBillSeriesForNewDay(objSetupHdModel.getStrNewBillSeriesForNewDay());
			objBean.setDblMaxDiscount(objSetupHdModel.getDblMaxDiscount());

			objBean.setChkShowReportsPOSWise(objSetupHdModel.getStrShowReportsPOSWise());
			objBean.setChkEnableDineIn(objSetupHdModel.getStrEnableDineIn());
			objBean.setChkAutoAreaSelectionInMakeKOT(objSetupHdModel.getStrAutoAreaSelectionInMakeKOT());
			objBean.setStrHomeDeliAreaForDirectBiller(objSetupHdModel.getStrHomeDeliveryAreaForDirectBiller());
			objBean.setStrTakeAwayAreaForDirectBiller(objSetupHdModel.getStrTakeAwayAreaForDirectBiller());
			objBean.setChkRoundOffBillAmount(objSetupHdModel.getStrRoundOffBillFinalAmt());
			objBean.setChkPrintItemsOnMoveKOTMoveTable(objSetupHdModel.getStrPrintItemsOnMoveKOTMoveTable());
			objBean.setIntNoOfDecimalPlaces(objSetupHdModel.getDblNoOfDecimalPlace());
			objBean.setChkPrintMoveTableMoveKOT(objSetupHdModel.getStrPrintMoveTableMoveKOTYN());
			objBean.setChkSendDBBackupOnMail(objSetupHdModel.getStrSendDBBackupOnClientMail());
			objBean.setChkPrintQtyTotal(objSetupHdModel.getStrPrintQtyTotal());
			objBean.setChkPrintOrderNoOnBill(objSetupHdModel.getStrPrintOrderNoOnBillYN());
			objBean.setChkAutoAddKOTToBill(objSetupHdModel.getStrAutoAddKOTToBill());
			objBean.setChkPrintDeviceUserDtlOnKOT(objSetupHdModel.getStrPrintDeviceAndUserDtlOnKOTYN());
			objBean.setChkFireCommunication(objSetupHdModel.getStrFireCommunication());
			objBean.setStrRemoveServiceChargeTaxCode(objSetupHdModel.getStrRemoveSCTaxCode());
			objBean.setChkLockTableForWaiter(objSetupHdModel.getStrLockTableForWaiter());
			objBean.setDblUSDCrrencyConverionRate(objSetupHdModel.getDblUSDConverionRate());
			objBean.setStrShowReportsInCurrency(objSetupHdModel.getStrShowReportsInCurrency());
			objBean.setStrPOSToMMSPostingCurrency(objSetupHdModel.getStrPOSToMMSPostingCurrency());
			objBean.setStrPOSToWebBooksPostingCurrency(objSetupHdModel.getStrPOSToWebBooksPostingCurrency());
			objBean.setStrBenowPOSIntegrationYN(objSetupHdModel.getStrBenowIntegrationYN());
			objBean.setStrMerchantCode(objSetupHdModel.getStrMerchantCode());
			//objBean.setStrSuperMerchantCode(objSetupHdModel.getStrSuperMerchantCode());
			objBean.setStrAuthenticationKey(objSetupHdModel.getStrAuthenticationKey());

			objBean.setStrPostMMSSalesEffectCostOrLoc(objSetupHdModel.getStrPostSalesCostOrLoc());
			objBean.setChkEnableNFCInterface(objSetupHdModel.getStrEnableNFCInterface());

			// Newly Added
			objBean.setStrPrintOpenItemsOnBill(objSetupHdModel.getStrPrintOpenItemsOnBill());

			objBean.setStrShowUnSettlementForm(objSetupHdModel.getStrShowUnSettlementForm());

			objBean.setDblRoundOff(objSetupHdModel.getDblRoundOff());

			objBean.setStrScanQRYN(objSetupHdModel.getStrScanQRYN());

			objBean.setStrAreaWisePromotions(objSetupHdModel.getStrAreaWisePromotions());

			objBean.setStrPrintHomeDeliveryYN(objSetupHdModel.getStrPrintHomeDeliveryYN());

			objBean.setStrShowPurRateInDirectBiller(objSetupHdModel.getStrShowPurRateInDirectBiller());

			objBean.setStrEffectOfSales(objSetupHdModel.getStrEffectOfSales());

			objBean.setStrEnableTableReservationForCustomer(objSetupHdModel.getStrEnableTableReservationForCustomer());

			objBean.setStrAutoShowPopItems(objSetupHdModel.getStrAutoShowPopItems());

			objBean.setStrEnableBillSeries(objSetupHdModel.getStrEnableBillSeries());

			objBean.setStrEnableLockTable(objSetupHdModel.getStrEnableLockTable());

			objBean.setStrReprintOnSettleBill(objSetupHdModel.getStrReprintOnSettleBill());

			objBean.setStrPOSWiseItemToMMSProductLinkUpYN(objSetupHdModel.getStrPOSWiseItemToMMSProductLinkUpYN());

			objBean.setStrEnableMasterDiscount(objSetupHdModel.getStrEnableMasterDiscount());

			objBean.setStrTableReservationSMS(objSetupHdModel.getStrTableReservationSMS());

			objBean.setStrSendTableReservationSMS(objSetupHdModel.getStrSendTableReservationSMS());
			objBean.setStrConsolidatedKOTPrinterPort(objSetupHdModel.getStrConsolidatedKOTPrinterPort());
			objBean.setStrAutoShowPopItems(objSetupHdModel.getStrAutoShowPopItems());
			
			objBean.setStrMergeAllKOTSToBill(objSetupHdModel.getStrMergeAllKOTSToBill());
			objBean.setStrXEmail(objSetupHdModel.getStrXEmail());
			objBean.setStrSalt(objSetupHdModel.getStrSalt());
			objBean.setLongCustSeries(objSetupHdModel.getLongCustSeries());
			objBean.setStrDayEndSMSYN(objSetupHdModel.getStrDayEnd());
			objBean.setStrBillFormatType(objSetupHdModel.getStrBillFormatType());
			/*objBean.setStrVoidBill(objSetupHdModel.getStrVoidBill());
			objBean.setStrVoidAdvOrderSMSYN(objSetupHdModel.getStrVoidAdvOrderSMSYN());
			objBean.setStrVoidKOTSMSYN(objSetupHdModel.getStrVoidKOTSMSYN());
			objBean.setStrNCKOTSMSYN(objSetupHdModel.getStrNCKOTSMSYN());
			objBean.setStrSettleBill(objSetupHdModel.getStrSettleBill());
			objBean.setStrModifyBill(objSetupHdModel.getStrModifyBill());
			objBean.setStrComplimentaryBill(objSetupHdModel.getStrComplimentaryBill());*/
			objBean.setStrShowBillsDtlType(objSetupHdModel.getStrShowBillsDtlType());
			objBean.setStrEmailSmtpHost(objSetupHdModel.getStrEmailSmtpHost());
			objBean.setStrBillFormatType(objSetupHdModel.getStrBillFormatType());
			objBean.setStrEmailSmtpPort(objSetupHdModel.getStrEmailSmtpPort());
			objBean.setStrConsolidatedKOTPrinterPort(objSetupHdModel.getStrConsolidatedKOTPrinterPort());
			objBean.setStrEmail(objSetupHdModel.getStrEmail());
			objBean.setStrPrintOriginalOnBill(objSetupHdModel.getStrPrintOriginalOnBill());
			objBean.setStrShowNotificationsOnTransaction(objSetupHdModel.getStrShowNotificationsOnTransaction());
			objBean.setStrBlankDayEndPrint(objSetupHdModel.getStrBlankDayEndPrint());
			objBean.setStrOnlineOrderNotification(objSetupHdModel.getStrOnlineOrderNotification());
			objBean.setStrDisplayTotalShowBill(objSetupHdModel.getStrDisplayTotalShowBill());
			objBean.setStrUserWiseShowBill(objSetupHdModel.getStrUserWiseShowBill());
			objBean.setStrPostSalesDataToExcise(objSetupHdModel.getStrPostSalesDataToExcise());
			
			objBean.setStrWERAOnlineOrderIntegration(objSetupHdModel.getStrWERAOnlineOrderIntegration());
			objBean.setStrWERAMerchantOutletId(objSetupHdModel.getStrWERAMerchantOutletId());
			objBean.setStrPostRoundOffToWebBooks(objSetupHdModel.getStrPostRoundOffToWebBooks());
		
			objBean.setStrCheckDebitCardBalOnTransactions(objSetupHdModel.getStrCheckDebitCardBalOnTransactions());
			objBean.setStrWERAAuthenticationAPIKey(objSetupHdModel.getStrWERAAuthenticationAPIKey());
			objBean.setStrMultipleBillPrinting(objSetupHdModel.getStrMultipleBillPrinting());
			
			objBean.setIntShowPopItemsOfDays(Integer.parseInt(String.valueOf(objSetupHdModel.getIntShowPopItemsOfDays())));

			objBean.setStrMultipleKOTPrintYN(objSetupHdModel.getStrMultipleKOTPrintYN());

			objBean.setStrAreaWiseCostCenterKOTPrintingYN(objSetupHdModel.getStrAreaWiseCostCenterKOTPrintingYN());
			
			objBean.setStrDineInAreaForDirectBiller(objSetupHdModel.getStrDirectAreaCode());
			objBean.setStrHomeDeliveryAreaForDirectBiller(objSetupHdModel.getStrHomeDeliveryAreaForDirectBiller());
			objBean.setStrTakeAwayAreaForDirectBiller(objSetupHdModel.getStrTakeAwayAreaForDirectBiller());
			objBean.setStrMergeAllKOTSToBill(objSetupHdModel.getStrMergeAllKOTSToBill());

			// Setting Mobile Number in SMS
			List listsms = funFillSMSSetupData(posCode, clientCode);
			if (listsms.size() > 0)
			{

				for (int i = 0; i < listsms.size(); i++)
				{

					objBean.setStrTransactionName((String) listsms.get(0));
					objBean.setStrSendSMSYN((String) listsms.get(1));
					objBean.setLongSMSMobileNo((String) listsms.get(2));

				}
			}

			dteEndDate = objSetupHdModel.getDteEndDate();

		}
		catch (Exception e)
		{
			e.printStackTrace();

		}

		return objBean;
	}

	@RequestMapping(value = "/loadPrinterDtl", method = RequestMethod.GET)
	public @ResponseBody clsPOSPropertySetupBean funSetPrinterDtl(HttpServletRequest request)
	{
		List<clsPOSPrinterSetupBean> listBillSeriesDtl = new ArrayList<clsPOSPrinterSetupBean>();
		clsPOSPropertySetupBean objBean = new clsPOSPropertySetupBean();
		StringBuilder sqlStringBuilder = new StringBuilder();
		try
		{

			sqlStringBuilder.append(" select a.strCostCenterCode,a.strCostCenterName,ifnull(b.strPrimaryPrinterPort,'')" + " ,ifnull(b.strSecondaryPrinterPort,''),ifnull(b.strPrintOnBothPrintersYN,'N')" + " from tblcostcentermaster a " + " left outer join tblprintersetup b on a.strCostCenterCode=b.strCostCenterCode");

			List list = objBaseService.funGetList(sqlStringBuilder, "sql");
			if (list != null)
			{
				clsPOSPrinterSetupBean objPrinterBean;
				for (int i = 0; i < list.size(); i++)
				{
					Object[] obj = (Object[]) list.get(i);
					objPrinterBean = new clsPOSPrinterSetupBean();
					objPrinterBean.setStrCostCenterCode(obj[0].toString());
					objPrinterBean.setStrCostCenterName(obj[1].toString());
					objPrinterBean.setStrPrimaryPrinterPort(obj[2].toString());
					objPrinterBean.setStrSecondaryPrinterPort(obj[3].toString());
					objPrinterBean.setStrPrintOnBothPrintersYN(obj[4].toString());
					listBillSeriesDtl.add(objPrinterBean);
				}
				objBean.setListPrinterDtl(listBillSeriesDtl);
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return objBean;
	}

	@RequestMapping(value = "/loadOldSBillSeriesSetup", method = RequestMethod.GET)
	public @ResponseBody String funSetBillSeries(@RequestParam("posCode") String posCode, HttpServletRequest request)
	{
		String strType = "";
		try
		{
			String sqlBillSeries = "select a.strType from tblbillseries a where a.strPOSCode='" + posCode + "' group by a.strType  ";
			List list = objBaseService.funGetList(new StringBuilder(sqlBillSeries), "sql");
			if (list.size() > 0)
			{
				strType = (String) list.get(0).toString();
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return strType;
	}

	// Pratiksha
	private List funFillSMSSetupData(String posCode, String clientCode) throws Exception
	{

		String strSMSMobileNo = "";
		List listsms = new ArrayList();
		StringBuilder sqlSMSMobileNo = new StringBuilder("select strTransactionName,strSendSMSYN,longMobileNo from tblsmssetup a  " + "where strPOSCode='" + posCode + "' and strClientCode='" + clientCode + "' ");
		List list = objBaseService.funGetList(sqlSMSMobileNo, "sql");
		if (list.size() > 0)
		{
			for (int i = 0; i < list.size(); i++)
			{
				Object[] obj = (Object[]) list.get(i);
				String transName = obj[0].toString();
				String sendSMSYN = obj[1].toString();
				String mobileNo = obj[2].toString();
				listsms.add(transName);
				listsms.add(sendSMSYN);
				listsms.add(mobileNo);

			}
		}
		return listsms;

	}

	@RequestMapping(value = "/loadOldBillSeries", method = RequestMethod.GET)
	public @ResponseBody clsPOSPropertySetupBean funSetSelectedBillSeries(@RequestParam("posCode") String posCode, HttpServletRequest request)
	{
		List<clsPOSBillSeriesDtlBean> listBillSeriesDtl = new ArrayList<clsPOSBillSeriesDtlBean>();
		clsPOSPropertySetupBean objBean = new clsPOSPropertySetupBean();
		try
		{

			StringBuilder sqlBillSeries = new StringBuilder("select a.strType,a.strBillSeries,a.strCodes,a.strNames,a.strPrintGTOfOtherBills,strPrintInclusiveOfTaxOnBill " + " from tblbillseries a where strPOSCode='" + posCode + "' ");

			List list = objBaseService.funGetList(sqlBillSeries, "sql");
			if (list.size() > 0)
			{
				clsPOSBillSeriesDtlBean objBillSeries;
				for (int i = 0; i < list.size(); i++)
				{
					Object[] obj = (Object[]) list.get(i);
					objBillSeries = new clsPOSBillSeriesDtlBean();
					objBillSeries.setStrBillSeries(obj[1].toString());
					objBillSeries.setStrCodes(obj[2].toString());
					objBillSeries.setStrNames(obj[3].toString());
					objBillSeries.setStrPrintGTOfOtherBills(obj[4].toString());
					objBillSeries.setStrPrintInclusiveOfTaxOnBill(obj[5].toString());

					listBillSeriesDtl.add(objBillSeries);
				}
				objBean.setListBillSeriesDtl(listBillSeriesDtl);
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}

		return objBean;
	}

	@RequestMapping(value = "/loadSelectedTypeDtlTable", method = RequestMethod.GET)
	public @ResponseBody List funLoadSelectedTypeDtlTable(@RequestParam("strType") String strType, HttpServletRequest req) throws Exception
	{
		String clientCode = req.getSession().getAttribute("gClientCode").toString();
		List listTypeData = new ArrayList();
		switch (strType)
		{
		case "Group":
			List list = objMasterService.funLoadGrouptData(clientCode);
			if (list.size() > 0)
			{
				listTypeData = list;
			}
			break;

		case "Sub Group":
			/*
			 * jArrList=objPOSGlobal.funGetAllSubGroup(clientCode);
			 * if(null!=jArrList) { for(int cnt=0;cnt<jArrList.size();cnt++) {
			 * JSONObject jobj=(JSONObject) jArrList.get(cnt);
			 * listTypeData.add(jobj); } }
			 */
			break;
		case "Menu Head":
			/*
			 * jArrList=objPOSGlobal.funGetAllMenuHeadForMaster(clientCode);
			 * if(null!=jArrList) { for(int cnt=0;cnt<jArrList.size();cnt++) {
			 * JSONObject jobj=(JSONObject) jArrList.get(cnt);
			 * listTypeData.add(jobj); } }
			 */
			break;
		case "Revenue Head":
			/*
			 * jArrList=objPOSGlobal.funGetAllRevenueHead(clientCode);
			 * if(null!=jArrList) { for(int cnt=0;cnt<jArrList.size();cnt++) {
			 * 
			 * listTypeData.add((String)jArrList.get(cnt)); } }
			 */
			break;

		}
		return listTypeData;
	}

	// Updatation Of Data
	@RequestMapping(value = "/savePOSPropertySetup", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsPOSPropertySetupBean objBean, BindingResult result, HttpServletRequest req, @RequestParam("companyLogo") MultipartFile file)
	{

		String posCode = "";
		try
		{

			String clientCode = req.getSession().getAttribute("gClientCode").toString();
			String webStockUserCode = req.getSession().getAttribute("gUserCode").toString();

			clsSetupHdModel objModel = new clsSetupHdModel(new clsSetupModel_ID(clientCode, posCode));
			String dateTime = obUtilityController.funGetCurrentDateTime();
			if (file.getSize() != 0)
			{
				Blob blobProdImage = Hibernate.createBlob(file.getInputStream());
				objModel.setBlobReportImage(blobProdImage);
				FileOutputStream fileOuputStream = null;
				try
				{
					byte[] bytes = file.getBytes();
					String imagePath = servletContext.getRealPath("/resources/images");
					fileOuputStream = new FileOutputStream(imagePath + "/imgClientImage.jpg");
					fileOuputStream.write(bytes);
					fileOuputStream.close();
				}
				catch (IOException e)
				{
					e.printStackTrace();
				}
			}
			objModel.setStrActivePromotions(objGlobal.funIfNull(objBean.getChkActivePromotions(), "N", "Y"));
			objModel.setDblMaxDiscount(objBean.getDblMaxDiscount());
			objModel.setDteEndDate(dteEndDate);
			objModel.setDteHOServerDate(objBean.getDteHOServerDate());
			objModel.setDteStartDate(dateTime);
			objModel.setIntAdvReceiptPrintCount(objBean.getStrAdvRecPrintCount());
			objModel.setIntBillPaperSize(objBean.getIntBiilPaperSize());
			objModel.setIntColumnSize(objBean.getIntColumnSize());
			objModel.setIntDaysBeforeOrderToCancel(objBean.getIntDaysBeforeOrderToCancel());
			objModel.setIntNoOfDelDaysForAdvOrder(objBean.getIntNoOfDelDaysForAdvOrder());
			objModel.setIntNoOfDelDaysForUrgentOrder(objBean.getIntNoOfDelDaysForUrgentOrder());
			objModel.setIntPinCode(objBean.getStrPinCode());
			objModel.setIntTelephoneNo(objBean.getStrTelephone());
			objModel.setStrAddressLine1(objBean.getStrAddrLine1());
			objModel.setStrAddressLine2(objBean.getStrAddrLine2());
			objModel.setStrAddressLine3(objBean.getStrAddrLine3());
			objModel.setStrAllowNewAreaMasterFromCustMaster(objGlobal.funIfNull(objBean.getChkBoxAllowNewAreaMasterFromCustMaster(), "N", "Y"));
			objModel.setStrAllowToCalculateItemWeight(objGlobal.funIfNull(objBean.getChkAllowToCalculateItemWeight(), "N", "Y"));
			objModel.setStrApplyDiscountOn(objBean.getStrApplyDiscountOn());
			objModel.setStrAreaWisePricing(objGlobal.funIfNull(objBean.getChkAreaWisePricing(), "N", "Y"));
			//objModel.setStrBillFooter(objBean.getStrBillFooter());
			objModel.setStrBillFooterStatus("N");
			objModel.setStrBillStettlementSMS(objBean.getStrAreaBillSettlementSMS());
			objModel.setStrBody(objBean.getStrBodyPart());
			objModel.setStrCalculateDiscItemWise(objGlobal.funIfNull(objBean.getChkCalculateDiscItemWise(), "N", "Y"));
			objModel.setStrCalculateTaxOnMakeKOT(objGlobal.funIfNull(objBean.getChkCalculateTaxOnMakeKOT(), "N", "Y"));
			objModel.setStrCardInterfaceType(objBean.getStrCardIntfType());
			objModel.setStrCarryForwardFloatAmtToNextDay(objGlobal.funIfNull(objBean.getChkCarryForwardFloatAmtToNextDay(), "N", "Y"));
			objModel.setStrChangeQtyForExternalCode(objGlobal.funIfNull(objBean.getChkChangeQtyForExternalCode(), "N", "Y"));
			objModel.setStrChangeTheme(objBean.getStrChangeTheme());
			objModel.setStrCheckDebitCardBalOnTransactions(objGlobal.funIfNull(objBean.getChkCheckDebitCardBalOnTrans(), "N", "Y"));
			objModel.setStrCityName(objBean.getStrCity());
			objModel.setStrClientCode(objBean.getStrClientCode());
			objModel.setStrClientName(objBean.getStrClientName());
			objModel.setStrCMSIntegrationYN(objBean.getStrCMSIntegrationYN());
			objModel.setStrCMSMemberForKOTJPOS(objGlobal.funIfNull(objBean.getChkMemberCodeForKOTJPOS(), "N", "Y"));
			objModel.setStrCMSMemberForKOTMPOS(objGlobal.funIfNull(objBean.getChkMemberCodeForKOTMPOS(), "N", "Y"));
			objModel.setStrCMSPOSCode(objBean.getStrPosCode());
			objModel.setStrCMSPostingType(objBean.getStrCMSPostingType());
			objModel.setStrCMSWebServiceURL(objBean.getStrCMSWesServiceURL());
			objModel.setStrConfirmEmailPassword(objBean.getStrEmailPassword());
			objModel.setStrCountry(objBean.getStrCountry());
			objModel.setStrCreditCardExpiryDateCompulsoryYN(objGlobal.funIfNull(objBean.getChkExpDateForCreditCardBillYN(), "N", "Y"));
			objModel.setStrCreditCardSlipNoCompulsoryYN(objGlobal.funIfNull(objBean.getChkSlipNoForCreditCardBillYN(), "N", "Y"));
			objModel.setStrCRMInterface(objBean.getStrCRM());
			objModel.setStrCustAddressSelectionForBill(objGlobal.funIfNull(objBean.getChkSelectCustAddressForBill(), "N", "Y"));
			objModel.setStrCustAreaMasterCompulsory(objGlobal.funIfNull(objBean.getChkAreaMasterCompulsory(), "N", "Y"));
			objModel.setLongCustSeries(objBean.getLongCustSeries());
			objModel.setStrDatabaseName(objBean.getStrRFIDDatabaseName());
			objModel.setStrDataPostFlag("Y");
			objModel.setStrDataSendFrequency(objBean.getStrDataSendFrequency());
			objModel.setStrDayEnd(objGlobal.funIfNull(objBean.getChkDayEnd(), "N", "Y"));
			objModel.setStrDBPassword(objBean.getStrRFIDPassword());
			objModel.setStrDBUserName(objBean.getStrRFIDUserName());
			objModel.setStrDelBoySelCompulsoryOnDirectBiller(objGlobal.funIfNull(objBean.getChkDelBoyCompulsoryOnDirectBiller(), "N", "Y"));
			objModel.setStrDirectAreaCode(objBean.getStrDirectArea());
			objModel.setStrDirectKOTPrintMakeKOT(objGlobal.funIfNull(objBean.getChkDirectKOTPrintMakeKOT(), "N", "Y"));
			objModel.setStrDiscountNote("N");
			objModel.setStrDontShowAdvOrderInOtherPOS(objGlobal.funIfNull(objBean.getChkDontShowAdvOrderInOtherPOS(), "N", "Y"));
			objModel.setStrEditHomeDelivery(objGlobal.funIfNull(objBean.getChkEditHomeDelivery(), "N", "Y"));
			objModel.setStrEffectOnPSP(objGlobal.funIfNull(objBean.getChkEffectOnPSP(), "N", "Y"));
			objModel.setStrEmail(objBean.getStrEmail());
			objModel.setStrEmailPassword(objBean.getStrEmailPassword());
			objModel.setStrEmailServerName(objBean.getStrEmailServerName());
			objModel.setStrEnableBillSeries(objGlobal.funIfNull(objBean.getStrEnableBillSeries(), "N", "Y"));
			objModel.setStrEnableBothPrintAndSettleBtnForDB(objGlobal.funIfNull(objBean.getChkEnableBothPrintAndSettleBtnForDB(), "N", "Y"));
			objModel.setStrEnableKOT(objGlobal.funIfNull(objBean.getChkEnableKOT(), "N", "Y"));
			objModel.setStrEnableKOTForDirectBiller(objGlobal.funIfNull(objBean.getChkPrintKotForDirectBiller(), "N", "Y"));
			objModel.setStrEnablePMSIntegrationYN(objGlobal.funIfNull(objBean.getChkEnablePMSIntegration(), "N", "Y"));
			objModel.setStrFTPAddress(objBean.getStrFTPAddress());
			objModel.setStrFTPServerPass(objBean.getStrFTPServerPass());
			objModel.setStrFTPServerUserName(objBean.getStrFTPServerUserName());
			objModel.setStrGenrateMI(objGlobal.funIfNull(objBean.getChkGenrateMI(), "N", "Y"));
			objModel.setStrGetWebserviceURL(objBean.getStrGetWebservice());
			objModel.setStrHomeDeliverySMS(objBean.getStrAreaSendHomeDeliverySMS());
			objModel.setStrInrestoPOSId(objBean.getStrInrestoPOSId());
			objModel.setStrInrestoPOSIntegrationYN(objBean.getStrInrestoPOSIntegrationYN());
			objModel.setStrInrestoPOSKey(objBean.getStrInrestoPOSKey());
			objModel.setStrInrestoPOSWebServiceURL(objBean.getStrInrestoPOSWesServiceURL());
			objModel.setStrItemQtyNumpad(objGlobal.funIfNull(objBean.getChkItemQtyNumpad(), "N", "Y"));
			objModel.setStrItemType(objBean.getStrItemType());
			objModel.setStrItemWiseKOTYN(objGlobal.funIfNull(objBean.getChkItemWiseKOTPrintYN(), "N", "Y"));
			objModel.setStrJioActivationCode(objBean.getStrJioActivationCode());
			objModel.setStrJioDeviceID(objBean.getStrJioDeviceID());
			objModel.setStrJioMID(objBean.getStrJioMID());
			objModel.setStrJioMoneyIntegration(objBean.getStrJioPOSIntegrationYN());
			objModel.setStrJioTID(objBean.getStrJioTID());
			objModel.setStrJioWebServiceUrl(objBean.getStrJioPOSWesServiceURL());
			objModel.setStrKOTToLocalPrinter(objGlobal.funIfNull(objBean.getChkPrintKOTToLocalPrinter(), "N", "Y"));
			objModel.setStrLastPOSForDayEnd(objBean.getStrPOSForDayEnd());
			objModel.setStrLockDataOnShift(objGlobal.funIfNull(objBean.getChkLockDataOnShift(), "N", "Y"));
			objModel.setStrManualAdvOrderNoCompulsory(objGlobal.funIfNull(objBean.getChkManualAdvOrderCompulsory(), "N", "Y"));
			objModel.setStrManualBillNo(objGlobal.funIfNull(objBean.getChkManualBillNo(), "N", "Y"));
			objModel.setStrMemberCodeForKotInMposByCardSwipe(objGlobal.funIfNull(objBean.getChkMemberCodeForKotInMposByCardSwipe(), "N", "Y"));
			objModel.setStrMemberCodeForMakeBillInMPOS(objGlobal.funIfNull(objBean.getChkMemberCodeForMakeBillInMPOS(), "N", "Y"));
			objModel.setStrMenuItemDispSeq(objBean.getStrMenuItemDisSeq());
			objModel.setStrMenuItemSortingOn(objBean.getStrMenuItemSortingOn());
			objModel.setStrMoveTableToOtherPOS(objGlobal.funIfNull(objBean.getChkMoveTableToOtherPOS(), "N", "Y"));
			objModel.setStrMoveKOTToOtherPOS(objGlobal.funIfNull(objBean.getChkMoveKOTToOtherPOS(), "N", "Y"));
			//objModel.setStrMultipleBillPrinting(objGlobal.funIfNull(objBean.getChkMultiBillPrint(), "N", "Y"));
			objModel.setStrMultipleKOTPrintYN(objGlobal.funIfNull(objBean.getStrMultipleKOTPrintYN(), "N", "Y"));
			objModel.setStrMultiWaiterSelectionOnMakeKOT(objGlobal.funIfNull(objBean.getChkMultipleWaiterSelectionOnMakeKOT(), "N", "Y"));
			objModel.setStrNatureOfBusinnes(objBean.getStrNatureOfBussness());
			objModel.setStrNegativeBilling(objGlobal.funIfNull(objBean.getChkNegBilling(), "N", "Y"));
			objModel.setStrNewBillSeriesForNewDay(objGlobal.funIfNull(objBean.getChkNewBillSeriesForNewDay(), "N", "Y"));
			objModel.setStrNoOfLinesInKOTPrint(objBean.getIntNoOfLinesInKOTPrint());
			objModel.setStrOpenCashDrawerAfterBillPrintYN(objGlobal.funIfNull(objBean.getChkOpenCashDrawerAfterBillPrint(), "N", "Y"));
			objModel.setStrOutletUID(objBean.getStrOutletUID());
			objModel.setStrPointsOnBillPrint(objGlobal.funIfNull(objBean.getChkPointsOnBillPrint(), "N", "Y"));
			objModel.setStrPopUpToApplyPromotionsOnBill(objGlobal.funIfNull(objBean.getChkPopUpToApplyPromotionsOnBill(), "N", "Y"));
			objModel.setStrPOSCode(objBean.getStrPosCode());
			objModel.setStrPOSID(objBean.getStrPOSID());
			objModel.setStrPostSalesDataToMMS(objGlobal.funIfNull(objBean.getChkPostSalesDataToMMS(), "N", "Y"));
			objModel.setStrPostWebserviceURL(objBean.getStrPostWebservice());
			objModel.setStrPOSType(objBean.getStrPOSType());
			objModel.setStrPriceFrom(objBean.getStrPriceFrom());
			objModel.setStrPrintBillYN(objGlobal.funIfNull(objBean.getChkPrintBill(), "N", "Y"));
			objModel.setStrPrintInclusiveOfAllTaxesOnBill(objGlobal.funIfNull(objBean.getChkPrintInclusiveOfAllTaxesOnBill(), "N", "Y"));
			objModel.setStrPrintKOTYN(objGlobal.funIfNull(objBean.getChkPrintKOTYN(), "N", "Y"));
			objModel.setStrPrintManualAdvOrderNoOnBill(objGlobal.funIfNull(objBean.getChkPrintManualAdvOrderOnBill(), "N", "Y"));
			objModel.setStrPrintMode(objBean.getStrBillPrintMode());
			objModel.setStrPrintModifierQtyOnKOT(objGlobal.funIfNull(objBean.getChkPrintModifierQtyOnKOT(), "N", "Y"));
			objModel.setStrPrintOnVoidBill(objGlobal.funIfNull(objBean.getChkPrintForVoidBill(), "N", "Y"));
			objModel.setStrPrintRemarkAndReasonForReprint(objGlobal.funIfNull(objBean.getChkPrintRemarkAndReasonForReprint(), "N", "Y"));
			objModel.setStrPrintServiceTaxNo(objGlobal.funIfNull(objBean.getChkServiceTaxNo(), "N", "Y"));
			objModel.setStrPrintShortNameOnKOT(objGlobal.funIfNull(objBean.getChkPrintShortNameOnKOT(), "N", "Y"));
			objModel.setStrPrintTaxInvoiceOnBill(objGlobal.funIfNull(objBean.getChkPrintInvoiceOnBill(), "N", "Y"));
			objModel.setStrPrintTDHItemsInBill(objGlobal.funIfNull(objBean.getChkPrintTDHItemsInBill(), "N", "Y"));
			objModel.setStrPrintTimeOnBill(objGlobal.funIfNull(objBean.getChkPrintTimeOnBill(), "N", "Y"));
			objModel.setStrPrintType(objBean.getStrPrintingType());
			objModel.setStrPrintVatNo(objGlobal.funIfNull(objBean.getChkPrintVatNo(), "N", "Y"));
			objModel.setStrPrintZeroAmtModifierInBill(objGlobal.funIfNull(objBean.getChkPrintZeroAmtModifierInBill(), "N", "Y"));
			objModel.setStrProductionLinkup(objGlobal.funIfNull(objBean.getChkProductionLinkup(), "N", "Y"));
			objModel.setStrPropertyWiseSalesOrderYN(objGlobal.funIfNull(objBean.getStrPropertyWiseSalesOrderYN(), "N", "Y"));
			objModel.setStrReceiverEmailId(objBean.getStrReceiverEmailId());
			objModel.setStrRFID(objBean.getStrRFIDSetup());
			objModel.setStrSelectCustomerCodeFromCardSwipe(objGlobal.funIfNull(objBean.getChkSelectCustomerCodeFromCardSwipe(), "N", "Y"));
			objModel.setStrSelectWaiterFromCardSwipe(objGlobal.funIfNull(objBean.getChkSelectWaiterFromCardSwipe(), "N", "Y"));
			objModel.setStrSendBillSettlementSMS(objGlobal.funIfNull(objBean.getChkBillSettlementSMS(), "N", "Y"));
			objModel.setStrSenderEmailId(objBean.getStrSenderEmailId());
			objModel.setStrSendHomeDelSMS(objGlobal.funIfNull(objBean.getChkHomeDelSMS(), "N", "Y"));
			objModel.setStrServerName(objBean.getStrRFIDServerName());
			objModel.setStrServiceTaxNo(objBean.getStrServiceTaxNo());
			objModel.setStrSettleBtnForDirectBillerBill(objGlobal.funIfNull(objBean.getChkEnableSettleBtnForDirectBillerBill(), "N", "Y"));
			objModel.setStrSettlementsFromPOSMaster(objGlobal.funIfNull(objBean.getChkSettlementsFromPOSMaster(), "N", "Y"));
			objModel.setStrSetUpToTimeForAdvOrder(objGlobal.funIfNull(objBean.getChkSetUpToTimeForAdvOrder(), "N", "Y"));
			objModel.setStrSetUpToTimeForUrgentOrder(objGlobal.funIfNull(objBean.getChkSetUpToTimeForUrgentOrder(), "N", "Y"));
			objModel.setStrShiftWiseDayEndYN(objGlobal.funIfNull(objBean.getChkShiftWiseDayEnd(), "N", "Y"));
			objModel.setStrShowBill(objGlobal.funIfNull(objBean.getChkShowBills(), "N", "Y"));
			objModel.setStrShowBillsDtlType(objBean.getStrShowBillsDtlType());
			objModel.setStrShowCustHelp("N");
			objModel.setStrShowItemDetailsGrid(objGlobal.funIfNull(objBean.getChkShowItemDtlsForChangeCustomerOnBill(), "N", "Y"));
			objModel.setStrShowItemStkColumnInDB(objGlobal.funIfNull(objBean.getChkShowItemStkColumnInDB(), "N", "Y"));
			objModel.setStrShowPopUpForNextItemQuantity(objGlobal.funIfNull(objBean.getChkShowPopUpForNextItemQuantity(), "N", "Y"));
			objModel.setStrShowPrinterErrorMessage(objGlobal.funIfNull(objBean.getChkPrinterErrorMessage(), "N", "Y"));
			objModel.setStrShowReportsPOSWise(objGlobal.funIfNull(objBean.getChkShowReportsPOSWise(), "N", "Y"));
			objModel.setStrSkipPax(objGlobal.funIfNull(objBean.getChkSkipPaxSelection(), "N", "Y"));
			objModel.setStrSkipWaiter(objGlobal.funIfNull(objBean.getChkSkipWaiterSelection(), "N", "Y"));
			objModel.setStrSkipWaiterAndPax(objGlobal.funIfNull(objBean.getStrSkipWaiterAndPax(), "N", "Y"));
			objModel.setStrSlabBasedHDCharges(objGlobal.funIfNull(objBean.getChkSlabBasedHomeDelCharges(), "N", "Y"));
			objModel.setStrSMSApi(objBean.getStrAreaSMSApi());
			objModel.setStrSMSType(objBean.getStrSMSType());
			objModel.setStrState(objBean.getStrState());
			objModel.setStrStockInOption((objBean.getStrStockInOption()));
			objModel.setStrTakewayCustomerSelection(objGlobal.funIfNull(objBean.getChkTakewayCustomerSelection(), "N", "Y"));
			objModel.setStrTouchScreenMode("N");
			objModel.setStrTreatMemberAsTable(objGlobal.funIfNull(objBean.getChkMemberAsTable(), "N", "Y"));
			String upToTimeForAdvOrder = objBean.getStrHours() + ":" + objBean.getStrMinutes() + " " + objBean.getStrAMPM();
			String upToTimeForUrgentOrder = objBean.getStrHoursUrgentOrder() + ":" + objBean.getStrMinutesUrgentOrder() + " " + objBean.getStrAMPMUrgent();
			objModel.setStrUpToTimeForAdvOrder(upToTimeForAdvOrder);
			objModel.setStrUpToTimeForUrgentOrder(upToTimeForUrgentOrder);
			objModel.setStrVatAndServiceTaxFromPos(objGlobal.funIfNull(objBean.getChkUseVatAndServiceNoFromPos(), "N", "Y"));
			objModel.setStrVatNo(objBean.getStrVatNo());
			objModel.setStrWebServiceLink(objBean.getStrWebServiceLink());
			objModel.setStrWSClientCode(objBean.getStrWSClientCode());
			objModel.setStrEnableDineIn(objGlobal.funIfNull(objBean.getChkEnableDineIn(), "N", "Y"));
			objModel.setStrAutoAreaSelectionInMakeKOT(objGlobal.funIfNull(objBean.getChkAutoAreaSelectionInMakeKOT(), "N", "Y"));
			objModel.setStrHomeDeliveryAreaForDirectBiller(objGlobal.funIfNull(objBean.getStrHomeDeliAreaForDirectBiller()," ",objBean.getStrHomeDeliAreaForDirectBiller()));
			objModel.setStrTakeAwayAreaForDirectBiller(objBean.getStrTakeAwayAreaForDirectBiller());
			objModel.setStrRoundOffBillFinalAmt(objGlobal.funIfNull(objBean.getChkRoundOffBillAmount(), "N", "Y"));
			objModel.setStrPrintItemsOnMoveKOTMoveTable(objGlobal.funIfNull(objBean.getChkPrintItemsOnMoveKOTMoveTable(), "N", "Y"));
			
			objModel.setDblNoOfDecimalPlace(objBean.getIntNoOfDecimalPlaces());
			objModel.setStrPrintMoveTableMoveKOTYN(objGlobal.funIfNull(objBean.getChkPrintMoveTableMoveKOT(), "N", "Y"));
			objModel.setStrSendDBBackupOnClientMail(objGlobal.funIfNull(objBean.getChkSendDBBackupOnMail(), "N", "Y"));
			objModel.setStrPrintQtyTotal(objGlobal.funIfNull(objBean.getChkPrintQtyTotal(), "N", "Y"));
			objModel.setStrPrintOrderNoOnBillYN(objGlobal.funIfNull(objBean.getChkPrintOrderNoOnBill(), "N", "Y"));
			objModel.setStrAutoAddKOTToBill(objGlobal.funIfNull(objBean.getChkAutoAddKOTToBill(), "N", "Y"));
			objModel.setStrPrintDeviceAndUserDtlOnKOTYN(objGlobal.funIfNull(objBean.getChkPrintDeviceUserDtlOnKOT(), "N", "Y"));
			objModel.setStrFireCommunication(objGlobal.funIfNull(objBean.getChkFireCommunication(), "N", "Y"));
			
			objModel.setStrRemoveSCTaxCode(objGlobal.funIfNull(objBean.getStrRemoveServiceChargeTaxCode(), " ", objBean.getStrRemoveServiceChargeTaxCode()));
			
			objModel.setStrLockTableForWaiter(objGlobal.funIfNull(objBean.getChkLockTableForWaiter(), "N", "Y"));
			
			objModel.setDblUSDConverionRate(objBean.getDblUSDCrrencyConverionRate());
			objModel.setStrShowReportsInCurrency(objBean.getStrShowReportsInCurrency());
			objModel.setStrPOSToMMSPostingCurrency(objBean.getStrPOSToMMSPostingCurrency());
			objModel.setStrPOSToWebBooksPostingCurrency(objBean.getStrPOSToWebBooksPostingCurrency());
			objModel.setStrBenowIntegrationYN(objBean.getStrBenowPOSIntegrationYN());
			objModel.setStrXEmail(objBean.getStrEmail());
			objModel.setStrMerchantCode(objBean.getStrMerchantCode());
			//objModel.setStrSuperMerchantCode(objBean.getStrSuperMerchantCode());

			objModel.setStrAuthenticationKey(objBean.getStrAuthenticationKey());
			objModel.setStrSalt(objBean.getStrSalt());
			objModel.setStrWERAOnlineOrderIntegration(objBean.getStrWERAOnlineOrderIntegration());
			objModel.setStrWERAMerchantOutletId(objBean.getStrWERAMerchantOutletId());
			objModel.setStrWERAAuthenticationAPIKey(objBean.getStrWERAAuthenticationAPIKey());

			objModel.setStrPostSalesCostOrLoc(objBean.getStrPostMMSSalesEffectCostOrLoc());

			objModel.setStrShowUnSettlementForm(objGlobal.funIfNull(objBean.getStrShowUnSettlementForm(), "N", "Y"));

			objModel.setDblRoundOff((objBean.getDblRoundOff()));
			objModel.setIntShowPopItemsOfDays(Long.parseLong((String.valueOf(objBean.getIntShowPopItemsOfDays()))));

			objModel.setStrScanQRYN(objGlobal.funIfNull(objBean.getStrScanQRYN(), "N", "Y"));
			objModel.setStrAreaWisePromotions(objGlobal.funIfNull(objBean.getStrAreaWisePromotions(), "N", "Y"));

			objModel.setStrPrintHomeDeliveryYN(objGlobal.funIfNull(objBean.getStrPrintHomeDeliveryYN(), "N", "Y"));
			objModel.setStrShowPurRateInDirectBiller(objGlobal.funIfNull(objBean.getStrShowPurRateInDirectBiller(), "N", "Y"));

			//objModel.setStrEffectOfSales((objBean.getStrEffectOfSales()));
			objModel.setStrEffectOfSales(objGlobal.funIfNull(objBean.getStrEffectOfSales(),"No","Yes"));

			objModel.setStrEnableTableReservationForCustomer(objGlobal.funIfNull(objBean.getStrEnableTableReservationForCustomer(), "N", "Y"));
			objModel.setStrAutoShowPopItems((objBean.getStrAutoShowPopItems()));
			//objModel.setStrEnableBillSeries((objBean.getChkEnableBillSeries()));
			objModel.setStrEnableLockTable(objGlobal.funIfNull(objBean.getStrEnableLockTable(), "N", "Y"));

			objModel.setStrReprintOnSettleBill(objGlobal.funIfNull(objBean.getStrReprintOnSettleBill(), "N", "Y"));
			objModel.setStrPOSWiseItemToMMSProductLinkUpYN(objGlobal.funIfNull(objBean.getStrPOSWiseItemToMMSProductLinkUpYN(), "N", "Y"));
			objModel.setStrEnableMasterDiscount(objGlobal.funIfNull(objBean.getStrEnableMasterDiscount(), "N", "Y"));
			objModel.setStrTableReservationSMS((objBean.getStrTableReservationSMS()));
			objModel.setStrBillFormatType(objGlobal.funIfNull(objBean.getStrBillFormatType()," ",objBean.getStrBillFormatType()));
			objModel.setStrSendTableReservationSMS(objGlobal.funIfNull(objBean.getStrSendTableReservationSMS(), "N", "Y"));
			objModel.setStrConsolidatedKOTPrinterPort((objBean.getStrConsolidatedKOTPrinterPort()));
			objModel.setStrAutoShowPopItems(objGlobal.funIfNull(objBean.getStrAutoShowPopItems(), "N", "Y"));
			objModel.setStrPrintOpenItemsOnBill(objGlobal.funIfNull(objBean.getStrPrintOpenItemsOnBill(), "N", "Y"));

			objModel.setStrAreaWisePromotions(objGlobal.funIfNull(objBean.getStrAreaWisePromotions(), "N", "Y"));

			objModel.setDteDateCreated(dateTime);
			objModel.setDteDateEdited(dateTime);
			objModel.setStrUserCreated(webStockUserCode);
			objModel.setStrUserEdited(webStockUserCode);
			objModel.setStrEnableNFCInterface(objGlobal.funIfNull(objBean.getChkEnableNFCInterface(), "N", "Y"));
			objModel.setLongCustSeries(objBean.getLongCustSeries());
			objModel.setStrEmailSmtpPort(objBean.getStrEmailSmtpPort());
			
			objModel.setStrEmailSmtpHost(objBean.getStrEmailSmtpHost());
			objModel.setStrMergeAllKOTSToBill(objGlobal.funIfNull(objBean.getStrMergeAllKOTSToBill(), "N", "Y"));
			
			objModel.setStrWERAAuthenticationAPIKey(objBean.getStrWERAAuthenticationAPIKey());
			objModel.setStrEmail(objBean.getStrEmail());
			objModel.setStrPrintOriginalOnBill(objGlobal.funIfNull(objBean.getStrPrintOriginalOnBill(), "N", "Y"));
			objModel.setStrBlankDayEndPrint(objGlobal.funIfNull(objBean.getStrBlankDayEndPrint(), "N", "Y"));
			objModel.setStrOnlineOrderNotification(objGlobal.funIfNull(objBean.getStrOnlineOrderNotification(), "N", "Y"));
			
			objModel.setStrAreaWiseCostCenterKOTPrintingYN(objGlobal.funIfNull(objBean.getStrAreaWiseCostCenterKOTPrintingYN(), "N", "Y"));
			objModel.setStrPostRoundOffToWebBooks(objGlobal.funIfNull(objBean.getStrPostRoundOffToWebBooks(), "N", "Y"));
			objModel.setStrDisplayTotalShowBill(objGlobal.funIfNull(objBean.getStrDisplayTotalShowBill(), "N", "Y"));
			objModel.setStrUserWiseShowBill(objGlobal.funIfNull(objBean.getStrUserWiseShowBill(), "N", "Y"));
			objModel.setStrPostSalesDataToExcise(objGlobal.funIfNull(objBean.getStrPostSalesDataToExcise(), "N", "Y"));
			objModel.setStrShowNotificationsOnTransaction(objGlobal.funIfNull(objBean.getStrShowNotificationsOnTransaction(), "N", "Y"));
			objModel.setStrBillFooter(objBean.getStrBillFooter());
			objModel.setDblMaxDiscount(objBean.getDblMaxDiscount());
			objModel.setStrCheckDebitCardBalOnTransactions(objGlobal.funIfNull(objBean.getStrCheckDebitCardBalOnTransactions(), "N", "Y"));
			objModel.setStrPOSWiseItemToMMSProductLinkUpYN(objGlobal.funIfNull(objBean.getStrPOSWiseItemToMMSProductLinkUpYN(), "N", "Y"));
			objModel.setStrPropertyWiseSalesOrderYN(objGlobal.funIfNull(objBean.getStrPropertyWiseSalesOrderYN(), "N", "Y"));
			
			objModel.setStrMultipleBillPrinting(objGlobal.funIfNull(objBean.getStrMultipleBillPrinting(), "N", "Y"));
		
			objModel.setStrMultipleKOTPrintYN(objGlobal.funIfNull(objBean.getStrMultipleKOTPrintYN(), "N", "Y"));
			
			//changes mahesh
			objModel.setStrDirectAreaCode(objBean.getStrDineInAreaForDirectBiller());
			objModel.setStrHomeDeliveryAreaForDirectBiller(objBean.getStrHomeDeliveryAreaForDirectBiller());
			objModel.setStrTakeAwayAreaForDirectBiller(objBean.getStrTakeAwayAreaForDirectBiller());
			

			funSaveUpdatePropertySetup(objModel);

			if (objBean.getStrJioPOSIntegrationYN().equalsIgnoreCase("Y"))
			{
				if (!(objBean.getStrJioDeviceID().isEmpty()))
				{
					if (JioDeviceIDFound && ((!objBean.getStrJioDeviceID().equals(JioDeviceIDFromDB))))
					{
						funSaveMapMyDevice(objBean.getStrJioMID(), objBean.getStrJioTID(), objBean.getStrJioDeviceID(), objBean.getStrJioActivationCode(), objBean.getStrPosCode());
					}
					else if (!JioDeviceIDFound)
					{
						funSaveMapMyDevice(objBean.getStrJioMID(), objBean.getStrJioTID(), objBean.getStrJioDeviceID(), objBean.getStrJioActivationCode(), objBean.getStrPosCode());
					}

				}
			}

			List<clsPOSPrinterSetupBean> printerlist = objBean.getListPrinterDtl();
			if (null != printerlist)
			{
				String sql = "truncate table tblprintersetup";
				objBaseService.funExecuteUpdate(sql, "sql");
				for (int i = 0; i < printerlist.size(); i++)
				{
					clsPOSPrinterSetupBean obj = new clsPOSPrinterSetupBean();
					obj = (clsPOSPrinterSetupBean) printerlist.get(i);
					clsPrinterSetupHdModel objModelprint = new clsPrinterSetupHdModel(new clsPrinterSetupModel_ID(obj.getStrCostCenterCode(), clientCode));
					objModelprint.setStrCostCenterCode(obj.getStrCostCenterCode());
					objModelprint.setStrCostCenterName(obj.getStrCostCenterName());
					objModelprint.setStrPrimaryPrinterPort(obj.getStrPrimaryPrinterPort());
					if (obj.getStrPrintOnBothPrintersYN() != null)
						objModelprint.setStrPrintOnBothPrintersYN("Y");
					else
						objModelprint.setStrPrintOnBothPrintersYN("N");

					objModelprint.setStrSecondaryPrinterPort(obj.getStrSecondaryPrinterPort());
					objModelprint.setStrUserCreated(webStockUserCode);
					objModelprint.setStrUserEdited(webStockUserCode);
					objModelprint.setDteDateCreated(dateTime);
					objModelprint.setDteDateEdited(dateTime);

					objModelprint.setStrDataPostFlag("Y");

					objBaseService.funSave(objModelprint);
				}
			}

			List<clsPOSSMSSetupBean> smsList = objBean.getListSMSDtl();
			StringBuilder sql = new StringBuilder();
			sql.append("select * from tblsmssetup where strPOSCode='" + posCode + "' and strClientCode='" + clientCode + "' ");
			List listSMS = objBaseService.funGetList(sql, "sql");
			if (null != listSMS)
			{
				clsPOSSMSSetupModel objSmSModel = new clsPOSSMSSetupModel();
				for (int i = 0; i < listSMS.size(); i++)
				{
					clsPOSSMSSetupBean objsmsbean = new clsPOSSMSSetupBean();
					objsmsbean = (clsPOSSMSSetupBean) listSMS.get(i);
					// clsPOSSMSSetupModel objSmSModel = new
					// clsPOSSMSSetupModel();
					Object[] obj = (Object[]) listSMS.get(i);
					String transName = obj[1].toString();
					String sendSMSYN = obj[2].toString();
					switch (transName)
					{
					case "DayEnd":

						objSmSModel.setStrSendSMSYN(objGlobal.funIfNull(objsmsbean.getStrSendSMSYN(), "N", "Y"));
					case "VoidKOT":
						objSmSModel.setStrSendSMSYN(objGlobal.funIfNull(objsmsbean.getStrSendSMSYN(), "N", "Y"));
					case "NCKOT":
						objSmSModel.setStrSendSMSYN(objGlobal.funIfNull(objsmsbean.getStrSendSMSYN(), "N", "Y"));
					case "VoidAdvOrder":
						objSmSModel.setStrSendSMSYN(objGlobal.funIfNull(objsmsbean.getStrSendSMSYN(), "N", "Y"));
					case "VoidBill":
						objSmSModel.setStrSendSMSYN(objGlobal.funIfNull(objsmsbean.getStrSendSMSYN(), "N", "Y"));
					case "ModifyBill":
						objSmSModel.setStrSendSMSYN(objGlobal.funIfNull(objsmsbean.getStrSendSMSYN(), "N", "Y"));
					case "SettleBill":
						objSmSModel.setStrSendSMSYN(objGlobal.funIfNull(objsmsbean.getStrSendSMSYN(), "N", "Y"));
					case "ComplimentaryBill":
						objSmSModel.setStrSendSMSYN(objGlobal.funIfNull(objsmsbean.getStrSendSMSYN(), "N", "Y"));
					}

					objSmSModel.setLongMobileNo(objsmsbean.getLongMobileNo());
					objSmSModel.setStrUserCreated(webStockUserCode);
					objSmSModel.setStrUserEdited(webStockUserCode);
					objSmSModel.setStrTransactionName(objsmsbean.getStrTransactionName());
					objSmSModel.setStrDataPostFlag("Y");

					objBaseService.funSave(objSmSModel);

				}
			}

			/*
			 * List<clsPOSSMSSetupBean> listsms = objBean.getListSMSDtl(); if
			 * (null != listsms) { // DayEnd clsPOSSMSSetupBean objsms = new
			 * clsPOSSMSSetupBean();
			 * 
			 * String Mobile = objsms.getLongMobileNo(); String UserEdited =
			 * objsms.getStrUserEdited(); String DataPost =
			 * objsms.getStrDataPostFlag(); String dateEdited =
			 * objsms.getDteDateEdited(); String dataFlag =
			 * objsms.getStrDataPostFlag();
			 * 
			 * String DayEnd = objGlobal.funIfNull(objBean.getStrDayEndSMSYN(),
			 * "N", "Y");
			 * 
			 * String sqlDayEnd = "update tblsmssetup " + "set strSendSMSYN=" +
			 * DayEnd + ",longMobileNo=" + Mobile + ",dteDateEdited=" +
			 * dateEdited + ",strUserEdited=" + UserEdited +
			 * "where strPOSCode= " + posCode + " and strClientCode= " +
			 * clientCode; objBaseService.funExecuteUpdate(sqlDayEnd, "sql");
			 * 
			 * // VoidKOT String VoidKOT =
			 * objGlobal.funIfNull(objBean.getStrVoidKOTSMSYN(), "N", "Y");
			 * 
			 * String sqlVoidKOT = "update tblsmssetup " + "set strSendSMSYN=" +
			 * VoidKOT + ",longMobileNo=" + Mobile + ",dteDateEdited=" +
			 * dateEdited + ",strUserEdited=" + UserEdited +
			 * "where strPOSCode= " + posCode + " and strClientCode= " +
			 * clientCode; objBaseService.funExecuteUpdate(sqlDayEnd, "sql");
			 * 
			 * // NCKOT String NCKOT =
			 * objGlobal.funIfNull(objBean.getStrNCKOTSMSYN(), "N", "Y"); String
			 * sqlNCKOT = "update tblsmssetup " + "set strSendSMSYN=" + NCKOT +
			 * ",longMobileNo=" + Mobile + ",dteDateEdited=" + dateEdited +
			 * ",strUserEdited=" + UserEdited + "where strPOSCode= " + posCode +
			 * " and strClientCode= " + clientCode;
			 * objBaseService.funExecuteUpdate(sqlDayEnd, "sql");
			 * 
			 * // VoidAdvOrder String VoidAdvOrder =
			 * objGlobal.funIfNull(objBean.getStrVoidAdvOrderSMSYN(), "N", "Y");
			 * String sqlVoidAdvOrder = "update tblsmssetup " +
			 * "set strSendSMSYN=" + VoidAdvOrder + ",longMobileNo=" + Mobile +
			 * ",dteDateEdited=" + dateEdited + ",strUserEdited=" + UserEdited +
			 * "where strPOSCode= " + posCode + " and strClientCode= " +
			 * clientCode; objBaseService.funExecuteUpdate(sqlVoidAdvOrder,
			 * "sql");
			 * 
			 * // VoidBill String VoidBill =
			 * objGlobal.funIfNull(objBean.getStrVoidBill(), "N", "Y"); String
			 * sqlVoidBill = "update tblsmssetup " + "set strSendSMSYN=" +
			 * VoidBill + ",longMobileNo=" + Mobile + ",dteDateEdited=" +
			 * dateEdited + ",strUserEdited=" + UserEdited +
			 * "where strPOSCode= " + posCode + " and strClientCode= " +
			 * clientCode; objBaseService.funExecuteUpdate(sqlVoidBill, "sql");
			 * 
			 * // ModifyBill String ModifyBill =
			 * objGlobal.funIfNull(objBean.getStrModifyBill(), "N", "Y"); String
			 * sqlModifyBill = "update tblsmssetup " + "set strSendSMSYN=" +
			 * ModifyBill + ",longMobileNo=" + Mobile + ",dteDateEdited=" +
			 * dateEdited + ",strUserEdited=" + UserEdited +
			 * "where strPOSCode= " + posCode + " and strClientCode= " +
			 * clientCode; objBaseService.funExecuteUpdate(sqlModifyBill,
			 * "sql");
			 * 
			 * // SettleBill String SettleBill =
			 * objGlobal.funIfNull(objBean.getStrSettleBill(), "N", "Y"); String
			 * sqlSettleBill = "update tblsmssetup " + "set strSendSMSYN=" +
			 * SettleBill + ",longMobileNo=" + Mobile + ",dteDateEdited=" +
			 * dateEdited + ",strUserEdited=" + UserEdited +
			 * "where strPOSCode= " + posCode + " and strClientCode= " +
			 * clientCode; objBaseService.funExecuteUpdate(sqlSettleBill,
			 * "sql");
			 * 
			 * }
			 */

			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage", "Updated Successfully");
			return new ModelAndView("redirect:/frmPOSPropertySetup.html");
		}
		catch (Exception ex)
		{

			ex.printStackTrace();
			return new ModelAndView("redirect:/frmFail.html");
		}
	}

	public void funSaveUpdatePropertySetup(clsSetupHdModel objModel)
	{
		String newPropertyPOSCode = objModel.getStrPOSCode();
		String strHOPOSType = objModel.getStrPOSType();
		try
		{
			String sql = "select strClientCode from tblsetup where strPOSCode='All' ";
			List list = objBaseService.funGetList(new StringBuilder(sql), "sql");
			if (list.size() > 0)
			{
				objBaseService.funSave(objModel);
				if (!newPropertyPOSCode.equalsIgnoreCase("All"))
				{
					sql = "delete from tblsetup where strPOSCode='All' ";
					objBaseService.funExecuteUpdate(sql, "sql");
				}
			}
			else
			{
				objBaseService.funSave(objModel);
				if (newPropertyPOSCode.equalsIgnoreCase("All"))
				{
					sql = "delete from tblsetup where strPOSCode<>'All' ";
					objBaseService.funExecuteUpdate(sql, "sql");
				}
				if (strHOPOSType.equalsIgnoreCase("Client POS"))
				{
					funPostPropertySetupDataToHO();
					funPostBillSeriesDataHO();
				}
			}

		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
	}

	private void funPostPropertySetupDataToHO()
	{
		boolean flgResult = false;
		StringBuilder sql = new StringBuilder();
		clsSetupHdModel objSetupHdModel = new clsSetupHdModel();
		try
		{
			Map hmMainMap = new HashMap();
			List listData = new ArrayList<>();
			boolean flgAllPOS = false;
			sql.append("select strClientCode from tblsetup where strPOSCode='All' ");
			List list = objBaseService.funGetList(sql, "sql");
			if (list.size() > 0)
			{
				flgAllPOS = true;
			}
			sql.setLength(0);
			list = objBaseService.funLoadAllCriteriaWise(objSetupHdModel, "strDataPostFlag", "N");

			if (list.size() > 0)
			{
				for (int i = 0; i < list.size(); i++)
				{
					objSetupHdModel = (clsSetupHdModel) list.get(i);
					if (!objSetupHdModel.getStrWSClientCode().trim().isEmpty())
					{
						if (flgAllPOS)
						{
							sql.setLength(0);
							sql.append("select strPOSCode from tblposmaster ");

							List poslist = objBaseService.funGetList(sql, "sql");
							for (int j = 0; j < poslist.size(); j++)
							{
								Map hmData = new HashMap<>();

								hmData.put("strClientCode", objSetupHdModel.getStrClientCode());// clientCode
								hmData.put("strClientName", objSetupHdModel.getStrClientName());// clientName
								hmData.put("strAddressLine1", objSetupHdModel.getStrAddressLine1());
								hmData.put("strAddressLine2", objSetupHdModel.getStrAddressLine2());
								hmData.put("strAddressLine3", objSetupHdModel.getStrAddressLine3());
								hmData.put("strEmail", objSetupHdModel.getStrEmail());
								hmData.put("strBillFooter", objSetupHdModel.getStrBillFooter());
								hmData.put("strBillFooterStatus", objSetupHdModel.getStrBillFooterStatus());
								hmData.put("intBillPaperSize", objSetupHdModel.getIntBillPaperSize());
								hmData.put("strBillFormatType", objSetupHdModel.getStrBillFormatType());
								hmData.put("strNegativeBilling", objSetupHdModel.getStrNegativeBilling());
								hmData.put("strDayEnd", objSetupHdModel.getStrDayEnd());
								hmData.put("strPrintMode", objSetupHdModel.getStrPrintMode());
								hmData.put("strDiscountNote", objSetupHdModel.getStrDiscountNote());
								hmData.put("strCityName", objSetupHdModel.getStrCityName());
								hmData.put("strState", objSetupHdModel.getStrState());
								hmData.put("strCountry", objSetupHdModel.getStrCountry());
								hmData.put("intTelephoneNo", objSetupHdModel.getIntTelephoneNo());
								hmData.put("gMobileNoForSMS", objSetupHdModel.getIntTelephoneNo());
								hmData.put("dteStartDate", objSetupHdModel.getDteStartDate());
								hmData.put("dteEndDate", objSetupHdModel.getDteEndDate());
								hmData.put("gEndTime", objSetupHdModel.getDteEndDate());
								hmData.put("strNatureOfBusinnes", objSetupHdModel.getStrNatureOfBusinnes());
								hmData.put("strMultipleBillPrinting", objSetupHdModel.getStrMultipleBillPrinting());
								hmData.put("strEnableKOT", objSetupHdModel.getStrEnableKOT());
								hmData.put("strEffectOnPSP", objSetupHdModel.getStrEffectOnPSP());
								hmData.put("strPrintVatNo", objSetupHdModel.getStrPrintVatNo());
								hmData.put("strVatNo", objSetupHdModel.getStrVatNo());
								hmData.put("strShowBill", objSetupHdModel.getStrShowBill());
								hmData.put("strPrintServiceTaxNo", objSetupHdModel.getStrPrintServiceTaxNo());
								hmData.put("strServiceTaxNo", objSetupHdModel.getStrServiceTaxNo());
								hmData.put("strManualBillNo", objSetupHdModel.getStrManualBillNo());
								hmData.put("strMenuItemDispSeq", objSetupHdModel.getStrMenuItemDispSeq());
								hmData.put("strSenderEmailId", objSetupHdModel.getStrSenderEmailId());
								hmData.put("strEmailPassword", objSetupHdModel.getStrEmailPassword());
								hmData.put("strConfirmEmailPassword", objSetupHdModel.getStrConfirmEmailPassword());
								hmData.put("strBody", objSetupHdModel.getStrBody());
								hmData.put("strEmailServerName", objSetupHdModel.getStrEmailServerName());
								hmData.put("strSMSApi", objSetupHdModel.getStrSMSApi());
								hmData.put("strUserCreated", objSetupHdModel.getStrUserCreated());
								hmData.put("strUserEdited", objSetupHdModel.getStrUserEdited());
								hmData.put("dteDateCreated", objSetupHdModel.getDteDateCreated());
								hmData.put("dteDateEdited", objSetupHdModel.getDteDateEdited());
								hmData.put("strPOSType", objSetupHdModel.getStrPOSType());
								hmData.put("strWebServiceLink", objSetupHdModel.getStrWebServiceLink());
								hmData.put("strDataSendFrequency", objSetupHdModel.getStrDataSendFrequency());
								hmData.put("dteHOServerDate", objSetupHdModel.getDteHOServerDate());
								hmData.put("strRFID", objSetupHdModel.getStrRFID());
								hmData.put("strServerName", objSetupHdModel.getStrServerName());
								hmData.put("strDBUserName", objSetupHdModel.getStrDBUserName());
								hmData.put("strDBPassword", objSetupHdModel.getStrDBPassword());
								hmData.put("strDatabaseName", objSetupHdModel.getStrDatabaseName());
								hmData.put("strEnableKOTForDirectBiller", objSetupHdModel.getStrEnableKOTForDirectBiller());
								hmData.put("intPinCode", objSetupHdModel.getIntPinCode());
								hmData.put("strChangeTheme", objSetupHdModel.getStrChangeTheme());
								hmData.put("dblMaxDiscount", objSetupHdModel.getDblMaxDiscount());
								hmData.put("strAreaWisePricing", objSetupHdModel.getStrAreaWisePricing());
								hmData.put("strMenuItemSortingOn", objSetupHdModel.getStrMenuItemSortingOn());
								hmData.put("strDirectAreaCode", objSetupHdModel.getStrDirectAreaCode());
								hmData.put("intColumnSize", objSetupHdModel.getIntColumnSize());
								hmData.put("strPrintType", objSetupHdModel.getStrPrintType());
								hmData.put("strEditHomeDelivery", objSetupHdModel.getStrEditHomeDelivery());
								hmData.put("strSlabBasedHDCharges", objSetupHdModel.getStrSlabBasedHDCharges());
								hmData.put("strSkipWaiterAndPax", objSetupHdModel.getStrSkipWaiterAndPax());
								hmData.put("strSkipWaiter", objSetupHdModel.getStrSkipWaiter());
								hmData.put("strDirectKOTPrintMakeKOT", objSetupHdModel.getStrDirectKOTPrintMakeKOT());
								hmData.put("strSkipPax", objSetupHdModel.getStrSkipPax());
								hmData.put("strCRMInterface", objSetupHdModel.getStrCRMInterface());
								hmData.put("strGetWebserviceURL", objSetupHdModel.getStrGetWebserviceURL());
								hmData.put("strPostWebserviceURL", objSetupHdModel.getStrPostWebserviceURL());
								// hmData.put("gOutletUID",objSetupHdModel.getStrOutletUID());
								hmData.put("strPOSID", objSetupHdModel.getStrPOSID());
								hmData.put("strStockInOption", objSetupHdModel.getStrStockInOption());
								hmData.put("longCustSeries", objSetupHdModel.getLongCustSeries());
								hmData.put("intAdvReceiptPrintCount", objSetupHdModel.getIntAdvReceiptPrintCount());
								hmData.put("strHomeDeliverySMS", objSetupHdModel.getStrHomeDeliverySMS());
								hmData.put("strBillStettlementSMS", objSetupHdModel.getStrBillStettlementSMS());
								hmData.put("strActivePromotions", objSetupHdModel.getStrActivePromotions());
								hmData.put("strSendHomeDelSMS", objSetupHdModel.getStrSendHomeDelSMS());
								hmData.put("strSendBillSettlementSMS", objSetupHdModel.getStrSendBillSettlementSMS());
								hmData.put("strSMSType", objSetupHdModel.getStrSMSType());
								hmData.put("strPrintShortNameOnKOT", objSetupHdModel.getStrPrintShortNameOnKOT());
								hmData.put("strShowCustHelp", objSetupHdModel.getStrShowCustHelp());
								hmData.put("strPrintOnVoidBill", objSetupHdModel.getStrPrintOnVoidBill());
								hmData.put("strPostSalesDataToMMS", objSetupHdModel.getStrPostSalesDataToMMS());
								hmData.put("strCustAreaMasterCompulsory", objSetupHdModel.getStrCustAreaMasterCompulsory());
								hmData.put("strPriceFrom", objSetupHdModel.getStrPriceFrom());
								hmData.put("strShowPrinterErrorMessage", objSetupHdModel.getStrShowPrinterErrorMessage());
								hmData.put("strTouchScreenMode", objSetupHdModel.getStrTouchScreenMode());
								hmData.put("strCardInterfaceType", objSetupHdModel.getStrCardInterfaceType());
								hmData.put("strCMSIntegrationYN", objSetupHdModel.getStrCMSIntegrationYN());
								hmData.put("strCMSWebServiceURL", objSetupHdModel.getStrCMSWebServiceURL());
								hmData.put("strChangeQtyForExternalCode", objSetupHdModel.getStrChangeQtyForExternalCode());
								hmData.put("strPointsOnBillPrint", objSetupHdModel.getStrPointsOnBillPrint());
								hmData.put("strCMSPOSCode", objSetupHdModel.getStrCMSPOSCode());
								hmData.put("strManualAdvOrderNoCompulsory", objSetupHdModel.getStrManualAdvOrderNoCompulsory());
								hmData.put("strPrintManualAdvOrderNoOnBill", objSetupHdModel.getStrPrintManualAdvOrderNoOnBill());
								hmData.put("strPrintModifierQtyOnKOT", objSetupHdModel.getStrPrintModifierQtyOnKOT());
								hmData.put("strNoOfLinesInKOTPrint", objSetupHdModel.getStrNoOfLinesInKOTPrint());
								hmData.put("strMultipleKOTPrintYN", objSetupHdModel.getStrMultipleKOTPrintYN());
								hmData.put("strItemQtyNumpad", objSetupHdModel.getStrItemQtyNumpad());
								hmData.put("strTreatMemberAsTable", objSetupHdModel.getStrTreatMemberAsTable());
								hmData.put("strKOTToLocalPrinter", objSetupHdModel.getStrKOTToLocalPrinter());
								hmData.put("strSettleBtnForDirectBillerBill", objSetupHdModel.getStrSettleBtnForDirectBillerBill());
								hmData.put("strDelBoySelCompulsoryOnDirectBiller", objSetupHdModel.getStrDelBoySelCompulsoryOnDirectBiller());
								hmData.put("strCMSMemberForKOTJPOS", objSetupHdModel.getStrCMSMemberForKOTJPOS());
								hmData.put("strCMSMemberForKOTMPOS", objSetupHdModel.getStrCMSMemberForKOTMPOS());
								hmData.put("strDontShowAdvOrderInOtherPOS", objSetupHdModel.getStrDontShowAdvOrderInOtherPOS());
								hmData.put("strPrintZeroAmtModifierInBill", objSetupHdModel.getStrPrintZeroAmtModifierInBill());
								hmData.put("strPrintKOTYN", objSetupHdModel.getStrPrintKOTYN());
								hmData.put("strCreditCardSlipNoCompulsoryYN", objSetupHdModel.getStrCreditCardSlipNoCompulsoryYN());
								hmData.put("strCreditCardExpiryDateCompulsoryYN", objSetupHdModel.getStrCreditCardExpiryDateCompulsoryYN());
								hmData.put("strSelectWaiterFromCardSwipe", objSetupHdModel.getStrSelectWaiterFromCardSwipe());
								hmData.put("strMultiWaiterSelectionOnMakeKOT", objSetupHdModel.getStrMultiWaiterSelectionOnMakeKOT());
								hmData.put("strMoveTableToOtherPOS", objSetupHdModel.getStrMoveTableToOtherPOS());
								hmData.put("strMoveKOTToOtherPOS", objSetupHdModel.getStrMoveKOTToOtherPOS());
								hmData.put("strCalculateTaxOnMakeKOT", objSetupHdModel.getStrCalculateTaxOnMakeKOT());
								hmData.put("strReceiverEmailId", objSetupHdModel.getStrReceiverEmailId());
								hmData.put("strCalculateDiscItemWise", objSetupHdModel.getStrCalculateDiscItemWise());
								hmData.put("strTakewayCustomerSelection", objSetupHdModel.getStrTakewayCustomerSelection());
								hmData.put("StrShowItemStkColumnInDB", objSetupHdModel.getStrShowItemStkColumnInDB());
								hmData.put("strItemType", objSetupHdModel.getStrItemType());
								hmData.put("strAllowNewAreaMasterFromCustMaster", objSetupHdModel.getStrAllowNewAreaMasterFromCustMaster());
								hmData.put("strCustAddressSelectionForBill", objSetupHdModel.getStrCustAddressSelectionForBill());
								hmData.put("strGenrateMI", objSetupHdModel.getStrGenrateMI());
								hmData.put("strFTPAddress", objSetupHdModel.getStrFTPAddress());
								hmData.put("strFTPServerUserName", objSetupHdModel.getStrFTPServerUserName());
								hmData.put("strFTPServerPass", objSetupHdModel.getStrFTPServerPass());
								hmData.put("strAllowToCalculateItemWeight", objSetupHdModel.getStrAllowToCalculateItemWeight());
								hmData.put("strShowBillsDtlType", objSetupHdModel.getStrShowBillsDtlType());
								hmData.put("strPrintTaxInvoiceOnBill", objSetupHdModel.getStrPrintTaxInvoiceOnBill());
								hmData.put("strPrintInclusiveOfAllTaxesOnBill", objSetupHdModel.getStrPrintInclusiveOfAllTaxesOnBill());
								hmData.put("strApplyDiscountOn", objSetupHdModel.getStrApplyDiscountOn());
								hmData.put("strMemberCodeForKotInMposByCardSwipe", objSetupHdModel.getStrMemberCodeForKotInMposByCardSwipe());
								hmData.put("strPrintBillYN", objSetupHdModel.getStrPrintBillYN());
								hmData.put("strVatAndServiceTaxFromPos", objSetupHdModel.getStrVatAndServiceTaxFromPos());
								hmData.put("strMemberCodeForMakeBillInMPOS", objSetupHdModel.getStrMemberCodeForMakeBillInMPOS());
								hmData.put("strItemWiseKOTYN", objSetupHdModel.getStrItemWiseKOTYN());
								hmData.put("strLastPOSForDayEnd", objSetupHdModel.getStrLastPOSForDayEnd());
								hmData.put("strCMSPostingType", objSetupHdModel.getStrCMSPostingType());
								hmData.put("strPopUpToApplyPromotionsOnBill", objSetupHdModel.getStrPopUpToApplyPromotionsOnBill());
								hmData.put("strSelectCustomerCodeFromCardSwipe", objSetupHdModel.getStrSelectCustomerCodeFromCardSwipe());
								hmData.put("strCheckDebitCardBalOnTransactions", objSetupHdModel.getStrCheckDebitCardBalOnTransactions());
								hmData.put("strSettlementsFromPOSMaster", objSetupHdModel.getStrSettlementsFromPOSMaster());
								hmData.put("strShiftWiseDayEndYN", objSetupHdModel.getStrShiftWiseDayEndYN());
								hmData.put("strProductionLinkup", objSetupHdModel.getStrProductionLinkup());
								hmData.put("strLockDataOnShift", objSetupHdModel.getStrLockDataOnShift());
								hmData.put("strWSClientCode", objSetupHdModel.getStrWSClientCode());
								hmData.put("strPOSCode", objSetupHdModel.getStrPOSCode());
								hmData.put("strEnableBillSeries", objSetupHdModel.getStrEnableBillSeries());
								hmData.put("strEnablePMSIntegrationYN", objSetupHdModel.getStrEnablePMSIntegrationYN());
								hmData.put("strPrintTimeOnBill", objSetupHdModel.getStrPrintTimeOnBill());
								hmData.put("strPrintTDHItemsInBill", objSetupHdModel.getStrPrintTDHItemsInBill());
								hmData.put("strPrintRemarkAndReasonForReprint", objSetupHdModel.getStrPrintRemarkAndReasonForReprint());

								hmData.put("intDaysBeforeOrderToCancel", objSetupHdModel.getIntDaysBeforeOrderToCancel());
								hmData.put("intNoOfDelDaysForAdvOrder", objSetupHdModel.getIntNoOfDelDaysForAdvOrder());
								hmData.put("intNoOfDelDaysForUrgentOrder", objSetupHdModel.getIntNoOfDelDaysForUrgentOrder());
								hmData.put("strSetUpToTimeForAdvOrder", objSetupHdModel.getStrSetUpToTimeForAdvOrder());
								hmData.put("strSetUpToTimeForUrgentOrder", objSetupHdModel.getStrSetUpToTimeForUrgentOrder());
								hmData.put("strUpToTimeForAdvOrder", objSetupHdModel.getStrUpToTimeForAdvOrder());
								hmData.put("strUpToTimeForUrgentOrder", objSetupHdModel.getStrUpToTimeForUrgentOrder());
								hmData.put("strEnableBothPrintAndSettleBtnForDB", objSetupHdModel.getStrEnableBothPrintAndSettleBtnForDB());
								hmData.put("strInrestoPOSIntegrationYN", objSetupHdModel.getStrInrestoPOSIntegrationYN());
								hmData.put("strInrestoPOSWebServiceURL", objSetupHdModel.getStrInrestoPOSWebServiceURL());
								hmData.put("strInrestoPOSId", objSetupHdModel.getStrInrestoPOSId());
								hmData.put("strInrestoPOSKey", objSetupHdModel.getStrInrestoPOSKey());
								hmData.put("strCarryForwardFloatAmtToNextDay", objSetupHdModel.getStrCarryForwardFloatAmtToNextDay());
								hmData.put("strOpenCashDrawerAfterBillPrintYN", objSetupHdModel.getStrOpenCashDrawerAfterBillPrintYN());
								hmData.put("strPropertyWiseSalesOrderYN", objSetupHdModel.getStrPropertyWiseSalesOrderYN());
								hmData.put("strDataPostFlag", objSetupHdModel.getStrDataPostFlag());
								hmData.put("strShowItemDetailsGrid", objSetupHdModel.getStrShowItemDetailsGrid());

								hmData.put("strShowPopUpForNextItemQuantity", objSetupHdModel.getStrShowPopUpForNextItemQuantity());

								hmData.put("strJioMoneyIntegration", objSetupHdModel.getStrJioMoneyIntegration());
								hmData.put("strJioWebServiceUrl", objSetupHdModel.getStrJioWebServiceUrl());

								hmData.put("strJioMID", objSetupHdModel.getStrJioMID());

								hmData.put("strJioTID", objSetupHdModel.getStrJioTID());

								hmData.put("strJioActivationCode", objSetupHdModel.getStrJioActivationCode());
								hmData.put("strJioDeviceID", objSetupHdModel.getStrJioDeviceID());
								hmData.put("strNewBillSeriesForNewDay", objSetupHdModel.getStrNewBillSeriesForNewDay());
								hmData.put("strShowReportsPOSWise", objSetupHdModel.getStrShowReportsPOSWise());

								hmData.put("strEnableDineIn", objSetupHdModel.getStrEnableDineIn());
								hmData.put("strAutoAreaSelectionInMakeKOT", objSetupHdModel.getStrAutoAreaSelectionInMakeKOT());

								hmData.put("strJioMID", objSetupHdModel.getStrJioMID());
								hmData.put("strJioTID", objSetupHdModel.getStrJioTID());

								hmData.put("strJioActivationCode", objSetupHdModel.getStrJioActivationCode());
								hmData.put("strJioDeviceID", objSetupHdModel.getStrJioDeviceID());
								hmData.put("strNewBillSeriesForNewDay", objSetupHdModel.getStrNewBillSeriesForNewDay());
								hmData.put("strShowReportsPOSWise", objSetupHdModel.getStrShowReportsPOSWise());

								hmData.put("strEnableDineIn", objSetupHdModel.getStrEnableDineIn());
								hmData.put("strAutoAreaSelectionInMakeKOT", objSetupHdModel.getStrAutoAreaSelectionInMakeKOT());
								hmData.put("strConsolidatedKOTPrinterPort", objSetupHdModel.getStrConsolidatedKOTPrinterPort());
								hmData.put("strWERAAuthenticationAPIKey", objSetupHdModel.getStrWERAAuthenticationAPIKey());
								hmData.put("strAreaWiseCostCenterKOTPrintingYN", objSetupHdModel.getStrAreaWiseCostCenterKOTPrintingYN());
								hmData.put("strPrintOriginalOnBill", objSetupHdModel.getStrPrintOriginalOnBill());
								hmData.put("strCheckDebitCardBalOnTransactions", objSetupHdModel.getStrCheckDebitCardBalOnTransactions());
							
								hmData.put("strUserWiseShowBill", objSetupHdModel.getStrUserWiseShowBill());

								listData.add(hmData);
							}
						}
						else
						{
							Map hmData = new HashMap();

							hmData.put("strClientCode", objSetupHdModel.getStrClientCode());// clientCode
							hmData.put("strClientName", objSetupHdModel.getStrClientName());// clientName
							hmData.put("strAddressLine1", objSetupHdModel.getStrAddressLine1());
							hmData.put("strAddressLine2", objSetupHdModel.getStrAddressLine2());
							hmData.put("strAddressLine3", objSetupHdModel.getStrAddressLine3());
							hmData.put("strEmail", objSetupHdModel.getStrEmail());
							hmData.put("strBillFooter", objSetupHdModel.getStrBillFooter());
							hmData.put("strBillFooterStatus", objSetupHdModel.getStrBillFooterStatus());
							hmData.put("intBillPaperSize", objSetupHdModel.getIntBillPaperSize());
							hmData.put("strBillFormatType", objSetupHdModel.getStrBillFormatType());

							hmData.put("strNegativeBilling", objSetupHdModel.getStrNegativeBilling());
							hmData.put("strDayEnd", objSetupHdModel.getStrDayEnd());
							hmData.put("strPrintMode", objSetupHdModel.getStrPrintMode());
							hmData.put("strDiscountNote", objSetupHdModel.getStrDiscountNote());
							hmData.put("strCityName", objSetupHdModel.getStrCityName());
							hmData.put("strState", objSetupHdModel.getStrState());
							hmData.put("strCountry", objSetupHdModel.getStrCountry());
							hmData.put("intTelephoneNo", objSetupHdModel.getIntTelephoneNo());
							hmData.put("gMobileNoForSMS", objSetupHdModel.getIntTelephoneNo());
							hmData.put("dteStartDate", objSetupHdModel.getDteStartDate());
							hmData.put("dteEndDate", objSetupHdModel.getDteEndDate());
							hmData.put("gEndTime", objSetupHdModel.getDteEndDate());
							hmData.put("strNatureOfBusinnes", objSetupHdModel.getStrNatureOfBusinnes());
							hmData.put("strMultipleBillPrinting", objSetupHdModel.getStrMultipleBillPrinting());
							hmData.put("strEnableKOT", objSetupHdModel.getStrEnableKOT());
							hmData.put("strEffectOnPSP", objSetupHdModel.getStrEffectOnPSP());
							hmData.put("strPrintVatNo", objSetupHdModel.getStrPrintVatNo());
							hmData.put("strVatNo", objSetupHdModel.getStrVatNo());
							hmData.put("strShowBill", objSetupHdModel.getStrShowBill());
							hmData.put("strPrintServiceTaxNo", objSetupHdModel.getStrPrintServiceTaxNo());
							hmData.put("strServiceTaxNo", objSetupHdModel.getStrServiceTaxNo());
							hmData.put("strManualBillNo", objSetupHdModel.getStrManualBillNo());
							hmData.put("strMenuItemDispSeq", objSetupHdModel.getStrMenuItemDispSeq());
							hmData.put("strSenderEmailId", objSetupHdModel.getStrSenderEmailId());
							hmData.put("strEmailPassword", objSetupHdModel.getStrEmailPassword());
							hmData.put("strConfirmEmailPassword", objSetupHdModel.getStrConfirmEmailPassword());
							hmData.put("strBody", objSetupHdModel.getStrBody());
							hmData.put("strEmailServerName", objSetupHdModel.getStrEmailServerName());
							hmData.put("strSMSApi", objSetupHdModel.getStrSMSApi());
							hmData.put("strUserCreated", objSetupHdModel.getStrUserCreated());
							hmData.put("strUserEdited", objSetupHdModel.getStrUserEdited());
							hmData.put("dteDateCreated", objSetupHdModel.getDteDateCreated());
							hmData.put("dteDateEdited", objSetupHdModel.getDteDateEdited());
							hmData.put("strPOSType", objSetupHdModel.getStrPOSType());
							hmData.put("strWebServiceLink", objSetupHdModel.getStrWebServiceLink());
							hmData.put("strDataSendFrequency", objSetupHdModel.getStrDataSendFrequency());
							hmData.put("dteHOServerDate", objSetupHdModel.getDteHOServerDate());
							hmData.put("strRFID", objSetupHdModel.getStrRFID());
							hmData.put("strServerName", objSetupHdModel.getStrServerName());
							hmData.put("strDBUserName", objSetupHdModel.getStrDBUserName());
							hmData.put("strDBPassword", objSetupHdModel.getStrDBPassword());
							hmData.put("strDatabaseName", objSetupHdModel.getStrDatabaseName());
							hmData.put("strEnableKOTForDirectBiller", objSetupHdModel.getStrEnableKOTForDirectBiller());
							hmData.put("intPinCode", objSetupHdModel.getIntPinCode());
							hmData.put("strChangeTheme", objSetupHdModel.getStrChangeTheme());
							hmData.put("dblMaxDiscount", objSetupHdModel.getDblMaxDiscount());
							hmData.put("strAreaWisePricing", objSetupHdModel.getStrAreaWisePricing());
							hmData.put("strMenuItemSortingOn", objSetupHdModel.getStrMenuItemSortingOn());
							hmData.put("strDirectAreaCode", objSetupHdModel.getStrDirectAreaCode());
							hmData.put("intColumnSize", objSetupHdModel.getIntColumnSize());
							hmData.put("strPrintType", objSetupHdModel.getStrPrintType());
							hmData.put("strEditHomeDelivery", objSetupHdModel.getStrEditHomeDelivery());
							hmData.put("strSlabBasedHDCharges", objSetupHdModel.getStrSlabBasedHDCharges());
							hmData.put("strSkipWaiterAndPax", objSetupHdModel.getStrSkipWaiterAndPax());
							hmData.put("strSkipWaiter", objSetupHdModel.getStrSkipWaiter());
							hmData.put("strDirectKOTPrintMakeKOT", objSetupHdModel.getStrDirectKOTPrintMakeKOT());
							hmData.put("strSkipPax", objSetupHdModel.getStrSkipPax());
							hmData.put("strCRMInterface", objSetupHdModel.getStrCRMInterface());
							hmData.put("strGetWebserviceURL", objSetupHdModel.getStrGetWebserviceURL());
							hmData.put("strPostWebserviceURL", objSetupHdModel.getStrPostWebserviceURL());
							hmData.put("strOutletUID", objSetupHdModel.getStrOutletUID());
							hmData.put("strPOSID", objSetupHdModel.getStrPOSID());
							hmData.put("strStockInOption", objSetupHdModel.getStrStockInOption());
							hmData.put("longCustSeries", objSetupHdModel.getLongCustSeries());
							hmData.put("intAdvReceiptPrintCount", objSetupHdModel.getIntAdvReceiptPrintCount());
							hmData.put("strHomeDeliverySMS", objSetupHdModel.getStrHomeDeliverySMS());
							hmData.put("strBillStettlementSMS", objSetupHdModel.getStrBillStettlementSMS());
							hmData.put("strActivePromotions", objSetupHdModel.getStrActivePromotions());
							hmData.put("strSendHomeDelSMS", objSetupHdModel.getStrSendHomeDelSMS());
							hmData.put("strSendBillSettlementSMS", objSetupHdModel.getStrSendBillSettlementSMS());
							hmData.put("strSMSType", objSetupHdModel.getStrSMSType());
							hmData.put("strPrintShortNameOnKOT", objSetupHdModel.getStrPrintShortNameOnKOT());
							hmData.put("strShowCustHelp", objSetupHdModel.getStrShowCustHelp());
							hmData.put("strPrintOnVoidBill", objSetupHdModel.getStrPrintOnVoidBill());
							hmData.put("strPostSalesDataToMMS", objSetupHdModel.getStrPostSalesDataToMMS());
							hmData.put("strCustAreaMasterCompulsory", objSetupHdModel.getStrCustAreaMasterCompulsory());
							hmData.put("strPriceFrom", objSetupHdModel.getStrPriceFrom());
							hmData.put("strShowPrinterErrorMessage", objSetupHdModel.getStrShowPrinterErrorMessage());
							hmData.put("strTouchScreenMode", objSetupHdModel.getStrTouchScreenMode());
							hmData.put("strCardInterfaceType", objSetupHdModel.getStrCardInterfaceType());
							hmData.put("strCMSIntegrationYN", objSetupHdModel.getStrCMSIntegrationYN());
							hmData.put("strCMSWebServiceURL", objSetupHdModel.getStrCMSWebServiceURL());
							hmData.put("strChangeQtyForExternalCode", objSetupHdModel.getStrChangeQtyForExternalCode());
							hmData.put("strPointsOnBillPrint", objSetupHdModel.getStrPointsOnBillPrint());
							hmData.put("strCMSPOSCode", objSetupHdModel.getStrCMSPOSCode());
							hmData.put("strManualAdvOrderNoCompulsory", objSetupHdModel.getStrManualAdvOrderNoCompulsory());
							hmData.put("strPrintManualAdvOrderNoOnBill", objSetupHdModel.getStrPrintManualAdvOrderNoOnBill());
							hmData.put("strPrintModifierQtyOnKOT", objSetupHdModel.getStrPrintModifierQtyOnKOT());
							hmData.put("strNoOfLinesInKOTPrint", objSetupHdModel.getStrNoOfLinesInKOTPrint());
							hmData.put("strMultipleKOTPrintYN", objSetupHdModel.getStrMultipleKOTPrintYN());
							hmData.put("strItemQtyNumpad", objSetupHdModel.getStrItemQtyNumpad());
							hmData.put("strTreatMemberAsTable", objSetupHdModel.getStrTreatMemberAsTable());
							hmData.put("strKOTToLocalPrinter", objSetupHdModel.getStrKOTToLocalPrinter());
							hmData.put("strSettleBtnForDirectBillerBill", objSetupHdModel.getStrSettleBtnForDirectBillerBill());
							hmData.put("strDelBoySelCompulsoryOnDirectBiller", objSetupHdModel.getStrDelBoySelCompulsoryOnDirectBiller());
							hmData.put("strCMSMemberForKOTJPOS", objSetupHdModel.getStrCMSMemberForKOTJPOS());
							hmData.put("strCMSMemberForKOTMPOS", objSetupHdModel.getStrCMSMemberForKOTMPOS());
							hmData.put("strDontShowAdvOrderInOtherPOS", objSetupHdModel.getStrDontShowAdvOrderInOtherPOS());
							hmData.put("strPrintZeroAmtModifierInBill", objSetupHdModel.getStrPrintZeroAmtModifierInBill());
							hmData.put("strPrintKOTYN", objSetupHdModel.getStrPrintKOTYN());
							hmData.put("strCreditCardSlipNoCompulsoryYN", objSetupHdModel.getStrCreditCardSlipNoCompulsoryYN());
							hmData.put("strCreditCardExpiryDateCompulsoryYN", objSetupHdModel.getStrCreditCardExpiryDateCompulsoryYN());
							hmData.put("strSelectWaiterFromCardSwipe", objSetupHdModel.getStrSelectWaiterFromCardSwipe());
							hmData.put("strMultiWaiterSelectionOnMakeKOT", objSetupHdModel.getStrMultiWaiterSelectionOnMakeKOT());
							hmData.put("strMoveTableToOtherPOS", objSetupHdModel.getStrMoveTableToOtherPOS());
							hmData.put("strMoveKOTToOtherPOS", objSetupHdModel.getStrMoveKOTToOtherPOS());
							hmData.put("strCalculateTaxOnMakeKOT", objSetupHdModel.getStrCalculateTaxOnMakeKOT());
							hmData.put("strReceiverEmailId", objSetupHdModel.getStrReceiverEmailId());
							hmData.put("strCalculateDiscItemWise", objSetupHdModel.getStrCalculateDiscItemWise());
							hmData.put("strTakewayCustomerSelection", objSetupHdModel.getStrTakewayCustomerSelection());
							hmData.put("StrShowItemStkColumnInDB", objSetupHdModel.getStrShowItemStkColumnInDB());
							hmData.put("strItemType", objSetupHdModel.getStrItemType());
							hmData.put("strAllowNewAreaMasterFromCustMaster", objSetupHdModel.getStrAllowNewAreaMasterFromCustMaster());
							hmData.put("strCustAddressSelectionForBill", objSetupHdModel.getStrCustAddressSelectionForBill());
							hmData.put("strGenrateMI", objSetupHdModel.getStrGenrateMI());
							hmData.put("strFTPAddress", objSetupHdModel.getStrFTPAddress());
							hmData.put("strFTPServerUserName", objSetupHdModel.getStrFTPServerUserName());
							hmData.put("strFTPServerPass", objSetupHdModel.getStrFTPServerPass());
							hmData.put("strAllowToCalculateItemWeight", objSetupHdModel.getStrAllowToCalculateItemWeight());
							hmData.put("strShowBillsDtlType", objSetupHdModel.getStrShowBillsDtlType());
							hmData.put("strPrintTaxInvoiceOnBill", objSetupHdModel.getStrPrintTaxInvoiceOnBill());
							hmData.put("strPrintInclusiveOfAllTaxesOnBill", objSetupHdModel.getStrPrintInclusiveOfAllTaxesOnBill());
							hmData.put("strApplyDiscountOn", objSetupHdModel.getStrApplyDiscountOn());
							hmData.put("strMemberCodeForKotInMposByCardSwipe", objSetupHdModel.getStrMemberCodeForKotInMposByCardSwipe());
							hmData.put("strPrintBillYN", objSetupHdModel.getStrPrintBillYN());
							hmData.put("strVatAndServiceTaxFromPos", objSetupHdModel.getStrVatAndServiceTaxFromPos());
							hmData.put("strMemberCodeForMakeBillInMPOS", objSetupHdModel.getStrMemberCodeForMakeBillInMPOS());
							hmData.put("strItemWiseKOTYN", objSetupHdModel.getStrItemWiseKOTYN());
							hmData.put("strLastPOSForDayEnd", objSetupHdModel.getStrLastPOSForDayEnd());
							hmData.put("strCMSPostingType", objSetupHdModel.getStrCMSPostingType());
							hmData.put("strPopUpToApplyPromotionsOnBill", objSetupHdModel.getStrPopUpToApplyPromotionsOnBill());
							hmData.put("strSelectCustomerCodeFromCardSwipe", objSetupHdModel.getStrSelectCustomerCodeFromCardSwipe());
							hmData.put("strCheckDebitCardBalOnTransactions", objSetupHdModel.getStrCheckDebitCardBalOnTransactions());
							hmData.put("strSettlementsFromPOSMaster", objSetupHdModel.getStrSettlementsFromPOSMaster());
							hmData.put("strShiftWiseDayEndYN", objSetupHdModel.getStrShiftWiseDayEndYN());
							hmData.put("strProductionLinkup", objSetupHdModel.getStrProductionLinkup());
							hmData.put("strLockDataOnShift", objSetupHdModel.getStrLockDataOnShift());
							hmData.put("strWSClientCode", objSetupHdModel.getStrWSClientCode());
							hmData.put("strPOSCode", objSetupHdModel.getStrPOSCode());
							hmData.put("strEnableBillSeries", objSetupHdModel.getStrEnableBillSeries());
							hmData.put("strEnablePMSIntegrationYN", objSetupHdModel.getStrEnablePMSIntegrationYN());
							hmData.put("strPrintTimeOnBill", objSetupHdModel.getStrPrintTimeOnBill());
							hmData.put("strPrintTDHItemsInBill", objSetupHdModel.getStrPrintTDHItemsInBill());
							hmData.put("strPrintRemarkAndReasonForReprint", objSetupHdModel.getStrPrintRemarkAndReasonForReprint());

							hmData.put("intDaysBeforeOrderToCancel", objSetupHdModel.getIntDaysBeforeOrderToCancel());
							hmData.put("intNoOfDelDaysForAdvOrder", objSetupHdModel.getIntNoOfDelDaysForAdvOrder());
							hmData.put("intNoOfDelDaysForUrgentOrder", objSetupHdModel.getIntNoOfDelDaysForUrgentOrder());
							hmData.put("strSetUpToTimeForAdvOrder", objSetupHdModel.getStrSetUpToTimeForAdvOrder());
							hmData.put("strSetUpToTimeForUrgentOrder", objSetupHdModel.getStrSetUpToTimeForUrgentOrder());
							hmData.put("strUpToTimeForAdvOrder", objSetupHdModel.getStrUpToTimeForAdvOrder());
							hmData.put("strUpToTimeForUrgentOrder", objSetupHdModel.getStrUpToTimeForUrgentOrder());
							hmData.put("strEnableBothPrintAndSettleBtnForDB", objSetupHdModel.getStrEnableBothPrintAndSettleBtnForDB());
							hmData.put("strInrestoPOSIntegrationYN", objSetupHdModel.getStrInrestoPOSIntegrationYN());
							hmData.put("strInrestoPOSWebServiceURL", objSetupHdModel.getStrInrestoPOSWebServiceURL());
							hmData.put("strInrestoPOSId", objSetupHdModel.getStrInrestoPOSId());
							hmData.put("strInrestoPOSKey", objSetupHdModel.getStrInrestoPOSKey());
							hmData.put("strCarryForwardFloatAmtToNextDay", objSetupHdModel.getStrCarryForwardFloatAmtToNextDay());
							hmData.put("strOpenCashDrawerAfterBillPrintYN", objSetupHdModel.getStrOpenCashDrawerAfterBillPrintYN());
							hmData.put("strPropertyWiseSalesOrderYN", objSetupHdModel.getStrPropertyWiseSalesOrderYN());
							hmData.put("strDataPostFlag", objSetupHdModel.getStrDataPostFlag());
							hmData.put("strShowItemDetailsGrid", objSetupHdModel.getStrShowItemDetailsGrid());

							hmData.put("strShowPopUpForNextItemQuantity", objSetupHdModel.getStrShowPopUpForNextItemQuantity());

							hmData.put("strJioMoneyIntegration", objSetupHdModel.getStrJioMoneyIntegration());
							hmData.put("strJioWebServiceUrl", objSetupHdModel.getStrJioWebServiceUrl());

							hmData.put("strJioMID", objSetupHdModel.getStrJioMID());

							hmData.put("strJioTID", objSetupHdModel.getStrJioTID());

							hmData.put("strJioActivationCode", objSetupHdModel.getStrJioActivationCode());
							hmData.put("strJioDeviceID", objSetupHdModel.getStrJioDeviceID());
							hmData.put("strNewBillSeriesForNewDay", objSetupHdModel.getStrNewBillSeriesForNewDay());
							hmData.put("strShowReportsPOSWise", objSetupHdModel.getStrShowReportsPOSWise());

							hmData.put("strEnableDineIn", objSetupHdModel.getStrEnableDineIn());
							hmData.put("strAutoAreaSelectionInMakeKOT", objSetupHdModel.getStrAutoAreaSelectionInMakeKOT());
							hmData.put("strConsolidatedKOTPrinterPort", objSetupHdModel.getStrConsolidatedKOTPrinterPort());
							hmData.put("strWERAAuthenticationAPIKey", objSetupHdModel.getStrWERAAuthenticationAPIKey());
							hmData.put("strWERAMerchantOutletId", objSetupHdModel.getStrWERAMerchantOutletId());
							hmData.put("strAreaWiseCostCenterKOTPrintingYN", objSetupHdModel.getStrAreaWiseCostCenterKOTPrintingYN());
							hmData.put("strPrintOriginalOnBill", objSetupHdModel.getStrPrintOriginalOnBill());
							hmData.put("strCheckDebitCardBalOnTransactions", objSetupHdModel.getStrCheckDebitCardBalOnTransactions());

							listData.add(hmData);

						}
					}
				}
			}
			hmMainMap.put("tblsetup", listData);
			funPOSTDataToHO(hmMainMap);
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
	}

	private void funPostBillSeriesDataHO()
	{
		boolean flgResult = false;
		StringBuilder sql = new StringBuilder();

		try
		{
			Map hmMainMap = new HashMap();
			List listData = new ArrayList();

			sql.append("select * from tblbillseries where strDataPostFlag='N'");

			List list = objBaseService.funGetList(sql, "sql");
			for (int j = 0; j < list.size(); j++)
			{
				Object[] obj = (Object[]) list.get(j);
				Map hmObject = new HashMap();
				hmObject.put("POSCode", obj[0].toString());
				hmObject.put("Type", obj[1].toString());
				hmObject.put("BillSeries", obj[2].toString());
				hmObject.put("LastNo", obj[3].toString());
				hmObject.put("Codes", obj[4].toString());
				hmObject.put("Names", obj[5].toString());
				hmObject.put("UserCreated", obj[6].toString());
				hmObject.put("UserEdited", obj[7].toString());
				hmObject.put("DateCreated", obj[8].toString());
				hmObject.put("DateEdited", obj[9].toString());
				hmObject.put("DataPostFlag", obj[10].toString());
				hmObject.put("ClientCode", obj[11].toString());
				hmObject.put("PropertyCode", obj[12].toString());
				hmObject.put("PrintGTOfOtherBills", obj[13].toString());
				hmObject.put("PrintIncOfTaxOnBill", obj[14].toString());

				listData.add(hmObject);
			}

			hmMainMap.put("tblbillseries", listData);
			funPOSTDataToHO(hmMainMap);
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}

	}

	public void funPOSTDataToHO(Map hmData)
	{
		String posURL = clsPOSGlobalFunctionsController.POSWSURL + "/POSIntegration/funPostPropertySetup";
		try
		{

			URL url = new URL(posURL);

			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setDoOutput(true);
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Content-Type", "application/json");
			OutputStream os = conn.getOutputStream();
			os.write(hmData.toString().getBytes());
			os.flush();
			if (conn.getResponseCode() != HttpURLConnection.HTTP_CREATED)
			{
				throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());
			}
			BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));
			String output = "", op = "";

			while ((output = br.readLine()) != null)
			{
				op += output;
			}
			System.out.println("Result= " + op);
			conn.disconnect();
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}

	}

	@RequestMapping(value = "/fetchDeviceID", method = RequestMethod.GET)
	public @ResponseBody Map funFetchDeviceID(HttpServletRequest req)
	{
		String IP = "localhost", PORT = "5150";
		objPOSGlobal.funStartSocketBat();
		Map hmData = new HashMap();
		try
		{
			String host = IP; // IP address of the server
			int port = Integer.parseInt(PORT); // Port on which the socket is
												// going to connect
			String response = "";
			StringBuilder Res = new StringBuilder();
			String SendData = "getDongleId"; // getDongleId
			System.out.println("Request String:" + SendData);
			try (Socket s = new Socket(host, port))
			// Creating socket class
			{
				DataOutputStream dout = new DataOutputStream(s.getOutputStream()); // creating
																					// outputstream
																					// to
																					// send
																					// data
																					// to
																					// server
				DataInputStream din = new DataInputStream(s.getInputStream()); // creating
																				// inputstream
																				// to
																				// receive
																				// data
																				// from
																				// server
				// BufferedReader br = new BufferedReader(new
				// InputStreamReader(System.in));
				byte[] str = SendData.getBytes("UTF-8");
				dout.write(str, 0, str.length);
				// System.out.println("Send data value = "+ SendData);
				dout.flush(); // Flush the streams

				byte[] bs = new byte[10024];
				din.read(bs);
				char c;
				for (byte b : bs)
				{
					c = (char) b;
					response = Res.append("").append(c).toString();
				}
				System.out.println("Device ID: " + response);
				dout.close(); // Closing the output stream
				din.close(); // Closing the input stream
			} // creating outputstream to send data to server
			hmData.put("deviceID", response.trim());
			return hmData;
		}
		catch (Exception e)
		{
			System.out.println("Exception:" + e);
			return hmData;
		}
	}

	public void funSaveMapMyDevice(String mid, String tid, String deviceId, String strJioMoneyActivationCode, String posCode)
	{

		objPOSGlobal.funStartSocketBat();
		try
		{

			String RequestType = "1008";
			String Amount = "0.00";

			String manufacturer = "JioPayDevice";// JioPayDevice
			String deviceStatus = "A";
			String linkDate = getCurrentDate();
			String deLinkDate = deLinkedDate();
			String superMerchantId = mid;
			String userName = "9820001759";
			String businessLegalName = "Sanguine Software";

			String requestData = "requestType=" + RequestType + "&mid=" + mid + "&deviceId=" + deviceId + "&manufacturer=" + manufacturer + "&deviceStatus=" + deviceStatus + "&linkDate=" + linkDate + "&deLinkDate=" + deLinkDate + "&superMerchantId=" + superMerchantId + "&userName=" + userName + "&businessLegalName=" + businessLegalName + "&tid=" + tid;

			System.out.println("RequestData : " + requestData);
			String Response = "";
			Response = objPOSGlobal.funMakeTransaction(requestData, RequestType, mid, tid, Amount, "PRE_PROD", "localhost", "5150", posCode, strJioMoneyActivationCode);
			System.out.println(Response);

			/*
			 * String strRes = Response.trim(); JSONParser jsonParser = new
			 * JSONParser(); JSONObject jsonObject = (JSONObject)
			 * jsonParser.parse(strRes); JSONArray lang= (JSONArray)
			 * jsonObject.get("result"); JSONParser jsonParser1 = new
			 * JSONParser(); JSONObject jsonObject1 = (JSONObject)
			 * jsonParser1.parse(lang.get(0).toString()); responseCode= (String)
			 * jsonObject1.get("messageCode");
			 */

		}
		catch (Exception e)
		{
			System.out.println("Exception:" + e);
		}
	}

	public String getCurrentDate()
	{
		Date currentDate = new Date();
		String strCurrentDate = (currentDate.getDate() + "/" + (currentDate.getMonth() + 1) + "/" + (currentDate.getYear() + 1900));
		return strCurrentDate;
	}

	public String deLinkedDate()
	{
		String currentDate = getCurrentDate();
		String[] date1 = currentDate.split("/");
		int year = 30 + Integer.parseInt(date1[2]);
		String nextDate = (date1[0] + "/" + date1[1] + "/" + String.valueOf(year));
		return nextDate;
	}

	public Map funLoadAreaList(String posCode)
	{
		Map mapArea = new TreeMap();
		try
		{
			StringBuilder sqlBuilder = new StringBuilder();
			sqlBuilder.append("select * from tblareamaster where (strPOSCode='" + posCode + "' or strPOSCode='All' )");
			List listSql = objBaseService.funGetList(sqlBuilder, "sql");
			if (listSql.size() > 0)
			{
				for (int j = 0; j < listSql.size(); j++)
				{
					Object obj = (Object) listSql.get(j);
					mapArea.put(Array.get(obj, 0).toString(), Array.get(obj, 1).toString());
				}
			}
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
		}
		return mapArea;
	}

	public Map funLoadTaxList()
	{

		Map mapTax = new TreeMap();

		try
		{
			StringBuilder sqlBuilder = new StringBuilder();
			sqlBuilder.append("select a.strTaxCode,a.strTaxDesc from tbltaxhd a");
			List listSql = objBaseService.funGetList(sqlBuilder, "sql");
			if (listSql.size() > 0)
			{
				for (int j = 0; j < listSql.size(); j++)
				{
					Object obj = (Object) listSql.get(j);
					mapTax.put(Array.get(obj, 0).toString(), Array.get(obj, 1).toString());
				}
			}
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
		}
		return mapTax;
	}

	@RequestMapping(value = "/testPrinterStatus", method = RequestMethod.GET)
	public @ResponseBody Map funTestPrinterStatus(@RequestParam("PrinterName") String printerName, HttpServletRequest req) throws Exception
	{
		String posCode = req.getSession().getAttribute("loginPOS").toString();
		String userCode = req.getSession().getAttribute("gUserCode").toString();
		String status = obUtilityController.funTestPrint(printerName, userCode, posCode);
		Map hmStatus = new HashMap();
		hmStatus.put("Status", status);
		return hmStatus;
	}

	@RequestMapping(value = "/testSendSMS", method = RequestMethod.GET)
	public @ResponseBody Map funTestSendSMSStatus(@RequestParam("testMobileNo") String testMobileNumber, HttpServletRequest req) throws Exception
	{
		String posCode = req.getSession().getAttribute("loginPOS").toString();
		String clientCode = req.getSession().getAttribute("gClientCode").toString();
		String status = obUtilityController.funSendTestSMS(testMobileNumber, "Test SMS", clientCode, posCode);
		Map hmStatus = new HashMap();
		hmStatus.put("Status", status);
		return hmStatus;
	}

	@RequestMapping(value = "/testSendEmail", method = RequestMethod.GET)
	public @ResponseBody Map funTestSendEmailStatus(@RequestParam("receiverEmailId") String receiverEmailId, @RequestParam("senderEmailId") String senderEmailId, @RequestParam("emailPassword") String emailPassword, @RequestParam("confirmedPassword") String confirmedPassword, @RequestParam("mailBody") String mailBody, HttpServletRequest req) throws Exception
	{
		String posCode = req.getSession().getAttribute("loginPOS").toString();
		String clientCode = req.getSession().getAttribute("gClientCode").toString();
		String status = obUtilityController.funTestEmailSetup(receiverEmailId, senderEmailId, emailPassword, confirmedPassword, mailBody);
		Map hmStatus = new HashMap();
		hmStatus.put("Status", status);
		return hmStatus;
	}

	// Pratiksha
	@RequestMapping(value = "/testWebServiceConnection", method = RequestMethod.GET)
	public @ResponseBody Map funTestWebServiceConnectionStatus(@RequestParam("webServiceURL") String webServiceURL, HttpServletRequest req) throws Exception
	{
		String posCode = req.getSession().getAttribute("loginPOS").toString();
		String clientCode = req.getSession().getAttribute("gClientCode").toString();
		String status = obUtilityController.funTestWebServiceConnectionSetup(webServiceURL);
		Map hmStatus = new HashMap();
		hmStatus.put("Status", status);
		return hmStatus;
	}

}
