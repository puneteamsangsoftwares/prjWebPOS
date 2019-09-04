package com.sanguine.webpos.controller;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.sanguine.base.service.clsBaseServiceImpl;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.webpos.bean.clsPOSAreaMasterBean;
import com.sanguine.webpos.bean.clsPOSFactoryMasterBean;
import com.sanguine.webpos.model.clsAreaMasterModel;
import com.sanguine.webpos.model.clsAreaMasterModel_ID;
import com.sanguine.webpos.model.clsFactoryMasterModel;
import com.sanguine.webpos.model.clsFactoryMasterModel_ID;
import com.sanguine.webpos.sevice.clsPOSMasterService;
import com.sanguine.webpos.util.clsPOSUtilityController;

import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.validation.BindingResult;

import javax.validation.Valid;
import javax.servlet.http.HttpServletRequest;

@Controller
public class clsPOSFactoryMasterController
{

	@Autowired
	private clsGlobalFunctions objGlobal;
	@Autowired
	private clsPOSGlobalFunctionsController objPOSGlobal;

	@Autowired
	private clsBaseServiceImpl objBaseServiceImpl;
	@Autowired
	clsPOSMasterService objMasterService;
	
	@Autowired
	private clsPOSUtilityController objUtilityController;


	Map map = new HashMap();

	@RequestMapping(value = "/frmPOSFactoryMaster", method = RequestMethod.GET)
	public ModelAndView funOpenForm(@ModelAttribute("command") @Valid clsPOSFactoryMasterBean objBean, BindingResult result, Map<String, Object> model, HttpServletRequest request)
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
			return new ModelAndView("frmPOSFactoryMaster_1");
		}
		else if ("1".equalsIgnoreCase(urlHits))
		{
			return new ModelAndView("frmPOSFactoryMaster");
		}
		else
		{
			return null;
		}

	}

	@RequestMapping(value = "/savePOSFactoryMaster", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsPOSFactoryMasterBean objBean, BindingResult result, HttpServletRequest req)
	{
		String urlHits = "1";
		String posCode = "";
		try
		{
			urlHits = req.getParameter("saddr").toString();
			String clientCode = req.getSession().getAttribute("gClientCode").toString();
			String webStockUserCode = req.getSession().getAttribute("gUserCode").toString();
			String factoryCode = objBean.getStrDataPostFlag();
			if (factoryCode.trim().isEmpty())
			{

				List list = objUtilityController.funGetDocumentCode("POSNotificationMaster");
				if (list.size() > 0)
				{
					String strMaxFactoryCode = list.get(0).toString();
				if (strMaxFactoryCode.equals("0"))
                    {
                        factoryCode = "F" + String.format("%06d", (Integer.parseInt((String) list.get(0)) + 1));
                    }
                    else
                    {
                        strMaxFactoryCode = strMaxFactoryCode.substring(1);
                        int intMaxFactoryCode = Integer.parseInt(strMaxFactoryCode);
                        intMaxFactoryCode++;
                        factoryCode = "F" + String.format("%06d", intMaxFactoryCode);
                    }
				}

			}

			
				clsFactoryMasterModel objModel = new clsFactoryMasterModel(new clsFactoryMasterModel_ID(factoryCode, clientCode));
				objModel.setStrFactoryName(objBean.getStrFactoryName());
				objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
				objModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
				objModel.setStrDataPostFlag("");
				objModel.setStrUserCreated(webStockUserCode);
				objModel.setStrUserEdited(webStockUserCode);
				req.getSession().setAttribute("success", true);
				req.getSession().setAttribute("successMessage"," "+factoryCode);
		
			String sql = "update tblmasteroperationstatus set dteDateEdited='" + objGlobal.funGetCurrentDateTime("yyyy-MM-dd") + "'  where strTableName='Factory' "
					+" and strClientCode='" + clientCode + "'";
			objBaseServiceImpl.funExecuteUpdate(sql, "sql");

			return new ModelAndView("redirect:/frmPOSFactoryMaster.html?saddr=" + urlHits);
		}
		catch (Exception ex)
		{
			urlHits = "1";
			ex.printStackTrace();
			return new ModelAndView("redirect:/frmFail.html");
		}
	}

	// Assign filed function to set data onto form for edit transaction.
	@RequestMapping(value = "/loadPOSFactoryMasterData", method = RequestMethod.GET)
	public @ResponseBody clsPOSFactoryMasterBean funSetSearchFields(@RequestParam("POSFactoryCode") String factoryCode, HttpServletRequest req)
	{
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		clsPOSFactoryMasterBean objPOSFactoryMaster = null;
		clsFactoryMasterModel objModel= (clsFactoryMasterModel) objMasterService.funSelectedFactoryMasterData(factoryCode,clientCode);
		objPOSFactoryMaster.setStrFactoryName(objModel.getStrFactoryName());
		objPOSFactoryMaster.setStrUserCreated(objModel.getStrUserCreated());
		objPOSFactoryMaster.setStrUserEdited(objModel.getStrUserEdited());
		objPOSFactoryMaster.setDteDateCreated(objModel.getDteDateCreated());

		
		
		return objPOSFactoryMaster;

		
	}

	@RequestMapping(value = "/checkFactoryName", method = RequestMethod.GET)
	public @ResponseBody boolean funCheckFactoryName(@RequestParam("strFactoryCode") String factoryCode, @RequestParam("strFactoryName") String factoryName, HttpServletRequest req)
	{
		String clientCode=req.getSession().getAttribute("gClientCode").toString();
		int count = objPOSGlobal.funCheckName(factoryCode, factoryName, clientCode, "POSFactoryMaster");
		if (count > 0)
			return false;
		else
			return true;

	}

}
