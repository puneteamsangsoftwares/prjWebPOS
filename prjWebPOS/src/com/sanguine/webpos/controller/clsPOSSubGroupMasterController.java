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
import com.sanguine.webpos.bean.clsPOSSubGroupMasterBean;
import com.sanguine.webpos.model.clsGroupMasterModel;
import com.sanguine.webpos.model.clsSubGroupMasterHdModel;
import com.sanguine.webpos.model.clsSubGroupMasterModel_ID;
import com.sanguine.webpos.sevice.clsPOSMasterService;
import com.sanguine.webpos.util.clsPOSUtilityController;
@Controller
public class clsPOSSubGroupMasterController
{

	@Autowired
	private clsGlobalFunctions objGlobal;
	
	@Autowired
	private clsPOSMasterService objMasterService; 
	
	@Autowired
	private clsPOSUtilityController obUtilityController;
	
	@Autowired
	private clsBaseServiceImpl objBaseServiceImpl;
	
	Map<String,String> mapGroup=new HashMap<String,String>();
	
	@RequestMapping(value = "/frmPOSSubGroup", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model,HttpServletRequest request)throws Exception
	{
		String strClientCode=request.getSession().getAttribute("gClientCode").toString();	
		String urlHits="1";
		try{
			urlHits=request.getParameter("saddr").toString();
		}catch(NullPointerException e){
			urlHits="1";
		}
		model.put("urlHits",urlHits);
		List listGroup = new ArrayList<String>();
		//listGroup.add("ALL");
		clsGroupMasterModel obGroupModel=null;
		List listGroupModels=objMasterService.funLoadAllGroupDetails(strClientCode);
		for(int i =0; i<listGroupModels.size();i++)
	    {
			obGroupModel=(clsGroupMasterModel) listGroupModels.get(i);
	    	listGroup.add(obGroupModel.getStrGroupName());
	    	mapGroup.put(obGroupModel.getStrGroupName(), obGroupModel.getStrGroupCode());
	    }
		model.put("listGroupName",listGroup);
		
		if("2".equalsIgnoreCase(urlHits)){
			return new ModelAndView("frmPOSSubGroup_1","command", new clsPOSSubGroupMasterBean());
		}else if("1".equalsIgnoreCase(urlHits)){
			return new ModelAndView("frmPOSSubGroup","command", new clsPOSSubGroupMasterBean());
		}else {
			return null;
		}
		 
	}

	@RequestMapping(value = "/savePOSSubGroup", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsPOSSubGroupMasterBean objBean,BindingResult result,HttpServletRequest req)
	{
		String urlHits="1";
		String subGroupCode = "";
		try
		{
			subGroupCode=objBean.getStrSubGroupCode();
			//urlHits=req.getParameter("saddr").toString();
			String clientCode=req.getSession().getAttribute("gClientCode").toString();
			String webPOSUserCode=req.getSession().getAttribute("gUserCode").toString();
			if (subGroupCode.trim().isEmpty())
			{
				long intCode =obUtilityController.funGetDocumentCodeFromInternal("SubGroup",clientCode);
				subGroupCode = "SG" + String.format("%07d", intCode);
			}
			clsSubGroupMasterHdModel objModel = new clsSubGroupMasterHdModel(new clsSubGroupMasterModel_ID(subGroupCode , clientCode));
		    objModel.setStrSubGroupName(objBean.getStrSubGroupName());
		    objModel.setStrGroupCode(objBean.getStrGroupCode());
		    objModel.setStrUserCreated(webPOSUserCode);
		    objModel.setStrUserEdited(webPOSUserCode);
		    objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		    objModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		    objModel.setStrDataPostFlag("N");
		    objModel.setStrAccountCode("NA");
		    objModel.setStrFactoryCode("");
		    objModel.setStrIncentives(objBean.getStrIncentives());
		    
		    objMasterService.funSaveSubGroupMaster(objModel);
						
			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage"," "+subGroupCode);
			
			String sql = "update tblmasteroperationstatus set dteDateEdited='"+objGlobal.funGetCurrentDateTime("yyyy-MM-dd")+"'  where strTableName='SubGroup' "
					+" and strClientCode='" + clientCode + "'";
			objBaseServiceImpl.funExecuteUpdate(sql,"sql");
			
			return new ModelAndView("redirect:/frmPOSSubGroup.html?saddr="+urlHits);
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
			return new ModelAndView("frmLogin", "command", new clsUserHdBean());
		}
	}

	//Assign filed function to set data onto form for edit transaction.
	@RequestMapping(value = "/loadPOSSubGroupMasterData", method = RequestMethod.GET)
	public @ResponseBody clsPOSSubGroupMasterBean funSetSearchFields(@RequestParam("POSSubGroupCode") String subgroupCode,HttpServletRequest req)
	{
		String clientCode=req.getSession().getAttribute("gClientCode").toString();
		clsPOSSubGroupMasterBean objPOSSubGroupMaster = null;
		
		try{
			Map<String,String> hmParameters=new HashMap<String,String>();
			hmParameters.put("subGroupCode",subgroupCode);
			hmParameters.put("clientCode",clientCode);
			clsSubGroupMasterHdModel objSubGroupModel = objMasterService.funLoadSubGroupData(hmParameters);
			
			objPOSSubGroupMaster = new clsPOSSubGroupMasterBean();
			objPOSSubGroupMaster.setStrSubGroupCode(objSubGroupModel.getStrSubGroupCode());
			objPOSSubGroupMaster.setStrSubGroupName(objSubGroupModel.getStrSubGroupName());
			objPOSSubGroupMaster.setStrGroupCode(objSubGroupModel.getStrGroupCode());
			objPOSSubGroupMaster.setStrIncentives(objSubGroupModel.getStrIncentives());
			
			
		}catch(Exception e){
			e.printStackTrace();
		}
		if(null==objPOSSubGroupMaster)
		{
			objPOSSubGroupMaster = new clsPOSSubGroupMasterBean();
			objPOSSubGroupMaster.setStrSubGroupCode("Invalid Code");
		}
		
		
		
		return objPOSSubGroupMaster;
	}
	
	
	 
	 @RequestMapping(value = "/loadSubGroupCombo", method = RequestMethod.GET)
		public @ResponseBody List<clsSubGroupMasterHdModel> funGetGropList(@RequestParam("code") String code, HttpServletRequest req) {
			String clientCode=req.getSession().getAttribute("gClientCode").toString();
			List listOfSubGroup=new ArrayList<>();
			try
			{
				//code
				listOfSubGroup = objMasterService.funLoadAllSubGroupOnGroup(code,clientCode);
				//listGroupModels = objMasterService.funLoadAllGroupDetails(clientCode);
			}
			catch (Exception e)
			{
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return listOfSubGroup;

		}
	
}
