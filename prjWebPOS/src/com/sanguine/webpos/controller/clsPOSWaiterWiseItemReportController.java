package com.sanguine.webpos.controller;

import java.io.FileOutputStream;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.jasperreports.engine.JRExporter;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;
import net.sf.jasperreports.engine.design.JasperDesign;
import net.sf.jasperreports.engine.export.JRPdfExporter;
import net.sf.jasperreports.engine.export.JRPdfExporterParameter;
import net.sf.jasperreports.engine.export.JRXlsExporter;
import net.sf.jasperreports.engine.export.JRXlsExporterParameter;
import net.sf.jasperreports.engine.xml.JRXmlLoader;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.sanguine.base.service.clsSetupService;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.webpos.bean.clsPOSBillDtl;
import com.sanguine.webpos.bean.clsPOSReportBean;
import com.sanguine.webpos.comparator.clsWaiterWiseSalesComparator;
import com.sanguine.webpos.model.clsShiftMasterModel;
import com.sanguine.webpos.model.clsWaiterMasterModel;
import com.sanguine.webpos.sevice.clsPOSMasterService;
import com.sanguine.webpos.sevice.clsPOSReportService;

@Controller
public class clsPOSWaiterWiseItemReportController {

	@Autowired
	private clsGlobalFunctions objGlobalFunctions;
	
	@Autowired
	private clsPOSGlobalFunctionsController objPOSGlobalFunctionsController; 
	
	@Autowired
	private ServletContext servletContext;
	
	@Autowired
	private clsPOSMasterService objMasterService; 
	
	@Autowired
	private clsPOSReportService objReportService;
	@Autowired
	private clsSetupService objSetupService;

	
	 Map<String,String> hmPOSData;
	 Map<String,String> hmWaiterData;
		private Map<String,String> map = new HashMap<String,String>();

	 ///frmPOSWaiterWiseItemWiseIncentiveReport frmPOSWaiterWiseIncentiveReport
	 @RequestMapping(value = "/frmPOSWaiterWiseItemReport", method = RequestMethod.GET)
		public ModelAndView funOpenForm(Map<String, Object> model,HttpServletRequest request)throws Exception
		{
			String strClientCode=request.getSession().getAttribute("gClientCode").toString();
			String POSCode=request.getSession().getAttribute("loginPOS").toString();	

			String urlHits="1";
			try{
				urlHits=request.getParameter("saddr").toString();
			}catch(NullPointerException e){
				urlHits="1";
			}
			model.put("urlHits",urlHits);

			
			hmPOSData=new HashMap<String, String>();
			List poslist = new ArrayList();
			poslist.add("ALL");
			List listOfPos = objMasterService.funFillPOSCombo(strClientCode);
			if(listOfPos!=null)
			{
				for(int i =0 ;i<listOfPos.size();i++)
				{
					Object[] obj = (Object[]) listOfPos.get(i);
					poslist.add( obj[1].toString());
					map.put( obj[1].toString(), obj[0].toString());
				}
			}
			model.put("posList",poslist);
			
			List waiterlist = new ArrayList();
			waiterlist.add("All");
			
			hmWaiterData=new HashMap<String, String>();
			List<clsWaiterMasterModel> listOfWaiters = objMasterService.funGetAllWaitersForMaster(strClientCode);
			if(listOfWaiters!=null)
			{
				for(int i =0 ;i<listOfWaiters.size();i++)
				{
					clsWaiterMasterModel objModel =  (clsWaiterMasterModel) listOfWaiters.get(i);
					waiterlist.add(objModel.getStrWShortName());
					hmWaiterData.put(objModel.getStrWShortName(),objModel.getStrWaiterNo());
				}
			}
			model.put("waiterlist",waiterlist);
			
			String posDate=request.getSession().getAttribute("gPOSDate").toString();	
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
			
			
			
			if("2".equalsIgnoreCase(urlHits)){
				return new ModelAndView("frmPOSWaiterWiseItemReport_1","command", new clsPOSReportBean());
			}else if("1".equalsIgnoreCase(urlHits)){
				return new ModelAndView("frmPOSWaiterWiseItemReport","command", new clsPOSReportBean());
			}else {
				return null;
			}
			 
		}
	 
	 @SuppressWarnings("rawtypes")
		@RequestMapping(value = "/rptWaiterWiseItemReport", method = RequestMethod.POST)	
		public void funReport(@ModelAttribute("command") clsPOSReportBean objBean, HttpServletResponse resp,HttpServletRequest req,String source)
		{
			
			try
			{
				String reportName = servletContext.getRealPath("/WEB-INF/reports/webpos/rptWaiterWiseItemReport.jrxml");
				String strClientCode=req.getSession().getAttribute("gClientCode").toString();
				String POSCode=req.getSession().getAttribute("loginPOS").toString();

				Map hm = objGlobalFunctions.funGetCommonHashMapForJasperReport(objBean, req, resp);
				String strPOSName = objBean.getStrPOSName();
				String posCode = "ALL";
				if (!strPOSName.equalsIgnoreCase("ALL"))
				{
					posCode = (String) hmPOSData.get(strPOSName);
				}
				hm.put("posCode", posCode);
				
				String strWaiterName = objBean.getStrWShortName();
				String waiterCode = "ALL";
				if (!strWaiterName.equalsIgnoreCase("ALL"))
				{
					waiterCode = (String) hmPOSData.get(strWaiterName);
				}
				hm.put("waiterName", strWaiterName);
				
				String fromDate = hm.get("fromDate").toString();
				String toDate = hm.get("toDate").toString();
				String strUserCode = hm.get("userName").toString();
				String strPOSCode = posCode;
				String strShiftNo = "1";
				Map objSetupParameter=objSetupService.funGetParameterValuePOSWise(strClientCode, POSCode, "gEnableShiftYN");
				if(objSetupParameter.get("gEnableShiftYN").toString().equals("Y"))
				{
					strShiftNo=objBean.getStrShiftCode();
				}
				hm.remove("shiftNo");
				hm.put("shiftNo", strShiftNo);
				List<clsPOSBillDtl> listOfWaiterWiseItemSales = new ArrayList<>();
				
				listOfWaiterWiseItemSales = objReportService.funProcessWaiterWiseItemReport(POSCode,fromDate,toDate,objSetupParameter.get("gEnableShiftYN").toString(),strShiftNo,waiterCode);
				
	            JasperDesign jd = JRXmlLoader.load(reportName);
				JasperReport jr = JasperCompileManager.compileReport(jd);
				List<JasperPrint> jprintlist = new ArrayList<JasperPrint>();
				JRBeanCollectionDataSource beanCollectionDataSource = new JRBeanCollectionDataSource(listOfWaiterWiseItemSales);
				JasperPrint print = JasperFillManager.fillReport(jr, hm, beanCollectionDataSource);
				jprintlist.add(print);
				String filePath = System.getProperty("user.dir")+ "/DayEndMailReports/";
				String extension=".pdf";
				if (!objBean.getStrDocType().equals("PDF"))
				{
					objBean.setStrDocType("EXCEL");
					extension=".xls";
				}	
				String fileName = "WaiterWiseItemReport_"+ fromDate + "_To_" + toDate + "_" + strUserCode + extension;
				filePath=filePath+"/"+fileName;
				if (jprintlist.size() > 0)
				{
					ServletOutputStream servletOutputStream = resp.getOutputStream();
					if (objBean.getStrDocType().equals("PDF"))
					{
						JRExporter exporter = new JRPdfExporter();
						resp.setContentType("application/pdf");
						exporter.setParameter(JRPdfExporterParameter.JASPER_PRINT_LIST, jprintlist);
						exporter.setParameter(JRPdfExporterParameter.OUTPUT_STREAM, servletOutputStream);
						exporter.setParameter(JRPdfExporterParameter.IGNORE_PAGE_MARGINS, Boolean.TRUE);
						resp.setHeader("Content-Disposition", "inline;filename=WaiterWiseItemReport_" + fromDate + "_To_" + toDate + "_" + strUserCode + ".pdf");
						exporter.exportReport();
						servletOutputStream.flush();
						servletOutputStream.close();
					}
					else
					{
						JRExporter exporter = new JRXlsExporter();
						resp.setContentType("application/xlsx");
						exporter.setParameter(JRXlsExporterParameter.JASPER_PRINT_LIST, jprintlist);
						exporter.setParameter(JRXlsExporterParameter.OUTPUT_STREAM, servletOutputStream);
						if(null!=source && source.equals("DayEndMail"))
							exporter.setParameter(JRXlsExporterParameter.OUTPUT_STREAM, new FileOutputStream(filePath));
						exporter.setParameter(JRXlsExporterParameter.IGNORE_PAGE_MARGINS, Boolean.TRUE);
						resp.setHeader("Content-Disposition", "inline;filename=WaiterWiseItemReport_" + fromDate + "_To_" + toDate + "_" + strUserCode + ".xls");
						exporter.exportReport();
						/*servletOutputStream.flush();
						servletOutputStream.close();*/
					}
				}
				else
				{
					resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
					resp.getWriter().append("No Record Found");

				}
	            
	            
			}
			catch(Exception e)
			{
				
			}
		}
}
