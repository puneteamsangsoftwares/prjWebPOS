package com.sanguine.webpos.controller;

import java.util.ArrayList;
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

import com.sanguine.base.service.clsBaseServiceImpl;
import com.sanguine.bean.clsUserHdBean;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.webpos.bean.clsPOSAreaMasterBean;
import com.sanguine.webpos.bean.clsPaymentSetupBean;
import com.sanguine.webpos.model.clsAreaMasterModel;
import com.sanguine.webpos.model.clsAreaMasterModel_ID;
import com.sanguine.webpos.model.clsPaymentSetupModel;
import com.sanguine.webpos.model.clsPaymentSetupModel_ID;
import com.sanguine.webpos.sevice.clsPOSMasterService;
import com.sanguine.webpos.util.clsPOSUtilityController;

@Controller
public class clsPOSPaymentSetupController {
	
	@Autowired
	private clsGlobalFunctions objGlobal;
	
	
	@Autowired 
	private clsBaseServiceImpl objBaseServiceImpl;
	
	@Autowired
	clsPOSMasterService objMasterService;
	
	@RequestMapping(value = "/frmPaymentSetup", method = RequestMethod.GET)
	public ModelAndView funOpenForm(@ModelAttribute("command") @Valid clsPaymentSetupBean objBean,BindingResult result,Map<String,Object> model, HttpServletRequest request)throws Exception
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
	
		List arrchannelList=new ArrayList<>();
		arrchannelList.add("BhratPe");
		arrchannelList.add("RazorPay");
		
		model.put("channelList", arrchannelList);
		
		if("2".equalsIgnoreCase(urlHits)){
			return new ModelAndView("frmPaymentSetup_1");
		}else if("1".equalsIgnoreCase(urlHits)){
			return new ModelAndView("frmPaymentSetup");
		}else {
			return null;
		}
	}
	
	@RequestMapping(value = "/savePaymentSetup", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsPaymentSetupBean objBean, BindingResult result, HttpServletRequest req)
	{
		try
		{
			String clientCode = req.getSession().getAttribute("gClientCode").toString();
			String webPOSUserCode = req.getSession().getAttribute("gUserCode").toString();
			String channelName = objBean.getStrChannelName();
			
			clsPaymentSetupModel objModel = new clsPaymentSetupModel(new clsPaymentSetupModel_ID(channelName, clientCode));
			objModel.setStrChannelName(objBean.getStrChannelName());
			objModel.setStrChannelID(objBean.getStrChannelID());
			objModel.setStrSecretKey(objBean.getStrSecretKey());
			objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			objModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			if(objBean.getStrOperational() !=null) {
				objModel.setStrOperational("Y");
			}else {
				objModel.setStrOperational("N");
			}
			//objModel.setStrOperational(objGlobal.funIfNull(objBean.getStrOperational(), "Y", objBean.getStrOperational()));
			objModel.setStrUserCreated(webPOSUserCode);
			objModel.setStrUserEdited(webPOSUserCode);
			objBaseServiceImpl.funSave(objModel);
			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage", " " + channelName);

			/*
			 * String sql = "update tblmasteroperationstatus set dteDateEdited='" +
			 * objGlobal.funGetCurrentDateTime("yyyy-MM-dd") +
			 * "'  where strTableName='Area' " + " and strClientCode='" + clientCode + "'";
			 * objBaseServiceImpl.funExecuteUpdate(sql, "sql");
			 */
			
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
			//return new ModelAndView("frmLogin", "command", new clsUserHdBean());
		}
		return new ModelAndView("redirect:/frmPaymentSetup.html");
	}

	// Assign filed function to set data onto form for edit transaction.

	@RequestMapping(value = "/loadPaymentSetupData", method = RequestMethod.GET)
	public @ResponseBody clsPaymentSetupModel funSetSearchFields(@RequestParam("channelName") String channelName, HttpServletRequest req) throws Exception
	{
		String clientCode = req.getSession().getAttribute("gClientCode").toString();
		
		StringBuilder hql=new StringBuilder(" from clsPaymentSetupModel where strChannelName='"+channelName+"' and strClientCode='"+clientCode+"'");
		List list=objBaseServiceImpl.funGetList(hql, "hql");
		clsPaymentSetupModel objModel = new clsPaymentSetupModel();
		objModel.setStrChannelName("Invalid Code");
		if(list!=null && list.size()>0) {
			 objModel = (clsPaymentSetupModel)list.get(0);	
		}
		
		//clsPaymentSetupModel objModel = (clsPaymentSetupModel) objMasterService.funSelectedPaymentData(channelName, clientCode);
		return objModel;
	}
	
 }
