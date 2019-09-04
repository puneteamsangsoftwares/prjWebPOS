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

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.POSGlobal.controller.clsBillDtl;
import com.POSReport.controller.clsCreditBillReportComparator;
import com.sanguine.webpos.bean.clsPOSBillDtl;
import com.sanguine.base.service.clsSetupService;
import com.sanguine.base.service.intfBaseService;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.webpos.bean.clsPOSReportBean;
import com.sanguine.webpos.model.clsShiftMasterModel;
import com.sanguine.webpos.sevice.clsPOSMasterService;
import com.sanguine.webpos.sevice.clsPOSReportService;

@Controller
public class clsDebtorAsOnReportController
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
	private intfBaseService objBaseService;

	@Autowired
	private clsSetupService objSetupService;

	HashMap<String, String> hmPOSData = new HashMap<String, String>();

	@RequestMapping(value = "/frmDebtorsAsOnReport", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model, HttpServletRequest request) throws Exception
	{
		String strClientCode = request.getSession().getAttribute("gClientCode").toString();
		String POSCode = request.getSession().getAttribute("loginPOS").toString();
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
		List<String> poslist = new ArrayList<String>();
		poslist.add("ALL");
		List listOfPos = objMasterService.funFullPOSCombo(strClientCode);
		if (listOfPos != null)
		{
			for (int i = 0; i < listOfPos.size(); i++)
			{
				Object[] obj = (Object[]) listOfPos.get(i);
				poslist.add(obj[1].toString());
				hmPOSData.put(obj[1].toString(), obj[0].toString());
			}
		}
		model.put("posList", poslist);
		List sgNameList = new ArrayList<String>();
		sgNameList.add("ALL");

		model.put("sgNameList", sgNameList);

		String posDate = request.getSession().getAttribute("gPOSDate").toString();
		request.setAttribute("POSDate", posDate);

		Map objSetupParameter = objSetupService.funGetParameterValuePOSWise(strClientCode, POSCode, "gEnableShiftYN");
		model.put("gEnableShiftYN", objSetupParameter.get("gEnableShiftYN").toString());
		// Shift
		List<String> shiftList = new ArrayList();
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
		if ("2".equalsIgnoreCase(urlHits))
		{
			return new ModelAndView("frmDebtorsAsOnReport_1", "command", new clsPOSReportBean());
		}
		else if ("1".equalsIgnoreCase(urlHits))
		{
			return new ModelAndView("frmDebtorsAsOnReport.html", "command", new clsPOSReportBean());
		}
		else
		{
			return null;
		}

	}

	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/rptDebtorsAsOnReport", method = RequestMethod.POST)
	public void funReport(@ModelAttribute("command") clsPOSReportBean objBean, HttpServletResponse resp, HttpServletRequest req, String source)
	{
		try
		{
			String reportName = servletContext.getRealPath("/WEB-INF/reports/webpos/rptDebtorAsOn.jrxml");
			String POSCode = req.getSession().getAttribute("loginPOS").toString();
			String strClientCode = req.getSession().getAttribute("gClientCode").toString();
			Map hm = objGlobalFunctions.funGetCommonHashMapForJasperReport(objBean, req, resp);
			String strPOSName = objBean.getStrPOSName();
			String posCode = "ALL";
			List listOfPos = objMasterService.funFullPOSCombo(strClientCode);
			if (listOfPos != null)
			{
				for (int i = 0; i < listOfPos.size(); i++)
				{
					Object[] obj = (Object[]) listOfPos.get(i);
					hmPOSData.put(obj[1].toString(), obj[0].toString());
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
			String shiftNo = "ALL";
			StringBuilder sbSqlLive = new StringBuilder();
			StringBuilder sbSqlQFile = new StringBuilder();

			List<clsPOSBillDtl> listOfCreditBillReport = new ArrayList<clsPOSBillDtl>();

			Map objSetupParameter = objSetupService.funGetParameterValuePOSWise(strClientCode, POSCode, "gEnableShiftYN");
			if (objSetupParameter.get("gEnableShiftYN").toString().equals("Y"))
			{
				shiftNo = objBean.getStrShiftCode();
			}
			hm.remove("shiftNo");
			hm.put("shiftNo", shiftNo);

			/*
			 * boolean isDayEndHappend = objUtility2.isDayEndHappened(toDate);
			 * if (!isDayEndHappend) { hm.put("isDayEndHappend",
			 * "DAY END NOT DONE."); }
			 */
			String sbSqlFilters = "";
			sbSqlLive.append("SELECT a.strCustomerCode, a.strCustomerName,if(CreditAmt is null,DebitAmt,DebitAmt - CreditAmt) Outstanding\n" + "FROM \n" + "(\n" + "SELECT a.strPOSCode,a.strCustomerCode,d.strCustomerName, SUM(b.dblSettlementAmt) DebitAmt\n" + "FROM tblbillhd a,tblbillsettlementdtl b,tblsettelmenthd c,tblcustomermaster d\n" + "WHERE a.strBillNo=b.strBillNo AND b.strSettlementCode=c.strSettelmentCode \n" + "AND DATE(a.dtebilldate)= DATE(b.dtebilldate) AND a.strClientCode=b.strClientCode \n" + "AND c.strSettelmentType='Credit' AND a.strCustomerCode=d.strCustomerCode \n" + "AND DATE(a.dteBillDate) <= '" + toDate + "'\n" + "GROUP BY a.strCustomerCode) AS a\n" + "left outer join  \n" + "(\n" + "SELECT c.strCustomerCode, ifnull(SUM(b.dblReceiptAmt),0) CreditAmt\n" + "FROM tblbillhd a,tblqcreditbillreceipthd b,tblcustomermaster c\n" + "WHERE a.strBillNo=b.strBillNo AND DATE(a.dteBillDate)= DATE(b.dteBillDate)\n" + " AND a.strClientCode=b.strClientCode AND a.strCustomerCode=c.strCustomerCode \n" + " AND DATE(b.dteReceiptDate) <= '" + toDate + "'\n" + "GROUP BY c.strCustomerCode) AS b\n" + "on a.strCustomerCode = b.strCustomerCode\n");

			sbSqlQFile.append("SELECT a.strCustomerCode, a.strCustomerName,if(CreditAmt is null,DebitAmt,DebitAmt - CreditAmt) Outstanding\n" + "FROM \n" + "(\n" + "SELECT a.strPOSCode,a.strCustomerCode,d.strCustomerName, SUM(b.dblSettlementAmt) DebitAmt\n" + "FROM tblqbillhd a,tblqbillsettlementdtl b,tblsettelmenthd c,tblcustomermaster d\n" + "WHERE a.strBillNo=b.strBillNo AND b.strSettlementCode=c.strSettelmentCode \n" + "AND DATE(a.dtebilldate)= DATE(b.dtebilldate) AND a.strClientCode=b.strClientCode \n" + "AND c.strSettelmentType='Credit' AND a.strCustomerCode=d.strCustomerCode \n" + "AND DATE(a.dteBillDate) <= '" + toDate + "'\n" + "GROUP BY a.strCustomerCode) AS a\n" + "left outer join  \n" + "(\n" + "SELECT c.strCustomerCode, ifnull(SUM(b.dblReceiptAmt),0) CreditAmt\n" + "FROM tblqbillhd a,tblqcreditbillreceipthd b,tblcustomermaster c\n" + "WHERE a.strBillNo=b.strBillNo AND DATE(a.dteBillDate)= DATE(b.dteBillDate)\n" + " AND a.strClientCode=b.strClientCode AND a.strCustomerCode=c.strCustomerCode \n" + " AND DATE(b.dteReceiptDate) <= '" + toDate + "'\n" + "GROUP BY c.strCustomerCode) AS b\n" + "on a.strCustomerCode = b.strCustomerCode\n");
			sbSqlFilters = " Order by a.strCustomerName";

			Map<String, clsPOSBillDtl> hmCustomerDtl = new HashMap<String, clsPOSBillDtl>();
			clsPOSBillDtl objBillBean = null;
			List listLiveData = objBaseService.funGetList(sbSqlLive, "sql");

			if (listLiveData.size() > 0)
			{
				for (int i = 0; i < listLiveData.size(); i++)
				{
					Object[] obj = (Object[]) listLiveData.get(i);
					if (hmCustomerDtl.containsKey(obj[0].toString()))
					{
						objBillBean = hmCustomerDtl.get(obj[0].toString());
						objBillBean.setDblBalanceAmt(objBillBean.getDblBalanceAmt() + Double.parseDouble(obj[2].toString()));

					}
					else
					{

						objBillBean.setStrCustomerCode(obj[0].toString());
						objBillBean.setStrCustomerName(obj[1].toString()); // Customer
																			// Name
						objBillBean.setDblBalanceAmt(Double.parseDouble(obj[2].toString()));

						hmCustomerDtl.put(obj[0].toString(), objBillBean);
					}
				}
			}

			List listSqlQFile = objBaseService.funGetList(sbSqlQFile, "sql");

			if (listSqlQFile.size() > 0)
			{
				for (int i = 0; i < listSqlQFile.size(); i++)
				{
					Object[] obj = (Object[]) listSqlQFile.get(i);

					if (hmCustomerDtl.containsKey(obj[0].toString()))
					{
						objBillBean = hmCustomerDtl.get(obj[0].toString());
						objBillBean.setDblBalanceAmt(objBillBean.getDblBalanceAmt() + Double.parseDouble(obj[2].toString()));

					}
					else
					{

						objBillBean.setStrCustomerCode(obj[0].toString());
						objBillBean.setStrCustomerName(obj[1].toString()); // Customer
																			// Name
						objBillBean.setDblBalanceAmt(Double.parseDouble(obj[2].toString()));

						hmCustomerDtl.put(obj[0].toString(), objBillBean);
					}

				}
			}

			for (Map.Entry<String, clsPOSBillDtl> entryOp : hmCustomerDtl.entrySet())
			{
				clsPOSBillDtl objBillDtl = entryOp.getValue();
				if (objBillDtl.getDblBalanceAmt() > 0)
				{
					listOfCreditBillReport.add(objBillDtl);
				}
			}

			 Comparator<clsPOSBillDtl> customerComparator = new Comparator<clsPOSBillDtl>()
					    {

						@Override
						public int compare(clsPOSBillDtl o1, clsPOSBillDtl o2)
						{
						    return o1.getStrCustomerCode().compareToIgnoreCase(o2.getStrCustomerCode());
						}
					    };

					  //  Collections.sort(listOfCreditBillReport, new clsCreditBillReportComparator(customerComparator));
					    
					    

			hm.put("listOfCreditBillReport", listOfCreditBillReport);
			List list = new ArrayList();
			list.add("1");
			JasperDesign jd = JRXmlLoader.load(reportName);
			JasperReport jr = JasperCompileManager.compileReport(jd);
			List<JasperPrint> jprintlist = new ArrayList<JasperPrint>();
			JRBeanCollectionDataSource beanCollectionDataSource = new JRBeanCollectionDataSource(list);
			JasperPrint print = JasperFillManager.fillReport(jr, hm, beanCollectionDataSource);
			jprintlist.add(print);
			String filePath = System.getProperty("user.dir") + "/DayEndMailReports/";
			String extension = ".pdf";
			if (!objBean.getStrDocType().equals("PDF"))
			{
				objBean.setStrDocType("EXCEL");
				extension = ".xls";
			}
			String fileName = "DebtorReport_" + fromDate + "_To_" + toDate + "_" + strUserCode + extension;
			filePath = filePath + "/" + fileName;
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
					resp.setHeader("Content-Disposition", "inline;filename=DebtorReport_" + fromDate + "_To_" + toDate + "_" + strUserCode + ".pdf");
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
					if (null != source && source.equals("DayEndMail"))
						exporter.setParameter(JRXlsExporterParameter.OUTPUT_STREAM, new FileOutputStream(filePath));
					exporter.setParameter(JRXlsExporterParameter.IGNORE_PAGE_MARGINS, Boolean.TRUE);
					resp.setHeader("Content-Disposition", "inline;filename=DebtorReport_" + fromDate + "_To_" + toDate + "_" + strUserCode + ".xls");
					exporter.exportReport();
					/*
					 * servletOutputStream.flush(); servletOutputStream.close();
					 */
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
