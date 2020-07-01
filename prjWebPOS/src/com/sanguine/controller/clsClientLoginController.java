package com.sanguine.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.ModelAndView;

import com.POSLicence.controller.clsClientDetails;
import com.POSLicence.controller.clsEncryptDecryptClientCode;
import com.sanguine.bean.clsClientBean;
import com.sanguine.bean.clsUserHdBean;
import com.sanguine.model.clsCompanyMasterModel;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.service.clsSetupMasterService;
import com.sanguine.service.clsUserMasterService;
import com.sanguine.webpos.model.clsUserHdModel;

@Controller
@SessionAttributes("userdetails")
public class clsClientLoginController
{

	final static Logger logger = Logger.getLogger(clsUserController.class);
	private String strModule = "1";

	@Autowired
	private clsSetupMasterService objSetupMasterService;
	
	@Autowired
	private clsGlobalFunctionsService objGlobalService;

	@Autowired
	clsUserController objUserControlller;
	
	@Value("${applicationType}")
	String applicationType;

	@RequestMapping(value = "/validateClient", method = RequestMethod.POST)
	public ModelAndView login(HttpServletRequest req, @Valid clsClientBean objClientBean, BindingResult result, ModelMap map)
	{
		ModelAndView objMV = null;
		try
		{
			if (result.hasErrors())
			{
				map.put("invalid", "1");
				objMV = new ModelAndView("frmClientLogin", "command", new clsClientBean());
			}
			else
			{
				if (objClientBean != null)
				{
					String sql="select a.strRegistrationEmail,a.strRegistrationPassword,a.strClientCode,a.strClientName from tblsetup a where a.strRegistrationEmail='"+objClientBean.getStrClientCode()+"';";
					
					List list=objGlobalService.funGetList(sql,"sql");

					if(list.size()>0 && list != null)
					{

						Object[] obj=(Object[])list.get(0);
					

					if (objClientBean.getStrClientCode() != null && objClientBean.getStrClientCode().trim().length() > 0 && objClientBean.getStrPassword() != null && objClientBean.getStrPassword().trim().length() > 0)
					{

						String EmailID = objClientBean.getStrClientCode();
						String EmailPassword = objClientBean.getStrPassword();

						String encryptedClientCodeFromDB = clsEncryptDecryptClientCode.funEncryptClientCode(obj[2].toString());

						clsClientDetails.funAddClientCodeAndName();

						SimpleDateFormat dFormat = new SimpleDateFormat("yyyy-MM-dd");

						Date systemDate = dFormat.parse(dFormat.format(new Date()));

						String encryptedExpDate = clsClientDetails.hmClientDtl.get(encryptedClientCodeFromDB).expiryDate;
						String decryptedExpDate = clsEncryptDecryptClientCode.funDecryptClientCode(encryptedExpDate);
						
						String encryptedPOSVersion=clsClientDetails.hmClientDtl.get(encryptedClientCodeFromDB).getPosVersion();
						String gPOSVerion = clsEncryptDecryptClientCode.funDecryptClientCode(encryptedPOSVersion);
						req.getSession().setAttribute("gPOSVerion",gPOSVerion);
						
						Date posExpiryDate = dFormat.parse(decryptedExpDate);
						if (systemDate.compareTo(posExpiryDate) <= 0)
						{
							if (EmailID.equalsIgnoreCase(obj[0].toString()) && EmailPassword.equalsIgnoreCase(obj[1].toString()))
							{
								req.getSession().setAttribute("gClientCode",obj[2].toString());
								req.getSession().setAttribute("gCompanyName",obj[3].toString());								
								//req.getSession().setAttribute("gStartDate", startDate);
								
								
								Map<String, String> moduleMap = new TreeMap<String, String>();
								moduleMap.put("7-WebPOS", "webpos_module_icon.png");

								req.getSession().setAttribute("moduleNo", strModule);
								req.getSession().setAttribute("moduleMap", moduleMap);
								String sqlUser="Select COUNT(*) from tbluserhd;";
								List listUser=objGlobalService.funGetList(sqlUser,"sql");

								if(listUser.size()>0 && listUser != null)
								{
									if(Integer.parseInt(listUser.get(0).toString())>0)
									{
										objMV= new ModelAndView("frmLogin", "command", new clsUserHdBean());			
									}
									else
									{
										clsUserHdModel user=new clsUserHdModel();
								    	 user.setStrSuperType("YES");
								    	 user.setStrUserName("SANGUINE");
								    	 user.setStrUserCode("SANGUINE");
								    	 objMV = objUserControlller.funSessionValue(user, req);
								    
									}
								}
								else
								{
									clsUserHdModel user=new clsUserHdModel();
							    	 user.setStrSuperType("YES");
							    	 user.setStrUserName("SANGUINE");
							    	 user.setStrUserCode("SANGUINE");
							    	 objMV = objUserControlller.funSessionValue(user, req);
							    	
									
								}
								 
								
							}
							else
							{
								map.put("invalid", "1");
								objMV = new ModelAndView("frmClientLogin", "command", new clsClientBean());
							}

						}
						else
						{
							map.put("LicenceExpired", "1");
							objMV = new ModelAndView("frmClientLogin", "command", new clsClientBean());
						}
					}
					else
					{
						map.put("invalid", "1");
						objMV = new ModelAndView("frmClientLogin", "command", new clsClientBean());
					}
				}
				else
				{
					map.put("invalid", "1");
					objMV = new ModelAndView("frmClientLogin", "command", new clsClientBean());
				}
			}
			else
			{
				map.put("invalid", "1");
				objMV = new ModelAndView("frmClientLogin", "command", new clsClientBean());
			}
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
			logger.error(e.getMessage());
			map.put("invalid", "1");
			objMV = new ModelAndView("frmClientLogin", "command", new clsClientBean());
		}
		return objMV;
	}

}
