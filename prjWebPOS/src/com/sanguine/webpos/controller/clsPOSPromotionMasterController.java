/*package com.sanguine.webpos.controller;

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

import org.apache.poi.hssf.record.ObjRecord;
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

import com.sanguine.base.dao.intfBaseDao;
import com.sanguine.base.service.clsBaseServiceImpl;
import com.sanguine.base.service.intfBaseService;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.webpos.bean.clsPOSAreaMasterBean;
import com.sanguine.webpos.bean.clsPOSBuyPromotionItemDtl;
import com.sanguine.webpos.bean.clsPOSGetPromotionItemDtl;
import com.sanguine.webpos.bean.clsPOSMasterBean;
import com.sanguine.webpos.bean.clsPOSPromationMasterBean;
import com.sanguine.webpos.bean.clsPOSPromotionDayTimeDtlBean;
import com.sanguine.webpos.bean.clsPromotionDtlBean;
import com.sanguine.webpos.model.clsAreaMasterModel;
import com.sanguine.webpos.model.clsAreaMasterModel_ID;
import com.sanguine.webpos.model.clsBuyPromotionDtlHdModel;
import com.sanguine.webpos.model.clsGetPromotionDtlHdModel;
import com.sanguine.webpos.model.clsMenuHeadMasterModel;
import com.sanguine.webpos.model.clsMenuItemMasterModel;
import com.sanguine.webpos.model.clsPOSPromationMasterHdModel;
import com.sanguine.webpos.model.clsPromotionDayTimeDtlHdModel;
import com.sanguine.webpos.model.clsTaxPosDetailsModel;
import com.sanguine.webpos.sevice.clsPOSMasterService;
import com.sanguine.webpos.util.clsPOSUtilityController;

@Controller
public class clsPOSPromotionMasterController
{
	@Autowired
	private clsGlobalFunctions objGlobal;

	@Autowired
	private clsPOSGlobalFunctionsController objPOSGlobal;

	@Autowired
	clsPOSMasterService objMasterService;

	@Autowired
	clsBaseServiceImpl objBaseService;

	@Autowired
	private clsPOSUtilityController objUtilityController;

	@Autowired
	intfBaseDao objBaseDao;

	// private clsUtilityFunctions utility;
	Map map = new HashMap();

	@RequestMapping(value = "/frmPOSPromationMaster", method = RequestMethod.GET)
	public ModelAndView funOpenForm(@ModelAttribute("command") @Valid clsPOSPromationMasterBean objBean, BindingResult result, Map<String, Object> model, HttpServletRequest request) throws Exception
	{

		String clientCode = request.getSession().getAttribute("gClientCode").toString();

		JSONArray jArrList = null;

		// jArrList = objPOSGlobal.funGetAllAreaForMaster(clientCode);

		// Area List

		Map areaList = new HashMap<>();
		areaList.put("All", "All");
		if (null != jArrList)
		{
			for (int cnt = 0; cnt < jArrList.size(); cnt++)
			{
				Map jObj = (Map) jArrList.get(cnt);
				areaList.put(jObj.get("strAreaCode").toString(), jObj.get("strAreaName").toString());
			}
		}
		model.put("areaList", areaList);

		// Pratiksha
		List list = objMasterService.funFillPOSCombo(clientCode);
		map.put("All", "All");

		for (int cnt = 0; cnt < list.size(); cnt++)
		{
			Object[] obj = (Object[]) list.get(cnt);
			map.put(obj[0].toString(), obj[1].toString());
		}
		model.put("posList", map);

		return new ModelAndView("frmPOSPromationMaster");

	}

	@RequestMapping(value = "/savePromotionMaster", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsPOSPromationMasterBean objBean, BindingResult result, HttpServletRequest req)
	{

		String clientCode = req.getSession().getAttribute("gClientCode").toString();
		String webStockUserCode=req.getSession().getAttribute("gUserCode").toString();

		clsPOSPromationMasterHdModel objModel = new clsPOSPromationMasterHdModel();

		objModel.setStrPromoCode(objBean.getStrPromoCode());
		objModel.setStrPromoName(objBean.getStrPromoItemName());
		objModel.setStrAreaCode(objBean.getStrAreaCode());
		objModel.setLongKOTTimeBound(objBean.getLongKOTTimeBound());
		objModel.setDteFromDate(objBean.getDteFromDate());
		objModel.setDteToDate(objBean.getDteToDate());
		objModel.setStrPromotionOn(objBean.getStrGetPromoOn());
		objModel.setStrPromoItemCode(objBean.getStrPromoItemCode());
		objModel.setStrType(objBean.getStrType());
		objModel.setStrOperator(objBean.getStrOperator());
		objModel.setDblBuyQty(objBean.getDblBuyQty());
		objModel.setStrGetPromoOn(objBean.getStrGetPromoOn());
		objModel.setStrGetItemCode(objBean.getStrGetItemCode());

		// Buy
		List<clsPOSBuyPromotionItemDtl> buyList = objBean.getListBuyPromotionDtl();
		List jArrBuyList = new ArrayList();

		if (null != buyList)
		{
			for (int i = 0; i < buyList.size(); i++)
			{
				clsPOSBuyPromotionItemDtl obj = new clsPOSBuyPromotionItemDtl();
				obj = buyList.get(i);
				if (obj.getStrPromoCode() != null)
				{

					clsBuyPromotionDtlHdModel objBuyModel = new clsBuyPromotionDtlHdModel();
					objBuyModel.setStrBuyPromoItemCode(obj.getStrBuyPromoItemCode());
					objBuyModel.setDblBuyItemQty(obj.getDblBuyItemQty());
					objBuyModel.setStrOperator(obj.getStrOperator());

					jArrBuyList.add(objBuyModel);

				}

			}
		}

		objModel.setListBuyPromotionDtl(jArrBuyList);

		// Get
		List<clsPOSGetPromotionItemDtl> getList = objBean.getListGetPromotionDtl();
		ArrayList jArrGetList = new ArrayList();

		if (null != getList)
		{
			for (int i = 0; i < getList.size(); i++)
			{
				clsPOSGetPromotionItemDtl obj = new clsPOSGetPromotionItemDtl();
				obj = getList.get(i);
				if (obj.getStrPromoItemCode() != null)
				{

					clsGetPromotionDtlHdModel objGetModel = new clsGetPromotionDtlHdModel();
					objGetModel.setDblGetQty(obj.getDblGetQty());
					objGetModel.setStrDiscountType(obj.getStrDiscountType());
					objGetModel.setDblDiscount(obj.getDblDiscount());
					objGetModel.setStrPromotionOn(obj.getStrPromotionOn());

					jArrGetList.add(objGetModel);

				}

			}
		}

		objModel.setListBuyPromotionDtl(jArrGetList);

		// Date and Time
		List<clsPOSPromotionDayTimeDtlBean> dayTimeList = objBean.getListPromotionDayTimeDtl();
		ArrayList jArrTimeList = new ArrayList();

		if (null != dayTimeList)
		{
			for (int i = 0; i < dayTimeList.size(); i++)
			{
				clsPOSPromotionDayTimeDtlBean obj = new clsPOSPromotionDayTimeDtlBean();
				obj = dayTimeList.get(i);
				if (obj.getStrDay() != null)
				{

					clsPromotionDayTimeDtlHdModel objTimeModel = new clsPromotionDayTimeDtlHdModel();
					objTimeModel.setStrDays(obj.getStrDay());
					objTimeModel.setTmeFromTime(obj.getTmeFromTime());
					objTimeModel.setTmeToTime(obj.getTmeToTime());

					jArrTimeList.add(objTimeModel);

				}

			}
		}

		// objModel.setListDayTimeDtl(jArrTimeList);;

		
		  JSONObject jObjPromotionMaster = new JSONObject();
		  jObjPromotionMaster.put("strPromoCode", objBean.getStrPromoCode());
		  jObjPromotionMaster.put("strPromoName", objBean.getStrPromoName());
		  jObjPromotionMaster.put("dteFromDate", objBean.getDteFromDate());
		  
		  jObjPromotionMaster.put("dteToDate", objBean.getDteToDate());
		  jObjPromotionMaster.put("strPromotionOn",
		  objBean.getStrPromotionOn());
		  
		  jObjPromotionMaster.put("strPromoItemCode",
		  objBean.getStrPromoItemCode());
		  
		  map.put(objBean.getStrPromoItemCode(),
		  objBean.getStrPromoItemName());
		  
		  jObjPromotionMaster.put("strType", objBean.getStrType());
		  
		  jObjPromotionMaster.put("strOperator", objBean.getStrOperator());
		  jObjPromotionMaster.put("dblBuyQty", objBean.getDblBuyQty());
		  jObjPromotionMaster.put("strGetPromoOn", objBean.getStrGetPromoOn());
		  jObjPromotionMaster.put("strGetItemCode",
		  objBean.getStrGetItemCode());
		  
		 map.put(objBean.getStrGetItemCode(), objBean.getStrGetItemName());
		  
		  jObjPromotionMaster.put("dblGetQty", objBean.getDblGetQty());
		  jObjPromotionMaster.put("strDiscountType",
		  objBean.getStrDiscountType()); jObjPromotionMaster.put("dblDiscount",
		  objBean.getDblDiscount()); jObjPromotionMaster.put("strPromoNote",
		  objBean.getStrPromoNote());
		  
		  jObjPromotionMaster.put("posCode", objBean.getStrPOSCode());
		  jObjPromotionMaster.put("areaCode", objBean.getStrAreaCode());
		 jObjPromotionMaster.put("User", webStockUserCode);
		  jObjPromotionMaster.put("ClientCode", clientCode);
		 // Settlement Data

		// req.getSession().setAttribute("successMessage", " " + op);

		return new ModelAndView("redirect:/frmPOSPromationMaster.html");

	}

	// Pratiksha 5-03-2019
	public ModelAndView funSavePromotionMaster(@ModelAttribute("command") @Valid clsPOSPromationMasterBean objBean, BindingResult result, HttpServletRequest req)
	{
		String clientCode = req.getSession().getAttribute("gClientCode").toString();
		String webStockUserCode = req.getSession().getAttribute("gUserCode").toString();
		// clsPOSPromationMasterHdModel objModel = new
		// clsPOSPromationMasterHdModel();
		clsPOSPromationMasterHdModel objModel = new clsPOSPromationMasterHdModel();

		objModel.setStrPromoCode(objBean.getStrPromoCode());
		objModel.setStrPromoName(objBean.getStrPromoName());
		objModel.setDteFromDate(objBean.getDteFromDate());
		objModel.setDteToDate(objBean.getDteToDate());
		objModel.setStrPromotionOn(objBean.getStrGetPromoOn());
		objModel.setStrPromoItemCode(objBean.getStrPromoItemCode());
		objModel.setStrPromoName(objBean.getStrPromoItemName());
		objModel.setStrType(objBean.getStrType());
		objModel.setStrOperator(objBean.getStrOperator());
		objModel.setDblBuyQty(objBean.getDblBuyQty());
		objModel.setStrGetPromoOn(objBean.getStrGetPromoOn());
		objModel.setStrGetItemCode(objBean.getStrGetItemCode());
		objModel.setStrPOSCode(objBean.getStrPOSCode());
		objModel.setStrAreaCode(objBean.getStrAreaCode());

		// Buy
		List<clsPOSBuyPromotionItemDtl> buyList = objBean.getListBuyPromotionDtl();
		List jArrBuyList = new ArrayList();

		if (null != buyList)
		{
			for (int i = 0; i < buyList.size(); i++)
			{
				clsPOSBuyPromotionItemDtl obj = new clsPOSBuyPromotionItemDtl();
				obj = buyList.get(i);
				if (obj.getItemCode() != null)
				{

					clsBuyPromotionDtlHdModel objBuyModel = new clsBuyPromotionDtlHdModel();
					objBuyModel.setStrBuyPromoItemCode(obj.getItemCode());
					objBuyModel.setDblBuyItemQty(obj.getTotalItemQty());
					//objBuyModel.setStrOperator(obj.get);

					jArrBuyList.add(objBuyModel);

				}

			}
		}

		objModel.setListBuyPromotionDtl(jArrBuyList);

		// Get
		List<clsPOSGetPromotionItemDtl> getList = objBean.getListGetPromotionDtl();
		ArrayList jArrGetList = new ArrayList();

		if (null != getList)
		{
			for (int i = 0; i < getList.size(); i++)
			{
				clsPOSGetPromotionItemDtl obj = new clsPOSGetPromotionItemDtl();
				obj = getList.get(i);
				if (obj.getStrPromoItemCode() != null)
				{

					clsGetPromotionDtlHdModel objGetModel = new clsGetPromotionDtlHdModel();
					objGetModel.setDblGetQty(obj.getDblGetQty());
					objGetModel.setStrDiscountType(obj.getStrDiscountType());
					objGetModel.setDblDiscount(obj.getDblDiscount());
					objGetModel.setStrPromotionOn(obj.getStrPromotionOn());

					jArrGetList.add(objGetModel);

				}

			}
		}

		objModel.setListBuyPromotionDtl(jArrGetList);

		// Date and Time
		List<clsPOSPromotionDayTimeDtlBean> dayTimeList = objBean.getListPromotionDayTimeDtl();
		ArrayList jArrTimeList = new ArrayList();

		if (null != dayTimeList)
		{
			for (int i = 0; i < dayTimeList.size(); i++)
			{
				clsPOSPromotionDayTimeDtlBean obj = new clsPOSPromotionDayTimeDtlBean();
				obj = dayTimeList.get(i);
				if (obj.getStrDay() != null)
				{

					clsPromotionDayTimeDtlHdModel objTimeModel = new clsPromotionDayTimeDtlHdModel();
					objTimeModel.setStrDays(obj.getStrDay());
					objTimeModel.setTmeFromTime(obj.getTmeFromTime());
					objTimeModel.setTmeToTime(obj.getTmeToTime());

					jArrTimeList.add(objTimeModel);

				}

			}
		}

		// objModel.setListDayTimeDtl(jArrTimeList);;

		return new ModelAndView("redirect:/frmPOSPromationMaster.html");

	}

	@RequestMapping(value = "/loadPromotionMasterData", method = RequestMethod.GET)
	public @ResponseBody clsPOSPromationMasterBean funSetSearchFields(@RequestParam("promoCode") String promoCode, HttpServletRequest req)
	{
		String clientCode = req.getSession().getAttribute("gClientCode").toString();
		clsPOSPromationMasterBean objPromotionMaster = null;
		List<clsPromotionDtlBean> listBuyData = new ArrayList<clsPromotionDtlBean>();
		List<clsPromotionDtlBean> listGetData = new ArrayList<clsPromotionDtlBean>();
		List<clsPOSPromotionDayTimeDtlBean> listDayTime = new ArrayList<clsPOSPromotionDayTimeDtlBean>();

		Map mapObjSearchDetails = new HashMap();

		mapObjSearchDetails = funSelectedPromotionMasterData(promoCode, clientCode);

		if (null != mapObjSearchDetails && mapObjSearchDetails.size() > 0)
		{
			objPromotionMaster = new clsPOSPromationMasterBean();
			objPromotionMaster.setStrPromoCode((String) mapObjSearchDetails.get("strPromoCode"));
			objPromotionMaster.setStrPromoName((String) mapObjSearchDetails.get("strPromoName"));
			objPromotionMaster.setStrPOSCode((String) mapObjSearchDetails.get("strPOSCode"));
			objPromotionMaster.setDteFromDate((String) mapObjSearchDetails.get("dteFromDate"));
			objPromotionMaster.setDteToDate((String) mapObjSearchDetails.get("dteToDate"));

			String promoOn = (String) mapObjSearchDetails.get("strPromotionOn");
			objPromotionMaster.setStrPromotionOn(promoOn);

			objPromotionMaster.setStrPromoItemCode((String) mapObjSearchDetails.get("strPromoItemCode"));
			objPromotionMaster.setStrPromoItemName((String) mapObjSearchDetails.get("strPromoItemName"));

			objPromotionMaster.setStrType((String) mapObjSearchDetails.get("strType"));
			objPromotionMaster.setStrOperator((String) mapObjSearchDetails.get("strOperator"));
			objPromotionMaster.setDblBuyQty((double) mapObjSearchDetails.get("dblBuyQty"));
			// .setDblBuyQty(mapObjSearchDetails.get());

			String getPromoOn = (String) mapObjSearchDetails.get("strGetPromoOn");

			objPromotionMaster.setStrGetPromoOn(getPromoOn);
			objPromotionMaster.setStrAreaCode((String) mapObjSearchDetails.get("areaCode"));
			objPromotionMaster.setStrGetItemCode((String) mapObjSearchDetails.get("strGetItemCode"));
			objPromotionMaster.setStrGetItemName((String) mapObjSearchDetails.get("strGetItemName"));

			objPromotionMaster.setStrPromoNote((String) mapObjSearchDetails.get("strPromoNote"));

			// Buy Details
			ArrayList jArrBuyList = (ArrayList) mapObjSearchDetails.get("BuyData");
			if (null != jArrBuyList && jArrBuyList.size() > 0)
			{
				if (getPromoOn.equalsIgnoreCase("Item"))
				{
					Map jobj = (Map) jArrBuyList.get(0);

					objPromotionMaster.setDblBuyQty((double) jobj.get("dblBuyItemQty"));
					objPromotionMaster.setStrOperator((String) jobj.get("strOperator"));

				}
				if (promoOn.equalsIgnoreCase("MenuHead"))
				{
					for (int cnt = 0; cnt < jArrBuyList.size(); cnt++)
					{
						Map jobj = (Map) jArrBuyList.get(cnt);
						clsPromotionDtlBean objBean = new clsPromotionDtlBean();
						objBean.setStrItemCode((String) jobj.get("buyPromoItemCode"));

						objPromotionMaster.setDblBuyQty((double) jobj.get("dblBuyItemQty"));
						objPromotionMaster.setStrOperator((String) jobj.get("strOperator"));

						listBuyData.add(objBean);
					}
				}
			}
			objPromotionMaster.setListBuyPromotionDtl(jArrBuyList);

			// Get Data
			ArrayList jArrGetList = (ArrayList) mapObjSearchDetails.get("GetData");
			if (null != jArrGetList && jArrGetList.size() > 0)
			{
				if (getPromoOn.equalsIgnoreCase("Item"))
				{
					JSONObject jobj = (JSONObject) jArrGetList.get(0);

					objPromotionMaster.setDblGetQty((long) jobj.get("GetQty"));
					objPromotionMaster.setDblDiscount((long) jobj.get("Discount"));
					objPromotionMaster.setStrDiscountType((String) jobj.get("DiscountType"));
				}
				if (getPromoOn.equalsIgnoreCase("MenuHead"))
				{

					for (int cnt = 0; cnt < jArrGetList.size(); cnt++)
					{
						Map jobj = (Map) jArrGetList.get(cnt);
						clsPromotionDtlBean objPOSDtl = new clsPromotionDtlBean();
						objPOSDtl.setStrItemCode((String) jobj.get("GetPromoItemCode"));

						objPromotionMaster.setDblGetQty((long) jobj.get("GetQty"));
						objPromotionMaster.setDblDiscount((long) jobj.get("Discount"));
						objPromotionMaster.setStrDiscountType((String) jobj.get("DiscountType"));

						listGetData.add(objPOSDtl);
					}
				}
			}
			objPromotionMaster.setListGetPromotionDtl(jArrGetList);

			// DayTime Data
			ArrayList jArrDayTimeList = (ArrayList) mapObjSearchDetails.get("TimeData");
			if (null != jArrDayTimeList && jArrDayTimeList.size() > 0)
			{
				for (int cnt = 0; cnt < jArrDayTimeList.size(); cnt++)
				{
					Map mapobj = (Map) jArrDayTimeList.get(cnt);
					clsPOSPromotionDayTimeDtlBean objPOSDtl = new clsPOSPromotionDayTimeDtlBean();
					objPOSDtl.setStrDay((String) mapobj.get("Day"));
					objPOSDtl.setTmeFromTime((String) mapobj.get("FromTime"));
					objPOSDtl.setTmeToTime((String) mapobj.get("ToTime"));

					listDayTime.add(objPOSDtl);
				}
			}
			objPromotionMaster.setListPromotionDayTimeDtl(listDayTime);

		}

		if (null == objPromotionMaster)
		{
			objPromotionMaster = new clsPOSPromationMasterBean();
			objPromotionMaster.setStrPromoCode("Invalid Code");
		}

		return objPromotionMaster;
	}

	// Pratiksha 05-03-2019
	private Map funSelectedPromotionMasterData(String promoCode, String clientCode)
	{

		Map mapPromotionMaster = new HashMap();

		try
		{
			Map<String, String> hmParameters = new HashMap<String, String>();
			hmParameters.put("promoCode", promoCode);
			hmParameters.put("clientCode", clientCode);
			// clsPOSPromationMasterHdModel objPromoModel =
			// (clsPOSPromationMasterHdModel)
			// objBaseService.funGetAllMasterDataByDocCodeWise("getPromotionMaster",
			// hmParameters);
			clsPOSPromationMasterHdModel objPromoModel = objMasterService.funGetPromotionMasterData(promoCode, clientCode);

			List<clsBuyPromotionDtlHdModel> listBuyPromotionDtl = (List<clsBuyPromotionDtlHdModel>) objPromoModel.getListBuyPromotionDtl();

			Map mapBuyData = new HashMap();
			ArrayList jBuyData = new ArrayList();

			if (listBuyPromotionDtl != null)
			{
				Iterator itr = listBuyPromotionDtl.iterator();
				while (itr.hasNext())
				{
					clsBuyPromotionDtlHdModel objSettle = (clsBuyPromotionDtlHdModel) itr.next();
					Map mapObjSettle = new HashMap();
					mapObjSettle.put("buyPromoItemCode", objSettle.getStrBuyPromoItemCode());
					mapObjSettle.put("dblBuyItemQty", objSettle.getDblBuyItemQty());
					mapObjSettle.put("strOperator", objSettle.getStrOperator());
					mapBuyData.put(mapObjSettle, mapBuyData);
				}
			}

			List<clsBuyPromotionDtlHdModel> listGetPromotionDtl = (List<clsBuyPromotionDtlHdModel>) objPromoModel.getListBuyPromotionDtl();
			ArrayList jGetData = new ArrayList();
			if (null != listGetPromotionDtl)
			{
				Iterator itrGetPromoDtl = listGetPromotionDtl.iterator();
				while (itrGetPromoDtl.hasNext())
				{
					clsGetPromotionDtlHdModel objSettle = (clsGetPromotionDtlHdModel) itrGetPromoDtl.next();
					Map mapObjSettle = new HashMap();
					mapObjSettle.put("GetPromoItemCode", objSettle.getStrPromoItemCode());
					mapObjSettle.put("GetQty", objSettle.getDblGetQty());
					mapObjSettle.put("Discount", objSettle.getDblDiscount());
					mapObjSettle.put("DiscountType", objSettle.getStrDiscountType());
					jGetData.add(mapObjSettle);
				}
			}

			List<clsPromotionDayTimeDtlHdModel> listDayTimeDtl = (List<clsPromotionDayTimeDtlHdModel>) objPromoModel.getListPromotionDayTimeDtl();
			ArrayList jTimeData = new ArrayList();

			if (null != listDayTimeDtl)
			{
				Iterator itrPromoDayTimeDtl = listDayTimeDtl.iterator();
				while (itrPromoDayTimeDtl.hasNext())
				{
					clsPromotionDayTimeDtlHdModel objSettle = (clsPromotionDayTimeDtlHdModel) itrPromoDayTimeDtl.next();
					Map mapObjSettle = new HashMap();
					mapObjSettle.put("Day", objSettle.getStrDays());
					mapObjSettle.put("FromTime", objSettle.getTmeFromTime());
					mapObjSettle.put("ToTime", objSettle.getTmeToTime());

					jTimeData.add(mapObjSettle);
				}
			}

			mapPromotionMaster.put("strPromoCode", objPromoModel.getStrPromoCode());
			mapPromotionMaster.put("strPromoName", objPromoModel.getStrPromoName());
			mapPromotionMaster.put("strPOSCode", objPromoModel.getStrPOSCode());
			mapPromotionMaster.put("dteFromDate", objPromoModel.getDteFromDate());
			mapPromotionMaster.put("dteToDate", objPromoModel.getDteToDate());

			mapPromotionMaster.put("strPromotionOn", objPromoModel.getStrPromotionOn());
			if (objPromoModel.getStrPromotionOn().equalsIgnoreCase("MenuHead"))
			{
				hmParameters = new HashMap<String, String>();
				hmParameters.put("menuCode", objPromoModel.getStrPromoItemCode());
				hmParameters.put("clientCode", clientCode);
				clsMenuHeadMasterModel model = objMasterService.funGetMenuHeadMasterData(objPromoModel.getStrPromoItemCode(), clientCode);

				mapPromotionMaster.put("strPromoItemCode", objPromoModel.getStrPromoItemCode());
				mapPromotionMaster.put("strPromoItemName", model.getStrMenuName());
			}
			else
			{
				hmParameters = new HashMap<String, String>();
				hmParameters.put("promoCode", objPromoModel.getStrPromoItemCode());
				hmParameters.put("clientCode", clientCode);

				clsMenuItemMasterModel objMenuItemMasterModel = objMasterService.funGetMenuItemMasterData(objPromoModel.getStrPromoItemCode(), clientCode);

				mapPromotionMaster.put("strPromoItemCode", objPromoModel.getStrPromoItemCode());
				mapPromotionMaster.put("strPromoItemName", objMenuItemMasterModel.getStrItemName());
			}
			mapPromotionMaster.put("strType", objPromoModel.getStrType());
			mapPromotionMaster.put("strOperator", objPromoModel.getStrOperator());
			mapPromotionMaster.put("dblBuyQty", objPromoModel.getDblBuyQty());
			mapPromotionMaster.put("strGetPromoOn", objPromoModel.getStrGetPromoOn());
			mapPromotionMaster.put("areaCode", objPromoModel.getStrAreaCode());
			if (objPromoModel.getStrGetPromoOn().equalsIgnoreCase("MenuHead"))
			{
				hmParameters = new HashMap<String, String>();
				hmParameters.put("menuCode", objPromoModel.getStrGetItemCode());
				hmParameters.put("clientCode", clientCode);
				clsMenuHeadMasterModel model = objMasterService.funGetMenuHeadMasterData(objPromoModel.getStrGetItemCode(), clientCode);

				mapPromotionMaster.put("strGetItemCode", objPromoModel.getStrGetItemCode());
				mapPromotionMaster.put("strGetItemName", model.getStrMenuName());
			}
			else
			{
				hmParameters = new HashMap<String, String>();
				hmParameters.put("itemCode", objPromoModel.getStrGetItemCode());
				hmParameters.put("clientCode", clientCode);

				clsMenuItemMasterModel objMenuItemMasterModel = objMasterService.funGetMenuItemMasterData(objPromoModel.getStrGetItemCode(), clientCode);

				mapPromotionMaster.put("strGetItemCode", objPromoModel.getStrGetItemCode());
				mapPromotionMaster.put("strGetItemName", objMenuItemMasterModel.getStrItemName());
			}
			mapPromotionMaster.put("strPromoNote", objPromoModel.getStrPromoNote());

			mapPromotionMaster.put("BuyData", jBuyData);
			mapPromotionMaster.put("GetData", jGetData);
			mapPromotionMaster.put("TimeData", jTimeData);
			// Write code to convert model into json object.

			System.out.println();
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
		}

		return mapPromotionMaster;

	}

	// Pratiksha 06-03-2018
	@RequestMapping(value = "/loadMenuHeadDataForPromotion", method = RequestMethod.GET)
	public @ResponseBody List<clsPromotionDtlBean> funLoadMenuHeadData(@RequestParam("menuCode") String menuCode, HttpServletRequest request) throws Exception

	{
		String posCode = request.getSession().getAttribute("gPOSCode").toString();

		String clientCode = request.getSession().getAttribute("gClientCode").toString();
		ArrayList listMenuHead = new ArrayList();
		
		List<clsPromotionDtlBean> list = new ArrayList<clsPromotionDtlBean>();

		Map mapMenuData = (Map) objMasterService.funGetMenuHeadMasterData(menuCode, clientCode);

		listMenuHead = (ArrayList) mapMenuData.get("buyMenuHead");
		if (null != listMenuHead && listMenuHead.size() > 0)
		{
			for (int cnt = 0; cnt < listMenuHead.size(); cnt++)
			{
				Map mapobj = (Map) listMenuHead.get(cnt);
				clsPromotionDtlBean objBean = new clsPromotionDtlBean();

				objBean.setStrItemCode((String) mapobj.get("strItemCode"));
				objBean.setStrItemName((String) mapobj.get("strItemName"));
				objBean.setStrRate((long) mapobj.get("strRate"));
				objBean.setStrApplicableYN((Boolean) mapobj.get("strApplicableYN"));
				list.add(objBean);
			}
		}

		return list;

	}
	


	@RequestMapping(value = "/funCheckDuplicateBuyPromoItem", method = RequestMethod.GET)
	public @ResponseBody boolean funCheckDuplicateBuyPromoItem(@RequestParam("promoItemCode") String promoItemCode, @RequestParam("promoCode") String promoCode, @RequestParam("areaCode") String areaCode, @RequestParam("posCode") String posCode, HttpServletRequest req) {
		String clientCode =req.getSession().getAttribute("gClientCode").toString();
		int count=objPOSGlobal.funCheckName(promoItemCode,promoCode,clientCode,"POSPromotionMaster");
		if(count>0)
			return false;
		else
			return true;

	}

}


 */