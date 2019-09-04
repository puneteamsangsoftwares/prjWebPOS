package com.sanguine.webpos.controller;

import java.io.FileOutputStream;
import java.util.ArrayList;
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

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.sanguine.base.service.clsSetupService;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.webpos.bean.clsPOSBillItemDtlBean;
import com.sanguine.webpos.bean.clsPOSReportBean;
import com.sanguine.webpos.model.clsShiftMasterModel;
import com.sanguine.webpos.model.clsSubGroupMasterHdModel;
import com.sanguine.webpos.sevice.clsPOSMasterService;
import com.sanguine.webpos.sevice.clsPOSReportService;

@Controller
public class clsPOSDailySalesReportController {

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
	
	Map<String,String> hmPOSData=new HashMap<String, String>();
	 
	 @RequestMapping(value = "/frmPOSDailySalesReport", method = RequestMethod.GET)
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
			List poslist = new ArrayList();
			poslist.add("All");
			
			List listOfPos = objMasterService.funFullPOSCombo(strClientCode);
			if(listOfPos!=null)
			{
				for(int i =0 ;i<listOfPos.size();i++)
				{
					Object[] obj = (Object[]) listOfPos.get(i);
					poslist.add( obj[1].toString());
					hmPOSData.put( obj[1].toString(), obj[0].toString());
				}
			}
			model.put("posList",poslist);
			
			Map objSetupParameter=objSetupService.funGetParameterValuePOSWise(strClientCode, POSCode, "gEnableShiftYN");
			model.put("gEnableShiftYN",objSetupParameter.get("gEnableShiftYN").toString());
			
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
				return new ModelAndView("frmPOSDailySalesReport_1","command", new clsPOSReportBean());
			}else if("1".equalsIgnoreCase(urlHits)){
				return new ModelAndView("frmPOSDailySalesReport","command", new clsPOSReportBean());
			}else {
				return null;
			}
			 
		}
		
		@SuppressWarnings("rawtypes")
		@RequestMapping(value = "/rptPOSDailySalesReport", method = RequestMethod.POST)	
		public void funReport(@ModelAttribute("command") clsPOSReportBean objBean, HttpServletResponse resp,HttpServletRequest req,String source)
		{
			String userCode=req.getSession().getAttribute("gUserCode").toString();
			
			try
			{
				String reportName = servletContext.getRealPath("/WEB-INF/reports/webpos/rptDailySalesReport.jrxml");
				String POSCode=req.getSession().getAttribute("loginPOS").toString();	

				String strClientCode=req.getSession().getAttribute("gClientCode").toString();
				Map hm = objGlobalFunctions.funGetCommonHashMapForJasperReport(objBean, req, resp);
				String strPOSName = objBean.getStrPOSName();
				String posCode = "ALL";
				List listOfPos = objMasterService.funFullPOSCombo(strClientCode);
				if(listOfPos!=null)
				{
					for(int i =0 ;i<listOfPos.size();i++)
					{
						Object[] obj = (Object[]) listOfPos.get(i);
						hmPOSData.put( obj[1].toString(), obj[0].toString());
					}
				}
				if (!strPOSName.equalsIgnoreCase("ALL"))
				{
					posCode = (String) hmPOSData.get(strPOSName);
				}
				hm.put("posCode", posCode);
				
				String fromDate = hm.get("fromDate").toString();
				String toDate = hm.get("toDate").toString();
				String strUserCode = hm.get("userName").toString();
				String strPOSCode = posCode;
				String strShiftNo = "ALL",enableShiftYN="N";
				Map objSetupParameter=objSetupService.funGetParameterValuePOSWise(strClientCode, posCode, "gEnableShiftYN");
				if (!strPOSName.equalsIgnoreCase("ALL"))
				{
					
				if(objSetupParameter.get("gEnableShiftYN").toString().equals("Y"))
				{
					strShiftNo=objBean.getStrShiftCode();
					enableShiftYN=objSetupParameter.get("gEnableShiftYN").toString();

				}
				}
				hm.remove("shiftNo");
				hm.put("shiftNo", strShiftNo);
				hm.put("shiftCode", strShiftNo);
				List<clsPOSBillItemDtlBean> listOfDailySaleData = new ArrayList<clsPOSBillItemDtlBean>();
				
	            listOfDailySaleData = objReportService.funProcessDailySalesReport(posCode,fromDate,toDate,strShiftNo,userCode,enableShiftYN);
				
	            JasperDesign jd = JRXmlLoader.load(reportName);
				JasperReport jr = JasperCompileManager.compileReport(jd);
				List<JasperPrint> jprintlist = new ArrayList<JasperPrint>();
				JRBeanCollectionDataSource beanCollectionDataSource = new JRBeanCollectionDataSource(listOfDailySaleData);
				JasperPrint print = JasperFillManager.fillReport(jr, hm, beanCollectionDataSource);
				jprintlist.add(print);
				String filePath = System.getProperty("user.dir")+ "/DayEndMailReports/";
				String extension=".pdf";
				if (!objBean.getStrDocType().equals("PDF"))
				{
					objBean.setStrDocType("EXCEL");
					extension=".xls";
				}	
				String fileName = "DailySalesReport_"+ fromDate + "_To_" + toDate + "_" + strUserCode + extension;
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
						resp.setHeader("Content-Disposition", "inline;filename=DailySalesReport_" + fromDate + "_To_" + toDate + "_" + strUserCode + ".pdf");
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
						resp.setHeader("Content-Disposition", "inline;filename=DailySalesReport_" + fromDate + "_To_" + toDate + "_" + strUserCode + ".xls");
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
			catch(Exception ex)
			{
				ex.printStackTrace();
			}
		    	
		}
		
		
}
