package com.sanguine.webpos.controller;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sanguine.base.service.intfBaseService;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.webpos.bean.clsPOSReportBean;
import com.sanguine.webpos.model.clsGroupMasterModel;
import com.sanguine.webpos.sevice.clsPOSMasterService;

@Controller
public class clsPOSStockInOutFlashController
{

	 @Autowired
	 private clsGlobalFunctions objGlobalFunctions;
		
	  @Autowired
	  private ServletContext servletContext;
		 
	  @Autowired
	  clsPOSMasterService objMasterService;
	  
	  @Autowired
	  private intfBaseService objBaseService;
		 
	  private Vector  vItemCode = new java.util.Vector();
		
	  Map map=new HashMap();
	  Map<String,String> hmPOSData;
	  
	  @RequestMapping(value = "/frmPOSStkInOutFlash", method = RequestMethod.GET)
		public ModelAndView funOpenForm(Map<String, Object> model,HttpServletRequest request)
		{
			String strClientCode=request.getSession().getAttribute("gClientCode").toString();	
			String urlHits="1";
			try{
				urlHits=request.getParameter("saddr").toString();
			}catch(NullPointerException e){
				urlHits="1";
			}
			model.put("urlHits",urlHits);
			List poslist = new ArrayList();
			poslist.add("ALL");
			
			hmPOSData=new HashMap<String, String>();
			List list=new ArrayList();
			try
			{
				list = objMasterService.funFullPOSCombo(strClientCode);
			}
			catch (Exception e)
			{
				e.printStackTrace();
			}
			hmPOSData.put("All", "All");
			
			for(int cnt=0;cnt<list.size();cnt++)
			{
				Object obj=list.get(cnt);
				poslist.add(Array.get(obj, 1).toString());
				hmPOSData.put(Array.get(obj, 0).toString(), Array.get(obj, 1).toString());
			}
			model.put("posList",poslist);
			
			List typeList = new ArrayList();
			/*Item wise
			Menuhead wise
			SubGroup wise
			Group wise*/
			typeList.add("Item wise");
			typeList.add("Menuhead wise");
			typeList.add("SubGroup wise");
			typeList.add("Group wise");
			model.put("typeList",typeList);
			
			List reportTypeList = new ArrayList();
			reportTypeList.add("Stock in");
			reportTypeList.add("Stock out");
			model.put("InOut",reportTypeList);
			
			Map groupMap = new HashMap<String,String>();
			groupMap.put("ALL","ALL");
		
			try
			{
				List <clsGroupMasterModel> GroupList = objMasterService.funLoadGrouptData(strClientCode);
			    for(int i =0; i<GroupList.size();i++)
			    {
			    	clsGroupMasterModel obj = (clsGroupMasterModel) GroupList.get(i);
			    	groupMap.put("strGroupName",obj.getStrGroupName());
			    }
			}
			catch(Exception e){e.printStackTrace();}
			model.put("groupMap",groupMap);
		
			List viewByList = new ArrayList();
			viewByList.add("All");
			model.put("reason",viewByList);
			
			List showZeroBalList = new ArrayList();
			showZeroBalList.add("Yes");
			showZeroBalList.add("No");
			model.put("showZeroBalList",showZeroBalList);
			
			
			if("2".equalsIgnoreCase(urlHits)){
				return new ModelAndView("frmPOSStkInOutFlash","command", new clsPOSReportBean());
			}else if("1".equalsIgnoreCase(urlHits)){
				return new ModelAndView("frmPOSStkInOutFlash","command", new clsPOSReportBean());
			}else {
				return null;
			}
		}
	  
	  @SuppressWarnings({ "rawtypes", "unchecked" })
		@RequestMapping(value={"/loadPOSStockInOutFlash"}, method=RequestMethod.GET)
	    @ResponseBody
	    public Map funLoadStockInOutFlashReport(HttpServletRequest req) throws Exception
	    {
		  LinkedHashMap resMap = new LinkedHashMap();
		     
	        
	        String clientCode=req.getSession().getAttribute("gClientCode").toString();
	        String PosCode=req.getSession().getAttribute("loginPOS").toString();
		    String strFromdate=req.getParameter("fromDate");
			String strToDate=req.getParameter("toDate");
			String posName=req.getParameter("posName");
			String type=req.getParameter("type");
			String reportType=req.getParameter("reportType");
			String groupwise=req.getParameter("groupwise");
			String showStockWith=req.getParameter("showStockWith");
			String showZeroBalStockYN=req.getParameter("showZeroBalStockYN");
			String time=req.getParameter("time");
			if(time.equals("first"))
	        {
				String strPosCode=req.getSession().getAttribute("loginPOS").toString();
				String posDate=req.getSession().getAttribute("gPOSDate").toString();
				String [] arrDate=posDate.split(" ");
				/*strFromdate=arrDate[0].split("-")[2]+"-"+arrDate[0].split("-")[1]+"-"+arrDate[0].split("-")[0];
				strToDate=arrDate[0].split("-")[2]+"-"+arrDate[0].split("-")[1]+"-"+arrDate[0].split("-")[0];*/		
	        }
			
			 if (reportType.equalsIgnoreCase("Stock In"))
		     {
				resMap=funGetStockInFlashData(clientCode,strFromdate,PosCode,strToDate,posName,type,reportType,groupwise,showStockWith,showZeroBalStockYN);
		     }
		     else
		     {
		        resMap=funGetStockOutFlashData(clientCode,strFromdate,strToDate,posName,type,reportType,groupwise,showStockWith,showZeroBalStockYN);
		     }
			return resMap;
	    }

	private LinkedHashMap funGetStockOutFlashData(String clientCode, String strFromdate, String strToDate, String posName, String type, String reportType, String groupwise, String showStockWith, String showZeroBalStockYN) throws Exception
	{
		LinkedHashMap resMap = new LinkedHashMap();
		  
		   double amtTotal=0, netTotal=0, paxTotal=0;
	     
	        List colHeader = new ArrayList();
	        String posCode="All";
	        String fromDate1=strFromdate.split("-")[2]+"-"+strFromdate.split("-")[1]+"-"+strFromdate.split("-")[0];
			String toDate1=strToDate.split("-")[2]+"-"+strToDate.split("-")[1]+"-"+strToDate.split("-")[0];
		
			
			Map jObj = funStockOutFlashReportDtl(strFromdate, strToDate,posCode,type,reportType,groupwise,showStockWith,showZeroBalStockYN);
			List list =new ArrayList();
			List totalList=new ArrayList();
			List jarr = (ArrayList) jObj.get("jArr");
			
			totalList.add("Total :");
			
			 if(null!=jarr)
			 {
				if(jarr.size()>0)
				{
					 for(int i=0;i<jarr.size();i++)
					 {
						Map jObjtemp =(Map) jarr.get(i);
						List arrList=new ArrayList();
						arrList.add(jObjtemp.get("ItemName").toString());
						arrList.add(jObjtemp.get("Qty").toString());
						arrList.add(jObjtemp.get("PurchaseRate").toString());
						arrList.add(jObjtemp.get("Amount").toString());
						arrList.add(jObjtemp.get("StockNo").toString());
						arrList.add(jObjtemp.get("StockInDate").toString());
						arrList.add(jObjtemp.get("PosName").toString());
						arrList.add(jObjtemp.get("Reason").toString());
						arrList.add(jObjtemp.get("BillNo").toString());
						arrList.add(jObjtemp.get("Tax").toString());	
						
						list.add(arrList);
					 }
					 
					   Map jObjTotal =(Map) jObj.get("total");
					   totalList.add(Double.parseDouble(jObjTotal.get("sumOpeningStock").toString()));
					   totalList.add(Double.parseDouble(jObjTotal.get("sumPurchaseRate").toString()));
					   totalList.add(Double.parseDouble(jObjTotal.get("sumAmount").toString()));
				 }
			
		      }
				List arrListHeader = null;
				arrListHeader=new ArrayList();
				arrListHeader.add("Item Name");
				arrListHeader.add("Qty");
				arrListHeader.add("Purchase Rate");
				arrListHeader.add("Amount");
				arrListHeader.add("Stock No");
				arrListHeader.add("Stock Date");
				arrListHeader.add("Pos Name");
				arrListHeader.add("Reason");
				arrListHeader.add("Bill No");
				arrListHeader.add("Tax");
		  		
				resMap.put("listHeader", arrListHeader);
				resMap.put("listDetails", list);
				resMap.put("totalList", totalList);
				
			return resMap;
	}

	private Map funStockOutFlashReportDtl(String strFromdate, String strToDate, String posCode, String type, String reportType, String groupwise, String showStockWith, String showZeroBalStockYN) throws Exception
	{
		StringBuilder sbSql = new StringBuilder();
		
		List listRet = new ArrayList();
		List jArr = new ArrayList();
		Map jObjTatol = new HashMap();
		Map jOBjRet = new HashMap();
		
		double sumOpeningStock=0.0;
	    double sumPurchaseRate = 0.0;
	    double sumAmount = 0.0;
	    double sumTax = 0.0;
	    
		if (type.equalsIgnoreCase("Item wise"))
	    {
		sbSql.append(" SELECT c.strItemName,sum(b.dblQuantity),b.dblPurchaseRate,sum(b.dblAmount) "
			+ ",a.strStkOutCode,DATE_FORMAT(a.dteStkOutDate,'%d-%m-%Y'),d.strPosName,g.strReasonName,a.strPurchaseBillNo "
			+ ",sum(a.dblTaxAmt) "
			+ "FROM tblstkouthd a  "
			+ "join tblstkoutdtl b on a.strStkOutCode=b.strStkOutCode  "
			+ "join tblitemmaster c on c.strItemCode=b.strItemCode  "
			+ "join tblposmaster d on a.strPOSCode=d.strPosCode "
			+ "left join tblpurchaseorderhd e on a.strPurchaseBillNo=e.strPOCode "
			+ "left join tblsuppliermaster f on e.strSupplierCode=f.strSupplierCode "
			+ "left join tblreasonmaster g on a.strReasonCode=g.strReasonCode "
			+ " where date( a.dteStkOutDate ) BETWEEN '" + objGlobalFunctions.funGetDate("yyyy-MM-dd",strFromdate) + "' AND '" + objGlobalFunctions.funGetDate("yyyy-MM-dd",strToDate) + "' ");
		if (!posCode.equals("All"))
		{
		    sbSql.append("  and a.strPOSCode='" + posCode + "'  ");
		}
		if (!showStockWith.isEmpty())
		{
		    sbSql.append(" and a.strStkOutCode='" + showStockWith.trim() + "'");
		}
		if (!showZeroBalStockYN.isEmpty())
		{
		    sbSql.append(" and b.strItemCode='" + showZeroBalStockYN + "'");
		}
		

		sbSql.append(" group by b.strItemCode,date( a.dteStkOutDate ),a.strPOSCOde,a.strStkOutCode "
			+ " order by date( a.dteStkOutDate ),c.strItemName asc ");
	    }
	    else if (type.equalsIgnoreCase("MenuHead wise"))
	    {
		sbSql.append(" select e.strMenuName ,sum(b.dblQuantity),b.dblPurchaseRate,sum(b.dblAmount),a.strStkOutCode"
			+ ",DATE_FORMAT(a.dteStkOutDate,'%d-%m-%Y'),f.strPosName,g.strReasonName,e.strMenuCode,sum(a.dblTaxAmt) "
			+ " from tblstkouthd a,tblstkoutdtl b,tblitemmaster c,tblmenuitempricingdtl d ,tblmenuhd e,tblposmaster f "
			+ ",tblreasonmaster g "
			+ " where b.strItemCode=d.strItemCode and d.strMenuCode=e.strMenuCode "
			+ " and a.strStkOutCode=b.strStkOutCode and c.strItemCode=b.strItemCode and a.strPOSCode=d.strPosCode "
			+ " and a.strPOSCode=f.strPosCode "
			+ " and date( a.dteStkOutDate ) BETWEEN '" + objGlobalFunctions.funGetDate("yyyy-MM-dd",strFromdate) + "' AND '" + objGlobalFunctions.funGetDate("yyyy-MM-dd",strToDate) + "' "
			+ " and a.strReasonCode=g.strReasonCode ");
		if (!posCode.equals("All"))
		{
		    sbSql.append("  and a.strPOSCode='" + posCode + "'  ");
		}
		if (!showStockWith.isEmpty())
		{
		    sbSql.append(" and a.strStkOutCode='" + showStockWith.trim() + "'");
		}
		if (!showZeroBalStockYN.isEmpty())
		{
		    sbSql.append(" and e.strMenuCode='" + showZeroBalStockYN + "'");
		}
		
		sbSql.append(" group by e.strMenuName,date(a.dteStkOutDate),a.strPOSCOde,a.strStkOutCode "
			+ " order by date( a.dteStkOutDate ),e.strMenuName asc ");
	    }
	    else if (type.equalsIgnoreCase("SubGroup wise"))
	    {
		sbSql.append(" select d.strSubGroupName ,sum(b.dblQuantity),b.dblPurchaseRate,sum(b.dblAmount)"
			+ ",a.strStkOutCode,DATE_FORMAT(a.dteStkOutDate,'%d-%m-%Y'),e.strPosName,f.strReasonName,d.strSubGroupCode,sum(a.dblTaxAmt) "
			+ " from tblstkouthd a,tblstkoutdtl b,tblitemmaster c,tblsubgrouphd d,tblposmaster e "
			+ ",tblreasonmaster f"
			+ " where c.strSubGroupCode=d.strSubGroupCode "
			+ " and a.strStkOutCode=b.strStkOutCode and c.strItemCode=b.strItemCode and a.strPOSCode=e.strPosCode"
			+ " and date( a.dteStkOutDate ) BETWEEN '" + objGlobalFunctions.funGetDate("yyyy-MM-dd",strFromdate) + "' AND '" + objGlobalFunctions.funGetDate("yyyy-MM-dd",strToDate) + "' "
			+ "and a.strReasonCode=f.strReasonCode ");
		if (!posCode.equals("All"))
		{
		    sbSql.append("  and a.strPOSCode='" + posCode + "'  ");
		}
		if (!showStockWith.isEmpty())
		{
		    sbSql.append(" and a.strStkOutCode='" + showStockWith.trim() + "'");
		}
		if (!showZeroBalStockYN.isEmpty())
		{
		    sbSql.append(" and d.strSubGroupCode='" + showZeroBalStockYN + "'");
		}
		
		sbSql.append(" group by d.strSubGroupName,date(a.dteStkOutDate),a.strPOSCOde,a.strStkOutCode "
			+ " order by date( a.dteStkOutDate ),d.strSubGroupName asc ");
	    }
	    else if (type.equalsIgnoreCase("Group wise"))
	    {
		sbSql.append(" select e.strGroupName,sum(b.dblQuantity),b.dblPurchaseRate,sum(b.dblAmount),a.strStkOutCode"
			+ ",DATE_FORMAT(a.dteStkOutDate,'%d-%m-%Y'),f.strPosName,g.strReasonName,e.strGroupCode,sum(a.dblTaxAmt) "
			+ " from tblstkouthd a,tblstkoutdtl b,tblitemmaster c,tblsubgrouphd d,tblgrouphd e,tblposmaster f "
			+ ",tblreasonmaster g"
			+ " where c.strSubGroupCode=d.strSubGroupCode and d.strGroupCode=e.strGroupCode "
			+ " and a.strStkOutCode=b.strStkOutCode and c.strItemCode=b.strItemCode and a.strPOSCode=f.strPosCode"
			+ " and date( a.dteStkOutDate ) BETWEEN '" + objGlobalFunctions.funGetDate("yyyy-MM-dd",strFromdate) + "' AND '" + objGlobalFunctions.funGetDate("yyyy-MM-dd",strToDate) + "' "
			+ " and a.strReasonCode=g.strReasonCode ");
		if (!posCode.equals("All"))
		{
		    sbSql.append("  and a.strPOSCode='" + posCode + "'  ");
		}
		if (!showStockWith.isEmpty())
		{
		    sbSql.append(" and a.strStkOutCode='" + showStockWith.trim() + "'");
		}
		if (!showZeroBalStockYN.isEmpty())
		{
		    sbSql.append(" and e.strGroupCode='" + showZeroBalStockYN + "'");
		}
		
		sbSql.append(" group by e.strGroupName,date(a.dteStkOutDate),a.strPOSCOde,a.strStkOutCode "
			+ " order by date( a.dteStkOutDate ),e.strGroupName asc ");
	    }
	
		List listsbSql = objBaseService.funGetList(sbSql, "sql");
		
		if (listsbSql.size() > 0) 
		{
			for (int i = 0; i < listsbSql.size(); i++) 
			{
				Object[] obj = (Object[]) listsbSql.get(i);
				Map jObj = new HashMap();
				jObj.put("ItemName", obj[0].toString());//Group
				jObj.put("Qty", obj[1].toString());//Subgroup
				jObj.put("PurchaseRate", obj[2].toString());//Item Name
				jObj.put("Amount", obj[3].toString());//Op Stock
				jObj.put("StockNo", obj[4].toString());//Stk Out
				jObj.put("StockInDate", objGlobalFunctions.funIfNull(obj[5].toString(), "", obj[5].toString()));//Balance
				jObj.put("PosName", objGlobalFunctions.funIfNull(obj[6].toString(), "", obj[6].toString()));//Purchase Rate
				jObj.put("Reason", objGlobalFunctions.funIfNull(obj[7].toString(), "", obj[7].toString()));//Purchase Rate
				jObj.put("BillNo", objGlobalFunctions.funIfNull(obj[8].toString(), "", obj[8].toString()));//Sale
				jObj.put("Tax", obj[9].toString());//Stk In
				
			

				sumOpeningStock += Double.parseDouble(obj[1].toString()); 
				sumPurchaseRate+=  Double.parseDouble(obj[2].toString()); 
				sumAmount+= Double.parseDouble(obj[3].toString());
				sumTax+= Double.parseDouble(obj[9].toString());
				
				
                jArr.add(jObj);
			}
			
			jObjTatol.put("sumOpeningStock", sumOpeningStock);
			jObjTatol.put("sumPurchaseRate", sumPurchaseRate);
			jObjTatol.put("sumAmount", sumAmount);
			jObjTatol.put("sumTax", sumTax);
			/*jObjTatol.put("sumBalAmt", sumBalAmt);	*/
			jOBjRet.put("total", jObjTatol);
			jOBjRet.put("jArr", jArr);

	   }
		
		return jOBjRet;
	}

	private LinkedHashMap funGetStockInFlashData(String clientCode, String strFromdate, String posCode, String strToDate, String posName, String type, String reportType, String groupwise, String showStockWith, String showZeroBalStockYN) throws Exception
	{LinkedHashMap resMap = new LinkedHashMap();
	  
	   double amtTotal=0, netTotal=0, paxTotal=0;
  
     List colHeader = new ArrayList();
     String strposCode="All";
     String fromDate1=strFromdate.split("-")[2]+"-"+strFromdate.split("-")[1]+"-"+strFromdate.split("-")[0];
		String toDate1=strToDate.split("-")[2]+"-"+strToDate.split("-")[1]+"-"+strToDate.split("-")[0];
	
		
		
		Map jObj = funStockInFlashReportDtl(strFromdate, strToDate,posCode,type,reportType,groupwise,showStockWith,showZeroBalStockYN);
		List list =new ArrayList();
		List totalList=new ArrayList();
		List jarr = (ArrayList) jObj.get("jArr");
		
		totalList.add("Total :");
		if(null!=jarr)
		{
			if(jarr.size()>0)
			{
				for(int i=0;i<jarr.size();i++)
				 {
					Map jObjtemp =(Map) jarr.get(i);
					List arrList=new ArrayList();
					arrList.add(jObjtemp.get("ItemName"));
					arrList.add(jObjtemp.get("Qty"));
					arrList.add(jObjtemp.get("PurchaseRate"));
					arrList.add(jObjtemp.get("Amount"));
					arrList.add(jObjtemp.get("StockNo"));
					arrList.add(jObjtemp.get("StockInDate"));
					arrList.add(jObjtemp.get("PosName"));
					arrList.add(jObjtemp.get("Reason"));
					arrList.add(jObjtemp.get("BillNo"));
					arrList.add(jObjtemp.get("Tax"));
					
					
					vItemCode.add(jObjtemp.get("ItemName"));
												
					list.add(arrList);
				 }
				
				   Map jObjTotal =(Map) jObj.get("total");;
				   totalList.add(Double.parseDouble(jObjTotal.get("sumOpeningStock").toString()));
				   totalList.add(Double.parseDouble(jObjTotal.get("sumPurchaseRate").toString()));
				   totalList.add(Double.parseDouble(jObjTotal.get("sumAmount").toString()));
				   totalList.add(Double.parseDouble(jObjTotal.get("sumTax").toString()));

				   
			}
	    }
		
		List arrListHeader = null;
		arrListHeader=new ArrayList();
		arrListHeader.add("Item Name");
		arrListHeader.add("Qty");
		arrListHeader.add("Purchase Rate");
		arrListHeader.add("Amount");
		arrListHeader.add("Stock No");
		arrListHeader.add("Stock Date");
		arrListHeader.add("Pos Name");
		arrListHeader.add("Reason");
		arrListHeader.add("Bill No");
		arrListHeader.add("Tax");

			
		resMap.put("listHeader", arrListHeader);
		resMap.put("listDetails", list);
		resMap.put("totalList", totalList);
		
	return resMap;}

	private Map funStockInFlashReportDtl(String strFromdate, String strToDate, String posCode, String type, String reportType, String groupwise, String showStockWith, String showZeroBalStockYN) throws Exception
	{

		
		StringBuilder sbSql = new StringBuilder();
		
		List listRet = new ArrayList();
		List jArr = new ArrayList();
		Map jObjTatol = new HashMap();
		Map jOBjRet = new HashMap();
		String posName = "All";

		if (type.equals("Item wise"))
	    {
		sbSql.append(" SELECT c.strItemName,b.dblQuantity,b.dblPurchaseRate,b.dblAmount,a.strStkInCode,DATE_FORMAT(a.dteStkInDate,'%d-%m-%Y')"
			+ ",d.strPosName,g.strReasonName,a.strPurchaseBillNo "
			+ ",sum(a.dblTaxAmt) "
			+ "FROM tblstkinhd a "
			+ "join tblstkindtl b on a.strStkInCode=b.strStkInCode "
			+ "join tblitemmaster c on c.strItemCode=b.strItemCode  "
			+ "join tblposmaster d on a.strPOSCode=d.strPosCode  "
			+ "left join tblpurchaseorderhd e on a.strPurchaseBillNo=e.strPOCode "
			+ "left join tblsuppliermaster f on e.strSupplierCode=f.strSupplierCode "
			+ "left join tblreasonmaster g on a.strReasonCode=g.strReasonCode "
			+ " where date( a.dteStkInDate ) BETWEEN '" + objGlobalFunctions.funGetDate("yyyy-MM-dd",strFromdate)+ "' AND '" + objGlobalFunctions.funGetDate("yyyy-MM-dd",strToDate) + "' "
			+ "and a.strReasonCode=g.strReasonCode ");
		if (!posName.equals("All"))
		{
		    sbSql.append("  and a.strPOSCode='" + posCode+ "'  ");
		}
		if (!showStockWith.isEmpty())
		{
		    sbSql.append(" and a.strStkInCode='" + showStockWith.trim() + "'");
		}
		if (!showZeroBalStockYN.isEmpty())
		{
		    sbSql.append(" and b.strItemCode='" + showZeroBalStockYN + "'");
		}
		
		sbSql.append(" group by date(a.dteStkInDate),a.strStkInCode,a.strPOSCode,b.strItemCode "
			+ "ORDER BY DATE(a.dteStkInDate),c.strItemName ASC ");
	    }
	    else if (type.equalsIgnoreCase("MenuHead wise"))
	    {
		sbSql.append(" select e.strMenuName,sum(b.dblQuantity),b.dblPurchaseRate,sum(b.dblAmount),a.strStkInCode"
			+ ",DATE_FORMAT(a.dteStkInDate,'%d-%m-%Y'),f.strPosName,g.strReasonName,e.strMenuCode,sum(a.dblTaxAmt) "
			+ " from tblstkinhd a,tblstkindtl b,tblitemmaster c,tblmenuitempricingdtl d ,tblmenuhd e,tblposmaster f"
			+ ",tblreasonmaster g "
			+ " where b.strItemCode=d.strItemCode and d.strMenuCode=e.strMenuCode "
			+ " and a.strStkInCode=b.strStkInCode and c.strItemCode=b.strItemCode and a.strPOSCode=d.strPosCode "
			+ " and a.strPOSCode=f.strPosCode "
			+ " and date( a.dteStkInDate ) BETWEEN '" + objGlobalFunctions.funGetDate("yyyy-MM-dd",strFromdate) + "' AND '" + objGlobalFunctions.funGetDate("yyyy-MM-dd",strToDate) + "' "
			+ "and a.strReasonCode=g.strReasonCode ");
		if (!posName.equals("All"))
		{
		    sbSql.append(" and a.strPOSCode='" + posCode + "'  ");
		}
		if (!showStockWith.isEmpty())
		{
		    sbSql.append(" and a.strStkInCode='" + showStockWith.trim() + "'");
		}
		if (!showZeroBalStockYN.isEmpty())
		{
		    sbSql.append(" and e.strMenuCode='" + showZeroBalStockYN + "'");
		}
		
		sbSql.append(" group by e.strMenuName,date(a.dteStkInDate),a.strPOSCOde,a.strStkInCode "
			+ " order by date( a.dteStkInDate ),e.strMenuName asc ");
	    }
	    else if (type.equalsIgnoreCase("SubGroup wise"))
	    {
		sbSql.append(" select d.strSubGroupName,sum(b.dblQuantity),b.dblPurchaseRate,sum(b.dblAmount),a.strStkInCode"
			+ ",DATE_FORMAT(a.dteStkInDate,'%d-%m-%Y'),e.strPosName,f.strReasonName,d.strSubGroupCode,sum(a.dblTaxAmt) "
			+ " from tblstkinhd a,tblstkindtl b,tblitemmaster c,tblsubgrouphd d,tblposmaster e,tblreasonmaster f  "
			+ " where c.strSubGroupCode=d.strSubGroupCode "
			+ " and a.strStkInCode=b.strStkInCode and c.strItemCode=b.strItemCode and a.strPOSCode=e.strPosCode "
			+ " and date( a.dteStkInDate ) BETWEEN '" + objGlobalFunctions.funGetDate("yyyy-MM-dd",strFromdate) + "' AND '" + objGlobalFunctions.funGetDate("yyyy-MM-dd",strToDate) + "' "
			+ "and a.strReasonCode=f.strReasonCode ");
		if (!posName.equals("All"))
		{
		    sbSql.append("  and a.strPOSCode='" + posCode + "'  ");
		}
		if (!showStockWith.isEmpty())
		{
		    sbSql.append(" and a.strStkInCode='" + showStockWith.trim() + "'");
		}
		if (!showZeroBalStockYN.isEmpty())
		{
		    sbSql.append(" and c.strSubGroupCode='" + showZeroBalStockYN + "'");
		}
		
		sbSql.append(" group by d.strSubGroupName,date(a.dteStkInDate),a.strPOSCOde,a.strStkInCode "
			+ " order by date( a.dteStkInDate ),d.strSubGroupName asc ");
	    }
	    else if (type.equalsIgnoreCase("Group wise"))
	    {
		sbSql.append(" select e.strGroupName,sum(b.dblQuantity),b.dblPurchaseRate,sum(b.dblAmount),a.strStkInCode"
			+ ",DATE_FORMAT(a.dteStkInDate,'%d-%m-%Y'),f.strPosName,g.strReasonName,e.strGroupCode,sum(a.dblTaxAmt) "
			+ " from tblstkinhd a,tblstkindtl b,tblitemmaster c,tblsubgrouphd d,tblgrouphd e,tblposmaster f "
			+ ",tblreasonmaster g "
			+ " where c.strSubGroupCode=d.strSubGroupCode and d.strGroupCode=e.strGroupCode "
			+ " and a.strStkInCode=b.strStkInCode and c.strItemCode=b.strItemCode and a.strPOSCode=f.strPosCode  "
			+ " and date( a.dteStkInDate ) BETWEEN '" + objGlobalFunctions.funGetDate("yyyy-MM-dd",strFromdate) + "' AND '" + objGlobalFunctions.funGetDate("yyyy-MM-dd",strToDate) + "' "
			+ "and a.strReasonCode=g.strReasonCode ");
		if (!posName.equals("All"))
		{
		    sbSql.append("  and a.strPOSCode='" + posCode + "'  ");
		}
		if (!showStockWith.isEmpty())
		{
		    sbSql.append(" and a.strStkInCode='" + showStockWith.trim() + "'");
		}
		if (!showZeroBalStockYN.isEmpty())
		{
		    sbSql.append(" and e.strGroupCode='" + showZeroBalStockYN + "'");
		}
		
		sbSql.append(" group by e.strGroupName,date(a.dteStkInDate),a.strPOSCOde,a.strStkInCode "
			+ " order by date( a.dteStkInDate ),e.strGroupName asc ");
	    }
		    
		    List listsbSql = objBaseService.funGetList(sbSql, "sql");
		    double sumOpeningStock=0.0;
		    double sumPurchaseRate = 0.0;
		    double sumAmount = 0.0;
		    double sumTax = 0.0;
			if (listsbSql.size() > 0) 
			{
				
				for (int i = 0; i < listsbSql.size(); i++) 
				{
					Object[] obj = (Object[]) listsbSql.get(i);
					Map jObj = new HashMap();
					jObj.put("ItemName", obj[0].toString());//Group
					jObj.put("Qty", obj[1].toString());//Subgroup
					jObj.put("PurchaseRate", obj[2].toString());//Item Name
					jObj.put("Amount", obj[3].toString());//Op Stock
					jObj.put("StockNo", obj[4].toString());//Stk Out
					jObj.put("StockInDate", objGlobalFunctions.funIfNull(obj[5].toString(), "", obj[5].toString()));//Balance
					jObj.put("PosName", objGlobalFunctions.funIfNull(obj[6].toString(), "", obj[6].toString()));//Purchase Rate
					jObj.put("Reason", objGlobalFunctions.funIfNull(obj[7].toString(), "", obj[7].toString()));//Purchase Rate
					jObj.put("BillNo", objGlobalFunctions.funIfNull(obj[8].toString(), "", obj[8].toString()));//Sale
					jObj.put("Tax", obj[9].toString());//Stk In
					
					sumOpeningStock += Double.parseDouble(obj[1].toString()); 
					sumPurchaseRate+=  Double.parseDouble(obj[2].toString()); 
					sumAmount+= Double.parseDouble(obj[3].toString());
					sumTax+= Double.parseDouble(obj[9].toString());
					
	                jArr.add(jObj);
				}
				jObjTatol.put("sumOpeningStock", sumOpeningStock);
				jObjTatol.put("sumPurchaseRate", sumPurchaseRate);
				jObjTatol.put("sumAmount", sumAmount);
				jObjTatol.put("sumTax", sumTax);
				/*jObjTatol.put("sumBalAmt", sumBalAmt);	*/
				jOBjRet.put("total", jObjTatol);
				jOBjRet.put("jArr", jArr);

		   }
		
		
		
		return jOBjRet;
	
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/rptPOSStockInOutFlashReport", method = RequestMethod.POST)	
	private ModelAndView funReport(@ModelAttribute("command") clsPOSReportBean objBean, HttpServletResponse resp,HttpServletRequest req) throws Exception
	{
		
		String clientCode=req.getSession().getAttribute("gClientCode").toString();
		String posName =objBean.getStrPOSName();
		String PosCode=req.getSession().getAttribute("loginPOS").toString();
	    String strFromdate=objBean.getFromDate();
		String strToDate=objBean.getToDate();
		String type=objBean.getStrType();
		String reportType=objBean.getStrReportType();
		String groupwise=objBean.getDblUSDConverionRate();
		String showStockWith="";
		String showZeroBalStockYN="";
		
		Map resMap = new LinkedHashMap();
		 if (reportType.equalsIgnoreCase("Stock In"))
	        {
			 	resMap=funGetStockInFlashData(clientCode,strFromdate,PosCode,strToDate,posName,type,reportType,groupwise,showStockWith,showZeroBalStockYN);
	        }
	        else
	        {
	        	resMap=funGetStockOutFlashData(clientCode,strFromdate,strToDate,posName,type,reportType,groupwise,showStockWith,showZeroBalStockYN);
	        	
	        }
			
		List ExportList=new ArrayList();	
		
		String FileName="Stock Flash "+strFromdate+"_To_"+strToDate;
	
		ExportList.add(FileName);
						
		List List=(List)resMap.get("listHeader");
		
		String[] headerList = new String[List.size()];
		for(int i = 0; i < List.size(); i++){
			headerList[i]=(String)List.get(i);
		}
		
		ExportList.add(headerList);
		
		List dataList=(List)resMap.get("listDetails");
		List totalList=(List)resMap.get("totalList"); 	
		
		dataList.add(totalList);
				
		ExportList.add(dataList);
		
	    return new ModelAndView("excelViewWithReportName", "listWithReportName", ExportList);	
}

}
