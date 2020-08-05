
package com.sanguine.webpos.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

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

import com.sanguine.base.service.intfBaseService;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.webpos.bean.clsKDSBean;
//import com.sanguine.webpos.bean.clsKDSBean;
import com.sanguine.webpos.bean.clsPOSMoveKOTItemsToTableBean;

@Controller
public class clsPOSKDSForKOTBookAndProcessController
{

	@Autowired
	private clsGlobalFunctions objGlobal;
	@Autowired
	private clsPOSGlobalFunctionsController objPOSGlobal;
	@Autowired
	intfBaseService objBaseService;

	@RequestMapping(value = "/frmPOSKDSForKOTBookAndProcess", method = RequestMethod.GET)
	public ModelAndView funOpenForm(@ModelAttribute("command") @Valid clsPOSMoveKOTItemsToTableBean objBean, BindingResult result, Map<String, Object> model, HttpServletRequest request)
	{

		return new ModelAndView("frmPOSKDSBookAndProcess");

	}

	@RequestMapping(value = "/funKOTOrderProcess", method = RequestMethod.POST)
	public ModelAndView funBillOrderProcess(@ModelAttribute("command") @Valid clsPOSMoveKOTItemsToTableBean objBean, BindingResult result, HttpServletRequest req, @RequestParam("selectedBills") ArrayList<String> listOfKOTsToBeProcess)
	{
		String webStockUserCode = req.getSession().getAttribute("usercode").toString();
		try
		{

			JSONObject jObjMoveKOT = new JSONObject();

			jObjMoveKOT.put("listOfKOTsToBeProcess", listOfKOTsToBeProcess);
			jObjMoveKOT.put("userCode", webStockUserCode);

			String posURL = "http://localhost:8080/prjSanguineWebService/WebKDSForKOTBookAndProcessController/funKOTOrderProcess";
			URL url = new URL(posURL);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setDoOutput(true);
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Content-Type", "application/json");
			OutputStream os = conn.getOutputStream();
			os.write(jObjMoveKOT.toString().getBytes());
			os.flush();
			if (conn.getResponseCode() != HttpURLConnection.HTTP_CREATED)
			{
				throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());
			}
			BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));
			String output = "", op = "";

			while ((output = br.readLine()) != null)
			{
				op += output;
			}
			System.out.println("Result= " + op);
			conn.disconnect();

			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage", " " + op);

			return new ModelAndView("redirect:/frmPOSKDSForKOTBookAndProcess.html");
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
			return new ModelAndView("redirect:/frmFail.html");
		}
	}

	
	  @SuppressWarnings("unchecked")
	  
	@RequestMapping(value = "/funGetKOTHdDtl", method = RequestMethod.GET)
	public @ResponseBody List funGetBillHdDtl(HttpServletRequest req)
	{

		List listRet = new ArrayList<>();
		List listReturn = new ArrayList<clsKDSBean>();
		List listR = new ArrayList<>();
		clsKDSBean objBean = null;
		StringBuilder sbSql = new StringBuilder();
		sbSql.append("SELECT a.dblItemQuantity,a.strItemName,a.strKOTNo,TIME_FORMAT(a.tmeOrderProcessing,'%H:%i'),a.strTableNo " + "FROM tblitemrtemp a");
		List list;
		String strPrev = "";
		try
		{
			list = objBaseService.funGetList(sbSql, "sql");
			if (list != null && list.size() > 0)
			{
				for (int i = 0; i < list.size(); i++)
				{
					Object[] obj = (Object[]) list.get(i);
					objBean = new clsKDSBean();

					objBean.setStrKOTNo(obj[0].toString());
					objBean.setStrTableNo(obj[1].toString());
					objBean.setStrName(obj[3].toString());
					objBean.setStrQty(obj[4].toString());
					objBean.setStrTime(obj[5].toString());

					if (i > 0)
					{

						if (!strPrev.equals(obj[2].toString()))
						{
							listRet.add(listR);
							strPrev = "";
							listR = new ArrayList<>();
							listR.add(obj);
							strPrev = obj[2].toString();
						}
						else
						{
							listR.add(obj);
						}
					}
					else
					{
						listR.add(obj);
					}
					strPrev = obj[2].toString();
				}
			}
			listRet.add(listR);
		}
		catch (Exception e)
		{
			// TODO Auto-generated catch block e.printStackTrace(); }

			listReturn.add(listR);
			
		}
		return listRet;
	}
 
	@RequestMapping(value = "/funGetNewKOTSize", method = RequestMethod.GET)
	public @ResponseBody List funGetNewBillSize(HttpServletRequest req)
	{
		StringBuilder sbSql = new StringBuilder();

		List listReturn = new ArrayList<>();
		sbSql.append("select a.strTableNo,a.strItemCode,a.strItemName,a.dblItemQuantity from tblitemrtemp a");
		List list;
		try
		{
			list = objBaseService.funGetList(sbSql, "sql");
			if (list != null && list.size() > 0)
			{
				for (int i = 0; i < list.size(); i++)
				{
					Object obj = list.get(i);

					listReturn.add(obj);

				}
			}
		}
		catch (Exception e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return listReturn;

	}
}
