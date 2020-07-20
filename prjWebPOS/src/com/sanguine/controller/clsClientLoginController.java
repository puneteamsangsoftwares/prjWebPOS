package com.sanguine.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.ModelAndView;

import com.POSLicence.controller.clsClientDetails;
import com.POSLicence.controller.clsEncryptDecryptClientCode;
import com.sanguine.base.service.intfBaseService;
import com.sanguine.bean.clsClientBean;
import com.sanguine.bean.clsUserHdBean;
import com.sanguine.model.clsCompanyMasterModel;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.service.clsSetupMasterService;
import com.sanguine.service.clsUserMasterService;
import com.sanguine.util.clsUserDesktopUtil;
import com.sanguine.webpos.model.clsSetupHdModel;
import com.sanguine.webpos.sevice.clsPOSMainMenuService;
import com.sanguine.webpos.sevice.clsPOSMasterService;

@Controller
@SessionAttributes("userdetails")
public class clsClientLoginController
{

	final static Logger logger = Logger.getLogger(clsUserController.class);
	private String strModule = "1";

	@Autowired
	private clsSetupMasterService objSetupMasterService;
	@Autowired
	private intfBaseService objBaseService;
	@Autowired
	private clsGlobalFunctions objGlobalFun;
	@Autowired
	clsPOSMasterService objMasterService;
	@Autowired
	clsPOSMainMenuService objMainMenuService;
	
	
	@Value("${applicationType}")
	String applicationType;

	@RequestMapping(value = "/validateClient", method = RequestMethod.POST)
	public ModelAndView login(HttpServletRequest req, @Valid clsClientBean objClientBean, BindingResult result, ModelMap map)
	{
		ModelAndView objMV = null;
		try
		{
			if (result.hasErrors())
			{
				map.put("invalid", "1");
				objMV = new ModelAndView("frmClientLogin", "command", new clsClientBean());
			}
			else
			{
				if (objClientBean != null)
				{
					if (objClientBean.getStrClientCode() != null && objClientBean.getStrClientCode().trim().length() > 0 && objClientBean.getStrPassword() != null && objClientBean.getStrPassword().trim().length() > 0)
					{
						String clientCodeFromDB = "";
						String clientPasswordFromDB = "";
						StringBuilder sbSql1 = new StringBuilder();
						sbSql1.append("select a.strClientCode,a.strEmailPassword,a.strPOSCode from tblsetup a where a.strEmail='"+objClientBean.getStrClientCode()+"'");
						/*List list1 = objBaseService.funGetList(sbSql1, "sql");
						if(list1!=null && list1.size()>0)
						{
							Object[] arr = (Object[]) list1.get(0);
							clientCodeFromDB = arr[0].toString();
							clientPasswordFromDB = arr[1].toString();
						}*/

						String encryptedClientCodeFromDB = clsEncryptDecryptClientCode.funEncryptClientCode(clientCodeFromDB);
						String encryptedClientPasswordFromDB = clsEncryptDecryptClientCode.funEncryptClientCode(clientPasswordFromDB);

						clsClientDetails.funAddClientCodeAndName();

						/*String decryptedClientCodeFromHm = clsEncryptDecryptClientCode.funDecryptClientCode(clsClientDetails.hmClientDtl.get(encryptedClientCodeFromDB).getId());
						String decryptedClientNameFromHm = clsEncryptDecryptClientCode.funDecryptClientCode(clsClientDetails.hmClientDtl.get(encryptedClientCodeFromDB).Client_Name);
						String decryptedClientPasswordFromHm = clsEncryptDecryptClientCode.funDecryptClientCode(clsClientDetails.hmClientDtl.get(encryptedClientCodeFromDB).getStrClientPassword());
*/
						SimpleDateFormat dFormat = new SimpleDateFormat("yyyy-MM-dd");

						Date systemDate = dFormat.parse(dFormat.format(new Date()));

						/*String encryptedExpDate = clsClientDetails.hmClientDtl.get(encryptedClientCodeFromDB).expiryDate;
						String decryptedExpDate = clsEncryptDecryptClientCode.funDecryptClientCode(encryptedExpDate);
						*/
/*						String encryptedPOSVersion=clsClientDetails.hmClientDtl.get(encryptedClientCodeFromDB).getPosVersion();
*/						String gPOSVerion = clsEncryptDecryptClientCode.funDecryptClientCode("1");
						req.getSession().setAttribute("gPOSVerion",gPOSVerion);
						clsSetupHdModel objSetupHdModel=null;
						String POSCode1 = "All";
						objSetupHdModel=objMasterService.funGetPOSWisePropertySetup(clientCodeFromDB,POSCode1);
						clientCodeFromDB="240.001";
						Date posExpiryDate = dFormat.parse("2021-01-01");
						if (systemDate.compareTo(posExpiryDate) <= 0)
						{
							if(true)
							//if (clientCodeFromDB.equalsIgnoreCase(objSetupHdModel.getStrClientCode()) && objClientBean.getStrPassword().equalsIgnoreCase(objSetupHdModel.getStrEmailPassword()))
							{
								req.getSession().setAttribute("gClientCode",clientCodeFromDB);
								//req.getSession().setAttribute("gCompanyName",objSetupHdModel.getStrClientName());								
								//req.getSession().setAttribute("gPOSCode",objSetupHdModel.getStrPOSCode());	
								req.getSession().setAttribute("gPOSCode","All");	
								req.getSession().setAttribute("gCompanyName","THOUSAND OAKS");	
								//req.getSession().setAttribute("gStartDate", startDate);
								
								StringBuilder sbSql = new StringBuilder();
								sbSql.append("select a.strUserCode from tbluserhd a where a.strClientCode='"+clientCodeFromDB+"'");
								List list = objBaseService.funGetList(sbSql, "sql");
								if(list!=null && list.size()>0)
								{
									Map<String, String> moduleMap = new TreeMap<String, String>();
									moduleMap.put("7-WebPOS", "webpos_module_icon.png");

									req.getSession().setAttribute("moduleNo", strModule);
									req.getSession().setAttribute("moduleMap", moduleMap);

									return new ModelAndView("frmLogin", "command", new clsUserHdBean());
								}
								else
								{
									Map<String, Object> model = new HashMap<String, Object>();
									clsUserHdBean user = new clsUserHdBean();
									
									user.setStrUserCode("Sanguine");
									user.setStrSuperUser("super");
									model.put("users", user);
									req.getSession().setAttribute("gUserCode",user.getStrUserCode());
									req.getSession().setAttribute("gUserType",user.getStrSuperUser());
									req.getSession().setAttribute("gSuperUser",user.getStrSuperUser());
									req.getSession().setAttribute("gPOSDate",objGlobalFun.funGetCurrentDate("dd-MM-yyyy"));
									req.getSession().setAttribute("loginPOS",POSCode1);

									req.getSession().setAttribute("gUserName",user.getStrUserCode().toUpperCase());
									String dayEndDate=	objGlobalFun.funGetCurrentDate("yyyy-MM-dd");
									req.getSession().setAttribute("dayEndDate",dayEndDate);
									
									String posModule = "M";
									String userCode=req.getSession().getAttribute("gUserCode").toString();
									String userType = req.getSession().getAttribute("gUserType").toString();
									JSONArray jArr = new JSONArray();

									if(objSetupHdModel!=null)
									{
										req.getSession().setAttribute("gCompanyName",objSetupHdModel.getStrClientName());		

									}
									String posCode = "All";
									List<clsUserDesktopUtil> webPOSDesktop=null;
									webPOSDesktop = funGetPOSMenuMap(userCode, clientCodeFromDB, posModule, userType, posCode);
									HashMap hmPendingForms=funGetAllPendingForms();
									for(clsUserDesktopUtil obj :webPOSDesktop)
									{
										
										if(!(hmPendingForms.containsKey(obj.getStrFormName()))) {
											
											JSONObject jobj = new JSONObject();
											jobj.put("formName", obj.getStrFormName());
											jobj.put("strFormName", obj.getStrFormName());
											jobj.put("strFormDesc", obj.getStrFormDesc());
											jobj.put("strImgName", obj.getStrImgName()+".png");
											jobj.put("strRequestMapping", obj.getStrRequestMapping());
											jobj.put("strShortName",obj.getStrShortName());
											jArr.add(jobj);
											
										}
									
										
									}
									req.getSession().setAttribute("gPOSCode", posCode);
									req.getSession().setAttribute("gPOSName", posCode);
									req.getSession().setAttribute("gModule", posModule);
									req.getSession().setAttribute("gClientCode", clientCodeFromDB);
															
									req.getSession().setAttribute("formSerachlist",jArr);
									req.getSession().setAttribute("desktop",webPOSDesktop);
									return new ModelAndView("frmWebPOSMainMenu");
								}
								
							}
							else
							{
								map.put("invalid", "1");
								objMV = new ModelAndView("frmClientLogin", "command", new clsClientBean());
							}

						}
						else
						{
							map.put("LicenceExpired", "1");
							objMV = new ModelAndView("frmClientLogin", "command", new clsClientBean());
						}
					}
					else
					{
						map.put("invalid", "1");
						objMV = new ModelAndView("frmClientLogin", "command", new clsClientBean());
					}
				}
				else
				{
					map.put("invalid", "1");
					objMV = new ModelAndView("frmClientLogin", "command", new clsClientBean());
				}
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
			logger.error(e.getMessage());
			map.put("invalid", "1");
			objMV = new ModelAndView("frmClientLogin", "command", new clsClientBean());
		}
		return objMV;
	}
	private List<clsUserDesktopUtil> funGetPOSMenuMap(String userCode,String clientCode,String moduleType,String superUser,String POSCode) throws Exception 
	{
		boolean superUserYN=false;
		if(superUser.equalsIgnoreCase("Super"))
		{
			superUserYN=true;
		}
		
		clsSetupHdModel objSetupHdModel=objMasterService.funGetPOSWisePropertySetup(clientCode,POSCode);
		if(null!=objSetupHdModel)
		{/*
			clsPOSGlobalFunctionsController.hmPOSSetupValues.put("gClientCode",objSetupHdModel.getStrClientCode());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("ClientName",objSetupHdModel.getStrClientName());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("ClientAddressLine1",objSetupHdModel.getStrAddressLine1());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("ClientAddressLine2",objSetupHdModel.getStrAddressLine2());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("ClientAddressLine3",objSetupHdModel.getStrAddressLine3());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("Email",objSetupHdModel.getStrEmail());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("BillFooter",objSetupHdModel.getStrBillFooter());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("BillFooterStatus",objSetupHdModel.getStrBillFooterStatus());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("BillPaperSize",objSetupHdModel.getIntBillPaperSize());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("NegativeBilling",objSetupHdModel.getStrNegativeBilling());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("DayEnd",objSetupHdModel.getStrDayEnd());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("PrintMode",objSetupHdModel.getStrPrintMode());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("DiscountNote",objSetupHdModel.getStrDiscountNote());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("CityName",objSetupHdModel.getStrCityName());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("State",objSetupHdModel.getStrState());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("Country",objSetupHdModel.getStrCountry());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("TelephoneNo",objSetupHdModel.getIntTelephoneNo());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("StartDate",objSetupHdModel.getStrState());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("EndDate",objSetupHdModel.getDteEndDate());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("NatureOfBusinnes",objSetupHdModel.getStrNatureOfBusinnes());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("MultipleBillPrinting",objSetupHdModel.getStrMultipleBillPrinting());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("EnableKOT",objSetupHdModel.getStrEnableKOT());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("PrintVatNo",objSetupHdModel.getStrPrintVatNo());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("VatNo",objSetupHdModel.getStrVatNo());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("ShowBill",objSetupHdModel.getStrShowBill());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("PrintServiceTaxNo",objSetupHdModel.getStrPrintServiceTaxNo());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("ServiceTaxNo",objSetupHdModel.getStrServiceTaxNo());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("ManualBillNo",objSetupHdModel.getStrManualBillNo());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("MenuItemDispSeq",objSetupHdModel.getStrMenuItemDispSeq());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("SenderEmailId",objSetupHdModel.getStrSenderEmailId());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("EmailPassword",objSetupHdModel.getStrEmailPassword());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("ConfirmEmailPassword",objSetupHdModel.getStrConfirmEmailPassword());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("Body",objSetupHdModel.getStrBody());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("EmailServerName",objSetupHdModel.getStrEmailServerName());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("SMSApi",objSetupHdModel.getStrSMSApi());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("UserCreated",objSetupHdModel.getStrUserCreated());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("UserEdited",objSetupHdModel.getStrUserEdited());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("ManualBillNo",objSetupHdModel.getStrManualBillNo());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("DateCreated",objSetupHdModel.getDteDateCreated());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("DateEdited",objSetupHdModel.getDteDateEdited());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("POSType",objSetupHdModel.getStrPOSType());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("WebServiceLink",objSetupHdModel.getStrWebServiceLink());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("DataSendFrequency",objSetupHdModel.getStrDataSendFrequency());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("HOServerDate",objSetupHdModel.getDteHOServerDate());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("RFID",objSetupHdModel.getStrRFID());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("ServerName",objSetupHdModel.getStrServerName());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("DBUserName",objSetupHdModel.getStrDBUserName());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("DBPassword",objSetupHdModel.getStrDBPassword());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("DatabaseName",objSetupHdModel.getStrDatabaseName());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("EnableKOTForDirectBiller",objSetupHdModel.getStrEnableKOTForDirectBiller());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("PinCode",objSetupHdModel.getIntPinCode());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("ChangeTheme",objSetupHdModel.getStrChangeTheme());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("MaxDiscount",objSetupHdModel.getDblMaxDiscount());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("AreaWisePricing",objSetupHdModel.getStrAreaWisePricing());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("MenuItemSortingOn",objSetupHdModel.getStrMenuItemSortingOn());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("DirectBillerAreaCode",objSetupHdModel.getStrDirectAreaCode());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("ColumnSize",objSetupHdModel.getIntColumnSize());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("PrintType",objSetupHdModel.getStrPrintType());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("EditHomeDelivery",objSetupHdModel.getStrEditHomeDelivery());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("SlabBasedHDCharges",objSetupHdModel.getStrSlabBasedHDCharges());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("SkipWaiterAndPax",objSetupHdModel.getStrSkipWaiterAndPax());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("SkipWaiter",objSetupHdModel.getStrSkipWaiter());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("DirectKOTPrintMakeKOT",objSetupHdModel.getStrDirectKOTPrintMakeKOT());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("SkipPax",objSetupHdModel.getStrSkipPax());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("CRMInterface",objSetupHdModel.getStrCRMInterface());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("GetWebserviceURL",objSetupHdModel.getStrGetWebserviceURL());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("PostWebserviceURL",objSetupHdModel.getStrPostWebserviceURL());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("OutletUID",objSetupHdModel.getStrOutletUID());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("POSID",objSetupHdModel.getStrPOSID());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("StockInOption",objSetupHdModel.getStrStockInOption());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("CustSeries",objSetupHdModel.getLongCustSeries());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("AdvReceiptPrintCount",objSetupHdModel.getIntAdvReceiptPrintCount());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("HomeDeliverySMS",objSetupHdModel.getStrHomeDeliverySMS());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("BillSettlementSMS",objSetupHdModel.getStrBillStettlementSMS());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("BillFormatType",objSetupHdModel.getStrBillFormatType());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("ActivePromotions",objSetupHdModel.getStrActivePromotions());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("SendHomeDelSMS",objSetupHdModel.getStrSendHomeDelSMS());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("SendBillSettlementSMS",objSetupHdModel.getStrSendBillSettlementSMS());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("SMSType",objSetupHdModel.getStrSMSType());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("PrintShortNameOnKOT",objSetupHdModel.getStrPrintShortNameOnKOT());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("ShowCustHelp",objSetupHdModel.getStrShowCustHelp());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("PrintOnVoidBill",objSetupHdModel.getStrPrintOnVoidBill());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("PostSalesDataToMMS",objSetupHdModel.getStrPostSalesDataToMMS());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("CustAreaMasterCompulsory",objSetupHdModel.getStrCustAreaMasterCompulsory());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("PriceFrom",objSetupHdModel.getStrPriceFrom());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("ShowPrinterErrorMessage",objSetupHdModel.getStrShowPrinterErrorMessage());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("TouchScreenMode",objSetupHdModel.getStrTouchScreenMode());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("CardInterfaceType",objSetupHdModel.getStrCardInterfaceType());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("CMSIntegrationYN",objSetupHdModel.getStrCMSIntegrationYN());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("CMSWebServiceURL",objSetupHdModel.getStrCMSWebServiceURL());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("ChangeQtyForExternalCode",objSetupHdModel.getStrChangeQtyForExternalCode());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("PointsOnBillPrint",objSetupHdModel.getStrPointsOnBillPrint());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("CMSPOSCode",objSetupHdModel.getStrCMSPOSCode());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("ManualAdvOrderNoCompulsory",objSetupHdModel.getStrManualAdvOrderNoCompulsory());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("PrintManualAdvOrderNoOnBill",objSetupHdModel.getStrPrintManualAdvOrderNoOnBill());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("PrintModifierQtyOnKOT",objSetupHdModel.getStrPrintModifierQtyOnKOT());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("NoOfLinesInKOTPrint",objSetupHdModel.getStrNoOfLinesInKOTPrint());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("MultipleKOTPrintYN",objSetupHdModel.getStrMultipleKOTPrintYN());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("ItemQtyNumpad",objSetupHdModel.getStrItemQtyNumpad());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("TreatMemberAsTable",objSetupHdModel.getStrTreatMemberAsTable());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("KOTToLocalPrinter",objSetupHdModel.getStrKOTToLocalPrinter());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("SettleBtnForDirectBillerBill",objSetupHdModel.getStrSettleBtnForDirectBillerBill());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("DelBoySelCompulsoryOnDirectBiller",objSetupHdModel.getStrDelBoySelCompulsoryOnDirectBiller());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("CMSMemberForKOTJPOS",objSetupHdModel.getStrCMSMemberForKOTJPOS());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("CMSMemberForKOTMPOS",objSetupHdModel.getStrCMSMemberForKOTMPOS());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("DontShowAdvOrderInOtherPOS",objSetupHdModel.getStrDontShowAdvOrderInOtherPOS());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("PrintZeroAmtModifierInBill",objSetupHdModel.getStrPrintZeroAmtModifierInBill());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("PrintKOTYN",objSetupHdModel.getStrPrintKOTYN());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("CreditCardSlipNoCompulsoryYN",objSetupHdModel.getStrCreditCardSlipNoCompulsoryYN());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("CreditCardExpiryDateCompulsoryYN",objSetupHdModel.getStrCreditCardExpiryDateCompulsoryYN());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("SelectWaiterFromCardSwipe",objSetupHdModel.getStrSelectWaiterFromCardSwipe());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("MultiWaiterSelectionOnMakeKOT",objSetupHdModel.getStrMultiWaiterSelectionOnMakeKOT());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("MoveTableToOtherPOS",objSetupHdModel.getStrMoveTableToOtherPOS());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("MoveKOTToOtherPOS",objSetupHdModel.getStrMoveKOTToOtherPOS());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("CalculateTaxOnMakeKOT",objSetupHdModel.getStrCalculateTaxOnMakeKOT());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("ReceiverEmailId",objSetupHdModel.getStrReceiverEmailId());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("CalculateDiscItemWise",objSetupHdModel.getStrCalculateDiscItemWise());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("TakewayCustomerSelection",objSetupHdModel.getStrTakewayCustomerSelection());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("ShowItemStkColumnInDB",objSetupHdModel.getStrShowItemStkColumnInDB());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("ItemType",objSetupHdModel.getStrItemType());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("AllowNewAreaMasterFromCustMaster",objSetupHdModel.getStrAllowNewAreaMasterFromCustMaster());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("CustAddressSelectionForBill",objSetupHdModel.getStrCustAddressSelectionForBill());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("MemberCodeForKotInMposByCardSwipe",objSetupHdModel.getStrMemberCodeForKotInMposByCardSwipe());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("PrintBillPopUp","Y");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("UseVatAndServiceTaxNoFromPOS","N");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("MemberCodeForMakeBillInMPOS","N");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("ItemWiseKOTPrintYN","N");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("LastPOSForDayEnd","P01");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("CMSPostingType","");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("PopUpToApplyPromotionsOnBill","Y");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strSelectCustomerCodeFromCardSwipe","N");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strCheckDebitCardBalOnTransactions","N");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strSettlementsFromPOSMaster","N");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strShiftWiseDayEndYN","N");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strProductionLinkup","N");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strLockDataOnShift","N");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strWSClientCode","");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strPOSCode","P01");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strEnableBillSeries",objSetupHdModel.getStrEnableBillSeries());
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("EnablePMSIntegrationYN","N");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strPrintTimeOnBill","Y");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strPrintTDHItemsInBill","N");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strPrintRemarkAndReasonForReprint","Y");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("intDaysBeforeOrderToCancel","1");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("intNoOfDelDaysForAdvOrder","1");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("intNoOfDelDaysForUrgentOrder","1");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strSetUpToTimeForAdvOrder","N");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strSetUpToTimeForUrgentOrder","N");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strUpToTimeForAdvOrder","N");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strUpToTimeForUrgentOrder","N");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strEnableBothPrintAndSettleBtnForDB","N");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strInrestoPOSIntegrationYN","N");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strInrestoPOSWebServiceURL","");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strInrestoPOSId","");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strInrestoPOSKey","");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strCarryForwardFloatAmtToNextDay","N");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strOpenCashDrawerAfterBillPrintYN","N");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strPropertyWiseSalesOrderYN","N");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strShowItemDetailsGrid","N");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strShowPopUpForNextItemQuantity","N");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strJioMoneyIntegration","N");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strJioWebServiceUrl","");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strJioMID","");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strJioTID","");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strJioActivationCode","");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strJioDeviceID","");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strNewBillSeriesForNewDay","N");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strShowReportsPOSWise","N");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strEnableDineIn","N");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strAutoAreaSelectionInMakeKOT","N");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("strConsolidatedKOTPrinterPort","");
	    	clsPOSGlobalFunctionsController.hmPOSSetupValues.put("dblNoOfDecimalPlace",objSetupHdModel.getDblNoOfDecimalPlace());
	    	
		*/}
		
		
		List listMainMenuForms=objMainMenuService.funGetMainMenuForms(moduleType, superUserYN, POSCode, userCode, clientCode,"");
		List<clsUserDesktopUtil> listMenu=new  ArrayList<clsUserDesktopUtil>();
		
		if(null!=listMainMenuForms)
		{	
		    for(int cnt=0;cnt<listMainMenuForms.size();cnt++)
		    {
		    	Object[] arrObjMainMenuList=(Object[])listMainMenuForms.get(cnt);
		    	clsUserDesktopUtil obTreeRootItem=new clsUserDesktopUtil();
		    	
		    	obTreeRootItem.setStrFormName(arrObjMainMenuList[2].toString());
		    	obTreeRootItem.setStrRequestMapping(arrObjMainMenuList[3].toString());
		    	obTreeRootItem.setStrImgName(arrObjMainMenuList[1].toString());
		    	obTreeRootItem.setStrFormDesc(arrObjMainMenuList[0].toString());
		    	obTreeRootItem.setStrShortName(arrObjMainMenuList[4].toString());
		    	listMenu.add(obTreeRootItem);
		    }
		}
	    
		return listMenu;
	}
	
	private HashMap funGetAllPendingForms() 
	{
		HashMap<Object, Object> hmPendingForms=new HashMap<>();
		
		
		hmPendingForms.put("frmAdvanceOrderTypeMaster","frmAdvanceOrderTypeMaster");
		hmPendingForms.put("frmLoyaltyPointMaster","frmLoyaltyPointMaster");
		hmPendingForms.put("frmBulkMenuItemPricing","frmBulkMenuItemPricing");
		//hmPendingForms.put("frmCounterMaster","frmCounterMaster");
		hmPendingForms.put("frmDebitCardMaster","frmDebitCardMaster");
		hmPendingForms.put("frmGiftVoucherMaster","frmGiftVoucherMaster");
		//hmPendingForms.put("frmModifierGroupMaster","frmModifierGroupMaster");
		//hmPendingForms.put("frmPromationMaster","frmPromationMaster");
		hmPendingForms.put("frmRecipeMaster","frmRecipeMaster");
		//hmPendingForms.put("frmDebitCardMaster","frmDebitCardMaster");
		hmPendingForms.put("frmReOrderTime","frmReOrderTime");
		hmPendingForms.put("frmTDH","frmTDH");
		//hmPendingForms.put("frmZoneMaster","frmZoneMaster");
		hmPendingForms.put("frmUserCardSwipe","frmUserCardSwipe");
		//hmPendingForms.put("frmOrderMaster","frmOrderMaster");
		hmPendingForms.put("frmCharactersticsMaster","frmCharactersticsMaster");
		//hmPendingForms.put("frmFactoryMaster","frmFactoryMaster");
		hmPendingForms.put("frmLinkupMaster","frmLinkupMaster");
		hmPendingForms.put("frmTallyLinkupMaster","frmTallyLinkupMaster");
		hmPendingForms.put("frmPromotionGroupMaster","frmPromotionGroupMaster");
		hmPendingForms.put("frmSupplierMaster","frmSupplierMaster");
		hmPendingForms.put("frmUomMaster","frmUomMaster");
		hmPendingForms.put("frmPaymentInterfaceMaster","frmPaymentInterfaceMaster");
		hmPendingForms.put("frmPlayZonePricingMaster","frmPlayZonePricingMaster");
		hmPendingForms.put("frmAdvanceBooking","frmAdvanceBooking");
		hmPendingForms.put("frmAssignHomeDelivery","frmAssignHomeDelivery");
		hmPendingForms.put("frmAvdBookReceipt","frmAvdBookReceipt");
		hmPendingForms.put("frmBillFromKOTs","frmBillFromKOTs");
		hmPendingForms.put("frmCloseProductionOrder","frmCloseProductionOrder");
		hmPendingForms.put("frmGiftVoucherIssue","frmGiftVoucherIssue");
		hmPendingForms.put("frmKitchenDisplaySystem","frmKitchenDisplaySystem");
		hmPendingForms.put("frmMultiCostCenterKDS","frmMultiCostCenterKDS");
		hmPendingForms.put("frmPhysicalStkPosting","frmPhysicalStkPosting");
		hmPendingForms.put("frmPostDataToHO","frmPostDataToHO");
		hmPendingForms.put("frmPostPOSDataToCMS","frmPostPOSDataToCMS");
		hmPendingForms.put("frmRechargeDebitCard","frmRechargeDebitCard");
		hmPendingForms.put("frmStkAdjustment","frmStkAdjustment");
		hmPendingForms.put("frmStkIn","frmStkIn");
		hmPendingForms.put("frmStkOut","frmStkOut");
		hmPendingForms.put("frmVoidAdvanceOrder","frmVoidAdvanceOrder");
		hmPendingForms.put("frmVoidStock","frmVoidStock");
		hmPendingForms.put("frmPostPOSSalesDataToMMS","frmPostPOSSalesDataToMMS");
		hmPendingForms.put("frmCustomerDisplaySystem","frmCustomerDisplaySystem");
		hmPendingForms.put("frmGenrateMallInterfaceText","frmGenrateMallInterfaceText");
		hmPendingForms.put("frmSendBulkSMS","frmSendBulkSMS");
		hmPendingForms.put("frmShowCard","frmShowCard");
		hmPendingForms.put("frmPlaceOrder","frmPlaceOrder");
		hmPendingForms.put("frmPullOrder","frmPullOrder");
		hmPendingForms.put("frmBarcodeGeneration","frmBarcodeGeneration");
		hmPendingForms.put("frmPostPOSSalesDataToExcise","frmPostPOSSalesDataToExcise");
		hmPendingForms.put("frmJioMoneyRefund","frmJioMoneyRefund");
		hmPendingForms.put("frmCustomerOrder","frmCustomerOrder");
		hmPendingForms.put("frmPurchaseOrder","frmPurchaseOrder");
		hmPendingForms.put("frmMiniMakeKOT","frmMiniMakeKOT");
		hmPendingForms.put("frmKPS","frmKPS");
		hmPendingForms.put("frmComplimentaryItems","frmComplimentaryItems");
		hmPendingForms.put("frmAdvanceOrderFlash","frmAdvanceOrderFlash");
		hmPendingForms.put("frmDebitCardFlashReports","frmDebitCardFlashReports");
		hmPendingForms.put("frmDeliveryboyIncentive","frmDeliveryboyIncentive");
		hmPendingForms.put("frmLoyaltyPointReport","frmLoyaltyPointReport");
		hmPendingForms.put("frmOrderAnalysisReport","frmOrderAnalysisReport");
		hmPendingForms.put("frmPromationFlash","frmPromationFlash");
		hmPendingForms.put("frmPurchaseOrder","frmPurchaseOrder");
		hmPendingForms.put("frmStkInOutFlash","frmStkInOutFlash");
		hmPendingForms.put("frmUnusedCardBalanceReport","frmUnusedCardBalanceReport");
		hmPendingForms.put("frmPlacedOrderReport","frmPlacedOrderReport");
		hmPendingForms.put("frmAdvanceOrderReport","frmAdvanceOrderReport");
		hmPendingForms.put("frmVoidAdvanceOrderReport","frmVoidAdvanceOrderReport");
		hmPendingForms.put("frmPhysicalStockFlash","frmPhysicalStockFlash");
		hmPendingForms.put("frmJioMoneyTransactionFlash","frmJioMoneyTransactionFlash");
		hmPendingForms.put("frmPOSSaleVSPurchase","frmPOSSaleVSPurchase");
		hmPendingForms.put("frmFoodCosting","frmFoodCosting");
		hmPendingForms.put("frmPurchaseOrderReport","frmPurchaseOrderReport");
		hmPendingForms.put("frmCallCenter","frmCallCenter");
		hmPendingForms.put("frmCallCenterOrderFlash","frmCallCenterOrderFlash");
		hmPendingForms.put("frmWeraFoodOrders","frmWeraFoodOrders");
		hmPendingForms.put("frmKDSBookAndProcess","frmKDSBookAndProcess");
		hmPendingForms.put("frmArrangeTransaction","frmArrangeTransaction");
		hmPendingForms.put("frmExportTallyInterface","frmExportTallyInterface");
		hmPendingForms.put("frmRegisterDebitCard","frmRegisterDebitCard");
		hmPendingForms.put("frmUserGroupRights","frmUserGroupRights");

		hmPendingForms.put("frmDebitCardBulkRecharge","frmDebitCardBulkRecharge");
		hmPendingForms.put("frmRegisterInOutPlayZone","frmRegisterInOutPlayZone");
		hmPendingForms.put("frmUserGroupRights","frmUserGroupRights");

		
		/**
		 *Both forms are included in on form named frmBilling 
		 */
		hmPendingForms.put("frmDirectBiller","frmDirectBiller");
		hmPendingForms.put("frmRestaurantBill","frmRestaurantBill");
		
		return hmPendingForms;
	}

}
