/*package com.sanguine.webpos.controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sanguine.base.service.clsSetupService;
import com.sanguine.base.service.intfBaseService;
import com.sanguine.webpos.bean.clsPOSBillHd;
import com.sanguine.webpos.bean.clsPOSReportBean;
import com.sanguine.webpos.model.clsCostCenterMasterModel;
import com.sanguine.webpos.model.clsGroupMasterModel;
import com.sanguine.webpos.model.clsSettlementMasterModel;
import com.sanguine.webpos.model.clsShiftMasterModel;
import com.sanguine.webpos.model.clsWaiterMasterModel;
import com.sanguine.webpos.sevice.clsPOSMasterService;
import com.sanguine.webpos.sevice.clsPOSReportService;

@Controller
public class clsPOSShiftWiseSalesSummaryFlash
{
	@Autowired
	private clsPOSReportService objReportService;

	@Autowired
	private clsPOSMasterService objMasterService;

	@Autowired
	intfBaseService objBaseService;

	@Autowired
	private clsSetupService objSetupService;

	Map posMap = new TreeMap();
	Map settlementMap = new TreeMap();
	Map shiftMap = new TreeMap();
	Map groupMap = new TreeMap();
	private Map<String, String> mapAllTaxes;
	private HashMap<String, String> mapDayGrandTotal;
	private HashMap<String, String> mapDayNetTotal;
	List ShiftType;
	double totalGroupAmtTotal;
	double totalDiscAmtTotal,totalSettleAmount,totalTaxAmount;
	String selectedPOSName;

	@RequestMapping(value = "/frmShiftWiseSalesSummaryFlash", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model, HttpServletRequest request) throws Exception
	{
		String strClientCode = request.getSession().getAttribute("gClientCode").toString();
		String POSCode = request.getSession().getAttribute("loginPOS").toString();
		StringBuilder sb = new StringBuilder();
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

		// POS Name
		posMap.put("All", "All");
		List listOfPos = objMasterService.funFillPOSCombo(strClientCode);
		if (listOfPos != null)
		{
			for (int i = 0; i < listOfPos.size(); i++)
			{
				Object[] obj = (Object[]) listOfPos.get(i);
				posMap.put(obj[0].toString(), obj[1].toString());
			}
		}
		model.put("posList", posMap);

		// SettleMent
		settlementMap.put("ALL", "ALL");
		List listOfSettlement = objMasterService.funFillSettlementCombo(strClientCode);
		if (listOfSettlement != null)
		{
			for (int i = 0; i < listOfSettlement.size(); i++)
			{
				clsSettlementMasterModel objModel = (clsSettlementMasterModel) listOfSettlement.get(i);
				settlementMap.put(objModel.getStrSettelmentCode(), objModel.getStrSettelmentDesc());
			}
		}
		model.put("settlementList", settlementMap);

		Map objSetupParameter = objSetupService.funGetParameterValuePOSWise(strClientCode, POSCode, "gEnableShiftYN");
		model.put("gEnableShiftYN", objSetupParameter.get("gEnableShiftYN").toString());

		// Shift
		List shiftList = new ArrayList();
		shiftList.add("All");
		List listShiftData = objReportService.funGetPOSWiseShiftList(POSCode, request);
		if (listShiftData != null)
		{
			for (int cnt = 0; cnt < listShiftData.size(); cnt++)
			{
				clsShiftMasterModel objShiftModel = (clsShiftMasterModel) listShiftData.get(cnt);
				shiftList.add(objShiftModel.getIntShiftCode());

			}
		}
		model.put("shiftList", shiftList);

		// Group
		groupMap.put("ALL", "ALL");
		List listOfGroup = objMasterService.funFillAllGroupList(strClientCode);
		if (listOfGroup != null)
		{
			for (int i = 0; i < listOfGroup.size(); i++)
			{
				clsGroupMasterModel objModel = (clsGroupMasterModel) listOfGroup.get(i);
				groupMap.put(objModel.getStrGroupCode(), objModel.getStrGroupName());
			}
		}
		model.put("groupList", groupMap);

		String posDate = request.getSession().getAttribute("gPOSDate").toString();
		request.setAttribute("POSDate", posDate);

		if ("2".equalsIgnoreCase(urlHits))
		{

			return new ModelAndView("frmShiftWiseSalesSummaryFlash_1", "command", new clsPOSReportBean());
		}
		else if ("1".equalsIgnoreCase(urlHits))
		{
			return new ModelAndView("frmShiftWiseSalesSummaryFlash", "command", new clsPOSReportBean());
		}
		else
		{
			return null;
		}

	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = { "/loadShiftWiseSummaryFlash" }, method = RequestMethod.GET)
	@ResponseBody
	public Map funLoadKDSFlash(HttpServletRequest req) throws Exception
	{
		LinkedHashMap resMap = new LinkedHashMap();
		resMap.put("status", "Found");
		String clientCode = req.getSession().getAttribute("gClientCode").toString();
		String POSCode = req.getSession().getAttribute("loginPOS").toString();

		String fromDate = req.getParameter("fromDate");

		String toDate = req.getParameter("toDate");

		String ShiftCode = req.getParameter("ShiftCode");
		String posCode = req.getParameter("posName");
		String SettleName = req.getParameter("SettleName");
		String GroupName = req.getParameter("GroupName");
		String OperationType = req.getParameter("OperationType");
		String strShiftNo = "1";
		Map objSetupParameter = objSetupService.funGetParameterValuePOSWise(clientCode, POSCode, "gEnableShiftYN");

		resMap = funGetData(clientCode, fromDate, toDate, objSetupParameter.get("gEnableShiftYN").toString(), ShiftCode, posCode, SettleName, GroupName, OperationType);
		if (resMap.size() == 0)
		{
			resMap.put("status", "Not Found");
		}

		return resMap;
	}

	private LinkedHashMap funGetData(String clientCode, String fromDate, String toDate, String enableShiftYN, String shiftCode, String posCode, String settleName, String groupName, String operationType) throws Exception
	{
		// TODO Auto-generated method stub

		LinkedHashMap resMap = new LinkedHashMap();
		Vector<String> dateCol = new Vector<>();
		Vector<String> posCol = new Vector<>();
		Vector<String> shiftCol = new Vector<>();
		Vector<String> paxCol = new Vector<>();
		StringBuilder sb = new StringBuilder();
		Map mapBillDate = new LinkedHashMap();
		List list = new ArrayList();
		List colHeader = new ArrayList();
		int colCount = 0, rowCount = 0;
		colHeader.add(" ");

		String fromDate1 = fromDate.split("-")[2] + "-" + fromDate.split("-")[1] + "-" + fromDate.split("-")[0];
		String toDate1 = toDate.split("-")[2] + "-" + toDate.split("-")[1] + "-" + toDate.split("-")[0];

		// fill Q Date and POS
		sb.setLength(0);

		sb.append("select a.intShiftCode,DATE_FORMAT(DATE(a.dteBillDate),'%d-%m-%Y'),sum(a.intPaxNo) \n" + "from tblqbillhd a\n" + "where  date(a.dteBillDate) between '" + fromDate + "' and '" + toDate + "' ");

		if (enableShiftYN.equalsIgnoreCase("Y") && (!shiftCode.equalsIgnoreCase("All")))
		{
			sb.append("and a.intShiftCode='" + shiftCode + "' ");
		}
		sb.append(" group by a.intShiftCode,date(a.dteBillDate)  order by date(a.dteBillDate),a.intShiftCode;");

		List rsSales = objBaseService.funGetList(sb, "sql");

		if (rsSales.size() > 0)
		{
			for (int i = 0; i < rsSales.size(); i++)
			{
				Object[] obj = (Object[]) rsSales.get(i);
				mapBillDate.put(obj[0].toString() + " " + obj[1].toString(), obj[0].toString() + " " + obj[1].toString() + " " + obj[2].toString());

			}
		}
		// fill Live Date and POS
		sb.setLength(0);

		sb.append("select a.intShiftCode,DATE_FORMAT(DATE(a.dteBillDate),'%d-%m-%Y'),sum(a.intPaxNo) \n" + "from tblbillhd a\n" + "where  date(a.dteBillDate) between '" + fromDate1 + "' and '" + toDate1 + "' ");
		if (!shiftCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.intShiftCode='" + shiftCode + "' ");
		}

		if (!posCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.strPOSCode='" + posCode + "' ");
		}

		sb.append(" group by a.intShiftCode,date(a.dteBillDate)  order by date(a.dteBillDate),a.intShiftCode;");
		rsSales = objBaseService.funGetList(sb, "sql");

		if (rsSales.size() > 0)
		{
			for (int i = 0; i < rsSales.size(); i++)
			{
				Object[] obj = (Object[]) rsSales.get(i);
				mapBillDate.put(obj[0].toString() + " " + obj[1].toString(), obj[0].toString() + " " + obj[1].toString() + " " + obj[2].toString());

			}
		}
		Iterator<String> itBillDate = mapBillDate.keySet().iterator();
		while (itBillDate.hasNext())
		{

			String strDataShiftPaxKey = itBillDate.next();
			String strDataShiftPaxValue = (String) mapBillDate.get(strDataShiftPaxKey);
			String strSplitDataShiftPax[] = strDataShiftPaxValue.split(" ");
			shiftCol.add(strSplitDataShiftPax[0]);
			dateCol.add(strSplitDataShiftPax[1]);
			paxCol.add(strSplitDataShiftPax[2]);
			posCol.add(posCode.toUpperCase());
		}

		Map<String, String> mapGroups = new HashMap<>();
		// add group columns
		sb.setLength(0);

		// live groups
		sb.setLength(0);
		sb.append("select  g.strGroupCode,g.strGroupName " + "from tblbillhd a,tblbilldtl b,tblitemmaster e " + ",tblsubgrouphd f ,tblgrouphd g  " + "where a.strBillNo=b.strBillNo " + "and date(a.dteBillDate)=date(b.dteBillDate) " + "and b.strItemCode=e.strItemCode " + "and e.strSubGroupCode=f.strSubGroupCode " + "and f.strGroupCode=g.strGroupCode "
		// + "AND b.dblAmount>0  "
		+ "AND DATE(a.dteBillDate) BETWEEN '" + fromDate1 + "' and '" + fromDate1 + "' ");
		if (!operationType.equalsIgnoreCase("All"))
		{
			sb.append("and a.strOperationType='" + operationType.toString() + "' ");
		}
		if (!posCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.strPOSCode='" + posCode + "' ");
		}
		if (!groupName.equalsIgnoreCase("All"))
		{
			sb.append(" and g.strGroupCode='" + groupMap.get(groupName.toString()) + "' ");
		}
		if (!shiftCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.intShiftCode='" + shiftCode + "' ");
		}

		sb.append(" GROUP BY g.strGroupCode,g.strGroupName ");
		List rsGroups = objBaseService.funGetList(sb, "sql");

		if (rsGroups.size() > 0)
		{
			for (int i = 0; i < rsGroups.size(); i++)

			{
				Object[] obj = (Object[]) rsGroups.get(i);

				mapGroups.put(obj[1].toString(), obj[1].toString());

			}
		}
		// Q groups
		sb.setLength(0);
		sb.append("select  g.strGroupCode,g.strGroupName " + "from tblqbillhd a,tblqbilldtl b,tblitemmaster e " + ",tblsubgrouphd f ,tblgrouphd g  " + "where a.strBillNo=b.strBillNo " + "and date(a.dteBillDate)=date(b.dteBillDate) " + "and b.strItemCode=e.strItemCode " + "and e.strSubGroupCode=f.strSubGroupCode " + "and f.strGroupCode=g.strGroupCode "
		// + "AND b.dblAmount>0  "
		+ "AND DATE(a.dteBillDate) BETWEEN '" + fromDate1 + "' and '" + fromDate1 + "' ");

		if (!operationType.toString().equalsIgnoreCase("All"))
		{
			sb.append("and a.strOperationType='" + operationType.toString() + "' ");
		}
		if (!posCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.strPOSCode='" + posCode + "' ");
		}
		if (!groupName.toString().equalsIgnoreCase("All"))
		{
			sb.append(" and g.strGroupCode='" + groupMap.get(groupName.toString()) + "' ");
		}
		if (!shiftCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.intShiftCode='" + shiftCode + "' ");
		}
		sb.append(" GROUP BY g.strGroupCode,g.strGroupName ");

		rsGroups = objBaseService.funGetList(sb, "sql");

		if (rsGroups.size() > 0)
		{
			for (int i = 0; i < rsGroups.size(); i++)

			{
				Object[] obj = (Object[]) rsGroups.get(i);

				mapGroups.put(obj[1].toString(), obj[1].toString());

			}
		}

		// //filling groups in table columns: Needs to be added
		Map<String, String> mapSettlements = new HashMap<String, String>();
		// fill Q settlement whoes amt>0
		sb.setLength(0);
		sb.append("SELECT c.strSettelmentDesc " + "FROM tblqbillhd a,tblqbillsettlementdtl b,tblsettelmenthd c " + "WHERE a.strBillNo=b.strBillNo  " + "and date(a.dteBillDate)=date(b.dteBillDate) " + "AND b.strSettlementCode=c.strSettelmentCode  " + "and b.dblSettlementAmt>0 " + "and date(a.dteBillDate) between '" + fromDate1 + "' and '" + toDate1 + "' ");
		if (!operationType.toString().equalsIgnoreCase("All"))
		{
			sb.append("and a.strOperationType='" + operationType.toString() + "' ");
		}
		if (!posCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.strPOSCode='" + posCode + "' ");
		}
		if (!groupName.toString().equalsIgnoreCase("All"))
		{
			sb.append(" and g.strGroupCode='" + groupMap.get(groupName.toString()) + "' ");
		}
		if (!settleName.toString().equalsIgnoreCase("All"))
		{
			sb.append(" and c.strSettelmentCode='" + settlementMap.get(settleName.toString()) + "' ");
		}

		if (!shiftCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.intShiftCode='" + shiftCode + "' ");
		}
		sb.append("GROUP BY strSettelmentDesc " + "ORDER BY strSettelmentDesc; ");
		rsSales = objBaseService.funGetList(sb, "sql");

		if (rsSales.size() > 0)
		{
			for (int i = 0; i < rsSales.size(); i++)

			{
				Object[] obj = (Object[]) rsSales.get(i);

				settlementMap.put(obj[1].toString(), obj[1].toString());

			}
		}
		sb.setLength(0);
		sb.append("SELECT c.strSettelmentDesc " + "FROM tblbillhd a,tblbillsettlementdtl b,tblsettelmenthd c " + "WHERE a.strBillNo=b.strBillNo  " + "and date(a.dteBillDate)=date(b.dteBillDate) " + "AND b.strSettlementCode=c.strSettelmentCode  " + "and b.dblSettlementAmt>0 " + "and date(a.dteBillDate) between '" + fromDate1 + "' and '" + toDate1 + "' ");
		if (!operationType.toString().equalsIgnoreCase("All"))
		{
			sb.append("and a.strOperationType='" + operationType.toString() + "' ");
		}
		if (!posCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.strPOSCode='" + posCode + "' ");
		}
		if (!groupName.toString().equalsIgnoreCase("All"))
		{
			sb.append(" and g.strGroupCode='" + groupMap.get(groupName.toString()) + "' ");
		}
		if (!settleName.toString().equalsIgnoreCase("All"))
		{
			sb.append(" and c.strSettelmentCode='" + settlementMap.get(settleName.toString()) + "' ");
		}

		if (!shiftCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.intShiftCode='" + shiftCode + "' ");
		}
		sb.append("GROUP BY strSettelmentDesc " + "ORDER BY strSettelmentDesc; ");

		String taxCalType = "";
		// fill TAX
		// /live
		sb.setLength(0);
		sb.append("select distinct(a.strTaxCode),a.strTaxDesc,a.strTaxCalculation  " + "from tbltaxhd a,tblbilltaxdtl b " + "where a.strTaxCode=b.strTaxCode " + "and date(b.dteBillDate) between '" + fromDate1 + "' and '" + toDate1 + "' ");
		List rsAllTaxes = objBaseService.funGetList(sb, "sql");

		if (rsAllTaxes.size() > 0)
		{
			for (int i = 0; i < rsAllTaxes.size(); i++)

			{
				Object[] obj = (Object[]) rsAllTaxes.get(i);

				taxCalType = obj[2].toString().trim();
				mapAllTaxes.put(obj[0].toString(), obj[1].toString());
			}
		}
		// /Qfile
		String columnForSalesAmount = "sum(b.dblAmount) ";

		sb.setLength(0);
		sb.append("select distinct(a.strTaxCode),a.strTaxDesc,a.strTaxCalculation  " + "from tbltaxhd a,tblqbilltaxdtl b " + "where a.strTaxCode=b.strTaxCode " + "and date(b.dteBillDate) between '" + fromDate1 + "' and '" + toDate1 + "' ");
		rsAllTaxes = rsAllTaxes = objBaseService.funGetList(sb, "sql");
		if (rsAllTaxes.size() > 0)
		{
			for (int i = 0; i < rsAllTaxes.size(); i++)

			{
				Object[] obj = (Object[]) rsAllTaxes.get(i);

				taxCalType = obj[2].toString().trim();
				mapAllTaxes.put(obj[0].toString(), obj[1].toString());
			}
		}

		// All header data filled till here

		// fill Q data group
		sb.setLength(0);
		sb.append("select a.intShiftCode,DATE_FORMAT(DATE(a.dteBillDate),'%d-%m-%Y'),g.strGroupName," + columnForSalesAmount + ",sum(b.dblDiscountAmt),sum(b.dblAmount)-sum(b.dblDiscountAmt) " + "from tblqbillhd a,tblqbilldtl b,tblitemmaster e " + ",tblsubgrouphd f ,tblgrouphd g  " + "where a.strBillNo=b.strBillNo " + "and date(a.dteBillDate)=date(b.dteBillDate) " + "and b.strItemCode=e.strItemCode " + "and e.strSubGroupCode=f.strSubGroupCode " + "and f.strGroupCode=g.strGroupCode "
		// + "AND b.dblAmount>0  "
		+ "AND DATE(a.dteBillDate) BETWEEN '" + fromDate + "' and '" + toDate + "' ");

		if (!operationType.toString().equalsIgnoreCase("All"))
		{
			sb.append("and a.strOperationType='" + operationType.toString() + "' ");
		}
		if (!posCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.strPOSCode='" + posCode + "' ");
		}
		if (!groupName.toString().equalsIgnoreCase("All"))
		{
			sb.append(" and g.strGroupCode='" + groupMap.get(groupName.toString()) + "' ");
		}
		if (!settleName.toString().equalsIgnoreCase("All"))
		{
			sb.append(" and c.strSettelmentCode='" + settlementMap.get(settleName.toString()) + "' ");
		}

		if (!shiftCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.intShiftCode='" + shiftCode + "' ");
		}

		sb.append(" GROUP BY a.intShiftCode,DATE(a.dteBillDate),g.strGroupCode,g.strGroupName ");
		sb.append("Order By DATE(a.dteBillDate),a.intShiftCode,g.strGroupCode,g.strGroupName;");
		funFillGroupWiseSalesData(sb);

		// fill Q modifier data group
		String columnForModiSalesAmount = "SUM(h.dblAmount) ";

		sb.setLength(0);
		sb.append("SELECT a.intShiftCode,DATE_FORMAT(DATE(a.dteBillDate),'%d-%m-%Y'),g.strGroupName," + columnForModiSalesAmount + ",sum(h.dblDiscAmt),sum(h.dblAmount)-sum(h.dblDiscAmt) " + "FROM tblqbillhd a,tblitemmaster e,tblsubgrouphd f,tblgrouphd g,tblqbillmodifierdtl h " + "WHERE a.strBillNo=h.strBillNo  " + "and date(a.dteBillDate)=date(h.dteBillDate) " + "AND e.strSubGroupCode=f.strSubGroupCode  " + "AND f.strGroupCode=g.strGroupCode  " + "and h.dblAmount>0 " + "AND a.strBillNo=h.strBillNo  " + "AND e.strItemCode=LEFT(h.strItemCode,7) " + "AND DATE(a.dteBillDate) BETWEEN '" + fromDate1 + "' and '" + toDate1 + "' ");

		if (!operationType.toString().equalsIgnoreCase("All"))
		{
			sb.append(" and a.strOperationType='" + operationType.toString() + "' ");
		}
		if (!posCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.strPOSCode='" + posCode + "' ");
		}
		if (!groupName.toString().equalsIgnoreCase("All"))
		{
			sb.append(" and g.strGroupCode='" + groupMap.get(groupName.toString()) + "' ");
		}
		if (!shiftCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.intShiftCode='" + shiftCode + "' ");
		}

		sb.append(" GROUP BY a.intShiftCode,DATE(a.dteBillDate),g.strGroupCode,g.strGroupName ");
		sb.append("Order By DATE(a.dteBillDate),a.intShiftCode,g.strGroupCode,g.strGroupName;");

		funFillGroupWiseSalesData(sb);

		List list1 = null;
		StringBuilder sqlBuilder = new StringBuilder("select strPOSCode,strPOSName from tblposmaster where strOperationalYN='Y' and strClientCode=" + clientCode);
		list1 = objBaseService.funGetList(sqlBuilder, "sql");
		for (int i = 0; i < list1.size(); i++)
		{
			Object[] obj = (Object[]) list1.get(i);
			selectedPOSName = obj[0].toString();
		}
		// fill Q Data
		sb.setLength(0);
		sb.append("select a.intShiftCode,DATE_FORMAT(DATE(a.dteBillDate),'%d-%m-%Y'),'" + selectedPOSName + "',c.strSettelmentDesc,sum(b.dblSettlementAmt) " + "from tblqbillhd a,tblqbillsettlementdtl b,tblsettelmenthd c " + "where a.strBillNo=b.strBillNo " + "and date(a.dteBillDate)=date(b.dteBillDate) " + "and b.strSettlementCode=c.strSettelmentCode " + "and date(a.dteBillDate) between '" + fromDate1 + "' and '" + toDate1 + "' ");
		if (!operationType.toString().equalsIgnoreCase("All"))
		{
			sb.append("and a.strOperationType='" + operationType.toString() + "' ");
		}
		if (!posCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.strPOSCode='" + posCode + "' ");
		}
		if (!groupName.toString().equalsIgnoreCase("All"))
		{
			sb.append(" and g.strGroupCode='" + groupMap.get(groupName.toString()) + "' ");
		}
		if (!settleName.toString().equalsIgnoreCase("All"))
		{
			sb.append(" and c.strSettelmentCode='" + settlementMap.get(settleName.toString()) + "' ");
		}

		if (!shiftCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.intShiftCode='" + shiftCode + "' ");
		}
		sb.append("group by a.intShiftCode,date(a.dteBillDate),c.strSettelmentDesc " + "order by date(a.dteBillDate),a.intShiftCode,a.intShiftCode,c.strSettelmentDesc; ");

		funFillSettlementData(sb);

		sb.setLength(0);
		sb.append("select a.intShiftCode,DATE_FORMAT(DATE(a.dteBillDate),'%d-%m-%Y'),c.strTaxDesc,sum(b.dblTaxAmount) " + "from " + "tblqbillhd a,tblqbilltaxdtl b,tbltaxhd c " + "where a.strBillNo=b.strBillNo " + "and date(a.dteBillDate)=date(b.dteBillDate) " + "and b.strTaxCode=c.strTaxCode " + "and date(a.dteBillDate) between '" + fromDate1 + "' and '" + toDate1 + "' ");
		if (!operationType.toString().equalsIgnoreCase("All"))
		{
			sb.append("and a.strOperationType='" + operationType.toString() + "' ");
		}
		if (!posCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.strPOSCode='" + posCode + "' ");
		}

		if (!shiftCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.intShiftCode='" + shiftCode + "' ");
		}
		sb.append(" group by a.intShiftCode,date(a.dteBillDate),b.strTaxCode" + " Order by date(a.dteBillDate),a.intShiftCode,b.strTaxCode; ");
		 funFillTaxData(sb);
		// End fill Q Data

		// fill live data group
		sb.setLength(0);
		sb.append("select a.intShiftCode,DATE_FORMAT(DATE(a.dteBillDate),'%d-%m-%Y'),g.strGroupName," + columnForSalesAmount + ",sum(b.dblDiscountAmt),sum(b.dblAmount)-sum(b.dblDiscountAmt) " + "from tblbillhd a,tblbilldtl b,tblitemmaster e " + ",tblsubgrouphd f ,tblgrouphd g  " + "where a.strBillNo=b.strBillNo " + "and date(a.dteBillDate)=date(b.dteBillDate) " + "and b.strItemCode=e.strItemCode " + "and e.strSubGroupCode=f.strSubGroupCode " + "and f.strGroupCode=g.strGroupCode "
		// + "AND b.dblAmount>0  "
		+ "AND DATE(a.dteBillDate) BETWEEN '" + fromDate1 + "' and '" + toDate1 + "' ");
		if (!operationType.toString().equalsIgnoreCase("All"))
		{
			sb.append("and a.strOperationType='" + operationType.toString() + "' ");
		}
		if (!posCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.strPOSCode='" + posCode + "' ");
		}

		if (!shiftCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.intShiftCode='" + shiftCode + "' ");
		}
		sb.append(" GROUP BY a.intShiftCode,DATE(a.dteBillDate),g.strGroupCode,g.strGroupName ");
		sb.append(" Order BY DATE(a.dteBillDate),a.intShiftCode,g.strGroupCode,g.strGroupName; ");

		funFillGroupWiseSalesData(sb);

		// fill live modifier data group
		sb.setLength(0);
		sb.append("SELECT a.intShiftCode,DATE_FORMAT(DATE(a.dteBillDate),'%d-%m-%Y'),g.strGroupName," + columnForModiSalesAmount + ",sum(h.dblDiscAmt),sum(h.dblAmount)-sum(h.dblDiscAmt) " + "FROM tblbillhd a,tblitemmaster e,tblsubgrouphd f,tblgrouphd g,tblbillmodifierdtl h " + "WHERE a.strBillNo=h.strBillNo  " + "and date(a.dteBillDate)=date(h.dteBillDate) " + "AND e.strSubGroupCode=f.strSubGroupCode  " + "AND f.strGroupCode=g.strGroupCode  " + "and h.dblAmount>0 " + "AND a.strBillNo=h.strBillNo  " + "AND e.strItemCode=LEFT(h.strItemCode,7) " + "AND DATE(a.dteBillDate) BETWEEN '" + fromDate + "' and '" + toDate + "' ");
		if (!operationType.toString().equalsIgnoreCase("All"))
		{
			sb.append("and a.strOperationType='" + operationType.toString() + "' ");
		}
		if (!posCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.strPOSCode='" + posCode + "' ");
		}

		if (!shiftCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.intShiftCode='" + shiftCode + "' ");
		}
		sb.append(" GROUP BY a.intShiftCode,DATE(a.dteBillDate),g.strGroupCode,g.strGroupName ");
		sb.append(" Order BY DATE(a.dteBillDate),a.intShiftCode,g.strGroupCode,g.strGroupName ");
		funFillGroupWiseSalesData(sb);

		// fill live Data
		sb.setLength(0);
		sb.append("select a.intShiftCode,DATE_FORMAT(DATE(a.dteBillDate),'%d-%m-%Y'),'" + selectedPOSName + "',c.strSettelmentDesc,sum(b.dblSettlementAmt) " + "from tblbillhd a,tblbillsettlementdtl b,tblsettelmenthd c " + "where a.strBillNo=b.strBillNo " + "and date(a.dteBillDate)=date(b.dteBillDate) " + "and b.strSettlementCode=c.strSettelmentCode " + "and date(a.dteBillDate) between '" + fromDate1 + "' and '" + toDate1 + "' ");

		if (!operationType.toString().equalsIgnoreCase("All"))
		{
			sb.append("and a.strOperationType='" + operationType.toString() + "' ");
		}
		if (!posCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.strPOSCode='" + posCode + "' ");
		}

		if (!settleName.toString().equalsIgnoreCase("All"))
		{
			sb.append(" and c.strSettelmentCode='" + settlementMap.get(settleName.toString()) + "' ");
		}

		if (!shiftCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.intShiftCode='" + shiftCode + "' ");
		}
		funFillSettlementData(sb);

		sb.setLength(0);
		sb.append("select a.intShiftCode,DATE_FORMAT(DATE(a.dteBillDate),'%d-%m-%Y'),c.strTaxDesc,sum(b.dblTaxAmount) " + "from " + "tblbillhd a,tblbilltaxdtl b,tbltaxhd c " + "where a.strBillNo=b.strBillNo " + "and date(a.dteBillDate)=date(b.dteBillDate) " + "and b.strTaxCode=c.strTaxCode " + "and date(a.dteBillDate) between '" + fromDate1 + "' and '" + toDate1 + "' ");
		if (!operationType.toString().equalsIgnoreCase("All"))
		{
			sb.append("and a.strOperationType='" + operationType.toString() + "' ");
		}
		if (!posCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.strPOSCode='" + posCode + "' ");
		}

		if (!shiftCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.intShiftCode='" + shiftCode + "' ");
		}

		funFillTaxData(sb);
		// fill Live Data

		// funUpdateSettWiseGroupWiseTaxAmtForLive();
		// funUpdateSettWiseGroupWiseTaxAmtForQFile();

		Map<String, clsPOSBillHd> mapDayWiseDiscRoundOff = new HashMap<>();

		sb.setLength(0);
		sb.append("SELECT a.intShiftCode,DATE_FORMAT(DATE(a.dteBillDate),'%d-%m-%Y'),sum(a.dblDiscountAmt),sum(a.dblRoundOff) " + "FROM tblqbillhd a  " + "WHERE date(a.dteBillDate) between '" + fromDate1 + "' and '" + toDate1 + "' ");

		if (!posCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.strPOSCode='" + posCode + "' ");
		}
		if (!shiftCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.intShiftCode='" + shiftCode + "' ");
		}
		sb.append(" GROUP BY a.intShiftCode,DATE(a.dteBillDate) " + " ORDER BY DATE(a.dteBillDate),a.intShiftCode; ");

		rsSales = objBaseService.funGetList(sb, "sql");

		if (rsSales.size() > 0)
		{
			for (int i = 0; i < rsSales.size(); i++)
			{
				Object[] obj = (Object[]) rsSales.get(i);
				String keyDate = obj[1].toString();
				if (mapDayWiseDiscRoundOff.containsKey(keyDate))
				{
					clsPOSBillHd objBillHd = mapDayWiseDiscRoundOff.get(keyDate);
					String discount = objBillHd.getDblDiscountAmt() + obj[2].toString();
					objBillHd.setDblDiscountAmt(Double.parseDouble(objBillHd.getDblDiscountAmt() + obj[2].toString()));//disc
				    objBillHd.setDblRoundOffDouble.parseDouble(objBillHd.getDblRoundOff() + obj[3].toString());//roundOff

					mapDayWiseDiscRoundOff.put(keyDate, objBillHd);
				}
				else
				{
					clsPOSBillHd objBillHd = new clsPOSBillHd();
					objBillHd.setDteBillDate(keyDate);
					objBillHd.setDblDiscountAmt(Double.parseDouble(obj[2].toString()));// disc
					objBillHd.setDblRoundOff((int) Double.parseDouble(obj[3].toString()));// roundOff

					mapDayWiseDiscRoundOff.put(keyDate, objBillHd);
				}
			}
		}
		sb.setLength(0);
		sb.append("SELECT a.intShiftCode,DATE_FORMAT(DATE(a.dteBillDate),'%d-%m-%Y'),sum(a.dblDiscountAmt),sum(a.dblRoundOff) " + "FROM tblbillhd a " + "WHERE date(a.dteBillDate) between '" + fromDate + "' and '" + toDate + "'  ");
		if (!operationType.toString().equalsIgnoreCase("All"))
		{
			sb.append("and a.strOperationType='" + operationType.toString() + "' ");
		}
		if (!posCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.strPOSCode='" + posCode + "' ");
		}
		if (!shiftCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.intShiftCode='" + shiftCode + "' ");
		}
		sb.append("GROUP BY a.intShiftCode,DATE(a.dteBillDate) " + "ORDER BY DATE(a.dteBillDate),a.intShiftCode; ");

		rsSales = objBaseService.funGetList(sb, "sql");

		if (rsSales.size() > 0)
		{
			for (int i = 0; i < rsSales.size(); i++)
			{
				Object[] obj = (Object[]) rsSales.get(i);
				String keyDate = obj[1].toString();
				if (mapDayWiseDiscRoundOff.containsKey(keyDate))
				{
					clsPOSBillHd objBillHd = mapDayWiseDiscRoundOff.get(keyDate);
					objBillHd.setDblDiscountAmt(Double.parseDouble(objBillHd.getDblDiscountAmt() + obj[2].toString()));// disc
					objBillHd.setDblRoundOff((int) (objBillHd.getDblRoundOff() + Double.parseDouble(obj[3].toString())));// roundOff

					mapDayWiseDiscRoundOff.put(keyDate, objBillHd);
				}
				else
				{
					clsPOSBillHd objBillHd = new clsPOSBillHd();
					objBillHd.setDteBillDate(keyDate);
					objBillHd.setDblDiscountAmt(Double.parseDouble(obj[2].toString()));// disc
					objBillHd.setDblRoundOff((int) Double.parseDouble(obj[3].toString()));// roundOff

					mapDayWiseDiscRoundOff.put(keyDate, objBillHd);
				}
			}
		}

		sb.setLength(0);
		sb.append("SELECT a.intShiftCode,DATE_FORMAT(DATE(a.dteBillDate),'%d-%m-%Y'),sum(b.dblSettlementAmt),sum(a.dblSubTotal)-sum(a.dblDiscountAmt) " + "FROM tblqbillhd a,tblqbillsettlementdtl b,tblsettelmenthd c " + "WHERE a.strBillNo=b.strBillNo  " + "and date(a.dteBillDate)=date(b.dteBillDate) " + "AND b.strSettlementCode=c.strSettelmentCode  " + "and b.dblSettlementAmt>0 " + "and date(a.dteBillDate) between '" + fromDate + "' and '" + toDate + "' ");
		if (!operationType.toString().equalsIgnoreCase("All"))
		{
			sb.append("and a.strOperationType='" + operationType.toString() + "' ");
		}
		if (!posCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.strPOSCode='" + posCode + "' ");
		}

		if (!settleName.toString().equalsIgnoreCase("All"))
		{
			sb.append(" and c.strSettelmentCode='" + settlementMap.get(settleName.toString()) + "' ");
		}

		if (!shiftCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.intShiftCode='" + shiftCode + "' ");
		}
		sb.append(" GROUP BY a.intShiftCode,DATE(a.dteBillDate) " + " ORDER BY DATE(a.dteBillDate),a.intShiftCode; ");

		rsSales = objBaseService.funGetList(sb, "sql");

		if (rsSales.size() > 0)
		{
			for (int i = 0; i < rsSales.size(); i++)
			{
				Object[] obj = (Object[]) rsSales.get(i);
				mapDayGrandTotal.put(obj[0].toString() + " " + obj[1].toString(), obj[2].toString());

			}

		}
		sb.setLength(0);
		sb.append("SELECT a.intShiftCode,DATE_FORMAT(DATE(a.dteBillDate),'%d-%m-%Y'),sum(b.dblSettlementAmt),sum(a.dblSubTotal)-sum(a.dblDiscountAmt) " + "FROM tblbillhd a,tblbillsettlementdtl b,tblsettelmenthd c " + "WHERE a.strBillNo=b.strBillNo  " + "and date(a.dteBillDate)=date(b.dteBillDate) " + "AND b.strSettlementCode=c.strSettelmentCode  " + "and b.dblSettlementAmt>0 " + "and date(a.dteBillDate) between '" + fromDate + "' and '" + toDate + "' ");
		if (!operationType.toString().equalsIgnoreCase("All"))
		{
			sb.append("and a.strOperationType='" + operationType.toString() + "' ");
		}
		if (!posCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.strPOSCode='" + posCode + "' ");
		}

		if (!settleName.toString().equalsIgnoreCase("All"))
		{
			sb.append(" and c.strSettelmentCode='" + settlementMap.get(settleName.toString()) + "' ");
		}

		if (!shiftCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.intShiftCode='" + shiftCode + "' ");
		}
		sb.append(" GROUP BY a.intShiftCode,DATE(a.dteBillDate) " + " ORDER BY DATE(a.dteBillDate),a.intShiftCode; ");
		rsSales = objBaseService.funGetList(sb, "sql");

		if (rsSales.size() > 0)
		{
			for (int i = 0; i < rsSales.size(); i++)
			{
				Object[] obj = (Object[]) rsSales.get(i);
				if (mapDayGrandTotal.containsKey(obj[0].toString() + " " + obj[1].toString()))
				{
					mapDayGrandTotal.put(obj[0].toString() + " " + obj[1].toString(), mapDayGrandTotal.get(obj[0].toString() + " " + obj[1].toString()) + obj[2].toString());
					// mapDayNetTotal.put(rsSales.getString(1),
					// mapDayNetTotal.get(rsSales.getString(1)) +
					// rsSales.getDouble(3));
				}
				else
				{
					mapDayGrandTotal.put(obj[0].toString() + " " + obj[1].toString(), obj[2].toString());
					// mapDayNetTotal.put(rsSales.getString(1),
					// rsSales.getDouble(3));
				}
			}
		}

		StringBuilder sqlGrandTotal = null;
		sqlGrandTotal.append("SELECT a.intShiftCode,DATE_FORMAT(DATE(a.dteBillDate),'%d-%m-%Y'),sum(a.dblGrandTotal),sum(a.dblSubTotal)-sum(a.dblDiscountAmt)" + "FROM tblqbillhd a " + "WHERE date(a.dteBillDate) between '" + fromDate + "' and '" + toDate + "' ");
		if (!operationType.toString().equalsIgnoreCase("All"))
		{
			sqlGrandTotal.append("and a.strOperationType='" + operationType.toString() + "' ");
		}
		if (!posCode.equalsIgnoreCase("All"))
		{
			sqlGrandTotal.append(sqlGrandTotal + " and a.strPOSCode='" + posCode + "' ");
		}
		if (!shiftCode.equalsIgnoreCase("All"))
		{
			sb.append(" and a.intShiftCode='" + shiftCode + "' ");
		}

		sqlGrandTotal.append(sqlGrandTotal + "GROUP BY a.intShiftCode,DATE(a.dteBillDate) " + "ORDER BY DATE(a.dteBillDate),a.intShiftCode; ");
		rsSales = objBaseService.funGetList(sqlGrandTotal, "sql");

		if (rsSales.size() > 0)
		{
			for (int i = 0; i < rsSales.size(); i++)
			{
				Object[] obj = (Object[]) rsSales.get(i);
				mapDayNetTotal.put(obj[0].toString() + " " + obj[1].toString(), obj[3].toString());

			}
		}
		sqlGrandTotal.append("SELECT a.intShiftCode,DATE_FORMAT(DATE(a.dteBillDate),'%d-%m-%Y'),sum(a.dblGrandTotal),sum(a.dblSubTotal)-sum(a.dblDiscountAmt)" + "FROM tblbillhd a " + "where date(a.dteBillDate) between '" + fromDate + "' and '" + toDate + "' ");
		if (!operationType.toString().equalsIgnoreCase("All"))
		{
			sqlGrandTotal.append("and a.strOperationType='" + operationType.toString() + "' ");
		}
		if (!posCode.equalsIgnoreCase("All"))
		{
			sqlGrandTotal.append(sqlGrandTotal + " and a.strPOSCode='" + posCode + "' ");
		}

		sqlGrandTotal.append(sqlGrandTotal + "GROUP BY a.intShiftCode,DATE(a.dteBillDate) " + "ORDER BY DATE(a.dteBillDate),a.intShiftCode; ");

		rsSales = objBaseService.funGetList(sqlGrandTotal, "sql");

		if (rsSales.size() > 0)
		{
			for (int i = 0; i < rsSales.size(); i++)
			{
				Object[] obj = (Object[]) rsSales.get(i);
				if (mapDayNetTotal.containsKey(obj[0].toString() + " " + obj[1].toString()))
				{
					mapDayNetTotal.put(obj[0].toString() + " " + obj[1].toString(), mapDayNetTotal.get(obj[1].toString()) + obj[3].toString());
				}
				else
				{
					mapDayNetTotal.put(obj[0].toString() + " " + obj[1].toString(), obj[3].toString());
				}
			}
		}

		return null;
	}

	private void funFillTaxData( StringBuilder sqlTax) throws Exception
	{
		// TODO Auto-generated method stub
		List listTax = objBaseService.funGetList(sqlTax, "sql");
		if (listTax.size() > 0)
		{
			for (int i = 0; i < listTax.size(); i++)
			{
				Object[] obj = (Object[]) listTax.get(i);
			totalTaxAmount += Double.parseDouble(obj[3].toString());
			}
		}
		
	}

	private void funFillSettlementData(StringBuilder sb) throws Exception
	{
		// TODO Auto-generated method stub
		List listSettlementData = objBaseService.funGetList(sb, "sql");
		if (listSettlementData.size() > 0)
		{
			for (int i = 0; i < listSettlementData.size(); i++)
			{
				Object[] obj = (Object[]) listSettlementData.get(i);
				totalSettleAmount += Double.parseDouble(obj[4].toString());

			}
		}
	}

	public void funFillGroupWiseSalesData(StringBuilder sqlGroups) throws Exception
	{
		List listgroupWise = objBaseService.funGetList(sqlGroups, "sql");
		if (listgroupWise.size() > 0)
		{
			for (int i = 0; i < listgroupWise.size(); i++)
			{
				Object[] obj = (Object[]) listgroupWise.get(i);
				String shift = obj[0].toString();
				String date = obj[1].toString();
				totalGroupAmtTotal += Integer.parseInt(obj[3].toString());// subtotal||
																			// subTotal-disc
				 totalDiscAmtTotal += Integer.parseInt(obj[4].toString());// discount
				double netTotal = Double.parseDouble(obj[5].toString());// subTotal-disc
				String strShiftWithDate = "";
			}
		}

	}

	private void funFillSettlementWiseGroupWiseAmtMapForLive()
	{
		StringBuilder sb = new StringBuilder();
		try
		{
			String POSCode = req.getSession().getAttribute("loginPOS").toString();

			// fill live Data
			sb.setLength(0);
			sb.append("select a.intShiftCode,DATE_FORMAT(DATE(a.dteBillDate),'%d-%m-%Y'),'" + selectedPOSName + "',c.strSettelmentDesc,sum(b.dblSettlementAmt) " + "from tblbillhd a,tblbillsettlementdtl b,tblsettelmenthd c " + "where a.strBillNo=b.strBillNo " + "and date(a.dteBillDate)=date(b.dteBillDate) " + "and b.strSettlementCode=c.strSettelmentCode " + "and date(a.dteBillDate) between '" + fromDate + "' and '" + toDate + "' ");
			
			if (!selectedPOSCode.equalsIgnoreCase("All"))
			{
				sb.append(" and a.strPOSCode='" + selectedPOSCode + "' ");
			}

			sb.append(" Group by a.intShiftCode,date(a.dteBillDate),c.strSettelmentDesc " + " Order by date(a.dteBillDate),a.intShiftCode,c.strSettelmentDesc; ");

			ResultSet rsSales = clsGlobalVarClass.dbMysql.executeResultSet(sb.toString());
			while (rsSales.next())
			{
				// date+SettlementDesc
				if (mapSettlemetWiseAmt.containsKey(rsSales.getString(2) + "!" + "All".toUpperCase()))
				{
					double oldSettlementAmt = mapSettlemetWiseAmt.get(rsSales.getString(2) + "!" + "All".toUpperCase());
					mapSettlemetWiseAmt.put(rsSales.getString(2) + "!" + "All".toUpperCase(), oldSettlementAmt + rsSales.getDouble(5));
				}
				else
				{
					mapSettlemetWiseAmt.put(rsSales.getString(2) + "!" + "All".toUpperCase(), rsSales.getDouble(5));
				}

				if (mapSettlemetWiseAmt.containsKey(rsSales.getString(2) + "!" + rsSales.getString(5).toUpperCase()))
				{
					double oldSettlementAmt = mapSettlemetWiseAmt.get(rsSales.getString(2) + "!" + rsSales.getString(4).toUpperCase());
					mapSettlemetWiseAmt.put(rsSales.getString(2) + "!" + rsSales.getString(4).toUpperCase(), oldSettlementAmt + rsSales.getDouble(5));
				}
				else
				{
					mapSettlemetWiseAmt.put(rsSales.getString(2) + "!" + rsSales.getString(4).toUpperCase(), rsSales.getDouble(5));
				}
			}
			rsSales.close();
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
	}
}
*/