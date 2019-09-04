/*package com.sanguine.webpos.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.codehaus.jackson.map.annotate.JsonSerialize.Typing;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.POSGlobal.controller.clsGlobalVarClass;
import com.POSGlobal.controller.clsSPOSException;
import com.sanguine.base.service.clsSetupService;
import com.sanguine.base.service.intfBaseService;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.util.clsRequestInterceptor;
import com.sanguine.webpos.bean.clsPOSAreaMasterBean;
import com.sanguine.webpos.bean.clsPOSBillSettlementBean;
import com.sanguine.webpos.bean.clsPOSBillSettlementDtl;
import com.sanguine.webpos.bean.clsPOSChangeSettlementBean;
import com.sanguine.webpos.bean.clsPOSSplitBillBean;
import com.sanguine.webpos.sevice.clsPOSMasterService;
import com.sanguine.webpos.sevice.clsPOSTransactionService;
import com.sanguine.webpos.util.clsPOSSetupUtility;
import com.sanguine.webpos.util.clsPOSUtilityController;

@Controller
public class clsPOSSplitBillController
{
	@Autowired
	private clsGlobalFunctions objGlobal;

	@Autowired
	private clsPOSGlobalFunctionsController objPOSGlobal;

	@Autowired
	clsPOSMasterService objMasterService;

	@Autowired
	private intfBaseService objBaseService;

	@Autowired
	private clsSetupService objSetupService;

	@Autowired
	private clsPOSUtilityController objUtilityController;

	@Autowired
	private clsPOSTransactionService objTransService;

	@Autowired
	private clsPOSSetupUtility objPOSSetupUtility;
	@Autowired
	private clsPOSUtilityController objUtility2;

	List listItem;
	private int no_Of_Items_withModifier = 0,
			no_Of_tax_withModifier = 0;
	private Map hmItemTypeWiseBill;
	List listItemTypeForItemType = new ArrayList<>();
	private String billedOperationType = "DineIn";
	private HashMap<String, String> billsToBePrinted = new HashMap<String, String>();

	private String settlementCode,
			billedAreaCode,
			dineInForTax,
			takeAwayForTax,
			homeDeliveryForTax;
	private ArrayList<ArrayList<Object>> arrListTaxCal;
	private ArrayList arrListTax = new ArrayList<>();
	String itemCode;
	private Map<String, List<Object>> hmGroupWiseBill;

	@RequestMapping(value = "/frmPOSSplitBill", method = RequestMethod.GET)
	public ModelAndView funOpenForm(@ModelAttribute("command") @Valid clsPOSSplitBillBean objBean, BindingResult result, Map<String, Object> model, HttpServletRequest request)
	{
		String urlHits = "1";
		try
		{
			urlHits = request.getParameter("saddr").toString();
		}
		catch (NullPointerException e)
		{
			urlHits = "1";
		}
		model.put("urlHits", urlHits);

		// Split Type
		List<String> splitTypeList = new ArrayList<String>();
		splitTypeList.add("--SELECT--");

		splitTypeList.add("Equal Split");
		splitTypeList.add("Group Wise");
		splitTypeList.add("Item Type Wise");
		splitTypeList.add("Item Wise");

		model.put("splitTypeList", splitTypeList);

		List listSplitQty = new ArrayList();
		for (int i = 1; i <= 10; i++)
		{
			listSplitQty.add(i);
		}
		model.put("splitTypeQty", listSplitQty);

		if ("2".equalsIgnoreCase(urlHits))
		{
			return new ModelAndView("frmPOSSplitBill_1");
		}
		else if ("1".equalsIgnoreCase(urlHits))
		{
			return new ModelAndView("frmPOSSplitBill");
		}
		else
		{
			return null;
		}

	}

	@RequestMapping(value = "/loadPOSSplitBillData", method = RequestMethod.GET)
	private @ResponseBody Map funFillItemGrid(@RequestParam("billNo") String billNo, HttpServletRequest request) throws Exception
	{
		StringBuilder sql = new StringBuilder();
		String posCode = request.getSession().getAttribute("gPOSCode").toString();
		String clientCode = request.getSession().getAttribute("gClientCode").toString();

		Map<String, List<List<List>>> maptotal = new HashMap<String, List<List<List>>>();

		// List for item
		listItem = objTransService.funGetSettlementBillForSplitBill(posCode, billNo);// [[BOCCONCINI
																						// &
																						// CHERRY
																						// TOMATO
																						// AVACADO
																						// ON
																						// TOAST,
																						// 1.0000,
																						// 350.0000,
																						// I001224,
																						// 0.0000]]

		sql.append("select b.strItemName,b.dblQuantity,b.dblAmount,a.strWaiterNo," + " a.dblDiscountAmt,a.dblDiscountPer ,b.strItemCode ,b.strKOTNo,sum(b.dblDiscountAmt),b.dblRate " + " from tblbillhd a,tblbilldtl b " + " where a.strBillNo=b.strBillNo " + " and date(a.dteBillDate)=date(b.dteBillDate) " + "and a.strBillNo='" + billNo + "' " + " group by b.strItemCode ");

		List list = objBaseService.funGetList(sql, "sql");
		if (list != null)
		{
			for (int i = 0; i < list.size(); i++)
			{
				Object[] obj = (Object[]) list.get(i);
				itemCode = obj[6].toString();

			}
		}

		// List for Tax
		List listtax = objTransService.funGetTaxForSplitBill(posCode, billNo);
		listItem.add(listtax);

		// List for Sub total
		List listtotal = objTransService.funGetSubtotalForSplitBill(clientCode, posCode, billNo);

		maptotal.put("MenuList", listItem);
		maptotal.put("TaxList", listtax);

		maptotal.put("TotalList", listtotal);

		return maptotal;

	}

	private boolean funIsModifierPresent(String oldBillNo, String temp_itemCode)
	{
		boolean flag = false;
		StringBuilder sqlModifier = new StringBuilder();
		try
		{
			sqlModifier.append("select * " + " from tblbillmodifierdtl " + " where strBillNo='" + oldBillNo + "' " + " and date(dteBillDate)='" + objGlobal.funGetCurrentDate("yyyy-MM-dd") + "' " + " and left(strItemCode,7)='" + temp_itemCode + "' ");
			List rsModifier = objBaseService.funGetList(sqlModifier, "sql");
			if (rsModifier.size() > 0)
			{
				sqlModifier.append("select count(strItemCode) " + " from tblbillmodifierdtl " + " where strBillNo='" + oldBillNo + "' " + " and date(dteBillDate)='" + objGlobal.funGetCurrentDate("yyyy-MM-dd") + "'  " + " and left(strItemCode,7)='" + temp_itemCode + "' ");
				rsModifier = objBaseService.funGetList(sqlModifier, "sql");
				if (rsModifier.size() > 0)
				{
					flag = true;

					for (int i = 0; i < rsModifier.size(); i++)
					{
						Object[] obj = (Object[]) rsModifier.get(i);
						no_Of_Items_withModifier = Integer.parseInt(obj[0].toString());
					}
				}

			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return flag;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/loadEqualSplitData", method = RequestMethod.GET)
	private void funFillGrid1(@RequestParam("billNo") String billNo, @RequestParam("splitQty") int splitQty, HttpServletRequest request) throws Exception
	{
		String posCode = request.getSession().getAttribute("gPOSCode").toString();
		String posDate = request.getSession().getAttribute("gPOSDate").toString().split(" ")[0];

		String clientCode = request.getSession().getAttribute("gClientCode").toString();

		StringBuilder sqlBillDtl = new StringBuilder();
		StringBuilder sqlModifier = new StringBuilder();
		StringBuilder sqlBillHd = new StringBuilder();
		StringBuilder sqlBillDiscDtl = new StringBuilder();
		StringBuilder sqlGT = new StringBuilder();
		StringBuilder sql_tblbilltaxdtl = new StringBuilder();
		List listTaxCode = new ArrayList<>();
		StringBuilder sb = new StringBuilder();
		List listbill = new ArrayList<>();

		sb.setLength(0);
		sb.append("select strTaxCode from tblbilltaxdtl " + "where strBillNo='" + billNo + "' " + "and date(dteBillDate)='" + posDate + "' ");
		List taxList = objBaseService.funGetList(sb, "sql");

		if (taxList != null)
		{
			for (int i = 0; i < taxList.size(); i++)
			{
				String obj = taxList.get(i).toString();
				List jRow = new ArrayList<>();

				jRow.add(obj);
				listTaxCode.add(jRow);
			}
		}

		for (int i = 1; i <= splitQty; i++)
		{
			String nwBillNo = billNo.concat("-") + i;
			for (int j = 0; j < listItem.size(); j++) 
													 * [[BOCCONCINI & CHERRY
													 * TOMATO AVACADO ON TOAST,
													 * 1.0000, 350.0000,
													 * I001224, 0.0000],
													 * [[SERVICE CHARGE @ 5%,
													 * 17.5000, T01], [SGST @
													 * 2.5%, 8.7500, T04], [CGST
													 * 
													 * @ 2.5%, 8.7500, T06]]]
													 
			{
				

				sqlBillDtl.append("insert into tblbilldtl(strItemCode,strItemName" + ",strBillNo,strAdvBookingNo,dblRate,dblQuantity,dblAmount" + ",dblTaxAmount,dteBillDate,strKOTNo,strClientCode" + ",strCustomerCode,tmeOrderProcessing,strDataPostFlag" + ",strMMSDataPostFlag,strManualKOTNo,tdhYN,dblDiscountAmt,dblDiscountPer,dtBillDate)" + "(select strItemCode,strItemName,'" + nwBillNo + "',strAdvBookingNo,dblRate,dblQuantity/('" + splitQty + "')," + "dblAmount/('" + splitQty + "'),if(dblAmount>0,dblTaxAmount/('" + splitQty + "'),0.00),dteBillDate,strKOTNo," + "strClientCode,strCustomerCode,tmeOrderProcessing,strDataPostFlag" + ",strMMSDataPostFlag,strManualKOTNo,tdhYN,dblDiscountAmt/('" + splitQty + "')," + "dblDiscountPer,'" + posDate + "' from tblbilldtl " + "where strBillNo='" + billNo + "' "// and
						+ "and strItemCode='" + itemCode + "' " + "and date(dteBillDate)='" + posDate + "' )");
				objBaseService.funExecuteUpdate(sqlBillDtl.toString(), "sql");

				if (funIsModifierPresent(billNo, itemCode))
				{
					sqlModifier.append("insert into tblbillmodifierdtl(strBillNo,strItemCode,strModifierCode,strModifierName" + " ,dblRate,dblQuantity,dblAmount,strClientCode,strCustomerCode,strDataPostFlag,strMMSDataPostFlag" + " ,strDefaultModifierDeselectedYN,strSequenceNo,dblDiscPer,dblDiscAmt,dteBillDate )" + " (select '" + nwBillNo + "',strItemCode,strModifierCode,strModifierName,dblRate " + " ,dblQuantity/('" + splitQty + "'),dblAmount/('" + splitQty + "'),strClientCode,strCustomerCode" + " ,strDataPostFlag,strMMSDataPostFlag,strDefaultModifierDeselectedYN,strSequenceNo,dblDiscPer,dblDiscAmt/('" + splitQty + "'),'" + objGlobal.funGetCurrentDate("yyyy-MM-dd") + "' " + " from tblbillmodifierdtl " + " where strBillNo='" + billNo + "' " + " and date(dteBillDate)='" + posDate + "' )");
					objBaseService.funExecuteUpdate(sqlModifier.toString(), "sql");

				}
			}
			for (int t = 0; t < listTaxCode.size(); t++)
			{
				sql_tblbilltaxdtl.append("insert into tblbilltaxdtl " + "(strBillNo,strTaxCode,dblTaxableAmount,dblTaxAmount,strClientCode,strDataPostFlag,dteBillDate) \n" + "(select '" + nwBillNo + "', strTaxCode, dblTaxableAmount/('" + splitQty + "'),dblTaxAmount/('" + splitQty + "')," + "'" + clientCode + "',strDataPostFlag,'" + clsGlobalVarClass.getPOSDateForTransaction() + "' " + "from tblbilltaxdtl " + " where strBillNo='" + billNo + "' " + " and strTaxCode='" + listTaxCode.get(t) + "' " + " and date(dteBillDate)='" + objGlobal.funGetCurrentDate("yyyy-MM-dd") + "' )");
				objBaseService.funExecuteUpdate(sql_tblbilltaxdtl.toString(), "sql");
			}

			sqlBillHd.append("insert into tblbillhd(strBillNo,strAdvBookingNo,dteBillDate" + ",strPOSCode,strSettelmentMode,dblDiscountAmt,dblDiscountPer" + ",dblTaxAmt,dblSubTotal,dblGrandTotal,strTakeAway,strOperationType" + ",strUserCreated,strUserEdited,dteDateCreated,dteDateEdited" + ",strClientCode,strTableNo,strWaiterNo,strCustomerCode,strManualBillNo" + ",intShiftCode,intPaxNo,strDataPostFlag,strReasonCode," + "strRemarks,dblTipAmount,dteSettleDate,strCounterCode,dblDeliveryCharges" + ",strCouponCode,strAreaCode,strDiscountOn,dblRoundOff,strTransactionType,dtBillDate,intOrderNo,dblUSDConverionRate)" + "(select '" + nwBillNo + "',strAdvBookingNo,dteBillDate" + ",strPOSCode,strSettelmentMode,dblDiscountAmt/('" + splitQty + "')" + ",dblDiscountPer,ROUND(dblTaxAmt)/('" + splitQty + "'),dblSubTotal/('" + splitQty + "')" + ",(dblSubTotal-dblDiscountAmt+ROUND(dblTaxAmt))/('" + splitQty + "')" + ",strTakeAway,strOperationType,strUserCreated,strUserEdited,dteDateCreated" + ",dteDateEdited,strClientCode,strTableNo,strWaiterNo,strCustomerCode" + ",strManualBillNo,intShiftCode,intPaxNo,strDataPostFlag,strReasonCode" + ",strRemarks,dblTipAmount,'" + clsGlobalVarClass.getPOSDateForTransaction() + "'" + ",strCounterCode,dblDeliveryCharges,strCouponCode,strAreaCode,strDiscountOn,dblRoundOff,concat(strTransactionType,',','SplitBill'),'" + posDate + "'" + ",intOrderNo,dblUSDConverionRate " + "from tblbillhd where strBillNo='" + billNo + "' " + "and date(dteBillDate)='" + posDate + "' )");

			objBaseService.funExecuteUpdate(sqlBillHd.toString(), "sql");

			sqlGT.append("select dblGrandTotal from tblbillhd " + " where strBillNo='" + nwBillNo + "' " + " and date(dteBillDate)='" + posDate + "' ");

			List rsGT = objBaseService.funGetList(sqlGT, "sql");
			if (rsGT.size() > 0)
			{

				for (int j = 0; j < rsGT.size(); i++)
				{
					Object[] obj = (Object[]) rsGT.get(j);
					double grandTotal = Double.parseDouble(obj[0].toString());
					// start code to calculate roundoff amount and round off by
					// amt
					Map<String, Double> mapRoundOff = objUtilityController.funCalculateRoundOffAmount(grandTotal, posCode);
					grandTotal = mapRoundOff.get("roundOffAmt");
					double grandTotalRoundOffBy = mapRoundOff.get("roundOffByAmt");
					// end code to calculate roundoff amount and round off by
					// amt

					objBaseService.funExecuteUpdate("update tblbillhd " + "set dblGrandTotal='" + grandTotal + "'" + ",dblRoundOff='" + grandTotalRoundOffBy + "'" + "where strBillNo='" + nwBillNo + "' " + "and date(dteBillDate)='" + posDate + "' ", "sql");
				}

			}
			sqlBillDiscDtl.append("insert into tblbilldiscdtl " + "(strBillNo,strPOSCode,dblDiscAmt,dblDiscPer,dblDiscOnAmt,strDiscOnType,strDiscOnValue " + ",strDiscReasonCode,strDiscRemarks,strUserCreated,strUserEdited,dteDateCreated,dteDateEdited " + ",strClientCode,strDataPostFlag,dteBillDate) " + "(select '" + nwBillNo + "',strPOSCode,dblDiscAmt/('" + splitQty + "'),dblDiscPer,dblDiscOnAmt/('" + splitQty + "'),strDiscOnType,strDiscOnValue " + ",strDiscReasonCode,strDiscRemarks,strUserCreated,'" + clsGlobalVarClass.gUserCode + "',dteDateCreated,'" + clsGlobalVarClass.getCurrentDateTime() + "' " + ",strClientCode,strDataPostFlag,'" + posDate + "' " + " from tblbilldiscdtl " + " where strBillNo='" + billNo + "' " + " and date(dteBillDate)='" + objGlobal.funGetCurrentDate("yyyy-MM-dd") + "' " + " )");
			objBaseService.funExecuteUpdate(sqlBillDiscDtl.toString(), "sql");

			// billsToBePrinted.put(nwBillNo,
			// clsGlobalVarClass.getPOSDateForTransaction());

		}
		String POSCode = "";
		StringBuilder sql = new StringBuilder();
		sql.append("select strPOSCode from tblbillhd " + " where strBillNo='" + billNo + "' " + " and date(dteBillDate)='" + posDate + "' ");
		List rsPOS = objBaseService.funGetList(sql, "sql");
		if (rsPOS.size() > 0)
		{
			for (int i = 0; i < rsPOS.size(); i++)
			{
				Object[] obj = (Object[]) taxList.get(i);
				POSCode = obj[0].toString();
			}
			// POSCode = rsPOS.getString(1);
		}
		sql.append("delete from tblbillhd where strBillNo='" + billNo + "' and date(dteBillDate)='" + posDate + "' ");
		objBaseService.funExecuteUpdate(sql.toString(), "sql");
		sql.append("delete from tblbilldtl where strBillNo='" + billNo + "' and date(dteBillDate)='" + posDate + "' ");
		objBaseService.funExecuteUpdate(sql.toString(), "sql");
		sql.append("delete from tblbilltaxdtl where strBillNo='" + billNo + "' and date(dteBillDate)='" + posDate + "' ");
		objBaseService.funExecuteUpdate(sql.toString(), "sql");
		sql.append("delete from tblbillmodifierdtl where strBillNo='" + billNo + "'");
		objBaseService.funExecuteUpdate(sql.toString(), "sql");
		sql.append("delete from tblbilldiscdtl where strBillNo='" + billNo + "' and date(dteBillDate)='" + posDate + "' ");
		objBaseService.funExecuteUpdate(sql.toString(), "sql");
		sql.append("delete from tblbillpromotiondtl where strBillNo='" + billNo + "' and date(dteBillDate)='" + posDate + "' ");
		objBaseService.funExecuteUpdate(sql.toString(), "sql");

		request.getSession().setAttribute("success", true);
		request.getSession().setAttribute("successMessage", "Bill Split Successfully ");
	}

	// Item Wise Type Wise Split
	// Pratiksha 06-05-2019
	@SuppressWarnings({ "unchecked", "unchecked" })
	@RequestMapping(value = "/loadItemTypeWiseSplit", method = RequestMethod.GET)
	private void funItemTypeWiseSplit(@RequestParam("billNo") String billNo, HttpServletRequest request)
	{
		StringBuilder sqlItemType = new StringBuilder();
		StringBuilder sqlItemTypeCount = new StringBuilder();
		String posCode = request.getSession().getAttribute("gPOSCode").toString();
		String clientCode = request.getSession().getAttribute("gClientCode").toString();
		String posDate = request.getSession().getAttribute("gPOSDate").toString().split(" ")[0];
		// listSplittedAmountOfItemsType = new ArrayList<>();

		// List arrListItemTypeWiseDtl = new ArrayList<>();

		try
		{
			sqlItemTypeCount.append("select a.strItemType " + " from tblitemmaster a,tblbilldtl b " + " where b.strBillNo='" + billNo + " '" + "and a.strItemCode=b.strItemCode " + " group by strItemType");
			List rsItemType = objBaseService.funGetList(sqlItemTypeCount, "sql"); // FOOD

			if (rsItemType != null)
			{
				for (int i = 0; i < rsItemType.size(); i++)
				{
					String obj = (String) rsItemType.get(i);
					listItemTypeForItemType.add(obj);
				}
			}

			if (listItemTypeForItemType.size() > 1)
			{
				for (int cnt = 0; cnt < listItemTypeForItemType.size(); cnt++)
				{
					List arrListItemTypeWiseDtl = new ArrayList<>();
					sqlItemType.append("select a.strItemCode,b.dblAmount,b.strItemName" + " ,b.dblQuantity,b.dblDiscountAmt,b.dblDiscountPer " + " from tblitemmaster a,tblbilldtl b " + " where a.strItemCode=b.strItemCode " + " and b.strBillNo='" + billNo + "' " + " and date(b.dteBillDate)='" + objGlobal.funGetCurrentDate("yyyy-MM-dd") + "' " + " and a.strItemType='" + listItemTypeForItemType.get(cnt).toString() + "'");
					// System.out.println(sqlItemType);
					List rsItemType1 = objBaseService.funGetList(sqlItemType, "sql");
					if (rsItemType1.size() > 0)
					{
						for (int i = 0; i < rsItemType1.size(); i++)
						{
							Object[] obj = (Object[]) rsItemType1.get(i);
							String itemDtl = obj[0].toString() + "#" + obj[1].toString() + "#" + obj[2].toString() + "#" + obj[3].toString() + "#" + obj[4].toString() + "#" + obj[5].toString();
							arrListItemTypeWiseDtl.add(itemDtl);
						}

					}

					hmItemTypeWiseBill.put(listItemTypeForItemType.get(cnt).toString(), arrListItemTypeWiseDtl);
				}
				funInsertNewDataItemTypeWise(billNo);
			}
			else
			{
				// new frmOkPopUp(null, "Only One Item Type Available", "Error",
				// 1).setVisible(true);
				request.getSession().setAttribute("success", true);
				request.getSession().setAttribute("successMessage", "Only One Item Type Available ");
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
	}

	private void funInsertNewDataItemTypeWise(String billNoItemType) throws Exception
	{
		String bill = billNoItemType;
		String insertQuery = "";
		int billCnt = 1;
		double dblTotalTaxAmt = 0.00;

		for (int cnt = 0; cnt < listItemTypeForItemType.size(); cnt++)
		{
			ArrayList arrListItemType = (ArrayList) hmItemTypeWiseBill.get(listItemTypeForItemType.get(cnt));
			double subTotal = 0;
			double finalDiscAmt = 0.00;
			double finalDiscPer = 0.00;
			String newBillNo = bill.concat("-") + billCnt;
			dblTotalTaxAmt = 0;
			List listTax = funCalculateTax(billedOperationType, arrListItemType);
		}
	}

	private List funCalculateTax(String operationType, List<String> arrListItemDtl)
	{
		List listTax = new ArrayList<ArrayList<Object>>();
		try
		{
			listTax = funCheckDateRangeForTax(operationType, arrListItemDtl);
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return listTax;
	}

	@SuppressWarnings("rawtypes")
	private ArrayList funCheckDateRangeForTax(String operationType, List<String> arrListItemDtl) throws Exception
	{
		String taxCode = "", taxName = "", taxOnGD = "", taxCal = "", taxIndicator = "";
		String opType = "", area = "", taxOnTax = "", taxOnTaxCode = "";
		double taxPercent = 0.00, taxableAmount = 0.00, taxCalAmt = 0.00;
		// String
		// posDate=request.getSession().getAttribute("POSDate").toString().split(" ")[0];

		ArrayList<Object> listTax = new ArrayList<Object>();
		StringBuilder sql_ChkTaxDate = new StringBuilder();
		StringBuilder sql_TaxOn = new StringBuilder();
		ArrayList<ArrayList<Object>> arrListTaxCal = new ArrayList<ArrayList<Object>>();
		clsGlobalVarClass.dbMysql.execute("truncate table tbltaxtemp;");// Empty
		// objBaseService.funExecuteUpdate(truncate table tbltaxtemp, "sql"); //
		// Tax
		// Temp
		// Table
		double subTotalForTax = 0;
		double discAmt = 0;
		double discPer = 0;

		sql_ChkTaxDate.append("select a.strTaxCode,a.strTaxDesc,a.strTaxOnSP,a.strTaxType,a.dblPercent " + " ,a.dblAmount,a.strTaxOnGD,a.strTaxCalculation,a.strTaxIndicator,a.strAreaCode,a.strOperationType " + " ,a.strItemType,a.strTaxOnTax,a.strTaxOnTaxCode " + " from tbltaxhd a,tbltaxposdtl b " + " where a.strTaxCode=b.strTaxCode and b.strPOSCode='" + clsGlobalVarClass.gPOSCode + "' " + " and date(a.dteValidFrom) <='" + dtPOSDate + "' " + " and date(a.dteValidTo)>='" + dtPOSDate + "' and a.strTaxOnSP='Sales' " + " order by a.strTaxOnTax,a.strTaxCode");
		List rsTax = objBaseService.funGetList(sql_ChkTaxDate, "sql");
		if (rsTax.size() > 0)
		{
			for (int i = 0; i < rsTax.size(); i++)
			{
				Object[] obj = (Object[]) rsTax.get(i);
				taxCode = obj[0].toString();
				taxName = obj[1].toString();
				taxPercent = Double.parseDouble(obj[4].toString());
				taxOnGD = obj[6].toString();
				taxCal = obj[7].toString();
				taxIndicator = obj[8].toString();
				taxOnTax = obj[12].toString();
				taxOnTaxCode = obj[13].toString();
				taxableAmount = 0.00;
				taxCalAmt = 0.00;
				sql_TaxOn.append("select strAreaCode,strOperationType,strItemType " + "from tbltaxhd where strTaxCode='" + taxCode + "'");
				List rsTaxOn = objBaseService.funGetList(sql_TaxOn, "sql");
				if (rsTaxOn.size() > 0)
				{
					for (int j = 0; j < rsTaxOn.size(); j++)
					{
						Object[] obj1 = (Object[]) rsTaxOn.get(j);
						area = obj1[0].toString();
						opType = obj1[1].toString();
					}

				}
				if (funCheckAreaCode(billedAreaCode, area))
				{
					if (funCheckOperationType(opType, operationType))
					{
						if (funFindSettlementForTax(taxCode, settlementCode))
						{
							boolean flgTaxOnGrpApplicable = false;
							taxableAmount = 0;
							listTax = new ArrayList<Object>();
							if (taxOnGD.equals("Gross"))
							{
								// to calculate tax on group of an item
								for (int j = 0; j < arrListItemDtl.size(); j++)
								{
									String[] spItemDtl = arrListItemDtl.get(i).toString().split("#");
									boolean isApplicable = isTaxApplicableOnItemGroup(taxCode, spItemDtl[0]);
									String itemCode = arrListItemDtl.get(i);
									String itemDetail = mapMainGridItemDetail.get(itemCode);
									String itemDetailArray[] = itemDetail.split("!");
									String itemName = itemDetailArray[0];
									String itemQty = itemDetailArray[1];
									double itemAmt = Double.parseDouble(itemDetailArray[2]);
									double itemDisc = Double.parseDouble(itemDetailArray[3]);

									boolean isApplicable1 = isTaxApplicableOnItemGroup(taxCode, itemCode);
									if (isApplicable1)
									{
										flgTaxOnGrpApplicable = true;
										taxableAmount = taxableAmount + itemAmt;

										if (taxOnTax.equalsIgnoreCase("Yes")) // For
																				// tax
																				// On
																				// Tax
																				// Calculation
																				// new
																				// logic
																				// only
																				// for
																				// same
																				// group
																				// item
										{
											taxableAmount = taxableAmount + funGetTaxableAmountForTaxOnTax(taxOnTaxCode, itemAmt, itemDisc, billedAreaCode, operationType, settlementCode);
										}
									}

								}
							}
							else
							{
								subTotalForTax = 0;
								discAmt = 0;
								for (String itemCode : arrListItemDtl)
								{

									String itemDetail = mapMainGridItemDetail.get(itemCode);
									String itemDetailArray[] = itemDetail.split("!");
									String itemName = itemDetailArray[0];
									String itemQty = itemDetailArray[1];
									double itemAmt = Double.parseDouble(itemDetailArray[2]);
									double itemDisc = Double.parseDouble(itemDetailArray[3]);

									boolean isApplicable = isTaxApplicableOnItemGroup(taxCode, itemCode);
									if (isApplicable)
									{
										flgTaxOnGrpApplicable = true;
										if (itemDisc > 0)
										{
											discAmt += itemDisc;
										}
										taxableAmount = taxableAmount + itemAmt;

										if (taxOnTax.equalsIgnoreCase("Yes")) // For
																				// tax
																				// On
																				// Tax
																				// Calculation
																				// new
																				// logic
																				// only
																				// for
																				// same
																				// group
																				// item
										{
											taxableAmount = taxableAmount + funGetTaxableAmountForTaxOnTax(taxOnTaxCode, itemAmt, itemDisc, billedAreaCode, operationType, settlementCode);
										}
									}
								}
								if (taxableAmount > 0)
								{
									taxableAmount = taxableAmount - discAmt;
								}
							}
							if (flgTaxOnGrpApplicable)
							{
								if (taxCal.equals("Forward")) // Forward Tax
																// Calculation
								{
									taxCalAmt = taxableAmount * (taxPercent / 100);
								}
								else
								// Backward Tax Calculation
								{
									taxCalAmt = taxableAmount - (taxableAmount * 100 / (100 + taxPercent));
								}

								listTax.add(taxCode);
								listTax.add(taxName);
								listTax.add(taxableAmount);
								listTax.add(taxCalAmt);
								listTax.add(taxCal);
								arrListTaxCal.add(listTax);
							}
						}
					}
				}

			}
		}
		return (ArrayList) arrListTaxCal;

	}

	private boolean funCheckAreaCode(String taxCode, String area)
	{
		boolean flgTaxOn = false;
		String[] spAreaCode = area.split(",");
		for (int cnt = 0; cnt < spAreaCode.length; cnt++)
		{
			if (spAreaCode[cnt].equals(billedAreaCode))
			{
				flgTaxOn = true;
				break;
			}
		}
		return flgTaxOn;
	}

	private boolean funCheckOperationType(String taxOperationType, String operationTypeForTax)
	{
		boolean flgTaxOn = false;
		if (operationTypeForTax.equalsIgnoreCase("DirectBiller"))
		{
			operationTypeForTax = "DineIn";
		}
		String[] spOpType = taxOperationType.split(",");
		for (int cnt = 0; cnt < spOpType.length; cnt++)
		{
			if (spOpType[cnt].equals("HomeDelivery") && operationTypeForTax.equalsIgnoreCase("HomeDelivery"))
			{
				flgTaxOn = true;
				break;
			}
			if (spOpType[cnt].equals("HomeDelivery") && operationTypeForTax.equalsIgnoreCase("Home Delivery"))
			{
				flgTaxOn = true;
				break;
			}
			if (spOpType[cnt].equals("DineIn") && operationTypeForTax.equalsIgnoreCase("DineIn"))
			{
				flgTaxOn = true;
				break;
			}
			if (spOpType[cnt].equals("DineIn") && operationTypeForTax.equalsIgnoreCase("Dine In"))
			{
				flgTaxOn = true;
				break;
			}
			if (spOpType[cnt].equals("TakeAway") && operationTypeForTax.equalsIgnoreCase("TakeAway"))
			{
				flgTaxOn = true;
				break;
			}
			if (spOpType[cnt].equals("TakeAway") && operationTypeForTax.equalsIgnoreCase("Take Away"))
			{
				flgTaxOn = true;
				break;
			}
		}
		return flgTaxOn;
	}

	private boolean funFindSettlementForTax(String taxCode, String settlementMode) throws Exception
	{
		boolean flgTaxSettlement = false;
		StringBuilder sql_SettlementTax = new StringBuilder();
		sql_SettlementTax.append("select strSettlementCode,strSettlementName " + "from tblsettlementtax where strTaxCode='" + taxCode + "' " + "and strApplicable='true' and strSettlementCode='" + settlementMode + "'");

		List rsTaxSettlement = objBaseService.funGetList(sql_SettlementTax, "sql");
		if (rsTaxSettlement.size() > 0)
		{
			flgTaxSettlement = true;
		}
		return flgTaxSettlement;
	}

	@SuppressWarnings("unused")
	private double funGetTaxAmountForTaxOnTax(String taxOnTaxCode) throws Exception
	{
		double taxAmt = 0;

		String[] spTaxOnTaxCode = taxOnTaxCode.split(",");
		for (int cnt = 0; cnt < arrListTaxCal.size(); cnt++)
		{
			for (int t = 0; t < spTaxOnTaxCode.length; t++)
			{
				arrListTax = arrListTaxCal.get(cnt);
				if (arrListTax.get(0).toString().equals(spTaxOnTaxCode[t]))
				{
					// taxableAmt +=
					// Double.parseDouble(arrListTax.get(2).toString()) +
					// Double.parseDouble(arrListTax.get(3).toString());
					taxAmt += Double.parseDouble(arrListTax.get(3).toString());
				}
			}
		}
		return taxAmt;
	}

	private boolean isTaxApplicableOnItemGroup(String taxCode, String itemCode)
	{
		boolean isApplicable = false;
		StringBuilder sql = new StringBuilder();
		try
		{
			sql.append("select a.strItemCode,a.strItemName,b.strSubGroupCode,b.strSubGroupName,c.strGroupCode,c.strGroupName,d.strTaxCode,d.strApplicable " + "from tblitemmaster a,tblsubgrouphd b,tblgrouphd c,tbltaxongroup d " + "where a.strSubGroupCode=b.strSubGroupCode " + "and b.strGroupCode=c.strGroupCode " + "and c.strGroupCode=d.strGroupCode " + "and a.strItemCode='" + itemCode.substring(0, 7) + "' " + "and d.strTaxCode='" + taxCode + "' " + "and d.strApplicable='true' ");
			List rsTaxApplicable = objBaseService.funGetList(sql, "sql");
			if (rsTaxApplicable.size() > 0)
			{
				isApplicable = true;
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			return isApplicable;
		}
	}

	// new logic for tax on tax
	private double funGetTaxableAmountForTaxOnTax(String taxOnTaxCode, double itemAmt, double itemDisc, String billAreaCode, String operationTypeForTax, String settlementCode) throws Exception
	{

		StringBuilder sqlTaxOnTax = new StringBuilder();
		StringBuilder sqlTaxOn = new StringBuilder();

		// 0 code
		// 1 name
		// 2 qty
		// 3 amt
		// 4 discAmt
		double taxAmt = 0;
		String[] spTaxOnTaxCode = taxOnTaxCode.split(",");
		String opType = "", taxAreaCodes = "";

		for (int t = 0; t < spTaxOnTaxCode.length; t++)
		{

			sqlTaxOn.append("select a.strTaxCode,a.strTaxDesc,a.strTaxOnSP,a.strTaxType,a.dblPercent " + ",a.dblAmount,a.strTaxOnGD,a.strTaxCalculation,a.strTaxIndicator,a.strAreaCode,a.strOperationType " + ",a.strItemType,a.strTaxOnTax,a.strTaxOnTaxCode " + "from tbltaxhd a,tbltaxposdtl b " + "where a.strTaxCode=b.strTaxCode and b.strPOSCode='" + clsGlobalVarClass.gPOSCode + "' " + "and date(a.dteValidFrom) <='" + dtPOSDate + "' " + "and date(a.dteValidTo)>='" + dtPOSDate + "' " + "and a.strTaxOnSP='Sales' " + "and  a.strTaxCode='" + spTaxOnTaxCode[t] + "' ");
			List rsTaxOn = objBaseService.funGetList(sqlTaxOn, "sql");
			if (rsTaxOn.size() > 0)
			{
				taxAreaCodes = (String) rsTaxOn.get(9);
				opType = (String) rsTaxOn.get(10);

				if (funCheckAreaCode(taxAreaCodes, billAreaCode))
				{
					if (funCheckOperationType(opType, operationTypeForTax))
					{
						if (funFindSettlementForTax(spTaxOnTaxCode[t], settlementCode))
						{

							sqlTaxOnTax.append("select a.strTaxCode,a.strTaxDesc,a.strTaxOnSP,a.strTaxType,a.dblPercent,a.dblAmount,a.dteValidFrom,a.dteValidTo,a.strTaxOnGD,a.strTaxCalculation,a.strTaxIndicator " + ",a.strTaxRounded,a.strTaxOnTax,a.strTaxOnTaxCode " + "from tbltaxhd a " + "where a.strTaxCode='" + spTaxOnTaxCode[t] + "' ");
							List rsTaxOnTax = objBaseService.funGetList(sqlTaxOnTax, "sql");
							if (rsTaxOnTax.size() > 0)
							{
								String taxCode = (String) rsTaxOnTax.get(0);
								String taxName = (String) rsTaxOnTax.get(1);
								String taxOnGD = (String) rsTaxOnTax.get(6);
								String taxCal = (String) rsTaxOnTax.get(7);
								String taxIndicator = (String) rsTaxOnTax.get(8);
								String taxOnTax = (String) rsTaxOnTax.get(12);
								// String taxOnTaxCode =
								// rsTaxOnTax.getString(14);
								double taxPercent = (double) rsTaxOnTax.get(5);

								if (taxOnGD.equals("Gross"))
								{
									taxAmt += (taxPercent / 100) * itemAmt;
								}
								else
								// discount
								{
									taxAmt += (taxPercent / 100) * (itemAmt - itemDisc);
								}
							}

						}
					}
				}
			}
		}
		return taxAmt;
	}

	// For Group Wise Split
	private void funGroupWiseSplit(String billNo)
	{

		StringBuilder sqlGroup = new StringBuilder();
		StringBuilder sql = new StringBuilder();
		// hmGroupWiseBill.clear();
		// hmSubGroupWiseBill.clear();
		try
		{
			sqlGroup.append("select d.strGroupCode " + " from tblbilldtl a " + " left outer join tblitemmaster b on a.strItemCode=b.strItemCode " + " left outer join tblsubgrouphd c on b.strSubGroupCode=c.strSubGroupCode " + " left outer join tblgrouphd d on c.strGroupCode=d.strGroupCode " + " where a.strBillNo='" + billNo + "' " + " and date(a.dteBillDate)='" + objGlobal.funGetCurrentDate("yyyy-MM-dd") + "' " + " group by d.strGroupCode");

			List rsGroup = objBaseService.funGetList(sqlGroup, "sql");
			for (int i = 0; i < rsGroup.size(); i++)
			{
				Object[] obj = (Object[]) rsGroup.get(i);
				List arrListGroupWiseDtl = new ArrayList<>();
				// items
				sql.append("select b.strItemCode,a.dblAmount,b.strItemName" + " ,a.dblQuantity,a.dblDiscountAmt,a.dblDiscountPer,c.strSubGroupName   " + " from tblbilldtl a " + " left outer join tblitemmaster b on a.strItemCode=b.strItemCode " + " left outer join tblsubgrouphd c on b.strSubGroupCode=c.strSubGroupCode " + " left outer join tblgrouphd d on c.strGroupCode=d.strGroupCode " + " where a.strBillNo='" + billNo + "' " + " and date(a.dteBillDate)='" + objGlobal.funGetCurrentDate("yyyy-MM-dd") + "' " + " and d.strGroupCode='" + rsGroup.getString(1) + "'");
				// System.out.println(sql);
				List rsGroup1 = objBaseService.funGetList(sql, "sql");
				for (int j = 0; j < rsGroup1.size(); j++)
				{
					Object[] obj1 = (Object[]) rsGroup1.get(j);
					String itemDtl = obj1[0].toString() + "#" + obj1[2].toString() + "#" + obj1[3].toString() + "#" + obj1[1].toString() + "#" + obj1[4].toString() + "#" + obj1[5].toString() + "#" + obj1[6].toString() + "#";
					arrListGroupWiseDtl.add(itemDtl);

				}

				// //modifiers
				sql = "SELECT a.strItemCode,a.dblAmount,a.strModifierName,a.dblQuantity,a.dblDiscAmt,a.dblDiscPer,c.strSubGroupName  " + " FROM tblbillmodifierdtl a " + " LEFT OUTER " + " JOIN tblitemmaster b ON left(a.strItemCode,7)=b.strItemCode " + " LEFT OUTER " + " JOIN tblsubgrouphd c ON b.strSubGroupCode=c.strSubGroupCode " + " LEFT OUTER " + " JOIN tblgrouphd d ON c.strGroupCode=d.strGroupCode " + " WHERE a.strBillNo='" + billNo + "' " + " and date(a.dteBillDate)='" + objGlobal.funGetCurrentDate("yyyy-MM-dd") + "' " + " AND d.strGroupCode='" + rsGroup.getString(1) + "' ";
				// System.out.println(sql);
				rsGroup1 = objBaseService.funGetList(sql, "sql");
				for (int k = 0; k < rsGroup1.size(); k++)
				{
					Object[] obj2 = (Object[]) rsGroup1.get(i);

					String itemDtl = obj2[0].toString() + "#" + obj2[2].toString() + "#" + obj2[3].toString() + "#" + obj2[1].toString() + "#" + obj2[4].toString() + "#" + obj2[5].toString() + "#" + obj2[6].toString() + "#";
				}

				hmGroupWiseBill.put(obj[0].toString(), arrListGroupWiseDtl);
			}
			if (hmGroupWiseBill.size() < 2)
			{
				new frmOkPopUp(null, "Can Not Split Only One Group Is Available.", "Error", 1).setVisible(true);
				return;
			}
			else
			{
				funInsertNewDataGroupWise(billNo);
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
	}

	private void funInsertNewDataGroupWise(String billNo) throws Exception
	{
		String bill = billNo;
		int billCnt = 1;
		ArrayList arrListGroupWiseItemDtl;
		StringBuilder sqlBillTax = new StringBuilder();
		StringBuilder sql = new StringBuilder();
		StringBuilder sqlBill = new StringBuilder();
		StringBuilder insertQuery = new StringBuilder();
		StringBuilder sqlGroupName = new StringBuilder();
		StringBuilder sqlBillDiscDtl = new StringBuilder();
		StringBuilder sqlTotal = new StringBuilder();
		StringBuilder sqlSubGroup = new StringBuilder();
		String sqlDisc;

		StringBuilder sqlDiscType = new StringBuilder();
		double dblTotalTaxAmt = 0.00;
		double subTotal, finalDiscAmt, discOnAmt, discounrAmt;
		double totalDiscount;
		String newBillNo;
		for (Map.Entry<String, List<Object>> entry : hmGroupWiseBill.entrySet())
		{
			String groupCode = entry.getKey();
			arrListGroupWiseItemDtl = (ArrayList) entry.getValue();
			subTotal = 0;
			totalDiscount = 0;
			newBillNo = bill.concat("-") + billCnt;
			dblTotalTaxAmt = 0;
			List listTax = funCalculateTax(billedOperationType, arrListGroupWiseItemDtl);
			for (int cntTax = 0; cntTax < listTax.size(); cntTax++)
			{
				// System.out.println(listTax.get(cntTax));
				ArrayList<Object> list = (ArrayList<Object>) listTax.get(cntTax);
				double dblTaxAmt = Double.parseDouble(list.get(3).toString());
				if (list.get(4).toString().equalsIgnoreCase("Forward"))
				{
					dblTotalTaxAmt = dblTotalTaxAmt + dblTaxAmt;
				}
				sqlBillTax.append("insert into tblbilltaxdtl " + "(strBillNo,strTaxCode,dblTaxableAmount,dblTaxAmount,strClientCode,dteBillDate) " + "values('" + newBillNo + "','" + list.get(0).toString() + "'," + list.get(2).toString() + "" + "," + dblTaxAmt + ",'" + clsGlobalVarClass.gClientCode + "','" + clsGlobalVarClass.getPOSDateForTransaction() + "')");

				objBaseService.funExecuteUpdate(sqlBillTax.toString(), "sql");

			}

			for (int cnt1 = 0; cnt1 < arrListGroupWiseItemDtl.size(); cnt1++)
			{
				String[] spItemDtl = arrListGroupWiseItemDtl.get(cnt1).toString().split("#");
				subTotal += Double.parseDouble(spItemDtl[3]);
				totalDiscount = totalDiscount + Double.parseDouble(spItemDtl[4]);
				double rate = Double.parseDouble(spItemDtl[3]) / Double.parseDouble(spItemDtl[2]);
				if (spItemDtl[0].contains("M"))
				{
					sql.append("insert into tblbillmodifierdtl" + " (select '" + newBillNo + "',strItemCode,strModifierCode,strModifierName" + " ,dblRate,dblQuantity,dblAmount,strClientCode,strCustomerCode" + " ,strDataPostFlag,strMMSDataPostFlag,strDefaultModifierDeselectedYN,strSequenceNo,dblDiscPer,dblDiscAmt,dteBillDate " + " from tblbillmodifierdtl " + " where strItemCode='" + spItemDtl[0] + "' " + " and strModifierName='" + spItemDtl[1] + "' " + " and strBillNo='" + bill + "' " + " and date(dteBillDate)='" + clsGlobalVarClass.gPOSOnlyDateForTransaction + "' )");
					objBaseService.funExecuteUpdate(sql.toString(), "sql");
				}
				else
				{
					sqlBill.append("select strKOTNo,strCustomerCode,tmeOrderProcessing" + " ,strManualKOTNo,tdhYN,strPromoCode " + " from tblbilldtl " + " where strBillNo='" + bill + "' " + " and strItemCode='" + spItemDtl[0] + "' " + " and date(dteBillDate)='" + objGlobal.funGetCurrentDate("yyyy-MM-dd") + "' ");
					List rsItemDtl = objBaseService.funGetList(sqlBill, "sql");
					if (rsItemDtl.size() > 0)
					{
						for (int i = 0; i < rsItemDtl.size(); i++)
						{
							Object[] obj = (Object[]) rsItemDtl.get(i);
							insertQuery.append("insert into tblbilldtl " + "(strItemCode,strItemName,strBillNo,dblRate" + ",dblQuantity,dblAmount,dblTaxAmount,dteBillDate" + ",strKOTNo,strClientCode,strCustomerCode,tmeOrderProcessing" + ",strManualKOTNo, tdhYN,strPromoCode,dblDiscountAmt,dblDiscountPer,dtBillDate) " + "values ('" + spItemDtl[0] + "','" + spItemDtl[1] + "','" + newBillNo + "'," + "'" + rate + "','" + spItemDtl[2] + "','" + spItemDtl[3] + "','0'," + "'" + dtBillDate + "','" + obj[0].toString() + "'," + "'" + clsGlobalVarClass.gClientCode + "','" + obj[1].toString() + "'," + "'" + obj[2].toString() + "','" + obj[3].toString() + "'," + "'" + obj[4].toString() + "','" + obj[5].toString() + "','" + spItemDtl[4] + "'," + "'" + spItemDtl[5] + "','" + clsGlobalVarClass.gPOSOnlyDateForTransaction + "' );");
							objBaseService.funExecuteUpdate(insertQuery.toString(), "sql");
							// clsGlobalVarClass.dbMysql.execute("update tblbillpromotiondtl set strBillNo='"
							// + newBillNo + "' "
							// + "where strBillNo='" + bill +
							// "' and strItemCode='" + spItemDtl[0] + "' ");

						}
					}
				}
				sqlDiscType.append("select * " + " from tblbilldiscdtl a  " + " where a.strBillNo='" + bill + "' " + " and date(a.dteBillDate)='" + objGlobal.funGetCurrentDate("yyyy-MM-dd") + "' ");
				List rsDiscType = objBaseService.funGetList(sqlDiscType, "sql");

				if (rsDiscType.size() > 0)
				{
					for (int i = 0; i < rsDiscType.size(); i++)
					{
						Object[] obj = (Object[]) rsDiscType.get(i);
						if (rsDiscType.contains("strDiscOnType") && spItemDtl[1].equals(rsDiscType.contains("strDiscOnValue")))
						{
							sqlDisc = "update tblbilldiscdtl  " + " set strBillNo='" + newBillNo + "' " + " where strBillNo='" + bill + "' " + " and date(dteBillDate)='" + objGlobal.funGetCurrentDate("yyyy-MM-dd") + "'" + " and strDiscOnType='ItemWise' " + " and strDiscOnValue='" + spItemDtl[1] + "' ";
							objBaseService.funExecuteUpdate(sqlDisc, "sql");
						}

					}
				}

				double grandTotal = subTotal + dblTotalTaxAmt - totalDiscount;
				StringBuilder sqlItemTypeWiseHd = new StringBuilder();

				// start code to calculate roundoff amount and round off by amt
				Map<String, Double> mapRoundOff = objUtility2.funCalculateRoundOffAmount(grandTotal, posCode);
				grandTotal = mapRoundOff.get("roundOffAmt");
				double grandTotalRoundOffBy = mapRoundOff.get("roundOffByAmt");
				// end code to calculate roundoff amount and round off by amt
				sqlItemTypeWiseHd.append("insert into tblbillhd" + "(strBillNo,strAdvBookingNo,dteBillDate,strPOSCode" + ",strSettelmentMode,dblDiscountAmt,dblDiscountPer,dblTaxAmt" + ",dblSubTotal,dblGrandTotal,strTakeAway,strOperationType" + ",strUserCreated,strUserEdited,dteDateCreated,dteDateEdited" + ",strClientCode,strTableNo,strWaiterNo,strCustomerCode" + ",strManualBillNo,intShiftCode,intPaxNo,strDataPostFlag" + ",strReasonCode,strRemarks,dblTipAmount,dteSettleDate" + ",strCounterCode,dblDeliveryCharges,strCouponCode,strAreaCode,strDiscountOn,dblRoundOff,strTransactionType,dtBillDate" + ",intOrderNo,dblUSDConverionRate ) " + "(select '" + newBillNo + "',strAdvBookingNo,dteBillDate" + ",strPOSCode,strSettelmentMode,'" + totalDiscount + "'" + ",'" + (totalDiscount * 100) / subTotal + "','" + dblTotalTaxAmt + "','" + subTotal + "','" + grandTotal + "'" + ",strTakeAway,strOperationType,strUserCreated,strUserEdited,dteDateCreated" + ",dteDateEdited,strClientCode,strTableNo,strWaiterNo,strCustomerCode" + ",strManualBillNo,intShiftCode,intPaxNo,strDataPostFlag" + ",strReasonCode,strRemarks,dblTipAmount,'" + clsGlobalVarClass.getPOSDateForTransaction() + "'" + ",strCounterCode,dblDeliveryCharges,strCouponCode,strAreaCode,strDiscountOn,'" + grandTotalRoundOffBy + "'" + ",CONCAT(strTransactionType,',','SplitBill'),'" + objGlobal.funGetCurrentDate("yyyy-MM-dd") + "'" + ",intOrderNo,dblUSDConverionRate " + " from tblbillhd " + " where strBillNo='" + bill + "' " + " and date(dteBillDate)='" + objGlobal.funGetCurrentDate("yyyy-MM-dd") + "' )");
				objBaseService.funExecuteUpdate(sqlItemTypeWiseHd.toString(), "sql");

				sqlGroupName.append("select a.strGroupName from tblgrouphd a " + "where a.strGroupCode='" + groupCode + "' ");
				List rsGroupName = objBaseService.funGetList(sqlGroupName, "sql");
				StringBuilder sqlDiscType1 = new StringBuilder();
				if (rsGroupName.size() > 0)
				{
					for (int i = 0; i < rsGroupName.size(); i++)
					{
						Object[] obj = (Object[]) rsGroupName.get(i);

						sqlDiscType1.append("select * " + " from tblbilldiscdtl a  " + " where a.strBillNo='" + bill + "' " + " and date(a.dteBillDate)='" + objGlobal.funGetCurrentDate("yyyy-MM-dd") + "'" + " and strDiscOnValue='" + obj[0].toString() + "' ");
						while (rsDiscType.size() > 0)
						{

							Object[] obj1 = (Object[]) rsDiscType.get(i);
							if (rsDiscType.contains("strDiscOnType").equals("GroupWise") && obj[0].equals(rsDiscType.contains("strDiscOnValue")))
							{
								if (totalDiscount > 0)
								{
									double discOnAmount = subTotal;
									double discPercent = (totalDiscount * 100) / subTotal;
									sqlBillDiscDtl.append("insert into tblbilldiscdtl " + "(strBillNo,strPOSCode,dblDiscAmt,dblDiscPer,dblDiscOnAmt,strDiscOnType,strDiscOnValue " + ",strDiscReasonCode,strDiscRemarks,strUserCreated,strUserEdited,dteDateCreated,dteDateEdited " + ",strClientCode,strDataPostFlag,dteBillDate) " + "(select '" + newBillNo + "',strPOSCode,'" + totalDiscount + "',dblDiscPer,'" + discOnAmount + "',strDiscOnType,strDiscOnValue " + ",strDiscReasonCode,strDiscRemarks,strUserCreated,'" + clsGlobalVarClass.gUserCode + "',dteDateCreated,'" + clsGlobalVarClass.getCurrentDateTime() + "' " + ",strClientCode,strDataPostFlag,'" + objGlobal.funGetCurrentDate("yyyy-MM-dd") + "' " + " from tblbilldiscdtl " + " where strBillNo='" + bill + "' " + " and date(dteBillDate)='" + objGlobal.funGetCurrentDate("yyyy-MM-dd") + "' " + " and strDiscOnType='GroupWise'" + " and strDiscOnValue='" + rsGroupName.getString(1) + "' " + ")");
									objBaseService.funExecuteUpdate(sqlBillDiscDtl.toString(), "sql");
								}
							}
						}
					}
					// subGroup wise discount

					sqlSubGroup.append("select * " + " from tblbilldiscdtl a " + " where a.strBillNo='" + bill + "' " + " and date(a.dteBillDate)='" + objGlobal.funGetCurrentDate("yyyy-MM-dd") + "' " + " and a.strDiscOnType='SubGroupWise'");
					List rsSubGroup = objBaseService.funGetList(sqlSubGroup, "sql");

					while (rsSubGroup.size() > 0)
					{
						String discOnValue = rsSubGroup.getString("strDiscOnValue");
						subTotal = 0.00;
						totalDiscount = 0.00;
						for (int cnt1 = 0; cnt1 < arrListGroupWiseItemDtl.size(); cnt1++)
						{
							String[] spItemDtl = arrListGroupWiseItemDtl.get(cnt1).toString().split("#");
							if (spItemDtl[6].equals(discOnValue))
							{
								subTotal += Double.parseDouble(spItemDtl[3]);
								totalDiscount = totalDiscount + Double.parseDouble(spItemDtl[4]);
							}
						}
						if (totalDiscount > 0)
						{
							double discOnAmount = subTotal;
							double discPercent = (totalDiscount * 100) / subTotal;
							sqlBillDiscDtl.append("insert into tblbilldiscdtl " + "(strBillNo,strPOSCode,dblDiscAmt,dblDiscPer,dblDiscOnAmt,strDiscOnType,strDiscOnValue " + ",strDiscReasonCode,strDiscRemarks,strUserCreated,strUserEdited,dteDateCreated,dteDateEdited " + ",strClientCode,strDataPostFlag,dteBillDate) " + "(select '" + newBillNo + "',strPOSCode,'" + totalDiscount + "',dblDiscPer,'" + discOnAmount + "',strDiscOnType,strDiscOnValue " + ",strDiscReasonCode,strDiscRemarks,strUserCreated,'" + clsGlobalVarClass.gUserCode + "',dteDateCreated,'" + objGlobal.funGetCurrentDateTime("yyyy-MM-dd") + "' " + ",strClientCode,strDataPostFlag,'" + objGlobal.funGetCurrentDate("yyyy-MM-dd") + "' " + " from tblbilldiscdtl " + " where strBillNo='" + bill + "' " + " and date(dteBillDate)='" + objGlobal.funGetCurrentDate("yyyy-MM-dd") + "' " + " and strDiscOnType='SubGroupWise'" + " and strDiscOnValue='" + discOnValue + "' " + ")");
							objBaseService.funExecuteUpdate(sqlBillDiscDtl.toString(), "sql");
						}

					}
					// Total wise discount
					sqlTotal.append("select * " + " from tblbilldiscdtl a " + " where a.strBillNo='" + bill + "' " + " and date(a.dteBillDate)='" + objGlobal.funGetCurrentDate("yyyy-MM-dd") + "' " + " and a.strDiscOnType='Total'  ");
					List rsTotal = objBaseService.funGetList(sqlTotal, "sql");
					while (rsTotal.size() > 0)
					{
						String discOnValue = rsTotal.getString("strDiscOnValue");
						subTotal = 0.00;
						totalDiscount = 0.00;
						for (int cnt1 = 0; cnt1 < arrListGroupWiseItemDtl.size(); cnt1++)
						{
							String[] spItemDtl = arrListGroupWiseItemDtl.get(cnt1).toString().split("#");

							subTotal += Double.parseDouble(spItemDtl[3]);
							totalDiscount = totalDiscount + Double.parseDouble(spItemDtl[4]);

						}
						if (totalDiscount > 0)
						{
							double discOnAmount = subTotal;
							double discPercent = (totalDiscount * 100) / subTotal;
							sqlBillDiscDtl.append("insert into tblbilldiscdtl " + "(strBillNo,strPOSCode,dblDiscAmt,dblDiscPer,dblDiscOnAmt,strDiscOnType,strDiscOnValue " + ",strDiscReasonCode,strDiscRemarks,strUserCreated,strUserEdited,dteDateCreated,dteDateEdited " + ",strClientCode,strDataPostFlag,dteBillDate) " + "(select '" + newBillNo + "',strPOSCode,'" + totalDiscount + "',dblDiscPer,'" + discOnAmount + "',strDiscOnType,strDiscOnValue " + ",strDiscReasonCode,strDiscRemarks,strUserCreated,'" + clsGlobalVarClass.gUserCode + "',dteDateCreated,'" + clsGlobalVarClass.getCurrentDateTime() + "' " + ",strClientCode,strDataPostFlag,'" + clsGlobalVarClass.getPOSDateForTransaction() + "' " + " from tblbilldiscdtl " + " where strBillNo='" + bill + "' " + " and date(dteBillDate)='" + objGlobal.funGetCurrentDate("yyyy-MM-dd") + "' " + " and strDiscOnType='Total'" + " and strDiscOnValue='" + discOnValue + "' " + ")");
							objBaseService.funExecuteUpdate(sqlBillDiscDtl.toString(), "sql");
						}
						billsToBePrinted.put(newBillNo, objGlobal.funGetCurrentDate("yyyy-MM-dd"));
						billCnt++;
					}

				}
			}

		}
		String POSCode = "";
		sql.append("select strPOSCode from tblbillhd " + " where strBillNo='" + bill + "' " + " and date(dteBillDate)='" + objGlobal.funGetCurrentDate("yyyy-MM-dd") + "' ");

		List rsPOS = objBaseService.funGetList(sql, "sql");
		if (rsPOS.size() > 0)
		{
			POSCode = (String) rsPOS.get(0);
		}
		sql.append("delete from tblbilltaxdtl where strBillNo='" + bill + "' and date(dteBillDate)='" + objGlobal.funGetCurrentDate("yyyy-MM-dd") + "' ");
		objBaseService.funExecuteUpdate(sql.toString(), "sql");
		sql.append("delete from tblbillmodifierdtl where strBillNo='" + bill + "' and date(dteBillDate)='" + objGlobal.funGetCurrentDate("yyyy-MM-dd") + "' ");
		objBaseService.funExecuteUpdate(sql.toString(), "sql");
		sql.append("delete from tblbilldtl where strBillNo='" + bill + "' and date(dteBillDate)='" + objGlobal.funGetCurrentDate("yyyy-MM-dd") + "' ");
		objBaseService.funExecuteUpdate(sql.toString(), "sql");
		sql.append("delete from tblbillhd where strBillNo='" + bill + "' and date(dteBillDate)='" + objGlobal.funGetCurrentDate("yyyy-MM-dd") + "' ");
		objBaseService.funExecuteUpdate(sql.toString(), "sql");
		sql.append("delete from tblbilldiscdtl where strBillNo='" + bill + "' and date(dteBillDate)='" + objGlobal.funGetCurrentDate("yyyy-MM-dd") + "' ");
		objBaseService.funExecuteUpdate(sql.toString(), "sql");
		sql.append("delete from tblbillpromotiondtl where strBillNo='" + bill + "' and date(dteBillDate)='" + objGlobal.funGetCurrentDate("yyyy-MM-dd") + "' ");
		objBaseService.funExecuteUpdate(sql.toString(), "sql");
		// new frmOkPopUp(null, "Bill Split Successfully", "Successfull",
		// 1).setVisible(true);
	}
}
*/