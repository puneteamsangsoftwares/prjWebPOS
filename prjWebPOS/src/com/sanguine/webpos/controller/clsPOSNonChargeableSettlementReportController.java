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

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.sanguine.base.service.clsSetupService;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.webpos.bean.clsPOSBillDtl;
import com.sanguine.webpos.bean.clsPOSReportBean;
import com.sanguine.webpos.model.clsReasonMasterModel;
import com.sanguine.webpos.model.clsSetupHdModel;
import com.sanguine.webpos.model.clsShiftMasterModel;
import com.sanguine.webpos.sevice.clsPOSMasterService;
import com.sanguine.webpos.sevice.clsPOSReportService;

@Controller
public class clsPOSNonChargeableSettlementReportController
{

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
	
	Map<String, String> hmPOSData = new HashMap<String,String>();
	Map<String, String> hmReasonData = new HashMap<String,String>();

	@RequestMapping(value = "/frmPOSNonChargableSettlementReport", method = RequestMethod.GET)
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
		model.put("posList", poslist);

		List reasonlist = new ArrayList();
		reasonlist.add("ALL");
		List listOfReasons = objMasterService.funGetAllReasonMaster(strClientCode);
		if(listOfReasons!=null)
		{
			for(int i =0 ;i<listOfReasons.size();i++)
			{
				clsReasonMasterModel objModel = (clsReasonMasterModel) listOfReasons.get(i);
				reasonlist.add(objModel.getStrReasonName());
				hmReasonData.put(objModel.getStrReasonName(), objModel.getStrReasonCode());
			}
		}
		model.put("ReasonMasterList", reasonlist);
		clsSetupHdModel objSetupHdModel=null;
		objSetupHdModel=objMasterService.funGetPOSWisePropertySetup(strClientCode,POSCode);
		String gEnableShiftYN=objSetupHdModel.getStrShiftWiseDayEndYN();
		model.put("gEnableShiftYN", gEnableShiftYN);
		// Map objSetupParameter=objSetupService.funGetParameterValuePOSWise(strClientCode, POSCode, "gEnableShiftYN");
		// model.put("gEnableShiftYN",objSetupParameter.get("gEnableShiftYN").toString());
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
			return new ModelAndView("frmPOSNonChargeableSettlementReport_1", "command", new clsPOSReportBean());
		}
		else if ("1".equalsIgnoreCase(urlHits))
		{
			return new ModelAndView("frmPOSNonChargeableSettlementReport", "command", new clsPOSReportBean());
		}
		else
		{
			return null;
		}
	}

	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/rptNonChargeableSettlementReport", method = RequestMethod.POST)
	public void funReport(@ModelAttribute("command") clsPOSReportBean objBean, HttpServletResponse resp, HttpServletRequest req,String source)
	{

		try
		{
			List<clsPOSBillDtl> listOfNCKOTData = new ArrayList<clsPOSBillDtl>();
			String reportName = servletContext.getRealPath("/WEB-INF/reports/webpos/rptNonChargableKOTReport.jrxml");
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
				posCode = hmPOSData.get(strPOSName).toString();
			}
			hm.put("posCode", posCode);
			String fromDate = hm.get("fromDate").toString();
			String toDate = hm.get("toDate").toString();
			String strUserCode = hm.get("userName").toString();
			String strPOSCode = posCode;
			String shiftNo = "1";

			String type = objBean.getStrDocType();
			String strReasonMaster = objBean.getStrReasonMaster();
			String reasonCode = "ALL";
			if (!strPOSName.equalsIgnoreCase("ALL"))
			{
				posCode = hmPOSData.get(strPOSName);
			}
			if (!strReasonMaster.equalsIgnoreCase("ALL"))
			{
				reasonCode = hmReasonData.get(strReasonMaster);
			}

			listOfNCKOTData = objReportService.funProcessNonChargableKotSettlementReport(posCode,fromDate,toDate,reasonCode);

			JasperDesign jd = JRXmlLoader.load(reportName);
			JasperReport jr = JasperCompileManager.compileReport(jd);

			List<JasperPrint> jprintlist = new ArrayList<JasperPrint>();

			JRBeanCollectionDataSource beanCollectionDataSource = new JRBeanCollectionDataSource(listOfNCKOTData);
			JasperPrint print = JasperFillManager.fillReport(jr, hm, beanCollectionDataSource);
			jprintlist.add(print);
			String filePath = System.getProperty("user.dir")+ "/DayEndMailReports/";
			String extension=".pdf";
			if (!objBean.getStrDocType().equals("PDF"))
			{
				objBean.setStrDocType("EXCEL");
				extension=".xls";
			}	
			String fileName = "NonChargeableKOTReport_"+ fromDate + "_To_" + toDate + "_" + strUserCode + extension;
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
					resp.setHeader("Content-Disposition", "inline;filename=NonChargeableKOTReport_" + fromDate + "_To_" + toDate + "_" + strUserCode + ".pdf");
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
					resp.setHeader("Content-Disposition", "inline;filename=NonChargeableKOTReport_" + fromDate + "_To_" + toDate + "_" + strUserCode + ".xls");
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
		catch (Exception ex)
		{
			ex.printStackTrace();
		}

		System.out.println("Hi");

	}
}
