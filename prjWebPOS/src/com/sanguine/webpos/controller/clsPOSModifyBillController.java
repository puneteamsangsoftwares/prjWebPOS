package com.sanguine.webpos.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sanguine.base.service.clsSetupService;
import com.sanguine.base.service.intfBaseService;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.webpos.bean.clsPOSBillDtl;
import com.sanguine.webpos.bean.clsPOSBillSeriesBillDtl;
import com.sanguine.webpos.bean.clsPOSBillSettlementBean;
import com.sanguine.webpos.bean.clsPOSKOTItemDtl;
import com.sanguine.webpos.bean.clsPOSPromotionItems;
import com.sanguine.webpos.model.clsBillDtlModel;
import com.sanguine.webpos.model.clsBillHdModel;
import com.sanguine.webpos.model.clsBillModifierDtlModel;
import com.sanguine.webpos.model.clsSetupHdModel;
import com.sanguine.webpos.sevice.clsPOSMasterService;

@Controller
public class clsPOSModifyBillController
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
	clsPOSBillingAPIController objBillingAPI;
	
	@Autowired
	clsPOSMasterService objMasterService;

	private StringBuilder sql = new StringBuilder();
	private Map<String, clsPOSPromotionItems> hmPromoItem = new HashMap<String, clsPOSPromotionItems>();

	@RequestMapping(value = "/frmPOSModifyBill", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model, HttpServletRequest request)
	{
		String strClientCode = request.getSession().getAttribute("gClientCode").toString();
		String urlHits = "1";
		try
		{
			urlHits = request.getParameter("saddr").toString();

			String clientCode = request.getSession().getAttribute("gClientCode").toString();
			String posCode = request.getSession().getAttribute("gPOSCode").toString();
			String posDate = request.getSession().getAttribute("gPOSDate").toString().split(" ")[0];
			
			model.put("gPOSCode", posCode);
			model.put("gClientCode", clientCode);

			model.put("urlHits", urlHits);
			model.put("billNo", "");
			model.put("billDate", posDate.split("-")[2] + "-" + posDate.split("-")[1] + "-" + posDate.split("-")[0]);

		}
		catch (NullPointerException e)
		{
			urlHits = "1";
		}

		/* Filling model attribute values */

		model.put("transactionType", "Modify Bill");
		model.put("urlHits", urlHits);
		String formToBeOpen = "Modify Bill";
		model.put("formToBeOpen", formToBeOpen);

		if ("2".equalsIgnoreCase(urlHits))
		{
			return new ModelAndView("frmWebPOSBilling", "command", new clsPOSBillSettlementBean());
		}
		else if ("1".equalsIgnoreCase(urlHits))
		{
			return new ModelAndView("frmWebPOSBilling", "command", new clsPOSBillSettlementBean());
		}
		else
		{
			return null;
		}

	}

	/* fetch all items and modifiers from a bill */

	@SuppressWarnings("finally")
	@RequestMapping(value = "/funGetItemsFromBill", method = RequestMethod.GET)
	public @ResponseBody Map<String, Object> funGetItemsFromBill(HttpServletRequest request, @RequestParam("billNo") String billNo)
	{
		List<clsPOSBillDtl> listOfBillItemDetails = new ArrayList<>();
		String operationType = "DineIn";

		Map<String, Object> map = new HashMap<>();

		try
		{
			String posCode = request.getSession().getAttribute("gPOSCode").toString();
			String posDate = request.getSession().getAttribute("gPOSDate").toString().split(" ")[0];
			String clientCode = request.getSession().getAttribute("gClientCode").toString();
			
			sql.setLength(0);
			sql.append("SELECT c.strItemCode,c.strItemName,c.dblRate,c.dblQuantity,c.dblAmount,c.dblTaxAmount,c.dblDiscAmt,c.isModifier,c.strSequenceNo,d.strSubGroupCode,e.strSubGroupName,e.strGroupCode,f.strGroupName FROM ( "
					+" SELECT a.strItemCode,a.strItemName,a.dblRate, SUM(a.dblQuantity)dblQuantity, SUM(a.dblAmount)dblAmount, SUM(a.dblTaxAmount)dblTaxAmount, SUM(a.dblDiscountAmt)dblDiscAmt,'false' isModifier,a.strSequenceNo strSequenceNo,a.strClientCode strClientCode "
					+" FROM tblbilldtl a "
					+" WHERE a.strBillNo='"+billNo+"' and a.strClientCode='"+clientCode+"' and date(a.dteBillDate)='"+posDate+"'  "  
					+" GROUP BY a.strItemCode UNION ALL "
					+" SELECT b.strItemCode,b.strModifierName,b.dblRate, SUM(b.dblQuantity)dblQuantity, SUM(b.dblAmount)dblAmount,0.00 dblTaxAmount, SUM(b.dblDiscAmt)dblDiscAmt,'true' isModifier,b.strSequenceNo strSequenceNo,b.strClientCode strClientCode "
					+" FROM tblbillmodifierdtl b "
					+" WHERE b.strBillNo='"+billNo+"'  and b.strClientCode='"+clientCode+"'  and date(b.dteBillDate)='"+posDate+"' "
					+" GROUP BY b.strItemCode) c,tblitemmaster d,tblsubgrouphd e,tblgrouphd f "
					+" WHERE "
					+" LEFT(c.strItemCode,7)=d.strItemCode AND d.strSubGroupCode=e.strSubGroupCode AND e.strGroupCode=f.strGroupCode "
					+" and  c.strClientCode=d.strClientCode and  d.strClientCode=e.strClientCode and  e.strClientCode=f.strClientCode "
					+" ORDER BY c.strItemCode,c.strItemName");
			List listPendBillData = objBaseService.funGetList(sql, "sql");
			if (listPendBillData != null && listPendBillData.size() > 0)
			{
				for (int i = 0; i < listPendBillData.size(); i++)
				{
					Object[] arrObj = (Object[]) listPendBillData.get(i);

					clsPOSBillDtl objItemDtl = new clsPOSBillDtl();

					objItemDtl.setStrItemCode(arrObj[0].toString());
					objItemDtl.setStrItemName(arrObj[1].toString());

					objItemDtl.setDblRate(Double.parseDouble(arrObj[2].toString()));
					objItemDtl.setDblQuantity(Double.parseDouble(arrObj[3].toString()));
					objItemDtl.setDblAmount(Double.parseDouble(arrObj[4].toString()));
					objItemDtl.setDblTaxAmount(Double.parseDouble(arrObj[5].toString()));
					objItemDtl.setDblDiscountAmt(Double.parseDouble(arrObj[6].toString()));
					objItemDtl.setModifier(Boolean.parseBoolean(arrObj[7].toString()));
					objItemDtl.setSequenceNo(arrObj[8].toString());
					objItemDtl.setStrSubGroupCode(arrObj[9].toString());
					objItemDtl.setStrSubGroupName(arrObj[10].toString());
					objItemDtl.setStrGroupCode(arrObj[11].toString());
					objItemDtl.setStrGroupName(arrObj[12].toString());

					listOfBillItemDetails.add(objItemDtl);
				}
			}
			sql.setLength(0);
			sql.append("select a.strOperationType from tblbillhd a where a.strBillNo='" + billNo + "' and date(a.dteBillDate)='" + posDate + "' " + "and a.strPOSCode='" + posCode + "' and a.strClientCode='"+clientCode+"'");

			List listOperationType = objBaseService.funGetList(sql, "sql");
			if (listOperationType != null && listOperationType.size() > 0)
			{
				operationType = listOperationType.get(0).toString();
			}
		}
		finally
		{
			map.put("listOfBillItemDetails", listOfBillItemDetails);
			map.put("operationType", operationType);

			return map;
		}
	}

	@SuppressWarnings("finally")
	@RequestMapping(value = "/actionModifyBill", method = RequestMethod.POST)
	public ModelAndView printBill(Map<String, Object> model, @ModelAttribute("command") clsPOSBillSettlementBean objBean, BindingResult result, HttpServletRequest request) throws Exception
	{
		try
		{
			String posDate = request.getSession().getAttribute("gPOSDate").toString().split(" ")[0];
			String billDateTime = posDate;
			String clientCode = request.getSession().getAttribute("gClientCode").toString();
			String posCode = request.getSession().getAttribute("loginPOS").toString();
			
			Date dt = new Date();
			String currentDateTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(dt);

			StringBuilder sbSql = new StringBuilder();
			sbSql.setLength(0);

			String billNo = objBean.getStrBillNo();

			boolean isBillSeries = false;
			clsSetupHdModel objSetupHdModel=objMasterService.funGetPOSWisePropertySetup(posCode, clientCode);
			
			if (objSetupHdModel.getStrEnableBillSeries().equalsIgnoreCase("Y"))
			{
				isBillSeries = true;
			}

			List<clsPOSBillSeriesBillDtl> listBillSeriesBillDtl = new ArrayList<clsPOSBillSeriesBillDtl>();

			/**
			 * Filling item details in a list
			 */
			List<clsPOSKOTItemDtl> listOfWholeKOTItemDtl = new ArrayList<clsPOSKOTItemDtl>();

			/* Setting billdtl data */
			
			sbSql.setLength(0);
			sbSql.append("from clsBillHdModel a where a.strBillNo='" + billNo + "' ");
			List<clsBillHdModel> listBillHd = objBaseService.funGetList(sbSql, "hql");
			if(listBillHd.size()>0)
			{
				clsBillHdModel objBillHdModel = listBillHd.get(0);
				List<clsBillDtlModel> listBillDtlModel = objBillHdModel.getListBillDtlModel();
				for(clsBillDtlModel objBillDtlModel:listBillDtlModel)
				{
					clsPOSKOTItemDtl objKOTItem = new clsPOSKOTItemDtl();
					objKOTItem.setStrItemCode(objBillDtlModel.getStrItemCode());
					objKOTItem.setStrItemName(objBillDtlModel.getStrItemName());
					objKOTItem.setDblItemQuantity(objBillDtlModel.getDblQuantity());
					objKOTItem.setDblAmount(objBillDtlModel.getDblAmount());
					objKOTItem.setDblRate(objBillDtlModel.getDblRate());
					objKOTItem.setStrKOTNo(objBillDtlModel.getStrKOTNo());
					objKOTItem.setStrManualKOTNo(objBillDtlModel.getStrManualKOTNo());
					objKOTItem.setStrKOTDateTime(billDateTime);
					objKOTItem.setStrCustomerCode(objGlobalFunctions.funIfNull(objBillDtlModel.getStrCustomerCode(), "", objBillDtlModel.getStrCustomerCode()));
					objKOTItem.setStrCustomerName("");
					objKOTItem.setStrPromoCode(objBillDtlModel.getStrPromoCode());
					objKOTItem.setStrCardNo("");
					objKOTItem.setStrOrderProcessTime(objGlobalFunctions.funIfNull(objBillDtlModel.getTmeOrderProcessing(), "00:00:00", objBillDtlModel.getTmeOrderProcessing()));
					objKOTItem.setStrOrderPickupTime(objGlobalFunctions.funIfNull(objBillDtlModel.getTmeOrderPickup(), "00:00:00", objBillDtlModel.getTmeOrderPickup()));
					objKOTItem.setStrWaiterNo(objBillDtlModel.getStrWaiterNo());
					listOfWholeKOTItemDtl.add(objKOTItem);
				}
				
				List<clsBillModifierDtlModel> listBillModifierDtlModel = objBillHdModel.getListBillModifierDtlModel();
				for(clsBillModifierDtlModel objBillModifierDtlModel:listBillModifierDtlModel)
				{
					clsPOSKOTItemDtl objKOTItem = new clsPOSKOTItemDtl();
					
					objKOTItem.setStrItemCode(objBillModifierDtlModel.getStrItemCode());
					objKOTItem.setStrItemName(objBillModifierDtlModel.getStrModifierName());
					objKOTItem.setDblItemQuantity(objBillModifierDtlModel.getDblQuantity());
					objKOTItem.setDblAmount(objBillModifierDtlModel.getDblAmount());
					objKOTItem.setDblRate(objBillModifierDtlModel.getDblRate());
					objKOTItem.setStrKOTNo("");
					objKOTItem.setStrManualKOTNo("");
					objKOTItem.setStrKOTDateTime(billDateTime);
					objKOTItem.setStrCustomerCode(objBillModifierDtlModel.getStrCustomerCode());
					objKOTItem.setStrCustomerName("");
					objKOTItem.setStrPromoCode("");
					objKOTItem.setStrCardNo("");
					objKOTItem.setStrOrderProcessTime("");
					objKOTItem.setStrOrderPickupTime("");
					objKOTItem.setStrWaiterNo("");

					listOfWholeKOTItemDtl.add(objKOTItem);
				}
			}
	

			if (isBillSeries)
			{
				/* To save normal bill */
				objBillingAPI.funSaveBill(isBillSeries, "", listBillSeriesBillDtl, billNo, listOfWholeKOTItemDtl, objBean, request, hmPromoItem);
			}
			else
			{
				/* To save normal bill */
				objBillingAPI.funSaveBill(isBillSeries, "", listBillSeriesBillDtl, billNo, listOfWholeKOTItemDtl, objBean, request, hmPromoItem);
			}

		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			return new ModelAndView("redirect:/frmPOSModifyBill.html");
		}
	}

}
