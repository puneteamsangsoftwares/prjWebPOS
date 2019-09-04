package com.sanguine.webpos.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
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
import com.sanguine.webpos.bean.clsPOSAreaMasterBean;
import com.sanguine.webpos.bean.clsPOSCustomerTypeMasterBean;
import com.sanguine.webpos.bean.clsPOSZoneMasterBean;
import com.sanguine.webpos.model.clsAreaMasterModel;
import com.sanguine.webpos.model.clsPOSZoneMasterModel;
import com.sanguine.webpos.model.clsPOSZoneMasterModel_ID;
import com.sanguine.webpos.sevice.clsPOSMasterService;
import com.sanguine.webpos.util.clsPOSUtilityController;

@Controller
public class clsPOSZoneMasterController
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

	@RequestMapping(value = "/frmPOSZoneMaster", method = RequestMethod.GET)
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

		// return new ModelAndView("frmPOSGroupMaster");

		if ("2".equalsIgnoreCase(urlHits))
		{
			return new ModelAndView("frmPOSZoneMaster_1", "command", new clsPOSZoneMasterBean());
		}
		else if ("1".equalsIgnoreCase(urlHits))
		{
			return new ModelAndView("frmPOSZoneMaster", "command", new clsPOSZoneMasterBean());
		}
		else
		{
			return null;
		}

	}

	@RequestMapping(value = "/checkZoneName", method = RequestMethod.GET)
	public @ResponseBody boolean funCheckAreaName(@RequestParam("strZoneName") String name, @RequestParam("strZoneCode") String code, HttpServletRequest req)
	{

		String clientCode = req.getSession().getAttribute("gClientCode").toString();
		int count = objPOSGlobal.funCheckName(name, code, clientCode, "POSZoneMaster");
		if (count > 0)
			return false;
		else
			return true;

	}

	@RequestMapping(value = "/savePOSZoneMaster", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsPOSZoneMasterBean objBean, BindingResult result, HttpServletRequest req)
	{
		String urlHits = "1";
		System.out.println(objBean);
		try
		{
			urlHits = req.getParameter("saddr").toString();
			String clientCode = req.getSession().getAttribute("gClientCode").toString();
			String webStockUserCode = req.getSession().getAttribute("gUserCode").toString();
			String zoneCode = objBean.getStrZoneCode();

			if (zoneCode.trim().isEmpty())
			{
				long intCode = objUtilityController.funGetDocumentCodeFromInternal("Zone");
				zoneCode = "CA" + String.format("%03d", intCode);
			}
			clsPOSZoneMasterModel objModel = new clsPOSZoneMasterModel(new clsPOSZoneMasterModel_ID(zoneCode, clientCode));
			objModel.setStrZoneName(objBean.getStrZoneName());

			objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			objModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			objModel.setStrDataPostFlag("N");
			objModel.setStrUserCreated(webStockUserCode);
			objModel.setStrUserEdited(webStockUserCode);
			objMasterService.funSaveUpdateZoneMaster(objModel);

			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage", " " + zoneCode);
			String sql = "update tblmasteroperationstatus set dteDateEdited='" + objGlobal.funGetCurrentDateTime("yyyy-MM-dd") + "'  where strTableName='Zone' " + " and strClientCode='" + clientCode + "'";
			objBaseServiceImpl.funExecuteUpdate(sql, "sql");

			return new ModelAndView("redirect:/frmPOSZoneMaster.html?saddr=" + urlHits);
		}
		catch (Exception ex)
		{

			ex.printStackTrace();
			return new ModelAndView("redirect:/frmFail.html");
		}
	}

	// Assign filed function to set data onto form for edit transaction.
	@RequestMapping(value = "/loadPOSZoneMasterData", method = RequestMethod.GET)
	public @ResponseBody clsPOSZoneMasterBean funSetSearchFields(@RequestParam("POSZoneCode") String ZoneCode, HttpServletRequest req)
	{

		String clientCode = req.getSession().getAttribute("gClientCode").toString();
		clsPOSZoneMasterBean objPOSZoneMaster = new clsPOSZoneMasterBean();

		clsPOSZoneMasterModel objModel = (clsPOSZoneMasterModel) objMasterService.funSelectedZoneMasterData(ZoneCode, clientCode);
		objPOSZoneMaster.setStrZoneCode(objModel.getStrZoneCode());
		objPOSZoneMaster.setStrZoneName(objModel.getStrZoneName());

		return objPOSZoneMaster;
	}

}
