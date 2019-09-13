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
import com.sanguine.bean.clsUserHdBean;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.webpos.bean.clsPOSAreaMasterBean;
import com.sanguine.webpos.bean.clsPOSReasonMasterBean;
import com.sanguine.webpos.model.clsAreaMasterModel;
import com.sanguine.webpos.model.clsReasonMasterModel;
import com.sanguine.webpos.model.clsReasonMasterModel_ID;
import com.sanguine.webpos.sevice.clsPOSMasterService;
import com.sanguine.webpos.util.clsPOSUtilityController;

@Controller
public class clsPOSReasonMasterController
{
	@Autowired
	private clsPOSGlobalFunctionsController objPOSGlobal;
	@Autowired
	private clsGlobalFunctions objGlobal;

	@Autowired
	private clsPOSUtilityController obUtilityController;

	@Autowired
	private clsPOSMasterService obMasterService;

	@Autowired
	private clsBaseServiceImpl objBaseServiceImpl;
	@Autowired
	clsPOSMasterService objMasterService;

	@RequestMapping(value = "/frmPOSReasonMaster", method = RequestMethod.GET)
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

		if ("2".equalsIgnoreCase(urlHits))
		{
			return new ModelAndView("frmPOSReasonMaster_1", "command", new clsPOSReasonMasterBean());
		}
		else if ("1".equalsIgnoreCase(urlHits))
		{
			return new ModelAndView("frmPOSReasonMaster", "command", new clsPOSReasonMasterBean());
		}
		else
		{
			return null;
		}

	}

	@RequestMapping(value = "/savePOSReasonMaster", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsPOSReasonMasterBean objBean, BindingResult result, HttpServletRequest req)
	{
		String urlHits = "1";
		String reasonCode = "";
		try
		{

			urlHits = req.getParameter("saddr").toString();
			String clientCode = req.getSession().getAttribute("gClientCode").toString();
			String webPOSUserCode = req.getSession().getAttribute("gUserCode").toString();
			reasonCode = objBean.getStrReasonCode();
			if (reasonCode.trim().isEmpty())
			{
				long intCode =obUtilityController.funGetDocumentCodeFromInternal("Reason",clientCode);
				reasonCode = "R" + String.format("%03d", intCode);
			}
			clsReasonMasterModel objModel = new clsReasonMasterModel(new clsReasonMasterModel_ID(reasonCode, clientCode));
			objModel.setStrReasonName(objBean.getStrReasonName());
			objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			objModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			objModel.setStrCashMgmt(objGlobal.funIfNull(objBean.getStrCashMgmt(), "N", "Y"));
			objModel.setStrComplementary(objGlobal.funIfNull(objBean.getStrComplementary(), "N", "Y"));
			objModel.setStrDataPostFlag("N");
			objModel.setStrDiscount(objGlobal.funIfNull(objBean.getStrDiscount(), "N", "Y"));
			objModel.setStrKot("N");
			objModel.setStrModifyBill(objGlobal.funIfNull(objBean.getStrModifyBill(), "N", "Y"));
			objModel.setStrNCKOT(objGlobal.funIfNull(objBean.getStrNCKOT(), "N", "Y"));
			objModel.setStrPSP(objGlobal.funIfNull(objBean.getStrPSP(), "N", "Y"));
			objModel.setStrReprint(objGlobal.funIfNull(objBean.getStrReprint(), "N", "Y"));
			objModel.setStrStkIn(objGlobal.funIfNull(objBean.getStrStkIn(), "N", "Y"));
			objModel.setStrStkOut(objGlobal.funIfNull(objBean.getStrStkOut(), "N", "Y"));
			objModel.setStrTransferEntry(objBean.getStrTransferEntry());
			objModel.setStrTransferType(objBean.getStrTransferType());
			objModel.setStrUnsettleBill(objGlobal.funIfNull(objBean.getStrUnsettleBill(), "N", "Y"));
			objModel.setStrUserCreated(webPOSUserCode);
			objModel.setStrUserEdited(webPOSUserCode);
			objModel.setStrVoidAdvOrder(objGlobal.funIfNull(objBean.getStrVoidAdvOrder(), "N", "Y"));
			objModel.setStrVoidBill(objGlobal.funIfNull(objBean.getStrVoidBill(), "N", "Y"));
			objModel.setStrVoidStkIn(objGlobal.funIfNull(objBean.getStrVoidStkIn(), "N", "Y"));
			objModel.setStrVoidStkOut(objGlobal.funIfNull(objBean.getStrVoidStkOut(), "N", "Y"));
			objModel.setStrMoveKOT(objGlobal.funIfNull(objBean.getStrMoveKOT(), "N", "Y"));
			objModel.setStrOperational(objGlobal.funIfNull(objBean.getStrOperational(), "N", "Y"));
			objModel.setStrHashTagLoyalty(objGlobal.funIfNull(objBean.getStrHashTagLoyaltyIntf(), "N", "Y"));
			obMasterService.funSaveReasonMaster(objModel);

			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage", " " + reasonCode);

			String sql = "update tblmasteroperationstatus set dteDateEdited='" + objGlobal.funGetCurrentDateTime("yyyy-MM-dd") + "'  where strTableName='Reason' " + " and strClientCode='" + clientCode + "'";
			objBaseServiceImpl.funExecuteUpdate(sql, "sql");

			return new ModelAndView("redirect:/frmPOSReasonMaster.html?saddr=" + urlHits);
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
			return new ModelAndView("frmLogin", "command", new clsUserHdBean());
		}
	}

	// Assign filed function to set data onto form for edit transaction.
	@RequestMapping(value = "/loadPOSReasonMasterData", method = RequestMethod.GET)
	public @ResponseBody clsPOSReasonMasterBean funSetSearchFields(@RequestParam("POSReasonCode") String reasonCode, HttpServletRequest req) throws Exception
	{
		String clientCode = req.getSession().getAttribute("gClientCode").toString();
		clsPOSReasonMasterBean objPOSReasonMaster = new clsPOSReasonMasterBean();

		clsReasonMasterModel objModel = (clsReasonMasterModel) objMasterService.funSelectedReasonMasterData(reasonCode, clientCode);

		objPOSReasonMaster.setStrReasonCode(objModel.getStrReasonCode());
		objPOSReasonMaster.setStrReasonName(objModel.getStrReasonName());
		objPOSReasonMaster.setStrTransferEntry(objModel.getStrTransferEntry());
		objPOSReasonMaster.setStrTransferType(objModel.getStrTransferType());
		objPOSReasonMaster.setStrStkIn(objModel.getStrStkIn());
		objPOSReasonMaster.setStrStkOut(objModel.getStrStkOut());
		objPOSReasonMaster.setStrVoidBill(objModel.getStrVoidBill());
		objPOSReasonMaster.setStrModifyBill(objModel.getStrModifyBill());
		objPOSReasonMaster.setStrPSP(objModel.getStrPSP());
		objPOSReasonMaster.setStrKot(objModel.getStrKot());
		objPOSReasonMaster.setStrCashMgmt(objModel.getStrCashMgmt());
		objPOSReasonMaster.setStrVoidStkIn(objModel.getStrVoidStkIn());
		objPOSReasonMaster.setStrVoidStkOut(objModel.getStrVoidStkOut());
		objPOSReasonMaster.setStrUnsettleBill(objModel.getStrUnsettleBill());
		objPOSReasonMaster.setStrComplementary(objModel.getStrComplementary());
		objPOSReasonMaster.setStrDiscount(objModel.getStrDiscount());
		objPOSReasonMaster.setStrNCKOT(objModel.getStrNCKOT());
		objPOSReasonMaster.setStrVoidAdvOrder(objModel.getStrVoidAdvOrder());
		objPOSReasonMaster.setStrReprint(objModel.getStrReprint());
		objPOSReasonMaster.setStrMoveKOT(objModel.getStrMoveKOT());
		objPOSReasonMaster.setStrHashTagLoyaltyIntf(objModel.getStrHashTagLoyalty());
		objPOSReasonMaster.setStrOperational(objModel.getStrOperational());

		return objPOSReasonMaster;
	}
	@RequestMapping(value ="/checkPOSReasonName" ,method =RequestMethod.GET)
	public  @ResponseBody boolean funCheckAreaName(@RequestParam("reasonName")  String name,@RequestParam("reasonCode")  String code,HttpServletRequest req) 
	{
		String clientCode =req.getSession().getAttribute("gClientCode").toString();
		int count=objPOSGlobal.funCheckName(name,code,clientCode,"POSReasonMaster");
		if(count>0)
			return true;
		else
			return false;
	}
}
