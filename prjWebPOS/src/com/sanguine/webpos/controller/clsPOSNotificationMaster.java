package com.sanguine.webpos.controller;

import java.lang.reflect.Array;
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
import com.sanguine.webpos.bean.clsPOSCostCenterBean;
import com.sanguine.webpos.bean.clsPOSNotificationMasterBean;
import com.sanguine.webpos.bean.clsPOSPricingMasterBean;
import com.sanguine.webpos.model.clsAreaMasterModel;
import com.sanguine.webpos.model.clsCostCenterMasterModel;
import com.sanguine.webpos.model.clsCostCenterMasterModel_ID;
import com.sanguine.webpos.model.clsPOSNotificationMasterModel;
import com.sanguine.webpos.model.clsPOSNotificationMasterModel_ID;
import com.sanguine.webpos.sevice.clsPOSMasterService;
import com.sanguine.webpos.util.clsPOSUtilityController;

@Controller
public class clsPOSNotificationMaster
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

	@Autowired
	clsPOSUtilityController obUtilityController;

	@RequestMapping(value = "/frmPOSNotificationMaster", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model, HttpServletRequest request) throws Exception
	{
		Map map = new HashMap();
		Map<String, String> areaList = new HashMap<>();

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

		String clientCode = request.getSession().getAttribute("gClientCode").toString();
		List list = objMasterService.funFillPOSCombo(clientCode);
		map.put("All", "All");

		for (int cnt = 0; cnt < list.size(); cnt++)
		{
			Object[] obj = (Object[]) list.get(cnt);
			map.put(obj[0].toString(), obj[1].toString());
		}
		model.put("posList", map);

		List listArea = objMasterService.funLoadClientWiseArea(clientCode);
		// Area List
		areaList.put("All", "All");

		if (null != listArea)
		{
			for (int cnt = 0; cnt < listArea.size(); cnt++)
			{
				clsAreaMasterModel obModel = (clsAreaMasterModel) listArea.get(cnt);
				areaList.put(obModel.getStrAreaCode(), obModel.getStrAreaName());

			}
		}
		model.put("areaList", areaList);

		if ("2".equalsIgnoreCase(urlHits))
		{
			return new ModelAndView("frmPOSNotificationMaster_1", "command", new clsPOSNotificationMasterBean());
		}
		else if ("1".equalsIgnoreCase(urlHits))
		{
			return new ModelAndView("frmPOSNotificationMaster", "command", new clsPOSNotificationMasterBean());
		}
		else
		{
			return null;
		}
	}

	// Save or Update CostCenterMaster
	@RequestMapping(value = "/saveNotificationMaster", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsPOSNotificationMasterBean objBean, BindingResult result, Map<String, Object> model, HttpServletRequest req)
	{

		try
		{

			String clientCode = req.getSession().getAttribute("gClientCode").toString();
			String webStockUserCode = req.getSession().getAttribute("gUserCode").toString();

			String strNotificationCode = "";
			String notificationCode = objBean.getStrNotificationCode();
			if (notificationCode.trim().isEmpty())
			{

				List list = objUtilityController.funGetDocumentCode("POSNotificationMaster");
				if (list.size() > 0)
				{
					String strMaxNotificationCode = list.get(0).toString();
					if (strMaxNotificationCode.equals("0"))
					{
						strNotificationCode = "NF" + String.format("%02d", (Integer.parseInt(strMaxNotificationCode) + 1));
					}
					else
					{
						strMaxNotificationCode = strMaxNotificationCode.substring(2);
						int intMaxNotificationCode = Integer.parseInt(strMaxNotificationCode);
						intMaxNotificationCode++;
						strNotificationCode = "NF" + String.format("%02d", intMaxNotificationCode);
					}
				}

			}

			clsPOSNotificationMasterModel objModel = new clsPOSNotificationMasterModel(new clsPOSNotificationMasterModel_ID(strNotificationCode, clientCode));
			objModel.setStrNotificationText(objBean.getStrNotificationText());
			objModel.setStrNotificationType(objBean.getStrNotificationType());
			objModel.setStrAreaCode(objBean.getStrAreaCode());
			objModel.setStrPOSCode(objBean.getStrPOSCode());
			String[] from = objBean.getDteFromDate().split("-");
			String fromDate = from[2] + "-" + from[1] + "-" + from[0];

			objModel.setDteFromDate(fromDate);

			String[] To = objBean.getDteToDate().split("-");
			String TODate = To[2] + "-" + To[1] + "-" + To[0];

			objModel.setDteToDate(TODate);
			objModel.setStrClientCode(clientCode);
			objModel.setStrUserCreated(webStockUserCode);
			objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));

			objMasterService.funSaveUpdateCostCenterMaster(objModel);

			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage", " " + strNotificationCode);

			String sql = "update tblmasteroperationstatus set dteDateEdited='" + objGlobal.funGetCurrentDateTime("yyyy-MM-dd") + "'  where strTableName='Notification' " + " and strClientCode='" + clientCode + "'";
			objBaseServiceImpl.funExecuteUpdate(sql, "sql");

			return new ModelAndView("redirect:/frmPOSNotificationMaster.html");
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
			return new ModelAndView("redirect:/frmFail.html");
		}
	}

	// Assign filed function to set data onto form for edit transaction.
	@RequestMapping(value = "/loadNotificationMasterData", method = RequestMethod.GET)
	public @ResponseBody clsPOSNotificationMasterBean funSetSearchFields(@RequestParam("POSNotificationCode") String notificationCode, HttpServletRequest req) throws Exception
	{
		String clientCode = req.getSession().getAttribute("gClientCode").toString();
		clsPOSNotificationMasterBean objPOSNotificationMaster = new clsPOSNotificationMasterBean();

		clsPOSNotificationMasterModel objModel = (clsPOSNotificationMasterModel) objMasterService.funSelectedNotificationMasterData(notificationCode, clientCode);
		objPOSNotificationMaster.setStrNotificationText(objModel.getStrNotificationText());
		objPOSNotificationMaster.setStrNotificationType(objModel.getStrNotificationType());
		objPOSNotificationMaster.setStrAreaCode(objModel.getStrAreaCode());
		objPOSNotificationMaster.setDteFromDate(objModel.getDteFromDate());

		objPOSNotificationMaster.setStrPOSCode(objModel.getStrPOSCode());
		objPOSNotificationMaster.setDteToDate(objModel.getDteToDate());

		if (null == objPOSNotificationMaster)
		{
			objPOSNotificationMaster = new clsPOSNotificationMasterBean();
			objPOSNotificationMaster.setStrNotificationCode("Invalid Code");
		}

		return objPOSNotificationMaster;
	}

}
