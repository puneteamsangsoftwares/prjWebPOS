package com.sanguine.webpos.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import com.sanguine.webpos.bean.clsPOSDebitCardMasterBean;
import com.sanguine.webpos.model.clsDebitCardRegistrationModel;


import com.sanguine.base.service.clsBaseServiceImpl;
import com.sanguine.controller.clsGlobalFunctions;

import com.sanguine.webpos.sevice.clsPOSMasterService;
import com.sanguine.webpos.util.clsPOSUtilityController;

@Controller
public class clsPOSDebitCardRegistration
{
	@Autowired
	private clsGlobalFunctions objGlobal;
	
	@Autowired
	private clsPOSGlobalFunctionsController objPOSGlobal;
	
	@Autowired 
	private clsBaseServiceImpl objBaseServiceImpl;
	
	@Autowired
	private clsPOSUtilityController objUtilityController;
	
	@Autowired
	clsPOSMasterService objMasterService;
	
	
	@RequestMapping(value = "/frmPOSDebitCardMaster", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model, HttpServletRequest request) throws Exception
	{
		Map map=new HashMap();
		String urlHits = "1";
		try {
			urlHits = request.getParameter("saddr").toString();
		} catch (NullPointerException e) {
			urlHits = "1";
		}
		model.put("urlHits", urlHits);
		
		String clientCode=request.getSession().getAttribute("gClientCode").toString();
		
		
		if("2".equalsIgnoreCase(urlHits)){
			return new ModelAndView("frmPOSDebitCardMaster_1");
		}else if("1".equalsIgnoreCase(urlHits)){
			return new ModelAndView("frmPOSDebitCardMaster.html");
		}else {
			return null;
		}
	}
	@RequestMapping(value = "/loadPOSDebitCardMasterData", method = RequestMethod.GET)
	public @ResponseBody clsPOSDebitCardMasterBean funSetSearchFields(@RequestParam("POSAreaCode") String areaCode,HttpServletRequest req)throws Exception
	{
		String clientCode=req.getSession().getAttribute("gClientCode").toString();
		clsPOSDebitCardMasterBean objPOSDebitMaster = new clsPOSDebitCardMasterBean();
				
		/*clsDebitCardRegistrationModel objModel= objMasterService.funSelectedDebitCardMasterData(areaCode,clientCode);
		objPOSDebitMaster.setStrManualNo(objModel.getStrManualNo());
		objPOSDebitMaster.getStrCustomerCode(objModel.getStrCustomerCode());
		objPOSDebitMaster.setStrPOSName(objModel.getStrPOSCode());*/
				
		return objPOSDebitMaster;
	}
			
}
