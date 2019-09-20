package com.sanguine.webpos.controller;

import java.util.ArrayList;
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
import com.sanguine.webpos.model.clsAreaMasterModel;
import com.sanguine.webpos.model.clsAreaMasterModel_ID;
import com.sanguine.webpos.sevice.clsPOSMasterService;
import com.sanguine.webpos.util.clsPOSUtilityController;
import com.sanguine.webpos.bean.clsPOSAreaMasterBean;
import com.sanguine.webpos.bean.clsPOSModifierGroupMasterBean;
import com.sanguine.webpos.model.clsModifierGroupMasterHdModel;
import com.sanguine.webpos.model.clsModifierGroupMasterModel_ID;

@Controller
public class clsPOSModifierGroupMasterController
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

	@RequestMapping(value = "/frmPOSModifierGroupMaster", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model, HttpServletRequest request)
	{
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

		ArrayList<String> lstSeqNo = new ArrayList<String>();
		for (int i = 1; i < 51; i++)
		{
			lstSeqNo.add(String.valueOf(i));
		}
		model.put("listSeqNo", lstSeqNo);

		if ("2".equalsIgnoreCase(urlHits))
		{
			return new ModelAndView("frmPOSModifierGroupMaster_1", "command", new clsPOSModifierGroupMasterBean());
		}
		else if ("1".equalsIgnoreCase(urlHits))
		{
			return new ModelAndView("frmPOSModifierGroupMaster", "command", new clsPOSModifierGroupMasterBean());
		}
		else
		{
			return null;
		}

	}

	@RequestMapping(value = "/saveModifierGroupMaster", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsPOSModifierGroupMasterBean objBean, BindingResult result, HttpServletRequest req)
	{
		String urlHits = "1";
		try
		{
			urlHits = req.getParameter("saddr").toString();
			String clientCode=req.getSession().getAttribute("gClientCode").toString();
			String webPOSUserCode=req.getSession().getAttribute("gUserCode").toString();
			String groupModifierCode = objBean.getStrModifierGroupCode();
			String code="";
			if (groupModifierCode.trim().isEmpty())
			{
				long intCode =objUtilityController.funGetDocumentCodeFromInternal("ModifierGroup",clientCode);
				groupModifierCode = "MG" + String.format("%06d", intCode);
			}
			clsModifierGroupMasterHdModel objModel = new clsModifierGroupMasterHdModel(new clsModifierGroupMasterModel_ID(groupModifierCode, clientCode));
			objModel.setStrModifierGroupName(objBean.getStrModifierGroupName());
			objModel.setStrModifierGroupShortName(objBean.getStrModifierGroupShortName());
			objModel.setStrApplyMaxItemLimit(objBean.getStrApplyMaxItemLimit());
			objModel.setIntItemMaxLimit(objBean.getIntItemMaxLimit());
			objModel.setStrOperational(objBean.getStrOperationType());
			objModel.setStrApplyMinItemLimit(objBean.getStrApplyMinItemLimit());
			objModel.setIntItemMinLimit(objBean.getStrMinItemLimit());
			objModel.setIntSequenceNo(objBean.getStrSequenceNo());
			objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			objModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			objModel.setStrDataPostFlag("N");
			objModel.setStrUserCreated(webPOSUserCode);
			objModel.setStrUserEdited(webPOSUserCode);
			objMasterService.funSaveUpdateGroupModifierMaster(objModel);
			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage"," "+groupModifierCode);
			
			String sql = "update tblmasteroperationstatus set dteDateEdited='" + objGlobal.funGetCurrentDateTime("yyyy-MM-dd") + "'  where strTableName='Group Modifier' " + " and strClientCode='" + clientCode + "'";
			objBaseServiceImpl.funExecuteUpdate(sql, "sql");

			return new ModelAndView("redirect:/frmPOSModifierGroupMaster.html");
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
			return new ModelAndView("frmLogin", "command", new clsUserHdBean());
		}
	}

	@RequestMapping(value = "/loadPOSModifierGroupMasterData", method = RequestMethod.GET)
	public @ResponseBody clsPOSModifierGroupMasterBean funSetSearchFields(@RequestParam("POSModifierGPCode") String groupModifierCode, HttpServletRequest req) throws Exception
	{
		String clientCode = req.getSession().getAttribute("gClientCode").toString();
		clsPOSModifierGroupMasterBean objPOSAreaMaster = new clsPOSModifierGroupMasterBean();

		clsModifierGroupMasterHdModel objModel = (clsModifierGroupMasterHdModel) objMasterService.funSelectedGroupModifierMasterData(groupModifierCode, clientCode);
		objPOSAreaMaster.setStrModifierGroupName(objModel.getStrModifierGroupName());
		objPOSAreaMaster.setStrModifierGroupShortName(objModel.getStrModifierGroupShortName());
		objPOSAreaMaster.setStrApplyMaxItemLimit(objModel.getStrApplyMaxItemLimit());
		objPOSAreaMaster.setIntItemMaxLimit(objModel.getIntItemMaxLimit());
		objPOSAreaMaster.setStrOperationType(objModel.getStrOperational());
		objPOSAreaMaster.setStrApplyMaxItemLimit(objModel.getStrApplyMinItemLimit());
		objPOSAreaMaster.setStrMinItemLimit((int) objModel.getIntItemMinLimit());
		objPOSAreaMaster.setStrSequenceNo(objModel.getIntSequenceNo());

		return objPOSAreaMaster;
	}

	@RequestMapping(value = "/checkModGrpName", method = RequestMethod.GET)
	public @ResponseBody boolean funCheckAreaName(@RequestParam("groupName") String name, @RequestParam("groupCode") String code, HttpServletRequest req)
	{
		String clientCode = req.getSession().getAttribute("gClientCode").toString();
		int count = objPOSGlobal.funCheckName(name, code, clientCode, "POSModGroup");
		if (count > 0)
			return false;
		else
			return true;
	}
}
