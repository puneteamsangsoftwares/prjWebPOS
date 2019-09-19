package com.sanguine.webpos.controller;

import java.io.FileOutputStream;
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

import com.sanguine.base.service.clsSetupService;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.webpos.bean.clsPOSBillItemDtlBean;
import com.sanguine.webpos.bean.clsPOSVoidBillDtl;
import com.sanguine.webpos.bean.clsPOSReportBean;
import com.sanguine.webpos.comparator.clsPOSBillComparator;
import com.sanguine.webpos.model.clsSetupHdModel;
import com.sanguine.webpos.model.clsShiftMasterModel;
import com.sanguine.webpos.sevice.clsPOSMasterService;
import com.sanguine.webpos.sevice.clsPOSReportService;


@Controller
public class clsPOSBillReportController
{

	@Autowired
	private clsGlobalFunctions objGlobalFunctions;

	@Autowired
	private ServletContext servletContext;

	@Autowired
	private clsPOSGlobalFunctionsController objPOSGlobalFunctions;
	
	@Autowired
	private clsPOSMasterService objMasterService;
	
	@Autowired
	private clsPOSReportService objReportService;
	
	@Autowired
	private clsSetupService objSetupService;

	HashMap hmPOSData = new HashMap<String, String>();

	@RequestMapping(value = "/frmPOSBillReport", method = RequestMethod.GET)
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
		List sgNameList = new ArrayList<String>();
		sgNameList.add("ALL");

		model.put("sgNameList", sgNameList);
		clsSetupHdModel objSetupHdModel=null;
		objSetupHdModel=objMasterService.funGetPOSWisePropertySetup(strClientCode,POSCode);
		String gEnableShiftYN=objSetupHdModel.getStrShiftWiseDayEndYN();
		model.put("gEnableShiftYN", gEnableShiftYN);
		// Map objSetupParameter=objSetupService.funGetParameterValuePOSWise(strClientCode, POSCode, "gEnableShiftYN");
		 //model.put("gEnableShiftYN",objSetupParameter.get("gEnableShiftYN").toString());
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
		String posDate = request.getSession().getAttribute("gPOSDate").toString();
		request.setAttribute("POSDate", posDate);

		if ("2".equalsIgnoreCase(urlHits))
		{
			return new ModelAndView("frmPOSBillReport_1", "command", new clsPOSReportBean());
		}
		else if ("1".equalsIgnoreCase(urlHits))
		{
			return new ModelAndView("frmPOSBillReport", "command", new clsPOSReportBean());
		}
		else
		{
			return null;
		}

	}

	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/rptPOSBillReport", method = RequestMethod.POST)
	public void funReport(@ModelAttribute("command") clsPOSReportBean objBean, HttpServletResponse resp, HttpServletRequest req,String source)
	{
		try
		{
			String reportName = servletContext.getRealPath("/WEB-INF/reports/webpos/rptBillWiseSalesReport.jrxml");

			Map hm = objGlobalFunctions.funGetCommonHashMapForJasperReport(objBean, req, resp);
			String strClientCode=req.getSession().getAttribute("gClientCode").toString();
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

			Map mapMultiSettleBills = new HashMap();

			List<clsPOSBillItemDtlBean> listOfBillData = new ArrayList<clsPOSBillItemDtlBean>();

			List list = objReportService.funProcessBillWiseReport( posCode, fromDate, toDate, shiftNo, "liveData");
			if (list.size() > 0)
			{
				for (int i = 0; i < list.size(); i++)
				{
					Object[] objArr = (Object[]) list.get(i);

					String key = objArr[0] + "!" + objArr[1];

					clsPOSBillItemDtlBean obj = new clsPOSBillItemDtlBean();
					if (mapMultiSettleBills.containsKey(key))// billNo
					{
						obj.setStrBillNo(objArr[0].toString());
						obj.setDteBillDate(objArr[1].toString());
						obj.setStrPosName(objArr[2].toString());
						obj.setStrSettelmentMode(objArr[3].toString());
						obj.setDblDiscountAmt(0.00);
						obj.setDblTaxAmt(0.00);
						obj.setDblSettlementAmt(Double.parseDouble(objArr[6].toString()));
						obj.setDblSubTotal(0.00);
						obj.setIntBillSeriesPaxNo(0);
					}
					else
					{
						obj.setStrBillNo(objArr[0].toString());
						obj.setDteBillDate(objArr[1].toString());
						obj.setStrPosName(objArr[2].toString());
						obj.setStrSettelmentMode(objArr[3].toString());
						obj.setDblDiscountAmt(Double.parseDouble(objArr[4].toString()));
						obj.setDblTaxAmt(Double.parseDouble(objArr[5].toString()));
						obj.setDblSettlementAmt(Double.parseDouble(objArr[6].toString()));
						obj.setDblSubTotal(Double.parseDouble(objArr[7].toString()));
						obj.setIntBillSeriesPaxNo(Integer.parseInt(objArr[9].toString()));
					}

					listOfBillData.add(obj);

					if (objArr[8].toString().equalsIgnoreCase("MultiSettle"))
					{
						mapMultiSettleBills.put(key, objArr[0].toString());
					}
				}
			}

			// QFile
			
			list = objReportService.funProcessBillWiseReport( posCode, fromDate, toDate, shiftNo, "qData");
			if (list.size() > 0)
			{
				for (int i = 0; i < list.size(); i++)
				{
					Object[] objArr = (Object[]) list.get(i);

					String key = objArr[0] + "!" + objArr[1];

					clsPOSBillItemDtlBean obj = new clsPOSBillItemDtlBean();
					if (mapMultiSettleBills.containsKey(key))// billNo
					{
						obj.setStrBillNo(objArr[0].toString());
						obj.setDteBillDate(objArr[1].toString());
						obj.setStrPosName(objArr[2].toString());
						obj.setStrSettelmentMode(objArr[3].toString());
						obj.setDblDiscountAmt(0.00);
						obj.setDblTaxAmt(0.00);
						obj.setDblSettlementAmt(Double.parseDouble(objArr[6].toString()));
						obj.setDblSubTotal(0.00);
						obj.setIntBillSeriesPaxNo(0);
					}
					else
					{
						obj.setStrBillNo(objArr[0].toString());
						obj.setDteBillDate(objArr[1].toString());
						obj.setStrPosName(objArr[2].toString());
						obj.setStrSettelmentMode(objArr[3].toString());
						obj.setDblDiscountAmt(Double.parseDouble(objArr[4].toString()));
						obj.setDblTaxAmt(Double.parseDouble(objArr[5].toString()));
						obj.setDblSettlementAmt(Double.parseDouble(objArr[6].toString()));
						obj.setDblSubTotal(Double.parseDouble(objArr[7].toString()));
						obj.setIntBillSeriesPaxNo(Integer.parseInt(objArr[9].toString()));
					}

					listOfBillData.add(obj);

					if (objArr[8].toString().equalsIgnoreCase("MultiSettle"))
					{
						mapMultiSettleBills.put(key, objArr[0].toString());
					}
				}
			}

			// Bill detail data
			List<clsPOSVoidBillDtl> listOfVoidBillData = new ArrayList<clsPOSVoidBillDtl>();

			list = objReportService.funProcessBillWiseReport( posCode, fromDate, toDate, shiftNo, "voidBillData");
			if (list.size() > 0)
			{
				for (int i = 0; i < list.size(); i++)
				{
					Object[] objArr = (Object[]) list.get(i);

					clsPOSVoidBillDtl objVoidBill = new clsPOSVoidBillDtl();
					objVoidBill.setStrBillNo(objArr[0].toString()); // BillNo
					objVoidBill.setDteBillDate(objArr[1].toString()); // Bill
																		// Date
					objVoidBill.setStrWaiterNo(objArr[2].toString()); // Voided
																		// Date
					objVoidBill.setStrTableNo(objArr[3].toString()); // Entry
																		// Time
					objVoidBill.setStrSettlementCode(objArr[4].toString()); // Voided
																			// Time
					objVoidBill.setDblAmount(Double.parseDouble(objArr[5].toString())); // Bill
																						// Amount
					objVoidBill.setStrReasonName(objArr[6].toString()); // Reason
					objVoidBill.setStrClientCode(objArr[7].toString()); // User
																		// Edited
					objVoidBill.setStrUserCreated(objArr[8].toString()); // User
																			// Created
					objVoidBill.setStrRemarks(objArr[9].toString()); // Remarks

					listOfVoidBillData.add(objVoidBill);
				}
			}

			;

			Comparator<clsPOSBillItemDtlBean> posNameComparator = new Comparator<clsPOSBillItemDtlBean>()
			{

				@Override
				public int compare(clsPOSBillItemDtlBean o1, clsPOSBillItemDtlBean o2)
				{
					return o1.getStrPosName().compareToIgnoreCase(o2.getStrPosName());
				}
			};

			Comparator<clsPOSBillItemDtlBean> billDateComparator = new Comparator<clsPOSBillItemDtlBean>()
			{

				@Override
				public int compare(clsPOSBillItemDtlBean o1, clsPOSBillItemDtlBean o2)
				{
					return o2.getDteBillDate().compareToIgnoreCase(o1.getDteBillDate());
				}
			};

			Comparator<clsPOSBillItemDtlBean> billNoComparator = new Comparator<clsPOSBillItemDtlBean>()
			{

				@Override
				public int compare(clsPOSBillItemDtlBean o1, clsPOSBillItemDtlBean o2)
				{
					return o1.getStrBillNo().compareToIgnoreCase(o2.getStrBillNo());
				}
			};

			Collections.sort(listOfBillData, new clsPOSBillComparator(posNameComparator, billDateComparator, billNoComparator));

			hm.put("listOfVoidBillData", listOfVoidBillData);

			JasperDesign jd = JRXmlLoader.load(reportName);
			JasperReport jr = JasperCompileManager.compileReport(jd);

			List<JasperPrint> jprintlist = new ArrayList<JasperPrint>();
			JRBeanCollectionDataSource beanCollectionDataSource = new JRBeanCollectionDataSource(listOfBillData);
			JasperPrint print = JasperFillManager.fillReport(jr, hm, beanCollectionDataSource);
			jprintlist.add(print);
			String filePath = System.getProperty("user.dir")+ "/DayEndMailReports/";
			String extension=".pdf";
			if (!objBean.getStrDocType().equals("PDF"))
         	{
				objBean.setStrDocType("EXCEL");
				extension=".xls";
         	}	
			String fileName = "BillReport_"+ fromDate + "_To_" + toDate + "_" + strUserCode + extension;
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
					resp.setHeader("Content-Disposition", "inline;filename=BillWiseSalesReport_" + fromDate + "_To_" + toDate + "_" + strUserCode + ".pdf");
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
					resp.setHeader("Content-Disposition", "inline;filename=BillWiseSalesReport_" + fromDate + "_To_" + toDate + "_" + strUserCode + ".xls");
					exporter.exportReport();
					servletOutputStream.flush();
					servletOutputStream.close();
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
