package com.sanguine.webpos.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.json.simple.JSONObject;
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
import com.sanguine.bean.clsUserHdBean;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.webpos.bean.clsPOSCostCenterBean;
import com.sanguine.webpos.model.clsCostCenterMasterModel;
import com.sanguine.webpos.model.clsCostCenterMasterModel_ID;
import com.sanguine.webpos.sevice.clsPOSMasterService;
import com.sanguine.webpos.util.clsPOSUtilityController;


@Controller
public class clsPOSCostCenterMasterController {

	@Autowired
	private clsGlobalFunctions objGlobal;
	
	@Autowired
	private clsPOSGlobalFunctionsController objPOSGlobal;

	@Autowired
	private clsPOSUtilityController objUtilityController;
	
	@Autowired
	clsPOSMasterService objMasterService;
	
	@Autowired
	private clsBaseServiceImpl objBaseServiceImpl;
	
	@Autowired
	clsPOSUtilityController obUtilityController;

	
	// Open CostCenterMaster
	@RequestMapping(value = "/frmPOSCostCenter", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model,
			HttpServletRequest request) {
		String urlHits = "1";
		try {
			urlHits = request.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		model.put("urlHits", urlHits);
		
		Map mapOfPrinterList = new HashMap();
		List<String> printerList=new ArrayList<String>();
		mapOfPrinterList = objUtilityController.funGetPrinterList();
		printerList =(ArrayList) mapOfPrinterList.get("printerList");
		model.put("printerList", printerList);


		if ("2".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmPOSCostCenterMaster_1", "command",
					new clsPOSCostCenterBean());
		} else if ("1".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmPOSCostCenterMaster", "command",
					new clsPOSCostCenterBean());
		} else {
			return new ModelAndView("frmPOSCostCenterMaster");
		}
	}

	
	// Save or Update CostCenterMaster
	@RequestMapping(value ="/saveCostCenterMaster", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsPOSCostCenterBean objBean ,BindingResult result,Map<String,Object> model,HttpServletRequest req)
	{
		String urlHits="1";
		try
		{
			urlHits=req.getParameter("saddr").toString();
			String clientCode=req.getSession().getAttribute("gClientCode").toString();
			String webPOSUserCode=req.getSession().getAttribute("gUserCode").toString();
	
			String code="";
			String costCenterCode=objBean.getStrCostCenterCode();
		    if (costCenterCode.trim().isEmpty())
			{
				long intCode =objUtilityController.funGetDocumentCodeFromInternal("CostCenter",clientCode);
				costCenterCode = "C" + String.format("%03d", intCode);
			}
		    clsCostCenterMasterModel objModel = new clsCostCenterMasterModel(new clsCostCenterMasterModel_ID(costCenterCode, clientCode));
		    objModel.setStrCostCenterName(objBean.getStrCostCenterName());
		    objModel.setStrPrinterPort(objBean.getStrPrinterPort());
		    objModel.setStrSecondaryPrinterPort(objBean.getStrSecondaryPrinterPort());
		    objModel.setIntPrimaryPrinterNoOfCopies(objBean.getIntPrimaryPrinterNoOfCopies());
		    objModel.setIntSecondaryPrinterNoOfCopies(objBean.getIntSecondaryPrinterNoOfCopies());
		    objModel.setStrPrintOnBothPrinters(objGlobal.funIfNull(objBean.getStrPrintOnBothPrinters(),"N","Y"));
		    objModel.setStrLabelOnKOT(objBean.getStrLabelOnKOT());
		    objModel.setStrClientCode(clientCode); 
		    objModel.setStrUserCreated(webPOSUserCode);
		    objModel.setStrUserEdited(webPOSUserCode);
		    objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		    objModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		    objModel.setStrDataPostFlag("N");
		    objMasterService.funSaveUpdateCostCenterMaster(objModel);
			
			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage"," "+costCenterCode);
			
			String sql = "update tblmasteroperationstatus set dteDateEdited='"+objGlobal.funGetCurrentDateTime("yyyy-MM-dd")+"'  where strTableName='CostCenter' "
					+" and strClientCode='" + clientCode + "'";
			objBaseServiceImpl.funExecuteUpdate(sql,"sql");
			
			return new ModelAndView("redirect:/frmPOSCostCenter.html?saddr="+urlHits);
		}
		catch(Exception ex)
		{
			urlHits="1";
			ex.printStackTrace();
			return new ModelAndView("frmLogin", "command", new clsUserHdBean());
		}
	}


	//Assign filed function to set data onto form for edit transaction.
		@RequestMapping(value = "/loadCostCenterMasterData", method = RequestMethod.GET)
		public @ResponseBody clsPOSCostCenterBean funSetSearchFields(@RequestParam("POSCostCenterCode") String costCenterCode,HttpServletRequest req)throws Exception
		{
			String clientCode=req.getSession().getAttribute("gClientCode").toString();
			clsPOSCostCenterBean objPOSCostCenterMaster = new clsPOSCostCenterBean();
			
			clsCostCenterMasterModel objModel= (clsCostCenterMasterModel) objMasterService.funSelectedCostCenterMasterData(costCenterCode,clientCode);
			objPOSCostCenterMaster.setStrCostCenterCode(objModel.getStrCostCenterCode());
			objPOSCostCenterMaster.setStrCostCenterName(objModel.getStrCostCenterName());
			objPOSCostCenterMaster.setStrPrinterPort(objModel.getStrPrinterPort());
			objPOSCostCenterMaster.setStrSecondaryPrinterPort(objModel.getStrSecondaryPrinterPort());
			objPOSCostCenterMaster.setIntPrimaryPrinterNoOfCopies(objModel.getIntPrimaryPrinterNoOfCopies());
			objPOSCostCenterMaster.setIntSecondaryPrinterNoOfCopies(objModel.getIntSecondaryPrinterNoOfCopies());
			objPOSCostCenterMaster.setStrPrintOnBothPrinters(objModel.getStrPrintOnBothPrinters());
			objPOSCostCenterMaster.setStrLabelOnKOT(objModel.getStrLabelOnKOT());
			
			if(null==objPOSCostCenterMaster)
			{
				objPOSCostCenterMaster = new clsPOSCostCenterBean();
				objPOSCostCenterMaster.setStrCostCenterCode("Invalid Code");
			}
			
			return objPOSCostCenterMaster;
		}
		
		@RequestMapping(value ="/checkCostCenterName" ,method =RequestMethod.GET)
		public  @ResponseBody boolean funCheckCostCenterName(@RequestParam("strCostCenterCode") String costCenterCode,@RequestParam("strCostCenterName")  String costCenterName,HttpServletRequest req) 
		{
			String clientCode =req.getSession().getAttribute("gClientCode").toString();
			int count=objPOSGlobal.funCheckName(costCenterCode,costCenterName,clientCode,"POSCostCenterMaster");
			if(count>0)
			 return false;
			else
				return true;
			
		}
		@RequestMapping(value = "/testPrimaryPrinterStatus", method = RequestMethod.GET)
		public @ResponseBody Map funTestPrinterStatus(@RequestParam("PrinterName") String printerName, HttpServletRequest req) throws Exception
		{
			String posCode = req.getSession().getAttribute("loginPOS").toString();
			String userCode = req.getSession().getAttribute("gUserCode").toString();
			String status = obUtilityController.funTestPrint(printerName, userCode, posCode);
			Map hmStatus = new HashMap();
			hmStatus.put("Status", status);
			return hmStatus;
		}
		
		@RequestMapping(value = "/testSecondaryPrinterStatus", method = RequestMethod.GET)
		public @ResponseBody Map funSecTestPrinterStatus(@RequestParam("PrinterName") String printerName, HttpServletRequest req) throws Exception
		{
			String posCode = req.getSession().getAttribute("loginPOS").toString();
			String userCode = req.getSession().getAttribute("gUserCode").toString();
			String status = obUtilityController.funPrintOnSecPrinter(printerName, userCode, posCode);
			Map hmStatus = new HashMap();
			hmStatus.put("Status", status);
			return hmStatus;
		}
		
}
