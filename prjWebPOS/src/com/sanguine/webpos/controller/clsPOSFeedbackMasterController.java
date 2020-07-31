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

import com.sanguine.base.service.clsBaseServiceImpl;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.webpos.bean.clsFeedBackMasterBean;
import com.sanguine.webpos.model.clsFeedBackMasterModel;
import com.sanguine.webpos.model.clsFeedBackMasterModel_ID;
import com.sanguine.webpos.model.clsPaymentSetupModel;
import com.sanguine.webpos.sevice.clsPOSMasterService;
import com.sanguine.webpos.util.clsPOSUtilityController;

@Controller
public class clsPOSFeedbackMasterController
{
	

	@Autowired
	private clsGlobalFunctions objGlobal;
	

	@Autowired
	private clsPOSUtilityController objUtilityController;
	
	
	@Autowired 
	private clsBaseServiceImpl objBaseServiceImpl;
	
	@Autowired
	clsPOSMasterService objMasterService;
	
	@RequestMapping(value = "/frmFeedbackMaster", method = RequestMethod.GET)
	public ModelAndView funOpenForm(@ModelAttribute("command") @Valid clsFeedBackMasterBean objBean,BindingResult result,Map<String,Object> model, HttpServletRequest request)throws Exception
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
		List list=objMasterService.funFillPOSCombo(clientCode);
		map.put("All", "All");
		
		for(int cnt=0;cnt<list.size();cnt++)
		{
			Object[] obj=(Object[]) list.get(cnt);
			map.put(obj[0].toString(), obj[1].toString());
		}
		model.put("posList", map);
		

		
		if("2".equalsIgnoreCase(urlHits)){
			return new ModelAndView("frmFeedbackMaster_1");
		}else if("1".equalsIgnoreCase(urlHits)){
			return new ModelAndView("frmFeedbackMaster");
		}else {
			return null;
		}
	}
	
	@RequestMapping(value = "/saveFeedbackMaster", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsFeedBackMasterBean objBean, BindingResult result, HttpServletRequest req)
	{
		try
		{
			String clientCode = req.getSession().getAttribute("gClientCode").toString();
			String webPOSUserCode = req.getSession().getAttribute("gUserCode").toString();
			String feedbackCode = objBean.getStrFBCode();
			if (feedbackCode.trim().isEmpty())
			{
				long intCode =objUtilityController.funGetDocumentCodeFromInternal("feedback",clientCode);
				feedbackCode = "FB" + String.format("%03d", intCode);
			}
			
			
			clsFeedBackMasterModel objModel = new clsFeedBackMasterModel(new clsFeedBackMasterModel_ID(feedbackCode, clientCode));
			objModel.setStrQuestion(objBean.getStrQuestion());
			objModel.setStrType(objBean.getStrType());
			objModel.setStrDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			objModel.setStrDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			if(objBean.getStrOperational() !=null) {
				objModel.setStrOperational("Y");
			}else {
				objModel.setStrOperational("N");
			}
			objModel.setIntRating(objBean.getIntRating());
			objModel.setIntSequence(objBean.getIntSequence());
			objModel.setStrUserCreated(webPOSUserCode);
			objModel.setStrUserEdited(webPOSUserCode);
			objModel.setStrPOSCode(objBean.getStrPOSCode());
			objBaseServiceImpl.funSave(objModel);
			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage", " " + feedbackCode);

			
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
			//return new ModelAndView("frmLogin", "command", new clsUserHdBean());
		}
		return new ModelAndView("redirect:/frmFeedbackMaster.html");
	}

	// Assign filed function to set data onto form for edit transaction.

	@RequestMapping(value = "/loadFeedbackMaster", method = RequestMethod.GET)
	public @ResponseBody clsFeedBackMasterModel funSetSearchFields(@RequestParam("fbCode") String fbCode, HttpServletRequest req) throws Exception
	{
		String clientCode = req.getSession().getAttribute("gClientCode").toString();
		
		StringBuilder hql=new StringBuilder(" from clsFeedBackMasterModel where strFBCode='"+fbCode+"' and strClientCode='"+clientCode+"'");
		List list=objBaseServiceImpl.funGetList(hql, "hql");
		clsFeedBackMasterModel objModel = new clsFeedBackMasterModel();
		objModel.setStrFBCode("Invalid Code");
		if(list!=null && list.size()>0) {
			 objModel = (clsFeedBackMasterModel)list.get(0);	
		}
		return objModel;
	}


}
