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
import com.sanguine.webpos.bean.clsPOSOrderMasterBean;
import com.sanguine.webpos.model.clsAreaMasterModel;
import com.sanguine.webpos.model.clsPOSOrderMasterModel;
import com.sanguine.webpos.model.clsPOSOrderMasterModel_ID;
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
public class clsPOSOrderMasterController {

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
	// Open POSOrderMaster
	@RequestMapping(value = "/frmPOSOrderMaster", method = RequestMethod.GET)
	public ModelAndView funOpenForm(@ModelAttribute("command") @Valid clsPOSOrderMasterBean objBean, BindingResult result, Map<String, Object> model, HttpServletRequest request) throws Exception {
		String urlHits = "1";
		Map map = new HashMap();

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

		if ("2".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmPOSOrderMaster_1");
		} else if ("1".equalsIgnoreCase(urlHits)) {
			return new ModelAndView("frmPOSOrderMaster");
		} else {
			return null;
		}

	}

	@RequestMapping(value = "/savePOSOrderMaster", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsPOSOrderMasterBean objBean, BindingResult result, HttpServletRequest req) {
		String urlHits = "1";
		String posCode = "";
		try {
			urlHits = req.getParameter("saddr").toString();
			String clientCode=req.getSession().getAttribute("gClientCode").toString();
			String webStockUserCode=req.getSession().getAttribute("gUserCode").toString();
			String orderCode=objBean.getStrOrderCode();
			
			if (orderCode.trim().isEmpty())
			{
				long intCode =objUtilityController.funGetDocumentCodeFromInternal("Order");
				orderCode = "OR" + String.format("%06d",orderCode );	
			}

			
			clsPOSOrderMasterModel objModel = new clsPOSOrderMasterModel(new clsPOSOrderMasterModel_ID(orderCode, clientCode));
			objModel.setStrPOSCode(objBean.getStrPOSName());
			objModel.setStrOrderDesc(objBean.getStrOrderDesc());
			
			objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			objModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			objModel.setStrDataPostFlag("");
			objModel.setStrUserCreated(webStockUserCode);
			objModel.setStrUserEdited(webStockUserCode);
			objMasterService.funSaveUpdateOrderMaster(objModel);
		
			String strHH = objBean.getStrHH();
			String strMM = objBean.getStrMM();
			String strAMPM = objBean.getStrAMPM();
			String uptoTime = strHH + ":" + strMM + " " + strAMPM;


			

		

			
			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage", " " + orderCode);

			String sql = "update tblmasteroperationstatus set dteDateEdited='"+objGlobal.funGetCurrentDateTime("yyyy-MM-dd")+"'  where strTableName='Order' "
					+" and strClientCode='" + clientCode + "'";
			objBaseServiceImpl.funExecuteUpdate(sql,"sql");
									
			return new ModelAndView("redirect:/frmPOSOrderMaster.html?saddr=" + urlHits);
		} catch (Exception ex) {
			urlHits = "1";
			ex.printStackTrace();
			return new ModelAndView("redirect:/frmFail.html");
		}
	}

	// Assign filed function to set data onto form for edit transaction.
	@RequestMapping(value = "/loadPOSOrderMasterData", method = RequestMethod.GET)
	public @ResponseBody clsPOSOrderMasterBean funSetSearchFields(@RequestParam("orderCode") String orderCode, HttpServletRequest req) {
		String clientCode=req.getSession().getAttribute("gClientCode").toString();
		clsPOSOrderMasterBean objPOSOrderMaster = new clsPOSOrderMasterBean();
				
	
		clsPOSOrderMasterModel objModel= (clsPOSOrderMasterModel) objMasterService.funSelectedOrderMasterData(orderCode,clientCode);
		objPOSOrderMaster.setStrOrderCode(objModel.getStrOrderCode());
		objPOSOrderMaster.setStrOrderDesc(objModel.getStrOrderDesc());
		objPOSOrderMaster.setStrPOSName(objModel.getStrPOSCode());
				
		
		return objPOSOrderMaster;
	}

	

	@RequestMapping(value = "/checkOrderName", method = RequestMethod.GET)
	public @ResponseBody boolean funCheckAreaName(@RequestParam("name") String name, @RequestParam("code") String code, HttpServletRequest req) {
		String clientCode = req.getSession().getAttribute("clientCode").toString();

		int count = objPOSGlobal.funCheckName(name, code, clientCode, "POSOrderMaster");
		if (count > 0)
			return false;
		else
			return true;

	}

}
