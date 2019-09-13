package com.sanguine.webpos.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.POSGlobal.controller.clsBillItemDtl;
import com.sanguine.base.service.clsSetupService;
import com.sanguine.base.service.intfBaseService;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.webpos.bean.clsBillItemDtlBean;
import com.sanguine.webpos.bean.clsManagerReportBean;
import com.sanguine.webpos.bean.clsPOSReportBean;
import com.sanguine.webpos.model.clsShiftMasterModel;
import com.sanguine.webpos.sevice.clsPOSMasterService;
import com.sanguine.webpos.sevice.clsPOSReportService;
import com.sanguine.webpos.util.clsPOSSetupUtility;
import com.sanguine.webpos.util.clsPOSUtilityController;

@Controller
public class clsPOSGrossSalesSummaryReportController
{
	@Autowired
	private intfBaseService objBaseService;
	
	@Autowired
	private clsPOSMasterService objMasterService;
	
	@Autowired
	 private clsSetupService objSetupService;
	
	@Autowired
	private clsGlobalFunctions objGlobalFunctions;
	
	@Autowired
	private clsPOSUtilityController objUtility;
	
	@Autowired
	clsPOSSetupUtility objPOSSetupUtility;
	
	@Autowired
	clsPOSReportService objReportService;
	
	HashMap hmPOSData = new HashMap<String, String>();
	
	@RequestMapping(value = "/frmGrossSalesSummary", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model, HttpServletRequest request)throws Exception
	{
		String strClientCode = request.getSession().getAttribute("gClientCode").toString();
		String POSCode=request.getSession().getAttribute("loginPOS").toString();	
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
		List poslist = new ArrayList();
		poslist.add("ALL");
		List listOfPos = objMasterService.funFillPOSCombo(strClientCode);
		if(listOfPos!=null)
		{
			for(int i =0 ;i<listOfPos.size();i++)
			{
				Object[] obj = (Object[]) listOfPos.get(i);
				poslist.add( obj[1].toString());
				hmPOSData.put( obj[1].toString(), obj[0].toString());
			}
		}
		model.put("posList", poslist);
		List sgNameList = new ArrayList<String>();
		sgNameList.add("ALL");

		model.put("sgNameList", sgNameList);
		
		String posDate = request.getSession().getAttribute("gPOSDate").toString();
		request.setAttribute("POSDate", posDate);
		
		Map objSetupParameter=objSetupService.funGetParameterValuePOSWise(strClientCode, POSCode, "gEnableShiftYN");
		model.put("gEnableShiftYN",objSetupParameter.get("gEnableShiftYN").toString());

		//Shift 
		List shiftList = new ArrayList();
		shiftList.add("All");
		List listShiftData = objReportService.funGetPOSWiseShiftList(POSCode,request);
		if(listShiftData!=null)
		{
			for(int cnt=0;cnt<listShiftData.size();cnt++)
			{
				clsShiftMasterModel objShiftModel= (clsShiftMasterModel) listShiftData.get(cnt);
				shiftList.add(objShiftModel.getIntShiftCode());
			
			}
		}
		model.put("shiftList",shiftList);
		
		if ("2".equalsIgnoreCase(urlHits))
		{
			return new ModelAndView("frmGrossSalesSummary_1", "command", new clsPOSReportBean());
		}
		else if ("1".equalsIgnoreCase(urlHits))
		{
			return new ModelAndView("frmGrossSalesSummary", "command", new clsPOSReportBean());
		}
		else
		{
			return null;
		}

	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/rptPOSGrossSalesSummary", method = RequestMethod.POST)	
	private void funReport(@ModelAttribute("command") clsPOSReportBean objBean, HttpServletResponse resp,HttpServletRequest req)
	{
		try
		{
			
			String strClientCode=req.getSession().getAttribute("gClientCode").toString();	
			String POSCode=req.getSession().getAttribute("loginPOS").toString();
			Map hm = objGlobalFunctions.funGetCommonHashMapForJasperReport(objBean, req, resp);
			String posCode = "ALL";
			posCode=objBean.getStrPOSName();
			hm.put("posCode", posCode);
			
			String fromDate = hm.get("fromDate").toString();
			String toDate = hm.get("toDate").toString();
			String strUserCode = hm.get("userName").toString();
			String strPOSCode = posCode;

			List list = new ArrayList();
			list.add(1);
			objUtility.funCreateTempFolder();

		    String filePath = System.getProperty("user.dir");
		    File file = new File(filePath + File.separator + "Temp" + File.separator + "Gross Sales Summary.txt");
		    PrintWriter pw = new PrintWriter(file);

		    String dashedLineOf150Chars = "------------------------------------------------------------------------------------------------------------------------------------------------------";

		    pw.println(hm.get("clientName"));
		    String gClientAddress2 = objPOSSetupUtility.funGetParameterValuePOSWise(strClientCode,POSCode, "gClientAddress2");
		    String gClientAddress3 = objPOSSetupUtility.funGetParameterValuePOSWise(strClientCode,POSCode, "gClientAddress3");
		    if (gClientAddress2.trim().length() > 0)
		    {
			pw.println(gClientAddress2);
		    }
		    if (gClientAddress3.trim().length() > 0)
		    {
			pw.println(gClientAddress3);
		    }
		    pw.println("Report : Gross Sales Summary");
		   // pw.println();
			
			int ret = funGrossSalesSummary(fromDate,toDate,posCode,pw,strClientCode);
			String printOS = "Windows";
			String printerType = "Inbuild";
			 pw.println();
			 pw.println();
			 if ("linux".equalsIgnoreCase(printOS))
			 {
				 pw.println("V");//Linux
			 }
			 else if ("windows".equalsIgnoreCase(printOS))
			 {
				if ("Inbuild".equalsIgnoreCase(printerType))
				{
				    pw.println("V");
				}
				else
				{
				    pw.println("m");//windows
				}
			 }

		    pw.flush();
		    pw.close();
		    
		    resp.setContentType("text/plain");
		    
	        
		    resp.setHeader("Content-disposition","attachment; filename=Gross Sales Summary.txt"); // Used to name the download file and its format
		    OutputStream out = resp.getOutputStream();
	       FileInputStream in = new FileInputStream(file);
	       byte[] buffer = new byte[4096];
	       int length;
	       while ((length = in.read(buffer)) > 0){
	          out.write(buffer, 0, length);
	       }
	       in.close();
	       out.flush();
		   
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
	    
		System.out.println("Hi");
			
	}
	
	public int funGrossSalesSummary(String fromDate,String toDate,String posCode, PrintWriter pw,final String strClientCode) throws Exception
	{
		StringBuilder sbSqlLiveFile = new StringBuilder();
		StringBuilder sbSqlQFile = new StringBuilder();
		StringBuilder sqlFilter = new StringBuilder();
		
		String firstBill = "", lastBill = "";
		
		/*sbSqlLiveFile.setLength(0);
		sbSqlLiveFile.append("select a.strBillNo,DATE_FORMAT(a.dteBillDate,'%d-%m-%Y') as date "
				+ " from tblqbillhd a,tblqbillsettlementdtl b,tblsettelmenthd c "
				+ "where  "
				+ "a.strBillNo=b.strBillNo  and a.strClientCode=b.strClientCode  "
				+ "and b.strSettlementCode=c.strSettelmentCode "
				+ "and date(a.dteBillDate) between  '" + fromDate + "' and '" + toDate + "' and ");


		if (!posCode.equalsIgnoreCase("All"))
		{
		    sbSqlLiveFile.append(" and a.strPOSCode='" + posCode + "' ");
		}
		sbSqlLiveFile.append("order BY a.strBillNo,c.strSettelmentDesc ");
		System.out.println(sbSqlLiveFile);*/
		pw.println("Reporting For:" + "  " + fromDate + " " + "To" + " " + toDate);
		/*String dashedLineOf150Chars = "------------------------------------------------------------------------------------------------------------------------------------------------------";
		pw.println(dashedLineOf150Chars);//line
*/		
		//pw.println();
		pw.println("Gross Sales Summary");
		/*pw.println();
		pw.println("---------------------------");
*/
		
		

		String sqlTip = "", sqlNoOfBill = "", sqlDiscount = "";

		Map<String, Map<String, clsManagerReportBean>> mapBillWiseData = new TreeMap<String, Map<String, clsManagerReportBean>>();
		Map<String, Map<String, String>> mapBillWiseSettlementNames = new TreeMap<String, Map<String, String>>();
		Map<String, Map<String, String>> mapBillWiseTaxNames = new TreeMap<String, Map<String, String>>();
		Map<String, Map<String, String>> mapBillWiseGroupNames = new TreeMap<String, Map<String, String>>();

		int maxSettlementNameLength = 24;
		int maxGroupNameLength = 12;
		int maxTaxNameLength = 0;
		int maxLineCount =0;

		Map<String, Integer> mapGroupNameWithLength = new TreeMap<>();
		Map<String, Integer> mapTaxNameWithLength = new TreeMap<>();

		int cntTax = 1;
		double totalTaxAmt = 0.00;
		double totalSettleAmt = 0.00;
		double totalDiscAmt = 0.00;
		double totalTipAmt = 0.00;
		double totalRoundOffAmt = 0.00;
		double totalBills = 0;

		/*sbSqlLiveFile.setLength(0);
		sbSqlLiveFile.append(" select a.strBillNo,c.strSettelmentCode,c.strSettelmentDesc,b.dblSettlementAmt,DATE_FORMAT(date(a.dteBillDate),'%d-%m-%Y')dteBillDate "
			+ " from tblbillhd a,tblbillsettlementdtl b,tblsettelmenthd c "
			+ " where a.strBillNo=b.strBillNo "
			+ " and date(a.dteBillDate)=date(b.dteBillDate) "
			+ " and b.strSettlementCode=c.strSettelmentCode "
			+ " and a.strClientCode=b.strClientCode "//and a.strSettelmentMode!='MultiSettle'
			+ " and date(a.dteBillDate) between '" + fromDate + "' and '" + toDate + "' and a.strClientCode='"+strClientCode+"' "
			+ " and c.strSettelmentType!='Complementary' "
			+ " ");
		if (!posCode.equalsIgnoreCase("All"))
		{
		    sbSqlLiveFile.append(" and a.strPOSCode='" + posCode + "' ");
		}
		sbSqlLiveFile.append(" order BY a.strBillNo,c.strSettelmentDesc ");
		System.out.println(sbSqlLiveFile);

		List listSettleManager = objBaseService.funGetList(sbSqlLiveFile, "sql");
		if(listSettleManager.size()>0)
		{
			for(int i=0;i<listSettleManager.size();i++)
			{	
			Object[] obj = (Object[])listSettleManager.get(i);	
		    String strBillNo = obj[0].toString();
		    String settlementCode = obj[1].toString();
		    String settlementDesc = obj[2].toString();
		    double settleAmt = Double.parseDouble(obj[3].toString());
		    String billDate = obj[4].toString();

		    if (settlementDesc.length() > maxSettlementNameLength)
		    {
		    	maxSettlementNameLength = settlementDesc.length();
		    }

		    totalSettleAmt = totalSettleAmt + settleAmt;

		    if (mapBillWiseSettlementNames.containsKey(strBillNo))
		    {
		    	Map<String, String> mapSettlementNames = mapBillWiseSettlementNames.get(strBillNo);

		    	mapSettlementNames.put(settlementCode, settlementDesc);
		    }
		    else
		    {
		    	Map<String, String> mapSettlementNames = new TreeMap<>();

		    	mapSettlementNames.put(settlementCode, settlementDesc);

		    	mapBillWiseSettlementNames.put(strBillNo, mapSettlementNames);
		    }

		    if (mapBillWiseData.containsKey(strBillNo))
		    {
		    	Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = mapBillWiseData.get(strBillNo);

		    	//put settlement dtl
			    if (mapBillWiseSettlementWiseData.containsKey(settlementCode))
				{
				    clsManagerReportBean objManagerReportBean = mapBillWiseSettlementWiseData.get(settlementCode);
				    objManagerReportBean.setDblSettlementAmt(objManagerReportBean.getDblSettlementAmt() + settleAmt);
	
				    mapBillWiseSettlementWiseData.put(settlementCode, objManagerReportBean);
				}
				else
				{
				    clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
				    objManagerReportBean.setStrSettlementCode(settlementCode);
				    objManagerReportBean.setStrSettlementDesc(settlementDesc);
				    objManagerReportBean.setDblSettlementAmt(settleAmt);
	
				    mapBillWiseSettlementWiseData.put(settlementCode, objManagerReportBean);
				}
				//put total settlement dtl
				if (mapBillWiseSettlementWiseData.containsKey("TotalSettlementAmt"))
				{
				    clsManagerReportBean objManagerReportBean = mapBillWiseSettlementWiseData.get("TotalSettlementAmt");
				    objManagerReportBean.setDblSettlementAmt(objManagerReportBean.getDblSettlementAmt() + settleAmt);
	
				    mapBillWiseSettlementWiseData.put("TotalSettlementAmt", objManagerReportBean);
				}
				else
				{
				    clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
				    objManagerReportBean.setStrSettlementCode("TotalSettlementAmt");
				    objManagerReportBean.setStrSettlementDesc("TotalSettlementAmt");
				    objManagerReportBean.setDblSettlementAmt(settleAmt);
	
				    mapBillWiseSettlementWiseData.put("TotalSettlementAmt", objManagerReportBean);
				}

				mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
		    }
		    else
		    {
				Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = new TreeMap<String, clsManagerReportBean>();
	
				//put settlement dtl
				clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
				objManagerReportBean.setStrSettlementCode(settlementCode);
				objManagerReportBean.setStrSettlementDesc(settlementDesc);
				objManagerReportBean.setDblSettlementAmt(settleAmt);
	
				mapBillWiseSettlementWiseData.put(settlementCode, objManagerReportBean);
	
				//put total settlement dtl
				objManagerReportBean = new clsManagerReportBean();
				objManagerReportBean.setStrSettlementCode("TotalSettlementAmt");
				objManagerReportBean.setStrSettlementDesc("TotalSettlementAmt");
				objManagerReportBean.setDblSettlementAmt(settleAmt);
	
				mapBillWiseSettlementWiseData.put("TotalSettlementAmt", objManagerReportBean);
	
				mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
		    }
		} 
		}
		

		sbSqlQFile.setLength(0);
		sbSqlQFile.append(" select a.strBillNo,c.strSettelmentCode,c.strSettelmentDesc,b.dblSettlementAmt,DATE_FORMAT(date(a.dteBillDate),'%d-%m-%Y')dteBillDate "
			+ " from tblqbillhd a,tblqbillsettlementdtl b,tblsettelmenthd c "
			+ " where a.strBillNo=b.strBillNo "
			+ " and date(a.dteBillDate)=date(b.dteBillDate) "
			+ " and b.strSettlementCode=c.strSettelmentCode "
			+ " and a.strClientCode=b.strClientCode "//and a.strSettelmentMode!='MultiSettle' 
			+ " and date(a.dteBillDate) between '" + fromDate + "' and '" + toDate + "'  and a.strClientCode='"+strClientCode+"' "
			+ " and c.strSettelmentType!='Complementary' ");
		if (!posCode.equalsIgnoreCase("All"))
		{
		    sbSqlQFile.append(" and a.strPOSCode='" + posCode + "' ");
		}
		sbSqlQFile.append(" order BY a.strBillNo,c.strSettelmentDesc ");
		listSettleManager = objBaseService.funGetList(sbSqlQFile, "sql");

		if(listSettleManager.size()>0)
		{
			for(int i=0;i<listSettleManager.size();i++)
			{
			Object[] obj = (Object[])listSettleManager.get(i);
		    String strBillNo = obj[0].toString();
		    String settlementCode = obj[1].toString();
		    String settlementDesc = obj[2].toString();
		    double settleAmt = Double.parseDouble(obj[3].toString());
		    String billDate = obj[4].toString();

		    if (settlementDesc.length() > maxSettlementNameLength)
		    {
		    	maxSettlementNameLength = settlementDesc.length();
		    }

		    totalSettleAmt = totalSettleAmt + settleAmt;

		    if (mapBillWiseSettlementNames.containsKey(strBillNo))
		    {
				Map<String, String> mapSettlementNames = mapBillWiseSettlementNames.get(strBillNo);
	
				mapSettlementNames.put(settlementCode, settlementDesc);
		    }
		    else
		    {
				Map<String, String> mapSettlementNames = new TreeMap<>();
	
				mapSettlementNames.put(settlementCode, settlementDesc);
	
				mapBillWiseSettlementNames.put(strBillNo, mapSettlementNames);
		    }

		    if (mapBillWiseData.containsKey(strBillNo))
		    {
				Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = mapBillWiseData.get(strBillNo);
	
				//put settlement dtl
				if (mapBillWiseSettlementWiseData.containsKey(settlementCode))
				{
				    clsManagerReportBean objManagerReportBean = mapBillWiseSettlementWiseData.get(settlementCode);
				    objManagerReportBean.setDblSettlementAmt(objManagerReportBean.getDblSettlementAmt() + settleAmt);
	
				    mapBillWiseSettlementWiseData.put(settlementCode, objManagerReportBean);
				}
				else
				{
				    clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
				    objManagerReportBean.setStrSettlementCode(settlementCode);
				    objManagerReportBean.setStrSettlementDesc(settlementDesc);
				    objManagerReportBean.setDblSettlementAmt(settleAmt);
	
				    mapBillWiseSettlementWiseData.put(settlementCode, objManagerReportBean);
				}
				//put total settlement dtl
				if (mapBillWiseSettlementWiseData.containsKey("TotalSettlementAmt"))
				{
				    clsManagerReportBean objManagerReportBean = mapBillWiseSettlementWiseData.get("TotalSettlementAmt");
				    objManagerReportBean.setDblSettlementAmt(objManagerReportBean.getDblSettlementAmt() + settleAmt);
	
				    mapBillWiseSettlementWiseData.put("TotalSettlementAmt", objManagerReportBean);
				}
				else
				{
				    clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
				    objManagerReportBean.setStrSettlementCode("TotalSettlementAmt");
				    objManagerReportBean.setStrSettlementDesc("TotalSettlementAmt");
				    objManagerReportBean.setDblSettlementAmt(settleAmt);
	
				    mapBillWiseSettlementWiseData.put("TotalSettlementAmt", objManagerReportBean);
				}

				mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
		    }
		    else
		    {
		    	Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = new TreeMap<String, clsManagerReportBean>();
		    	//put settlement dtl

				clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
				objManagerReportBean.setStrSettlementCode(settlementCode);
				objManagerReportBean.setStrSettlementDesc(settlementDesc);
				objManagerReportBean.setDblSettlementAmt(settleAmt);
	
				mapBillWiseSettlementWiseData.put(settlementCode, objManagerReportBean);

				//put total settlement dtl
				objManagerReportBean = new clsManagerReportBean();
				objManagerReportBean.setStrSettlementCode("TotalSettlementAmt");
				objManagerReportBean.setStrSettlementDesc("TotalSettlementAmt");
				objManagerReportBean.setDblSettlementAmt(settleAmt);
	
				mapBillWiseSettlementWiseData.put("TotalSettlementAmt", objManagerReportBean);
	
				mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
		    }
		}
		}
		

		*//**
		 * live taxes
		 *//*
		StringBuilder sqlTax = new StringBuilder();
		sqlTax.setLength(0);
		sqlTax.append("SELECT a.strBillNo,ifnull(c.strTaxCode,'VAT'),ifnull(c.strTaxDesc,'VAT'),ifnull(SUM(b.dblTaxAmount),0) "
		+ " from tblbillhd a "
		+ " left outer join tblbilltaxdtl b on a.strBillNo=b.strBillNo AND DATE(a.dteBillDate)= DATE(b.dteBillDate) AND a.strClientCode=b.strClientCode "
		+ " left outer join tbltaxhd c on b.strTaxCode=c.strTaxCode "
		+ " where date(a.dteBillDate) between '" + fromDate + "' and '" + toDate + "'  and a.strClientCode='"+strClientCode+"' ");
		if (!posCode.equalsIgnoreCase("All"))
		{
			sqlTax.append(" and a.strPOSCode='" + posCode + "' ");
		}
		sqlTax.append(" group by a.strBillNo,c.strTaxCode");
		List listTaxDtl1 = objBaseService.funGetList(sqlTax, "sql");
		if(listTaxDtl1.size()>0)
		{
			for(int i=0;i<listTaxDtl1.size();i++)
			{
			Object[] obj = (Object[]) listTaxDtl1.get(i);	
		    String strBillNo = obj[0].toString();
		    String taxCode = obj[1].toString();
		    String taxDesc = obj[2].toString();
		    double taxAmt = Double.parseDouble(obj[3].toString());

		    mapTaxNameWithLength.put(taxDesc, taxDesc.length());
		    if (taxDesc.length() > maxTaxNameLength)
		    {
		    	maxTaxNameLength = taxDesc.length();
		    }

		    totalTaxAmt = totalTaxAmt + taxAmt;

		    if (mapBillWiseTaxNames.containsKey(strBillNo))
		    {
		    	Map<String, String> mapTaxNames = mapBillWiseTaxNames.get(strBillNo);

		    	mapTaxNames.put(taxCode, taxDesc);
		    }
		    else
		    {
				Map<String, String> mapTaxNames = new TreeMap<>();
	
				mapTaxNames.put(taxCode, taxDesc);
	
				mapBillWiseTaxNames.put(strBillNo, mapTaxNames);
		    }

		    if (mapBillWiseData.containsKey(strBillNo))
		    {
				Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = mapBillWiseData.get(strBillNo);

				//put tax dtl
				if (mapBillWiseSettlementWiseData.containsKey(taxCode))
				{
				    clsManagerReportBean objManagerReportBean = mapBillWiseSettlementWiseData.get(taxCode);
				    objManagerReportBean.setDblSettlementAmt(objManagerReportBean.getDblTaxAmt() + taxAmt);
	
				    mapBillWiseSettlementWiseData.put(taxCode, objManagerReportBean);
				}
				else
				{
				    clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
				    objManagerReportBean.setStrTaxCode(taxCode);
				    objManagerReportBean.setStrTaxDesc(taxDesc);
				    objManagerReportBean.setDblTaxAmt(taxAmt);
	
				    mapBillWiseSettlementWiseData.put(taxCode, objManagerReportBean);
				}

				//put total tax dtl
				if (mapBillWiseSettlementWiseData.containsKey("TotalTaxAmt"))
				{
				    clsManagerReportBean objManagerReportBean = mapBillWiseSettlementWiseData.get("TotalTaxAmt");
				    objManagerReportBean.setDblTaxAmt(objManagerReportBean.getDblTaxAmt() + taxAmt);
	
				    mapBillWiseSettlementWiseData.put("TotalTaxAmt", objManagerReportBean);
				}
				else
				{
				    clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
				    objManagerReportBean.setStrTaxCode("TotalTaxAmt");
				    objManagerReportBean.setStrTaxDesc("TotalTaxAmt");
				    objManagerReportBean.setDblTaxAmt(taxAmt);
	
				    mapBillWiseSettlementWiseData.put("TotalTaxAmt", objManagerReportBean);
				}

				mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
		    }
		    else
		    {
				Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = new TreeMap<String, clsManagerReportBean>();
	
				clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
				objManagerReportBean.setStrTaxCode(taxCode);
				objManagerReportBean.setStrTaxDesc(taxDesc);
				objManagerReportBean.setDblTaxAmt(taxAmt);
	
				//put total tax dtl
				objManagerReportBean = new clsManagerReportBean();
				objManagerReportBean.setStrTaxCode("TotalTaxAmt");
				objManagerReportBean.setStrTaxDesc("TotalTaxAmt");
				objManagerReportBean.setDblTaxAmt(taxAmt);
	
				mapBillWiseSettlementWiseData.put("TotalTaxAmt", objManagerReportBean);
	
				mapBillWiseSettlementWiseData.put(taxCode, objManagerReportBean);
	
				mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
		    }
		}
		}
		

		*//**
		 * Q taxes
		 *//*
		sqlTax.setLength(0);
		sqlTax.append("SELECT a.strBillNo,ifnull(c.strTaxCode,'VAT'),ifnull(c.strTaxDesc,'VAT'),ifnull(SUM(b.dblTaxAmount),0) "
				+ " from tblqbillhd a "
				+ " left outer join tblqbilltaxdtl b on a.strBillNo=b.strBillNo AND DATE(a.dteBillDate)= DATE(b.dteBillDate) AND a.strClientCode=b.strClientCode "
				+ " left outer join tbltaxhd c on b.strTaxCode=c.strTaxCode "
				+ " where date(a.dteBillDate) between '" + fromDate + "' and '" + toDate + "'  and a.strClientCode='"+strClientCode+"' ");
		if (!posCode.equalsIgnoreCase("All"))
		{
			sqlTax.append(" and a.strPOSCode='" + posCode + "' ");
		}
		sqlTax.append( " group by a.strBillNo,c.strTaxCode");
		listTaxDtl1 = objBaseService.funGetList(sqlTax, "sql");
		if(listTaxDtl1.size()>0)
		{
			for(int i=0;i<listTaxDtl1.size();i++)
			{
			Object[] obj = (Object[])listTaxDtl1.get(i);	
		    String strBillNo = obj[0].toString();
		    String taxCode = obj[1].toString();
		    String taxDesc = obj[2].toString();
		    double taxAmt = Double.parseDouble(obj[3].toString());

		    if (taxDesc.length() > maxTaxNameLength)
		    {
		    	maxTaxNameLength = taxDesc.length();
		    }
		    mapTaxNameWithLength.put(taxDesc, taxDesc.length());

		    totalTaxAmt = totalTaxAmt + taxAmt;

		    if (mapBillWiseTaxNames.containsKey(strBillNo))
		    {
				Map<String, String> mapTaxNames = mapBillWiseTaxNames.get(strBillNo);
	
				mapTaxNames.put(taxCode, taxDesc);
		    }
		    else
		    {
				Map<String, String> mapTaxNames = new TreeMap<>();
	
				mapTaxNames.put(taxCode, taxDesc);
	
				mapBillWiseTaxNames.put(strBillNo, mapTaxNames);
		    }

		    if (mapBillWiseData.containsKey(strBillNo))
		    {
		    	Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = mapBillWiseData.get(strBillNo);

				//put tax dtl
				if (mapBillWiseSettlementWiseData.containsKey(taxCode))
				{
				    clsManagerReportBean objManagerReportBean = mapBillWiseSettlementWiseData.get(taxCode);
				    objManagerReportBean.setDblSettlementAmt(objManagerReportBean.getDblTaxAmt() + taxAmt);
	
				    mapBillWiseSettlementWiseData.put(taxCode, objManagerReportBean);
				}
				else
				{
				    clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
				    objManagerReportBean.setStrTaxCode(taxCode);
				    objManagerReportBean.setStrTaxDesc(taxDesc);
				    objManagerReportBean.setDblTaxAmt(taxAmt);
	
				    mapBillWiseSettlementWiseData.put(taxCode, objManagerReportBean);
				}

				//put total tax dtl
				if (mapBillWiseSettlementWiseData.containsKey("TotalTaxAmt"))
				{
				    clsManagerReportBean objManagerReportBean = mapBillWiseSettlementWiseData.get("TotalTaxAmt");
				    objManagerReportBean.setDblTaxAmt(objManagerReportBean.getDblTaxAmt() + taxAmt);
	
				    mapBillWiseSettlementWiseData.put("TotalTaxAmt", objManagerReportBean);
				}
				else
				{
				    clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
				    objManagerReportBean.setStrTaxCode("TotalTaxAmt");
				    objManagerReportBean.setStrTaxDesc("TotalTaxAmt");
				    objManagerReportBean.setDblTaxAmt(taxAmt);
	
				    mapBillWiseSettlementWiseData.put("TotalTaxAmt", objManagerReportBean);
				}

				mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
		    }
		    else
		    {
		    	Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = new TreeMap<String, clsManagerReportBean>();

				clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
				objManagerReportBean.setStrTaxCode(taxCode);
				objManagerReportBean.setStrTaxDesc(taxDesc);
				objManagerReportBean.setDblTaxAmt(taxAmt);
	
				objManagerReportBean = new clsManagerReportBean();
				objManagerReportBean.setStrTaxCode("TotalTaxAmt");
				objManagerReportBean.setStrTaxDesc("TotalTaxAmt");
				objManagerReportBean.setDblTaxAmt(taxAmt);
	
				mapBillWiseSettlementWiseData.put("TotalTaxAmt", objManagerReportBean);
	
				mapBillWiseSettlementWiseData.put(taxCode, objManagerReportBean);
	
				mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
		    }
		}
		}
		

		//set discount,roundoff,tip
		sbSqlLiveFile.setLength(0);
		sbSqlLiveFile.append(" SELECT sum(a.dblDiscountAmt),sum(a.dblRoundOff),sum(a.dblTipAmount),a.strBillNo "
				+ " from tblbillhd a  "
				+ " where date(a.dteBillDate) between '" + fromDate + "' and '" + toDate + "'  and a.strClientCode='"+strClientCode+"' "
				+ "  ");
		if (!posCode.equalsIgnoreCase("All"))
		{
		    sbSqlLiveFile.append(" and a.strPOSCode='" + posCode + "' ");
		}
		sbSqlLiveFile.append(" group by a.strBillNo ");
		System.out.println(sbSqlLiveFile);

		listSettleManager = objBaseService.funGetList(sbSqlLiveFile, "sql");
		if(listSettleManager.size()>0)
		{
			for(int i=0;i<listSettleManager.size();i++)
			{
				Object[] obj =(Object[]) listSettleManager.get(i);	
			    double discAmt = Double.parseDouble(obj[0].toString());//discAmt
			    double roundOffAmt =Double.parseDouble(obj[1].toString());//roundOff
			    double tipAmt = Double.parseDouble(obj[2].toString());//tipAmt
			    totalDiscAmt = totalDiscAmt + discAmt;
			    totalRoundOffAmt = totalRoundOffAmt + roundOffAmt;//roundOff
			    totalTipAmt = totalTipAmt + tipAmt;//tipAmt
			    String strBillNo = obj[3].toString();//billDate

			    //discount
			    if (mapBillWiseData.containsKey(strBillNo))
			    {
			    	Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = mapBillWiseData.get(strBillNo);
			    	if (mapBillWiseSettlementWiseData.containsKey("DiscAmt"))
			    	{
			    		clsManagerReportBean objDiscAmt = mapBillWiseSettlementWiseData.get("DiscAmt");
			    		objDiscAmt.setDblDiscAmt(objDiscAmt.getDblDiscAmt() + discAmt);
			    	}
					else
					{
					    clsManagerReportBean objDiscAmt = new clsManagerReportBean();
					    objDiscAmt.setDblDiscAmt(discAmt);
		
					    mapBillWiseSettlementWiseData.put("DiscAmt", objDiscAmt);
					}

			    }
			    else
			    {
				Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = new TreeMap<String, clsManagerReportBean>();
	
				clsManagerReportBean objDiscAmt = new clsManagerReportBean();
				objDiscAmt.setDblDiscAmt(discAmt);
	
				mapBillWiseSettlementWiseData.put("DiscAmt", objDiscAmt);
	
				mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
			    }

			    //roundoff
			    if (mapBillWiseData.containsKey(strBillNo))
			    {
			    	Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = mapBillWiseData.get(strBillNo);
			    	if (mapBillWiseSettlementWiseData.containsKey("RoundOffAmt"))
			    	{
			    		clsManagerReportBean objRoundOffAmt = mapBillWiseSettlementWiseData.get("RoundOffAmt");
			    		objRoundOffAmt.setDblRoundOffAmt(objRoundOffAmt.getDblRoundOffAmt() + roundOffAmt);
			    	}
			    	else
			    	{
			    		clsManagerReportBean objRoundOffAmt = new clsManagerReportBean();
			    		objRoundOffAmt.setDblRoundOffAmt(roundOffAmt);

			    		mapBillWiseSettlementWiseData.put("RoundOffAmt", objRoundOffAmt);
			    	}

			    }
			    else
			    {
			    	Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = new TreeMap<String, clsManagerReportBean>();

					clsManagerReportBean objRoundOffAmt = new clsManagerReportBean();
					objRoundOffAmt.setDblRoundOffAmt(roundOffAmt);
		
					mapBillWiseSettlementWiseData.put("RoundOffAmt", objRoundOffAmt);
		
					mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
			    }

			    //tip
			    if (mapBillWiseData.containsKey(strBillNo))
			    {
			    	Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = mapBillWiseData.get(strBillNo);
			    	if (mapBillWiseSettlementWiseData.containsKey("TipAmt"))
			    	{
			    		clsManagerReportBean objTipAmt = mapBillWiseSettlementWiseData.get("TipAmt");
			    		objTipAmt.setDblTipAmt(objTipAmt.getDblTipAmt() + tipAmt);
			    	}
					else
					{
					    clsManagerReportBean objTipAmt = new clsManagerReportBean();
					    objTipAmt.setDblTipAmt(tipAmt);
		
					    mapBillWiseSettlementWiseData.put("TipAmt", objTipAmt);
					}

			    }
			    else
			    {
					Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = new TreeMap<String, clsManagerReportBean>();
		
					clsManagerReportBean objTipAmt = new clsManagerReportBean();
					objTipAmt.setDblTipAmt(tipAmt);
		
					mapBillWiseSettlementWiseData.put("TipAmt", objTipAmt);
		
					mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
			    }

		}
		}
		

		sbSqlQFile.setLength(0);
		sbSqlQFile.append(" SELECT sum(a.dblDiscountAmt),sum(a.dblRoundOff),sum(a.dblTipAmount),a.strBillNo "
				+ " from tblqbillhd a"
				+ " where date(a.dteBillDate) between '" + fromDate + "' and '" + toDate + "'  and a.strClientCode='"+strClientCode+"' "
				+ "  ");
		if (!posCode.equalsIgnoreCase("All"))
		{
		    sbSqlQFile.append(" and a.strPOSCode='" + posCode + "' ");
		}
		sbSqlQFile.append(" group by a.strBillNo ");
		System.out.println(sbSqlQFile);

		listSettleManager = objBaseService.funGetList(sbSqlQFile, "sql");
		if(listSettleManager.size()>0)
		{
			for(int i=0;i<listSettleManager.size();i++)
			{
			Object[] obj = (Object[]) listSettleManager.get(i);	
		    double discAmt = Double.parseDouble(obj[0].toString());//discAmt
		    double roundOffAmt =  Double.parseDouble(obj[1].toString());//roundOff
		    double tipAmt =  Double.parseDouble(obj[2].toString());//tipAmt
		    // int noOfBills = rsSettleManager.getInt(4);//bill count
		    totalDiscAmt = totalDiscAmt + discAmt;
		    totalRoundOffAmt = totalRoundOffAmt + roundOffAmt;//roundOff
		    totalTipAmt = totalTipAmt + tipAmt;//tipAmt
		    //  totalBills = totalBills + noOfBills;//bill count
		    String strBillNo = obj[3].toString();//billDate

		    //discount
		    if (mapBillWiseData.containsKey(strBillNo))
		    {
				Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = mapBillWiseData.get(strBillNo);
				if (mapBillWiseSettlementWiseData.containsKey("DiscAmt"))
				{
				    clsManagerReportBean objDiscAmt = mapBillWiseSettlementWiseData.get("DiscAmt");
				    objDiscAmt.setDblDiscAmt(objDiscAmt.getDblDiscAmt() + discAmt);
				}
				else
				{
				    clsManagerReportBean objDiscAmt = new clsManagerReportBean();
				    objDiscAmt.setDblDiscAmt(discAmt);
	
				    mapBillWiseSettlementWiseData.put("DiscAmt", objDiscAmt);
				}

		    }
		    else
		    {
				Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = new TreeMap<String, clsManagerReportBean>();
	
				clsManagerReportBean objDiscAmt = new clsManagerReportBean();
				objDiscAmt.setDblDiscAmt(discAmt);
	
				mapBillWiseSettlementWiseData.put("DiscAmt", objDiscAmt);
	
				mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
		    }

		    //roundoff
		    if (mapBillWiseData.containsKey(strBillNo))
		    {
				Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = mapBillWiseData.get(strBillNo);
				if (mapBillWiseSettlementWiseData.containsKey("RoundOffAmt"))
				{
				    clsManagerReportBean objRoundOffAmt = mapBillWiseSettlementWiseData.get("RoundOffAmt");
				    objRoundOffAmt.setDblRoundOffAmt(objRoundOffAmt.getDblRoundOffAmt() + roundOffAmt);
				}
				else
				{
				    clsManagerReportBean objRoundOffAmt = new clsManagerReportBean();
				    objRoundOffAmt.setDblRoundOffAmt(roundOffAmt);
	
				    mapBillWiseSettlementWiseData.put("RoundOffAmt", objRoundOffAmt);
				}

		    }
		    else
		    {
				Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = new TreeMap<String, clsManagerReportBean>();
	
				clsManagerReportBean objRoundOffAmt = new clsManagerReportBean();
				objRoundOffAmt.setDblRoundOffAmt(roundOffAmt);
	
				mapBillWiseSettlementWiseData.put("RoundOffAmt", objRoundOffAmt);
	
				mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
		    }

		    //tip
		    if (mapBillWiseData.containsKey(strBillNo))
		    {
				Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = mapBillWiseData.get(strBillNo);
				if (mapBillWiseSettlementWiseData.containsKey("TipAmt"))
				{
				    clsManagerReportBean objTipAmt = mapBillWiseSettlementWiseData.get("TipAmt");
				    objTipAmt.setDblTipAmt(objTipAmt.getDblTipAmt() + tipAmt);
				}
				else
				{
				    clsManagerReportBean objTipAmt = new clsManagerReportBean();
				    objTipAmt.setDblTipAmt(tipAmt);
	
				    mapBillWiseSettlementWiseData.put("TipAmt", objTipAmt);
				}

		    }
		    else
		    {
				Map<String, clsManagerReportBean> mapDateWiseSettlementWiseData = new TreeMap<String, clsManagerReportBean>();
	
				clsManagerReportBean objTipAmt = new clsManagerReportBean();
				objTipAmt.setDblTipAmt(tipAmt);
	
				mapDateWiseSettlementWiseData.put("TipAmt", objTipAmt);
	
				mapBillWiseData.put(strBillNo, mapDateWiseSettlementWiseData);
		    }
		   
		}
		}
		

		*//**
		 * fill live date wise group wise data
		 *//*
		StringBuilder sqlGroupData = new StringBuilder();

		sqlGroupData.setLength(0);
		sqlGroupData.append("select  a.strBillNo,e.strGroupCode,e.strGroupName,sum(b.dblAmount)SubTotal,sum(b.dblDiscountAmt)Discount,sum(b.dblAmount)-sum(b.dblDiscountAmt)NetTotal "
				+ "from tblbillhd a,tblbilldtl b,tblitemmaster c,tblsubgrouphd d,tblgrouphd e "
				+ "where a.strBillNo=b.strBillNo "
				+ "AND DATE(a.dteBillDate)= DATE(b.dteBillDate) "
				+ "and b.strItemCode=c.strItemCode "
				+ "and c.strSubGroupCode=d.strSubGroupCode "
				+ "and d.strGroupCode=e.strGroupCode "
				+ "and date(a.dteBillDate) between '" + fromDate + "' and '" + toDate + "'  and a.strClientCode='"+strClientCode+"' ");
		if (!posCode.equalsIgnoreCase("All"))
		{
		    sqlGroupData.append(" and a.strPOSCode='" + posCode + "' ");
		}
		sqlGroupData.append("group by  a.strBillNo,e.strGroupCode ");
		List lisrGroupsData = objBaseService.funGetList(sqlGroupData, "sql");
		if(lisrGroupsData.size()>0)
		{
			for(int i=0;i<lisrGroupsData.size();i++)
			{
			Object[] obj = (Object[])lisrGroupsData.get(i);	
		    String strBillNo = obj[0].toString();//date
		    String groupCode = obj[1].toString();//groupCode
		    String groupName = obj[2].toString();//groupName
		    double subTotal = Double.parseDouble(obj[3].toString()); //subTotal
		    double discount = Double.parseDouble(obj[4].toString()); //discount
		    double netTotal = Double.parseDouble(obj[5].toString()); //netTotal

		    if (groupName.length() > maxGroupNameLength)
		    {
		    	maxGroupNameLength = groupName.length();
		    }
		    mapGroupNameWithLength.put(groupName, groupName.length());

		    if (mapBillWiseGroupNames.containsKey(strBillNo))
		    {
		    	Map<String, String> mapGroupNames = mapBillWiseGroupNames.get(strBillNo);

		    	mapGroupNames.put(groupCode, groupName);
		    }
		    else
		    {
		    	Map<String, String> mapGroupNames = new TreeMap<>();

		    	mapGroupNames.put(groupCode, groupName);

		    	mapBillWiseGroupNames.put(strBillNo, mapGroupNames);
		    }

		    if (mapBillWiseData.containsKey(strBillNo))
		    {
		    	Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = mapBillWiseData.get(strBillNo);

				if (mapBillWiseSettlementWiseData.containsKey(groupCode))
				{
				    clsManagerReportBean objGroupDtl = mapBillWiseSettlementWiseData.get(groupCode);
	
				    objGroupDtl.setDblSubTotal(objGroupDtl.getDblSubTotal() + subTotal);
				    objGroupDtl.setDblDisAmt(objGroupDtl.getDblDisAmt() + discount);
				    objGroupDtl.setDblNetTotal(objGroupDtl.getDblNetTotal() + netTotal);
				}
				else
				{
				    clsManagerReportBean objGroupDtl = new clsManagerReportBean();
				    objGroupDtl.setStrGroupCode(groupCode);
				    objGroupDtl.setStrGroupName(groupName);
				    objGroupDtl.setDblSubTotal(subTotal);
				    objGroupDtl.setDblDisAmt(discount);
				    objGroupDtl.setDblNetTotal(netTotal);
	
				    mapBillWiseSettlementWiseData.put(groupCode, objGroupDtl);
				}

				//put total settlement dtl
				if (mapBillWiseSettlementWiseData.containsKey("TotalGroupAmt"))
				{
				    clsManagerReportBean objManagerReportBean = mapBillWiseSettlementWiseData.get("TotalGroupAmt");
				    objManagerReportBean.setDblSubTotal(objManagerReportBean.getDblSubTotal() + subTotal);
				    objManagerReportBean.setDblNetTotal(objManagerReportBean.getDblNetTotal() + netTotal);
	
				    mapBillWiseSettlementWiseData.put("TotalGroupAmt", objManagerReportBean);
				}
				else
				{
				    clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
				    objManagerReportBean.setStrGroupCode("TotalGroupAmt");
				    objManagerReportBean.setStrGroupName("TotalGroupAmt");
				    objManagerReportBean.setDblSubTotal(subTotal);
				    objManagerReportBean.setDblNetTotal(netTotal);
	
				    mapBillWiseSettlementWiseData.put("TotalGroupAmt", objManagerReportBean);
				}
		    }
		    else
		    {
				Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = new TreeMap<String, clsManagerReportBean>();
	
				clsManagerReportBean objGroupDtl = new clsManagerReportBean();
				objGroupDtl.setStrGroupCode(groupCode);
				objGroupDtl.setStrGroupName(groupName);
				objGroupDtl.setDblSubTotal(subTotal);
				objGroupDtl.setDblDisAmt(discount);
				objGroupDtl.setDblNetTotal(netTotal);
	
				//put total settlement dtl
				clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
				objManagerReportBean.setStrGroupCode("TotalGroupAmt");
				objManagerReportBean.setStrGroupName("TotalGroupAmt");
				objManagerReportBean.setDblSubTotal(subTotal);
				objManagerReportBean.setDblNetTotal(netTotal);
	
				mapBillWiseSettlementWiseData.put("TotalGroupAmt", objManagerReportBean);
	
				mapBillWiseSettlementWiseData.put(groupCode, objGroupDtl);
	
				mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
		    }
		}
		}

		*//**
		 * fill live modifiers date wise group wise data
		 *//*
		sqlGroupData.setLength(0);
		sqlGroupData.append("select a.strBillNo,e.strGroupCode,e.strGroupName,sum(b.dblAmount)SubTotal,sum(b.dblDiscAmt)Discount,sum(b.dblAmount)-sum(b.dblDiscAmt)NetTotal "
				+ "from tblbillhd a,tblbillmodifierdtl b,tblitemmaster c,tblsubgrouphd d,tblgrouphd e "
				+ "where a.strBillNo=b.strBillNo "
				+ "AND DATE(a.dteBillDate)= DATE(b.dteBillDate) "
				+ "and left(b.strItemCode,7)=c.strItemCode "
				+ "and c.strSubGroupCode=d.strSubGroupCode "
				+ "and d.strGroupCode=e.strGroupCode "
				+ "and date(a.dteBillDate) between '" + fromDate + "' and '" + toDate + "'  and a.strClientCode='"+strClientCode+"' ");
		if (!posCode.equalsIgnoreCase("All"))
		{
		    sqlGroupData.append(" and a.strPOSCode='" + posCode + "' ");
		}
		sqlGroupData.append("group by a.strBillNo,e.strGroupCode ");
		List listGroupsData = objBaseService.funGetList(sqlGroupData, "sql");
		if(listGroupsData.size()>0)
		{
			for(int i=0;i<listGroupsData.size();i++)
			{
			Object[] obj = (Object[])listGroupsData.get(i);	
		    String strBillNo = obj[0].toString();//date
		    String groupCode = obj[1].toString();//groupCode
		    String groupName = obj[2].toString();//groupName
		    double subTotal = Double.parseDouble(obj[3].toString()); //subTotal
		    double discount = Double.parseDouble(obj[4].toString()); //discount
		    double netTotal = Double.parseDouble(obj[5].toString()); //netTotal

		    if (groupName.length() > maxGroupNameLength)
		    {
		    	maxGroupNameLength = groupName.length();
		    }
		    mapGroupNameWithLength.put(groupName, groupName.length());

		    if (mapBillWiseGroupNames.containsKey(strBillNo))
		    {
		    	Map<String, String> mapGroupNames = mapBillWiseGroupNames.get(strBillNo);

		    	mapGroupNames.put(groupCode, groupName);
		    }
		    else
		    {
				Map<String, String> mapGroupNames = new TreeMap<>();
	
				mapGroupNames.put(groupCode, groupName);
	
				mapBillWiseGroupNames.put(strBillNo, mapGroupNames);
		    }

		    if (mapBillWiseData.containsKey(strBillNo))
		    {
		    	Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = mapBillWiseData.get(strBillNo);

				if (mapBillWiseSettlementWiseData.containsKey(groupCode))
				{
				    clsManagerReportBean objGroupDtl = mapBillWiseSettlementWiseData.get(groupCode);
	
				    objGroupDtl.setDblSubTotal(objGroupDtl.getDblSubTotal() + subTotal);
				    objGroupDtl.setDblDisAmt(objGroupDtl.getDblDisAmt() + discount);
				    objGroupDtl.setDblNetTotal(objGroupDtl.getDblNetTotal() + netTotal);
				}
				else
				{
				    clsManagerReportBean objGroupDtl = new clsManagerReportBean();
				    objGroupDtl.setStrGroupCode(groupCode);
				    objGroupDtl.setStrGroupName(groupName);
				    objGroupDtl.setDblSubTotal(subTotal);
				    objGroupDtl.setDblDisAmt(discount);
				    objGroupDtl.setDblNetTotal(netTotal);
	
				    mapBillWiseSettlementWiseData.put(groupCode, objGroupDtl);
				}

				//put total settlement dtl
				if (mapBillWiseSettlementWiseData.containsKey("TotalGroupAmt"))
				{
				    clsManagerReportBean objManagerReportBean = mapBillWiseSettlementWiseData.get("TotalGroupAmt");
				    objManagerReportBean.setDblSubTotal(objManagerReportBean.getDblSubTotal() + subTotal);
				    objManagerReportBean.setDblNetTotal(objManagerReportBean.getDblNetTotal() + netTotal);
	
				    mapBillWiseSettlementWiseData.put("TotalGroupAmt", objManagerReportBean);
				}
				else
				{
				    clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
				    objManagerReportBean.setStrGroupCode("TotalGroupAmt");
				    objManagerReportBean.setStrGroupName("TotalGroupAmt");
				    objManagerReportBean.setDblSubTotal(subTotal);
				    objManagerReportBean.setDblNetTotal(netTotal);
	
				    mapBillWiseSettlementWiseData.put("TotalGroupAmt", objManagerReportBean);
				}
		    }
		    else
		    {
				Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = new TreeMap<String, clsManagerReportBean>();
	
				clsManagerReportBean objGroupDtl = new clsManagerReportBean();
				objGroupDtl.setStrGroupCode(groupCode);
				objGroupDtl.setStrGroupName(groupName);
				objGroupDtl.setDblSubTotal(subTotal);
				objGroupDtl.setDblDisAmt(discount);
				objGroupDtl.setDblNetTotal(netTotal);
	
				//put total settlement dtl
				clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
				objManagerReportBean.setStrGroupCode("TotalGroupAmt");
				objManagerReportBean.setStrGroupName("TotalGroupAmt");
				objManagerReportBean.setDblSubTotal(subTotal);
				objManagerReportBean.setDblNetTotal(netTotal);
	
				mapBillWiseSettlementWiseData.put("TotalGroupAmt", objManagerReportBean);
	
				mapBillWiseSettlementWiseData.put(groupCode, objGroupDtl);
	
				mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
		    }
		}
		}
		

		*//**
		 * fill Q date wise group wise data
		 *//*
		sqlGroupData.setLength(0);
		sqlGroupData.append("select a.strBillNo,e.strGroupCode,e.strGroupName,sum(b.dblAmount)SubTotal,sum(b.dblDiscountAmt)Discount,sum(b.dblAmount)-sum(b.dblDiscountAmt)NetTotal "
				+ "from tblqbillhd a,tblqbilldtl b,tblitemmaster c,tblsubgrouphd d,tblgrouphd e "
				+ "where a.strBillNo=b.strBillNo "
				+ "AND DATE(a.dteBillDate)= DATE(b.dteBillDate) "
				+ "and b.strItemCode=c.strItemCode "
				+ "and c.strSubGroupCode=d.strSubGroupCode "
				+ "and d.strGroupCode=e.strGroupCode "
				+ "and date(a.dteBillDate) between '" + fromDate + "' and '" + toDate + "'  and a.strClientCode='"+strClientCode+"' ");
		if (!posCode.equalsIgnoreCase("All"))
		{
		    sqlGroupData.append(" and a.strPOSCode='" + posCode + "' ");
		}
		sqlGroupData.append("group by a.strBillNo,e.strGroupCode ");
		listGroupsData = objBaseService.funGetList(sqlGroupData, "sql");
		if(listGroupsData.size()>0)
		{
			for(int i=0;i<listGroupsData.size();i++)
			{
			Object[] obj = (Object[]) listGroupsData.get(i);	
			String strBillNo = obj[0].toString();//date
		    String groupCode = obj[1].toString();//groupCode
		    String groupName = obj[2].toString();//groupName
		    double subTotal = Double.parseDouble(obj[3].toString()); //subTotal
		    double discount = Double.parseDouble(obj[4].toString()); //discount
		    double netTotal = Double.parseDouble(obj[5].toString()); //netTotal

		    if (groupName.length() > maxGroupNameLength)
		    {
		    	maxGroupNameLength = groupName.length();
		    }
		    mapGroupNameWithLength.put(groupName, groupName.length());

		    if (mapBillWiseGroupNames.containsKey(strBillNo))
		    {
		    	Map<String, String> mapGroupNames = mapBillWiseGroupNames.get(strBillNo);

		    	mapGroupNames.put(groupCode, groupName);
		    }
		    else
		    {
				Map<String, String> mapGroupNames = new TreeMap<>();
	
				mapGroupNames.put(groupCode, groupName);
	
				mapBillWiseGroupNames.put(strBillNo, mapGroupNames);
		    }

		    if (mapBillWiseData.containsKey(strBillNo))
		    {
		    	Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = mapBillWiseData.get(strBillNo);

				if (mapBillWiseSettlementWiseData.containsKey(groupCode))
				{
				    clsManagerReportBean objGroupDtl = mapBillWiseSettlementWiseData.get(groupCode);
	
				    objGroupDtl.setDblSubTotal(objGroupDtl.getDblSubTotal() + subTotal);
				    objGroupDtl.setDblDisAmt(objGroupDtl.getDblDisAmt() + discount);
				    objGroupDtl.setDblNetTotal(objGroupDtl.getDblNetTotal() + netTotal);
				}
				else
				{
				    clsManagerReportBean objGroupDtl = new clsManagerReportBean();
				    objGroupDtl.setStrGroupCode(groupCode);
				    objGroupDtl.setStrGroupName(groupName);
				    objGroupDtl.setDblSubTotal(subTotal);
				    objGroupDtl.setDblDisAmt(discount);
				    objGroupDtl.setDblNetTotal(netTotal);
	
				    mapBillWiseSettlementWiseData.put(groupCode, objGroupDtl);
				}

				//put total settlement dtl
				if (mapBillWiseSettlementWiseData.containsKey("TotalGroupAmt"))
				{
				    clsManagerReportBean objManagerReportBean = mapBillWiseSettlementWiseData.get("TotalGroupAmt");
				    objManagerReportBean.setDblSubTotal(objManagerReportBean.getDblSubTotal() + subTotal);
				    objManagerReportBean.setDblNetTotal(objManagerReportBean.getDblNetTotal() + netTotal);
	
				    mapBillWiseSettlementWiseData.put("TotalGroupAmt", objManagerReportBean);
				}
				else
				{
				    clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
				    objManagerReportBean.setStrGroupCode("TotalGroupAmt");
				    objManagerReportBean.setStrGroupName("TotalGroupAmt");
				    objManagerReportBean.setDblSubTotal(subTotal);
				    objManagerReportBean.setDblNetTotal(netTotal);
	
				    mapBillWiseSettlementWiseData.put("TotalGroupAmt", objManagerReportBean);
				}
		    }
		    else
		    {
				Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = new TreeMap<String, clsManagerReportBean>();
	
				clsManagerReportBean objGroupDtl = new clsManagerReportBean();
				objGroupDtl.setStrGroupCode(groupCode);
				objGroupDtl.setStrGroupName(groupName);
				objGroupDtl.setDblSubTotal(subTotal);
				objGroupDtl.setDblDisAmt(discount);
				objGroupDtl.setDblNetTotal(netTotal);
	
				//put total settlement dtl
				clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
				objManagerReportBean.setStrGroupCode("TotalGroupAmt");
				objManagerReportBean.setStrGroupName("TotalGroupAmt");
				objManagerReportBean.setDblSubTotal(subTotal);
				objManagerReportBean.setDblNetTotal(netTotal);
	
				mapBillWiseSettlementWiseData.put("TotalGroupAmt", objManagerReportBean);
	
				mapBillWiseSettlementWiseData.put(groupCode, objGroupDtl);
	
				mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
		    }
		}
		}
		

		*//**
		 * fill Q modifiers date wise group wise data
		 *//*
		sqlGroupData.setLength(0);
		sqlGroupData.append("select a.strBillNo,e.strGroupCode,e.strGroupName,sum(b.dblAmount)SubTotal,sum(b.dblDiscAmt)Discount,sum(b.dblAmount)-sum(b.dblDiscAmt)NetTotal "
				+ "from tblqbillhd a,tblqbillmodifierdtl b,tblitemmaster c,tblsubgrouphd d,tblgrouphd e "
				+ "where a.strBillNo=b.strBillNo "
				+ "AND DATE(a.dteBillDate)= DATE(b.dteBillDate) "
				+ "and left(b.strItemCode,7)=c.strItemCode "
				+ "and c.strSubGroupCode=d.strSubGroupCode "
				+ "and d.strGroupCode=e.strGroupCode "
				+ "and date(a.dteBillDate) between '" + fromDate + "' and '" + toDate + "'  and a.strClientCode='"+strClientCode+"' ");
		if (!posCode.equalsIgnoreCase("All"))
		{
		    sqlGroupData.append(" and a.strPOSCode='" + posCode + "' ");
		}
		sqlGroupData.append("group by a.strBillNo,e.strGroupCode ");
		listGroupsData = objBaseService.funGetList(sqlGroupData, "sql");
		if(listGroupsData.size()>0)
		{
			for(int i=0;i<listGroupsData.size();i++)
			{
			Object[] obj = (Object[])listGroupsData.get(i);	
		    String strBillNo = obj[0].toString();//date
		    String groupCode = obj[1].toString();//groupCode
		    String groupName = obj[2].toString();//groupName
		    double subTotal = Double.parseDouble(obj[3].toString()); //subTotal
		    double discount = Double.parseDouble(obj[4].toString()); //discount
		    double netTotal = Double.parseDouble(obj[5].toString()); //netTotal

		    if (groupName.length() > maxGroupNameLength)
		    {
		    	maxGroupNameLength = groupName.length();
		    }
		    mapGroupNameWithLength.put(groupName, groupName.length());

		    if (mapBillWiseGroupNames.containsKey(strBillNo))
		    {
		    	Map<String, String> mapGroupNames = mapBillWiseGroupNames.get(strBillNo);

		    	mapGroupNames.put(groupCode, groupName);
		    }
		    else
		    {
				Map<String, String> mapGroupNames = new TreeMap<>();
	
				mapGroupNames.put(groupCode, groupName);
	
				mapBillWiseGroupNames.put(strBillNo, mapGroupNames);
		    }

		    if (mapBillWiseData.containsKey(strBillNo))
		    {
		    	Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = mapBillWiseData.get(strBillNo);

				if (mapBillWiseSettlementWiseData.containsKey(groupCode))
				{
				    clsManagerReportBean objGroupDtl = mapBillWiseSettlementWiseData.get(groupCode);
	
				    objGroupDtl.setDblSubTotal(objGroupDtl.getDblSubTotal() + subTotal);
				    objGroupDtl.setDblDisAmt(objGroupDtl.getDblDisAmt() + discount);
				    objGroupDtl.setDblNetTotal(objGroupDtl.getDblNetTotal() + netTotal);
				}
				else
				{
				    clsManagerReportBean objGroupDtl = new clsManagerReportBean();
				    objGroupDtl.setStrGroupCode(groupCode);
				    objGroupDtl.setStrGroupName(groupName);
				    objGroupDtl.setDblSubTotal(subTotal);
				    objGroupDtl.setDblDisAmt(discount);
				    objGroupDtl.setDblNetTotal(netTotal);
	
				    mapBillWiseSettlementWiseData.put(groupCode, objGroupDtl);
				}

				//put total settlement dtl
				if (mapBillWiseSettlementWiseData.containsKey("TotalGroupAmt"))
				{
				    clsManagerReportBean objManagerReportBean = mapBillWiseSettlementWiseData.get("TotalGroupAmt");
				    objManagerReportBean.setDblSubTotal(objManagerReportBean.getDblSubTotal() + subTotal);
				    objManagerReportBean.setDblNetTotal(objManagerReportBean.getDblNetTotal() + netTotal);
	
				    mapBillWiseSettlementWiseData.put("TotalGroupAmt", objManagerReportBean);
				}
				else
				{
				    clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
				    objManagerReportBean.setStrGroupCode("TotalGroupAmt");
				    objManagerReportBean.setStrGroupName("TotalGroupAmt");
				    objManagerReportBean.setDblSubTotal(subTotal);
				    objManagerReportBean.setDblNetTotal(netTotal);
	
				    mapBillWiseSettlementWiseData.put("TotalGroupAmt", objManagerReportBean);
				}
		    }
		    else
		    {
				Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = new TreeMap<String, clsManagerReportBean>();
	
				clsManagerReportBean objGroupDtl = new clsManagerReportBean();
				objGroupDtl.setStrGroupCode(groupCode);
				objGroupDtl.setStrGroupName(groupName);
				objGroupDtl.setDblSubTotal(subTotal);
				objGroupDtl.setDblDisAmt(discount);
				objGroupDtl.setDblNetTotal(netTotal);
	
				//put total settlement dtl
				clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
				objManagerReportBean.setStrGroupCode("TotalGroupAmt");
				objManagerReportBean.setStrGroupName("TotalGroupAmt");
				objManagerReportBean.setDblSubTotal(subTotal);
				objManagerReportBean.setDblNetTotal(netTotal);
	
				mapBillWiseSettlementWiseData.put("TotalGroupAmt", objManagerReportBean);
	
				mapBillWiseSettlementWiseData.put(groupCode, objGroupDtl);
	
				mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
		    }
		}
		}
		
		*//**
		 * new logic for gross sales
		 *//*
		Map<String, Map<String, Double>> mapSettelemtWiseGroupBreakup = new TreeMap<>();
		Map<String, Map<String, Double>> mapSettelemtWiseTaxBreakup = new TreeMap<>();
		*//**
		 * new logic for gross sales
		 *//*

		if (mapBillWiseData.size() > 0)
		{
		    for (Map.Entry<String, Map<String, clsManagerReportBean>> entrySet : mapBillWiseData.entrySet())
		    {
		    	String strBillNo = entrySet.getKey();
		    	Map<String, clsManagerReportBean> mapBillWiseGroupTaxSettlementData = entrySet.getValue();

		    	clsManagerReportBean objTotalSettlementAmt = mapBillWiseGroupTaxSettlementData.get("TotalSettlementAmt");
		    	double totalSettlementAmt = 0;
				if (objTotalSettlementAmt != null)
				{
				    totalSettlementAmt = objTotalSettlementAmt.getDblSettlementAmt();
				}
				clsManagerReportBean objTotalTaxAmt = mapBillWiseGroupTaxSettlementData.get("TotalTaxAmt");
				totalTaxAmt = 0;
				if (objTotalTaxAmt != null)
				{
				    totalTaxAmt = objTotalTaxAmt.getDblTaxAmt();
				}

				clsManagerReportBean objTotalGroupAmt = mapBillWiseGroupTaxSettlementData.get("TotalGroupAmt");
				//double totalGroupSubTotal = objTotalGroupAmt.getDblSubTotal();
				double totalGroupNetTotal = 0;
				if (objTotalGroupAmt != null)
				{
				    totalGroupNetTotal = objTotalGroupAmt.getDblNetTotal();
				}

			
				String labelSettlement = "SETTLEMENT          |";
	
				String horizontalTotalLabel = "  TOTALS   |";

				//pw.println();
				//pw.print(strBillNo);

				Map<String, String> mapBillWiseTaxeNames = mapBillWiseTaxNames.get(strBillNo);
				if (mapBillWiseTaxeNames != null)
				{
				    if (mapBillWiseGroupNames.containsKey(strBillNo))
				    {
					Map<String, String> mapGroupNames = mapBillWiseGroupNames.get(strBillNo);
					for (Map.Entry<String, String> entryGroupNames : mapGroupNames.entrySet())
					{

					    String groupCode = entryGroupNames.getKey();
					    String groupName = entryGroupNames.getValue();
					    if (groupName.length() > maxGroupNameLength)
					    {
							maxGroupNameLength = groupName.length();
					    }

					    clsManagerReportBean objGroupDtl = mapBillWiseGroupTaxSettlementData.get(groupCode);
					    //double groupSubTotal = objGroupDtl.getDblSubTotal();
					    double groupNetTotal = objGroupDtl.getDblNetTotal();
	
					    *//**
					     * print a line
					     *//*
					    int lineCount = funGetLineCount(strBillNo, labelSettlement, groupName, horizontalTotalLabel, mapBillWiseData, mapBillWiseSettlementNames, mapBillWiseTaxNames);
					  //  pw.println();
					    for (int i = 0; i < lineCount; i++)
					    {
						//pw.print("-");
					    }
					    if (lineCount > maxLineCount)
					    {
						maxLineCount = lineCount;
					    }

					    *//**
					     * print header line
					     *//*
					    //pw.println();
					    //pw.print(objUtility.funPrintTextWithAlignment(labelSettlement, labelSettlement.length(), "Left"));
					    //pw.print(objUtility.funPrintTextWithAlignment(groupName + "|", groupName.length(), "Left"));
					    if (mapBillWiseTaxeNames != null)
					    {
							for (String taxDesc : mapBillWiseTaxeNames.values())
							{
							    String labelTaxDesc = taxDesc + "|";
							    //pw.print(objUtility.funPrintTextWithAlignment(labelTaxDesc, labelTaxDesc.length(), "Left"));
							}
					    }
				    //pw.print(objUtility.funPrintTextWithAlignment(horizontalTotalLabel, horizontalTotalLabel.length(), "Left"));

				    *//**
				     * print settlement wise data
				     *//*
				   // pw.println();
				    Map<String, String> mapSettlementNames = mapBillWiseSettlementNames.get(strBillNo);

				    if (mapSettlementNames != null)
				    {
						for (Map.Entry<String, String> entrySettlements : mapSettlementNames.entrySet())
						{
						    String settlementCode = entrySettlements.getKey();
						    String settlementName = entrySettlements.getValue();
	
						    double horizontalTotalAmt = 0.00;
	
						    clsManagerReportBean objSettlementDtl = mapBillWiseGroupTaxSettlementData.get(settlementCode);
	
						    double groupSubTotalForThisSettlement = 0.00;
						    if (totalSettlementAmt > 0)
						    {
						    	groupSubTotalForThisSettlement = (groupNetTotal / totalSettlementAmt) * objSettlementDtl.getDblSettlementAmt();
						    }
						    horizontalTotalAmt += groupSubTotalForThisSettlement;

					    //new added for groups
						    if (mapSettelemtWiseGroupBreakup.containsKey(settlementName))
						    {
								Map<String, Double> mapGroupBreakup = mapSettelemtWiseGroupBreakup.get(settlementName);
								if (mapGroupBreakup.containsKey(groupName))
								{
								    mapGroupBreakup.put(groupName, mapGroupBreakup.get(groupName) + groupSubTotalForThisSettlement);
		
								    mapSettelemtWiseGroupBreakup.put(settlementName, mapGroupBreakup);
								}
							else
							{
							    mapGroupBreakup.put(groupName, groupSubTotalForThisSettlement);
	
							    mapSettelemtWiseGroupBreakup.put(settlementName, mapGroupBreakup);
							}
					    }
					    else
					    {
							Map<String, Double> mapGroupBreakup = new TreeMap<String, Double>();
	
							mapGroupBreakup.put(groupName, groupSubTotalForThisSettlement);
	
							mapSettelemtWiseGroupBreakup.put(settlementName, mapGroupBreakup);
					    }

					    //pw.println();
					   // pw.print(objUtility.funPrintTextWithAlignment(settlementName, labelSettlement.length(), "Left"));
					   // pw.print(objUtility.funPrintTextWithAlignment(String.valueOf(Math.rint(groupSubTotalForThisSettlement) + "|"), groupName.length(), "Right"));
					    if (mapBillWiseTaxeNames != null)
					    {
							for (Map.Entry<String, String> entryTaxNames : mapBillWiseTaxeNames.entrySet())
							{
							    String taxCode = entryTaxNames.getKey();
							    String taxName = entryTaxNames.getValue();
	
							    String labelTaxDesc = taxName + "|";
	
							    clsManagerReportBean objTaxDtl = mapBillWiseGroupTaxSettlementData.get(taxCode);
							    double taxAmt = objTaxDtl.getDblTaxAmt();
	
							    double taxWiseGroupTotal = funGetTaxWiseGroupTotal(strBillNo, taxCode, mapBillWiseGroupTaxSettlementData);
	
							    double taxAmtForThisTax = 0.00;
							    boolean isApplicable = isApplicableTaxOnGroup(taxCode, groupCode);

							    if (taxWiseGroupTotal > 0 && isApplicable)
							    {
							    	taxAmtForThisTax = (taxAmt / taxWiseGroupTotal) * groupSubTotalForThisSettlement;
							    }
							    horizontalTotalAmt += taxAmtForThisTax;

							    //new added for taxes
							    String key = settlementName + "!" + groupName + "!" + taxName;
							    if (mapSettelemtWiseTaxBreakup.containsKey(settlementName))
							    {
								Map<String, Double> mapTaxBreakup = mapSettelemtWiseTaxBreakup.get(settlementName);
								if (mapTaxBreakup.containsKey(key))
								{
									mapTaxBreakup.put(key, mapTaxBreakup.get(key) + taxAmtForThisTax);

									mapSettelemtWiseTaxBreakup.put(settlementName, mapTaxBreakup);
								}
								else
								{
								    mapTaxBreakup.put(key, taxAmtForThisTax);
	
								    mapSettelemtWiseTaxBreakup.put(settlementName, mapTaxBreakup);
								}
						    }
						    else
						    {
						    	Map<String, Double> mapTaxBreakup = new TreeMap<String, Double>();

						    	mapTaxBreakup.put(key, taxAmtForThisTax);

						    	mapSettelemtWiseTaxBreakup.put(settlementName, mapTaxBreakup);
						    }

						   // pw.print(objUtility.funPrintTextWithAlignment(String.valueOf(Math.rint(taxAmtForThisTax)) + "|", labelTaxDesc.length(), "Right"));
						}
					    }
					    //pw.print(objUtility.funPrintTextWithAlignment(String.valueOf(Math.rint(horizontalTotalAmt)) + "|", horizontalTotalLabel.length(), "Right"));
					}
				    }
				    *//**
				     * print total line
				     *//*
				    //pw.println();
				    for (int i = 0; i < lineCount; i++)
				    {
				    	pw.print("-");
				    }
				    pw.println();
				    pw.print(objUtility.funPrintTextWithAlignment(groupName.toUpperCase() + " TOTALS", labelSettlement.length(), "Left"));
				    pw.print(objUtility.funPrintTextWithAlignment(String.valueOf(Math.rint(groupNetTotal)) + "|", groupName.length(), "Right"));
				    
				    if (mapBillWiseTaxeNames != null)
				    {
						for (Map.Entry<String, String> entryTaxNames : mapBillWiseTaxeNames.entrySet())
						{
						    String taxCode = entryTaxNames.getKey();
						    String taxName = entryTaxNames.getValue();
	
						    String labelTaxDesc = taxName + "|";
						    double taxAmt = 0.00;
	
						    boolean isApplicable = isApplicableTaxOnGroup(taxCode, groupCode);
						    if (isApplicable)
						    {
							double taxWiseGroupTotal = funGetTaxWiseGroupTotal(strBillNo, taxCode, mapBillWiseGroupTaxSettlementData);
							clsManagerReportBean objTaxDtl = mapBillWiseGroupTaxSettlementData.get(taxCode);
							double totalTaxAmtForGroup = objTaxDtl.getDblTaxAmt();

							if (taxWiseGroupTotal > 0)
							{
							    taxAmt = (totalTaxAmtForGroup / taxWiseGroupTotal) * groupNetTotal;
							}
					    }
					    //pw.print(objUtility.funPrintTextWithAlignment(String.valueOf(Math.rint(taxAmt)) + "|", labelTaxDesc.length(), "Right"));
					}
				    }
				    pw.println();
				    for (int i = 0; i < lineCount; i++)
				    {
				    	pw.print("-");
				    }
				    pw.println();
				    pw.println();

				}
			    }
			    else
			    {
			    	continue;
			    }
			}
			*//**
			 * print total line
			 *//*
			//pw.println();
			for (int i = 0; i < maxLineCount; i++)
			{
			   // pw.print("-");
			}
			pw.println();
			pw.print(objUtility.funPrintTextWithAlignment(strBillNo + " TOTALS", labelSettlement.length(), "Left"));
			pw.print(objUtility.funPrintTextWithAlignment(String.valueOf(Math.rint(totalGroupNetTotal)) + "|", maxGroupNameLength, "Right"));
			
			double BillTotal = totalGroupNetTotal;
			if (mapBillWiseTaxeNames != null)
			{
			    for (Map.Entry<String, String> entryTaxNames : mapBillWiseTaxeNames.entrySet())
			    {
					String taxCode = entryTaxNames.getKey();
					String taxName = entryTaxNames.getValue();
	
					String labelTaxDesc = "  " + taxName + "|";
	
					clsManagerReportBean objTaxDtl = mapBillWiseGroupTaxSettlementData.get(taxCode);
					double totalTaxAmtForGroup = objTaxDtl.getDblTaxAmt();
					BillTotal += totalTaxAmtForGroup;
					//pw.print(objUtility.funPrintTextWithAlignment(String.valueOf(Math.rint(totalTaxAmtForGroup)) + "|", labelTaxDesc.length(), "Right"));
			    }
			}

			pw.print(objUtility.funPrintTextWithAlignment(Math.rint(BillTotal) + "|", horizontalTotalLabel.length(), "Center"));
			pw.println();
			for (int i = 0; i < maxLineCount; i++)
			{
			    pw.print("-");
			}
			pw.println();
			pw.println();
			
			//System.out.println(strBillNo);
			
			
		   }   
		}*/
		sbSqlLiveFile.setLength(0);
		sbSqlLiveFile.append(" select a.strBillNo,c.strSettelmentCode,c.strSettelmentDesc,b.dblSettlementAmt,DATE_FORMAT(date(a.dteBillDate),'%d-%m-%Y')dteBillDate "
			+ ",a.dblRoundOff "
			+ " from tblbillhd a,tblbillsettlementdtl b,tblsettelmenthd c "
			+ " where a.strBillNo=b.strBillNo "
			+ " and date(a.dteBillDate)=date(b.dteBillDate) "
			+ " and b.strSettlementCode=c.strSettelmentCode "
			+ " and a.strClientCode=b.strClientCode "//and a.strSettelmentMode!='MultiSettle'
			+ " and date(a.dteBillDate) between '" + fromDate + "' and '" + toDate + "' and a.strClientCode='"+strClientCode+"' "
			+ " and c.strSettelmentType!='Complementary' "
			+ " ");
		if (!posCode.equalsIgnoreCase("All"))
		{
		    sbSqlLiveFile.append(" and a.strPOSCode='" + posCode + "' ");
		}
		sbSqlLiveFile.append(" order BY a.strBillNo,c.strSettelmentDesc ");
		System.out.println(sbSqlLiveFile);

		List listSettleManager = objBaseService.funGetList(sbSqlLiveFile, "sql");
		if(listSettleManager.size()>0)
		{
		      for(int i=0;i<listSettleManager.size();i++)
		      {	
		            Object[] obj = (Object[])listSettleManager.get(i);	
			    String strBillNo = obj[0].toString();
			    String settlementCode = obj[1].toString();
			    String settlementDesc = obj[2].toString();
			    double settleAmt = Double.parseDouble(obj[3].toString());
			    String billDate = obj[4].toString();
			    double roundOffAmt =Double.parseDouble(obj[5].toString());

		    if (settlementDesc.length() > maxSettlementNameLength)
		    {
			maxSettlementNameLength = settlementDesc.length();
		    }

		    totalSettleAmt = totalSettleAmt + settleAmt;

		    if (mapBillWiseSettlementNames.containsKey(strBillNo))
		    {
			Map<String, String> mapSettlementNames = mapBillWiseSettlementNames.get(strBillNo);

			mapSettlementNames.put(settlementCode, settlementDesc);
		    }
		    else
		    {
			Map<String, String> mapSettlementNames = new TreeMap<>();

			mapSettlementNames.put(settlementCode, settlementDesc);

			mapBillWiseSettlementNames.put(strBillNo, mapSettlementNames);
		    }

		    if (mapBillWiseData.containsKey(strBillNo))
		    {
			Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = mapBillWiseData.get(strBillNo);

			//put settlement dtl
			if (mapBillWiseSettlementWiseData.containsKey(settlementCode))
			{
			    clsManagerReportBean objManagerReportBean = mapBillWiseSettlementWiseData.get(settlementCode);
			    objManagerReportBean.setDblSettlementAmt(objManagerReportBean.getDblSettlementAmt() + settleAmt);

			    mapBillWiseSettlementWiseData.put(settlementCode, objManagerReportBean);
			}
			else
			{
			    clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
			    objManagerReportBean.setStrSettlementCode(settlementCode);
			    objManagerReportBean.setStrSettlementDesc(settlementDesc);
			    objManagerReportBean.setDblSettlementAmt(settleAmt);

			    mapBillWiseSettlementWiseData.put(settlementCode, objManagerReportBean);
			}
			//put total settlement dtl
			if (mapBillWiseSettlementWiseData.containsKey("TotalSettlementAmt"))
			{
			    clsManagerReportBean objManagerReportBean = mapBillWiseSettlementWiseData.get("TotalSettlementAmt");
			    objManagerReportBean.setDblSettlementAmt(objManagerReportBean.getDblSettlementAmt() + settleAmt);

			    mapBillWiseSettlementWiseData.put("TotalSettlementAmt", objManagerReportBean);
			}
			else
			{
			    clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
			    objManagerReportBean.setStrSettlementCode("TotalSettlementAmt");
			    objManagerReportBean.setStrSettlementDesc("TotalSettlementAmt");
			    objManagerReportBean.setDblSettlementAmt(settleAmt);

			    mapBillWiseSettlementWiseData.put("TotalSettlementAmt", objManagerReportBean);
			}

			mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
		    }
		    else
		    {
			Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = new TreeMap<String, clsManagerReportBean>();

			//put settlement dtl
			clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
			objManagerReportBean.setStrSettlementCode(settlementCode);
			objManagerReportBean.setStrSettlementDesc(settlementDesc);
			objManagerReportBean.setDblSettlementAmt(settleAmt);
			objManagerReportBean.setDblRoundOffAmt(roundOffAmt);

			mapBillWiseSettlementWiseData.put(settlementCode, objManagerReportBean);

			//put total settlement dtl
			objManagerReportBean = new clsManagerReportBean();
			objManagerReportBean.setStrSettlementCode("TotalSettlementAmt");
			objManagerReportBean.setStrSettlementDesc("TotalSettlementAmt");
			objManagerReportBean.setDblSettlementAmt(settleAmt);

			mapBillWiseSettlementWiseData.put("TotalSettlementAmt", objManagerReportBean);

			mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
		   }
		} 
	 }
		

		sbSqlQFile.setLength(0);
		sbSqlQFile.append(" select a.strBillNo,c.strSettelmentCode,c.strSettelmentDesc,b.dblSettlementAmt,DATE_FORMAT(date(a.dteBillDate),'%d-%m-%Y')dteBillDate "
			+ ",a.dblRoundOff "
			+ " from tblqbillhd a,tblqbillsettlementdtl b,tblsettelmenthd c "
			+ " where a.strBillNo=b.strBillNo "
			+ " and date(a.dteBillDate)=date(b.dteBillDate) "
			+ " and b.strSettlementCode=c.strSettelmentCode "
			+ " and a.strClientCode=b.strClientCode "//and a.strSettelmentMode!='MultiSettle' 
			+ " and date(a.dteBillDate) between '" + fromDate + "' and '" + toDate + "' "
			+ " and c.strSettelmentType!='Complementary' ");
		if (!posCode.equalsIgnoreCase("All"))
		{
		    sbSqlQFile.append(" and a.strPOSCode='" + posCode + "' ");
		}
		sbSqlQFile.append(" order BY a.strBillNo,c.strSettelmentDesc ");
	        listSettleManager = objBaseService.funGetList(sbSqlQFile, "sql");

		if(listSettleManager.size()>0)
		{
		    for(int i=0;i<listSettleManager.size();i++)
		    {
		          Object[] obj = (Object[])listSettleManager.get(i);
			    String strBillNo = obj[0].toString();
			    String settlementCode = obj[1].toString();
			    String settlementDesc = obj[2].toString();
			    double settleAmt = Double.parseDouble(obj[3].toString());
			    String billDate = obj[4].toString();

		            double roundOffAmt = Double.parseDouble(obj[5].toString());

		    if (settlementDesc.length() > maxSettlementNameLength)
		    {
			maxSettlementNameLength = settlementDesc.length();
		    }

		    totalSettleAmt = totalSettleAmt + settleAmt;

		    if (mapBillWiseSettlementNames.containsKey(strBillNo))
		    {
			Map<String, String> mapSettlementNames = mapBillWiseSettlementNames.get(strBillNo);

			mapSettlementNames.put(settlementCode, settlementDesc);
		    }
		    else
		    {
			Map<String, String> mapSettlementNames = new TreeMap<>();

			mapSettlementNames.put(settlementCode, settlementDesc);

			mapBillWiseSettlementNames.put(strBillNo, mapSettlementNames);
		    }

		    if (mapBillWiseData.containsKey(strBillNo))
		    {
			Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = mapBillWiseData.get(strBillNo);

			//put settlement dtl
			if (mapBillWiseSettlementWiseData.containsKey(settlementCode))
			{
			    clsManagerReportBean objManagerReportBean = mapBillWiseSettlementWiseData.get(settlementCode);
			    objManagerReportBean.setDblSettlementAmt(objManagerReportBean.getDblSettlementAmt() + settleAmt);

			    mapBillWiseSettlementWiseData.put(settlementCode, objManagerReportBean);
			}
			else
			{
			    clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
			    objManagerReportBean.setStrSettlementCode(settlementCode);
			    objManagerReportBean.setStrSettlementDesc(settlementDesc);
			    objManagerReportBean.setDblSettlementAmt(settleAmt);

			    mapBillWiseSettlementWiseData.put(settlementCode, objManagerReportBean);
			}
			//put total settlement dtl
			if (mapBillWiseSettlementWiseData.containsKey("TotalSettlementAmt"))
			{
			    clsManagerReportBean objManagerReportBean = mapBillWiseSettlementWiseData.get("TotalSettlementAmt");
			    objManagerReportBean.setDblSettlementAmt(objManagerReportBean.getDblSettlementAmt() + settleAmt);

			    mapBillWiseSettlementWiseData.put("TotalSettlementAmt", objManagerReportBean);
			}
			else
			{
			    clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
			    objManagerReportBean.setStrSettlementCode("TotalSettlementAmt");
			    objManagerReportBean.setStrSettlementDesc("TotalSettlementAmt");
			    objManagerReportBean.setDblSettlementAmt(settleAmt);

			    mapBillWiseSettlementWiseData.put("TotalSettlementAmt", objManagerReportBean);
			}

			mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
		    }
		    else
		    {
			Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = new TreeMap<String, clsManagerReportBean>();
			//put settlement dtl

			clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
			objManagerReportBean.setStrSettlementCode(settlementCode);
			objManagerReportBean.setStrSettlementDesc(settlementDesc);
			objManagerReportBean.setDblSettlementAmt(settleAmt);
			objManagerReportBean.setDblRoundOffAmt(roundOffAmt);

			mapBillWiseSettlementWiseData.put(settlementCode, objManagerReportBean);

			//put total settlement dtl
			objManagerReportBean = new clsManagerReportBean();
			objManagerReportBean.setStrSettlementCode("TotalSettlementAmt");
			objManagerReportBean.setStrSettlementDesc("TotalSettlementAmt");
			objManagerReportBean.setDblSettlementAmt(settleAmt);

			mapBillWiseSettlementWiseData.put("TotalSettlementAmt", objManagerReportBean);

			mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
		   }
			}
			}
		/**
		 * live taxes
		 */
		StringBuilder sqlTax= new StringBuilder();
		sqlTax.append("SELECT a.strBillNo,ifnull(c.strTaxCode,'VAT'),ifnull(c.strTaxDesc,'VAT'),ifnull(SUM(b.dblTaxAmount),0) "
			+ " from tblbillhd a "
			+ " left outer join tblbilltaxdtl b on a.strBillNo=b.strBillNo AND DATE(a.dteBillDate)= DATE(b.dteBillDate) AND a.strClientCode=b.strClientCode "
			+ " left outer join tbltaxhd c on b.strTaxCode=c.strTaxCode "
			+ " where date(a.dteBillDate) between '" + fromDate + "' and '" + toDate + "' ");
		if (!posCode.equalsIgnoreCase("All"))
		{
			sqlTax.append( " and a.strPOSCode='" + posCode + "' ");
		}
		sqlTax.append( " group by a.strBillNo,c.strTaxCode");
		List listTaxDtl1 = objBaseService.funGetList(sqlTax, "sql");
		if(listTaxDtl1.size()>0)
		{
		   for(int i=0;i<listTaxDtl1.size();i++)
		   {
		    Object[] obj = (Object[]) listTaxDtl1.get(i);	
		    String strBillNo = obj[0].toString();
		    String taxCode = obj[1].toString();
		    String taxDesc = obj[2].toString();
		    double taxAmt = Double.parseDouble(obj[3].toString());

		    mapTaxNameWithLength.put(taxDesc, taxDesc.length());
		    if (taxDesc.length() > maxTaxNameLength)
		    {
			maxTaxNameLength = taxDesc.length();
		    }

		    totalTaxAmt = totalTaxAmt + taxAmt;

		    if (mapBillWiseTaxNames.containsKey(strBillNo))
		    {
			Map<String, String> mapTaxNames = mapBillWiseTaxNames.get(strBillNo);

			mapTaxNames.put(taxCode, taxDesc);
		    }
		    else
		    {
			Map<String, String> mapTaxNames = new TreeMap<>();

			mapTaxNames.put(taxCode, taxDesc);

			mapBillWiseTaxNames.put(strBillNo, mapTaxNames);
		    }

		    if (mapBillWiseData.containsKey(strBillNo))
		    {
			Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = mapBillWiseData.get(strBillNo);

			//put tax dtl
			if (mapBillWiseSettlementWiseData.containsKey(taxCode))
			{
			    clsManagerReportBean objManagerReportBean = mapBillWiseSettlementWiseData.get(taxCode);
			    objManagerReportBean.setDblSettlementAmt(objManagerReportBean.getDblTaxAmt() + taxAmt);

			    mapBillWiseSettlementWiseData.put(taxCode, objManagerReportBean);
			}
			else
			{
			    clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
			    objManagerReportBean.setStrTaxCode(taxCode);
			    objManagerReportBean.setStrTaxDesc(taxDesc);
			    objManagerReportBean.setDblTaxAmt(taxAmt);

			    mapBillWiseSettlementWiseData.put(taxCode, objManagerReportBean);
			}

			//put total tax dtl
			if (mapBillWiseSettlementWiseData.containsKey("TotalTaxAmt"))
			{
			    clsManagerReportBean objManagerReportBean = mapBillWiseSettlementWiseData.get("TotalTaxAmt");
			    objManagerReportBean.setDblTaxAmt(objManagerReportBean.getDblTaxAmt() + taxAmt);

			    mapBillWiseSettlementWiseData.put("TotalTaxAmt", objManagerReportBean);
			}
			else
			{
			    clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
			    objManagerReportBean.setStrTaxCode("TotalTaxAmt");
			    objManagerReportBean.setStrTaxDesc("TotalTaxAmt");
			    objManagerReportBean.setDblTaxAmt(taxAmt);
			     mapBillWiseSettlementWiseData.put("TotalTaxAmt", objManagerReportBean);
			}
			mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
		    }
		    else
		    {
			Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = new TreeMap<String, clsManagerReportBean>();

			clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
			objManagerReportBean.setStrTaxCode(taxCode);
			objManagerReportBean.setStrTaxDesc(taxDesc);
			objManagerReportBean.setDblTaxAmt(taxAmt);

			//put total tax dtl
			objManagerReportBean = new clsManagerReportBean();
			objManagerReportBean.setStrTaxCode("TotalTaxAmt");
			objManagerReportBean.setStrTaxDesc("TotalTaxAmt");
			objManagerReportBean.setDblTaxAmt(taxAmt);

			mapBillWiseSettlementWiseData.put("TotalTaxAmt", objManagerReportBean);

			mapBillWiseSettlementWiseData.put(taxCode, objManagerReportBean);

			mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
		  }
		}
	 }
		

		/**
		 * Q taxes
		 */
		sqlTax.setLength(0);
		sqlTax.append("SELECT a.strBillNo,ifnull(c.strTaxCode,'VAT'),ifnull(c.strTaxDesc,'VAT'),ifnull(SUM(b.dblTaxAmount),0) "
			+ " from tblqbillhd a "
			+ " left outer join tblqbilltaxdtl b on a.strBillNo=b.strBillNo AND DATE(a.dteBillDate)= DATE(b.dteBillDate) AND a.strClientCode=b.strClientCode "
			+ " left outer join tbltaxhd c on b.strTaxCode=c.strTaxCode "
			+ " where date(a.dteBillDate) between '" + fromDate + "' and '" + toDate + "' ");
		if (!posCode.equalsIgnoreCase("All"))
		{
			sqlTax.append(" and a.strPOSCode='" + posCode + "' ");
		}
		sqlTax.append( " group by a.strBillNo,c.strTaxCode");
		
		listTaxDtl1 = objBaseService.funGetList(sqlTax, "sql");
		if(listTaxDtl1.size()>0)
		{
		       for(int i=0;i<listTaxDtl1.size();i++)
				{
				Object[] obj = (Object[])listTaxDtl1.get(i);	
			    String strBillNo = obj[0].toString();
			    String taxCode = obj[1].toString();
			    String taxDesc = obj[2].toString();
			    double taxAmt = Double.parseDouble(obj[3].toString());

		    if (taxDesc.length() > maxTaxNameLength)
		    {
			maxTaxNameLength = taxDesc.length();
		    }

		    mapTaxNameWithLength.put(taxDesc, taxDesc.length());

		    totalTaxAmt = totalTaxAmt + taxAmt;

		    if (mapBillWiseTaxNames.containsKey(strBillNo))
		    {
			Map<String, String> mapTaxNames = mapBillWiseTaxNames.get(strBillNo);

			mapTaxNames.put(taxCode, taxDesc);
		    }
		    else
		    {
			Map<String, String> mapTaxNames = new TreeMap<>();

			mapTaxNames.put(taxCode, taxDesc);

			mapBillWiseTaxNames.put(strBillNo, mapTaxNames);
		    }

		    if (mapBillWiseData.containsKey(strBillNo))
		    {
			Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = mapBillWiseData.get(strBillNo);

			//put tax dtl
			if (mapBillWiseSettlementWiseData.containsKey(taxCode))
			{
			    clsManagerReportBean objManagerReportBean = mapBillWiseSettlementWiseData.get(taxCode);
			    objManagerReportBean.setDblSettlementAmt(objManagerReportBean.getDblTaxAmt() + taxAmt);
			    mapBillWiseSettlementWiseData.put(taxCode, objManagerReportBean);
			}
			else
			{
			    clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
			    objManagerReportBean.setStrTaxCode(taxCode);
			    objManagerReportBean.setStrTaxDesc(taxDesc);
			    objManagerReportBean.setDblTaxAmt(taxAmt);

			    mapBillWiseSettlementWiseData.put(taxCode, objManagerReportBean);
			}

			//put total tax dtl
			if (mapBillWiseSettlementWiseData.containsKey("TotalTaxAmt"))
			{
			    clsManagerReportBean objManagerReportBean = mapBillWiseSettlementWiseData.get("TotalTaxAmt");
			    objManagerReportBean.setDblTaxAmt(objManagerReportBean.getDblTaxAmt() + taxAmt);

			    mapBillWiseSettlementWiseData.put("TotalTaxAmt", objManagerReportBean);
			}
			else
			{
			    clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
			    objManagerReportBean.setStrTaxCode("TotalTaxAmt");
			    objManagerReportBean.setStrTaxDesc("TotalTaxAmt");
			    objManagerReportBean.setDblTaxAmt(taxAmt);

			    mapBillWiseSettlementWiseData.put("TotalTaxAmt", objManagerReportBean);
			}

			mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
		    }
		    else
		    {
			Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = new TreeMap<String, clsManagerReportBean>();

			clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
			objManagerReportBean.setStrTaxCode(taxCode);
			objManagerReportBean.setStrTaxDesc(taxDesc);
			objManagerReportBean.setDblTaxAmt(taxAmt);

			objManagerReportBean = new clsManagerReportBean();
			objManagerReportBean.setStrTaxCode("TotalTaxAmt");
			objManagerReportBean.setStrTaxDesc("TotalTaxAmt");
			objManagerReportBean.setDblTaxAmt(taxAmt);

			mapBillWiseSettlementWiseData.put("TotalTaxAmt", objManagerReportBean);

			mapBillWiseSettlementWiseData.put(taxCode, objManagerReportBean);

			mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
		    }
		}
		}
	        maxTaxNameLength = maxTaxNameLength + 1;



		

		//set discount,roundoff,tip
		sbSqlLiveFile.setLength(0);
		sbSqlLiveFile.append(" SELECT sum(a.dblDiscountAmt),sum(a.dblRoundOff),sum(a.dblTipAmount),a.strBillNo "
			+ " from tblbillhd a  "
			+ " where date(a.dteBillDate) between '" + fromDate + "' and '" + toDate + "' "
			+ "  ");
		if (!posCode.equalsIgnoreCase("All"))
		{
		    sbSqlLiveFile.append(" and a.strPOSCode='" + posCode + "' ");
		}
		sbSqlLiveFile.append(" group by a.strBillNo ");
		System.out.println(sbSqlLiveFile);

		listSettleManager = objBaseService.funGetList(sbSqlLiveFile, "sql");
		if(listSettleManager.size()>0)
		{
		     for(int i=0;i<listSettleManager.size();i++)
		     {
	                    Object[] obj =(Object[]) listSettleManager.get(i);	
			    double discAmt = Double.parseDouble(obj[0].toString());//discAmt
			    double roundOffAmt =Double.parseDouble(obj[1].toString());//roundOff
			    double tipAmt = Double.parseDouble(obj[2].toString());//tipAmt
			    totalDiscAmt = totalDiscAmt + discAmt;
			    totalRoundOffAmt = totalRoundOffAmt + roundOffAmt;//roundOff
			    totalTipAmt = totalTipAmt + tipAmt;//tipAmt
			    String strBillNo = obj[3].toString();//billDate

		    //discount
		    if (mapBillWiseData.containsKey(strBillNo))
		    {
			Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = mapBillWiseData.get(strBillNo);
			if (mapBillWiseSettlementWiseData.containsKey("DiscAmt"))
			{
			    clsManagerReportBean objDiscAmt = mapBillWiseSettlementWiseData.get("DiscAmt");
			    objDiscAmt.setDblDiscAmt(objDiscAmt.getDblDiscAmt() + discAmt);
			}
			else
			{
			    clsManagerReportBean objDiscAmt = new clsManagerReportBean();
			    objDiscAmt.setDblDiscAmt(discAmt);

			    mapBillWiseSettlementWiseData.put("DiscAmt", objDiscAmt);
			}

		    }
		    else
		    {
			Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = new TreeMap<String, clsManagerReportBean>();

			clsManagerReportBean objDiscAmt = new clsManagerReportBean();
			objDiscAmt.setDblDiscAmt(discAmt);

			mapBillWiseSettlementWiseData.put("DiscAmt", objDiscAmt);

			mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
		    }

		    //roundoff
		    if (mapBillWiseData.containsKey(strBillNo))
		    {
			Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = mapBillWiseData.get(strBillNo);
			if (mapBillWiseSettlementWiseData.containsKey("RoundOffAmt"))
			{
			    clsManagerReportBean objRoundOffAmt = mapBillWiseSettlementWiseData.get("RoundOffAmt");
			    objRoundOffAmt.setDblRoundOffAmt(objRoundOffAmt.getDblRoundOffAmt() + roundOffAmt);
			}
			else
			{
			    clsManagerReportBean objRoundOffAmt = new clsManagerReportBean();
			    objRoundOffAmt.setDblRoundOffAmt(roundOffAmt);

			    mapBillWiseSettlementWiseData.put("RoundOffAmt", objRoundOffAmt);
			}

		    }
		    else
		    {
			Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = new TreeMap<String, clsManagerReportBean>();

			clsManagerReportBean objRoundOffAmt = new clsManagerReportBean();
			objRoundOffAmt.setDblRoundOffAmt(roundOffAmt);

			mapBillWiseSettlementWiseData.put("RoundOffAmt", objRoundOffAmt);

			mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
		    }

		    //tip
		    if (mapBillWiseData.containsKey(strBillNo))
		    {
			Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = mapBillWiseData.get(strBillNo);
			if (mapBillWiseSettlementWiseData.containsKey("TipAmt"))
			{
			    clsManagerReportBean objTipAmt = mapBillWiseSettlementWiseData.get("TipAmt");
			    objTipAmt.setDblTipAmt(objTipAmt.getDblTipAmt() + tipAmt);
			}
			else
			{
			    clsManagerReportBean objTipAmt = new clsManagerReportBean();
			    objTipAmt.setDblTipAmt(tipAmt);

			    mapBillWiseSettlementWiseData.put("TipAmt", objTipAmt);
			}

		    }
		    else
		    {
			Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = new TreeMap<String, clsManagerReportBean>();

			clsManagerReportBean objTipAmt = new clsManagerReportBean();
			objTipAmt.setDblTipAmt(tipAmt);

			mapBillWiseSettlementWiseData.put("TipAmt", objTipAmt);

			mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
		    }
	          }
		}


		sbSqlQFile.setLength(0);
		sbSqlQFile.append(" SELECT sum(a.dblDiscountAmt),sum(a.dblRoundOff),sum(a.dblTipAmount),a.strBillNo "
			+ " from tblqbillhd a"
			+ " where date(a.dteBillDate) between '" + fromDate + "' and '" + toDate + "' "
			+ "  ");
		if (!posCode.equalsIgnoreCase("All"))
		{
		    sbSqlQFile.append(" and a.strPOSCode='" + posCode + "' ");
		}
		sbSqlQFile.append(" group by a.strBillNo ");
		System.out.println(sbSqlQFile);

		listSettleManager = objBaseService.funGetList(sbSqlQFile, "sql");
		if(listSettleManager.size()>0)
		{
			for(int i=0;i<listSettleManager.size();i++)
			{
			Object[] obj = (Object[]) listSettleManager.get(i);	
		    double discAmt = Double.parseDouble(obj[0].toString());//discAmt
		    double roundOffAmt =  Double.parseDouble(obj[1].toString());//roundOff
		    double tipAmt =  Double.parseDouble(obj[2].toString());//tipAmt
		    // int noOfBills = rsSettleManager.getInt(4);//bill count
		    totalDiscAmt = totalDiscAmt + discAmt;
		    totalRoundOffAmt = totalRoundOffAmt + roundOffAmt;//roundOff
		    totalTipAmt = totalTipAmt + tipAmt;//tipAmt
		    //  totalBills = totalBills + noOfBills;//bill count
		    String strBillNo = obj[3].toString();//billDate

		    //discount
		    if (mapBillWiseData.containsKey(strBillNo))
		    {
			Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = mapBillWiseData.get(strBillNo);
			if (mapBillWiseSettlementWiseData.containsKey("DiscAmt"))
			{
			    clsManagerReportBean objDiscAmt = mapBillWiseSettlementWiseData.get("DiscAmt");
			    objDiscAmt.setDblDiscAmt(objDiscAmt.getDblDiscAmt() + discAmt);
			}
			else
			{
			    clsManagerReportBean objDiscAmt = new clsManagerReportBean();
			    objDiscAmt.setDblDiscAmt(discAmt);

			    mapBillWiseSettlementWiseData.put("DiscAmt", objDiscAmt);
			}

		    }
		    else
		    {
			Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = new TreeMap<String, clsManagerReportBean>();

			clsManagerReportBean objDiscAmt = new clsManagerReportBean();
			objDiscAmt.setDblDiscAmt(discAmt);

			mapBillWiseSettlementWiseData.put("DiscAmt", objDiscAmt);

			mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
		    }

		    //roundoff
		    if (mapBillWiseData.containsKey(strBillNo))
		    {
			Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = mapBillWiseData.get(strBillNo);
			if (mapBillWiseSettlementWiseData.containsKey("RoundOffAmt"))
			{
			    clsManagerReportBean objRoundOffAmt = mapBillWiseSettlementWiseData.get("RoundOffAmt");
			    objRoundOffAmt.setDblRoundOffAmt(objRoundOffAmt.getDblRoundOffAmt() + roundOffAmt);
			}
			else
			{
			    clsManagerReportBean objRoundOffAmt = new clsManagerReportBean();
			    objRoundOffAmt.setDblRoundOffAmt(roundOffAmt);

			    mapBillWiseSettlementWiseData.put("RoundOffAmt", objRoundOffAmt);
			}

		    }
		    else
		    {
			Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = new TreeMap<String, clsManagerReportBean>();

			clsManagerReportBean objRoundOffAmt = new clsManagerReportBean();
			objRoundOffAmt.setDblRoundOffAmt(roundOffAmt);

			mapBillWiseSettlementWiseData.put("RoundOffAmt", objRoundOffAmt);

			mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
		    }

		    //tip
		    if (mapBillWiseData.containsKey(strBillNo))
		    {
			Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = mapBillWiseData.get(strBillNo);
			if (mapBillWiseSettlementWiseData.containsKey("TipAmt"))
			{
			    clsManagerReportBean objTipAmt = mapBillWiseSettlementWiseData.get("TipAmt");
			    objTipAmt.setDblTipAmt(objTipAmt.getDblTipAmt() + tipAmt);
			}
			else
			{
			    clsManagerReportBean objTipAmt = new clsManagerReportBean();
			    objTipAmt.setDblTipAmt(tipAmt);

			    mapBillWiseSettlementWiseData.put("TipAmt", objTipAmt);
			}

		    }
		    else
		    {
			Map<String, clsManagerReportBean> mapDateWiseSettlementWiseData = new TreeMap<String, clsManagerReportBean>();

			clsManagerReportBean objTipAmt = new clsManagerReportBean();
			objTipAmt.setDblTipAmt(tipAmt);

			mapDateWiseSettlementWiseData.put("TipAmt", objTipAmt);

			mapBillWiseData.put(strBillNo, mapDateWiseSettlementWiseData);
		    }
	          }
		}
		

		/**
		 * fill live date wise group wise data
		 */
		StringBuilder sqlGroupData = new StringBuilder();

		sqlGroupData.setLength(0);
		sqlGroupData.append("select  a.strBillNo,e.strGroupCode,e.strGroupName,sum(b.dblAmount)SubTotal,sum(b.dblDiscountAmt)Discount,sum(b.dblAmount)-sum(b.dblDiscountAmt)NetTotal "
			+ "from tblbillhd a,tblbilldtl b,tblitemmaster c,tblsubgrouphd d,tblgrouphd e "
			+ "where a.strBillNo=b.strBillNo "
			+ "AND DATE(a.dteBillDate)= DATE(b.dteBillDate) "
			+ "and b.strItemCode=c.strItemCode "
			+ "and c.strSubGroupCode=d.strSubGroupCode "
			+ "and d.strGroupCode=e.strGroupCode "
			+ "and date(a.dteBillDate) between '" + fromDate + "' and '" + toDate + "' ");
		if (!posCode.equalsIgnoreCase("All"))
		{
		    sqlGroupData.append(" and a.strPOSCode='" + posCode + "' ");
		}
		sqlGroupData.append("group by  a.strBillNo,e.strGroupCode ");
		List lisrGroupsData = objBaseService.funGetList(sqlGroupData, "sql");
			if(lisrGroupsData.size()>0)
			{
				for(int i=0;i<lisrGroupsData.size();i++)
				{
				Object[] obj = (Object[])lisrGroupsData.get(i);	
			    String strBillNo = obj[0].toString();//date
			    String groupCode = obj[1].toString();//groupCode
			    String groupName = obj[2].toString();//groupName
			    double subTotal = Double.parseDouble(obj[3].toString()); //subTotal
			    double discount = Double.parseDouble(obj[4].toString()); //discount
			    double netTotal = Double.parseDouble(obj[5].toString()); //netTotal


		    if (groupName.length() > maxGroupNameLength)
		    {
			maxGroupNameLength = groupName.length();
		    }
		    mapGroupNameWithLength.put(groupName, groupName.length());

		    if (mapBillWiseGroupNames.containsKey(strBillNo))
		    {
			Map<String, String> mapGroupNames = mapBillWiseGroupNames.get(strBillNo);

			mapGroupNames.put(groupCode, groupName);
		    }
		    else
		    {
			Map<String, String> mapGroupNames = new TreeMap<>();

			mapGroupNames.put(groupCode, groupName);

			mapBillWiseGroupNames.put(strBillNo, mapGroupNames);
		    }

		    if (mapBillWiseData.containsKey(strBillNo))
		    {
			Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = mapBillWiseData.get(strBillNo);

			if (mapBillWiseSettlementWiseData.containsKey(groupCode))
			{
			    clsManagerReportBean objGroupDtl = mapBillWiseSettlementWiseData.get(groupCode);

			    objGroupDtl.setDblSubTotal(objGroupDtl.getDblSubTotal() + subTotal);
			    objGroupDtl.setDblDisAmt(objGroupDtl.getDblDisAmt() + discount);
			    objGroupDtl.setDblNetTotal(objGroupDtl.getDblNetTotal() + netTotal);
			}
			else
			{
			    clsManagerReportBean objGroupDtl = new clsManagerReportBean();
			    objGroupDtl.setStrGroupCode(groupCode);
			    objGroupDtl.setStrGroupName(groupName);
			    objGroupDtl.setDblSubTotal(subTotal);
			    objGroupDtl.setDblDisAmt(discount);
			    objGroupDtl.setDblNetTotal(netTotal);

			    mapBillWiseSettlementWiseData.put(groupCode, objGroupDtl);
			}

			//put total settlement dtl
			if (mapBillWiseSettlementWiseData.containsKey("TotalGroupAmt"))
			{
			    clsManagerReportBean objManagerReportBean = mapBillWiseSettlementWiseData.get("TotalGroupAmt");
			    objManagerReportBean.setDblSubTotal(objManagerReportBean.getDblSubTotal() + subTotal);
			    objManagerReportBean.setDblNetTotal(objManagerReportBean.getDblNetTotal() + netTotal);

			    mapBillWiseSettlementWiseData.put("TotalGroupAmt", objManagerReportBean);
			}
			else
			{
			    clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
			    objManagerReportBean.setStrGroupCode("TotalGroupAmt");
			    objManagerReportBean.setStrGroupName("TotalGroupAmt");
			    objManagerReportBean.setDblSubTotal(subTotal);
			    objManagerReportBean.setDblNetTotal(netTotal);

			    mapBillWiseSettlementWiseData.put("TotalGroupAmt", objManagerReportBean);
			}
		    }
		    else
		    {
			Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = new TreeMap<String, clsManagerReportBean>();

			clsManagerReportBean objGroupDtl = new clsManagerReportBean();
			objGroupDtl.setStrGroupCode(groupCode);
			objGroupDtl.setStrGroupName(groupName);
			objGroupDtl.setDblSubTotal(subTotal);
			objGroupDtl.setDblDisAmt(discount);
			objGroupDtl.setDblNetTotal(netTotal);

			//put total settlement dtl
			clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
			objManagerReportBean.setStrGroupCode("TotalGroupAmt");
			objManagerReportBean.setStrGroupName("TotalGroupAmt");
			objManagerReportBean.setDblSubTotal(subTotal);
			objManagerReportBean.setDblNetTotal(netTotal);

			mapBillWiseSettlementWiseData.put("TotalGroupAmt", objManagerReportBean);

			mapBillWiseSettlementWiseData.put(groupCode, objGroupDtl);

			mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
		    }
		}
	}

		/**
		 * fill live modifiers date wise group wise data
		 */
		sqlGroupData.setLength(0);
		sqlGroupData.append("select a.strBillNo,e.strGroupCode,e.strGroupName,sum(b.dblAmount)SubTotal,sum(b.dblDiscAmt)Discount,sum(b.dblAmount)-sum(b.dblDiscAmt)NetTotal "
			+ "from tblbillhd a,tblbillmodifierdtl b,tblitemmaster c,tblsubgrouphd d,tblgrouphd e "
			+ "where a.strBillNo=b.strBillNo "
			+ "AND DATE(a.dteBillDate)= DATE(b.dteBillDate) "
			+ "and left(b.strItemCode,7)=c.strItemCode "
			+ "and c.strSubGroupCode=d.strSubGroupCode "
			+ "and d.strGroupCode=e.strGroupCode "
			+ "and date(a.dteBillDate) between '" + fromDate + "' and '" + toDate + "' ");
		if (!posCode.equalsIgnoreCase("All"))
		{
		    sqlGroupData.append(" and a.strPOSCode='" + posCode + "' ");
		}
		sqlGroupData.append("group by a.strBillNo,e.strGroupCode ");
		List listGroupsData = objBaseService.funGetList(sqlGroupData, "sql");
			if(listGroupsData.size()>0)
			{
				for(int i=0;i<listGroupsData.size();i++)
				{
				Object[] obj = (Object[])listGroupsData.get(i);	
			    String strBillNo = obj[0].toString();//date
			    String groupCode = obj[1].toString();//groupCode
			    String groupName = obj[2].toString();//groupName
			    double subTotal = Double.parseDouble(obj[3].toString()); //subTotal
			    double discount = Double.parseDouble(obj[4].toString()); //discount
			    double netTotal = Double.parseDouble(obj[5].toString()); //netTotal


		    if (groupName.length() > maxGroupNameLength)
		    {
			maxGroupNameLength = groupName.length();
		    }
		    mapGroupNameWithLength.put(groupName, groupName.length());

		    if (mapBillWiseGroupNames.containsKey(strBillNo))
		    {
			Map<String, String> mapGroupNames = mapBillWiseGroupNames.get(strBillNo);

			mapGroupNames.put(groupCode, groupName);
		    }
		    else
		    {
			Map<String, String> mapGroupNames = new TreeMap<>();

			mapGroupNames.put(groupCode, groupName);

			mapBillWiseGroupNames.put(strBillNo, mapGroupNames);
		    }

		    if (mapBillWiseData.containsKey(strBillNo))
		    {
			Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = mapBillWiseData.get(strBillNo);

			if (mapBillWiseSettlementWiseData.containsKey(groupCode))
			{
			    clsManagerReportBean objGroupDtl = mapBillWiseSettlementWiseData.get(groupCode);

			    objGroupDtl.setDblSubTotal(objGroupDtl.getDblSubTotal() + subTotal);
			    objGroupDtl.setDblDisAmt(objGroupDtl.getDblDisAmt() + discount);
			    objGroupDtl.setDblNetTotal(objGroupDtl.getDblNetTotal() + netTotal);
			}
			else
			{
			    clsManagerReportBean objGroupDtl = new clsManagerReportBean();
			    objGroupDtl.setStrGroupCode(groupCode);
			    objGroupDtl.setStrGroupName(groupName);
			    objGroupDtl.setDblSubTotal(subTotal);
			    objGroupDtl.setDblDisAmt(discount);
			    objGroupDtl.setDblNetTotal(netTotal);

			    mapBillWiseSettlementWiseData.put(groupCode, objGroupDtl);
			}

			//put total settlement dtl
			if (mapBillWiseSettlementWiseData.containsKey("TotalGroupAmt"))
			{
			    clsManagerReportBean objManagerReportBean = mapBillWiseSettlementWiseData.get("TotalGroupAmt");
			    objManagerReportBean.setDblSubTotal(objManagerReportBean.getDblSubTotal() + subTotal);
			    objManagerReportBean.setDblNetTotal(objManagerReportBean.getDblNetTotal() + netTotal);

			    mapBillWiseSettlementWiseData.put("TotalGroupAmt", objManagerReportBean);
			}
			else
			{
			    clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
			    objManagerReportBean.setStrGroupCode("TotalGroupAmt");
			    objManagerReportBean.setStrGroupName("TotalGroupAmt");
			    objManagerReportBean.setDblSubTotal(subTotal);
			    objManagerReportBean.setDblNetTotal(netTotal);

			    mapBillWiseSettlementWiseData.put("TotalGroupAmt", objManagerReportBean);
			}
		    }
		    else
		    {
			Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = new TreeMap<String, clsManagerReportBean>();

			clsManagerReportBean objGroupDtl = new clsManagerReportBean();
			objGroupDtl.setStrGroupCode(groupCode);
			objGroupDtl.setStrGroupName(groupName);
			objGroupDtl.setDblSubTotal(subTotal);
			objGroupDtl.setDblDisAmt(discount);
			objGroupDtl.setDblNetTotal(netTotal);

			//put total settlement dtl
			clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
			objManagerReportBean.setStrGroupCode("TotalGroupAmt");
			objManagerReportBean.setStrGroupName("TotalGroupAmt");
			objManagerReportBean.setDblSubTotal(subTotal);
			objManagerReportBean.setDblNetTotal(netTotal);

			mapBillWiseSettlementWiseData.put("TotalGroupAmt", objManagerReportBean);

			mapBillWiseSettlementWiseData.put(groupCode, objGroupDtl);

			mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
		    }
		}
	}

		/**
		 * fill Q date wise group wise data
		 */
		sqlGroupData.setLength(0);
		sqlGroupData.append("select a.strBillNo,e.strGroupCode,e.strGroupName,sum(b.dblAmount)SubTotal,sum(b.dblDiscountAmt)Discount,sum(b.dblAmount)-sum(b.dblDiscountAmt)NetTotal "
			+ "from tblqbillhd a,tblqbilldtl b,tblitemmaster c,tblsubgrouphd d,tblgrouphd e "
			+ "where a.strBillNo=b.strBillNo "
			+ "AND DATE(a.dteBillDate)= DATE(b.dteBillDate) "
			+ "and b.strItemCode=c.strItemCode "
			+ "and c.strSubGroupCode=d.strSubGroupCode "
			+ "and d.strGroupCode=e.strGroupCode "
			+ "and date(a.dteBillDate) between '" + fromDate + "' and '" + toDate + "' ");
		if (!posCode.equalsIgnoreCase("All"))
		{
		    sqlGroupData.append(" and a.strPOSCode='" + posCode + "' ");
		}
		sqlGroupData.append("group by a.strBillNo,e.strGroupCode ");
		listGroupsData = objBaseService.funGetList(sqlGroupData, "sql");
			if(listGroupsData.size()>0)
			{
				for(int i=0;i<listGroupsData.size();i++)
				{
				Object[] obj = (Object[]) listGroupsData.get(i);	
				String strBillNo = obj[0].toString();//date
			    String groupCode = obj[1].toString();//groupCode
			    String groupName = obj[2].toString();//groupName
			    double subTotal = Double.parseDouble(obj[3].toString()); //subTotal
			    double discount = Double.parseDouble(obj[4].toString()); //discount
			    double netTotal = Double.parseDouble(obj[5].toString()); //netTotal


		    if (groupName.length() > maxGroupNameLength)
		    {
			maxGroupNameLength = groupName.length();
		    }
		    mapGroupNameWithLength.put(groupName, groupName.length());

		    if (mapBillWiseGroupNames.containsKey(strBillNo))
		    {
			Map<String, String> mapGroupNames = mapBillWiseGroupNames.get(strBillNo);

			mapGroupNames.put(groupCode, groupName);
		    }
		    else
		    {
			Map<String, String> mapGroupNames = new TreeMap<>();

			mapGroupNames.put(groupCode, groupName);

			mapBillWiseGroupNames.put(strBillNo, mapGroupNames);
		    }

		    if (mapBillWiseData.containsKey(strBillNo))
		    {
			Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = mapBillWiseData.get(strBillNo);

			if (mapBillWiseSettlementWiseData.containsKey(groupCode))
			{
			    clsManagerReportBean objGroupDtl = mapBillWiseSettlementWiseData.get(groupCode);

			    objGroupDtl.setDblSubTotal(objGroupDtl.getDblSubTotal() + subTotal);
			    objGroupDtl.setDblDisAmt(objGroupDtl.getDblDisAmt() + discount);
			    objGroupDtl.setDblNetTotal(objGroupDtl.getDblNetTotal() + netTotal);
			}
			else
			{
			    clsManagerReportBean objGroupDtl = new clsManagerReportBean();
			    objGroupDtl.setStrGroupCode(groupCode);
			    objGroupDtl.setStrGroupName(groupName);
			    objGroupDtl.setDblSubTotal(subTotal);
			    objGroupDtl.setDblDisAmt(discount);
			    objGroupDtl.setDblNetTotal(netTotal);

			    mapBillWiseSettlementWiseData.put(groupCode, objGroupDtl);
			}

			//put total settlement dtl
			if (mapBillWiseSettlementWiseData.containsKey("TotalGroupAmt"))
			{
			    clsManagerReportBean objManagerReportBean = mapBillWiseSettlementWiseData.get("TotalGroupAmt");
			    objManagerReportBean.setDblSubTotal(objManagerReportBean.getDblSubTotal() + subTotal);
			    objManagerReportBean.setDblNetTotal(objManagerReportBean.getDblNetTotal() + netTotal);

			    mapBillWiseSettlementWiseData.put("TotalGroupAmt", objManagerReportBean);
			}
			else
			{
			    clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
			    objManagerReportBean.setStrGroupCode("TotalGroupAmt");
			    objManagerReportBean.setStrGroupName("TotalGroupAmt");
			    objManagerReportBean.setDblSubTotal(subTotal);
			    objManagerReportBean.setDblNetTotal(netTotal);

			    mapBillWiseSettlementWiseData.put("TotalGroupAmt", objManagerReportBean);
			}
		    }
		    else
		    {
			Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = new TreeMap<String, clsManagerReportBean>();

			clsManagerReportBean objGroupDtl = new clsManagerReportBean();
			objGroupDtl.setStrGroupCode(groupCode);
			objGroupDtl.setStrGroupName(groupName);
			objGroupDtl.setDblSubTotal(subTotal);
			objGroupDtl.setDblDisAmt(discount);
			objGroupDtl.setDblNetTotal(netTotal);

			//put total settlement dtl
			clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
			objManagerReportBean.setStrGroupCode("TotalGroupAmt");
			objManagerReportBean.setStrGroupName("TotalGroupAmt");
			objManagerReportBean.setDblSubTotal(subTotal);
			objManagerReportBean.setDblNetTotal(netTotal);

			mapBillWiseSettlementWiseData.put("TotalGroupAmt", objManagerReportBean);

			mapBillWiseSettlementWiseData.put(groupCode, objGroupDtl);

			mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
		    }
		}
	}

		/**
		 * fill Q modifiers date wise group wise data
		 */
		sqlGroupData.setLength(0);
		sqlGroupData.append("select a.strBillNo,e.strGroupCode,e.strGroupName,sum(b.dblAmount)SubTotal,sum(b.dblDiscAmt)Discount,sum(b.dblAmount)-sum(b.dblDiscAmt)NetTotal "
			+ "from tblqbillhd a,tblqbillmodifierdtl b,tblitemmaster c,tblsubgrouphd d,tblgrouphd e "
			+ "where a.strBillNo=b.strBillNo "
			+ "AND DATE(a.dteBillDate)= DATE(b.dteBillDate) "
			+ "and left(b.strItemCode,7)=c.strItemCode "
			+ "and c.strSubGroupCode=d.strSubGroupCode "
			+ "and d.strGroupCode=e.strGroupCode "
			+ "and date(a.dteBillDate) between '" + fromDate + "' and '" + toDate + "' ");
		if (!posCode.equalsIgnoreCase("All"))
		{
		    sqlGroupData.append(" and a.strPOSCode='" + posCode + "' ");
		}
		sqlGroupData.append("group by a.strBillNo,e.strGroupCode ");
		listGroupsData = objBaseService.funGetList(sqlGroupData, "sql");
			if(listGroupsData.size()>0)
			{
				for(int i=0;i<listGroupsData.size();i++)
				{
				Object[] obj = (Object[])listGroupsData.get(i);	
			    String strBillNo = obj[0].toString();//date
			    String groupCode = obj[1].toString();//groupCode
			    String groupName = obj[2].toString();//groupName
			    double subTotal = Double.parseDouble(obj[3].toString()); //subTotal
			    double discount = Double.parseDouble(obj[4].toString()); //discount
			    double netTotal = Double.parseDouble(obj[5].toString()); //netTotal

		    if (groupName.length() > maxGroupNameLength)
		    {
			maxGroupNameLength = groupName.length();
		    }
		    mapGroupNameWithLength.put(groupName, groupName.length());

		    if (mapBillWiseGroupNames.containsKey(strBillNo))
		    {
			Map<String, String> mapGroupNames = mapBillWiseGroupNames.get(strBillNo);

			mapGroupNames.put(groupCode, groupName);
		    }
		    else
		    {
			Map<String, String> mapGroupNames = new TreeMap<>();

			mapGroupNames.put(groupCode, groupName);

			mapBillWiseGroupNames.put(strBillNo, mapGroupNames);
		    }

		    if (mapBillWiseData.containsKey(strBillNo))
		    {
			Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = mapBillWiseData.get(strBillNo);

			if (mapBillWiseSettlementWiseData.containsKey(groupCode))
			{
			    clsManagerReportBean objGroupDtl = mapBillWiseSettlementWiseData.get(groupCode);

			    objGroupDtl.setDblSubTotal(objGroupDtl.getDblSubTotal() + subTotal);
			    objGroupDtl.setDblDisAmt(objGroupDtl.getDblDisAmt() + discount);
			    objGroupDtl.setDblNetTotal(objGroupDtl.getDblNetTotal() + netTotal);
			}
			else
			{
			    clsManagerReportBean objGroupDtl = new clsManagerReportBean();
			    objGroupDtl.setStrGroupCode(groupCode);
			    objGroupDtl.setStrGroupName(groupName);
			    objGroupDtl.setDblSubTotal(subTotal);
			    objGroupDtl.setDblDisAmt(discount);
			    objGroupDtl.setDblNetTotal(netTotal);

			    mapBillWiseSettlementWiseData.put(groupCode, objGroupDtl);
			}

			//put total settlement dtl
			if (mapBillWiseSettlementWiseData.containsKey("TotalGroupAmt"))
			{
			    clsManagerReportBean objManagerReportBean = mapBillWiseSettlementWiseData.get("TotalGroupAmt");
			    objManagerReportBean.setDblSubTotal(objManagerReportBean.getDblSubTotal() + subTotal);
			    objManagerReportBean.setDblNetTotal(objManagerReportBean.getDblNetTotal() + netTotal);

			    mapBillWiseSettlementWiseData.put("TotalGroupAmt", objManagerReportBean);
			}
			else
			{
			    clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
			    objManagerReportBean.setStrGroupCode("TotalGroupAmt");
			    objManagerReportBean.setStrGroupName("TotalGroupAmt");
			    objManagerReportBean.setDblSubTotal(subTotal);
			    objManagerReportBean.setDblNetTotal(netTotal);

			    mapBillWiseSettlementWiseData.put("TotalGroupAmt", objManagerReportBean);
			}
		    }
		    else
		    {
			Map<String, clsManagerReportBean> mapBillWiseSettlementWiseData = new TreeMap<String, clsManagerReportBean>();

			clsManagerReportBean objGroupDtl = new clsManagerReportBean();
			objGroupDtl.setStrGroupCode(groupCode);
			objGroupDtl.setStrGroupName(groupName);
			objGroupDtl.setDblSubTotal(subTotal);
			objGroupDtl.setDblDisAmt(discount);
			objGroupDtl.setDblNetTotal(netTotal);

			//put total settlement dtl
			clsManagerReportBean objManagerReportBean = new clsManagerReportBean();
			objManagerReportBean.setStrGroupCode("TotalGroupAmt");
			objManagerReportBean.setStrGroupName("TotalGroupAmt");
			objManagerReportBean.setDblSubTotal(subTotal);
			objManagerReportBean.setDblNetTotal(netTotal);

			mapBillWiseSettlementWiseData.put("TotalGroupAmt", objManagerReportBean);

			mapBillWiseSettlementWiseData.put(groupCode, objGroupDtl);

			mapBillWiseData.put(strBillNo, mapBillWiseSettlementWiseData);
		    }
		}
	}

		/**
		 * new logic for gross sales
		 */
		final String CASHCARDGUESTCREDIT = "CASH GUEST CREDIT CARD  Total";

		StringBuilder settlementStringBuilder = new StringBuilder();
		StringBuilder sqlSettlement = new StringBuilder();
		List listSettle=new ArrayList<>();
		sqlSettlement.append("select a.strSettelmentDesc "
			+ "from tblsettelmenthd a "
			+ "order by a.strSettelmentDesc");
		listSettle = objBaseService.funGetList(sqlSettlement, "sql");
		if(listSettle.size()>0)
		{
			for(int i=0;i<listSettle.size();i++)
			{
				Object obj = (Object)listSettle.get(i);	
				
				settlementStringBuilder.append(" " + obj.toString());
			}
		    
		}
		
		settlementStringBuilder.append(" Total");

		final String COMMONSORTING = settlementStringBuilder.toString();

		Comparator<String> settlementSorting = new Comparator<String>()
		{
		    @Override
		    public int compare(String o1, String o2)
		    {
				if (strClientCode.equals("240.001"))//TOAKS		    
				{
				    return CASHCARDGUESTCREDIT.indexOf(o1) - CASHCARDGUESTCREDIT.indexOf(o2);
				}
				else
				{
				    return COMMONSORTING.indexOf(o1) - COMMONSORTING.indexOf(o2);
				}

		    }
		};

		Map<String, Map<String, Double>> mapSettelemtWiseGroupBreakup = new TreeMap<>(settlementSorting);

		Map<String, Map<String, Double>> mapSettelemtWiseTaxBreakup = new TreeMap<>();
		/**
		 * new logic for gross sales
		 */
	        
		if (mapBillWiseData.size() > 0)
		{
		    for (Map.Entry<String, Map<String, clsManagerReportBean>> entrySet : mapBillWiseData.entrySet())
		    {
			String strBillNo = entrySet.getKey();
			Map<String, clsManagerReportBean> mapBillWiseGroupTaxSettlementData = entrySet.getValue();

			clsManagerReportBean objTotalSettlementAmt = mapBillWiseGroupTaxSettlementData.get("TotalSettlementAmt");
			double totalSettlementAmt = 0;
			if (objTotalSettlementAmt != null)
			{
			    totalSettlementAmt = objTotalSettlementAmt.getDblSettlementAmt();
			}
			clsManagerReportBean objTotalTaxAmt = mapBillWiseGroupTaxSettlementData.get("TotalTaxAmt");
			double totalTaxAmt1 = 0;
			if (objTotalTaxAmt != null)
			{
			   totalTaxAmt1 = objTotalTaxAmt.getDblTaxAmt();
			}

			clsManagerReportBean objTotalGroupAmt = mapBillWiseGroupTaxSettlementData.get("TotalGroupAmt");
			//double totalGroupSubTotal = objTotalGroupAmt.getDblSubTotal();
			double totalGroupNetTotal = 0;
			if (objTotalGroupAmt != null)
			{
			    totalGroupNetTotal = objTotalGroupAmt.getDblNetTotal();
			}

			String labelSettlement = "SETTLEMENT          |";

			String horizontalTotalLabel = "  TOTALS   |";

			//pw.println();
			//pw.print(strBillNo);
			Map<String, String> mapBillWiseTaxeNames = mapBillWiseTaxNames.get(strBillNo);

			Iterator<String> ketIterator = mapBillWiseTaxeNames.keySet().iterator();
			while (ketIterator.hasNext())
			{
			    String taxCode = ketIterator.next();
			    if (taxCode == null || taxCode.isEmpty())
			    {
				ketIterator.remove();
			    }
			}

			if (mapBillWiseTaxeNames != null)
			{
			    if (mapBillWiseGroupNames.containsKey(strBillNo))
			    {
				Map<String, String> mapGroupNames = mapBillWiseGroupNames.get(strBillNo);
				for (Map.Entry<String, String> entryGroupNames : mapGroupNames.entrySet())
				{

				    String groupCode = entryGroupNames.getKey();
				    String groupName = entryGroupNames.getValue();
				    if (groupName.length() > maxGroupNameLength)
				    {
					maxGroupNameLength = groupName.length();
				    }

				    clsManagerReportBean objGroupDtl = mapBillWiseGroupTaxSettlementData.get(groupCode);
				    //double groupSubTotal = objGroupDtl.getDblSubTotal();
				    double groupNetTotal = objGroupDtl.getDblNetTotal();

				    /**
				     * print a line
				     */
				    int lineCount = funGetLineCount(strBillNo, labelSettlement, groupName, horizontalTotalLabel, mapBillWiseData, mapBillWiseSettlementNames, mapBillWiseTaxNames);
				    //pw.println();
				    for (int i = 0; i < lineCount; i++)
				    {
					////pw.print("-");
				    }
				    if (lineCount > maxLineCount)
				    {
					maxLineCount = lineCount;
				    }

				    /**
				     * print header line
				     */
				    //pw.println();
				    //pw.print(objUtility.funPrintTextWithAlignment(labelSettlement, labelSettlement.length(), "Left"));
				    //pw.print(objUtility.funPrintTextWithAlignment(groupName + "|", groupName.length(), "Left"));
				    if (mapBillWiseTaxeNames != null)
				    {
					for (String taxDesc : mapBillWiseTaxeNames.values())
					{
					    String labelTaxDesc = taxDesc + "|";
					    //pw.print(objUtility.funPrintTextWithAlignment(labelTaxDesc, labelTaxDesc.length(), "Left"));
					}
				    }
				    //pw.print(objUtility.funPrintTextWithAlignment(horizontalTotalLabel, horizontalTotalLabel.length(), "Left"));

				    /**
				     * print settlement wise data
				     */
				    //pw.println();
				    Map<String, String> mapSettlementNames = mapBillWiseSettlementNames.get(strBillNo);

				    if (mapSettlementNames != null)
				    {
					for (Map.Entry<String, String> entrySettlements : mapSettlementNames.entrySet())
					{
					    String settlementCode = entrySettlements.getKey();
					    String settlementName = entrySettlements.getValue();

					    double horizontalTotalAmt = 0.00;

					    clsManagerReportBean objSettlementDtl = mapBillWiseGroupTaxSettlementData.get(settlementCode);

					    double groupSubTotalForThisSettlement = 0.00;
					    if (totalSettlementAmt > 0)
					    {
						groupSubTotalForThisSettlement = (groupNetTotal / totalSettlementAmt) * objSettlementDtl.getDblSettlementAmt();
						//groupSubTotalForThisSettlement = (groupNetTotal / totalSettlementAmt) * objSettlementDtl.getDblSettlementAmt();
					    }
					    horizontalTotalAmt += groupSubTotalForThisSettlement;

					    //new added for groups
					    if (mapSettelemtWiseGroupBreakup.containsKey(settlementName))
					    {
						Map<String, Double> mapGroupBreakup = mapSettelemtWiseGroupBreakup.get(settlementName);
						if (mapGroupBreakup.containsKey(groupName))
						{
						    mapGroupBreakup.put(groupName, mapGroupBreakup.get(groupName) + groupSubTotalForThisSettlement);

						    mapSettelemtWiseGroupBreakup.put(settlementName, mapGroupBreakup);
						}
						else
						{
						    mapGroupBreakup.put(groupName, groupSubTotalForThisSettlement);

						    mapSettelemtWiseGroupBreakup.put(settlementName, mapGroupBreakup);
						}
					    }
					    else
					    {
						Map<String, Double> mapGroupBreakup = new TreeMap<String, Double>();

						mapGroupBreakup.put(groupName, groupSubTotalForThisSettlement);

						mapSettelemtWiseGroupBreakup.put(settlementName, mapGroupBreakup);
					    }

					    //new added for groups total
					    String totalSettlement = "Total";
					    if (mapSettelemtWiseGroupBreakup.containsKey(totalSettlement))
					    {
						Map<String, Double> mapGroupBreakup = mapSettelemtWiseGroupBreakup.get(totalSettlement);
						if (mapGroupBreakup.containsKey(groupName))
						{
						    mapGroupBreakup.put(groupName, mapGroupBreakup.get(groupName) + groupSubTotalForThisSettlement);

						    mapSettelemtWiseGroupBreakup.put(totalSettlement, mapGroupBreakup);
						}
						else
						{
						    mapGroupBreakup.put(groupName, groupSubTotalForThisSettlement);

						    mapSettelemtWiseGroupBreakup.put(totalSettlement, mapGroupBreakup);
						}
					    }
					    else
					    {
						Map<String, Double> mapGroupBreakup = new TreeMap<String, Double>();

						mapGroupBreakup.put(groupName, groupSubTotalForThisSettlement);

						mapSettelemtWiseGroupBreakup.put(totalSettlement, mapGroupBreakup);
					    }

					    //pw.println();
					    //pw.print(objUtility.funPrintTextWithAlignment(settlementName, labelSettlement.length(), "Left"));
					    //pw.print(objUtility.funPrintTextWithAlignment(String.valueOf(Math.rint(groupSubTotalForThisSettlement) + "|"), groupName.length(), "Right"));
					    if (mapBillWiseTaxeNames != null)
					    {
						for (Map.Entry<String, String> entryTaxNames : mapBillWiseTaxeNames.entrySet())
						{
						    if(entryTaxNames.getKey().equals("VAT")){
							continue;
						    }
						    String taxCode = entryTaxNames.getKey();
						    String taxName = entryTaxNames.getValue();

						    String labelTaxDesc = taxName + "|";

						    clsManagerReportBean objTaxDtl = mapBillWiseGroupTaxSettlementData.get(taxCode);
						    double taxAmt = objTaxDtl.getDblTaxAmt();

						    double taxWiseGroupTotal = funGetTaxWiseGroupTotal(strBillNo, taxCode, mapBillWiseGroupTaxSettlementData);

						    double taxAmtForThisTax = 0.00;
						    boolean isApplicable = isApplicableTaxOnGroup(taxCode, groupCode);

						    if (taxWiseGroupTotal > 0 && isApplicable)
						    {
							taxAmtForThisTax = (taxAmt / taxWiseGroupTotal) * groupSubTotalForThisSettlement;
						    }
						    horizontalTotalAmt += taxAmtForThisTax;

						    //new added for taxes
						    String key = settlementName + "!" + groupName + "!" + taxName;
						    if (mapSettelemtWiseTaxBreakup.containsKey(settlementName))
						    {
							Map<String, Double> mapTaxBreakup = mapSettelemtWiseTaxBreakup.get(settlementName);
							if (mapTaxBreakup.containsKey(key))
							{
							    mapTaxBreakup.put(key, mapTaxBreakup.get(key) + taxAmtForThisTax);

							    mapSettelemtWiseTaxBreakup.put(settlementName, mapTaxBreakup);
							}
							else
							{
							    mapTaxBreakup.put(key, taxAmtForThisTax);

							    mapSettelemtWiseTaxBreakup.put(settlementName, mapTaxBreakup);
							}
						    }
						    else
						    {
							Map<String, Double> mapTaxBreakup = new TreeMap<String, Double>();

							mapTaxBreakup.put(key, taxAmtForThisTax);

							mapSettelemtWiseTaxBreakup.put(settlementName, mapTaxBreakup);
						    }

						    //new added for total taxes
						    String totalKey = totalSettlement + "!" + groupName + "!" + taxName;
						    if (mapSettelemtWiseTaxBreakup.containsKey(totalSettlement))
						    {
							Map<String, Double> mapTaxBreakup = mapSettelemtWiseTaxBreakup.get(totalSettlement);
							if (mapTaxBreakup.containsKey(totalKey))
							{
							    mapTaxBreakup.put(totalKey, mapTaxBreakup.get(totalKey) + taxAmtForThisTax);

							    mapSettelemtWiseTaxBreakup.put(totalSettlement, mapTaxBreakup);
							}
							else
							{
							    mapTaxBreakup.put(totalKey, taxAmtForThisTax);

							    mapSettelemtWiseTaxBreakup.put(totalSettlement, mapTaxBreakup);
							}
						    }
						    else
						    {
							Map<String, Double> mapTaxBreakup = new TreeMap<String, Double>();

							mapTaxBreakup.put(totalKey, taxAmtForThisTax);

							mapSettelemtWiseTaxBreakup.put(totalSettlement, mapTaxBreakup);
						    }

						    //pw.print(objUtility.funPrintTextWithAlignment(String.valueOf(Math.rint(taxAmtForThisTax)) + "|", labelTaxDesc.length(), "Right"));
						}
					    }
					    //pw.print(objUtility.funPrintTextWithAlignment(String.valueOf(Math.rint(horizontalTotalAmt)) + "|", horizontalTotalLabel.length(), "Right"));
					}
				    }
				    /**
				     * print total line
				     */
				    //pw.println();
				    for (int i = 0; i < lineCount; i++)
				    {
					//pw.print("-");
				    }
				    //pw.println();
				    //pw.print(objUtility.funPrintTextWithAlignment(groupName.toUpperCase() + " TOTALS", labelSettlement.length(), "Left"));
				    //pw.print(objUtility.funPrintTextWithAlignment(String.valueOf(Math.rint(groupNetTotal)) + "|", groupName.length(), "Right"));
				    if (mapBillWiseTaxeNames != null)
				    {
					for (Map.Entry<String, String> entryTaxNames : mapBillWiseTaxeNames.entrySet())
					{
					    String taxCode = entryTaxNames.getKey();
					    String taxName = entryTaxNames.getValue();

					    String labelTaxDesc = taxName + "|";
					    double taxAmt = 0.00;

					    boolean isApplicable = isApplicableTaxOnGroup(taxCode, groupCode);
					    if (isApplicable)
					    {
						double taxWiseGroupTotal = funGetTaxWiseGroupTotal(strBillNo, taxCode, mapBillWiseGroupTaxSettlementData);
						clsManagerReportBean objTaxDtl = mapBillWiseGroupTaxSettlementData.get(taxCode);
						double totalTaxAmtForGroup = objTaxDtl.getDblTaxAmt();

						if (taxWiseGroupTotal > 0)
						{
						    taxAmt = (totalTaxAmtForGroup / taxWiseGroupTotal) * groupNetTotal;
						}
					    }
					    //pw.print(objUtility.funPrintTextWithAlignment(String.valueOf(Math.rint(taxAmt)) + "|", labelTaxDesc.length(), "Right"));
					}
				    }
				    //pw.println();
				    for (int i = 0; i < lineCount; i++)
				    {
					//pw.print("-");
				    }
				    //pw.println();
				    //pw.println();

				}
			    }
			    else
			    {
				continue;
			    }
			}
			/**
			 * print total line
			 */
			//pw.println();
//	                for (int i = 0; i < maxLineCount; i++)
//	                {
//	                    ////pw.print("-");
//	                }
			////pw.println();
			////pw.print(objUtility.funPrintTextWithAlignment(strBillNo + " TOTALS", labelSettlement.length(), "Left"));
			//pw.print(objUtility.funPrintTextWithAlignment(String.valueOf(Math.rint(totalGroupNetTotal)) + "|", maxGroupNameLength, "Right"));
			double BillTotal = totalGroupNetTotal;
			if (mapBillWiseTaxeNames != null)
			{
			    for (Map.Entry<String, String> entryTaxNames : mapBillWiseTaxeNames.entrySet())
			    {
				String taxCode = entryTaxNames.getKey();
				String taxName = entryTaxNames.getValue();

				String labelTaxDesc = "  " + taxName + "|";

				clsManagerReportBean objTaxDtl = mapBillWiseGroupTaxSettlementData.get(taxCode);
				double totalTaxAmtForGroup = objTaxDtl.getDblTaxAmt();
				BillTotal += totalTaxAmtForGroup;
				//pw.print(objUtility.funPrintTextWithAlignment(String.valueOf(Math.rint(totalTaxAmtForGroup)) + "|", labelTaxDesc.length(), "Right"));
			    }
			}

			//pw.print(objUtility.funPrintTextWithAlignment(Math.rint(BillTotal) + "|", horizontalTotalLabel.length(), "Center"));
			//pw.println();
//	                for (int i = 0; i < maxLineCount; i++)
//	                {
//	                    //pw.print("-");
//	                }
			//pw.println();
			//pw.println();
		    }
		}

		DecimalFormat decimalFormat2Decimal = new DecimalFormat("0.00");
		List listSettlementData=new ArrayList<>();

		if ("Total After Tip Amount".length() > maxSettlementNameLength)
		{
		    maxSettlementNameLength = "Total After Tip Amount".length();
		}

		Iterator<String> keyIterator = mapTaxNameWithLength.keySet().iterator();
		while (keyIterator.hasNext())
		{
		    String taxCode = keyIterator.next();
		    if (taxCode == null || taxCode.isEmpty())
		    {
			   keyIterator.remove();
		    }
		}

		maxLineCount = maxSettlementNameLength + (maxGroupNameLength * 2) + (maxTaxNameLength * mapTaxNameWithLength.size()) + maxSettlementNameLength + 15;
		 if(strClientCode.equalsIgnoreCase("240.001"))
		 {
			    for (int i = 0; i < maxLineCount-20; i++)
			    {
				       pw.print("-");
			    }

		 }
		 else
		 {
			    for (int i = 0; i < maxLineCount; i++)
			    {
				       pw.print("-");
			    }
		 } 
		 String settlementLabelForPrinting = "Settlement              ";
		for (int i = settlementLabelForPrinting.length(); i < maxSettlementNameLength; i++)
		{
		    settlementLabelForPrinting += " ";
		}

		pw.println();
		pw.print(objUtility.funPrintTextWithAlignment(settlementLabelForPrinting + "|", maxSettlementNameLength, "left"));
		pw.print(objUtility.funPrintTextWithAlignment("Tax Category" + "|", maxGroupNameLength, "left"));
		pw.print(objUtility.funPrintTextWithAlignment("Sale Amt" + "|", maxSettlementNameLength, "right"));
		for (Map.Entry<String, Integer> taxEntry : mapTaxNameWithLength.entrySet())
		{
		    if(taxEntry.getKey().equals("VAT")){
			continue;
		    }
		    String taxName = taxEntry.getKey();
		    pw.print(objUtility.funPrintTextWithAlignment(taxName + "|", maxTaxNameLength, "right"));
		}
	        if(!strClientCode.equalsIgnoreCase("240.001"))
		{
		     pw.print(objUtility.funPrintTextWithAlignment("Total" + "|", maxSettlementNameLength, "right"));
	    
	    }
	
        double finalNetTotal = 0.00, finalSettlementTotal = 0.00;
    	Map<String, Double> mapFinalTaxTotal = new TreeMap<String, Double>();
    	mapFinalTaxTotal.put("Total", 0.00);		
    	
    	Map<String, clsBillItemDtlBean> mapSettlementModes = new HashMap<>();
    	double grossRevenue = 0;

    	sbSqlLiveFile.setLength(0);
    	sbSqlLiveFile.append("SELECT IFNULL(c.strPosCode,'All'),a.strSettelmentDesc, IFNULL(SUM(b.dblSettlementAmt),0.00), "
    			+ " IFNULL(d.strposname,'All'), IF(c.strPOSCode IS NULL,0, COUNT(*))"
    			+ " FROM tblsettelmenthd a"
    			+ " LEFT OUTER JOIN tblbillsettlementdtl b ON a.strSettelmentCode=b.strSettlementCode  and a.strClientCode=b.strClientCode AND DATE(b.dteBillDate)  BETWEEN '"+fromDate+"' AND '"+toDate+"'"
    			+ " LEFT OUTER JOIN tblbillhd c ON b.strBillNo=c.strBillNo AND DATE(b.dteBillDate)= DATE(c.dteBillDate) and a.strClientCode=c.strClientCode"
    			+ " LEFT OUTER JOIN tblposmaster d ON c.strPOSCode=d.strPosCode  and a.strClientCode=d.strClientCode" );

    	sbSqlQFile.setLength(0);
    	sbSqlQFile.append("SELECT IFNULL(c.strPosCode,'All'),a.strSettelmentDesc, IFNULL(SUM(b.dblSettlementAmt),0.00), "
    			+ " IFNULL(d.strposname,'All'), IF(c.strPOSCode IS NULL,0, COUNT(*))"
    			+ " FROM tblsettelmenthd a"
    			+ " LEFT OUTER JOIN tblqbillsettlementdtl b ON a.strSettelmentCode=b.strSettlementCode  and a.strClientCode=b.strClientCode AND DATE(b.dteBillDate)  BETWEEN '"+fromDate+"' AND '"+toDate+"'"
    			+ " LEFT OUTER JOIN tblqbillhd c ON b.strBillNo=c.strBillNo AND DATE(b.dteBillDate)= DATE(c.dteBillDate) and a.strClientCode=c.strClientCode"
    			+ " LEFT OUTER JOIN tblposmaster d ON c.strPOSCode=d.strPosCode  and a.strClientCode=d.strClientCode");

    	sqlFilter.append(" where a.strSettelmentType!='Complementary'  and b.dblSettlementAmt >0 and a.strClientCode='"+strClientCode+"' "
    		+ " and a.strApplicable='Yes' ");

    	if (!"All".equalsIgnoreCase(posCode))
    	{
    	    sqlFilter.append(" and  c.strPosCode='" + posCode + "' ");
    	}
    	sqlFilter.append("group by a.strSettelmentCode "
    		+ "order by b.dblSettlementAmt desc ");

    	sbSqlLiveFile.append(sqlFilter);
    	sbSqlQFile.append(sqlFilter);
		
    	//ResultSet rsData = clsGlobalVarClass.dbMysql.executeResultSet(sbSqlLive.toString());
    	listSettlementData = objBaseService.funGetList(sbSqlLiveFile, "sql");
		if(listSettlementData.size()>0)
		{
			for(int i=0;i<listSettlementData.size();i++)
			{
			      Object[] objSettlementData = (Object[])listSettlementData.get(i);	
			      
			      String settlementName = objSettlementData[1].toString(); // rsData.getString(2);
		    	  if (mapSettlementModes.containsKey(settlementName))
		    	  {
		    	    clsBillItemDtlBean obj = mapSettlementModes.get(settlementName);
		    		obj.setDblSettlementAmt(obj.getDblSettlementAmt() +  Double.parseDouble(objSettlementData[4].toString()));//rsData.getDouble(3));
		    		obj.setNoOfBills(obj.getNoOfBills() + Integer.parseInt(objSettlementData[4].toString())); //rsData.getInt(5));

		    	  }
		    	  else
		    	  {
		    		clsBillItemDtlBean obj = new clsBillItemDtlBean();
		    		obj.setStrPosCode(objSettlementData[0].toString());              //(rsData.getString(1));
		    		obj.setStrSettelmentMode(settlementName);
		    		obj.setDblSettlementAmt(Double.parseDouble(objSettlementData[2].toString()));        //(rsData.getDouble(3));
		    		obj.setStrPosName(objSettlementData[3].toString());       //(rsData.getString(4));
		    		obj.setNoOfBills(Integer.parseInt(objSettlementData[4].toString()));             //(rsData.getInt(5));

		    		mapSettlementModes.put(settlementName, obj);

		    	  }

		    	 grossRevenue +=Double.parseDouble(objSettlementData[2].toString());// rsData.getDouble(3);

			
			
			
			}
		}
		
		listSettlementData=new ArrayList<>();
		listSettlementData = objBaseService.funGetList(sbSqlQFile, "sql");
		if(listSettlementData.size()>0)
		{
			for(int i=0;i<listSettlementData.size();i++)
			{
			      Object[] objSettlementData = (Object[])listSettlementData.get(i);	
			      
			      String settlementName = objSettlementData[1].toString(); // rsData.getString(2);
		    	  if (mapSettlementModes.containsKey(settlementName))
		    	  {
		    	    clsBillItemDtlBean obj = mapSettlementModes.get(settlementName);
		    		obj.setDblSettlementAmt(obj.getDblSettlementAmt() +  Double.parseDouble(objSettlementData[4].toString()));//rsData.getDouble(3));
		    		obj.setNoOfBills(obj.getNoOfBills() + Integer.parseInt(objSettlementData[4].toString())); //rsData.getInt(5));

		    	  }
		    	  else
		    	  {
		    		clsBillItemDtlBean obj = new clsBillItemDtlBean();
		    		obj.setStrPosCode(objSettlementData[0].toString());              //(rsData.getString(1));
		    		obj.setStrSettelmentMode(settlementName);
		    		obj.setDblSettlementAmt(Double.parseDouble(objSettlementData[2].toString()));        //(rsData.getDouble(3));
		    		obj.setStrPosName(objSettlementData[3].toString());       //(rsData.getString(4));
		    		obj.setNoOfBills(Integer.parseInt(objSettlementData[4].toString()));             //(rsData.getInt(5));

		    		mapSettlementModes.put(settlementName, obj);

		    	  }

		    	 grossRevenue +=Double.parseDouble(objSettlementData[2].toString());// rsData.getDouble(3);

			
			
			
			}
		}
    	

    	
    	for (Map.Entry<String, Map<String, Double>> settlementEntry : mapSettelemtWiseGroupBreakup.entrySet())
    	{
    	    String settlementName = settlementEntry.getKey();

    	    double settlementWiseNetTotal = 0.00;
    	    Map<String, Double> mapSettlementWiseTaxTotal = new TreeMap<String, Double>();
    	    mapSettlementWiseTaxTotal.put("Total", 0.00);

    	    Map<String, Double> mapGroupBreakup = settlementEntry.getValue();

    	    String settlementNameForPrinting = settlementName;
    	    for (int i = settlementName.length(); i < maxSettlementNameLength; i++)
    	    {
    		settlementNameForPrinting += " ";
    	    }

    	    pw.println();
    	    pw.print(objUtility.funPrintTextWithAlignment(settlementNameForPrinting, maxSettlementNameLength, "left"));

    	    for (Map.Entry<String, Integer> groupEntry : mapGroupNameWithLength.entrySet())
    	    {
    		double total = 0;
    		String groupName = groupEntry.getKey();
    		int groupNameLength = groupEntry.getValue();

    		double groupNetTotal = 0.00;
    		if (mapGroupBreakup.containsKey(groupName))
    		{
    		    groupNetTotal = mapGroupBreakup.get(groupName);
    		}

    		total = total + groupNetTotal;
    		if (!settlementName.equalsIgnoreCase("Total"))
    		{
    		    settlementWiseNetTotal += groupNetTotal;
    		    finalNetTotal += groupNetTotal;
    		}

    		String emptySettlementNameForPrinting = "";
    		for (int i = emptySettlementNameForPrinting.length(); i < maxSettlementNameLength; i++)
    		{
    		    emptySettlementNameForPrinting += " ";
    		}

    		String groupNameForPrinting = groupName;
    		for (int i = groupName.length(); i < maxGroupNameLength; i++)
    		{
    		    groupNameForPrinting += " ";
    		}

    		pw.println();
    		pw.print(objUtility.funPrintTextWithAlignment(emptySettlementNameForPrinting + "|", maxSettlementNameLength, "right"));
    		pw.print(objUtility.funPrintTextWithAlignment(groupNameForPrinting + "|", maxGroupNameLength, "left"));
    		pw.print(objUtility.funPrintTextWithAlignment(decimalFormat2Decimal.format(groupNetTotal) + "|", maxSettlementNameLength, "right"));

    		if (mapSettelemtWiseTaxBreakup.containsKey(settlementName))
    		{
    		    Map<String, Double> mapTaxBreakup = mapSettelemtWiseTaxBreakup.get(settlementName);

    		    for (Map.Entry<String, Integer> taxEntry : mapTaxNameWithLength.entrySet())
    		    {
    			if(taxEntry.getKey().equals("VAT")){
    			    continue;
    			}
    			String taxName = taxEntry.getKey();
    			String key = settlementName + "!" + groupName + "!" + taxName;

    			double taxAmt = 0.00;
    			if (mapTaxBreakup.containsKey(key))
    			{
    			    taxAmt = mapTaxBreakup.get(key);
    			}

    			total = total + taxAmt;

    			if (mapSettlementWiseTaxTotal.containsKey(taxName))
    			{
    			    mapSettlementWiseTaxTotal.put(taxName, mapSettlementWiseTaxTotal.get(taxName) + taxAmt);
    			}
    			else
    			{
    			    mapSettlementWiseTaxTotal.put(taxName, taxAmt);
    			}

    			if (!settlementName.equalsIgnoreCase("Total"))
    			{
    			    if (mapFinalTaxTotal.containsKey(taxName))
    			    {
    				mapFinalTaxTotal.put(taxName, mapFinalTaxTotal.get(taxName) + taxAmt);
    			    }
    			    else
    			    {
    				mapFinalTaxTotal.put(taxName, taxAmt);
    			    }
    			}

    			pw.print(objUtility.funPrintTextWithAlignment(decimalFormat2Decimal.format(taxAmt) + "|", maxTaxNameLength, "right"));
    		    }

    		}
    		else
    		{
    		    continue;
    		}
                    if(!strClientCode.equalsIgnoreCase("240.001"))
    		{
    		    pw.print(objUtility.funPrintTextWithAlignment(decimalFormat2Decimal.format(total) + "|", maxSettlementNameLength, "right"));

    		}
    	    }
    	    //print settlement wise total

    	    if (!settlementName.equalsIgnoreCase("Total"))
    	    {
    		double finalSettlementWiseTotal = settlementWiseNetTotal;

    		String settlementTotalForPrinting = "Total " + settlementName;
    		for (int i = settlementTotalForPrinting.length(); i < maxSettlementNameLength; i++)
    		{
    		    settlementTotalForPrinting += " ";
    		}

    		String emptyGroupNameForPrinting = "";
    		for (int i = emptyGroupNameForPrinting.length(); i < maxGroupNameLength; i++)
    		{
    		    emptyGroupNameForPrinting += " ";
    		}

    		pw.println();
    		pw.print(objUtility.funPrintTextWithAlignment(settlementTotalForPrinting + "|", maxSettlementNameLength, "left"));
    		pw.print(objUtility.funPrintTextWithAlignment(emptyGroupNameForPrinting + "|", maxGroupNameLength, "left"));
    		pw.print(objUtility.funPrintTextWithAlignment(decimalFormat2Decimal.format(settlementWiseNetTotal) + "|", maxSettlementNameLength, "right"));
    		for (Map.Entry<String, Integer> taxEntry : mapTaxNameWithLength.entrySet())
    		{
    		    if(taxEntry.getKey().equals("VAT")){
    			continue;
    		    }
    		    String taxName = taxEntry.getKey();
    		    double settlementWiseTaxAmt = 0.00;
    		    if (mapSettlementWiseTaxTotal.containsKey(taxName))
    		    {
    			settlementWiseTaxAmt = mapSettlementWiseTaxTotal.get(taxName);
    		    }
    		    finalSettlementWiseTotal += settlementWiseTaxAmt;
    		    pw.print(objUtility.funPrintTextWithAlignment(decimalFormat2Decimal.format(settlementWiseTaxAmt) + "|", maxTaxNameLength, "right"));
    		}

    		double roundOffForThisSettlement = (totalRoundOffAmt / totalSettleAmt) * finalSettlementWiseTotal;
    		finalSettlementWiseTotal = finalSettlementWiseTotal + roundOffForThisSettlement;

    		double settlementAmount = mapSettlementModes.get(settlementName).getDblSettlementAmt();
                    if(!strClientCode.equalsIgnoreCase("240.001"))
    		{
    		   pw.print(objUtility.funPrintTextWithAlignment(decimalFormat2Decimal.format(settlementAmount) + "|", maxSettlementNameLength, "right"));
    		   pw.println(); 
    		}
    		

    	    }
    	}
    	//print grand total
    	
    	    double finalTotalSettlementAmounr = finalNetTotal;

    	String totalForPrinting = "Total";
    	for (int i = totalForPrinting.length(); i < maxSettlementNameLength; i++)
    	{
    	    totalForPrinting += " ";
    	}

    	String emptyGroupNameForPrinting = "";
    	for (int i = emptyGroupNameForPrinting.length(); i < maxGroupNameLength; i++)
    	{
    	    emptyGroupNameForPrinting += " ";
    	}

    	String emptyNetTotalForPrinting = "";
    	for (int i = emptyNetTotalForPrinting.length(); i < maxGroupNameLength; i++)
    	{
    	    emptyNetTotalForPrinting += " ";
    	}

    	String emptyTaxNameForPrinting = "";
    	for (int i = emptyTaxNameForPrinting.length(); i < maxTaxNameLength; i++)
    	{
    	    emptyTaxNameForPrinting += " ";
    	}

    	String roundOffForPrinting = "Round Off";
    	for (int i = "Round Off".length(); i < maxSettlementNameLength; i++)
    	{
    	    roundOffForPrinting += " ";
    	}

    	String tipForPrinting = "Tip Amount";
    	for (int i = "Tip Amount".length(); i < maxSettlementNameLength; i++)
    	{
    	    tipForPrinting += " ";
    	}

    	String totalAfterTipForPrinting = "Total After Tip Amount";
    	for (int i = totalAfterTipForPrinting.length(); i < maxSettlementNameLength; i++)
    	{
    	    totalAfterTipForPrinting += " ";
    	}

    	pw.println();
    	pw.print(objUtility.funPrintTextWithAlignment(totalForPrinting + "|", maxSettlementNameLength, "left"));
    	pw.print(objUtility.funPrintTextWithAlignment(emptyGroupNameForPrinting + "|", maxGroupNameLength, "right"));
    	pw.print(objUtility.funPrintTextWithAlignment(decimalFormat2Decimal.format(finalNetTotal) + "|", maxSettlementNameLength, "right"));
    	for (Map.Entry<String, Integer> taxEntry : mapTaxNameWithLength.entrySet())
    	{
    	    if(taxEntry.getKey().equals("VAT")){
    		continue;
    	    }
    	    String taxName = taxEntry.getKey();
    	    double settlementWiseTaxAmt = 0.00;
    	    if (mapFinalTaxTotal.containsKey(taxName))
    	    {
    		settlementWiseTaxAmt = mapFinalTaxTotal.get(taxName);
    	    }
    	    finalTotalSettlementAmounr += settlementWiseTaxAmt;
    	    pw.print(objUtility.funPrintTextWithAlignment(decimalFormat2Decimal.format(settlementWiseTaxAmt) + "|", maxTaxNameLength, "right"));
    	}
            if(!strClientCode.equalsIgnoreCase("240.001"))
    	{
    	    	pw.print(objUtility.funPrintTextWithAlignment(decimalFormat2Decimal.format(finalTotalSettlementAmounr + totalRoundOffAmt) + "|", maxSettlementNameLength, "right"));

    	}

    	pw.println();
    	pw.println();
    	pw.println();
    	pw.println();
    	pw.println();
    	pw.println();
    	pw.println("Note:-Round Off Amount is "+decimalFormat2Decimal.format(totalRoundOffAmt));
    	pw.println();
    	pw.println();
    	pw.println("End Of Gross Sales Summary");	
	    
		
		return 1;
	}
	
	private boolean isApplicableTaxOnGroup(String taxCode, String groupCode)
    {
		boolean isApplicable = false;
		try
		{
		    StringBuilder sqlBuilder = new StringBuilder("select a.strTaxCode,a.strGroupCode,a.strGroupName,a.strApplicable "
			    + "from tbltaxongroup a "
			    + "where a.strTaxCode='" + taxCode + "' "
			    + "and a.strGroupCode='" + groupCode + "' "
			    + "and a.strApplicable='true' ");
		    List listIsApplicable = objBaseService.funGetList(sqlBuilder, "sql");
		    if (listIsApplicable.size()>0)
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
	
	private double funGetTaxWiseGroupTotal(String billDate, String taxCode, Map<String, clsManagerReportBean> mapBillWiseGroupTaxSettlementData)
    {
		double taxWiseGroupTotal = 0.00;

		try
		{
		    StringBuilder sql = new StringBuilder("select distinct(b.strGroupCode),b.strGroupName,a.strTaxOnGD "
			    + "from tbltaxhd a,tbltaxongroup b "
			    + "where a.strTaxCode=b.strTaxCode "
			    + "and b.strTaxCode='" + taxCode + "' "
			    + "and b.strApplicable='true' ");
		    List listIsApplicable = objBaseService.funGetList(sql, "sql");
		    if(listIsApplicable.size()>0)
		    {
				for(int i=0;i<listIsApplicable.size();i++)
				{
					Object[] obj = (Object[])listIsApplicable.get(i);
		    		String groupCode = obj[0].toString();//groupCode
					String taxOnGD = obj[2].toString();//taxOnGD
		
					if (mapBillWiseGroupTaxSettlementData.containsKey(groupCode))
					{
					    clsManagerReportBean objGroupDtl = mapBillWiseGroupTaxSettlementData.get(groupCode);
					    if (taxOnGD.equalsIgnoreCase("Gross"))
					    {
					    	taxWiseGroupTotal += objGroupDtl.getDblSubTotal();
					    }
					    else
					    {
					    	taxWiseGroupTotal += objGroupDtl.getDblNetTotal();
					    }
					}
		    	}
		    }
		   
		}
		catch (Exception e)
		{
		    e.printStackTrace();
		}
		finally
		{
		    return taxWiseGroupTotal;
		}
    }
	
	private int funGetLineCount(String billNo, String labelSettlement, String labelGroupName, String horizontalTotalLabel, Map<String, Map<String, clsManagerReportBean>> mapBillWiseData, Map<String, Map<String, String>> mapBillWiseSettlemetNames, Map<String, Map<String, String>> mapBillWiseTaxNames)
    {

		StringBuilder stringBuilder = new StringBuilder();
		stringBuilder.append(labelSettlement);
		stringBuilder.append(labelGroupName);

		Map<String, String> map = mapBillWiseTaxNames.get(billNo);
		if (map != null)
		{
		    for (String taxDesc : map.values())
		    {
				String labelTaxDesc = taxDesc + "|";
				stringBuilder.append(labelTaxDesc);
		    }
		}
		stringBuilder.append(horizontalTotalLabel);
	
		return stringBuilder.length();
    }
}



