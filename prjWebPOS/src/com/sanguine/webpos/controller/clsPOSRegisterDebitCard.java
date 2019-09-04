package com.sanguine.webpos.controller;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sanguine.base.service.clsBaseServiceImpl;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.webpos.bean.clsPOSAreaMasterBean;
import com.sanguine.webpos.bean.clsPOSDebitCardMasterBean;
import com.sanguine.webpos.model.clsAreaMasterModel;
import com.sanguine.webpos.model.clsAreaMasterModel_ID;
import com.sanguine.webpos.model.clsRegisterDebitCardModel;
import com.sanguine.webpos.model.clsRegisterDebitCardModel_ID;
import com.sanguine.webpos.sevice.clsPOSMasterService;
import com.sanguine.webpos.util.clsPOSUtilityController;

public class clsPOSRegisterDebitCard
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
	
	/*@RequestMapping(value = "/loadPOSDebitCardMasterData", method = RequestMethod.GET)
	public @ResponseBody clsPOSDebitCardMasterBean funSetSearchFields(@RequestParam("cardTypeCode") String code,HttpServletRequest req)throws Exception
	{
		String clientCode=req.getSession().getAttribute("gClientCode").toString();
		clsPOSDebitCardMasterBean objPOSDebitCardMasterBeanMaster = new clsPOSDebitCardMasterBean();
				
		clsRegisterDebitCardModel objModel= (clsRegisterDebitCardModel) objMasterService.funSelectedDebitMasterData(code,clientCode);
		objPOSDebitCardMasterBeanMaster.setStrCardTypeCode(objModel.getStrCardTypeCode());
		objPOSDebitCardMasterBeanMaster.setStrCardName(objModel.getStrCardNo());
		objPOSDebitCardMasterBeanMaster.setStrManualNo(objModel.getStrManualNo());
				
		return objPOSDebitCardMasterBeanMaster;
	}
	@RequestMapping(value = "/savePOSAreaMaster", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsPOSDebitCardMasterBean objBean,BindingResult result,HttpServletRequest req)
	{
		try
		{
			String clientCode=req.getSession().getAttribute("gClientCode").toString();
			String webStockUserCode=req.getSession().getAttribute("gUserCode").toString();
			//String areaCode=objBean.getStrAreaCode();
			

			//clsRegisterDebitCardModel objModel = new clsRegisterDebitCardModel(new clsRegisterDebitCardModel_ID(code, clientCode));
			objModel.setStrCardTypeCode(objBean.getStrCardTypeCode());
			objModel.setStrCardNo(objBean.getStrCardName());
			objModel.setStrManualNo(objBean.getStrManualNo());
			//objModel.getStrCardNo(objBean.getStrPOSName());
			objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			objModel.setStrDataPostFlag("");
			objModel.setStrUserCreated(webStockUserCode);
			objMasterService.funSaveUpdateAreaMaster(objModel);
			req.getSession().setAttribute("success", true);
			//req.getSession().setAttribute("successMessage"," "+code);
			
			String sql = "update tblmasteroperationstatus set dteDateEdited='"+objGlobal.funGetCurrentDateTime("yyyy-MM-dd")+"'  where strTableName='Area' ";
			objBaseServiceImpl.funExecuteUpdate(sql,"sql");
									
			return new ModelAndView("redirect:/frmPOSAreaMaster.html");
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
			return new ModelAndView("redirect:/frmFail.html");
		}
	}*/
}
