package com.sanguine.webpos.controller;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileOutputStream;
import java.sql.Blob;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.sanguine.base.service.clsBaseServiceImpl;
import com.sanguine.base.service.intfBaseService;
import com.sanguine.bean.clsUserHdBean;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.webpos.bean.clsPOSMasterBean;
import com.sanguine.webpos.bean.clsPOSUserAccessBean;
import com.sanguine.webpos.bean.clsPOSUserRegistrationBean;
import com.sanguine.webpos.model.clsSuperUserDetailHdModel;
import com.sanguine.webpos.model.clsUserDetailHdModel;
import com.sanguine.webpos.model.clsUserHDModel_ID;
import com.sanguine.webpos.model.clsUserHdModel;
import com.sanguine.webpos.model.clsWaiterMasterModel;
import com.sanguine.webpos.sevice.clsPOSMasterService;
import com.sanguine.webpos.util.clsPOSGlobalSingleObject;
import com.sanguine.webpos.util.clsPOSUtilityController;

@Controller
public class clsPOSUserRegistrationController
{
	@Autowired
	private clsGlobalFunctions objGlobal;

	@Autowired
	private clsPOSGlobalFunctionsController objPOSGlobal;

	@Autowired
	clsPOSMasterService objMasterService;

	@Autowired
	intfBaseService obBaseService;

	@Autowired
	private clsBaseServiceImpl objBaseServiceImpl;

	@Autowired
	private clsPOSUtilityController objUtilityController;

	@Autowired
	private ServletContext servletContext;

	@RequestMapping(value = "/frmPOSUserRegistration", method = RequestMethod.GET)
	public ModelAndView funOpenForm(@ModelAttribute("command") @Valid clsPOSUserRegistrationBean objBean, BindingResult result, Map<String, Object> model, HttpServletRequest request) throws Exception
	{
		Map waiterMap = new HashMap();

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

		// Pratiksha 12-02-2019
		String clientCode = request.getSession().getAttribute("gClientCode").toString();
		
		clsWaiterMasterModel objWaiterModel = new clsWaiterMasterModel();
		List listOfWaiter = objMasterService.funGetAllWaitersForMaster(clientCode);
		waiterMap.put("All", "All");
		if (listOfWaiter != null)
		{
			for (int i = 0; i < listOfWaiter.size(); i++)
			{
				clsWaiterMasterModel objModel = (clsWaiterMasterModel) listOfWaiter.get(i);
				waiterMap.put(objModel.getStrWaiterNo(), objModel.getStrWShortName());
			}
		}

		model.put("waiterList", waiterMap);

		if ("2".equalsIgnoreCase(urlHits))
		{
			return new ModelAndView("frmPOSUserRegistration_1");
		}
		else if ("1".equalsIgnoreCase(urlHits))
		{
			return new ModelAndView("frmPOSUserRegistration");
		}
		else
		{
			return null;
		}

	}
	
	@RequestMapping(value = "/loadMasterModuleData", method = RequestMethod.GET)
	public @ResponseBody List<clsPOSUserRegistrationBean> funLoadMasterModuleData(@RequestParam("strModuleType") String moduleType, HttpServletRequest req) throws Exception
	{
		String clientCode = req.getSession().getAttribute("gClientCode").toString();

		List<clsPOSUserRegistrationBean> listMasterModuleData = new ArrayList<clsPOSUserRegistrationBean>();

		ArrayList jArryPosList = objPOSGlobal.funGetAllWebPOSForms(clientCode);

		if (null != jArryPosList && jArryPosList.size()>0)
		{
			for (int cnt = 0; cnt < jArryPosList.size(); cnt++)
			{
				Map<String, String> hmForms = (Map<String, String>) jArryPosList.get(cnt);
				
				clsPOSUserRegistrationBean objFormDtl = new clsPOSUserRegistrationBean();
				String moduleName =  hmForms.get("strModuleName"); 
				String type =  hmForms.get("strModuleType");
				if (moduleType.equals("M"))
				{
					if ((!moduleName.equals("Customer Master")) && type.equals(moduleType))
					{
						objFormDtl.setStrFormName(hmForms.get("strFormName"));
						objFormDtl.setStrModuleName(hmForms.get("strModuleName"));
						objFormDtl.setStrModuleType(hmForms.get("strModuleType"));
						listMasterModuleData.add(objFormDtl);
					}
				}
				else if (moduleType.equals("T") && type.equals(moduleType))
				{
					objFormDtl.setStrFormName( hmForms.get("strFormName"));
					objFormDtl.setStrModuleName( hmForms.get("strModuleName"));
					objFormDtl.setStrModuleType( hmForms.get("strModuleType"));
					listMasterModuleData.add(objFormDtl);
				}
				else if (moduleType.equals("R") && type.equals(moduleType))
				{
					objFormDtl.setStrFormName( hmForms.get("strFormName"));
					objFormDtl.setStrModuleName( hmForms.get("strModuleName"));
					objFormDtl.setStrModuleType( hmForms.get("strModuleType"));
					listMasterModuleData.add(objFormDtl);
				}
				else if (moduleType.equals("U") && type.equals(moduleType))
				{
					objFormDtl.setStrFormName( hmForms.get("strFormName"));
					objFormDtl.setStrModuleName( hmForms.get("strModuleName"));
					objFormDtl.setStrModuleType( hmForms.get("strModuleType"));
					listMasterModuleData.add(objFormDtl);
				}
			}
		}

		if (listMasterModuleData.size() > 0 && (moduleType.equals("T")))
		{
			clsPOSUserRegistrationBean objFormDtl = new clsPOSUserRegistrationBean();
			objFormDtl.setStrFormName("frmCustomerMaster");
			objFormDtl.setStrModuleName("Customer Master");
			objFormDtl.setStrModuleType(moduleType);
			listMasterModuleData.add(objFormDtl);
		}

		return listMasterModuleData;
	}

	// Pratiksha 12-02-2019
	@RequestMapping(value = "/loadPOSDetails", method = RequestMethod.GET)
	public @ResponseBody List<clsPOSMasterBean> funPOSData(HttpServletRequest req) throws Exception
	{
		String clientCode = req.getSession().getAttribute("gClientCode").toString();
		clsPOSMasterBean objPOSMasterBean = new clsPOSMasterBean();

		List listForPOSData = objMasterService.funFullPOSCombo(clientCode);
		List<clsPOSMasterBean> retList = new ArrayList<clsPOSMasterBean>();
		
		if (listForPOSData != null)
		{
			for (int cnt = 0; cnt < listForPOSData.size(); cnt++)
			{
				objPOSMasterBean = new clsPOSMasterBean();
				Object[] obj = (Object[]) listForPOSData.get(cnt);
				objPOSMasterBean.setStrPosCode(obj[0].toString());
				objPOSMasterBean.setStrPosName(obj[1].toString());
				objPOSMasterBean.setStrApplicableYN(true);
				retList.add(objPOSMasterBean);
			}

		}
		return retList;
	}

	@SuppressWarnings({ "rawtypes", "unused" })
	@RequestMapping(value = "/loadUserMasterData", method = RequestMethod.GET)
	public @ResponseBody clsPOSUserRegistrationBean funSetSearchFields(@RequestParam("strUserCode") String UserCode, HttpServletRequest req) throws Exception
	{
		String clientCode = req.getSession().getAttribute("gClientCode").toString();
		clsPOSUserRegistrationBean objPOSUserRegistrationMasterbean = new clsPOSUserRegistrationBean();
		clsUserHdModel objPOSUserRegistrationModel = objMasterService.funSelectedUserRegistrationMasterData(UserCode, clientCode);
		objPOSUserRegistrationMasterbean.setStrUserCode(objPOSUserRegistrationModel.getStrUserCode());
		objPOSUserRegistrationMasterbean.setStrUserName(objPOSUserRegistrationModel.getStrUserName());
		objPOSUserRegistrationMasterbean.setStrSuperType(objPOSUserRegistrationModel.getStrSuperType());
		objPOSUserRegistrationMasterbean.setStrWaiterNo(objPOSUserRegistrationModel.getStrWaiterNo());

		String validD = objPOSUserRegistrationModel.getDteValidDate().substring(0, 10);
		String validDate = validD.split("-")[2] + "-" + validD.split("-")[1] + "-" + validD.split("-")[0];
		objPOSUserRegistrationMasterbean.setDteValidTill(validDate);

		objPOSUserRegistrationMasterbean.setStrPOSAccess(objPOSUserRegistrationModel.getStrPOSAccess());
		
		String encKey = "04081977";
		String Password=objPOSUserRegistrationModel.getStrPassword();
		Password = clsPOSGlobalSingleObject.getObjPasswordEncryptDecreat().decrypt(encKey, Password);
        objPOSUserRegistrationMasterbean.setStrPassword(Password);
		
        
       /*// String encKey1 = "04081977";
		String ConfirmPassword=objPOSUserRegistrationModel.getStrConfirmPassword();
		ConfirmPassword = clsPOSGlobalSingleObject.getObjPasswordEncryptDecreat().encrypt(encKey1, ConfirmPassword);
        objPOSUserRegistrationMasterbean.setStrPassword(ConfirmPassword);  */
        
        
		//objPOSUserRegistrationMasterbean.setStrConfirmPassword(objPOSUserRegistrationModel.getStrConfirmPassword());
		objPOSUserRegistrationMasterbean.setIntNoOfDaysReportsView(objPOSUserRegistrationModel.getIntNoOfDaysReportsView());
		if (null == objPOSUserRegistrationMasterbean)
		{
			objPOSUserRegistrationMasterbean = new clsPOSUserRegistrationBean();
			objPOSUserRegistrationMasterbean.setStrUserCode("Invalid Code");
		}

		return objPOSUserRegistrationMasterbean;
	}


	@RequestMapping(value = "/loadUsersModuleData", method = RequestMethod.GET)
	public @ResponseBody clsPOSUserRegistrationBean funLoadUsersModule(@RequestParam("userCode") String userCode, HttpServletRequest req)
	{
		String clientCode = req.getSession().getAttribute("gClientCode").toString();
		clsPOSUserRegistrationBean objUserRegistration = new clsPOSUserRegistrationBean();
		List<clsPOSUserAccessBean> listAllSelectedModules = new ArrayList<clsPOSUserAccessBean>();
        StringBuilder sqlUserData = new StringBuilder();
        sqlUserData.append("SELECT a.strUserCode,a.strFormName,a.strGrant,a.strTLA,a.strAuditing" + " FROM tbluserdtl a,tbluserhd b WHERE a.strUserCode=b.strUserCode AND b.strClientCode='" + clientCode + "' " + "  and a.strUserCode='"+userCode+"' ");
        List list=null;
		try
		{
			list = objBaseServiceImpl.funGetList(sqlUserData, "sql");
			clsUserDetailHdModel objUserModel = new clsUserDetailHdModel();
			if (list!=null && list.size() > 0)
			{
				clsPOSUserAccessBean objUser =null;
				List list1 = new ArrayList();
				for (int cnt = 0; cnt < list.size(); cnt++)
				{
					Object[] obj = (Object[]) list.get(cnt);

					objUser = new clsPOSUserAccessBean();
					objUser.setStrUserCode(userCode);
					objUser.setStrFormName(obj[1].toString()); // formName
					objUser.setStrGrant(obj[2].toString()); // grant
					objUser.setStrAuditing(obj[4].toString()); // tla
					objUser.setStrTLA(obj[3].toString()); // audit
					listAllSelectedModules.add(objUser);
				}
				objUserRegistration.setListUsersSelectedForms(listAllSelectedModules);
			}
		}
		catch (Exception e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		if (null == objUserRegistration)
		{
			objUserRegistration = new clsPOSUserRegistrationBean();
			objUserRegistration.setStrUserCode("Invalid Code");
		}

		return objUserRegistration;
	}
	
	

	public String funAddUpdatePOSUserAccess(Map mapUserAccess)
	{
		String clientCode = "", userType = " ";
		try
		{

			Map<String, String> map = new HashMap<String, String>();

			// userCode = map.get("UserCode");
			clientCode = map.get("ClientCode");
			userType = map.get("UserType");

			// List list;
			String masterFormList = map.get("MasterFormDetails");
			String transactionFormList = map.get("TransactionFormDetails");
			String reportsFormList = map.get("ReportsFormDetails");
			String utilitiesFormList = map.get("UtilitiesFormDetails");

		}

		catch (Exception e)
		{
			e.printStackTrace();
		}
		return clientCode;

		// return userCode; */
	}

	// Pratiksha 12-02-2019
	@RequestMapping(value = "/savePOSUserRegistrationMaster", method = RequestMethod.POST)
	public ModelAndView funAddUpdate1(@ModelAttribute("command") @Valid clsPOSUserRegistrationBean objBean, BindingResult result, HttpServletRequest req, @RequestParam("companyLogo") MultipartFile file)
	{
		try
		{
			String clientCode = req.getSession().getAttribute("gClientCode").toString();
			String strLoginUser = req.getSession().getAttribute("gUserCode").toString();
			String userCode = objBean.getStrUserCode();
			clsUserHdModel objModel = new clsUserHdModel(new clsUserHDModel_ID(userCode, clientCode));
			if(objBean.getStrOldUserCode()!=null){
				if(!objBean.getStrOldUserCode().equals(objBean.getStrUserCode())){
					objBaseServiceImpl.funDeletePOSUser(objBean.getStrOldUserCode(), clientCode);
				}
			}
				
			objModel.setStrUserName(objBean.getStrUserName());
			//String encKey = "04081977";

			objModel.setStrSuperType(objBean.getStrSuperType());
			objModel.setStrUserType(((objGlobal.funIfNull(objBean.getStrUserType(), "N", "Y"))));
			objModel.setStrDataPostFlag("N");
			objModel.setStrDebitCardString(objGlobal.funIfNull(objBean.getStrUserType(), "N", "Y"));
			String validD = objBean.getDteValidTill().substring(0, 10);
			String validDate = validD.split("-")[2] + "-" + validD.split("-")[1] + "-" + validD.split("-")[0];
			if(validD.split("-")[0].length()>2){validDate=validD;}
			objModel.setDteValidTill(validDate);
			String encKey = "04081977";
			String Password=objBean.getStrPassword();
			Password = clsPOSGlobalSingleObject.getObjPasswordEncryptDecreat().encrypt(encKey, Password);
			objModel.setStrPassword(Password);
			objModel.setStrConfirmPassword(Password);
			objModel.setStrWaiterNo(objBean.getStrWaiterNo());
			objModel.setStrImgUserIconPath(objBean.getStrImgUserIconPath());
			objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			objModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
			objModel.setDteValidDate((objGlobal.funGetCurrentDateTime("yyyy-MM-dd")));
			objModel.setStrUserCreated(strLoginUser);
			objModel.setStrUserEdited(strLoginUser);
			if(objBean.getStrSuperType()== null)
	         {
				objModel.setStrSuperType("op");
			 }
			else
			{
				objModel.setStrSuperType("Super");
			}
			/*if (objBean.getStrSuperType().equalsIgnoreCase("Super"))
			{
				objModel.setStrSuperType("Super");
			}*/
			
			objModel.setIntNoOfDaysReportsView(objBean.getIntNoOfDaysReportsView());

			// To Save POS List
			List<clsPOSMasterBean> poslist = objBean.getListPOSData();
			String strSelectedPosCode = "";
			if (poslist != null)
			{
				for (int i = 0; i < poslist.size(); i++)
				{
					clsPOSMasterBean objBean1 = poslist.get(i);
					if (objBean1.getStrApplicableYN() != null)
					{
						if(strSelectedPosCode.isEmpty()){
							strSelectedPosCode = objBean1.getStrPosCode();	
						}else{
							strSelectedPosCode += ","+objBean1.getStrPosCode();
						}
					}
				}
			}


			objModel.setStrPOSAccess(strSelectedPosCode.toString());

			objModel.setStrUserCreated(strLoginUser);
			objModel.setStrUserEdited(strLoginUser);

			// To Save image
			if (file.getSize() != 0)
			{
				Blob blobProdImage = Hibernate.createBlob(file.getInputStream());
				objModel.setImgUserIcon(blobProdImage);
				FileOutputStream fileOuputStream = null;

				byte[] bytes = file.getBytes();
				String imagePath = servletContext.getRealPath("/resources/images");
				fileOuputStream = new FileOutputStream(imagePath + "/imgClientImage.jpg");
				fileOuputStream.write(bytes);
				fileOuputStream.close();

			}else{
				ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
				byte[] imageBytes = byteArrayOutputStream.toByteArray();
				ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(imageBytes);
				Blob blobProdImage = Hibernate.createBlob(byteArrayInputStream);
				objModel.setImgUserIcon(blobProdImage);
				
			}
			List<clsPOSUserAccessBean> listMaster = objBean.getListMasterForm();
			List<clsPOSUserAccessBean> listTransaction = objBean.getListTransactionForm();
			List<clsPOSUserAccessBean> listReports = objBean.getListReportForm();
			List<clsPOSUserAccessBean> listUtilities = objBean.getListUtilitiesForm();

			if (objBean.getStrSuperType()==null)
			{
				//OP

				String sql="delete from tbluserdtl where strUserCode='"+userCode+"' ;" ; // userCode
				objBaseServiceImpl.funExecuteUpdate(sql, "sql");
				
				ArrayList listmast = new ArrayList<>();
				for (int i = 0; i < listMaster.size(); i++)
				{
					clsPOSUserAccessBean obj = (clsPOSUserAccessBean) listMaster.get(i);

					if (obj.getStrGrant() != null)
					{
						clsPOSUserAccessBean objBean1 = listMaster.get(i);
						clsUserDetailHdModel objUserMaster = new clsUserDetailHdModel();
						objUserMaster.setStrFormName(objBean1.getStrFormName());
						objUserMaster.setStrButtonName(objBean1.getStrButtonName());
						objUserMaster.setStrGrant((objBean1.getStrGrant()));
						objUserMaster.setStrTLA((objBean1.getStrTLA()));
						objUserMaster.setStrAuditing(objBean1.getStrAuditing());
						objUserMaster.setStrUserCode(userCode);
						objUserMaster.setIntSequence(5);
						objUserMaster.setStrAdd("true");
						objUserMaster.setStrEdit("true");
						objUserMaster.setStrDelete("true");
						objUserMaster.setStrView("true");
						objUserMaster.setStrPrint("true");
						objUserMaster.setStrSave("true");
						obBaseService.funSave(objUserMaster);
					}
				}

				for (int i = 0; i < listTransaction.size(); i++)
				{
					clsPOSUserAccessBean obj = (clsPOSUserAccessBean) listTransaction.get(i);

					if (obj.getStrGrant() != null)
					{
						clsPOSUserAccessBean objBean1 = listTransaction.get(i);
						clsUserDetailHdModel objUserTrans = new clsUserDetailHdModel();
						objUserTrans.setStrFormName(objBean1.getStrFormName());
						objUserTrans.setStrButtonName("");
						objUserTrans.setStrGrant(objBean1.getStrGrant());
						objUserTrans.setStrTLA(objBean1.getStrTLA());
						objUserTrans.setStrAuditing(objBean1.getStrAuditing());
						objUserTrans.setStrUserCode(userCode);
						objUserTrans.setIntSequence(5);
						objUserTrans.setStrAdd("true");
						objUserTrans.setStrEdit("true");
						objUserTrans.setStrDelete("true");
						objUserTrans.setStrView("true");
						objUserTrans.setStrPrint("true");
						objUserTrans.setStrSave("true");
						obBaseService.funSave(objUserTrans);

					}
				}

				for (int i = 0; i < listReports.size(); i++)
				{
					clsPOSUserAccessBean obj = (clsPOSUserAccessBean) listReports.get(i);
					if (obj.getStrGrant() != null)
					{
						clsPOSUserAccessBean objBean1 = listReports.get(i);
						clsUserDetailHdModel objUserReport = new clsUserDetailHdModel();
						objUserReport.setStrFormName(objBean1.getStrFormName());
						objUserReport.setStrButtonName(objBean1.getStrButtonName());

						objUserReport.setStrGrant((objBean1.getStrGrant()));
						objUserReport.setStrTLA((objBean1.getStrTLA()));
						objUserReport.setStrAuditing(objBean1.getStrAuditing());

						objUserReport.setStrUserCode(userCode);

						objUserReport.setIntSequence(5);
						objUserReport.setStrAdd("true");
						objUserReport.setStrEdit("true");
						objUserReport.setStrDelete("true");
						objUserReport.setStrView("true");
						objUserReport.setStrPrint("true");
						objUserReport.setStrSave("true");
						obBaseService.funSave(objUserReport);

					}
				}

				for (int i = 0; i < listUtilities.size(); i++)
				{
					clsPOSUserAccessBean obj = (clsPOSUserAccessBean) listUtilities.get(i);
					if (obj.getStrGrant() != null)
					{
						clsPOSUserAccessBean objBean1 = listUtilities.get(i);
						clsUserDetailHdModel objUserUtilites = new clsUserDetailHdModel();

						objUserUtilites.setStrFormName(objBean1.getStrFormName());
						objUserUtilites.setStrButtonName(objBean1.getStrButtonName());

						objUserUtilites.setStrGrant((objBean1.getStrGrant()));
						objUserUtilites.setStrTLA((objBean1.getStrTLA()));
						objUserUtilites.setStrAuditing(objBean1.getStrAuditing());

						objUserUtilites.setStrUserCode(userCode);

						objUserUtilites.setIntSequence(5);
						objUserUtilites.setStrAdd("true");
						objUserUtilites.setStrEdit("true");
						objUserUtilites.setStrDelete("true");
						objUserUtilites.setStrView("true");
						objUserUtilites.setStrPrint("true");
						objUserUtilites.setStrSave("true");
						obBaseService.funSave(objUserUtilites);

					}
				}

			
			}// if
			else
			{
				//Super
				ArrayList listMast = new ArrayList<>();
				// delete data from super user
				
				String sql="delete from tblsuperuserdtl where strUserCode='"+userCode+"' ;" ; // userCode
				objBaseServiceImpl.funExecuteUpdate(sql, "sql");
				for (int i = 0; i < listMaster.size(); i++)
				{
					clsPOSUserAccessBean obj = (clsPOSUserAccessBean) listMaster.get(i);

					if (true)// super user
					{
						clsPOSUserAccessBean objBean1 = listMaster.get(i);
						clsSuperUserDetailHdModel objSuperUserModel = new clsSuperUserDetailHdModel();
						objSuperUserModel.setStrFormName(objBean.getStrFormName());

						objSuperUserModel.setStrButtonName(objBean1.getStrButtonName());
						objSuperUserModel.setStrGrant("true");
						objSuperUserModel.setStrTLA((objBean1.getStrTLA()));
						objSuperUserModel.setStrAuditing(objBean1.getStrAuditing());

						objSuperUserModel.setStrUserCode(userCode);

						objSuperUserModel.setIntSequence(5);
						objSuperUserModel.setStrAdd("true");
						objSuperUserModel.setStrEdit("true");
						objSuperUserModel.setStrDelete("true");
						objSuperUserModel.setStrView("true");
						objSuperUserModel.setStrPrint("true");
						objSuperUserModel.setStrSave("true");

						obBaseService.funSave(objSuperUserModel);

					}
				}

				ArrayList listTrans = new ArrayList<>();
				for (int i = 0; i < listTransaction.size(); i++)
				{
					if (true)
					{
						clsPOSUserAccessBean objBean1 = listTransaction.get(i);
						clsSuperUserDetailHdModel objSuperUserTrans = new clsSuperUserDetailHdModel();
						objSuperUserTrans.setStrFormName(objBean1.getStrFormName());
						objSuperUserTrans.setStrButtonName(objBean1.getStrButtonName());

						objSuperUserTrans.setStrGrant("true");
						objSuperUserTrans.setStrTLA((objBean1.getStrTLA()));
						objSuperUserTrans.setStrAuditing(objBean1.getStrAuditing());

						objSuperUserTrans.setStrUserCode(userCode);

						objSuperUserTrans.setIntSequence(5);
						objSuperUserTrans.setStrAdd("true");
						objSuperUserTrans.setStrEdit("true");
						objSuperUserTrans.setStrDelete("true");
						objSuperUserTrans.setStrView("true");
						objSuperUserTrans.setStrPrint("true");
						objSuperUserTrans.setStrSave("true");
						obBaseService.funSave(objSuperUserTrans);

					}
				}

				ArrayList listRprt = new ArrayList<>();

				for (int i = 0; i < listReports.size(); i++)
				{
					if (true)
					{
						clsPOSUserAccessBean objBean1 = listReports.get(i);
						clsSuperUserDetailHdModel objSuperUserReport = new clsSuperUserDetailHdModel();
						objSuperUserReport.setStrFormName(objBean1.getStrFormName());
						objSuperUserReport.setStrButtonName(objBean1.getStrButtonName());
						objSuperUserReport.setStrGrant("true");
						objSuperUserReport.setStrAuditing("true");
						objSuperUserReport.setStrTLA((objBean1.getStrTLA()));
						objSuperUserReport.setStrUserCode(userCode);
						objSuperUserReport.setIntSequence(5);
						objSuperUserReport.setStrAdd("true");
						objSuperUserReport.setStrEdit("true");
						objSuperUserReport.setStrDelete("true");
						objSuperUserReport.setStrView("true");
						objSuperUserReport.setStrPrint("true");
						objSuperUserReport.setStrSave("true");
						obBaseService.funSave(objSuperUserReport);

					}
				}

				ArrayList listUtil = new ArrayList();
				for (int i = 0; i < listUtilities.size(); i++)
				{
					if (true)
					{
						clsPOSUserAccessBean objBean1 = listUtilities.get(i);
						clsSuperUserDetailHdModel objSuperUserUtilites = new clsSuperUserDetailHdModel();

						objSuperUserUtilites.setStrFormName(objBean1.getStrFormName());
						objSuperUserUtilites.setStrButtonName(objBean1.getStrButtonName());
						objSuperUserUtilites.setStrGrant("true");
						objSuperUserUtilites.setStrTLA((objBean1.getStrTLA()));
						objSuperUserUtilites.setStrAuditing(objBean1.getStrAuditing());
						objSuperUserUtilites.setStrUserCode(userCode);
						objSuperUserUtilites.setIntSequence(5);
						objSuperUserUtilites.setStrAdd("true");
						objSuperUserUtilites.setStrEdit("true");
						objSuperUserUtilites.setStrDelete("true");
						objSuperUserUtilites.setStrView("true");
						objSuperUserUtilites.setStrPrint("true");
						objSuperUserUtilites.setStrSave("true");
						obBaseService.funSave(objSuperUserUtilites);
					}
				}
			}

			objMasterService.funSaveUpdateUserRegistrationMaster(objModel);

			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage", " " + userCode);

			String sql = "update tblmasteroperationstatus set dteDateEdited='" + objGlobal.funGetCurrentDateTime("yyyy-MM-dd") + "'  where strTableName='tbluserhd' "
					+" and strClientCode='" + clientCode + "'";
			objBaseServiceImpl.funExecuteUpdate(sql, "sql");

			return new ModelAndView("redirect:/frmPOSUserRegistration.html");
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
			return new ModelAndView("frmLogin", "command", new clsUserHdBean());
		}
	}
}
