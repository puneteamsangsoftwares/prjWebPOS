package com.sanguine.webpos.controller;

import java.lang.reflect.Array;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sanguine.base.service.clsSetupService;
import com.sanguine.base.service.intfBaseService;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.webpos.bean.clsPOSReportBean;
import com.sanguine.webpos.bean.clsPOSSalesFlashReportsBean;
import com.sanguine.webpos.model.clsAreaMasterModel;
import com.sanguine.webpos.model.clsSettlementMasterModel;
import com.sanguine.webpos.model.clsSetupHdModel;
import com.sanguine.webpos.model.clsShiftMasterModel;
import com.sanguine.webpos.model.clsUserHdModel;
import com.sanguine.webpos.sevice.clsPOSMasterService;
import com.sanguine.webpos.sevice.clsPOSReportService;

@Controller
public class clsPOSSalesReportController {
	
	

	@Autowired
	private clsGlobalFunctions objGlobalFunctions;
	
	@Autowired
	private clsPOSGlobalFunctionsController objPOSGlobalFunctionsController; 
	
	 @Autowired
	private ServletContext servletContext;
	 
	@Autowired
	clsPOSMasterService objMasterService;
	
	@Autowired
	private intfBaseService obBaseService;
	
	@Autowired
	private clsPOSReportService objReportService;
	
	@Autowired
	private clsGlobalFunctions objGlobal;
	
	@Autowired
	private clsSetupService objSetupService;
	
	 Map<String,String> hmPOSData;
	 Map<String,String> hmPayMode;
	 Map<String,String> hmOperator;
	 Map<String,String> hmArea;
	 List<clsPOSSalesFlashReportsBean> listSalesReport;
	 List listStockFlashModel;
	 DecimalFormat decimalFormat;
	 DecimalFormat decimalFormat2;
	 DecimalFormat decimalFormat1;
	 DecimalFormat decimalFormat0;
	 
	 
	 
	 double totalDiscAmt = 0, totalSubTotal = 0, totalTaxAmt = 0, totalSettleAmt = 0,totalTipAmt = 0;
	 
	@RequestMapping(value = "/frmPOSSalesReport", method = RequestMethod.GET)
		public ModelAndView funOpenForm(Map<String, Object> model,HttpServletRequest request) throws Exception
		{
		 
		 	decimalFormat = new DecimalFormat("#.##");
			String strClientCode=request.getSession().getAttribute("gClientCode").toString();	
			String POSCode=request.getSession().getAttribute("loginPOS").toString();	
			String urlHits="1";
			try{
				urlHits=request.getParameter("saddr").toString();
			}catch(NullPointerException e){
				urlHits="1";
			}
			model.put("urlHits",urlHits);
			List poslist = new ArrayList();
			poslist.add("All");
			
			hmPOSData=new HashMap<String, String>();
			List list=objMasterService.funFillPOSCombo(strClientCode);
			hmPOSData.put("All", "All");
			for(int cnt=0;cnt<list.size();cnt++)
			{
				Object obj=list.get(cnt);
				poslist.add(Array.get(obj, 1).toString());
				hmPOSData.put(Array.get(obj, 0).toString(), Array.get(obj, 1).toString());
			}
			model.put("posList",poslist);
			
			List listHH=new ArrayList();
			List listMM=new ArrayList();
			List listOperator=new ArrayList();
			List listPayMode=new ArrayList();
			
			listHH.add("HH");
			for(int i=1;i<=12;i++)
			{
				listHH.add(i);
			}
			model.put("HH",listHH);
			
			listMM.add("MM");
			for(int i=1;i<=60;i++)
			{
				listMM.add(i);
			}
			model.put("MM",listMM);
			
			hmPayMode=new HashMap<String, String>();
			list=objMasterService.funLoadSettlementDtl(strClientCode);
			listPayMode.add("All");
			hmPayMode.put("All", "All");
			clsSettlementMasterModel objModel = null;
			for(int cnt=0;cnt<list.size();cnt++)
			{
				objModel = (clsSettlementMasterModel) list.get(cnt);
				listPayMode.add(objModel.getStrSettelmentDesc());
				hmPayMode.put(objModel.getStrSettelmentCode(), objModel.getStrSettelmentDesc());
			}
			model.put("PayMode",listPayMode);	
			
			
			hmOperator=new HashMap<String, String>();
			listOperator.add("All");
			list=objMasterService.funFillUserCombo(strClientCode);
			hmOperator.put("All", "All");
			clsUserHdModel objUserModel = null;
			for(int cnt=0;cnt<list.size();cnt++)
			{
				objUserModel = (clsUserHdModel) list.get(cnt);
				listOperator.add(objUserModel.getStrUserName());
				hmOperator.put(objUserModel.getStrUserCode(), objUserModel.getStrUserName());
			}
			 model.put("Operator",listOperator);
			 
			List arealist = new ArrayList();
			arealist.add("All");
			hmArea=new HashMap<String, String>();
			List listForAreaMasterData = objMasterService.funGetAllAreaForMaster(strClientCode);
			Map mapAreaName = new HashMap<>();
			if(listForAreaMasterData!=null)
			{
				for(int cnt=0;cnt<listForAreaMasterData.size();cnt++)
				{
					clsAreaMasterModel objAreaModel= (clsAreaMasterModel) listForAreaMasterData.get(cnt);
					arealist.add(objAreaModel.getStrAreaName());
					hmArea.put(objAreaModel.getStrAreaCode(), objAreaModel.getStrAreaName());
				}
			}
			model.put("areaList",arealist);
			clsSetupHdModel objSetupHdModel=null;
			objSetupHdModel=objMasterService.funGetPOSWisePropertySetup(strClientCode,POSCode);
			String gEnableShiftYN=objSetupHdModel.getStrShiftWiseDayEndYN();
			model.put("gEnableShiftYN", gEnableShiftYN);
			//Map objSetupParameter=objSetupService.funGetParameterValuePOSWise(strClientCode, POSCode, "gEnableShiftYN");
			//model.put("gEnableShiftYN",objSetupParameter.get("gEnableShiftYN").toString());
			
			List shiftList = new ArrayList();
			shiftList.add("All");
			List listShiftData = funGetPOSWiseShiftList(POSCode,request);
			if(listShiftData!=null)
			{
				for(int cnt=0;cnt<listShiftData.size();cnt++)
				{
					clsShiftMasterModel objShiftModel= (clsShiftMasterModel) listShiftData.get(cnt);
					arealist.add(objShiftModel.getIntShiftCode());
				}
			}
			model.put("shiftList",shiftList);
		    
			 
           //for pos date
		    String POSDate=request.getSession().getAttribute("gPOSDate").toString();
			request.setAttribute("POSDate", POSDate);
			
			if("2".equalsIgnoreCase(urlHits)){
				return new ModelAndView("frmPOSSalesReport_1","command", new clsPOSReportBean());
			}else if("1".equalsIgnoreCase(urlHits)){
				return new ModelAndView("frmPOSSalesReport","command", new clsPOSReportBean());
			}else {
				return null;
			}
	}	 
		
	 	
	 	//rptPOSSalesReport
	 	
	 	@SuppressWarnings("rawtypes")
		@RequestMapping(value = "/rptPOSSalesReport", method = RequestMethod.POST)	
		private ModelAndView funReport(@ModelAttribute("command") clsPOSReportBean objBean, HttpServletResponse resp,HttpServletRequest req)
		{
			    String clientCode=req.getSession().getAttribute("gClientCode").toString();
		     	String userCode=req.getSession().getAttribute("gUserCode").toString();
	 			String companyName=req.getSession().getAttribute("gCompanyName").toString();
	 			String LoginPOSCode=req.getSession().getAttribute("loginPOS").toString(); 			
	 			String FromDate="",FromTime="",ToDate="",ToTime="";	
	 			String FromDateTime=objBean.getFromDate()+":"+objBean.getStrHHFrom()+"/"+objBean.getStrMMFrom()+"/"+objBean.getStrAMPMFrom();
	 			String ToDateTime=objBean.getToDate()+":"+objBean.getStrHHTo()+"/"+objBean.getStrMMTo()+"/"+objBean.getStrAMPMTo();
				String operationType=objBean.getStrOperationType();
				String strPOSName=objBean.getStrPOSName();	
				String strOperator=objBean.getStrOperator();
				String strPayMode=objBean.getStrPayMode();
				String strFromBill=objBean.getStrFromBillNo();
				String strToBill=objBean.getStrToBillNo();
				String reportType=objBean.getStrReportType();
				String Type=objBean.getStrType();
				String Customer=objBean.getStrCustomer();
				String ConsolidatePOS=objBean.getStrConsolidatePOS();
				String ReportName=objBean.getStrReportName();
				String shiftNo="1";
				String areaCode="";
				FromDate=FromDateTime.split(":")[0];
	 			FromTime=FromDateTime.split(":")[1];
	 			ToDate=ToDateTime.split(":")[0];
	 			ToTime=ToDateTime.split(":")[1];
	 		
	 			String strFromdate=FromDate.split("-")[2]+"-"+FromDate.split("-")[1]+"-"+FromDate.split("-")[0];
	 			String strToDate=ToDate.split("-")[2]+"-"+ToDate.split("-")[1]+"-"+ToDate.split("-")[0]; 
	 			
	 			clsSetupHdModel objSetupHdModel=null;
				try
				{
					objSetupHdModel=objMasterService.funGetPOSWisePropertySetup(clientCode,LoginPOSCode);
				}
				catch (Exception e)
				{
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				String gEnableShiftYN=objSetupHdModel.getStrShiftWiseDayEndYN();
			
				
	 			//Map objSetupParameter=objSetupService.funGetParameterValuePOSWise(clientCode, LoginPOSCode, "gEnableShiftYN");
				if(gEnableShiftYN.equals("Y"))
				{
					shiftNo=objBean.getStrShiftCode();
				}
	 			
			    Map resMap = new LinkedHashMap();
				resMap=FunGetData(strPOSName,FromDateTime,ToDateTime,strOperator,strPayMode,strFromBill,strToBill,reportType,
	 					Type,Customer,ConsolidatePOS,ReportName,userCode,LoginPOSCode,gEnableShiftYN,shiftNo,clientCode,operationType,areaCode);
			
				List ExportList=new ArrayList();	
			
				String dteFromDate=objBean.getFromDate();
				String dteToDate=objBean.getToDate();
				String FileName="SalesFlashReport_"+ReportName.substring(3)+"_"+dteFromDate+"_To_"+dteToDate;
				
				ExportList.add(FileName);
				int  rowCount=(int) resMap.get("RowCount");
				int colCount=(int) resMap.get("ColCount");					
				List List=(List)resMap.get("Header");
				if(resMap.containsKey("headerList"))
				{
					List Listt=(List)resMap.get("headerList");
					if(Listt!=null)
					{					
						String[] headerListt = new String[Listt.size()];					
						for(int i = 0; i < Listt.size(); i++){
							headerListt[i]=(String)Listt.get(i);
						}
						ExportList.add(headerListt);
					}
				}
				
				List rowlist=new ArrayList();
				String[] headerList = new String[List.size()];
				
				for(int i = 0; i < List.size(); i++){
					headerList[i]=(String)List.get(i);
				}
			
			ExportList.add(headerList);
			for(int i=0;i<resMap.size();i++)
			{
				if(i<rowCount)
				{	
					List ob=(List)resMap.get(""+i);
					rowlist.add(ob);
				}
			
			}
			for(int i=0;i<2;i++)
			{
				List DataList=new ArrayList();
				for(int j=0; j<colCount;j++)
				{
					DataList.add(" ");
				}
				rowlist.add(DataList);
			}
			
		
			
			//Total Header
			List TotalHeaderList=new ArrayList();		
			//String rName=ReportName.substring(2);
			switch(ReportName.substring(3))
			{
				case "SettlementWise" :
					//TotalHeaderList.add("Total");
					//TotalHeaderList.add("Sales Amount");
					break;
					
				case "BillWise" :
					//TotalHeaderList.add("Total");
					//TotalHeaderList.add("Sub Total");
					//TotalHeaderList.add("Disc ");
					//TotalHeaderList.add("Tax Total");
					//TotalHeaderList.add("Sales Amount");
					//TotalHeaderList.add("Tip Amount");
					break;
				
				case "ItemWise" :
					//TotalHeaderList.add("Total");
					//TotalHeaderList.add("Quantity");
					//TotalHeaderList.add("Sales Amount");
					//TotalHeaderList.add("Sub Total");
					//TotalHeaderList.add("Discount ");
					
					break;
				case "MenuHeadWise":
					//TotalHeaderList.add("Total");
					//TotalHeaderList.add("Quantity");
					//TotalHeaderList.add("Sales Amount");
					//TotalHeaderList.add("Sub Total");
					//TotalHeaderList.add("Discount ");
					break;
				case "GroupWise":
					//TotalHeaderList.add("Total");
					//TotalHeaderList.add("Quantity");
					//TotalHeaderList.add("Sub Total");
					//TotalHeaderList.add("Net Total");
					//TotalHeaderList.add("Discount ");
					break;
				case "SubGroupWise":
					//TotalHeaderList.add("Total");
					//TotalHeaderList.add("Quantity");
					//TotalHeaderList.add("Sub Total");
					//TotalHeaderList.add("Net Total");
					//TotalHeaderList.add("Discount ");
					break;
				case "CustWise":
					TotalHeaderList.add(" ");
					TotalHeaderList.add(" ");
					TotalHeaderList.add(" ");
					//TotalHeaderList.add("Quantity");
					//TotalHeaderList.add("Sales Amount");
					break;
					
				case "WaiterWise":
					//TotalHeaderList.add("Total");
					//TotalHeaderList.add("Sales Amount");
					break;
				case "DeliveryBoyWise":
					//TotalHeaderList.add("Total");
					//TotalHeaderList.add("Sales Amount");
					break;
				case "CostCenterWise":
					//TotalHeaderList.add("Total");
					//TotalHeaderList.add("Quantity");
					//TotalHeaderList.add("Sub Total");
					//TotalHeaderList.add("Sales Amount");
					//TotalHeaderList.add("Discount ");
					break;
				case "HomeDeliveryWise":
					//TotalHeaderList.add("Total");
					//TotalHeaderList.add("Discount ");
					//TotalHeaderList.add("Tax ");
					//TotalHeaderList.add("Sales Amount");
					break;
				case "TableWise":
					//TotalHeaderList.add("Total");
					//TotalHeaderList.add("Sales Amount");
					break;
				case "HourlyWise":
					/*TotalHeaderList.add("Total");
					TotalHeaderList.add("Sales Amount");*/
					break;
				case "AreaWise":
					/*TotalHeaderList.add("Total");
					TotalHeaderList.add("Sales Amount");*/
					break;
				case "DayWiseSales":				 		
					/*TotalHeaderList.add("Total");
					TotalHeaderList.add("Total Bill");
					TotalHeaderList.add("Sub Total");
					TotalHeaderList.add("Total Discount");
					TotalHeaderList.add("Tax Total ");
					TotalHeaderList.add("Total Amount");*/
					break;
				case "TaxWiseSales":
					/*TotalHeaderList.add("Total");
					TotalHeaderList.add("Total Taxable");
					TotalHeaderList.add("Total Tax");*/
					break;
				case "TipReport":
					/*TotalHeaderList.add("Total");
					TotalHeaderList.add("Discount");
					TotalHeaderList.add("Sub Total");
					TotalHeaderList.add("Tax Total ");
					TotalHeaderList.add("Tip Amount");
					TotalHeaderList.add("Sales Amount");*/
					break;
				case "ItemModifierWise":
					/*TotalHeaderList.add("Total");
					TotalHeaderList.add("Quantity");
					TotalHeaderList.add("Sales Amount");*/
					break;
				case "MenuHeadWiseWithModifier":
					//TotalHeaderList.add("Total");	
					//TotalHeaderList.add("Quantity");
					//TotalHeaderList.add("Sales Amount");
					break;
				case "ItemHourlyWise":
					//TotalHeaderList.add("Total");
					//TotalHeaderList.add("Total Amount");
					//TotalHeaderList.add("Total Discount");
					break;
				case "OperatorWise":
					//TotalHeaderList.add("Total");
					//TotalHeaderList.add("Discount Amount");
					//TotalHeaderList.add("Sales Amount");
					break;
				case "MonthlySalesFlash":
					//TotalHeaderList.add("Total");
					//TotalHeaderList.add("Total Sale");
					break;
			}
			
			List totalList=(List)resMap.get("Total");
			rowlist.add(totalList);			
			TotalHeaderList.add("");
			TotalHeaderList.add(" Created On : " + objGlobal.funGetCurrentDateTime("dd-mm-yyyy")+ " By : " + userCode + " ");
			rowlist.add(TotalHeaderList);
			
			ExportList.add(rowlist);
			return new ModelAndView("excelViewWithReportName", "listWithReportName", ExportList);	
		}
		
	 	 private LinkedHashMap FunGetData(String strPOSName,String FromDateTime,String ToDateTime, String strOperator,
					String strPayMode,String strFromBill,String strToBill,String reportType,
					String Type,String Customer,String ConsolidatePOS,String ReportName,String userCode,String LoginPOSCode,String enableShiftYN,String shiftCode,String clientCode,String operationType,String areaCode)
				{
	 		 
	 		 	
				  LinkedHashMap resMap = new LinkedHashMap();
			     
			        List colHeader = new ArrayList();
			       
			        colHeader.add(" ");
			          
			    	String FromDate="",FromTime="",ToDate="",ToTime="";
		 			
		 			FromDate=FromDateTime.split(":")[0];
		 			FromTime=FromDateTime.split(":")[1];
		 			ToDate=ToDateTime.split(":")[0];
		 			ToTime=ToDateTime.split(":")[1];
		 		
		 			String strFromdate=FromDate.split("-")[2]+"-"+FromDate.split("-")[1]+"-"+FromDate.split("-")[0];
		 			String strToDate=ToDate.split("-")[2]+"-"+ToDate.split("-")[1]+"-"+ToDate.split("-")[0]; 
				    String dateFrom = "", field = null, dateTo = "";
				    try{	
	 				if (funGetFromTime(FromTime)!= null)
	 				{
				        dateFrom = strFromdate + " " + funGetFromTime(FromTime);
				        field = "dteBillDate";
	 				}
	 				else 
	 				{
				        dateFrom = strFromdate;
				        field = "date(dteBillDate)";
	 				}
	 				if (funGetToTime(ToTime) != null)
	 				{
	 					dateTo = strToDate + " " + funGetToTime(ToTime);
	 				}
	 				else
					{
					    dateTo = strToDate;
					}
	 				ConsolidatePOS=objGlobalFunctions.funIfNull(ConsolidatePOS,"N","Y");
	 				if(ConsolidatePOS.equalsIgnoreCase("true"))
	 				{
	 					ConsolidatePOS="Y";
	 				}
	 				else{
	 					ConsolidatePOS="N";
	 				}
	 				//
	 				String posCode= "All";
	 				String PayMode= "All";
			
	 				if(!strPOSName.equalsIgnoreCase("ALL"))
	 				{
	 					 for(Map.Entry<String,String> entry : hmPOSData.entrySet())
	 					 {
	 						 String POSCode=entry.getKey();
	 						 String POSName=entry.getValue();
	 						 if(POSName.equalsIgnoreCase(strPOSName))
	 						 {
	 							posCode=POSCode;
	 						 }
	 					 }
	 					//posCode= hmPOSData.get(strPOSName);
	 				}
		
	 				if(!strPayMode.equalsIgnoreCase("All"))
	 				{
	 					PayMode= hmPayMode.get(strPayMode);
	 				}
			
	 				
					Map mapData=new HashMap();
					 
					mapData=objReportService.funSalesReport(dateFrom, dateTo, posCode,shiftCode,userCode,field,PayMode,strOperator,strFromBill,strToBill,reportType,Type,Customer,ConsolidatePOS,ReportName.substring(3),LoginPOSCode,enableShiftYN,clientCode,operationType,areaCode);
					DecimalFormat decimalFormat2;
					decimalFormat2 = new DecimalFormat("0.00");
					List listColHeader = (ArrayList)mapData.get("ColHeader");
					List headerList=(ArrayList)mapData.get("headerList");
					colHeader=listColHeader;
					int colCount=Integer.parseInt(mapData.get("colCount").toString());
					int rowCount=Integer.parseInt(mapData.get("RowCount").toString());
					double totalSale=0;
					double totalDiscAmt=0,totalSubTotal=0,totalTaxAmt=0,totalSettleAmt=0,totalTipAmt=0,
							totalQty1=0, totalAmount=0, subTotal=0, discountTotal=0 ,
	 						SalesAmount=0, Tax=0, totalDiscount = 0, totalSubTotalDWise = 0,
	 						totalTax = 0, totalTaxableAmt = 0,totalDisc=0,TotalPAX=0,TotalNoOfBills=0,totalAdvAmt=0,totalRoundOff=0;
			 				
		 					
					int totalNoOfBills = 0;
	 				int totalQty=0;
					List listTotal=new ArrayList();
					switch(ReportName.substring(3))
					{
						case "SettlementWise":
								totalSale=Double.parseDouble(mapData.get("TotalSale").toString());
								listTotal.add("");
								listTotal.add("Total");
								listTotal.add(totalSale);
							break;
						case "BillWise" :
								totalDiscAmt=Double.parseDouble(mapData.get("totalDiscAmt").toString());
				 				totalSubTotal=Double.parseDouble(mapData.get("totalSubTotal").toString());
				 				totalTaxAmt=Double.parseDouble(mapData.get("totalTaxAmt").toString());
				 				totalSettleAmt=Double.parseDouble(mapData.get("totalSettleAmt").toString());
				 				totalTipAmt=Double.parseDouble(mapData.get("totalTipAmt").toString());
				 				TotalPAX=Double.parseDouble(mapData.get("totalPaxx").toString());
				 				totalAdvAmt=Double.parseDouble(mapData.get("totalAdvTotal").toString());
				 				totalRoundOff=Double.parseDouble(mapData.get("totalRoundOff").toString());
				 				listTotal.add("");
				 				listTotal.add("");
				 				listTotal.add("");
				 				listTotal.add("");
				 				listTotal.add("");
				 				listTotal.add("");
				 				listTotal.add("");
				 				listTotal.add("Total");
				 				listTotal.add("");
								listTotal.add(totalSubTotal);
								listTotal.add("");
								listTotal.add(totalDiscAmt);
								listTotal.add(totalTaxAmt);
								listTotal.add(totalAdvAmt);
								listTotal.add(totalSettleAmt);
								listTotal.add(totalRoundOff);
								listTotal.add("");
								listTotal.add(totalTipAmt);
								listTotal.add("");
								listTotal.add("");
								listTotal.add(TotalPAX);
								
							break;
						case "ItemWise":
								totalQty1=Double.parseDouble(mapData.get("totalQty").toString());
				 				 totalQty=(int) totalQty1;
				 				totalAmount=Double.parseDouble(mapData.get("totalAmount").toString());
				 				subTotal=Double.parseDouble(mapData.get("subTotal").toString());
				 				discountTotal=Double.parseDouble(mapData.get("discountTotal").toString());
				 				listTotal.add("Total");
				 				listTotal.add("");
				 				listTotal.add(totalQty);
								listTotal.add(totalAmount);
								listTotal.add(discountTotal);		
								listTotal.add(subTotal);
							break;
						case "MenuHeadWise":
								totalQty1=Double.parseDouble(mapData.get("totalQty").toString());
								totalQty=(int) totalQty1;
				 				totalAmount=Double.parseDouble(mapData.get("totalAmount").toString());
				 				subTotal=Double.parseDouble(mapData.get("subTotal").toString());
				 				discountTotal=Double.parseDouble(mapData.get("discountTotal").toString());
				 				listTotal.add("Total");
				 				listTotal.add("");
								listTotal.add(totalQty);
								listTotal.add(totalAmount);
								listTotal.add(subTotal);
								listTotal.add(discountTotal);
							break;
						case "GroupWise":
								totalQty1=Double.parseDouble(mapData.get("totalQty").toString());
				 				 totalQty=(int) totalQty1;
				 				totalAmount=Double.parseDouble(mapData.get("totalAmount").toString());
				 				subTotal=Double.parseDouble(mapData.get("subTotal").toString());
				 				discountTotal=Double.parseDouble(mapData.get("discountTotal").toString());
				 				listTotal.add("Total");
				 				listTotal.add("");
								listTotal.add(totalQty);
								listTotal.add(totalAmount);
								listTotal.add(subTotal);
								listTotal.add(discountTotal);
							break;
						case "SubGroupWise":
							totalQty1=Double.parseDouble(mapData.get("totalQty").toString());
			 				totalQty=(int) totalQty1;
			 				totalAmount=Double.parseDouble(mapData.get("SalesAmt").toString());
			 				subTotal=Double.parseDouble(mapData.get("subTotal").toString());
			 				discountTotal=Double.parseDouble(mapData.get("discountTotal").toString());
							listTotal.add("Total");
							listTotal.add("");
							listTotal.add(totalQty);
							listTotal.add(totalAmount);
							listTotal.add(subTotal);
							listTotal.add(discountTotal);
							break;
						case "CustWise":
							totalQty1=Double.parseDouble(mapData.get("billCount").toString());
			 				totalQty=(int) totalQty1;
			 				totalAmount=Double.parseDouble(mapData.get("grandTotal").toString());
			 				listTotal.add("Total");
			 				listTotal.add("");
			 				listTotal.add("");
							listTotal.add(totalQty);
							listTotal.add(totalAmount);
							break;
						case "WaiterWise":
			 				totalSale=Double.parseDouble(mapData.get("TotalAmount").toString());
			 				listTotal.add("");
			 				listTotal.add("");
			 				listTotal.add("Total");
			 				listTotal.add(totalSale);
							break;
						case "DeliveryBoyWise":
							totalSale=Double.parseDouble(mapData.get("TotalAmount").toString());
			 				listTotal.add("Total");
			 				listTotal.add("");
			 				listTotal.add(totalSale);
							break;
						case "CostCenterWise":
							totalQty1=Double.parseDouble(mapData.get("totalQty").toString());
			 				totalQty=(int) totalQty1;
			 				totalAmount=Double.parseDouble(mapData.get("totalAmt").toString());
			 				subTotal=Double.parseDouble(mapData.get("subTotal").toString());
			 				discountTotal=Double.parseDouble(mapData.get("discountTotal").toString());
			 				listTotal.add("Total");
			 				listTotal.add("");
			 				listTotal.add(totalQty);
			 				listTotal.add(totalAmount);
			 				listTotal.add(subTotal);			 				
			 				listTotal.add(discountTotal);
							break;
						case "HomeDeliveryWise":
			 				SalesAmount=Double.parseDouble(mapData.get("SalesAmt").toString());
			 				Tax=Double.parseDouble(mapData.get("sumtax").toString());
			 				discountTotal=Double.parseDouble(mapData.get("sumDisc").toString());
			 				listTotal.add("Total");
			 				listTotal.add("");
			 				listTotal.add("");
			 				listTotal.add("");
			 				listTotal.add("");			 				
			 				listTotal.add(discountTotal);
			 				listTotal.add(Tax);
			 				listTotal.add(SalesAmount);
 							break;
						case "TableWise":
			 				SalesAmount=Double.parseDouble(mapData.get("SalesAmt").toString());
			 				listTotal.add("Total");
			 				listTotal.add("");
			 				listTotal.add(SalesAmount);
 							break;
						case "HourlyWise": 	
							TotalNoOfBills=Double.parseDouble(mapData.get("TotalNoOfBills").toString());
							TotalPAX=Double.parseDouble(mapData.get("TotalPax").toString());
							SalesAmount=Double.parseDouble(mapData.get("SalesAmt").toString());
			 				listTotal.add("Total");
			 				listTotal.add(TotalNoOfBills);
			 				listTotal.add(TotalPAX);
			 				listTotal.add(SalesAmount);
			 				break;
						case "AreaWise":
							SalesAmount=Double.parseDouble(mapData.get("SalesAmt").toString());
			 				listTotal.add("Total");
			 				listTotal.add("");
			 				listTotal.add(SalesAmount);
 							break;
						case "DayWiseSales":
							 totalNoOfBills=Integer.parseInt(mapData.get("totalNoOfBills").toString());
		 					 totalAmount=Double.parseDouble(mapData.get("totAmount").toString());
		 					 totalSubTotalDWise=Double.parseDouble(mapData.get("totalSubTotal").toString());
		 					 totalDiscount=Double.parseDouble(mapData.get("totalDiscount").toString());
		 					 totalTaxAmt=Double.parseDouble(mapData.get("totalTaxAmt").toString());
		 					listTotal.add("Total");
			 				listTotal.add(totalNoOfBills);
			 				listTotal.add(totalSubTotalDWise);
			 				listTotal.add(totalDiscount);
			 				listTotal.add(totalTaxAmt);
			 				listTotal.add(totalAmount);
							break;
						case "TaxWiseSales":
							totalTax=Double.parseDouble(mapData.get("totalTax").toString());
		 					totalTaxableAmt=Double.parseDouble(mapData.get("totalTaxableAmt").toString());
		 					listTotal.add("");
		 					listTotal.add("");
		 					listTotal.add("");
		 					listTotal.add("");
		 					listTotal.add("Total");
			 				listTotal.add(totalTaxableAmt);
			 				listTotal.add(totalTax);
							break;
						case "TipReport":
								 SalesAmount=Double.parseDouble(mapData.get("SalesAmount").toString());
			 					 totalSubTotal=Double.parseDouble(mapData.get("subTotal").toString());
			 					 totalDiscount=Double.parseDouble(mapData.get("Disc").toString());
			 					 totalTaxAmt=Double.parseDouble(mapData.get("totalTaxAmt").toString());
			 					 totalTipAmt=Double.parseDouble(mapData.get("tipAmountTotal").toString());
			 					listTotal.add("Total");
			 					listTotal.add(totalDiscount);
				 				listTotal.add(totalSubTotal);
				 				listTotal.add(totalTaxAmt);
				 				listTotal.add(totalTipAmt);
				 				listTotal.add(SalesAmount);
 							break;
						case "ItemModifierWise":
							totalQty1=Double.parseDouble(mapData.get("totalQty").toString());
			 				totalQty=(int) totalQty1;
			 				SalesAmount=Double.parseDouble(mapData.get("totalAmount").toString());
			 				listTotal.add("Total");
			 				listTotal.add("");
			 				listTotal.add(totalQty);
							listTotal.add(SalesAmount);
 							break;
						case "MenuHeadWiseWithModifier":
							totalQty1=Double.parseDouble(mapData.get("totalQty").toString());
			 				totalQty=(int) totalQty1;
			 				SalesAmount=Double.parseDouble(mapData.get("totalAmount").toString());
			 				listTotal.add("Total");
			 				listTotal.add("");
							listTotal.add(totalQty);
							listTotal.add(SalesAmount);
 
							break;
						case "ItemHourlyWise":
							totalQty1=Double.parseDouble(mapData.get("totalQty").toString());							
							totalAmount=Double.parseDouble(mapData.get("totalAmount").toString());
	 						totalDiscount=Double.parseDouble(mapData.get("totalDiscAmount").toString());	 					
							listTotal.add("Total");
							listTotal.add("");
							listTotal.add(totalQty1);
							listTotal.add(totalAmount);
							listTotal.add(totalDiscount);
							break;
						case "OperatorWise":
							totalDisc=Double.parseDouble(mapData.get("totalDisc").toString());
	 						SalesAmount=Double.parseDouble(mapData.get("totalAmount").toString());
	 						listTotal.add("Total");
	 						listTotal.add("");
	 						listTotal.add("");
	 						listTotal.add("");
							listTotal.add(totalDisc);
							listTotal.add(SalesAmount);
							break;
						case "MonthlySalesFlash":
	 						SalesAmount=Double.parseDouble(mapData.get("totalSale").toString());
	 						listTotal.add("Total");
							listTotal.add(SalesAmount);
							break;
							
					}
					for(int i=0; i<rowCount; i++)
				        {
				        	   resMap.put(""+i,(List)mapData.get(""+i));
				        }
					resMap.put("headerList", headerList);
					resMap.put("Header", colHeader);
					resMap.put("ColCount", colCount);
					resMap.put("RowCount", rowCount);
					resMap.put("Total", listTotal);
				
			  }
			  catch(Exception e){
				  e.printStackTrace();
			  }
		
			  
			  return resMap;
		  }
	 	
	 	
	 	
	 	
/*load Settlement wise data*/
	 	@RequestMapping(value = "/loadSettlementWiseSalesReport", method = RequestMethod.POST)
	 	public @ResponseBody List<clsPOSSalesFlashReportsBean> funLoadSettlementWiseSalesReport(@RequestParam("POSName") String strPOSName,@RequestParam("FromDate") String FromDateTime,@RequestParam("ToDate") String ToDateTime,@RequestParam("Operator") String strOperator,
				@RequestParam("PayMode") String strPayMode,@RequestParam("txtFromBillNo") String strFromBill,@RequestParam("txtToBillNo") String strToBill,@RequestParam("txtReportType") String reportType,
				@RequestParam("txtType") String Type,@RequestParam("txtCustomer") String Customer,@RequestParam("chkConsolidatePOS") String ConsolidatePOS,@RequestParam("hidReportName") String ReportName,@RequestParam("areaCode") String areaCode,
				@RequestParam("operationType") String operationType,@RequestParam("gEnableShiftYN") String gEnableShiftYN,@RequestParam("shiftCode") String shiftCode,
				HttpServletResponse resp,HttpServletRequest req)
			{
	 			decimalFormat2= new DecimalFormat("0.00");
				listSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
				listStockFlashModel=new ArrayList();
	 			String clientCode=req.getSession().getAttribute("gClientCode").toString();
	 			String userCode=req.getSession().getAttribute("gUserCode").toString();
	 			String companyName=req.getSession().getAttribute("gCompanyName").toString();
	 			String LoginPOSCode=req.getSession().getAttribute("loginPOS").toString();
	 			
	 			String FromDate="",FromTime="",ToDate="",ToTime="";
	 			
	 			FromDate=FromDateTime.split(":")[0];
	 			FromTime=FromDateTime.split(":")[1];
	 			ToDate=ToDateTime.split(":")[0];
	 			ToTime=ToDateTime.split(":")[1];
	 		
	 			String strFromdate=FromDate.split("-")[2]+"-"+FromDate.split("-")[1]+"-"+FromDate.split("-")[0];
	 			String strToDate=ToDate.split("-")[2]+"-"+ToDate.split("-")[1]+"-"+ToDate.split("-")[0]; 
	 			try
	 			{	 		
		 			
	 				Map mapData = new HashMap();
		 			mapData=funGetReportData(strPOSName,FromDateTime,ToDateTime,strOperator,strPayMode,strFromBill,strToBill,reportType,
		 					Type,Customer,ConsolidatePOS,ReportName,userCode,LoginPOSCode,areaCode,operationType,gEnableShiftYN,shiftCode,clientCode,operationType);
	 				clsPOSSalesFlashReportsBean objBean= new clsPOSSalesFlashReportsBean();
	 				
	 				double totalSale=Double.parseDouble(mapData.get("TotalSale").toString());
	 				objBean.setTotalSubTotal(decimalFormat2.format(totalSale));
	 				listSalesReport.add(objBean);
	        
	 				List<clsPOSSalesFlashReportsBean> tmplistSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
	 				tmplistSalesReport= (List<clsPOSSalesFlashReportsBean>)mapData.get("ListSettlementWiseSales");
	 				clsPOSSalesFlashReportsBean obj;
	 				for(int i=0;i<tmplistSalesReport.size();i++)
	 				{
	 					obj= new clsPOSSalesFlashReportsBean();
	 					List DataList=new ArrayList<>();
	 					obj.setStrField1((tmplistSalesReport.get(i).getStrField1()));
	 					obj.setStrField2(tmplistSalesReport.get(i).getStrField2());
	 					obj.setStrField3(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField3())));
	 					
	 					double saleAmt = Double.parseDouble(tmplistSalesReport.get(i).getStrField3());
                        double salePer = (saleAmt / totalSale) * 100;
	 					obj.setStrField4(String.valueOf(decimalFormat2.format(salePer)));
	 					listSalesReport.add(obj);
	 				}
	 				System.out.print("@controller "+listSalesReport.size());
	        	} 
	 			catch (Exception e) 
	 			{
						e.printStackTrace();
	 			}
	
		return listSalesReport;
	}

	 
	 
	 
	/*load bill wise data*/
	 	@RequestMapping(value = "/loadBillWiseSalesReport", method = RequestMethod.POST)
	 	public @ResponseBody List<clsPOSSalesFlashReportsBean> funGetSalesDetails(@RequestParam("POSName") String strPOSName,@RequestParam("FromDate") String FromDateTime,@RequestParam("ToDate") String ToDateTime,@RequestParam("Operator") String strOperator,
				@RequestParam("PayMode") String strPayMode,@RequestParam("txtFromBillNo") String strFromBill,@RequestParam("txtToBillNo") String strToBill,@RequestParam("txtReportType") String reportType,
				@RequestParam("txtType") String Type,@RequestParam("txtCustomer") String Customer,@RequestParam("chkConsolidatePOS") String ConsolidatePOS,@RequestParam("hidReportName") String ReportName,
				@RequestParam("areaCode") String areaCode,@RequestParam("operationType") String operationType,@RequestParam("gEnableShiftYN") String gEnableShiftYN,@RequestParam("shiftCode") String shiftCode,
				HttpServletResponse resp,HttpServletRequest req)
			{
	 			decimalFormat2 = new DecimalFormat("0.00");
				listSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
	 			String clientCode=req.getSession().getAttribute("gClientCode").toString();
	 			String userCode=req.getSession().getAttribute("gUserCode").toString();
	 			String companyName=req.getSession().getAttribute("gCompanyName").toString();
	 			String LoginPOSCode=req.getSession().getAttribute("loginPOS").toString();
	 		try{
	 				
	 				Map mapData = new HashMap();
		 			mapData=funGetReportData(strPOSName,FromDateTime,ToDateTime,strOperator,strPayMode,strFromBill,strToBill,reportType,
		 					Type,Customer,ConsolidatePOS,ReportName,userCode,LoginPOSCode,areaCode,operationType,gEnableShiftYN,shiftCode,clientCode,operationType);

	 				clsPOSSalesFlashReportsBean objBean= new clsPOSSalesFlashReportsBean();
	 				double totalDiscAmt=0,totalSubTotal=0,totalTaxAmt=0,totalSettleAmt=0,totalTipAmt=0,totalAdvTotal=0,totalRoundOff=0,totalPaxx=0;
	 				totalDiscAmt=Double.parseDouble(mapData.get("totalDiscAmt").toString());
	 				totalSubTotal=Double.parseDouble(mapData.get("totalSubTotal").toString());
	 				totalTaxAmt=Double.parseDouble(mapData.get("totalTaxAmt").toString());
	 				totalSettleAmt=Double.parseDouble(mapData.get("totalSettleAmt").toString());
	 				totalTipAmt=Double.parseDouble(mapData.get("totalTipAmt").toString());
	 				totalAdvTotal+=Double.parseDouble(mapData.get("totalAdvTotal").toString());
					totalRoundOff+=Double.parseDouble(mapData.get("totalRoundOff").toString());
					totalPaxx = Double.parseDouble(mapData.get("totalPaxx").toString());
	 				
	 				
	 				objBean.setTotalDiscAmt(String.valueOf(decimalFormat2.format(totalDiscAmt)));
	 				objBean.setTotalSubTotal(String.valueOf(decimalFormat2.format(totalSubTotal)));
	 				objBean.setTotalTaxAmt(String.valueOf(decimalFormat2.format(totalTaxAmt)));
	 				objBean.setTotalSettleAmt(String.valueOf(decimalFormat2.format(totalSettleAmt)));
	 				objBean.setTotalTipAmt(String.valueOf(decimalFormat2.format(totalTipAmt)));
	 				
	 				objBean.setTotalAdvAmt(String.valueOf(decimalFormat2.format(totalAdvTotal)));
	 				objBean.setTotalRoundOffAmt(String.valueOf(decimalFormat2.format(totalRoundOff)));
	 				objBean.setTotalPAX(String.valueOf(decimalFormat2.format(totalPaxx)));	 				
	 				listSalesReport.add(objBean);
	        
	 				List<clsPOSSalesFlashReportsBean> tmplistSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
	 				tmplistSalesReport = (List<clsPOSSalesFlashReportsBean>)mapData.get("TempListBillWiseSales");
	 				
	 				for(int i=0;i<tmplistSalesReport.size();i++)
	 				{
	 					listSalesReport.add(tmplistSalesReport.get(i));
	 				}
	 				System.out.print("@controller "+listSalesReport.size());
	        
	 			} 
 	 			catch (Exception e) 
	 			{
						e.printStackTrace();
	 			}
	
		return listSalesReport;
	}
	 	
/*load Item wise data*/
	 	@RequestMapping(value = "/loadItemWiseSalesReport", method = RequestMethod.POST)
	 	public @ResponseBody List<clsPOSSalesFlashReportsBean> funLoadItemWiseSalesReport(@RequestParam("POSName") String strPOSName,@RequestParam("FromDate") String FromDateTime,@RequestParam("ToDate") String ToDateTime,@RequestParam("Operator") String strOperator,
				@RequestParam("PayMode") String strPayMode,@RequestParam("txtFromBillNo") String strFromBill,@RequestParam("txtToBillNo") String strToBill,@RequestParam("txtReportType") String reportType,
				@RequestParam("txtType") String Type,@RequestParam("txtCustomer") String Customer,@RequestParam("chkConsolidatePOS") String ConsolidatePOS,@RequestParam("hidReportName") String ReportName
				,@RequestParam("areaCode") String areaCode,@RequestParam("operationType") String operationType,@RequestParam("gEnableShiftYN") String gEnableShiftYN,@RequestParam("shiftCode") String shiftCode,
				HttpServletResponse resp,HttpServletRequest req)
			{
	 			decimalFormat0 = new DecimalFormat("");
	 			decimalFormat1 = new DecimalFormat("0.0");
	 			decimalFormat2 = new DecimalFormat("0.00");
				listSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
				String clientCode=req.getSession().getAttribute("gClientCode").toString();
	 			String userCode=req.getSession().getAttribute("gUserCode").toString();
	 			String companyName=req.getSession().getAttribute("gCompanyName").toString();
	 			String LoginPOSCode=req.getSession().getAttribute("loginPOS").toString();
	 			Map mapData = new HashMap();
	 			mapData=funGetReportData(strPOSName,FromDateTime,ToDateTime,strOperator,strPayMode,strFromBill,strToBill,reportType,
	 					Type,Customer,ConsolidatePOS,ReportName,userCode,LoginPOSCode,areaCode,operationType,gEnableShiftYN,shiftCode,clientCode,operationType);

		 			try {
			 		
	 				//JSONObject mapData = objGlobalFunctions.funPOSTMethodUrlJosnObjectData(clsPOSGlobalFunctionsController.POSWSURL+"/WebPOSReport/funSalesReport",mapDataFillter);
		
	 				clsPOSSalesFlashReportsBean objBean= new clsPOSSalesFlashReportsBean();
	 				//objBean.setTotalSubTotal(mapData.get("TotalSale").toString());
	 							
	 				double totalQty=0, totalAmount=0, subTotal=0, discountTotal=0;
	 				totalQty=Double.parseDouble(mapData.get("totalQty").toString());
	 				//Math.round(totalQty);
	 				totalAmount=Double.parseDouble(mapData.get("totalAmount").toString());
	 				subTotal=Double.parseDouble(mapData.get("subTotal").toString());	 				
	 				discountTotal=Double.parseDouble(mapData.get("discountTotal").toString());	 				
	 				objBean.setTotalQuantity(String.valueOf(decimalFormat0.format(totalQty)));
	 				objBean.setTotalAmount(String.valueOf(decimalFormat2.format(totalAmount)));
	 				objBean.setTotalSubTotal(String.valueOf(decimalFormat2.format(subTotal)));
	 				objBean.setTotalDiscAmt(String.valueOf(decimalFormat2.format(discountTotal)));				
	 				
	 				listSalesReport.add(objBean);
	        	 				
	 				List<clsPOSSalesFlashReportsBean> tmplistSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
	 				tmplistSalesReport = (List<clsPOSSalesFlashReportsBean>)mapData.get("ListItemWiseSales");
	 				clsPOSSalesFlashReportsBean obj;
	 				for(int i=0;i<tmplistSalesReport.size();i++)
	 				{
	 					obj= new clsPOSSalesFlashReportsBean();
	 					obj.setStrField1(tmplistSalesReport.get(i).getStrField1());
	 					obj.setStrField2(tmplistSalesReport.get(i).getStrField2());
	 					obj.setStrField3(tmplistSalesReport.get(i).getStrField3());
	 					obj.setStrField4(tmplistSalesReport.get(i).getStrField4());
	 					obj.setStrField5(tmplistSalesReport.get(i).getStrField5());
	 					obj.setStrField6(tmplistSalesReport.get(i).getStrField6());
	 					
	 					listSalesReport.add(obj);
	 				}
	 				System.out.print("@controller "+listSalesReport.size());
	        	} 
	 			catch (Exception e) 
	 			{
						e.printStackTrace();
	 			}
	
		return listSalesReport;
	}	 	
	 
	 	/*load Menu Head wise data*/
	 	@RequestMapping(value = "/loadMenuHeadWiseSalesReport", method = RequestMethod.POST)
	 	public @ResponseBody List<clsPOSSalesFlashReportsBean> funLoadMenuHeadWiseSalesReport(@RequestParam("POSName") String strPOSName,@RequestParam("FromDate") String FromDateTime,@RequestParam("ToDate") String ToDateTime,@RequestParam("Operator") String strOperator,
				@RequestParam("PayMode") String strPayMode,@RequestParam("txtFromBillNo") String strFromBill,@RequestParam("txtToBillNo") String strToBill,@RequestParam("txtReportType") String reportType,
				@RequestParam("txtType") String Type,@RequestParam("txtCustomer") String Customer,@RequestParam("chkConsolidatePOS") String ConsolidatePOS,@RequestParam("hidReportName") String ReportName
				,@RequestParam("areaCode") String areaCode,@RequestParam("operationType") String operationType,@RequestParam("gEnableShiftYN") String gEnableShiftYN,@RequestParam("shiftCode") String shiftCode,
				HttpServletResponse resp,HttpServletRequest req)
			{
	 			decimalFormat0 = new DecimalFormat("");
	 			decimalFormat2 = new DecimalFormat("0.00");
				listSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
				String clientCode=req.getSession().getAttribute("gClientCode").toString();
	 			String userCode=req.getSession().getAttribute("gUserCode").toString();
	 			String companyName=req.getSession().getAttribute("gCompanyName").toString();
	 			String LoginPOSCode=req.getSession().getAttribute("loginPOS").toString();
	 			Map mapData = new HashMap();
	 			mapData=funGetReportData(strPOSName,FromDateTime,ToDateTime,strOperator,strPayMode,strFromBill,strToBill,reportType,
	 					Type,Customer,ConsolidatePOS,ReportName,userCode,LoginPOSCode,areaCode,operationType,gEnableShiftYN,shiftCode,clientCode,operationType);

		 			try {
		 				
	 				clsPOSSalesFlashReportsBean objBean= new clsPOSSalesFlashReportsBean();
	 				
	 				double totalQty=0,totalAmount=0, subTotal=0, discountTotal=0;
	 				totalQty=Math.round(Double.parseDouble(mapData.get("totalQty").toString()));
	 				totalAmount=Double.parseDouble(mapData.get("totalAmount").toString());
	 				subTotal=Double.parseDouble(mapData.get("subTotal").toString());
	 				discountTotal=Double.parseDouble(mapData.get("discountTotal").toString());
	 				
	 				objBean.setTotalQuantity(String.valueOf(decimalFormat0.format(totalQty)));
	 				objBean.setTotalAmount(String.valueOf(decimalFormat2.format(totalAmount)));
	 				objBean.setTotalSubTotal(String.valueOf(decimalFormat2.format(subTotal)));
	 				objBean.setTotalDiscAmt(String.valueOf(decimalFormat2.format(discountTotal)));
	 				
	 				listSalesReport.add(objBean);
	        
	 				List<clsPOSSalesFlashReportsBean> tmplistSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
	 				tmplistSalesReport = (List<clsPOSSalesFlashReportsBean>)mapData.get("ListMenuHeadWiseSales");
	 				clsPOSSalesFlashReportsBean obj;
	 				for(int i=0;i<tmplistSalesReport.size();i++)
	 				{
	 					obj= new clsPOSSalesFlashReportsBean();
	 					obj.setStrField1(tmplistSalesReport.get(i).getStrField1());
	 					obj.setStrField2(tmplistSalesReport.get(i).getStrField2());
	 					obj.setStrField3(decimalFormat0.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField3())));
	 					obj.setStrField4(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField4())));
	 					obj.setStrField5(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField5())));
	 					obj.setStrField6(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField6())));
	 					
	 					double saleAmt=Double.parseDouble(tmplistSalesReport.get(i).getStrField4());
	 					double salePer = (saleAmt / totalAmount) * 100;
	 					obj.setStrField7(String.valueOf(decimalFormat2.format(salePer)));
	 					listSalesReport.add(obj);
	 				}
	 				System.out.print("@controller "+listSalesReport.size());
	        	} 
	 			catch (Exception e) 
	 			{
						e.printStackTrace();
	 			}
	
		return listSalesReport;
	}
/*load Group wise data*/
	 	@RequestMapping(value = "/loadGroupWiseSalesReport", method = RequestMethod.POST)
	 	public @ResponseBody List<clsPOSSalesFlashReportsBean> funLoadGroupWiseSalesReport(@RequestParam("POSName") String strPOSName,@RequestParam("FromDate") String FromDateTime,@RequestParam("ToDate") String ToDateTime,@RequestParam("Operator") String strOperator,
				@RequestParam("PayMode") String strPayMode,@RequestParam("txtFromBillNo") String strFromBill,@RequestParam("txtToBillNo") String strToBill,@RequestParam("txtReportType") String reportType,
				@RequestParam("txtType") String Type,@RequestParam("txtCustomer") String Customer,@RequestParam("chkConsolidatePOS") String ConsolidatePOS,@RequestParam("hidReportName") String ReportName
				,@RequestParam("areaCode") String areaCode,@RequestParam("operationType") String operationType,@RequestParam("gEnableShiftYN") String gEnableShiftYN,@RequestParam("shiftCode") String shiftCode,
				HttpServletResponse resp,HttpServletRequest req)
			{	
	 			decimalFormat0 = new DecimalFormat("");
	 			decimalFormat2 = new DecimalFormat("0.00");
				listSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
				String clientCode=req.getSession().getAttribute("gClientCode").toString();
	 			String userCode=req.getSession().getAttribute("gUserCode").toString();
	 			String companyName=req.getSession().getAttribute("gCompanyName").toString();
	 			String LoginPOSCode=req.getSession().getAttribute("loginPOS").toString();
	 			Map mapData = new HashMap();
	 			mapData=funGetReportData(strPOSName,FromDateTime,ToDateTime,strOperator,strPayMode,strFromBill,strToBill,reportType,
	 					Type,Customer,ConsolidatePOS,ReportName,userCode,LoginPOSCode,areaCode,operationType,gEnableShiftYN,shiftCode,clientCode,operationType); 			
	 			try 
	 			{
		 			clsPOSSalesFlashReportsBean objBean= new clsPOSSalesFlashReportsBean();		
	 				double totalQty=0,totalAmount=0, subTotal=0, discountTotal=0;
	 				totalQty=Math.round(Double.parseDouble(mapData.get("totalQty").toString()));
	 				totalAmount=Double.parseDouble(mapData.get("totalAmount").toString());
	 				subTotal=Double.parseDouble(mapData.get("subTotal").toString());
	 				discountTotal=Double.parseDouble(mapData.get("discountTotal").toString());
	 				
	 				objBean.setTotalQuantity(String.valueOf(decimalFormat0.format(totalQty)));
	 				objBean.setTotalAmount(String.valueOf(decimalFormat2.format(totalAmount)));
	 				objBean.setTotalSubTotal(String.valueOf(decimalFormat2.format(subTotal)));
	 				objBean.setTotalDiscAmt(String.valueOf(decimalFormat2.format(discountTotal)));
	 				
	 				listSalesReport.add(objBean);
	        
	 				List<clsPOSSalesFlashReportsBean> tmplistSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
	 				tmplistSalesReport = (List<clsPOSSalesFlashReportsBean>)mapData.get("ListGroupWiseSales");
	 				clsPOSSalesFlashReportsBean obj;
	 				for(int i=0;i<tmplistSalesReport.size();i++)
	 				{
	 					obj= new clsPOSSalesFlashReportsBean();
	 					obj.setStrField1(tmplistSalesReport.get(i).getStrField1());
	 					obj.setStrField2(tmplistSalesReport.get(i).getStrField2());
	 					obj.setStrField3(decimalFormat0.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField3())));
	 					obj.setStrField4(tmplistSalesReport.get(i).getStrField4());
	 					obj.setStrField5(tmplistSalesReport.get(i).getStrField5());
	 					obj.setStrField6(tmplistSalesReport.get(i).getStrField6());
	 					
	 					double saleAmt=Double.parseDouble(tmplistSalesReport.get(i).getStrField4());
	 					double salePer = (saleAmt / totalAmount) * 100;
	 					obj.setStrField7(String.valueOf(decimalFormat2.format(salePer)));
	 					listSalesReport.add(obj);
	 				}
	 				System.out.print("@controller "+listSalesReport.size());
	        	} 
	 			catch (Exception e) 
	 			{
						e.printStackTrace();
	 			}
	
		return listSalesReport;
	}
/*load Sub Group wise data*/
	 	@RequestMapping(value = "/loadSubGroupWiseSalesReport", method = RequestMethod.POST)
	 	public @ResponseBody List<clsPOSSalesFlashReportsBean> loadSubGroupWiseSalesReport(@RequestParam("POSName") String strPOSName,@RequestParam("FromDate") String FromDateTime,@RequestParam("ToDate") String ToDateTime,@RequestParam("Operator") String strOperator,
				@RequestParam("PayMode") String strPayMode,@RequestParam("txtFromBillNo") String strFromBill,@RequestParam("txtToBillNo") String strToBill,@RequestParam("txtReportType") String reportType,
				@RequestParam("txtType") String Type,@RequestParam("txtCustomer") String Customer,@RequestParam("chkConsolidatePOS") String ConsolidatePOS,@RequestParam("hidReportName") String ReportName
				,@RequestParam("areaCode") String areaCode,@RequestParam("operationType") String operationType,@RequestParam("gEnableShiftYN") String gEnableShiftYN,@RequestParam("shiftCode") String shiftCode,
				HttpServletResponse resp,HttpServletRequest req)
			{
	 			decimalFormat0 = new DecimalFormat("");
	 			decimalFormat2 = new DecimalFormat("0.00");
				listSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
				String clientCode=req.getSession().getAttribute("gClientCode").toString();
	 			String userCode=req.getSession().getAttribute("gUserCode").toString();
	 			String companyName=req.getSession().getAttribute("gCompanyName").toString();
	 			String LoginPOSCode=req.getSession().getAttribute("loginPOS").toString();
	 			
	 			Map mapData = new HashMap();
	 			mapData=funGetReportData(strPOSName,FromDateTime,ToDateTime,strOperator,strPayMode,strFromBill,strToBill,reportType,
	 					Type,Customer,ConsolidatePOS,ReportName,userCode,LoginPOSCode,areaCode,operationType,gEnableShiftYN,shiftCode,clientCode,operationType);

		 			try {
		 				
	 				//JSONObject mapData = objGlobalFunctions.funPOSTMethodUrlJosnObjectData(clsPOSGlobalFunctionsController.POSWSURL+"/WebPOSReport/funSalesReport",mapDataFillter);
		
	 				clsPOSSalesFlashReportsBean objBean= new clsPOSSalesFlashReportsBean();
	 				//objBean.setTotalSubTotal(mapData.get("TotalSale").toString());
	 				
	 				double totalQty=0,totalAmount=0, subTotal=0, discountTotal=0;
	 				totalQty=Math.round(Double.parseDouble(mapData.get("totalQty").toString()));
	 				//int totalQty1=(int) totalQty;
	 				totalAmount=Double.parseDouble(mapData.get("SalesAmt").toString());
	 				subTotal=Double.parseDouble(mapData.get("subTotal").toString());
	 				discountTotal=Double.parseDouble(mapData.get("discountTotal").toString());
	 				
	 				objBean.setTotalQuantity(String.valueOf(decimalFormat0.format(totalQty)));
	 				objBean.setTotalAmount(String.valueOf(decimalFormat2.format(totalAmount)));
	 				objBean.setTotalSubTotal(String.valueOf(decimalFormat2.format(subTotal)));
	 				objBean.setTotalDiscAmt(String.valueOf(decimalFormat2.format(discountTotal)));
	 				
	 				listSalesReport.add(objBean);
	        
	 				List<clsPOSSalesFlashReportsBean> tmplistSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
	 				tmplistSalesReport = (List<clsPOSSalesFlashReportsBean>)mapData.get("ListSubGroupWiseSales");
	 				clsPOSSalesFlashReportsBean obj;
	 				for(int i=0;i<tmplistSalesReport.size();i++)
	 				{
	 					obj= new clsPOSSalesFlashReportsBean();
	 					obj.setStrField1(tmplistSalesReport.get(i).getStrField1());
	 					obj.setStrField2(tmplistSalesReport.get(i).getStrField2());
	 					obj.setStrField3(decimalFormat0.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField3())));
	 					obj.setStrField4(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField4())));
	 					obj.setStrField5(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField5())));
	 					obj.setStrField6(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField6())));
	 					
	 					double saleAmt=Double.parseDouble(tmplistSalesReport.get(i).getStrField5());
	 					double salePer = (saleAmt / subTotal) * 100;
	 					obj.setStrField7(String.valueOf(decimalFormat2.format(salePer)));
	 					listSalesReport.add(obj);
	 				}
	 				System.out.print("@controller "+listSalesReport.size());
	        	} 
	 			catch (Exception e) 
	 			{
						e.printStackTrace();
	 			}
	
		return listSalesReport;
	}	 	
/*load Customer wise data*/
	 	@RequestMapping(value = "/loadCustWiseSalesReport", method = RequestMethod.POST)
	 	public @ResponseBody List<clsPOSSalesFlashReportsBean> funLoadCustWiseSalesReport(@RequestParam("POSName") String strPOSName,@RequestParam("FromDate") String FromDateTime,@RequestParam("ToDate") String ToDateTime,@RequestParam("Operator") String strOperator,
				@RequestParam("PayMode") String strPayMode,@RequestParam("txtFromBillNo") String strFromBill,@RequestParam("txtToBillNo") String strToBill,@RequestParam("txtReportType") String reportType,
				@RequestParam("txtType") String Type,@RequestParam("txtCustomer") String Customer,@RequestParam("chkConsolidatePOS") String ConsolidatePOS,@RequestParam("hidReportName") String ReportName
				,@RequestParam("areaCode") String areaCode,@RequestParam("operationType") String operationType,@RequestParam("gEnableShiftYN") String gEnableShiftYN,@RequestParam("shiftCode") String shiftCode,
				HttpServletResponse resp,HttpServletRequest req)
			{
	 			decimalFormat0 = new DecimalFormat("");
	 			decimalFormat2 = new DecimalFormat("0.00");
				listSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
				String clientCode=req.getSession().getAttribute("gClientCode").toString();
	 			String userCode=req.getSession().getAttribute("gUserCode").toString();
	 			String companyName=req.getSession().getAttribute("gCompanyName").toString();
	 			String LoginPOSCode=req.getSession().getAttribute("loginPOS").toString();
	 			
	 			Map mapData = new HashMap();
	 			mapData=funGetReportData(strPOSName,FromDateTime,ToDateTime,strOperator,strPayMode,strFromBill,strToBill,reportType,
	 					Type,Customer,ConsolidatePOS,ReportName,userCode,LoginPOSCode,areaCode,operationType,gEnableShiftYN,shiftCode,clientCode,operationType);

		 			try {
		 				
	 				
	 				clsPOSSalesFlashReportsBean objBean= new clsPOSSalesFlashReportsBean();
	 				
	 				double totalQty=0,totalAmount=0, subTotal=0, discountTotal=0;
	 				totalQty=Double.parseDouble(mapData.get("billCount").toString());
	 				//int totalQty=(int) totalQty1;
	 				totalAmount=Double.parseDouble(mapData.get("grandTotal").toString());
	 				
	 				objBean.setTotalQuantity(decimalFormat0.format(totalQty));
	 				objBean.setTotalAmount(decimalFormat2.format(totalAmount));
	 			
	 				listSalesReport.add(objBean);
	        
	 				List<clsPOSSalesFlashReportsBean> tmplistSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
	 				tmplistSalesReport = (List<clsPOSSalesFlashReportsBean>)mapData.get("ListCustWiseSales");
	 				clsPOSSalesFlashReportsBean obj;
	 				for(int i=0;i<tmplistSalesReport.size();i++)
	 				{
	 					obj= new clsPOSSalesFlashReportsBean();
	 					obj.setStrField1(tmplistSalesReport.get(i).getStrField1());
	 					obj.setStrField2(tmplistSalesReport.get(i).getStrField2());
	 					obj.setStrField3(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField3())));
	 					obj.setMobileNo(tmplistSalesReport.get(i).getMobileNo());
	 					obj.setDob(tmplistSalesReport.get(i).getDob());
	 	
	 					listSalesReport.add(obj);
	 				}
	 				System.out.print("@controller "+listSalesReport.size());
	        	} 
	 			catch (Exception e) 
	 			{
						e.printStackTrace();
	 			}
		 
	
		return listSalesReport;
	}	 
/*load Waiter wise data*/
	 	@RequestMapping(value = "/loadWaiterWiseSalesReport", method = RequestMethod.POST)
	 	public @ResponseBody List<clsPOSSalesFlashReportsBean> funLoadWaiterWiseSalesReport(@RequestParam("POSName") String strPOSName,@RequestParam("FromDate") String FromDateTime,@RequestParam("ToDate") String ToDateTime,@RequestParam("Operator") String strOperator,
				@RequestParam("PayMode") String strPayMode,@RequestParam("txtFromBillNo") String strFromBill,@RequestParam("txtToBillNo") String strToBill,@RequestParam("txtReportType") String reportType,
				@RequestParam("txtType") String Type,@RequestParam("txtCustomer") String Customer,@RequestParam("chkConsolidatePOS") String ConsolidatePOS,@RequestParam("hidReportName") String ReportName
				,@RequestParam("areaCode") String areaCode,@RequestParam("operationType") String operationType,@RequestParam("gEnableShiftYN") String gEnableShiftYN,@RequestParam("shiftCode") String shiftCode,
				HttpServletResponse resp,HttpServletRequest req)
			{
	 	    	decimalFormat0 = new DecimalFormat("0");
	 			decimalFormat1 = new DecimalFormat("0.0");
	 			decimalFormat2 = new DecimalFormat("0.00");
				listSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
				String clientCode=req.getSession().getAttribute("gClientCode").toString();
	 			String userCode=req.getSession().getAttribute("gUserCode").toString();
	 			String companyName=req.getSession().getAttribute("gCompanyName").toString();
	 			String LoginPOSCode=req.getSession().getAttribute("loginPOS").toString();
	 			
	 			String FromDate="",FromTime="",ToDate="",ToTime="";
	 			
	 			FromDate=FromDateTime.split(":")[0];
	 			FromTime=FromDateTime.split(":")[1];
	 			ToDate=ToDateTime.split(":")[0];
	 			ToTime=ToDateTime.split(":")[1];
	 		
	 			String strFromdate=FromDate.split("-")[2]+"-"+FromDate.split("-")[1]+"-"+FromDate.split("-")[0];
	 			String strToDate=ToDate.split("-")[2]+"-"+ToDate.split("-")[1]+"-"+ToDate.split("-")[0]; 
	 			try
	 			{	 				
	 				Map mapData = new HashMap();
		 			mapData=funGetReportData(strPOSName,FromDateTime,ToDateTime,strOperator,strPayMode,strFromBill,strToBill,reportType,
		 					Type,Customer,ConsolidatePOS,ReportName,userCode,LoginPOSCode,areaCode,operationType,gEnableShiftYN,shiftCode,clientCode,operationType);

	 				clsPOSSalesFlashReportsBean objBean= new clsPOSSalesFlashReportsBean();
	 				
	 				double totalSale=0;
	 				totalSale=Double.parseDouble(mapData.get("TotalAmount").toString());
	 				
	 				objBean.setTotalSubTotal(String.valueOf(decimalFormat2.format(totalSale)));
	 				listSalesReport.add(objBean);
	        
	 				List<clsPOSSalesFlashReportsBean> tmplistSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
	 				tmplistSalesReport = (List<clsPOSSalesFlashReportsBean>)mapData.get("ListWaiterWiseSales");
	 				clsPOSSalesFlashReportsBean obj;
	 				for(int i=0;i<tmplistSalesReport.size();i++)
	 				{
	 					obj= new clsPOSSalesFlashReportsBean();
	 					obj.setStrField1(tmplistSalesReport.get(i).getStrField1());
	 					obj.setStrField2(tmplistSalesReport.get(i).getStrField2());
	 					obj.setStrField3(tmplistSalesReport.get(i).getStrField3());
	 					obj.setStrField4(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField4())));
	 					obj.setNoOfBills(decimalFormat0.format(Double.parseDouble(tmplistSalesReport.get(i).getNoOfBills())));
	 					listSalesReport.add(obj);
	 				}
	 				System.out.print("@controller "+listSalesReport.size());
	        	} 
	 			catch (Exception e) 
	 			{
						e.printStackTrace();
	 			}
	
	 			System.out.println("------------------");
	 			System.out.println(listSalesReport);
	 			
		return listSalesReport;
		
		
	}
	 
/*load DeliveryBoy wise data*/
	 	@RequestMapping(value = "/loadDeliveryBoyWiseSalesReport", method = RequestMethod.POST)
	 	public @ResponseBody List<clsPOSSalesFlashReportsBean> funLoadDeliveryBoyWiseSalesReport(@RequestParam("POSName") String strPOSName,@RequestParam("FromDate") String FromDateTime,@RequestParam("ToDate") String ToDateTime,@RequestParam("Operator") String strOperator,
				@RequestParam("PayMode") String strPayMode,@RequestParam("txtFromBillNo") String strFromBill,@RequestParam("txtToBillNo") String strToBill,@RequestParam("txtReportType") String reportType,
				@RequestParam("txtType") String Type,@RequestParam("txtCustomer") String Customer,@RequestParam("chkConsolidatePOS") String ConsolidatePOS,@RequestParam("hidReportName") String ReportName
				,@RequestParam("areaCode") String areaCode,@RequestParam("operationType") String operationType,@RequestParam("gEnableShiftYN") String gEnableShiftYN,@RequestParam("shiftCode") String shiftCode,
				HttpServletResponse resp,HttpServletRequest req)
			{
	 			decimalFormat2 = new DecimalFormat("0.00");
				listSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
				String clientCode=req.getSession().getAttribute("gClientCode").toString();
	 			String userCode=req.getSession().getAttribute("gUserCode").toString();
	 			String companyName=req.getSession().getAttribute("gCompanyName").toString();
	 			String LoginPOSCode=req.getSession().getAttribute("loginPOS").toString();
	 			
	 			String FromDate="",FromTime="",ToDate="",ToTime="";
	 			
	 			FromDate=FromDateTime.split(":")[0];
	 			FromTime=FromDateTime.split(":")[1];
	 			ToDate=ToDateTime.split(":")[0];
	 			ToTime=ToDateTime.split(":")[1];
	 		
	 			String strFromdate=FromDate.split("-")[2]+"-"+FromDate.split("-")[1]+"-"+FromDate.split("-")[0];
	 			String strToDate=ToDate.split("-")[2]+"-"+ToDate.split("-")[1]+"-"+ToDate.split("-")[0]; 
	 			try
	 			{	 				
	 				Map mapData = new HashMap();
		 			mapData=funGetReportData(strPOSName,FromDateTime,ToDateTime,strOperator,strPayMode,strFromBill,strToBill,reportType,
		 					Type,Customer,ConsolidatePOS,ReportName,userCode,LoginPOSCode,areaCode,operationType,gEnableShiftYN,shiftCode,clientCode,operationType);

	 			    clsPOSSalesFlashReportsBean objBean= new clsPOSSalesFlashReportsBean();
	 				
	 				double totalSale=0;
	 				totalSale=Double.parseDouble(mapData.get("TotalAmount").toString());
	 				
	 				objBean.setTotalSubTotal(String.valueOf(decimalFormat2.format(totalSale)));
	 				listSalesReport.add(objBean);
	        
	 				List<clsPOSSalesFlashReportsBean> tmplistSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
	 				tmplistSalesReport = (List<clsPOSSalesFlashReportsBean>)mapData.get("ListDelBoyWiseSales");
	 				clsPOSSalesFlashReportsBean obj;
	 				for(int i=0;i<tmplistSalesReport.size();i++)
	 				{
	 					obj= new clsPOSSalesFlashReportsBean();
	 					obj.setStrField1(tmplistSalesReport.get(i).getStrField1());
	 					obj.setStrField2(tmplistSalesReport.get(i).getStrField2());
	 					obj.setStrField3(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField3())));
	 					obj.setStrField4(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField4())));
	 					listSalesReport.add(obj);
	 				}
	 				System.out.print("@controller "+listSalesReport.size());
	        	} 
	 			catch (Exception e) 
	 			{
						e.printStackTrace();
	 			}
	
		return listSalesReport;
	}
	 
	 	
/*load Cost Center wise data*/
	 	@RequestMapping(value = "/loadCostCenterWiseSalesReport", method = RequestMethod.POST)
	 	public @ResponseBody List<clsPOSSalesFlashReportsBean> funLoadCostCenterWiseSalesReport(@RequestParam("POSName") String strPOSName,@RequestParam("FromDate") String FromDateTime,@RequestParam("ToDate") String ToDateTime,@RequestParam("Operator") String strOperator,
				@RequestParam("PayMode") String strPayMode,@RequestParam("txtFromBillNo") String strFromBill,@RequestParam("txtToBillNo") String strToBill,@RequestParam("txtReportType") String reportType,
				@RequestParam("txtType") String Type,@RequestParam("txtCustomer") String Customer,@RequestParam("chkConsolidatePOS") String ConsolidatePOS,@RequestParam("hidReportName") String ReportName
				,@RequestParam("areaCode") String areaCode,@RequestParam("operationType") String operationType,@RequestParam("gEnableShiftYN") String gEnableShiftYN,@RequestParam("shiftCode") String shiftCode,
				HttpServletResponse resp,HttpServletRequest req)
			{
	 			decimalFormat0 = new DecimalFormat("");
	 			decimalFormat2 = new DecimalFormat("0.00");
				listSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
				String clientCode=req.getSession().getAttribute("gClientCode").toString();
	 			String userCode=req.getSession().getAttribute("gUserCode").toString();
	 			String companyName=req.getSession().getAttribute("gCompanyName").toString();
	 			String LoginPOSCode=req.getSession().getAttribute("loginPOS").toString();
	 			
	 			String FromDate="",FromTime="",ToDate="",ToTime="";
	 			
	 			FromDate=FromDateTime.split(":")[0];
	 			FromTime=FromDateTime.split(":")[1];
	 			ToDate=ToDateTime.split(":")[0];
	 			ToTime=ToDateTime.split(":")[1];
	 		
	 			String strFromdate=FromDate.split("-")[2]+"-"+FromDate.split("-")[1]+"-"+FromDate.split("-")[0];
	 			String strToDate=ToDate.split("-")[2]+"-"+ToDate.split("-")[1]+"-"+ToDate.split("-")[0]; 
	 			try
	 			{	 				
	 				Map mapData = new HashMap();
		 			mapData=funGetReportData(strPOSName,FromDateTime,ToDateTime,strOperator,strPayMode,strFromBill,strToBill,reportType,
		 					Type,Customer,ConsolidatePOS,ReportName,userCode,LoginPOSCode,areaCode,operationType,gEnableShiftYN,shiftCode,clientCode,operationType);
	
	 				clsPOSSalesFlashReportsBean objBean= new clsPOSSalesFlashReportsBean();
	 				double totalQty1=0,totalAmount=0, subTotal=0, discountTotal=0;
	 				totalQty1=Math.round(Double.parseDouble(mapData.get("totalQty").toString()));
	 				int totalQty=(int) totalQty1;
	 				totalAmount=Double.parseDouble(mapData.get("totalAmt").toString());
	 				subTotal=Double.parseDouble(mapData.get("subTotal").toString());
	 				discountTotal=Double.parseDouble(mapData.get("discountTotal").toString());
	 				
	 				objBean.setTotalQuantity(String.valueOf(decimalFormat0.format(totalQty)));
	 				objBean.setTotalAmount(String.valueOf(decimalFormat2.format(totalAmount)));
	 				objBean.setTotalSubTotal(String.valueOf(decimalFormat2.format(subTotal)));
	 				objBean.setTotalDiscAmt(String.valueOf(decimalFormat2.format(discountTotal)));
	 				listSalesReport.add(objBean);
	        
	 				List<clsPOSSalesFlashReportsBean> tmplistSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
	 				tmplistSalesReport = (List<clsPOSSalesFlashReportsBean>)mapData.get("ListCostCentWiseSales");
	 				clsPOSSalesFlashReportsBean obj;
	 				for(int i=0;i<tmplistSalesReport.size();i++)
	 				{
	 					obj= new clsPOSSalesFlashReportsBean();
	 					obj.setStrField1(tmplistSalesReport.get(i).getStrField1());
	 					obj.setStrField2(tmplistSalesReport.get(i).getStrField2());
	 					obj.setStrField3(decimalFormat0.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField3())));
	 					obj.setStrField4(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField4())));
	 					obj.setStrField5(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField5())));
		 				obj.setStrField6(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField6())));
		 				
		 				double saleAmt=Double.parseDouble(tmplistSalesReport.get(i).getStrField4());
	 					double salePer = (saleAmt / totalAmount) * 100;
	 					obj.setStrField7(String.valueOf(decimalFormat2.format(salePer)));
	 					listSalesReport.add(obj);
	 					
	 				}
	 				System.out.print("@controller "+listSalesReport.size());
	        	} 
	 			catch (Exception e) 
	 			{
						e.printStackTrace();
	 			}
	
		return listSalesReport;
	}
	
/*load Home Delivery wise data*/
	 	@RequestMapping(value = "/loadHomeDelWiseSalesReport", method = RequestMethod.POST)
	 	public @ResponseBody List<clsPOSSalesFlashReportsBean> funLoadHomeDeliveryWiseSalesReport(@RequestParam("POSName") String strPOSName,@RequestParam("FromDate") String FromDateTime,@RequestParam("ToDate") String ToDateTime,@RequestParam("Operator") String strOperator,
				@RequestParam("PayMode") String strPayMode,@RequestParam("txtFromBillNo") String strFromBill,@RequestParam("txtToBillNo") String strToBill,@RequestParam("txtReportType") String reportType,
				@RequestParam("txtType") String Type,@RequestParam("txtCustomer") String Customer,@RequestParam("chkConsolidatePOS") String ConsolidatePOS,@RequestParam("hidReportName") String ReportName
				,@RequestParam("areaCode") String areaCode,@RequestParam("operationType") String operationType,@RequestParam("gEnableShiftYN") String gEnableShiftYN,@RequestParam("shiftCode") String shiftCode,
				HttpServletResponse resp,HttpServletRequest req)
			 {
	 			decimalFormat2 = new DecimalFormat("0.00");
				listSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
				String clientCode=req.getSession().getAttribute("gClientCode").toString();
	 			String userCode=req.getSession().getAttribute("gUserCode").toString();
	 			String companyName=req.getSession().getAttribute("gCompanyName").toString();
	 			String LoginPOSCode=req.getSession().getAttribute("loginPOS").toString();
	 			
	 			String FromDate="",FromTime="",ToDate="",ToTime="";
	 			
	 			FromDate=FromDateTime.split(":")[0];
	 			FromTime=FromDateTime.split(":")[1];
	 			ToDate=ToDateTime.split(":")[0];
	 			ToTime=ToDateTime.split(":")[1];
	 		
	 			String strFromdate=FromDate.split("-")[2]+"-"+FromDate.split("-")[1]+"-"+FromDate.split("-")[0];
	 			String strToDate=ToDate.split("-")[2]+"-"+ToDate.split("-")[1]+"-"+ToDate.split("-")[0]; 
	 			try
	 			{	 				
	 				Map mapData = new HashMap();
		 			mapData=funGetReportData(strPOSName,FromDateTime,ToDateTime,strOperator,strPayMode,strFromBill,strToBill,reportType,
		 					Type,Customer,ConsolidatePOS,ReportName,userCode,LoginPOSCode,areaCode,operationType,gEnableShiftYN,shiftCode,clientCode,operationType);

	 				clsPOSSalesFlashReportsBean objBean= new clsPOSSalesFlashReportsBean();
	 				double SalesAmount=0, Tax=0, discountTotal=0;
	 				
	 				SalesAmount=Double.parseDouble(mapData.get("SalesAmt").toString());
	 				Tax=Double.parseDouble(mapData.get("sumtax").toString());
	 				discountTotal=Double.parseDouble(mapData.get("sumDisc").toString());
	 				
	 				objBean.setTotalAmount(String.valueOf(decimalFormat2.format(SalesAmount)));
	 				objBean.setTotalSubTotal(String.valueOf(decimalFormat2.format(Tax)));//for Tax
	 				objBean.setTotalDiscAmt(String.valueOf(decimalFormat2.format(discountTotal)));
	 				listSalesReport.add(objBean);
	        
	 				List<clsPOSSalesFlashReportsBean> tmplistSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
	 				tmplistSalesReport = (List<clsPOSSalesFlashReportsBean>)mapData.get("ListHomeDelWiseSales");
	 				clsPOSSalesFlashReportsBean obj;
	 				for(int i=0;i<tmplistSalesReport.size();i++)
	 				{
	 					obj= new clsPOSSalesFlashReportsBean();
	 					obj.setStrField1(tmplistSalesReport.get(i).getStrField1());
	 					obj.setStrField2(tmplistSalesReport.get(i).getStrField2());
	 					obj.setStrField3(tmplistSalesReport.get(i).getStrField3());
	 					obj.setStrField4(tmplistSalesReport.get(i).getStrField4());
	 					obj.setStrField5(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField5())));
		 				obj.setStrField6(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField6())));
		 				obj.setStrField7(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField7())));
	 					obj.setStrField8(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField8())));
	 					obj.setStrField9(tmplistSalesReport.get(i).getStrField9());
	 					obj.setStrField10(tmplistSalesReport.get(i).getStrField10());
	 					obj.setStrField11(tmplistSalesReport.get(i).getStrField11());
		 				listSalesReport.add(obj);
	 					
	 				}
	 				System.out.print("@controller "+listSalesReport.size());
	        	} 
	 			catch (Exception e) 
	 			{
						e.printStackTrace();
	 			}
	
		return listSalesReport;
	}
	
/*load Table wise data*/
	 	@RequestMapping(value = "/loadTableWiseSalesReport", method = RequestMethod.POST)
	 	public @ResponseBody List<clsPOSSalesFlashReportsBean> funLoadTableWiseSalesReport(@RequestParam("POSName") String strPOSName,@RequestParam("FromDate") String FromDateTime,@RequestParam("ToDate") String ToDateTime,@RequestParam("Operator") String strOperator,
				@RequestParam("PayMode") String strPayMode,@RequestParam("txtFromBillNo") String strFromBill,@RequestParam("txtToBillNo") String strToBill,@RequestParam("txtReportType") String reportType,
				@RequestParam("txtType") String Type,@RequestParam("txtCustomer") String Customer,@RequestParam("chkConsolidatePOS") String ConsolidatePOS,@RequestParam("hidReportName") String ReportName
				,@RequestParam("areaCode") String areaCode,@RequestParam("operationType") String operationType,@RequestParam("gEnableShiftYN") String gEnableShiftYN,@RequestParam("shiftCode") String shiftCode,
				HttpServletResponse resp,HttpServletRequest req)
			{
	 			decimalFormat2 = new DecimalFormat("0.00");
				listSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
				String clientCode=req.getSession().getAttribute("gClientCode").toString();
	 			String userCode=req.getSession().getAttribute("gUserCode").toString();
	 			String companyName=req.getSession().getAttribute("gCompanyName").toString();
	 			String LoginPOSCode=req.getSession().getAttribute("loginPOS").toString();
	 			
	 			String FromDate="",FromTime="",ToDate="",ToTime="";
	 			
	 			FromDate=FromDateTime.split(":")[0];
	 			FromTime=FromDateTime.split(":")[1];
	 			ToDate=ToDateTime.split(":")[0];
	 			ToTime=ToDateTime.split(":")[1];
	 		
	 			String strFromdate=FromDate.split("-")[2]+"-"+FromDate.split("-")[1]+"-"+FromDate.split("-")[0];
	 			String strToDate=ToDate.split("-")[2]+"-"+ToDate.split("-")[1]+"-"+ToDate.split("-")[0]; 
	 			try
	 			{	 				
	 				Map mapData = new HashMap();
		 			mapData=funGetReportData(strPOSName,FromDateTime,ToDateTime,strOperator,strPayMode,strFromBill,strToBill,reportType,
		 					Type,Customer,ConsolidatePOS,ReportName,userCode,LoginPOSCode,areaCode,operationType,gEnableShiftYN,shiftCode,clientCode,operationType);

	 				clsPOSSalesFlashReportsBean objBean= new clsPOSSalesFlashReportsBean();
	 				double SalesAmount=0;
	 				
	 				SalesAmount=Double.parseDouble(mapData.get("SalesAmt").toString());
	 			
	 				objBean.setTotalAmount(String.valueOf(decimalFormat2.format(SalesAmount)));
	 				listSalesReport.add(objBean);
	        
	 				List<clsPOSSalesFlashReportsBean> tmplistSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
	 				tmplistSalesReport = (List<clsPOSSalesFlashReportsBean>)mapData.get("ListTableWiseSales");
	 				clsPOSSalesFlashReportsBean obj;
	 				for(int i=0;i<tmplistSalesReport.size();i++)
	 				{
	 					obj= new clsPOSSalesFlashReportsBean();
	 					obj.setStrField1(tmplistSalesReport.get(i).getStrField1());
	 					obj.setStrField2(tmplistSalesReport.get(i).getStrField2());
	 					obj.setStrField3(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField3())));
	 					listSalesReport.add(obj);
	 					
	 				}
	 				System.out.print("@controller "+listSalesReport.size());
	        	} 
	 			catch (Exception e) 
	 			{
						e.printStackTrace();
	 			}
	
		return listSalesReport;
	}
	
/*load Hourly Head wise data*/
	 	@RequestMapping(value = "/loadHourlyWiseSalesReport", method = RequestMethod.POST)
	 	public @ResponseBody List<clsPOSSalesFlashReportsBean> funLoadHourlyWiseSalesReport(@RequestParam("POSName") String strPOSName,@RequestParam("FromDate") String FromDateTime,@RequestParam("ToDate") String ToDateTime,@RequestParam("Operator") String strOperator,
				@RequestParam("PayMode") String strPayMode,@RequestParam("txtFromBillNo") String strFromBill,@RequestParam("txtToBillNo") String strToBill,@RequestParam("txtReportType") String reportType,
				@RequestParam("txtType") String Type,@RequestParam("txtCustomer") String Customer,@RequestParam("chkConsolidatePOS") String ConsolidatePOS,@RequestParam("hidReportName") String ReportName
				,@RequestParam("areaCode") String areaCode,@RequestParam("operationType") String operationType,@RequestParam("gEnableShiftYN") String gEnableShiftYN,@RequestParam("shiftCode") String shiftCode,
				HttpServletResponse resp,HttpServletRequest req)
			{
	 			decimalFormat0 = new DecimalFormat("0");
 				decimalFormat2 = new DecimalFormat("0.00");
				listSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
				String clientCode=req.getSession().getAttribute("gClientCode").toString();
	 			String userCode=req.getSession().getAttribute("gUserCode").toString();
	 			String companyName=req.getSession().getAttribute("gCompanyName").toString();
	 			String LoginPOSCode=req.getSession().getAttribute("loginPOS").toString();
	 			
	 			Map mapData = new HashMap();
	 			mapData=funGetReportData(strPOSName,FromDateTime,ToDateTime,strOperator,strPayMode,strFromBill,strToBill,reportType,
	 					Type,Customer,ConsolidatePOS,ReportName,userCode,LoginPOSCode,areaCode,operationType,gEnableShiftYN,shiftCode,clientCode,operationType);

		 			try 
		 			{
	 				clsPOSSalesFlashReportsBean objBean= new clsPOSSalesFlashReportsBean();
	 				double SalesAmount=0,TotalNoOfBills=0,TotalPax=0;
	 				
	 				TotalNoOfBills=Double.parseDouble(mapData.get("TotalNoOfBills").toString());
	 				TotalPax=Double.parseDouble(mapData.get("TotalPax").toString());
	 				SalesAmount=Double.parseDouble(mapData.get("SalesAmt").toString());
	 				objBean.setNoOfBills(String.valueOf(decimalFormat0.format(TotalNoOfBills)));
	 				objBean.setTotalPAX(String.valueOf(decimalFormat0.format(TotalPax)));
	 				objBean.setTotalAmount(String.valueOf(decimalFormat2.format(SalesAmount)));
	 				listSalesReport.add(objBean);
	        
	 				List<clsPOSSalesFlashReportsBean> tmplistSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
	 				tmplistSalesReport = (List<clsPOSSalesFlashReportsBean>)mapData.get("ListHourWiseSales");
	 				clsPOSSalesFlashReportsBean obj;
	 				for(int i=0;i<tmplistSalesReport.size();i++)
	 				{
	 					obj= new clsPOSSalesFlashReportsBean();
	 					obj.setStrField1(tmplistSalesReport.get(i).getStrField1().substring(0,5));
	 					obj.setStrField2(decimalFormat0.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField2())));
	 					obj.setStrField3(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField3())));
	 					obj.setStrField5(tmplistSalesReport.get(i).getStrField5());	 					
	 					
	 					double saleAmt=Double.parseDouble(tmplistSalesReport.get(i).getStrField3());
	 					double salePer = (saleAmt / SalesAmount) * 100;
	 					obj.setStrField4(String.valueOf(decimalFormat2.format(salePer)));
	 					listSalesReport.add(obj);
	 				}
	 				System.out.print("@controller "+listSalesReport.size());
	        	} 
	 			catch (Exception e) 
	 			{
						e.printStackTrace();
	 			}
	
		return listSalesReport;
	}
	 	
/*load Area  wise data*/
	 	@RequestMapping(value = "/loadAreaWiseSalesReport", method = RequestMethod.POST)
	 	public @ResponseBody List<clsPOSSalesFlashReportsBean> funLoadAreaWiseSalesReport(@RequestParam("POSName") String strPOSName,@RequestParam("FromDate") String FromDateTime,@RequestParam("ToDate") String ToDateTime,@RequestParam("Operator") String strOperator,
				@RequestParam("PayMode") String strPayMode,@RequestParam("txtFromBillNo") String strFromBill,@RequestParam("txtToBillNo") String strToBill,@RequestParam("txtReportType") String reportType,
				@RequestParam("txtType") String Type,@RequestParam("txtCustomer") String Customer,@RequestParam("chkConsolidatePOS") String ConsolidatePOS,@RequestParam("hidReportName") String ReportName
				,@RequestParam("areaCode") String areaCode,@RequestParam("operationType") String operationType,@RequestParam("gEnableShiftYN") String gEnableShiftYN,@RequestParam("shiftCode") String shiftCode,
				HttpServletResponse resp,HttpServletRequest req)
			{
 				decimalFormat2 = new DecimalFormat("0.00");
				listSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
				String clientCode=req.getSession().getAttribute("gClientCode").toString();
	 			String userCode=req.getSession().getAttribute("gUserCode").toString();
	 			String companyName=req.getSession().getAttribute("gCompanyName").toString();
	 			String LoginPOSCode=req.getSession().getAttribute("loginPOS").toString();
	 			
	 			Map mapData = new HashMap();
	 			mapData=funGetReportData(strPOSName,FromDateTime,ToDateTime,strOperator,strPayMode,strFromBill,strToBill,reportType,
	 					Type,Customer,ConsolidatePOS,ReportName,userCode,LoginPOSCode,areaCode,operationType,gEnableShiftYN,shiftCode,clientCode,operationType);

		 		try 
		 		 {
		 			clsPOSSalesFlashReportsBean objBean= new clsPOSSalesFlashReportsBean();
	 				String SalesAmount="";
	 				SalesAmount=decimalFormat2.format(Double.parseDouble(mapData.get("SalesAmt").toString()));
	 			
	 				objBean.setTotalAmount(SalesAmount);
	 				listSalesReport.add(objBean);
	        
	 				List<clsPOSSalesFlashReportsBean> tmplistSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
	 				tmplistSalesReport = (List<clsPOSSalesFlashReportsBean>)mapData.get("ListAreaWiseSales");
	 				clsPOSSalesFlashReportsBean obj;
	 				for(int i=0;i<tmplistSalesReport.size();i++)
	 				{
	 					obj= new clsPOSSalesFlashReportsBean();
	 					obj.setStrField1(tmplistSalesReport.get(i).getStrField1().substring(0));
	 					obj.setStrField2(tmplistSalesReport.get(i).getStrField2());
	 					obj.setStrField3(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField3())));
	 				
	 					listSalesReport.add(obj);
	 				}
	 				System.out.print("@controller "+listSalesReport.size());
	        	} 
	 			catch (Exception e) 
	 			{
						e.printStackTrace();
	 			}
	
		return listSalesReport;
	}
	
/*load Day  wise data*/
	 	@RequestMapping(value = "/loadDayWiseSalesReport", method = RequestMethod.POST)
	 	public @ResponseBody List<clsPOSSalesFlashReportsBean> funLoadDayWiseSalesReport(@RequestParam("POSName") String strPOSName,@RequestParam("FromDate") String FromDateTime,@RequestParam("ToDate") String ToDateTime,@RequestParam("Operator") String strOperator,
				@RequestParam("PayMode") String strPayMode,@RequestParam("txtFromBillNo") String strFromBill,@RequestParam("txtToBillNo") String strToBill,@RequestParam("txtReportType") String reportType,
				@RequestParam("txtType") String Type,@RequestParam("txtCustomer") String Customer,@RequestParam("chkConsolidatePOS") String ConsolidatePOS,@RequestParam("hidReportName") String ReportName
				,@RequestParam("areaCode") String areaCode,@RequestParam("operationType") String operationType,@RequestParam("gEnableShiftYN") String gEnableShiftYN,@RequestParam("shiftCode") String shiftCode,
				HttpServletResponse resp,HttpServletRequest req)
			{
	 			decimalFormat2 = new DecimalFormat("0.00");
				listSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
				String clientCode=req.getSession().getAttribute("gClientCode").toString();
	 			String userCode=req.getSession().getAttribute("gUserCode").toString();
	 			String companyName=req.getSession().getAttribute("gCompanyName").toString();
	 			String LoginPOSCode=req.getSession().getAttribute("loginPOS").toString();
	 			
	 			Map mapData = new HashMap();
	 			mapData=funGetReportData(strPOSName,FromDateTime,ToDateTime,strOperator,strPayMode,strFromBill,strToBill,reportType,
	 					Type,Customer,ConsolidatePOS,ReportName,userCode,LoginPOSCode,areaCode,operationType,gEnableShiftYN,shiftCode,clientCode,operationType);

		 		try {
			 				
		 				clsPOSSalesFlashReportsBean objBean= new clsPOSSalesFlashReportsBean();
		 				
		 				double SalesAmount=0;
	 					double totalDiscount = 0, totalSubTotalDWise = 0, totalAmount = 0, totalTaxAmt = 0;
	 					int totalNoOfBills = 0;
	 					totalNoOfBills=Integer.parseInt(mapData.get("totalNoOfBills").toString());
	 					totalAmount=Double.parseDouble(mapData.get("totAmount").toString());
	 					totalSubTotalDWise=Double.parseDouble(mapData.get("totalSubTotal").toString());
	 					totalDiscount=Double.parseDouble(mapData.get("totalDiscount").toString());
	 					totalTaxAmt=Double.parseDouble(mapData.get("totalTaxAmt").toString());
		 						
		 				objBean.setTotalQuantity(String.valueOf(totalNoOfBills));//totalNoOfBills
		 				objBean.setTotalAmount(String.valueOf(decimalFormat2.format(totalAmount)));
		 				objBean.setTotalSubTotal(String.valueOf(decimalFormat2.format(totalSubTotalDWise)));
		 				objBean.setTotalDiscAmt(String.valueOf(decimalFormat2.format(totalDiscount)));
		 				objBean.setTotalTaxAmt(String.valueOf(decimalFormat2.format(totalTaxAmt)));
		 				
		 				listSalesReport.add(objBean);
	        
		 				List<clsPOSSalesFlashReportsBean> tmplistSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
		 				tmplistSalesReport = (List<clsPOSSalesFlashReportsBean>)mapData.get("ListDayWiseSales");
		 				clsPOSSalesFlashReportsBean obj;
	 				for(int i=0;i<tmplistSalesReport.size();i++)
	 				{
	 					obj= new clsPOSSalesFlashReportsBean();
	 					obj.setStrField1(tmplistSalesReport.get(i).getStrField1());
	 					obj.setStrField2(tmplistSalesReport.get(i).getStrField2());
	 					obj.setStrField3(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField3())));
	 					obj.setStrField4(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField4())));
	 					obj.setStrField5(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField5())));
	 					obj.setStrField6(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField6())));
	 				
	 					listSalesReport.add(obj);
	 				}
	 				System.out.print("@controller "+listSalesReport.size());
	        	} 
	 			catch (Exception e) 
	 			{
						e.printStackTrace();
	 			}
	
		return listSalesReport;
	}	 	
	 
/*load Tax wise data*/
	 	@RequestMapping(value = "/loadTaxWiseSalesReport", method = RequestMethod.POST)
	 	public @ResponseBody List<clsPOSSalesFlashReportsBean> funLoadTaxWiseSalesReport(@RequestParam("POSName") String strPOSName,@RequestParam("FromDate") String FromDateTime,@RequestParam("ToDate") String ToDateTime,@RequestParam("Operator") String strOperator,
				@RequestParam("PayMode") String strPayMode,@RequestParam("txtFromBillNo") String strFromBill,@RequestParam("txtToBillNo") String strToBill,@RequestParam("txtReportType") String reportType,
				@RequestParam("txtType") String Type,@RequestParam("txtCustomer") String Customer,@RequestParam("chkConsolidatePOS") String ConsolidatePOS,@RequestParam("hidReportName") String ReportName
				,@RequestParam("areaCode") String areaCode,@RequestParam("operationType") String operationType,@RequestParam("gEnableShiftYN") String gEnableShiftYN,@RequestParam("shiftCode") String shiftCode,
				HttpServletResponse resp,HttpServletRequest req)
			{
	 			decimalFormat2 = new DecimalFormat("0.00");
				listSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
				String clientCode=req.getSession().getAttribute("gClientCode").toString();
	 			String userCode=req.getSession().getAttribute("gUserCode").toString();
	 			String companyName=req.getSession().getAttribute("gCompanyName").toString();
	 			String LoginPOSCode=req.getSession().getAttribute("loginPOS").toString();
	 			
	 			Map mapData = new HashMap();
	 			mapData=funGetReportData(strPOSName,FromDateTime,ToDateTime,strOperator,strPayMode,strFromBill,strToBill,reportType,
	 					Type,Customer,ConsolidatePOS,ReportName,userCode,LoginPOSCode,areaCode,operationType,gEnableShiftYN,shiftCode,clientCode,operationType);

		 		try 
		 		{				
		 				clsPOSSalesFlashReportsBean objBean= new clsPOSSalesFlashReportsBean();
		 				double totalTax = 0, totalTaxableAmt = 0;	
		 				totalTax=Double.parseDouble(mapData.get("totalTax").toString());
		 				totalTaxableAmt=Double.parseDouble(mapData.get("totalTaxableAmt").toString());
		 				objBean.setTotalSubTotal(String.valueOf(decimalFormat2.format(totalTax)));
		 				objBean.setTotalTaxAmt(String.valueOf(decimalFormat2.format(totalTaxableAmt)));
		 				
		 				listSalesReport.add(objBean);
	        
		 				List<clsPOSSalesFlashReportsBean> tmplistSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
		 				tmplistSalesReport = (List<clsPOSSalesFlashReportsBean>)mapData.get("ListTaxWiseSales");
		 				clsPOSSalesFlashReportsBean obj;
	 			
		 				for(int i=0;i<tmplistSalesReport.size();i++)
		 				{
		 					obj= new clsPOSSalesFlashReportsBean();
		 					obj.setStrField1(tmplistSalesReport.get(i).getStrField1());
		 					obj.setStrField2(tmplistSalesReport.get(i).getStrField2());
		 					obj.setStrField3(tmplistSalesReport.get(i).getStrField3());
		 					obj.setStrField4(tmplistSalesReport.get(i).getStrField4());
		 					obj.setStrField5(tmplistSalesReport.get(i).getStrField5());
		 					obj.setStrField6(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField6())));
		 					obj.setStrField7(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField7())));		 				
		 					listSalesReport.add(obj);
		 				}
	 				System.out.print("@controller "+listSalesReport.size());
	        	} 
	 			catch (Exception e) 
	 			{
						e.printStackTrace();
	 			}
	
		return listSalesReport;
	}
	 
/*load Tip wise data*/
	 	@RequestMapping(value = "/loadTipWiseSalesReport", method = RequestMethod.POST)
	 	public @ResponseBody List<clsPOSSalesFlashReportsBean> funLoadTipSalesReport(@RequestParam("POSName") String strPOSName,@RequestParam("FromDate") String FromDateTime,@RequestParam("ToDate") String ToDateTime,@RequestParam("Operator") String strOperator,
				@RequestParam("PayMode") String strPayMode,@RequestParam("txtFromBillNo") String strFromBill,@RequestParam("txtToBillNo") String strToBill,@RequestParam("txtReportType") String reportType,
				@RequestParam("txtType") String Type,@RequestParam("txtCustomer") String Customer,@RequestParam("chkConsolidatePOS") String ConsolidatePOS,@RequestParam("hidReportName") String ReportName
				,@RequestParam("areaCode") String areaCode,@RequestParam("operationType") String operationType,@RequestParam("gEnableShiftYN") String gEnableShiftYN,@RequestParam("shiftCode") String shiftCode,
				HttpServletResponse resp,HttpServletRequest req)
			{
	 			decimalFormat2 = new DecimalFormat("0.00");	
				listSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
				String clientCode=req.getSession().getAttribute("gClientCode").toString();
	 			String userCode=req.getSession().getAttribute("gUserCode").toString();
	 			String companyName=req.getSession().getAttribute("gCompanyName").toString();
	 			String LoginPOSCode=req.getSession().getAttribute("loginPOS").toString();
	 			
	 			Map mapData = new HashMap();
	 			mapData=funGetReportData(strPOSName,FromDateTime,ToDateTime,strOperator,strPayMode,strFromBill,strToBill,reportType,
	 					Type,Customer,ConsolidatePOS,ReportName,userCode,LoginPOSCode,areaCode,operationType,gEnableShiftYN,shiftCode,clientCode,operationType);

		 		try 
		 		{
			 				
		 			clsPOSSalesFlashReportsBean objBean= new clsPOSSalesFlashReportsBean();	
		 			double SalesAmount=0;
	 				double totalDiscount = 0, totalSubTotal= 0, totalTaxAmt = 0,totalTipAmt=0;
					SalesAmount=Double.parseDouble(mapData.get("SalesAmount").toString());
 					totalSubTotal=Double.parseDouble(mapData.get("subTotal").toString());
 					totalDiscount=Double.parseDouble(mapData.get("Disc").toString());
 					totalTaxAmt=Double.parseDouble(mapData.get("totalTaxAmt").toString());
 					totalTipAmt=Double.parseDouble(mapData.get("tipAmountTotal").toString());
		 					
 					objBean.setTotalDiscAmt(String.valueOf(decimalFormat2.format(totalDiscount)));
 					objBean.setTotalSubTotal(String.valueOf(decimalFormat2.format(totalSubTotal)));
 					objBean.setTotalTaxAmt(String.valueOf(decimalFormat2.format(totalTaxAmt)));
 					objBean.setTotalTipAmt(String.valueOf(decimalFormat2.format(totalTipAmt)));
 					objBean.setTotalAmount(String.valueOf(decimalFormat2.format(totalTipAmt)));
		 		    listSalesReport.add(objBean);
	        
		 		    List<clsPOSSalesFlashReportsBean> tmplistSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
	 				tmplistSalesReport = (List<clsPOSSalesFlashReportsBean>)mapData.get("ListTipWiseSales");
	 				clsPOSSalesFlashReportsBean obj;
	 				for(int i=0;i<tmplistSalesReport.size();i++)
	 				{
	 					obj= new clsPOSSalesFlashReportsBean();
	 					obj.setStrField1(tmplistSalesReport.get(i).getStrField1());
	 					obj.setStrField2(tmplistSalesReport.get(i).getStrField2());
	 					obj.setStrField3(tmplistSalesReport.get(i).getStrField3());
	 					obj.setStrField4(tmplistSalesReport.get(i).getStrField4());
	 					obj.setStrField5(tmplistSalesReport.get(i).getStrField5());
	 					obj.setStrField6(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField6())));
	 					obj.setStrField7(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField7())));
	 					obj.setStrField8(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField8())));
	 					obj.setStrField9(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField9())));
	 					obj.setStrField10(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField10())));
	 					obj.setStrField11(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField11())));
	 					listSalesReport.add(obj);
	 				}
	 				System.out.print("@controller "+listSalesReport.size());
	        	} 
	 			catch (Exception e) 
	 			{
						e.printStackTrace();
	 			}
	
		return listSalesReport;
	}
	 	
/*load Item Modifier  wise data*/
	 	@RequestMapping(value = "/loadItemModifierWiseSalesReport", method = RequestMethod.POST)
	 	public @ResponseBody List<clsPOSSalesFlashReportsBean> funLoadItemModifierWiseSalesReport(@RequestParam("POSName") String strPOSName,@RequestParam("FromDate") String FromDateTime,@RequestParam("ToDate") String ToDateTime,@RequestParam("Operator") String strOperator,
				@RequestParam("PayMode") String strPayMode,@RequestParam("txtFromBillNo") String strFromBill,@RequestParam("txtToBillNo") String strToBill,@RequestParam("txtReportType") String reportType,
				@RequestParam("txtType") String Type,@RequestParam("txtCustomer") String Customer,@RequestParam("chkConsolidatePOS") String ConsolidatePOS,@RequestParam("hidReportName") String ReportName
				,@RequestParam("areaCode") String areaCode,@RequestParam("operationType") String operationType,@RequestParam("gEnableShiftYN") String gEnableShiftYN,@RequestParam("shiftCode") String shiftCode,
				HttpServletResponse resp,HttpServletRequest req)
			{
	 			decimalFormat0 = new DecimalFormat("");
	 			decimalFormat2 = new DecimalFormat("0.00"); 
				listSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
				String clientCode=req.getSession().getAttribute("gClientCode").toString();
	 			String userCode=req.getSession().getAttribute("gUserCode").toString();
	 			String companyName=req.getSession().getAttribute("gCompanyName").toString();
	 			String LoginPOSCode=req.getSession().getAttribute("loginPOS").toString();
	 			
	 			Map mapData = new HashMap();
	 			mapData=funGetReportData(strPOSName,FromDateTime,ToDateTime,strOperator,strPayMode,strFromBill,strToBill,reportType,
	 					Type,Customer,ConsolidatePOS,ReportName,userCode,LoginPOSCode,areaCode,operationType,gEnableShiftYN,shiftCode,clientCode,operationType);

		 		try 
		 		{
			 				
		 			
		 		    clsPOSSalesFlashReportsBean objBean= new clsPOSSalesFlashReportsBean();
		 			double SalesAmount=0;
	 				double totalQty = 0;
					totalQty=Double.parseDouble(mapData.get("totalQty").toString());
					SalesAmount=Double.parseDouble(mapData.get("totalAmount").toString());
					objBean.setTotalQuantity(String.valueOf(totalQty));//totalNoOfBills
					objBean.setTotalAmount(String.valueOf(decimalFormat2.format(SalesAmount)));
					listSalesReport.add(objBean);
	        
					List<clsPOSSalesFlashReportsBean> tmplistSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
	 				tmplistSalesReport = (List<clsPOSSalesFlashReportsBean>)mapData.get("ListModWiseSales");
	 				clsPOSSalesFlashReportsBean obj;
	 				for(int i=0;i<tmplistSalesReport.size();i++)
	 				{
	 					obj= new clsPOSSalesFlashReportsBean();
	 					obj.setStrField1(tmplistSalesReport.get(i).getStrField1());
	 					obj.setStrField2(tmplistSalesReport.get(i).getStrField2());
	 					obj.setStrField3(decimalFormat0.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField3())));
	 					obj.setStrField4(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField4())));
	 				
	 					listSalesReport.add(obj);
	 				}
	 				System.out.print("@controller "+listSalesReport.size());
	        	} 
	 			catch (Exception e) 
	 			{
						e.printStackTrace();
	 			}
	
		return listSalesReport;
	}	
	 	
/*load Menu head wise with Modifier  wise data*/
	 	@RequestMapping(value = "/loadMenuHeadWiseWithModSalesReport", method = RequestMethod.POST)
	 	public @ResponseBody List<clsPOSSalesFlashReportsBean> funLoadMenuHeadWiseWithModifierSalesReport(@RequestParam("POSName") String strPOSName,@RequestParam("FromDate") String FromDateTime,@RequestParam("ToDate") String ToDateTime,@RequestParam("Operator") String strOperator,
				@RequestParam("PayMode") String strPayMode,@RequestParam("txtFromBillNo") String strFromBill,@RequestParam("txtToBillNo") String strToBill,@RequestParam("txtReportType") String reportType,
				@RequestParam("txtType") String Type,@RequestParam("txtCustomer") String Customer,@RequestParam("chkConsolidatePOS") String ConsolidatePOS,@RequestParam("hidReportName") String ReportName
				,@RequestParam("areaCode") String areaCode,@RequestParam("operationType") String operationType,@RequestParam("gEnableShiftYN") String gEnableShiftYN,@RequestParam("shiftCode") String shiftCode,
				HttpServletResponse resp,HttpServletRequest req)
			{
	 			decimalFormat0 = new DecimalFormat(""); 
	 			decimalFormat2 = new DecimalFormat("0.00"); 
				listSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
				String clientCode=req.getSession().getAttribute("gClientCode").toString();
	 			String userCode=req.getSession().getAttribute("gUserCode").toString();
	 			String companyName=req.getSession().getAttribute("gCompanyName").toString();
	 			String LoginPOSCode=req.getSession().getAttribute("loginPOS").toString();
	 			
	 			Map mapData = new HashMap();
	 			mapData=funGetReportData(strPOSName,FromDateTime,ToDateTime,strOperator,strPayMode,strFromBill,strToBill,reportType,
	 					Type,Customer,ConsolidatePOS,ReportName,userCode,LoginPOSCode,areaCode,operationType,gEnableShiftYN,shiftCode,clientCode,operationType);

		 		try 
		 		{
			 				
	 				clsPOSSalesFlashReportsBean objBean= new clsPOSSalesFlashReportsBean();
	 				double SalesAmount=0;
 					double totalQty = 0;
					totalQty=Double.parseDouble(mapData.get("totalQty").toString());
					SalesAmount=Double.parseDouble(mapData.get("totalAmount").toString());
					objBean.setTotalQuantity(String.valueOf(decimalFormat0.format(totalQty)));//totalNoOfBills
					objBean.setTotalAmount(String.valueOf(decimalFormat2.format(SalesAmount)));//totalSalesAmount
					listSalesReport.add(objBean);
	        
					List<clsPOSSalesFlashReportsBean> tmplistSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
	 				tmplistSalesReport = (List<clsPOSSalesFlashReportsBean>)mapData.get("ListMenuHeadModWiseSales");
	 				clsPOSSalesFlashReportsBean obj;
	 				for(int i=0;i<tmplistSalesReport.size();i++)
	 				{
	 					obj= new clsPOSSalesFlashReportsBean();
	 					obj.setStrField1(tmplistSalesReport.get(i).getStrField1());
	 					obj.setStrField2(tmplistSalesReport.get(i).getStrField2());
	 					double d = Double.parseDouble(tmplistSalesReport.get(i).getStrField3());
	 					obj.setStrField3(decimalFormat0.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField3())));
	 					obj.setStrField4(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField4())));
	 				
	 					listSalesReport.add(obj);
	 				}
	 				System.out.print("@controller "+listSalesReport.size());
	        	} 
	 			catch (Exception e) 
	 			{
						e.printStackTrace();
	 			}
	
		return listSalesReport;
	}	
	 

/*loadItem Hourly wise with Modifier  wise data*/
	 	@RequestMapping(value = "/loadItemHourlyWiseSalesReport", method = RequestMethod.POST)
	 	public @ResponseBody List<clsPOSSalesFlashReportsBean> funLoadItemHourlyWiseSalesReport(@RequestParam("POSName") String strPOSName,@RequestParam("FromDate") String FromDateTime,@RequestParam("ToDate") String ToDateTime,@RequestParam("Operator") String strOperator,
				@RequestParam("PayMode") String strPayMode,@RequestParam("txtFromBillNo") String strFromBill,@RequestParam("txtToBillNo") String strToBill,@RequestParam("txtReportType") String reportType,
				@RequestParam("txtType") String Type,@RequestParam("txtCustomer") String Customer,@RequestParam("chkConsolidatePOS") String ConsolidatePOS,@RequestParam("hidReportName") String ReportName
				,@RequestParam("areaCode") String areaCode,@RequestParam("operationType") String operationType,@RequestParam("gEnableShiftYN") String gEnableShiftYN,@RequestParam("shiftCode") String shiftCode,
				HttpServletResponse resp,HttpServletRequest req)
			{
	 			decimalFormat1 = new DecimalFormat("0.0"); 
	 			decimalFormat2 = new DecimalFormat("0.00"); 
				listSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
				String clientCode=req.getSession().getAttribute("gClientCode").toString();
	 			String userCode=req.getSession().getAttribute("gUserCode").toString();
	 			String companyName=req.getSession().getAttribute("gCompanyName").toString();
	 			String LoginPOSCode=req.getSession().getAttribute("loginPOS").toString();
	 			
	 			Map mapData = new HashMap();
	 			mapData=funGetReportData(strPOSName,FromDateTime,ToDateTime,strOperator,strPayMode,strFromBill,strToBill,reportType,
	 					Type,Customer,ConsolidatePOS,ReportName,userCode,LoginPOSCode,areaCode,operationType,gEnableShiftYN,shiftCode,clientCode,operationType);

		 		try 
		 		{
		 						
		 			
			 				
	 			   clsPOSSalesFlashReportsBean objBean= new clsPOSSalesFlashReportsBean();
	 				double totalAmount=0;
 					double totalQty = 0,totalDiscAmount=0;
 					totalQty=Double.parseDouble(mapData.get("totalQty").toString());
 					totalDiscAmount=Double.parseDouble(mapData.get("totalDiscAmount").toString());
 					totalAmount=Double.parseDouble(mapData.get("totalAmount").toString());
					objBean.setTotalQuantity(String.valueOf(decimalFormat1.format(totalQty)));
					objBean.setTotalDiscAmt(String.valueOf(decimalFormat2.format(totalDiscAmount)));
					objBean.setTotalAmount(String.valueOf(decimalFormat2.format(totalAmount)));
					listSalesReport.add(objBean);
	        
					List<clsPOSSalesFlashReportsBean> tmplistSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
	 				tmplistSalesReport = (List<clsPOSSalesFlashReportsBean>)mapData.get("ListItemHourlyWiseSales");
	 				clsPOSSalesFlashReportsBean obj;
	 				for(int i=0;i<tmplistSalesReport.size();i++)
	 				{
	 					obj= new clsPOSSalesFlashReportsBean();
	 					obj.setStrField1(tmplistSalesReport.get(i).getStrField1());
	 					obj.setStrField2(tmplistSalesReport.get(i).getStrField2());
	 					obj.setStrField3(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField3())));
	 					obj.setStrField4(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField4())));
	 					obj.setStrField5(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField5())));
	 					listSalesReport.add(obj);
	 				}
	 				System.out.print("@controller "+listSalesReport.size());
	        	} 
	 			catch (Exception e) 
	 			{
						e.printStackTrace();
	 			}
	
		return listSalesReport;
	}	
	  	

/*load Operator wise  data*/
	 	@RequestMapping(value = "/loadOperstorWiseSalesReport", method = RequestMethod.POST)
	 	public @ResponseBody List<clsPOSSalesFlashReportsBean> funLoadOperatorSalesReport(@RequestParam("POSName") String strPOSName,@RequestParam("FromDate") String FromDateTime,@RequestParam("ToDate") String ToDateTime,@RequestParam("Operator") String strOperator,
				@RequestParam("PayMode") String strPayMode,@RequestParam("txtFromBillNo") String strFromBill,@RequestParam("txtToBillNo") String strToBill,@RequestParam("txtReportType") String reportType,
				@RequestParam("txtType") String Type,@RequestParam("txtCustomer") String Customer,@RequestParam("chkConsolidatePOS") String ConsolidatePOS,@RequestParam("hidReportName") String ReportName
				,@RequestParam("areaCode") String areaCode,@RequestParam("operationType") String operationType,@RequestParam("gEnableShiftYN") String gEnableShiftYN,@RequestParam("shiftCode") String shiftCode,
				HttpServletResponse resp,HttpServletRequest req)
			{
	 		
	 		 	decimalFormat1 = new DecimalFormat("0.0");
	 			decimalFormat2 = new DecimalFormat("0.00"); 
				listSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
				String clientCode=req.getSession().getAttribute("gClientCode").toString();
	 			String userCode=req.getSession().getAttribute("gUserCode").toString();
	 			String companyName=req.getSession().getAttribute("gCompanyName").toString();
	 			String LoginPOSCode=req.getSession().getAttribute("loginPOS").toString();
	 			
	 			Map mapData = new HashMap();
	 			mapData=funGetReportData(strPOSName,FromDateTime,ToDateTime,strOperator,strPayMode,strFromBill,strToBill,reportType,
	 					Type,Customer,ConsolidatePOS,ReportName,userCode,LoginPOSCode,areaCode,operationType,gEnableShiftYN,shiftCode,clientCode,operationType);

		 		try 
		 		{
		 			clsPOSSalesFlashReportsBean objBean= new clsPOSSalesFlashReportsBean();
	 				double SalesAmount=0;
 					double totalDisc = 0;
	 				totalDisc=Double.parseDouble(mapData.get("totalDisc").toString());
					SalesAmount=Double.parseDouble(mapData.get("totalAmount").toString());
					objBean.setTotalDiscAmt(String.valueOf(decimalFormat1.format(totalDisc)));
					objBean.setTotalAmount(String.valueOf(decimalFormat2.format(SalesAmount)));
					listSalesReport.add(objBean);
	        
					List<clsPOSSalesFlashReportsBean> tmplistSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
	 				tmplistSalesReport = (List<clsPOSSalesFlashReportsBean>)mapData.get("ListOperatorWiseSales");
	 				clsPOSSalesFlashReportsBean obj;
	 				for(int i=0;i<tmplistSalesReport.size();i++)
	 				{
	 					obj= new clsPOSSalesFlashReportsBean();
	 					obj.setStrField1(tmplistSalesReport.get(i).getStrField1());
	 					obj.setStrField2(tmplistSalesReport.get(i).getStrField2());
	 					obj.setStrField3(tmplistSalesReport.get(i).getStrField3());
	 					obj.setStrField4(tmplistSalesReport.get(i).getStrField4());
	 					obj.setStrField5(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField5())));
	 					obj.setStrField6(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField6())));
	 					listSalesReport.add(obj);
	 				}
	 				System.out.print("@controller "+listSalesReport.size());
	        	} 
	 			catch (Exception e) 
	 			{
						e.printStackTrace();
	 			}
	
		return listSalesReport;
	}	
	 
/*load Monthly wise  data*/
	 	@RequestMapping(value = "/loadMonthlyWiseSalesReport", method = RequestMethod.POST)
	 	public @ResponseBody List<clsPOSSalesFlashReportsBean> funLoadMonthlySalesReport(@RequestParam("POSName") String strPOSName,@RequestParam("FromDate") String FromDateTime,@RequestParam("ToDate") String ToDateTime,@RequestParam("Operator") String strOperator,
				@RequestParam("PayMode") String strPayMode,@RequestParam("txtFromBillNo") String strFromBill,@RequestParam("txtToBillNo") String strToBill,@RequestParam("txtReportType") String reportType,
				@RequestParam("txtType") String Type,@RequestParam("txtCustomer") String Customer,@RequestParam("chkConsolidatePOS") String ConsolidatePOS,@RequestParam("hidReportName") String ReportName
				,@RequestParam("areaCode") String areaCode,@RequestParam("operationType") String operationType,@RequestParam("gEnableShiftYN") String gEnableShiftYN,@RequestParam("shiftCode") String shiftCode,
				HttpServletResponse resp,HttpServletRequest req)
			{
 				decimalFormat2 = new DecimalFormat("0.00"); 
				listSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
				String clientCode=req.getSession().getAttribute("gClientCode").toString();
	 			String userCode=req.getSession().getAttribute("gUserCode").toString();
	 			String companyName=req.getSession().getAttribute("gCompanyName").toString();
	 			String LoginPOSCode=req.getSession().getAttribute("loginPOS").toString();
	 			
	 			Map mapData = new HashMap();
	 			mapData=funGetReportData(strPOSName,FromDateTime,ToDateTime,strOperator,strPayMode,strFromBill,strToBill,reportType,
	 					Type,Customer,ConsolidatePOS,ReportName,userCode,LoginPOSCode,areaCode,operationType,gEnableShiftYN,shiftCode,clientCode,operationType);

		 		try 
		 		{
			 				
	 			    clsPOSSalesFlashReportsBean objBean= new clsPOSSalesFlashReportsBean();
	 				double SalesAmount=0;
					SalesAmount=Double.parseDouble(mapData.get("totalSale").toString());
					objBean.setTotalAmount(String.valueOf(decimalFormat2.format(SalesAmount)));
					listSalesReport.add(objBean);
	        
					List<clsPOSSalesFlashReportsBean> tmplistSalesReport=new ArrayList<clsPOSSalesFlashReportsBean>();
	 				tmplistSalesReport = (List<clsPOSSalesFlashReportsBean>)mapData.get("ListMonthlySales");
	 				clsPOSSalesFlashReportsBean obj;
	 				for(int i=0;i<tmplistSalesReport.size();i++)
	 				{
	 					obj= new clsPOSSalesFlashReportsBean();
	 					obj.setStrField1(tmplistSalesReport.get(i).getStrField1());
	 					obj.setStrField2(tmplistSalesReport.get(i).getStrField2());
	 					obj.setStrField3(decimalFormat2.format(Double.parseDouble(tmplistSalesReport.get(i).getStrField3())));
	 					listSalesReport.add(obj);
	 				}
	 				System.out.print("@controller "+listSalesReport.size());
	        	} 
	 			catch (Exception e) 
	 			{
						e.printStackTrace();
	 			}
	
		return listSalesReport;
	}	
	 	
/*return json data used to send webservice */
	public Map funGetReportData(String strPOSName,String FromDateTime,String ToDateTime, String strOperator,
				String strPayMode,String strFromBill,String strToBill,String reportType,
				String Type,String Customer,String ConsolidatePOS,String ReportName,String userCode,String LoginPOSCode,String areaCode,String operationTye,String gEnableShiftYN,String shiftCode,String clientCode,String operationType)
		{
			Map mapDataReportData = new HashMap();
			try{
				
	 			String FromDate="",FromTime="",ToDate="",ToTime="";
	 			
	 			FromDate=FromDateTime.split(":")[0];
	 			FromTime=FromDateTime.split(":")[1];
	 			ToDate=ToDateTime.split(":")[0];
	 			ToTime=ToDateTime.split(":")[1];
	 			
	 			String strFromdate=FromDate.split("-")[2]+"-"+FromDate.split("-")[1]+"-"+FromDate.split("-")[0];
	 			String strToDate=ToDate.split("-")[2]+"-"+ToDate.split("-")[1]+"-"+ToDate.split("-")[0]; 
			
	 			String dateFrom = "", field = null, dateTo = "";
			
	 				if (funGetFromTime(FromTime)!= null)
	 				{
				        dateFrom = strFromdate + " " + funGetFromTime(FromTime);
				        field = "dteBillDate";
	 				}
	 				else 
	 				{
				        dateFrom = strFromdate;
				        field = "date(dteBillDate)";
	 				}
	 				if (funGetToTime(ToTime) != null)
	 				{
	 					dateTo = strToDate + " " + funGetToTime(ToTime);
	 				}
	 				else
					{
					    dateTo = strToDate;
					}
	 				if(ConsolidatePOS.equalsIgnoreCase("true"))
	 				{
	 					ConsolidatePOS="Y";
	 				}
	 				else{
	 					ConsolidatePOS="N";
	 				}
	 				String posCode= "All";
	 				String PayMode= "All";
			
	 				if(!strPOSName.equalsIgnoreCase("ALL"))
	 				{
	 					 for(Map.Entry<String,String> entry : hmPOSData.entrySet())
	 					 {
	 						 String POSCode=entry.getKey();
	 						 String POSName=entry.getValue();
	 						 if(POSName.equalsIgnoreCase(strPOSName))
	 						 {
	 							posCode=POSCode;
	 						 }
	 					 }
	 					//posCode= hmPOSData.get(strPOSName);
	 				}
		
	 				if(!strPayMode.equalsIgnoreCase("All"))
	 				{
	 					PayMode= hmPayMode.get(strPayMode);
	 				}
			
	 				mapDataReportData=objReportService.funSalesReport(strFromdate,strToDate, posCode,shiftCode, userCode,field,PayMode,strOperator,
	 				strFromBill,strToBill,reportType,Type,Customer,ConsolidatePOS,ReportName.substring(3),LoginPOSCode,gEnableShiftYN,clientCode,operationType,areaCode);
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
			return mapDataReportData;
		}
	 	
 	private String funGetFromTime(String FromTime) throws Exception
		    {
		        String fromTime = null;
		        String Hour = FromTime.split("/")[0];
	            String Minute =FromTime.split("/")[1];
	            String Ampm = FromTime.split("/")[2];
		        if (Hour==("HH") && !(Minute==("MM")))
		        {
		            SimpleDateFormat displayFormat = new SimpleDateFormat("HH:mm");
		            SimpleDateFormat parseFormat = new SimpleDateFormat("hh:mm a");
		            String Time = Hour + ":" + Minute + " " + Ampm;
		            Date date = parseFormat.parse(Time);
		            fromTime = displayFormat.format(date);
		        }
		        return fromTime;
		    }
		 
		private String funGetToTime(String ToTime) throws Exception
		    {
		        String toTime = null;
		        String Hour = ToTime.split("/")[0];
	            String Minute =ToTime.split("/")[1];
	            String Ampm = ToTime.split("/")[2];
		        if (Hour==("HH") && !(Minute==("MM")))
		        {
		            SimpleDateFormat displayFormat = new SimpleDateFormat("HH:mm");
		            SimpleDateFormat parseFormat = new SimpleDateFormat("hh:mm a");
		            String Time = Hour + ":" + Minute + " " + Ampm;
		            Date date = parseFormat.parse(Time);
		            ToTime = displayFormat.format(date);
		        }
		        return toTime;
		    }
		
	
		
		
		
		
		@RequestMapping(value = "/loadPOSWiseShiftData", method = RequestMethod.GET)
		public @ResponseBody List<clsShiftMasterModel> funGetPOSWiseShiftList(@RequestParam("POSCode") String posCode,HttpServletRequest req)throws Exception
		{
			String clientCode=req.getSession().getAttribute("gClientCode").toString();
			List<clsShiftMasterModel> listShiftModel =new ArrayList();
			String posName = null;
			
			StringBuilder sqlShift = new StringBuilder();
			if (posCode.equalsIgnoreCase("All"))
			{
			    sqlShift.append("select max(a.intShiftCode) from tblshiftmaster a group by a.intShiftCode ");
			}
			else
			{
			    sqlShift.append("select a.intShiftCode from tblshiftmaster a where a.strPOSCode='" + posCode + "' ");
			}

			List listSql = obBaseService.funGetList(sqlShift, "sql");
			if(listSql.size()>0)
			{
				for(int i=0 ;i<listSql.size();i++ )
			      {
					Object obj = listSql.get(i);
					clsShiftMasterModel objModel = new clsShiftMasterModel();
					objModel.setIntShiftCode(obj.toString());
					listShiftModel.add(objModel);
					
					   listShiftModel.add(objModel);
			      } 	
			}
			return listShiftModel;
		}
		
		 
	}
