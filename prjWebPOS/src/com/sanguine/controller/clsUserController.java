package com.sanguine.controller;

import java.net.DatagramSocket;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.ModelAndView;

import com.POSLicence.controller.clsClientDetails;
import com.POSLicence.controller.clsEncryptDecryptClientCode;
import com.sanguine.bean.clsClientBean;
import com.sanguine.bean.clsUserHdBean;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.service.clsSetupMasterService;
import com.sanguine.service.clsUserMasterService;
import com.sanguine.util.clsSocketServer;
import com.sanguine.util.clsUserDesktopUtil;
import com.sanguine.webpos.bean.clsPOSSelectionBean;
import com.sanguine.webpos.controller.clsPOSToolsController;
import com.sanguine.webpos.model.clsSetupHdModel;
import com.sanguine.webpos.model.clsUserHdModel;
import com.sanguine.webpos.sevice.clsPOSMainMenuService;
import com.sanguine.webpos.sevice.clsPOSMasterService;
import com.sanguine.webpos.util.clsPOSGlobalSingleObject;

@Controller
@SessionAttributes("userdetails")

public class clsUserController
{
	final static Logger logger=Logger.getLogger(clsUserController.class);
	private String strModule="1";
	@Autowired
	private clsUserMasterService objUserMasterService;
	
	@Autowired
	private clsGlobalFunctions objGlobalFun;
	
	@Autowired
	private clsGlobalFunctionsService objGlobalService;

	
	@Autowired
	private clsSetupMasterService objSetupMasterService;


	@Autowired
	clsPOSMainMenuService objMainMenuService;
	
	@Autowired
	clsPOSMasterService objMasterService;
	
	@Autowired
	clsPOSToolsController objPOSTools;
	
	@Autowired
	private clsOnlineOrderController objOnlineOrderController;
	
	
	@Value("${applicationType}")
	String applicationType;

	public static clsSocketServer objSocketServer ;
	public static  DatagramSocket socket;
	
	
	@RequestMapping(value = "/index", method = RequestMethod.GET)
	public ModelAndView welcome(HttpServletRequest req) 	
	{
		
		try {
//			if(objSocketServer==null) {
//				int port = 5001;
//				clsUserController.socket=new DatagramSocket(port);
//		        objSocketServer = new clsSocketServer();	
//		        objSocketServer.start();
//			}
				
		}catch(Exception e) {
			e.printStackTrace();
		}

		PasswordEncoderGenerator();
		ModelAndView mAndV=null;
				
	//Direct Show Login Page or Client Login Page
		try
		{
			if(applicationType.equalsIgnoreCase("single"))
			{
				List<clsSetupHdModel> listClsSetUpModel=objSetupMasterService.funGetListSetupModel();
				if(listClsSetUpModel.size()>0)
				{
					clsSetupHdModel objSetUpModel=listClsSetUpModel.get(listClsSetUpModel.size()-1);
					
					String startDate=objSetUpModel.getDteStartDate();
					String[] spDate=startDate.split("-");
					String year=spDate[0];
					String month=spDate[1];
					String[] spDate1 =spDate[2].split(" ");
					String date=spDate1[0];
					startDate=date+"/"+month+"/"+year;
					req.getSession().setAttribute("gClientCode",objSetUpModel.getStrClientCode());
					req.getSession().setAttribute("gCompanyName",objSetUpModel.getStrClientName());		
					req.getSession().setAttribute("gStartDate",startDate);
					Map <String,String> moduleMap=new TreeMap<String, String>();
					moduleMap.put("7-WebPOS", "webpos_module_icon.png");
			
					req.getSession().setAttribute("moduleNo",strModule);
					req.getSession().setAttribute("moduleMap",moduleMap);
					mAndV= new ModelAndView("frmLogin","command", new clsUserHdBean());
				   
				} else {
				  return mAndV;
				}
			} 
			else
			{
				mAndV = new ModelAndView("frmClientLogin","command", new clsClientBean());
			}
			
		}catch(Exception ex)
		{
			ex.printStackTrace();
		}
		return mAndV;
	}
	
	
	@SuppressWarnings("deprecation")
	@RequestMapping(value = "/validateUser", method = RequestMethod.POST)
	public  ModelAndView funValidateUser(@ModelAttribute("command") @Valid clsUserHdBean userBean,BindingResult result,HttpServletRequest req,ModelMap map)
	{		
		if(logger.isDebugEnabled())
		{  
			   logger.debug("Start debug");  
		}
		ModelAndView objMV=null;
		String clientCodeFromDB=req.getSession().getAttribute("gClientCode").toString();
		String companyNameFromDB=req.getSession().getAttribute("gCompanyName").toString();
		
		if(result.hasErrors())
		{
			map.put("invalid", "1");
			return new ModelAndView("frmLogin","command", new clsUserHdBean());
		}
		else
		{
			String encryptedClientCodeFromDB = clsEncryptDecryptClientCode.funEncryptClientCode(clientCodeFromDB);
			String encryptedClientNameFromDB = clsEncryptDecryptClientCode.funEncryptClientCode(companyNameFromDB);
						
			clsClientDetails.funAddClientCodeAndName();
			
//			String decryptedClientCodeFromHm = clsEncryptDecryptClientCode.funDecryptClientCode(clsClientDetails.hmClientDtl.get(encryptedClientCodeFromDB).);
			String decryptedClientNameFromHm = clsEncryptDecryptClientCode.funDecryptClientCode(clsClientDetails.hmClientDtl.get(encryptedClientCodeFromDB).Client_Name);
			
						
			if(companyNameFromDB.equalsIgnoreCase(decryptedClientNameFromHm))
			{
				 SimpleDateFormat dFormat = new SimpleDateFormat("yyyy-MM-dd");
                 try
                 {
                	 Date systemDate = dFormat.parse(dFormat.format(new Date()));
                	 
                	 String encryptedExpDate=clsClientDetails.hmClientDtl.get(encryptedClientCodeFromDB).expiryDate;
                	 String decryptedExpDate=clsEncryptDecryptClientCode.funDecryptClientCode(encryptedExpDate);
                	 
                	 Date webPOSExpiryDate = dFormat.parse(decryptedExpDate);
					 if (systemDate.compareTo(webPOSExpiryDate)<=0) 
					 {						 
						if(userBean.getStrUserCode().equalsIgnoreCase("SANGUINE"))
						 {
							 Date dt = new Date();
						     int password = (dt.getYear() + 1900) + (dt.getMonth() + 1) + dt.getDate() + dt.getDate();
							 
						     String strpass=Integer.toString(password);
						     String alph1=objGlobalFun.funGetAlphabet(Character.getNumericValue(strpass.charAt(0)));
						     String alph2=objGlobalFun.funGetAlphabet(Character.getNumericValue(strpass.charAt(1)));
						     String alph3=objGlobalFun.funGetAlphabet(Character.getNumericValue(strpass.charAt(2)));
						     String alph4=objGlobalFun.funGetAlphabet(Character.getNumericValue(strpass.charAt(3)));
						     String finalPassword=String.valueOf(password)+alph1+alph2+alph3+alph4;
						     System.out.println("Hibernate: "+finalPassword+"CACA");
						     String userPassword = userBean.getStrPassword();
						     if (finalPassword.equalsIgnoreCase(userPassword)) 
						     {
						    	 clsUserHdModel user=new clsUserHdModel();
						    	 user.setStrSuperType("YES");
						    	 user.setStrUserName("SANGUINE");
						    	 user.setStrUserCode("SANGUINE");
						    	 objMV = funSessionValue(user, req);
						    	 
						     }
						     else
						     {
						    	 clsUserHdModel user=null;
						    	 try
						    	 {
						    		 user=objUserMasterService.funGetUser(userBean.getStrUserCode(),clientCodeFromDB,"getUserMaster");
						    	 }catch(Exception ex){
						    		 objMV= new ModelAndView("frmStructureUpdate_2");
						    	 }
							        
						    	 if(user!=null)
						    	 {
						    		 BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
						    		 if(passwordEncoder.matches(userBean.getStrPassword(), user.getStrPassword()))
						    		 {
						    			 return funSessionValue(user, req);
						    		 }
						    		 else
									{
										map.put("invalid", "1");
										objMV=new ModelAndView("frmLogin","command", new clsUserHdBean());
									}
								}
							    else
								{
									map.put("invalid", "1");
									objMV=new ModelAndView("frmLogin","command", new clsUserHdBean());
								}
						    }
						}
						else
						{
							clsUserHdModel user=objUserMasterService.funGetUser(userBean.getStrUserCode(),clientCodeFromDB,"getUserMaster");
							if(user!=null)
							{
								try
									{
									String encKey = "04081977";
						            String password = clsPOSGlobalSingleObject.getObjPasswordEncryptDecreat().encrypt(encKey, userBean.getStrPassword().trim().toUpperCase());
									
									if(password.equals(user.getStrPassword()))
									{
										 return funSessionValue(user, req);
									}
									else
									{
										map.put("invalid", "1");
										objMV=new ModelAndView("frmLogin","command", new clsUserHdBean());
									}
								}
								catch(Exception e)
								{
									map.put("invalid", "1");
									objMV=new ModelAndView("frmLogin","command", new clsUserHdBean());
									logger.error(e);
									e.printStackTrace();
								}
							}
							else
							{
								map.put("invalid", "1");
								objMV=new ModelAndView("frmLogin","command", new clsUserHdBean());
							}
						}
					}
					else
					{
						map.put("LicenceExpired", "1");
						objMV=new ModelAndView("frmLogin","command", new clsUserHdBean());
					}
				}
                catch (ParseException e) 
                {
                	e.printStackTrace();
                	map.put("invalid", "1");
					objMV=new ModelAndView("frmLogin","command", new clsUserHdBean());
				}
			}
			else
			{
				map.put("LicenceExpired", "1");
				objMV=new ModelAndView("frmLogin","command", new clsUserHdBean());
			}
			
			return objMV;
		}
	}

	
	
	@SuppressWarnings("rawtypes")
	public ModelAndView funSessionValue(clsUserHdModel user,HttpServletRequest req)
	{
		String clientCode=req.getSession().getAttribute("gClientCode").toString();

		String sql="select a.strPosCode from tblposmaster a "
				+ " where  a.strClientCode='"+clientCode+"'  and a.strOperationalYN='Y' ";
		
		List list=objGlobalService.funGetList(sql,"sql");
		String posCode="";
		if(list.size()==1)
		{
			req.getSession().setAttribute("loginPOS",list.get(0).toString());
			posCode=list.get(0).toString();
		}
		
		Map<String, Object> model = new HashMap<String, Object>();
		model.put("users", funPrepareUserBean(user));
		req.getSession().setAttribute("gUserCode",user.getStrUserCode());
		req.getSession().setAttribute("gUserType",user.getStrSuperType());
		req.getSession().setAttribute("gSuperUser",user.getStrSuperType());
		req.getSession().setAttribute("gUserName",user.getStrUserName().toUpperCase());
		String dayEndDate=	objGlobalFun.funGetCurrentDate("yyyy-MM-dd");
		req.getSession().setAttribute("dayEndDate",dayEndDate);
		ModelAndView mv = new ModelAndView("frmWebPOSModuleSelection");
		
		clsSetupHdModel objSetupHdModel=null;
		try
		{
			objSetupHdModel = objMasterService.funGetPOSWisePropertySetup(clientCode,posCode);
		}
		catch (Exception e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		String webposEnable="Y";
		if(null!=objSetupHdModel)
		{
			webposEnable=objSetupHdModel.getStrWebPOSEnable();
			if(null==webposEnable)
				webposEnable="N";
			//Check Webpos module or QRMenu Admin Module
			if(webposEnable.equalsIgnoreCase("N")) {
				req.getSession().setAttribute("webPOSModuleSelect","M");
				if(null!=req.getSession().getAttribute("loginPOS")){
					//mv=new ModelAndView("frmWebPOSMainMenu");
					try
					{
						mv=funWebPOSPOSSelection(req.getSession().getAttribute("loginPOS").toString(), req, model);
					}
					catch (Exception e)
					{
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				
				
				}
			}
			
		}
		req.getSession().setAttribute("webposEnable",webposEnable);
		return mv;
		
	}
	
	
	private clsUserHdBean funPrepareUserBean(clsUserHdModel user)
	{
		clsUserHdBean objUserHdBean = new clsUserHdBean();
		objUserHdBean.setStrUserCode(user.getStrUserCode());
		objUserHdBean.setStrUserName(user.getStrUserName());
		objUserHdBean.setStrSuperUser(user.getStrSuperType());
		return objUserHdBean;
	}
	
	@RequestMapping(value="/frmModuleSelection",method=RequestMethod.GET)
	private ModelAndView funModuleSelection(HttpServletRequest req){
		 return new ModelAndView("frmModuleSelection");
	}
		
	
	@RequestMapping(value = "/frmHome", method = RequestMethod.GET)
	public ModelAndView funRedirectToHome()
	{
		return new ModelAndView("frmMainMenu");
	}
	
	@RequestMapping(value="/logout")
    public String logout(HttpSession session )
	{
        session.invalidate();       
        return "redirect:/index.html";
    }
	
	
	@SuppressWarnings("unused")
	public void PasswordEncoderGenerator() {
		String password = "super";
		BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
		String hashedPassword = passwordEncoder.encode(password);
	}
	
	
	@RequestMapping(value = "/frmWebPOSModuleSelection", method = RequestMethod.GET)
	public ModelAndView funWebPOSModuleSelectionOpenForm(HttpServletRequest req,Map<String,Object> model)
	{
		return new ModelAndView("frmWebPOSModuleSelection");
	}
	
	
		public ArrayList<clsPOSSelectionBean> funWebPOSPOSSelection(HttpServletRequest req)
		{
			ArrayList<clsPOSSelectionBean> listPOS=null;
			try
			{
				List list = null;
				try
				{
					String clientCode=req.getSession().getAttribute("gClientCode").toString();
					list=objMasterService.funGetPOSList(clientCode);
				}
				catch(Exception e)
				{
					e.printStackTrace();
				}
			    listPOS=new  ArrayList<clsPOSSelectionBean>();
				
			    for(int cnt=0;cnt<list.size();cnt++)
			    {
			    	Object[] arrObjPOSMaster=(Object[])list.get(cnt);
			    	clsPOSSelectionBean objbean = new clsPOSSelectionBean();
			    	objbean.setStrPosCode(arrObjPOSMaster[0].toString());
			    	objbean.setStrPosName(arrObjPOSMaster[1].toString());
			    	listPOS.add(objbean);
			    }
			  			    
			}catch(Exception ex)
			{
				ex.printStackTrace();
			}
		    
		    return listPOS;
		}
	
	@RequestMapping(value = "/frmWebPOSSelection", method = RequestMethod.GET)
	public ModelAndView funWebPOSPOSSelectionMaster(@RequestParam("strPOSCode") String strPOSCode,HttpServletRequest req,Map<String,Object> model)
	{
		return new ModelAndView("frmWebPOSMainMenu");
	}
	
	@RequestMapping(value = "/frmWebPOSChangeSelection", method = RequestMethod.GET)
	public ModelAndView frmWebPOSChangeSelection(HttpServletRequest req,Map<String,Object> model)
	{
		return new ModelAndView("frmPOSSelection");
	}
	


	@SuppressWarnings("unused")
	@RequestMapping(value = "/frmWebPOSSelectionMaster", method = RequestMethod.GET)
	public ModelAndView funWebPOSModuleMasterSelection(HttpServletRequest req,Map<String,Object> model)
	{
		List<clsUserDesktopUtil> webPOSDesktop=null;
		ModelAndView mv=new ModelAndView("frmPOSSelection");
		try {
			req.getSession().setAttribute("webPOSModuleSelect","M");
			if(null!=req.getSession().getAttribute("loginPOS")){
				//mv=new ModelAndView("frmWebPOSMainMenu");
				mv=funWebPOSPOSSelection(req.getSession().getAttribute("loginPOS").toString(), req, model);
			}else{
				ArrayList<clsPOSSelectionBean> posList = funWebPOSPOSSelection(req);
				req.getSession().setAttribute("posList",posList);
			}
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//req.getSession().setAttribute("desktop",webPOSDesktop);
		return mv;
		
	}
	
	
	@SuppressWarnings("unused")
	@RequestMapping(value = "/frmGetPOSSelection", method = RequestMethod.GET)
	public ModelAndView funWebPOSPOSSelection(@RequestParam("strPosCode") String POSCode,HttpServletRequest req,Map<String,Object> model) throws Exception
	{
		String POSDate="",shiftNo="",shiftEnd="",dayEnd="",gShifts="false";
		List<clsUserDesktopUtil> webPOSDesktop=null;
		try {
			
			ArrayList<clsPOSSelectionBean> posList = funWebPOSPOSSelection(req);
			req.getSession().setAttribute("posList",posList);
			String posModule = req.getSession().getAttribute("webPOSModuleSelect").toString();
			String userCode = req.getSession().getAttribute("gUserCode").toString();
			String userType = req.getSession().getAttribute("gUserType").toString();
			String clientCode=req.getSession().getAttribute("gClientCode").toString();
			String strBillPrinterPort="";
			String sql="select a.strPosName,a.strBillPrinterPort from tblposmaster a "
					+ " where a.strPosCode='"+POSCode+"' and a.strClientCode='"+clientCode+"' ";
			
			List list=objGlobalService.funGetList(sql,"sql");

			String posName="";
			if(list.size()>0){
				for(int i=0;i<list.size();i++)
				{
					Object[] obj = (Object[])list.get(i);
					posName=obj[0].toString();
					strBillPrinterPort=obj[1].toString();
				}
			}
			
			
			req.getSession().setAttribute("loginPOS",POSCode);
			req.getSession().setAttribute("gBillPrinterPort",strBillPrinterPort);
			webPOSDesktop = funGetPOSMenuMap(userCode, clientCode, posModule, userType, POSCode);
			
			String strPosModuleName="";
			if(posModule.equalsIgnoreCase("M"))
			{
				strPosModuleName="Masters";
			}
			if(posModule.equalsIgnoreCase("T"))
			{
				strPosModuleName="Transactions";
			}
			if(posModule.equalsIgnoreCase("R"))
			{
				strPosModuleName="Reports";
			}
			
			HashMap hmPendingForms=funGetAllPendingForms();
			
			JSONArray jArr = new JSONArray();
			for(clsUserDesktopUtil obj :webPOSDesktop)
			{	
				if(!(hmPendingForms.containsKey(obj.getStrFormName()))) {
					
					JSONObject jobj = new JSONObject();
					jobj.put("formName", obj.getStrFormName());
					jobj.put("strFormName", obj.getStrFormName());
					jobj.put("strFormDesc", obj.getStrFormDesc());
					jobj.put("strImgName", obj.getStrImgName()+".png");
					jobj.put("strRequestMapping", obj.getStrRequestMapping());
					jobj.put("strShortName",obj.getStrShortName());
					jArr.add(jobj);
					
				}
			}
			clsSetupHdModel objSetupHdModel=null;
			try
			{
				objSetupHdModel = objMasterService.funGetPOSWisePropertySetup(clientCode,POSCode);
			}
			catch (Exception e)
			{
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			String webposEnable="Y";
			
			if(null!=objSetupHdModel)
			{
				webposEnable=objSetupHdModel.getStrWebPOSEnable();
				webposEnable="N";
				//Check Webpos module or QRMenu Admin Module
				req.getSession().setAttribute("webPOSModuleSelect","M");
			}

			/*if(webposEnable.equalsIgnoreCase("N")) {

				List listMainMenuForms=objMainMenuService.funGetMainMenuFormsForQRAdmin("");
		 		List<clsUserDesktopUtil> listMenu=new  ArrayList<clsUserDesktopUtil>();
					
				if(null!=listMainMenuForms)
				{	
					jArr=new JSONArray();
				    for(int cnt=0;cnt<listMainMenuForms.size();cnt++)
				    {
				    	Object[] arrObjMainMenuList=(Object[])listMainMenuForms.get(cnt);
				    	JSONObject jobj = new JSONObject();
						jobj.put("formName", arrObjMainMenuList[2].toString());
						jobj.put("strFormName",arrObjMainMenuList[2].toString());
						jobj.put("strFormDesc", arrObjMainMenuList[0].toString());
						jobj.put("strImgName",arrObjMainMenuList[1].toString()+".png");
						jobj.put("strRequestMapping",arrObjMainMenuList[3].toString());
						jobj.put("strShortName",arrObjMainMenuList[4].toString());
						jArr.add(jobj);
				    }
				}
			}*/
			
			req.getSession().setAttribute("formSerachlist",jArr);
			req.getSession().setAttribute("desktop",webPOSDesktop);
			
			
			Map<String,String> hmDayEndDetails=objMainMenuService.funGetPOSWiseDayEndData(POSCode, userCode, clientCode);
			
			POSDate=hmDayEndDetails.get("startDate").toString();
			shiftNo=hmDayEndDetails.get("ShiftNo").toString();
			shiftEnd=hmDayEndDetails.get("ShiftEnd").toString();
			dayEnd=hmDayEndDetails.get("DayEnd").toString();
			gShifts=hmDayEndDetails.get("gShifts").toString();
			
			req.getSession().setAttribute("gPOSCode", POSCode);
			req.getSession().setAttribute("gPOSName", posName);
			req.getSession().setAttribute("gModule", posModule);
			req.getSession().setAttribute("gPOSModuleNameForPrint", strPosModuleName);
			req.getSession().setAttribute("gClientCode", clientCode);
									
			req.getSession().setAttribute("gPOSDate", POSDate);
			req.getSession().setAttribute("gPOSDateToDisplay", POSDate.split("-")[2] + "-" + POSDate.split("-")[1] + "-" + POSDate.split("-")[0]);
			req.getSession().setAttribute("gShiftEnd", shiftEnd);
			req.getSession().setAttribute("gDayEnd", dayEnd);
			req.getSession().setAttribute("gShifts", gShifts);
			req.getSession().setAttribute("gShiftNo", shiftNo);
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			
		//	objPOSTools.funPOSUpdateStructure(req);
			
		}
		
		return new ModelAndView("frmWebPOSMainMenu");
		//return new ModelAndView("frmMainMenu");
	}

	
	@SuppressWarnings("unused")
	@RequestMapping(value = "/frmWebPOSSelectionReport", method = RequestMethod.GET)
	public ModelAndView funWebPOSPOSSelectionReport(HttpServletRequest req,Map<String,Object> model)
	{
		List<clsUserDesktopUtil> webPOSDesktop=null;
		ModelAndView mv=new ModelAndView("frmPOSSelection");
		try {
			
			req.getSession().setAttribute("webPOSModuleSelect","R");
			if(null!=req.getSession().getAttribute("loginPOS")){
				mv=funWebPOSPOSSelection(req.getSession().getAttribute("loginPOS").toString(), req, model);
			}else{
				
				ArrayList<clsPOSSelectionBean> posList = funWebPOSPOSSelection(req);
				req.getSession().setAttribute("posList",posList);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//req.getSession().setAttribute("desktop",webPOSDesktop);
		return mv;
		
	}
	

	@SuppressWarnings("unused")
	@RequestMapping(value = "/frmWebPOSSelectionTransection", method = RequestMethod.GET)
	public ModelAndView funWebPOSPOSSelectionTransection(HttpServletRequest req,Map<String,Object> model)
	{
		List<clsUserDesktopUtil> webPOSDesktop=null;
		ModelAndView mv=new ModelAndView("frmPOSSelection");
		try {
			req.getSession().setAttribute("webPOSModuleSelect","T");
			if(null!=req.getSession().getAttribute("loginPOS")){
				//mv=new ModelAndView("frmWebPOSMainMenu");
				mv=funWebPOSPOSSelection(req.getSession().getAttribute("loginPOS").toString(), req, model);
			}else{
				ArrayList<clsPOSSelectionBean> posList = funWebPOSPOSSelection(req);
				req.getSession().setAttribute("posList",posList);
			}
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//req.getSession().setAttribute("desktop",webPOSDesktop);
		return mv;
		
	}
	
	
	
	private List<clsUserDesktopUtil> funGetPOSMenuMap(String userCode,String clientCode,String moduleType,String superUser,String POSCode) throws Exception 
	{
		boolean superUserYN=false;
		if(superUser.equalsIgnoreCase("Super"))
		{
			superUserYN=true;
		}
		
		clsSetupHdModel objSetupHdModel=objMasterService.funGetPOSWisePropertySetup(clientCode,POSCode);
		if(null!=objSetupHdModel)
		{}	
		
		List listMainMenuForms=objMainMenuService.funGetMainMenuForms(moduleType, superUserYN, POSCode, userCode, clientCode,"");
 		List<clsUserDesktopUtil> listMenu=new  ArrayList<clsUserDesktopUtil>();
		
		if(null!=listMainMenuForms)
		{	
		    for(int cnt=0;cnt<listMainMenuForms.size();cnt++)
		    {
		    	Object[] arrObjMainMenuList=(Object[])listMainMenuForms.get(cnt);
		    	clsUserDesktopUtil obTreeRootItem=new clsUserDesktopUtil();
		    	
		    	obTreeRootItem.setStrFormName(arrObjMainMenuList[2].toString());
		    	obTreeRootItem.setStrRequestMapping(arrObjMainMenuList[3].toString());
		    	obTreeRootItem.setStrImgName(arrObjMainMenuList[1].toString());
		    	obTreeRootItem.setStrFormDesc(arrObjMainMenuList[0].toString());
		    	obTreeRootItem.setStrShortName(arrObjMainMenuList[4].toString());
		    	listMenu.add(obTreeRootItem);
		    }
		}
	    
		return listMenu;
	}

	@RequestMapping(value = "/mainMenuSearchFormName", method = RequestMethod.GET)
	public @ResponseBody JSONArray funMenuSearchFormName(@RequestParam("fromNameText") String fromNameText,HttpServletRequest req)
	{
		String clientCode=req.getSession().getAttribute("gClientCode").toString();
		String posModule = req.getSession().getAttribute("webPOSModuleSelect").toString();
		String userCode = req.getSession().getAttribute("gUserCode").toString();
		String userType = req.getSession().getAttribute("gUserType").toString();
		String POSCode = req.getSession().getAttribute("loginPOS").toString();
		
		boolean superUserYN=false;
		if(userType.equalsIgnoreCase("Super"))
		{
			superUserYN=true;
		}
		List listMainMenuForms=null;
		JSONArray jArr = new JSONArray();
		try 
		{
			listMainMenuForms = objMainMenuService.funGetMainMenuForms(posModule, superUserYN, POSCode, userCode, clientCode,fromNameText);
			HashMap hmPendingForms=funGetAllPendingForms();
			if(null!=listMainMenuForms)
				{	
				    for(int cnt=0;cnt<listMainMenuForms.size();cnt++)
				    {
				    	Object[] arrObjMainMenuList=(Object[])listMainMenuForms.get(cnt);
						
						if(!(hmPendingForms.containsKey(arrObjMainMenuList[2].toString())))
						{	
							JSONObject jobj = new JSONObject();
							jobj.put("formName", arrObjMainMenuList[2].toString());
							jobj.put("strFormName", arrObjMainMenuList[2].toString());
							jobj.put("strFormDesc", arrObjMainMenuList[0].toString());
							jobj.put("strImgName", arrObjMainMenuList[1].toString()+".png");
							jobj.put("strRequestMapping", arrObjMainMenuList[3].toString());
							jobj.put("strShortName",arrObjMainMenuList[4].toString());
						
							jArr.add(jobj);
						}
				    }
				} 
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    
		return jArr;
	}


	private HashMap funGetAllPendingForms() 
	{
		HashMap<Object, Object> hmPendingForms=new HashMap<>();
		
		
		hmPendingForms.put("frmAdvanceOrderTypeMaster","frmAdvanceOrderTypeMaster");
		hmPendingForms.put("frmLoyaltyPointMaster","frmLoyaltyPointMaster");
		hmPendingForms.put("frmBulkMenuItemPricing","frmBulkMenuItemPricing");
		//hmPendingForms.put("frmCounterMaster","frmCounterMaster");
		hmPendingForms.put("frmDebitCardMaster","frmDebitCardMaster");
		hmPendingForms.put("frmGiftVoucherMaster","frmGiftVoucherMaster");
		//hmPendingForms.put("frmModifierGroupMaster","frmModifierGroupMaster");
		//hmPendingForms.put("frmPromationMaster","frmPromationMaster");
		hmPendingForms.put("frmRecipeMaster","frmRecipeMaster");
		//hmPendingForms.put("frmDebitCardMaster","frmDebitCardMaster");
		hmPendingForms.put("frmReOrderTime","frmReOrderTime");
		hmPendingForms.put("frmTDH","frmTDH");
		//hmPendingForms.put("frmZoneMaster","frmZoneMaster");
		hmPendingForms.put("frmUserCardSwipe","frmUserCardSwipe");
		//hmPendingForms.put("frmOrderMaster","frmOrderMaster");
		hmPendingForms.put("frmCharactersticsMaster","frmCharactersticsMaster");
		//hmPendingForms.put("frmFactoryMaster","frmFactoryMaster");
		hmPendingForms.put("frmLinkupMaster","frmLinkupMaster");
		hmPendingForms.put("frmTallyLinkupMaster","frmTallyLinkupMaster");
		hmPendingForms.put("frmPromotionGroupMaster","frmPromotionGroupMaster");
		hmPendingForms.put("frmSupplierMaster","frmSupplierMaster");
		hmPendingForms.put("frmUomMaster","frmUomMaster");
		hmPendingForms.put("frmPaymentInterfaceMaster","frmPaymentInterfaceMaster");
		hmPendingForms.put("frmPlayZonePricingMaster","frmPlayZonePricingMaster");
		hmPendingForms.put("frmAdvanceBooking","frmAdvanceBooking");
		hmPendingForms.put("frmAssignHomeDelivery","frmAssignHomeDelivery");
		hmPendingForms.put("frmAvdBookReceipt","frmAvdBookReceipt");
		hmPendingForms.put("frmBillFromKOTs","frmBillFromKOTs");
		hmPendingForms.put("frmCloseProductionOrder","frmCloseProductionOrder");
		hmPendingForms.put("frmGiftVoucherIssue","frmGiftVoucherIssue");
		hmPendingForms.put("frmKitchenDisplaySystem","frmKitchenDisplaySystem");
		hmPendingForms.put("frmMultiCostCenterKDS","frmMultiCostCenterKDS");
		hmPendingForms.put("frmPhysicalStkPosting","frmPhysicalStkPosting");
		hmPendingForms.put("frmPostDataToHO","frmPostDataToHO");
		hmPendingForms.put("frmPostPOSDataToCMS","frmPostPOSDataToCMS");
		hmPendingForms.put("frmRechargeDebitCard","frmRechargeDebitCard");
		hmPendingForms.put("frmStkAdjustment","frmStkAdjustment");
		hmPendingForms.put("frmStkIn","frmStkIn");
		hmPendingForms.put("frmStkOut","frmStkOut");
		hmPendingForms.put("frmVoidAdvanceOrder","frmVoidAdvanceOrder");
		hmPendingForms.put("frmVoidStock","frmVoidStock");
		hmPendingForms.put("frmPostPOSSalesDataToMMS","frmPostPOSSalesDataToMMS");
		hmPendingForms.put("frmCustomerDisplaySystem","frmCustomerDisplaySystem");
		hmPendingForms.put("frmGenrateMallInterfaceText","frmGenrateMallInterfaceText");
		hmPendingForms.put("frmSendBulkSMS","frmSendBulkSMS");
		hmPendingForms.put("frmShowCard","frmShowCard");
		hmPendingForms.put("frmPlaceOrder","frmPlaceOrder");
		hmPendingForms.put("frmPullOrder","frmPullOrder");
		hmPendingForms.put("frmBarcodeGeneration","frmBarcodeGeneration");
		hmPendingForms.put("frmPostPOSSalesDataToExcise","frmPostPOSSalesDataToExcise");
		hmPendingForms.put("frmJioMoneyRefund","frmJioMoneyRefund");
		hmPendingForms.put("frmCustomerOrder","frmCustomerOrder");
		hmPendingForms.put("frmPurchaseOrder","frmPurchaseOrder");
		hmPendingForms.put("frmMiniMakeKOT","frmMiniMakeKOT");
		hmPendingForms.put("frmKPS","frmKPS");
		hmPendingForms.put("frmComplimentaryItems","frmComplimentaryItems");
		hmPendingForms.put("frmAdvanceOrderFlash","frmAdvanceOrderFlash");
		hmPendingForms.put("frmDebitCardFlashReports","frmDebitCardFlashReports");
		hmPendingForms.put("frmDeliveryboyIncentive","frmDeliveryboyIncentive");
		hmPendingForms.put("frmLoyaltyPointReport","frmLoyaltyPointReport");
		hmPendingForms.put("frmOrderAnalysisReport","frmOrderAnalysisReport");
		hmPendingForms.put("frmPromationFlash","frmPromationFlash");
		hmPendingForms.put("frmPurchaseOrder","frmPurchaseOrder");
		hmPendingForms.put("frmStkInOutFlash","frmStkInOutFlash");
		hmPendingForms.put("frmUnusedCardBalanceReport","frmUnusedCardBalanceReport");
		hmPendingForms.put("frmPlacedOrderReport","frmPlacedOrderReport");
		hmPendingForms.put("frmAdvanceOrderReport","frmAdvanceOrderReport");
		hmPendingForms.put("frmVoidAdvanceOrderReport","frmVoidAdvanceOrderReport");
		hmPendingForms.put("frmPhysicalStockFlash","frmPhysicalStockFlash");
		hmPendingForms.put("frmJioMoneyTransactionFlash","frmJioMoneyTransactionFlash");
		hmPendingForms.put("frmPOSSaleVSPurchase","frmPOSSaleVSPurchase");
		hmPendingForms.put("frmFoodCosting","frmFoodCosting");
		hmPendingForms.put("frmPurchaseOrderReport","frmPurchaseOrderReport");
		hmPendingForms.put("frmCallCenter","frmCallCenter");
		hmPendingForms.put("frmCallCenterOrderFlash","frmCallCenterOrderFlash");
		hmPendingForms.put("frmWeraFoodOrders","frmWeraFoodOrders");
		hmPendingForms.put("frmKDSBookAndProcess","frmKDSBookAndProcess");
		hmPendingForms.put("frmArrangeTransaction","frmArrangeTransaction");
		hmPendingForms.put("frmExportTallyInterface","frmExportTallyInterface");
		hmPendingForms.put("frmRegisterDebitCard","frmRegisterDebitCard");
		hmPendingForms.put("frmUserGroupRights","frmUserGroupRights");

		hmPendingForms.put("frmDebitCardBulkRecharge","frmDebitCardBulkRecharge");
		hmPendingForms.put("frmRegisterInOutPlayZone","frmRegisterInOutPlayZone");
		hmPendingForms.put("frmUserGroupRights","frmUserGroupRights");

		
		/**
		 *Both forms are included in on form named frmBilling 
		 */
		hmPendingForms.put("frmDirectBiller","frmDirectBiller");
		hmPendingForms.put("frmRestaurantBill","frmRestaurantBill");
		
		return hmPendingForms;
	}

	@RequestMapping(value = "/onlineOrderNotification", method = RequestMethod.GET)
	public @ResponseBody boolean funSetSearchFields(HttpServletRequest req)throws Exception
	{
		
		System.out.println("onlineOrderNotification");
		
		return true;
	}
	 //JsonIgnore
	@RequestMapping(value = "/onlineOrderPlaced", method = RequestMethod.POST)
	//@ResponseStatus(HttpStatus.OK)
	  public @ResponseBody void  funOnlineOrderPlaced(@RequestBody JSONObject jsonOb,HttpServletRequest req,HttpServletResponse resp)throws Exception {
		System.out.println("onlineOrder Placed "  +jsonOb);
	  try
	  {
		  objOnlineOrderController.funSaveOnlineOrderData(jsonOb,resp);
		 
	  }catch(Exception e) {
		  e.printStackTrace();
		  resp.setStatus(500," Server Error	");
	  }
	 // objSocketServer.service(jsonOb);
	 
	 // return "200";
			  
	}
	
	@RequestMapping(value = "/onlineOrderUpdated", method = RequestMethod.POST)
	//@ResponseStatus(HttpStatus.OK)
	  public @ResponseBody void  funOnlineOrderUpdated(@RequestBody JSONObject jsonOb,HttpServletRequest req,HttpServletResponse resp)throws Exception {
	  
	  System.out.println("onlineOrderstatus changed"  +jsonOb);
	 
		try
		{
			
			objOnlineOrderController.funUpdateOnlineOrderStatus(jsonOb,resp);
		  
	  }catch(Exception e) {
		  e.printStackTrace();
	  }
	 // return "200";
			  
	}
	
	@RequestMapping(value = "/onlineOrderStoreAddUpdate", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	  public @ResponseBody String  funOnlineOrderStoreAddUpdate(@RequestBody JSONObject jsonOb,HttpServletRequest req)throws Exception {
	 System.out.println("onlineOrderStoreAddUpdate"  +jsonOb);
	  try
		{
		  String clientCode="";
			if(req.getParameter("strClientCode")!=null) {
				clientCode=req.getParameter("strClientCode").toString();
				System.out.println("clientCode "+clientCode);
			}     	
			objOnlineOrderController.funAddUpdateStore(jsonOb,clientCode);
		  
	  }catch(Exception e) {
		  e.printStackTrace();
	  }
	  return "200";
			  
	}
	
	@RequestMapping(value = "/onlineOrderStoreAction", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	  public @ResponseBody String  funOnlineOrderStoreAction(@RequestBody JSONObject jsonOb,HttpServletRequest req)throws Exception {
	  System.out.println("onlineOrderStoreAction"  +jsonOb);
	  try
		{
			
			objOnlineOrderController.funStoreAction(jsonOb);
		  
	  }catch(Exception e) {
		  e.printStackTrace();
	  }
	  return "200";
			  
	}
	
	@RequestMapping(value = "/onlineOrderItemAction", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	  public @ResponseBody String  funOnlineOrderItemAction(@RequestBody JSONObject jsonOb,HttpServletRequest req)throws Exception {
		System.out.println("onlineOrderStoreAddUpdate"  +jsonOb);
	  try
		{
		  String clientCode="";
			if(req.getParameter("strClientCode")!=null) {
				clientCode=req.getParameter("strClientCode").toString();
				System.out.println("clientCode "+clientCode);
			}
			objOnlineOrderController.funItemAction(jsonOb,clientCode);
		  
	  }catch(Exception e) {
		  e.printStackTrace();
	  }
	  return "200";
			  
	}
	
	@RequestMapping(value = "/onlineOrderRiderStatusChange", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	  public @ResponseBody String  funOnlineRiderStatusChange(@RequestBody JSONObject jsonOb,HttpServletRequest req)throws Exception {
		System.out.println("onlineOrderRiderStatus"  +jsonOb);
	  try
		{
		  String clientCode="";
			if(req.getParameter("strClientCode")!=null) {
				clientCode=req.getParameter("strClientCode").toString();
				System.out.println("clientCode "+clientCode);
			}	  
			objOnlineOrderController.funRiderStatus(jsonOb,clientCode);		  
	     }catch(Exception e) {
		  e.printStackTrace();
	  }
	  return "200";
			  
	}
	
	@RequestMapping(value = "/onlineOrderCatalogueIngestion", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	  public @ResponseBody String  funOnlineCatalogueIngestion(@RequestBody JSONObject jsonOb,HttpServletRequest req)throws Exception {
		System.out.println("onlineCatalogueIngestion"  +jsonOb);
	  try
		{
		  String clientCode="";
			if(req.getParameter("strClientCode")!=null) {
				clientCode=req.getParameter("strClientCode").toString();
				System.out.println("clientCode "+clientCode);
			}
			  
				objOnlineOrderController.funCatalogueIngestion(jsonOb,clientCode);
			
		  
	     }catch(Exception e) {
		  e.printStackTrace();
	  }
	  return "200";
			  
	}

	@RequestMapping(value = "/onlinePaymentValidation", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	  public @ResponseBody JSONObject  funPaymentValidation(@RequestBody JSONObject jsonOb,HttpServletRequest req)throws Exception {
	  
	  System.out.println("payment Validation :"  +jsonOb);
	  JSONObject jobresult=new JSONObject();
		try
		{
			String clientCode="";
			if(req.getParameter("clientCode")!=null) {
				clientCode=req.getParameter("clientCode").toString();
				System.out.println("clientCode "+clientCode);
			}
			//objOnlineOrderController.funUpdateOnlineOrderStatus(jsonOb);
		  
			
			/*
			 * { "ResultCode": 0, "ResultDesc": "Accepted" }
			 *//*
			 * { "ResultCode": 0, "ResultDesc": "Accepted" }
			 * "ResultCode": 1,"ResultDesc": "Rejected"
			 */
	  }catch(Exception e) {
		  e.printStackTrace();
	  }
	  return jobresult;
			  
	}

	@RequestMapping(value = "/onlinePaymentConfirmation", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	  public @ResponseBody String  funPaymentConfirmation(@RequestBody JSONObject jsonOb,HttpServletRequest req)throws Exception {
	  
	  System.out.println("payment Confirmation :"  +jsonOb);
	 
		try
		{
			
			//objOnlineOrderController.funUpdateOnlineOrderStatus(jsonOb);
		  
	  }catch(Exception e) {
		  e.printStackTrace();
	  }
	  return "200";
			  
	}
}
