package com.sanguine.webpos.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import net.sf.jasperreports.engine.JREmptyDataSource;
import net.sf.jasperreports.engine.JRExporter;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.design.JasperDesign;
import net.sf.jasperreports.engine.export.JRPdfExporter;
import net.sf.jasperreports.engine.export.JRPdfExporterParameter;
import net.sf.jasperreports.engine.export.JRXlsExporter;
import net.sf.jasperreports.engine.export.JRXlsExporterParameter;
import net.sf.jasperreports.engine.xml.JRXmlLoader;
import net.sf.jasperreports.view.JRViewer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sanguine.base.service.clsBaseServiceImpl;
import com.sanguine.base.service.clsSetupService;
import com.sanguine.base.service.intfBaseService;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.webpos.bean.clsPOSPrinterSetUpMasterBean;
import com.sanguine.webpos.model.clsAreaMasterModel;
import com.sanguine.webpos.model.clsPOSPrinterSetUpMasterModel;
import com.sanguine.webpos.model.clsPOSPrinterSetUpMasterModel_ID;
import com.sanguine.webpos.sevice.clsPOSMasterService;
import com.sanguine.webpos.util.clsPOSUtilityController;

@Controller
public class clsPOSPrinterSetUpMasterController
{
	@Autowired
	private clsPOSGlobalFunctionsController objPOSGlobal;

	@Autowired
	clsGlobalFunctions objGlobalFunctions;

	@Autowired
	clsPOSMasterService objMasterService;

	@Autowired
	clsPOSUtilityController obUtility;

	@Autowired
	intfBaseService obBaseService;

	@Autowired
	private clsBaseServiceImpl objBaseServiceImpl;

	@Autowired
	private clsGlobalFunctionsService objGlobalFunctionsService;

	@Autowired
	clsPOSUtilityController objUtilityController;

	@Autowired
	clsPOSUtilityController obUtilityController;

	@Autowired
	private ServletContext servletContext;
	@Autowired
	private clsSetupService objSetupService;
	@Autowired
	intfBaseService objBaseService;
	
	@Autowired
	private clsGlobalFunctions objGlobal;

	// Open POSPrinterSetUpMaster
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/frmPrinterSetup", method = RequestMethod.GET)
	public ModelAndView funOpenForm(@ModelAttribute("command") @Valid clsPOSPrinterSetUpMasterBean objBean, BindingResult result, Map<String, Object> model, HttpServletRequest request) throws Exception
	{
		Map mapOfPrinterList = new HashMap();
		Map<String, String> areaList = new HashMap<>();
		Map<String, String> costCenterList = new HashMap<>();
		Map<String, String> posList = new HashMap<>();
		String clientCode = request.getSession().getAttribute("gClientCode").toString();

		List listArea = objMasterService.funLoadClientWiseArea(clientCode);
		// Area List
		areaList.put("All", "All");

		if (null != listArea)
		{
			for (int cnt = 0; cnt < listArea.size(); cnt++)
			{
				clsAreaMasterModel obModel = (clsAreaMasterModel) listArea.get(cnt);
				areaList.put(obModel.getStrAreaCode(), obModel.getStrAreaName());

			}
		}
		// POS LIST
		List listPOS = objMasterService.funFullPOSCombo(clientCode);
		posList.put("All", "All");

		if (null != listPOS)
		{
			for (int cnt = 0; cnt < listPOS.size(); cnt++)
			{
				Object Obj[] = (Object[]) listPOS.get(cnt);
				posList.put(Obj[0].toString(), Obj[1].toString());

			}
		}

		List<String> printerList = new ArrayList<String>();
		mapOfPrinterList = objUtilityController.funGetPrinterList();
		printerList = (ArrayList) mapOfPrinterList.get("printerList");

		List listCostCenter = objMasterService.funFullCostCenterCombo(clientCode);
		if (null != listCostCenter)
		{
			for (int cnt = 0; cnt < listCostCenter.size(); cnt++)
			{
				Object obj[] = (Object[]) listCostCenter.get(cnt);
				costCenterList.put(obj[0].toString(), obj[1].toString());

			}
		}

		model.put("costCenterList", costCenterList);
		model.put("printerList", printerList);
		model.put("areaList", areaList);
		model.put("posList", posList);

		return new ModelAndView("frmPrinterSetup", "command", new clsPOSPrinterSetUpMasterBean());
	}

	// Load Master Data On Form
	@RequestMapping(value = "/frmPOSPrinterSetUpMaster1", method = RequestMethod.POST)
	public @ResponseBody clsPOSPrinterSetUpMasterModel funLoadMasterData(HttpServletRequest request)
	{
		String sql = "";

		List listModel = (List) objGlobalFunctionsService.funGetList(sql,"");
		clsPOSPrinterSetUpMasterModel objPOSPrinterSetUpMaster = new clsPOSPrinterSetUpMasterModel();
		return objPOSPrinterSetUpMaster;
	}

	// Save or Update POSPrinterSetUpMaster
	@RequestMapping(value = "/savePOSPrinterSetUpMaster", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsPOSPrinterSetUpMasterBean objBean, BindingResult result, HttpServletRequest req)
	{

		String urlHits = "1";
		try
		{
			List<clsPOSPrinterSetUpMasterBean> listOfDataObject = objBean.getListObjPrinterDataBean();
			urlHits = req.getParameter("saddr").toString();
			String clientCode = req.getSession().getAttribute("gClientCode").toString();
			String webStockUserCode = req.getSession().getAttribute("gUserCode").toString();
			if (listOfDataObject != null)
			{
				for (int i = 0; i < listOfDataObject.size(); i++)
				{
					clsPOSPrinterSetUpMasterBean objPrinterData = listOfDataObject.get(i);

					String posCode = objPrinterData.getStrPOSCode();
					String areaCode = objPrinterData.getStrAreaCode();
					String costCenterCode = objPrinterData.getStrCostCenterCode();
					clsPOSPrinterSetUpMasterModel objModel = new clsPOSPrinterSetUpMasterModel(new clsPOSPrinterSetUpMasterModel_ID(posCode, areaCode, costCenterCode, clientCode));
					objModel.setStrPOSCode(objPrinterData.getStrPOSName());
					objModel.setStrCostCenterCode(objPrinterData.getStrCostCenterCode());
					objModel.setStrPrimaryPrinterPort(objPrinterData.getStrPrimaryPrinterPort());
					objModel.setStrSecondaryPrinterPort(objPrinterData.getStrSecondaryPrinterPort());
					objModel.setDteDateCreated(objGlobalFunctions.funGetCurrentDateTime("yyyy-MM-dd"));
					objModel.setDteDateEdited(objGlobalFunctions.funGetCurrentDateTime("yyyy-MM-dd"));
					objModel.setStrUserCreated(webStockUserCode);
					objModel.setStrUserEdited(webStockUserCode);
					objModel.setStrPrinterType("Cost Center");
					objModel.setStrDataPostFlag("N");

					objModel.setStrPrintOnBothPrintersYN(objGlobalFunctions.funIfNull(objPrinterData.getStrPrintOnBothPrintersYN(), "N", "Y"));

					objMasterService.funSavePrinterSetupMaster(objModel);
				     req.getSession().setAttribute("success", true);
					req.getSession().setAttribute("successMessage", " " + "Data Saved SuccessFully");
					String sql = "update tblmasteroperationstatus set dteDateEdited='" + objGlobal.funGetCurrentDateTime("yyyy-MM-dd") + "'  where strTableName='Printer Setup' " + " and strClientCode='" + clientCode + "'";
					objBaseServiceImpl.funExecuteUpdate(sql, "sql");

					//return new ModelAndView("redirect:/frmPrinterSetup.html");

				}

			}

			return new ModelAndView("redirect:/frmPrinterSetup.html");

		}
		catch (Exception ex)
		{
			urlHits = "1";
			ex.printStackTrace();
			return new ModelAndView("redirect:/frmFail.html");
		}
	}

	// Pratiksha 22-04-2019
	@RequestMapping(value = "/testPriPrinterStatus", method = RequestMethod.GET)
	public @ResponseBody Map funTestPrinterStatus(@RequestParam("PrinterName") String printerName, HttpServletRequest req) throws Exception
	{
		String posCode = req.getSession().getAttribute("loginPOS").toString();
		String userCode = req.getSession().getAttribute("gUserCode").toString();
		String status = obUtilityController.funTestPrint(printerName, userCode, posCode);
		Map hmStatus = new HashMap();
		hmStatus.put("Status", status);
		return hmStatus;
	}

	// Pratiksha 13-05-2019
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "/frmTestPrinter", method = RequestMethod.GET)
	public void funTestPrinterForJasper(@RequestParam("PrinterName") String PrinterName, @RequestParam("CostCenterName") String CostCenterName, HttpServletResponse resp, HttpServletRequest request) throws Exception
	{
		String webStockUserCode = request.getSession().getAttribute("gUserCode").toString();
		String clientCode = request.getSession().getAttribute("gClientCode").toString();
		String posCode = request.getSession().getAttribute("loginPOS").toString();
		String strDocType = "PDF";
		//HashMap hm = new HashMap();
		Map<String,Object> map = new HashMap<String,Object>();

		map.put("User Name", webStockUserCode);
		map.put("POS Name", posCode);
		map.put("Cost Center", CostCenterName);
		map.put("Printer Name", PrinterName);
		

		String reportName = servletContext.getRealPath("/WEB-INF/reports/webpos/rptTestPrinterForJasper.jrxml");

		JasperDesign jd = JRXmlLoader.load(reportName);
		JasperReport jr = JasperCompileManager.compileReport(jd);
		List<JasperPrint> jprintlist = new ArrayList<JasperPrint>();
		//JRBeanCollectionDataSource beanCollectionDataSource = new JRBeanCollectionDataSource();
		JasperPrint print = JasperFillManager.fillReport(jr, map,   new JREmptyDataSource());
		jprintlist.add(print);
		String filePath = System.getProperty("user.dir") + "/DayEndMailReports/";
		String extension = ".pdf";
		if (!strDocType.equals("PDF"))
		{
			strDocType = "EXCEL";
			extension = ".xls";
		}

		if (jprintlist.size() > 0)
		{
			ServletOutputStream servletOutputStream = resp.getOutputStream();
			if (strDocType.equals("PDF"))
			{
				JRExporter exporter = new JRPdfExporter();
				resp.setContentType("application/pdf");
				exporter.setParameter(JRPdfExporterParameter.JASPER_PRINT_LIST, jprintlist);
				exporter.setParameter(JRPdfExporterParameter.OUTPUT_STREAM, servletOutputStream);
				exporter.setParameter(JRPdfExporterParameter.IGNORE_PAGE_MARGINS, Boolean.TRUE);
				resp.setHeader("Content-Disposition", "inline;filename=GenrateKOTJasperReport_" + webStockUserCode + ".pdf");

				exporter.exportReport();
				JRViewer viewer = new JRViewer(print);
				viewer.setVisible(true);
				servletOutputStream.flush();
				servletOutputStream.close();
			}
			else
			{
				JRExporter exporter = new JRXlsExporter();
				resp.setContentType("application/xlsx");
				exporter.setParameter(JRXlsExporterParameter.JASPER_PRINT_LIST, jprintlist);
				exporter.setParameter(JRXlsExporterParameter.OUTPUT_STREAM, servletOutputStream);
				exporter.setParameter(JRXlsExporterParameter.IGNORE_PAGE_MARGINS, Boolean.TRUE);
				resp.setHeader("Content-Disposition", "inline;filename=GenrateKOTJasperReport_" + webStockUserCode + ".xls");
				exporter.exportReport();
				JRViewer viewer = new JRViewer(print);
				viewer.setVisible(true);
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
	
}
