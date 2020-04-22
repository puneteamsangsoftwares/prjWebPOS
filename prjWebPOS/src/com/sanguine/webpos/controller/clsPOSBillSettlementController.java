package com.sanguine.webpos.controller;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sanguine.base.service.clsBaseServiceImpl;
import com.sanguine.base.service.clsSetupService;
import com.sanguine.base.service.intfBaseService;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.webpos.bean.clsPOSBillSettlementBean;
import com.sanguine.webpos.bean.clsPOSSettelementOptions;
import com.sanguine.webpos.bean.clsPOSSettlementDtlsOnBill;
import com.sanguine.webpos.model.clsBillDtlModel;
import com.sanguine.webpos.model.clsBillHdModel;
import com.sanguine.webpos.model.clsBillSettlementDtlModel;
import com.sanguine.webpos.model.clsSetupHdModel;
import com.sanguine.webpos.sevice.clsPOSMasterService;
import com.sanguine.webpos.util.clsPOSUtilityController;

@Controller
public class clsPOSBillSettlementController
{

	@Autowired
	private clsGlobalFunctions objGlobalFunctions;

	@Autowired
	clsPOSGlobalFunctionsController objPOSGlobalFunctionsController;

	@Autowired
	private clsSetupService objSetupService;

	@Autowired
	private intfBaseService objBaseService;

	@Autowired
	clsBaseServiceImpl objBaseServiceImpl;

	@Autowired
	clsPOSBillingAPIController objBillingAPI;

	@Autowired 
	clsPOSMasterService objMasterService;
	
	@Autowired
	clsPOSUtilityController objUtility;
	
	@SuppressWarnings("finally")
	@RequestMapping(value = "/frmPOSRestaurantDtl", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model, HttpServletRequest request)
	{
		String urlHits = "1";
		clsPOSBillSettlementBean objBillSettlementBean = new clsPOSBillSettlementBean();
		clsSetupHdModel objSetupHdModel=null;
		try
		{

			String clientCode = request.getSession().getAttribute("gClientCode").toString();
			String posCode = request.getSession().getAttribute("gPOSCode").toString();
			String posDate = request.getSession().getAttribute("gPOSDate").toString().split(" ")[0];
			String userCode = request.getSession().getAttribute("gUserCode").toString();

			urlHits = request.getParameter("saddr").toString();

			String usertype = request.getSession().getAttribute("gUserType").toString();
			boolean isSuperUser = false;
			objSetupHdModel=objMasterService.funGetPOSWisePropertySetup(clientCode,posCode);
			if (usertype.equalsIgnoreCase("yes"))
			{
				isSuperUser = true;
			}
			else
			{
				isSuperUser = false;
			}

			/* Filling model attribute values */
			model.put("urlHits", urlHits);
			String formToBeOpen = "Settle Bill";
			model.put("formToBeOpen", formToBeOpen);

			String gPickSettlementsFromPOSMaster=objSetupHdModel.getStrSettlementsFromPOSMaster();
			String gEnablePMSIntegrationYN=objSetupHdModel.getStrEnablePMSIntegrationYN();
			
			List listSettlementObject = new ArrayList<clsPOSSettelementOptions>();

			JSONObject jObj1 = objBillingAPI.funSettlementMode(clientCode, posCode, isSuperUser, gPickSettlementsFromPOSMaster, gEnablePMSIntegrationYN);

			//JSONObject jsSettelementOptionsDtl = (JSONObject) jObj1.get("SettleObj");

			listSettlementObject = (List) jObj1.get("listSettleObj");
			JSONArray jArr = new JSONArray();
			JSONObject jsSettle = new JSONObject();
			clsPOSSettelementOptions ob=null;
			for (int j = 0; j < listSettlementObject.size(); j++)
			{
				jArr.add(listSettlementObject.get(j));
				ob=(clsPOSSettelementOptions)listSettlementObject.get(j);
				if(ob.getStrSettelmentType().equalsIgnoreCase("cash")){
					model.put("cashSettlement", ob.getStrSettelmentDesc()+","+ob.getStrSettelmentType()+","+ob.getStrSettelmentCode()+","+ob.getDblConvertionRatio()+","+ob.getStrBillPrintOnSettlement());
				}
			}
			model.put("ObSettleObject", jsSettle);
			model.put("gItemQtyNumpad", false);
			if(objSetupHdModel.getStrItemQtyNumpad().equalsIgnoreCase("Y")){
				model.put("gItemQtyNumpad", true);	
			}
			model.put("roundoff", objSetupHdModel.getDblRoundOff());
			objBillSettlementBean.setJsonArrForSettleButtons(jArr);

			objBillSettlementBean.setDteExpiryDate(posDate);

		}
		catch (NullPointerException e)
		{
			urlHits = "1";
		}
		finally
		{
			if ("2".equalsIgnoreCase(urlHits))
			{
				return new ModelAndView("frmWebPOSBilling", "command", objBillSettlementBean);
			}
			else if ("1".equalsIgnoreCase(urlHits))
			{
				return new ModelAndView("frmWebPOSBilling", "command", objBillSettlementBean);
			}
			else
			{
				return null;
			}
		}
	}

	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/fillUnsettleBillData", method = RequestMethod.GET)
	public @ResponseBody Map funFillUnSettleBill(Map<String, Object> model, HttpServletRequest req)
	{
		List listUnsettlebill = new ArrayList();
		Map<String,Object> hmUnsettleBill = new HashMap<String,Object> ();
		try
		{
			String clientCode = req.getSession().getAttribute("gClientCode").toString();
			String strPosCode = req.getSession().getAttribute("loginPOS").toString();
			String posDate = req.getSession().getAttribute("gPOSDate").toString();

			StringBuilder sql = new StringBuilder();
			try
			{
				clsSetupHdModel objSetupHdModel=objMasterService.funGetPOSWisePropertySetup(clientCode,strPosCode);
				String gShowBillsType = objSetupHdModel.getStrShowBillsDtlType();
				String gCMSIntegrationYN = objSetupHdModel.getStrCMSIntegrationYN();
				hmUnsettleBill.put("gShowBillsType", gShowBillsType);
				hmUnsettleBill.put("gCMSIntegrationYN", gCMSIntegrationYN);
		        DecimalFormat deciformat=objUtility.funGetGlobalDecimalFormatter(objSetupHdModel.getDblNoOfDecimalPlace());

				if (gShowBillsType.equalsIgnoreCase("Table Detail Wise"))
				{
					sql.append("select a.strBillNo,ifnull(b.strTableNo,''),ifnull(b.strTableName,''),ifnull(c.strWaiterNo,'')" + " ,ifnull(c.strWShortName,''),ifnull(d.strCustomerCode,''),ifnull(d.strCustomerName,''),a.dblGrandTotal" + " ,DATE_FORMAT(a.dteBillDate,'%h:%i:%s')  " + " from tblbillhd a left outer join tbltablemaster b on a.strTableNo=b.strTableNo and a.strClientCode=b.strClientCode left outer join tblwaitermaster c on a.strWaiterNo=c.strWaiterNo  and a.strClientCode=c.strClientCode  left outer join tblcustomermaster d on a.strCustomerCode=d.strCustomerCode  and a.strClientCode=d.strClientCode where a.strBillNo not in (select strBillNo from tblbillsettlementdtl where strClientCode='"+clientCode+"' )  and date(a.dteBillDate)='" + posDate + "' " + " and a.strPOSCode='" + strPosCode + "' and a.strClientCode='"+clientCode+"' ");
				}
				else// Delivery Detail Wise
				{
					sql.append("SELECT a.strBillNo,IFNULL(d.strCustomerName,''),ifnull(e.strBuildingName,''),ifnull(f.strDPName,'')" + " ,a.dblGrandTotal,ifnull(g.strTableNo,''),ifnull(g.strTableName,''),DATE_FORMAT(a.dteBillDate,'%h:%i:%s') " + " FROM tblbillhd a " + " left outer join tblhomedeldtl b on a.strBillNo=b.strBillNo  and a.strClientCode=b.strClientCode " + " LEFT OUTER JOIN tblcustomermaster d ON a.strCustomerCode=d.strCustomerCode  and a.strClientCode=d.strClientCode " + " left outer join tblbuildingmaster e on d.strBuldingCode=e.strBuildingCode  and d.strClientCode=e.strClientCode " + " left outer join tbldeliverypersonmaster  f on  f.strDPCode=b.strDPCode  and f.strClientCode=b.strClientCode " + " left outer join tbltablemaster g on a.strTableNo=g.strTableNo  and a.strClientCode=g.strClientCode " + " WHERE a.strBillNo NOT IN (SELECT strBillNo FROM tblbillsettlementdtl  where strClientCode='"+clientCode+"' )  AND DATE(a.dteBillDate)='" + posDate + "'  AND a.strPOSCode='" + strPosCode + "' and a.strClientCode='"+clientCode+"' group by a.strBillNo");
				}
				List listPendBillData = objBaseService.funGetList(sql, "sql");
				if (listPendBillData.size() > 0)
				{
					for (int i = 0; i < listPendBillData.size(); i++)
					{
						LinkedList<String> setFillGrid = new LinkedList();
						Object[] obj = (Object[]) listPendBillData.get(i);
						
						if (gShowBillsType.equalsIgnoreCase("Table Detail Wise"))
						{
							setFillGrid.add(obj[0].toString());
							setFillGrid.add(obj[2].toString());
							setFillGrid.add(obj[4].toString());
							setFillGrid.add(obj[6].toString());
							setFillGrid.add(obj[8].toString());
							setFillGrid.add(deciformat.format(Double.parseDouble(obj[7].toString())));
							setFillGrid.add(obj[1].toString());

							listUnsettlebill.add(setFillGrid);
						}
						else// Delivery Detail Wise
						{
							setFillGrid.add(obj[0].toString());
							setFillGrid.add(obj[6].toString());
							setFillGrid.add(obj[1].toString());
							setFillGrid.add(obj[2].toString());
							setFillGrid.add(obj[3].toString());
							setFillGrid.add(obj[7].toString());
							setFillGrid.add(deciformat.format(Double.parseDouble(obj[4].toString())));
							setFillGrid.add(obj[5].toString());

							listUnsettlebill.add(setFillGrid);
						}
						
					}
				}
				hmUnsettleBill.put("listUnsettlebill", listUnsettlebill);

			}
			catch (Exception e)
			{
				e.printStackTrace();
			}
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
		}
		return hmUnsettleBill;
	}

	public Map funFillUnsettleBill(String clientCode, String posCode, String posDate)
	{
		Map hmReturn = new HashMap();
		List listData = new ArrayList();
		StringBuilder sql = new StringBuilder();
		try
		{
			clsSetupHdModel objSetupHdModel=objMasterService.funGetPOSWisePropertySetup(posCode, clientCode);
			String gShowBillsType = objSetupHdModel.getStrShowBillsDtlType();
			String gCMSIntegrationYN = objSetupHdModel.getStrCMSIntegrationYN();
			hmReturn.put("gShowBillsType", gShowBillsType);
			hmReturn.put("gCMSIntegrationYN", gCMSIntegrationYN);

			if (gShowBillsType.equalsIgnoreCase("Table Detail Wise"))
			{
				sql.append("select a.strBillNo,ifnull(b.strTableNo,''),ifnull(b.strTableName,''),ifnull(c.strWaiterNo,'')" + " ,ifnull(c.strWShortName,''),ifnull(d.strCustomerCode,''),ifnull(d.strCustomerName,''),a.dblGrandTotal" + " ,DATE_FORMAT(a.dteBillDate,'%h:%i:%s')  " + " from tblbillhd a left outer join tbltablemaster b on a.strTableNo=b.strTableNo and a.strClientCode=b.strClientCode left outer join tblwaitermaster c on a.strWaiterNo=c.strWaiterNo  and a.strClientCode=c.strClientCode  left outer join tblcustomermaster d on a.strCustomerCode=d.strCustomerCode  and a.strClientCode=d.strClientCode where a.strBillNo not in (select strBillNo from tblbillsettlementdtl where strClientCode='"+clientCode+"' )  and date(a.dteBillDate)='" + posDate + "' " + " and a.strPOSCode='" + posCode + "' and a.strClientCode='"+clientCode+"' ");
			}
			else// Delivery Detail Wise
			{
				sql.append("SELECT a.strBillNo,IFNULL(d.strCustomerName,''),ifnull(e.strBuildingName,''),ifnull(f.strDPName,'')" + " ,a.dblGrandTotal,ifnull(g.strTableNo,''),ifnull(g.strTableName,''),DATE_FORMAT(a.dteBillDate,'%h:%i:%s') " + " FROM tblbillhd a " + " left outer join tblhomedeldtl b on a.strBillNo=b.strBillNo  and a.strClientCode=b.strClientCode " + " LEFT OUTER JOIN tblcustomermaster d ON a.strCustomerCode=d.strCustomerCode  and a.strClientCode=d.strClientCode " + " left outer join tblbuildingmaster e on d.strBuldingCode=e.strBuildingCode  and d.strClientCode=e.strClientCode " + " left outer join tbldeliverypersonmaster  f on  f.strDPCode=b.strDPCode  and f.strClientCode=b.strClientCode " + " left outer join tbltablemaster g on a.strTableNo=g.strTableNo  and a.strClientCode=g.strClientCode " + " WHERE a.strBillNo NOT IN (SELECT strBillNo FROM tblbillsettlementdtl  where strClientCode='"+clientCode+"' )  AND DATE(a.dteBillDate)='" + posDate + "'  AND a.strPOSCode='" + posCode + "' and a.strClientCode='"+clientCode+"' group by a.strBillNo");
			}
			List listPendBillData = objBaseService.funGetList(sql, "sql");
			if (listPendBillData.size() > 0)
			{
				for (int i = 0; i < listPendBillData.size(); i++)
				{
					Object[] obj = (Object[]) listPendBillData.get(i);
					Map hmData = new HashMap();
					if (gShowBillsType.equalsIgnoreCase("Table Detail Wise"))
					{
						hmData.put("strBillNo", obj[0].toString());
						hmData.put("strTableName", obj[2].toString());
						hmData.put("strWShortName", obj[4].toString());
						hmData.put("strCustomerName", obj[6].toString());
						hmData.put("dteBillDate", obj[8].toString());
						hmData.put("dblGrandTotal", obj[7].toString());
						hmData.put("strTableNo", obj[1].toString());
					}
					else// Delivery Detail Wise
					{
						hmData.put("strBillNo", obj[0].toString());
						hmData.put("strTableName", obj[6].toString());
						hmData.put("strCustomerName", obj[1].toString());
						hmData.put("strBuildingName", obj[2].toString());
						hmData.put("strDPName", obj[3].toString());
						hmData.put("dteBillDate", obj[7].toString());
						hmData.put("dblGrandTotal", obj[4].toString());
						hmData.put("strTableNo", obj[5].toString());
					}
					listData.add(hmData);
				}
			}

			hmReturn.put("jArr", listData);

		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return hmReturn;
	}

	
	@SuppressWarnings("finally")
	@RequestMapping(value = "/actionBillSettle", method = RequestMethod.POST)
	public ModelAndView printBill(@ModelAttribute("command") clsPOSBillSettlementBean objBean, BindingResult result, HttpServletRequest request) throws Exception
	{
		try
		{
			String clientCode = "",
					POSCode = "",
					posDate = "",
					userCode = "",
					posClientCode = "";

			StringBuilder hqlBuilder = new StringBuilder();

			clientCode = request.getSession().getAttribute("gClientCode").toString();
			POSCode = request.getSession().getAttribute("gPOSCode").toString();
			posDate = request.getSession().getAttribute("gPOSDate").toString().split(" ")[0];
			userCode = request.getSession().getAttribute("gUserCode").toString();

			String split = posDate;
			String billDateTime = split;

			Date dt = new Date();
			String currentDateTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(dt);
			String dateTime = posDate + " " + currentDateTime.split(" ")[1];

			StringBuilder sbSql = new StringBuilder();
			sbSql.setLength(0);

			String billNo = objBean.getStrBillNo();

			hqlBuilder.setLength(0);
			hqlBuilder.append(" from clsBillHdModel where strBillNo='" + billNo + "' and strClientCode='" + clientCode + "' and dtBillDate='" + posDate + "'  ");
			List<clsBillHdModel> listOfHd = objBaseService.funGetList(hqlBuilder, "hql");

			clsBillHdModel objBillHdModel = listOfHd.get(0);
			List<clsBillDtlModel> listBillDtlModel = objBillHdModel.getListBillDtlModel();

			objBillHdModel.setStrTransactionType(objBillHdModel.getStrTransactionType() + "," + "Settle Bill");

			/* Save bill settlement data */
			List<clsPOSSettlementDtlsOnBill> listObjBillSettlementDtl = objBean.getListSettlementDtlOnBill();

			List<clsBillSettlementDtlModel> listBillSettlementDtlModel = new ArrayList<clsBillSettlementDtlModel>();

			boolean isComplementarySettle = false;
			if (listObjBillSettlementDtl.size() == 1 && listObjBillSettlementDtl.get(0).getStrSettelmentType().equalsIgnoreCase("Complementary"))
			{
				isComplementarySettle = true;
			}
			String strSettlement="";
			for (clsPOSSettlementDtlsOnBill objBillSettlementDtl : listObjBillSettlementDtl)
			{
				clsBillSettlementDtlModel objSettleModel = new clsBillSettlementDtlModel();

				if(objBillSettlementDtl.getStrSettelmentCode()!=null && objBillSettlementDtl.getDblPaidAmt()>0){
					strSettlement=objBillSettlementDtl.getStrSettelmentDesc();
					objSettleModel.setStrSettlementCode(objBillSettlementDtl.getStrSettelmentCode());
					if (isComplementarySettle)
					{
						objSettleModel.setDblSettlementAmt(0.00);
						objSettleModel.setDblPaidAmt(0.00);
						
						objSettleModel.setDblActualAmt(0.00);
						objSettleModel.setDblRefundAmt(0.00);
						
						objBillHdModel.setDblDeliveryCharges(0.00);
						objBillHdModel.setDblDiscountAmt(0);
						objBillHdModel.setDblDiscountPer(0);
						objBillHdModel.setDblGrandTotal(0);
						objBillHdModel.setDblRoundOff(0);
						objBillHdModel.setDblSubTotal(0);
						objBillHdModel.setDblTaxAmt(0);
						objBillHdModel.setDblTipAmount(0);
						
					}
					else
					{
						objSettleModel.setDblSettlementAmt(objBillSettlementDtl.getDblPaidAmt());
						objSettleModel.setDblPaidAmt(objBillSettlementDtl.getDblPaidAmt());
						
						objSettleModel.setDblActualAmt(objBillSettlementDtl.getDblActualAmt());
						objSettleModel.setDblRefundAmt(objBillSettlementDtl.getDblRefundAmt());
					}
					
					
					
					objSettleModel.setStrExpiryDate("");
					objSettleModel.setStrCardName("");
					objSettleModel.setStrRemark("");
					objSettleModel.setStrCustomerCode("");
                    if(objBillSettlementDtl.getStrSettelmentType().equalsIgnoreCase("Credit"))
                    {
    					objSettleModel.setStrCustomerCode(objGlobalFunctions.funIfNull(objBean.getStrCustomerCode(), "", objBean.getStrCustomerCode()));

                    }
					
					objSettleModel.setStrGiftVoucherCode("");
					objSettleModel.setStrDataPostFlag("");

					objSettleModel.setStrFolioNo("");
					objSettleModel.setStrRoomNo("");

					listBillSettlementDtlModel.add(objSettleModel);

				}
				
			}

			objBillHdModel.setStrSettelmentMode("");

			if (listBillSettlementDtlModel != null && listBillSettlementDtlModel.size() == 0)
			{
				objBillHdModel.setStrSettelmentMode("");
			}
			else if (listBillSettlementDtlModel != null && listBillSettlementDtlModel.size() == 1)
			{
				objBillHdModel.setStrSettelmentMode(strSettlement);
			}
			else
			{
				objBillHdModel.setStrSettelmentMode("MultiSettle");
			}

			objBillHdModel.setListBillSettlementDtlModel(listBillSettlementDtlModel);
			objBillHdModel.setStrCustomerCode(objGlobalFunctions.funIfNull(objBean.getStrCustomerCode(), "", objBean.getStrCustomerCode()));
			
			/* Save Bill HD */
			objBaseServiceImpl.funSave(objBillHdModel);
			objBillingAPI.funUpdateTableStatus(objBillHdModel.getStrTableNo(), "Normal",clientCode);
			
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			return new ModelAndView("redirect:/frmPOSRestaurantDtl.html?saddr=1");
		}
	}

}
