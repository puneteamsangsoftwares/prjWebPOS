/*package com.sanguine.webpos.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

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

import com.sanguine.base.service.clsBaseServiceImpl;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.webpos.bean.clsPOSGiftVoucherMasterBean;
import com.sanguine.webpos.bean.clsPOSGroupMasterBean;
import com.sanguine.webpos.model.clsCustomerTypeMasterModel;
import com.sanguine.webpos.model.clsGiftVoucherMasterModel;
import com.sanguine.webpos.model.clsGiftVoucherMasterModel_ID;
import com.sanguine.webpos.model.clsGroupMasterModel;
import com.sanguine.webpos.model.clsGroupMasterModel_ID;
import com.sanguine.webpos.sevice.clsPOSMasterService;
import com.sanguine.webpos.util.clsPOSUtilityController;


@Controller
public class clsPOSGiftVoucherMasterController
{
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
	
	Map map=new TreeMap<>();
	
@RequestMapping(value = "/frmPOSGiftVoucherMaster", method = RequestMethod.GET)
public ModelAndView funOpenForm(Map<String, Object> model,HttpServletRequest request)throws Exception
{
	String clientCode=request.getSession().getAttribute("gClientCode").toString();
	String urlHits="1";
	try{
		urlHits=request.getParameter("saddr").toString();
	}catch(NullPointerException e){
		urlHits="1";
	}
	model.put("urlHits",urlHits);
	
	if("2".equalsIgnoreCase(urlHits)){
		return new ModelAndView("frmPOSGiftVoucherMaster_1","command", new clsPOSGiftVoucherMasterBean());
	}else if("1".equalsIgnoreCase(urlHits)){
		return new ModelAndView("frmPOSGiftVoucherMaster","command", new clsPOSGiftVoucherMasterBean());
	}else {
		return null;
	}
	 
}
	
@RequestMapping(value = "/savePOSGiftVoucherMaster", method = RequestMethod.POST)
public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsPOSGiftVoucherMasterBean objBean,BindingResult result,HttpServletRequest req)
{
	String urlHits="1";
	
	try
	{
		String clientCode=req.getSession().getAttribute("gClientCode").toString();
		String strUserCode=req.getSession().getAttribute("gUserCode").toString();
		String giftvoucherCode = objBean.getStrGiftVoucherCode();
		
		if (giftvoucherCode.trim().isEmpty())
	    {
	    	long intCode =objUtilityController.funGetDocumentCodeFromInternal("GiftVoucher");
			giftvoucherCode="GV" + String.format("%07d", intCode);
 
	    }
	    clsGiftVoucherMasterModel objModel = new clsGiftVoucherMasterModel(new clsGiftVoucherMasterModel_ID(giftvoucherCode, clientCode));
	   
	    objModel.setStrGiftVoucherName(objBean.getStrGiftVoucherName());
	    objModel.setStrGiftVoucherSeries(objBean.getStrGiftVoucherSeries());
	    objModel.setIntGiftVoucherStartNo(objBean.getIntGiftVoucherStartNo());
	    objModel.setIntGiftVoucherEndNo(objBean.getIntGiftVoucherEndNo());
	    objModel.setIntTotalGiftVouchers(objBean.getIntTotalGiftVouchers());
	    objModel.setStrGiftVoucherValueType(objBean.getStrGiftVoucherValueType());
	    objModel.setDblGiftVoucherValue(objBean.getDblGiftVoucherValue());
	    objModel.setStrGiftVoucherCode(giftvoucherCode);
	    objModel.setStrClientCode(clientCode);
	    String dteFrom=objBean.getDteValidFrom().substring(0, 10);
	    String ValidF=dteFrom.split("-")[2]+"-"+dteFrom.split("-")[1]+"-"+dteFrom.split("-")[0];
	    String dteTo=objBean.getDteValidFrom().substring(0, 10);
	    String ValidTo=dteTo.split("-")[2]+"-"+dteTo.split("-")[1]+"-"+dteTo.split("-")[0];
	    
	   // String dteFrom[]=objBean.getDteValidFrom().split("-");
	   //	String dteTo[]=objBean.getDteValidTo().split("-");
	   	objModel.setDteValidFrom(ValidF);
	    objModel.setDteValidTo(ValidTo);
	    objModel.setStrUserCreated(strUserCode);
	    
	    objModel.setStrUserEdited(strUserCode);
	    objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
	    objModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
	    objModel.setStrDataPostFlag("");
	    objModel.setStrGiftVoucherSeriesCode("");
	    objModel.setStrGiftVoucherShortName("");
	    
	    
	    
	
	    
	    objMasterService.funSaveUpdateGiftVoucherMaster(objModel);
	    String sql = "update tblmasteroperationstatus set dteDateEdited='"+objGlobal.funGetCurrentDateTime("yyyy-MM-dd")+"'  where strTableName='GiftVoucher' "
	    		+" and strClientCode='" + clientCode + "'";
		objBaseServiceImpl.funExecuteUpdate(sql,"sql");
		
		req.getSession().setAttribute("success", true);
		req.getSession().setAttribute("successMessage"," "+giftvoucherCode);
		
		return new ModelAndView("redirect:/frmPOSGiftVoucherMaster.html?saddr="+urlHits);
	}
	catch(Exception ex)
	{
		urlHits="1";
		ex.printStackTrace();
		return new ModelAndView("redirect:/frmFail.html");
	}
}
	
//Assign filed function to set data onto form for edit transaction.
@RequestMapping(value = "/loadPOSGiftVoucherMasterData", method = RequestMethod.GET)
public @ResponseBody clsPOSGiftVoucherMasterBean funSetSearchFields(@RequestParam("POSGiftVoucherCode") String giftVoucherCode,HttpServletRequest req)throws Exception
{
	String clientCode=req.getSession().getAttribute("gClientCode").toString();
	clsPOSGiftVoucherMasterBean objPOSGiftVoucherMaster = new clsPOSGiftVoucherMasterBean();
	clsGiftVoucherMasterModel objGiftVoucherMasterModel = objMasterService.funSelectedGiftVoucherMasterData(giftVoucherCode, clientCode);
	objPOSGiftVoucherMaster.setStrGiftVoucherCode(objGiftVoucherMasterModel.getStrGiftVoucherCode());
	objPOSGiftVoucherMaster.setStrGiftVoucherName(objGiftVoucherMasterModel.getStrGiftVoucherName());
	objPOSGiftVoucherMaster.setStrGiftVoucherSeries(objGiftVoucherMasterModel.getStrGiftVoucherSeries());
	objPOSGiftVoucherMaster.setStrGiftVoucherValueType(objGiftVoucherMasterModel.getStrGiftVoucherValueType());
	objPOSGiftVoucherMaster.setIntGiftVoucherStartNo(objGiftVoucherMasterModel.getIntGiftVoucherStartNo());
	objPOSGiftVoucherMaster.setIntGiftVoucherEndNo(objGiftVoucherMasterModel.getIntGiftVoucherEndNo());
	objPOSGiftVoucherMaster.setIntTotalGiftVouchers(objGiftVoucherMasterModel.getIntTotalGiftVouchers());
	objPOSGiftVoucherMaster.setDblGiftVoucherValue(objGiftVoucherMasterModel.getDblGiftVoucherValue());
	objPOSGiftVoucherMaster.setStrGiftVoucherSeriesCode(objGiftVoucherMasterModel.getStrGiftVoucherSeriesCode());
	String validFrom=objGiftVoucherMasterModel.getDteValidFrom().substring(0, 10);
	String validF=validFrom.split("-")[2]+"-"+validFrom.split("-")[1]+"-"+validFrom.split("-")[0];
	
	String ValidTo=objGiftVoucherMasterModel.getDteValidTo().substring(0, 10);
	String validT=validFrom.split("-")[2]+"-"+validFrom.split("-")[1]+"-"+validFrom.split("-")[0];
	
	objPOSGiftVoucherMaster.setDteValidFrom(validF);
	objPOSGiftVoucherMaster.setDteValideTo(validT);
	if(null == objPOSGiftVoucherMaster)
	{
		objPOSGiftVoucherMaster = new clsPOSGiftVoucherMasterBean();
		objPOSGiftVoucherMaster.setStrGiftVoucherCode("Invalid Code");
	}
	
	return objPOSGiftVoucherMaster;
}
			
 @RequestMapping(value ="/checkGiftVoucherName" ,method =RequestMethod.GET)
	public  @ResponseBody boolean funCheckAdvOrderName(@RequestParam("name")  String name,@RequestParam("code")  String code,HttpServletRequest req) 
	{
		String clientCode =req.getSession().getAttribute("gClientCode").toString();
		int count=objPOSGlobal.funCheckName(name,code,clientCode,"POSGiftVoucherMaster");
		if(count>0)
			return false;
		else
			return true;
	}			
}
*/