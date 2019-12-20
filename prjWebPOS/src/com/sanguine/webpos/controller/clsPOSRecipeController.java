package com.sanguine.webpos.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.mysql.jdbc.Connection;
import com.sanguine.base.service.intfBaseService;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.model.clsPropertySetupModel;
import com.sanguine.webpos.bean.clsPOSReportBean;
import com.sanguine.webpos.bean.clsRecipeMasterBean;
import com.sanguine.webpos.model.clsSetupHdModel;
import com.sanguine.webpos.sevice.clsPOSMasterService;


@Controller
public class clsPOSRecipeController
{


		@Autowired
		private clsPOSMasterService objMasterService;


		@Autowired
		private ServletContext servletContext;
		
		@Autowired
		private intfBaseService objBaseService; 


	@RequestMapping(value = "/frmPOSRecipeListReport", method = RequestMethod.GET)
	public ModelAndView frmPOSRecipesList(Map<String, Object> model, HttpServletRequest request) {
		String urlHits = "1";
		String strClientCode = request.getSession().getAttribute("gClientCode").toString();
		String POSCode=request.getSession().getAttribute("loginPOS").toString();	
		
		try {
			urlHits = request.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		
		model.put("urlHits", urlHits);

		HashMap hmPOSData = new HashMap<String, String>();
		hmPOSData.put("All", "All");
		List listOfPos;
		try
		{
			listOfPos = objMasterService.funFillPOSCombo(strClientCode);
			
			if(listOfPos!=null)
			{
				for(int i =0 ;i<listOfPos.size();i++)
				{
					Object[] obj = (Object[]) listOfPos.get(i);
				
					hmPOSData.put( obj[1].toString(), obj[0].toString());
				}
			}
		}
		catch (Exception e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		model.put("posList", hmPOSData);
		
		if ("2".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmPOSRecipeListReport_1", "command", new clsPOSReportBean());
		} else {
			return new ModelAndView("frmPOSRecipeListReport", "command", new clsPOSReportBean());
		}

	}
	
	@RequestMapping(value = "/rptPOSRecipeList", method = RequestMethod.GET)
	private void funReport(@ModelAttribute("command") clsPOSReportBean objBean, HttpServletResponse resp, HttpServletRequest req) {
		String itemCode = objBean.getStrItemCode();
		//String type = objBean.getStrDocType();
		//String rateFrom =objBean.getStrShowBOM();
		funCallReport(itemCode, resp, req,objBean);
	}

	private void funCallReport(String itemCode, HttpServletResponse resp, HttpServletRequest req,clsPOSReportBean obReportjBean) {
		try {
			clsGlobalFunctions objGlobal = new clsGlobalFunctions();
			Connection con = objGlobal.funGetConnection(req);
			
			String clientCode=req.getSession().getAttribute("gClientCode").toString();
			String userCode=req.getSession().getAttribute("gUserCode").toString();
			String posCode=req.getSession().getAttribute("gPOSCode").toString();
			//clsPropertySetupModel objSetup = objSetupMasterService.funGetObjectPropertySetup(propertyCode, clientCode);
        ///prjWebPOS/WebRoot/WEB-INF/reports/webpos/rptRecipesList.jrxml
			String reportName = servletContext.getRealPath("/WEB-INF/reports/webpos/rptRecipesList.jrxml");
			String imagePath = servletContext.getRealPath("/resources/images/company_Logo.png");
			clsSetupHdModel objSetup=objMasterService.funGetPOSWisePropertySetup(clientCode,posCode);
			//String recipeListPrice=objSetup.getStrRecipeListPrice();
			String strReceipePriceClmn="ifnull(cp.dblCostRM/cp.dblRecipeConversion,0)";
			/*if(recipeListPrice.equalsIgnoreCase("Received"))
			{
				strReceipePriceClmn="ifnull(cp.dblCostRM/cp.dblReceiveConversion,0)";
			}*/
			
			StringBuilder sqlDtlQuery = new StringBuilder(" SELECT h.strRecipeCode AS strBOMCode,h.strItemCode AS strParentCode, " 
					+" p.strUOM AS ParentstrUOM, p.strItemName AS ParentProdName, "
					+"  IFNULL(lp.strPosName,'') AS parentLocation, d.strChildItemCode, "
  					+" IFNULL(cp.strItemName,'') AS childProductName, IFNULL(cp.strRecipeUOM,'') AS childUOM, " 
  					+" d.dblQuantity, IFNULL(cp.dblPurchaseRate/ cp.dblReceivedConversion,0) AS price, "
	  				+" IFNULL((cp.dblPurchaseRate / cp.dblRecipeConversion)* d.dblQuantity,0) AS value,d.dblQuantity, "
	   				+" IFNULL((d.dblQuantity/ cp.dblRecipeConversion),0) AS InitialWt, IFNULL(cp.strRawMaterial,'N'),"
	   				+ " h.dteFromDate,h.dteToDate "
					+" FROM tblrecipehd h "
					+" INNER JOIN tblrecipedtl AS d ON h.strRecipeCode = d.strRecipeCode AND d.strClientCode='"+clientCode+"' "
					+" LEFT OUTER "
					+" JOIN tblitemmaster p ON h.strItemCode = p.strItemCode AND p.strClientCode='"+clientCode+"' "
					+" LEFT OUTER "
					+" JOIN tblitemmaster AS cp ON d.strChildItemCode = cp.strItemCode AND cp.strClientCode='"+clientCode+"' "
					+" LEFT OUTER "
					+" JOIN tblposmaster lp ON lp.strPosCode = d.strPOSCode AND lp.strClientCode='"+clientCode+"' "
					+" WHERE h.strClientCode='"+clientCode+"' ");
			
			if (!itemCode.equals("")) {
				sqlDtlQuery .append(" and h.strItemCode='" + itemCode + "'  ");
			}
			
			String SGCode = "";
			String strSGCodes[] = obReportjBean.getStrSGCode().split(",");
			for (int i = 0; i < strSGCodes.length; i++) {
				if (SGCode.length() > 0) {
					SGCode = SGCode + " or p.strSubGroupCode='" + strSGCodes[i] + "' ";
				} else {
					SGCode = " p.strSubGroupCode='" + strSGCodes[i] + "' ";
				}

			}

			sqlDtlQuery.append(" and " + "(" + SGCode + ")");
			
			List<clsRecipeMasterBean> listDtlBean=new ArrayList<clsRecipeMasterBean>(); 
			List listChildRate = objBaseService.funGetList(sqlDtlQuery, "sql");
			String strParentCode="",finalwt="";
			if(listChildRate.size()>0)
			{
				for(int i=0;i<listChildRate.size();i++)
				{
					
					Object[] obj=(Object[])listChildRate.get(i);
					double bomrate =Double.parseDouble(obj[9].toString());
					double bomAmt=Double.parseDouble(obj[10].toString());
				
					clsRecipeMasterBean objBean=new clsRecipeMasterBean();
					objBean.setStrParentCode(obj[1].toString());
					objBean.setStrParentName(obj[3].toString());
					objBean.setStrChildCode(obj[5].toString());
					objBean.setStrChildName(obj[6].toString());
					objBean.setDblQty(Double.parseDouble(obj[8].toString()));
					objBean.setStrUOM(obj[7].toString());
					objBean.setStrLocation(obj[4].toString());
					
					if(obj[13].toString().equalsIgnoreCase("N") || obj[13].toString().equalsIgnoreCase("N")){
						
						strParentCode=obj[5].toString();
						finalwt = obj[12].toString();
						//double dblRecipeCost=//objGlobalFun.funGetChildProduct(obj[21].toString(),clientCode,obj[0].toString(),strParentCode,finalwt,0);
						//bomAmt=dblRecipeCost;
					}
					objBean.setDblAmount(bomAmt);
					objBean.setDblPrice(bomrate);
					objBean.setDtValidFrom(obj[14].toString());
					objBean.setDtValidTo(obj[15].toString());
					listDtlBean.add(objBean);
					
				}
			}
			
		
			
			
			String sqlHDQuery = "";

			HashMap hm = new HashMap();
			hm.put("strCompanyName", objSetup.getStrClientName());
			hm.put("strUserCode", userCode);
			hm.put("strImagePath", imagePath);

			hm.put("strAddr1", objSetup.getStrAddressLine1());
			hm.put("strAddr2", objSetup.getStrAddressLine2());
			hm.put("strCity", objSetup.getStrCityName());
			hm.put("strState", objSetup.getStrState());
			hm.put("strCountry", objSetup.getStrCountry());
			hm.put("strPin", String.valueOf(objSetup.getIntPinCode()));
			hm.put("listDtlBean", listDtlBean);
			JasperDesign jd = JRXmlLoader.load(reportName);
			JasperReport jr = JasperCompileManager.compileReport(jd);

			JasperPrint jp = JasperFillManager.fillReport(jr, hm, new JREmptyDataSource());
			List<JasperPrint> jprintlist = new ArrayList<JasperPrint>();
			jprintlist.add(jp);

			if (jprintlist.size() > 0) {
				ServletOutputStream servletOutputStream = resp.getOutputStream();
				if (true) {
					JRExporter exporter = new JRPdfExporter();
					resp.setContentType("application/pdf");
					exporter.setParameter(JRPdfExporterParameter.JASPER_PRINT_LIST, jprintlist);
					exporter.setParameter(JRPdfExporterParameter.OUTPUT_STREAM, servletOutputStream);
					exporter.setParameter(JRPdfExporterParameter.IGNORE_PAGE_MARGINS, Boolean.TRUE);
					resp.setHeader("Content-Disposition", "inline;filename=" + "rptRecipeList.pdf");
					exporter.exportReport();
					servletOutputStream.flush();
					servletOutputStream.close();
				} else {
					JRExporter exporter = new JRXlsExporter();
					resp.setContentType("application/xlsx");
					exporter.setParameter(JRXlsExporterParameter.JASPER_PRINT_LIST, jprintlist);
					exporter.setParameter(JRXlsExporterParameter.OUTPUT_STREAM, servletOutputStream);
					exporter.setParameter(JRXlsExporterParameter.IGNORE_PAGE_MARGINS, Boolean.TRUE);
					resp.setHeader("Content-Disposition", "attachment;filename=" + "rptRecipeList.xlsx");
					exporter.exportReport();
					servletOutputStream.flush();
					servletOutputStream.close();
				}
			} else {
				resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
				try {
					resp.getWriter().append("No Record Found");
				} catch (IOException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
}
