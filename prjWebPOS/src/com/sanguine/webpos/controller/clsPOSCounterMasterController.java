package com.sanguine.webpos.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
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
import com.sanguine.webpos.bean.clsPOSCounterMasterBean;
import com.sanguine.webpos.bean.clsPOSGroupMasterBean;
import com.sanguine.webpos.bean.clsPOSMenuHeadBean;
import com.sanguine.webpos.model.clsAreaMasterModel;
import com.sanguine.webpos.model.clsAreaMasterModel_ID;
import com.sanguine.webpos.model.clsPOSCounterDtlModel;
import com.sanguine.webpos.model.clsPOSCounterMasterModel;
import com.sanguine.webpos.model.clsPOSCounterMasterModel_ID;
import com.sanguine.webpos.model.clsTaxOnGroupModel;
import com.sanguine.webpos.model.clsTaxPosDetailsModel;
import com.sanguine.webpos.sevice.clsPOSMasterService;
import com.sanguine.webpos.util.clsPOSUtilityController;

@Controller
public class clsPOSCounterMasterController
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

	Map map = new HashMap();
	Map map1 = new HashMap();

	// Map mapUserName = new HashMap<>();
	// Map mapPOSName = new HashMap<>();

	@RequestMapping(value = "/frmPOSCounterMaster", method = RequestMethod.GET)
	public ModelAndView funOpenForm(@ModelAttribute("command") @Valid clsPOSCounterMasterBean objBean, BindingResult result, Map<String, Object> model, HttpServletRequest request) throws Exception
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

		String clientCode = request.getSession().getAttribute("gClientCode").toString();
		List<Object> posList = new ArrayList<Object>();
		map.put("All", "All");

		List list = objMasterService.funFillPOSCombo(clientCode);
		map.put("All", "All");

		for (int cnt = 0; cnt < list.size(); cnt++)
		{
			Object[] obj = (Object[]) list.get(cnt);
			map.put(obj[0].toString(), obj[1].toString());
		}
		model.put("posList", map);

		// UserCode
		List Userlist = objMasterService.funFillUserCodeCombo(clientCode);
		map.put("All", "All");

		for (int cnt = 0; cnt < Userlist.size(); cnt++)
		{
			Object[] obj = (Object[]) Userlist.get(cnt);
			map1.put(obj[0].toString(), obj[1].toString());
		}
		model.put("userList", map1);

		if ("2".equalsIgnoreCase(urlHits))
		{
			return new ModelAndView("frmPOSCounterMaster_1");
		}
		else if ("1".equalsIgnoreCase(urlHits))
		{
			return new ModelAndView("frmPOSCounterMaster");
		}
		else
		{
			return null;
		}

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/savePOSCounterMaster", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsPOSCounterMasterBean objBean, BindingResult result, HttpServletRequest req)
	{
		String urlHits = "1";

		String userCode = "";
		try
		{
			urlHits = req.getParameter("saddr").toString();
			String clientCode = req.getSession().getAttribute("gClientCode").toString();

			String counterCode = objBean.getStrCounterCode();
			String webStockUserCode = req.getSession().getAttribute("gUserCode").toString();

			if (counterCode.trim().isEmpty())
			{
				long intCode =objUtilityController.funGetDocumentCodeFromInternal("Counter",clientCode);
				counterCode = "CT" + String.format("%02d", intCode);
			}
			else
			{
				 counterCode = "CT01";
			}
			clsPOSCounterMasterModel objModel = new clsPOSCounterMasterModel(new clsPOSCounterMasterModel_ID(counterCode, clientCode));

			//objModel.setStrCounterCode(objBean.getStrCounterCode());
			objModel.setStrCounterName(objBean.getStrCounterName());
			objModel.setStrOperational(objBean.getStrOperational());
			objModel.setStrPOSCode(objBean.getStrPOSCode());

			objModel.setStrUserCode(objBean.getStrUserCode());
			objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			objModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			objModel.setStrDataPostFlag("");
			objModel.setStrUserCreated(webStockUserCode);
			objModel.setStrUserEdited(webStockUserCode);
			//objMasterService.funSaveUpdateCounterMaster(objModel);

			// Menu Head Data
			List<clsPOSMenuHeadBean> list = objBean.getGetListMenuHeadDtl();
			List<clsPOSCounterDtlModel> listCounterDtlModel = new ArrayList<clsPOSCounterDtlModel>();
			

			if (null != list)
			{
				for (int i = 0; i < list.size(); i++)
				{

					clsPOSMenuHeadBean obj = new clsPOSMenuHeadBean();
					obj = (clsPOSMenuHeadBean) list.get(i);
					if (obj.getStrOperational() != null)
					{
						clsPOSCounterDtlModel objPosModel = new clsPOSCounterDtlModel();
						objPosModel.setStrMenuCode(objBean.getStrMenuCode());
						listCounterDtlModel.add(objPosModel);

					}

				}
			}
			objModel.setListCounterDtlModel(listCounterDtlModel);
			objMasterService.funSaveUpdateCounterMaster(objModel);

			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage", " " + counterCode);

			String sql = "update tblmasteroperationstatus set dteDateEdited='" + objGlobal.funGetCurrentDateTime("yyyy-MM-dd") + "'  where strTableName='CounterMaster' " + " and strClientCode='" + clientCode + "'";
			objBaseServiceImpl.funExecuteUpdate(sql, "sql");

			return new ModelAndView("redirect:/frmPOSCounterMaster.html?saddr=" + urlHits);
		}
		catch (Exception ex)
		{
			urlHits = "1";
			ex.printStackTrace();
			return new ModelAndView("redirect:/frmFail.html");
		}
	}

	@RequestMapping(value = "/loadCounterMasterData", method = RequestMethod.GET)
	public @ResponseBody clsPOSCounterMasterBean funSetSearchFields(@RequestParam("counterCode") String counterCode, HttpServletRequest req)
	{
		String clientCode = req.getSession().getAttribute("gClientCode").toString();
		clsPOSCounterMasterBean objPOSCounterMaster = null;
		String posName = "";
		String userName = "";

		clsPOSCounterMasterBean objBean = new clsPOSCounterMasterBean();

		clsPOSCounterMasterModel objModel = (clsPOSCounterMasterModel) objMasterService.funSelectedCounterMasterData(counterCode, clientCode);
		objBean.setStrCounterCode(objModel.getStrCounterCode());
		objBean.setStrCounterName(objModel.getStrCounterName());
		objBean.setStrPOSCode(objModel.getStrPOSCode());
		objBean.setStrUserCode(objModel.getStrUserCode());
		objBean.setStrOperational(objModel.getStrOperational());

		List<clsPOSMenuHeadBean> listMenuHeadData = new ArrayList<clsPOSMenuHeadBean>();

		List<clsPOSCounterDtlModel> listMenuDtl = objModel.getListCounterDtlModel();
		Iterator itr = listMenuDtl.iterator();
		while (itr.hasNext())
		{
			clsPOSCounterDtlModel objCounterdtl = (clsPOSCounterDtlModel) itr.next();
			clsPOSMenuHeadBean objMenuHeadDtl = new clsPOSMenuHeadBean();
			objMenuHeadDtl.setStrMenuHeadCode(objCounterdtl.getStrMenuCode());

			listMenuHeadData.add(objMenuHeadDtl);
		}
		objBean.setGetListMenuHeadDtl(listMenuHeadData);

		return objBean;
	}

	public static Object getKeyFromValue(Map hm, Object value)
	{
		for (Object o : hm.keySet())
		{
			if (hm.get(o).equals(value))
			{
				return o;
			}
		}
		return null;
	}

	@RequestMapping(value = "/checkCounterName", method = RequestMethod.GET)
	public @ResponseBody boolean funCheckFactoryName(@RequestParam("strCounterCode") String counterCode, @RequestParam("strCounterName") String counterName, HttpServletRequest req)
	{
		String clientCode = req.getSession().getAttribute("clientCode").toString();
		int count = objPOSGlobal.funCheckName(counterCode, counterName, clientCode, "POSCounterMaster");
		if (count > 0)
			return false;
		else
			return true;

	}

}