package com.sanguine.webpos.controller;


import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;

import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.ImageIcon;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.File;

import org.springframework.web.servlet.ModelAndView;

import com.lowagie.text.pdf.codec.Base64.InputStream;

import java.io.OutputStream;

import com.sanguine.base.service.clsBaseServiceImpl;
import com.sanguine.controller.clsGlobalFunctions;
import com.sanguine.webpos.bean.clsPOSMenuItemMasterBean;
import com.sanguine.webpos.model.clsMenuItemMasterModel;
import com.sanguine.webpos.model.clsMenuItemMasterModel_ID;
import com.sanguine.webpos.model.clsRecipeDtlModel;
import com.sanguine.webpos.model.clsRecipeMasterModel;
import com.sanguine.webpos.model.clsSubGroupMasterHdModel;
import com.sanguine.webpos.sevice.clsPOSMasterService;
import com.sanguine.webpos.util.clsPOSUtilityController;

@Controller
public class clsPOSMenuItemMasterController{

	@Autowired
	private clsGlobalFunctions objGlobalFunctions;
	
	@Autowired
	private clsGlobalFunctions objGlobal=null;
	
	@Autowired
	private clsPOSGlobalFunctionsController objPOSGlobal;
	
	@Autowired
	private clsPOSUtilityController objUtilityController;
	
	@Autowired 
	private clsBaseServiceImpl objBaseServiceImpl;
	
	@Autowired
	clsPOSMasterService objMasterService;
	@Autowired
	private ServletContext servletContext;


	Map<String,String> hmSubGroupName=new HashMap<String,String>();
	Map<String,String> hmSubGroupCode=new HashMap<String,String>();

	@RequestMapping(value = "/frmPOSMenuItem", method = RequestMethod.GET)
	public ModelAndView funOpenForm(Map<String, Object> model,HttpServletRequest request)
	{

		String urlHits="1";
		try{
			urlHits=request.getParameter("saddr").toString();
		}catch(NullPointerException e){
			urlHits="1";
		}
		model.put("urlHits",urlHits);
			
		
		//ProcessTime
		List<String> lstProcessTime=new ArrayList<String>();
		for(int i=1;i<31;i++)
		{
				lstProcessTime.add(String.valueOf(i));
		}
		model.put("ProcessTime", lstProcessTime);
		
		//subgroup data
		String clientCode=request.getSession().getAttribute("gClientCode").toString();
		
		List list=funGetSubGroupGDetail(clientCode);
		model.put("subGroup", list);
		
		if("2".equalsIgnoreCase(urlHits)){
			return new ModelAndView("frmPOSMenuItemMaster_1","command", new clsPOSMenuItemMasterBean());
		}else if("1".equalsIgnoreCase(urlHits)){
			return new ModelAndView("frmPOSMenuItemMaster","command", new clsPOSMenuItemMasterBean());
		}else {
			return null;
		}
	}
	public ArrayList<String> funGetSubGroupGDetail(String clientCode)
	{
		clsSubGroupMasterHdModel objModel=new clsSubGroupMasterHdModel();
		ArrayList<String> lstSGData=new ArrayList<String>();
    	try
    	{
			List objModelList =objMasterService.funLoadAllSubGroup(clientCode);
	    	for(int i=0; i<objModelList.size();i++)
	    	{
	    		objModel =(clsSubGroupMasterHdModel) objModelList.get(i);
	    		hmSubGroupName.put(objModel.getStrSubGroupName(),objModel.getStrSubGroupCode());
	    		hmSubGroupCode.put(objModel.getStrSubGroupCode(),objModel.getStrSubGroupName());
	    		lstSGData.add(objModel.getStrSubGroupName());	
	    	}
    	}
    	catch(Exception e)
    	{
    		e.printStackTrace();
    	}
		return lstSGData;
	}
	
	@RequestMapping(value = "/loadItemCode", method = RequestMethod.GET)
	public @ResponseBody clsPOSMenuItemMasterBean funSetSearchFields(@RequestParam("itemCode") String itemCode,HttpServletRequest req)throws Exception
	{
		String clientCode=req.getSession().getAttribute("gClientCode").toString();
		clsPOSMenuItemMasterBean objMenuItemMasterBean=null;
		
		clsMenuItemMasterModel objMenuItemMasterModel = objMasterService.funGetMenuItemMasterData(itemCode,clientCode);
		objMenuItemMasterBean=new clsPOSMenuItemMasterBean();
		objMenuItemMasterBean.setStrItemCode(objMenuItemMasterModel.getStrItemCode());
		objMenuItemMasterBean.setStrItemName(objMenuItemMasterModel.getStrItemName());
		objMenuItemMasterBean.setStrShortName(objMenuItemMasterModel.getStrShortName());
		objMenuItemMasterBean.setStrExternalCode(objMenuItemMasterModel.getStrExternalCode());
		objMenuItemMasterBean.setStrItemForSale(objMenuItemMasterModel.getStrItemForSale());
		objMenuItemMasterBean.setStrItemType(objMenuItemMasterModel.getStrItemType());
		if(null!=hmSubGroupCode)
			objMenuItemMasterBean.setStrSubGroupCode(hmSubGroupCode.get(objMenuItemMasterModel.getStrSubGroupCode()));
		objMenuItemMasterBean.setStrRawMaterial(objMenuItemMasterModel.getStrRawMaterial());
		objMenuItemMasterBean.setStrTaxIndicator(objMenuItemMasterModel.getStrTaxIndicator());
		objMenuItemMasterBean.setDblPurchaseRate(objMenuItemMasterModel.getDblPurchaseRate());
		objMenuItemMasterBean.setStrRevenueHead(objMenuItemMasterModel.getStrRevenueHead());
		objMenuItemMasterBean.setDblSalePrice(objMenuItemMasterModel.getDblSalePrice());
		objMenuItemMasterBean.setIntProcDay(objMenuItemMasterModel.getIntProcDay());
		objMenuItemMasterBean.setIntProcTimeMin(objMenuItemMasterModel.getIntProcTimeMin());
		objMenuItemMasterBean.setDblMinLevel(objMenuItemMasterModel.getDblMinLevel());
		objMenuItemMasterBean.setDblMaxLevel(objMenuItemMasterModel.getDblMaxLevel());
		objMenuItemMasterBean.setStrStockInEnable(objMenuItemMasterModel.getStrStockInEnable());
		objMenuItemMasterBean.setStrOpenItem(objMenuItemMasterModel.getStrOpenItem());
		objMenuItemMasterBean.setStrItemWiseKOTYN(objMenuItemMasterModel.getStrItemWiseKOTYN());
		objMenuItemMasterBean.setStrItemDetails(objMenuItemMasterModel.getStrItemDetails());
		objMenuItemMasterBean.setStrDiscountApply(objMenuItemMasterModel.getStrDiscountApply());
		objMenuItemMasterBean.setStrUOM(objMenuItemMasterModel.getStrUOM());
		objMenuItemMasterBean.setStrOperationalYN(objMenuItemMasterModel.getStrOperationalYN());
		objMenuItemMasterBean.setStrRecipeUOM(objMenuItemMasterModel.getStrRecipeUOM());
		//objMenuItemMasterBean.setDblRecipeConversion(objMenuItemMasterModel.getDblRecipeConversion());
		objMenuItemMasterBean.setDblReceivedConversion(objMenuItemMasterModel.getDblReceivedConversion());
		objMenuItemMasterBean.setDblRecipeConversion(objMenuItemMasterModel.getDblRecipeConversion());
		objMenuItemMasterBean.setStrHSNNo(objMenuItemMasterModel.getStrHSNNo());

		
		return objMenuItemMasterBean;
	}
	

	@RequestMapping(value = "/saveMenuItemMaster", method = RequestMethod.POST)
	public ModelAndView funAddUpdate(@ModelAttribute("command") @Valid clsPOSMenuItemMasterBean objBean,BindingResult result,HttpServletRequest req, @RequestParam("memberImage") MultipartFile file)
	{
		String urlHits="1";
		                                                                                                                                                                   
		try
		{
			urlHits=req.getParameter("saddr").toString();
			String clientCode=req.getSession().getAttribute("gClientCode").toString();
			String userCode=req.getSession().getAttribute("gUserCode").toString();
			String posCode=req.getSession().getAttribute("gPOSCode").toString();
			String itemCode = objBean.getStrItemCode();
			if (itemCode.trim().isEmpty())
			{
				long intCode =objUtilityController.funGetDocumentCodeFromInternal("Item",clientCode);
				itemCode = "I" + String.format("%06d", intCode);
			}
	        clsMenuItemMasterModel objModel = new clsMenuItemMasterModel(new clsMenuItemMasterModel_ID(itemCode, clientCode));
		    objModel.setStrItemCode(itemCode);
		    objModel.setStrItemName(objBean.getStrItemName());
		    objModel.setStrShortName(objBean.getStrShortName());
		    objModel.setStrExternalCode(objBean.getStrExternalCode());
		    objModel.setStrItemForSale(objGlobal.funIfNull(objBean.getStrItemForSale(),"N","Y"));
		    objModel.setStrItemType(objGlobal.funIfNull(objBean.getStrItemType(),"Food", objBean.getStrItemType()));
		    
		    objModel.setStrSubGroupCode(hmSubGroupName.get(objBean.getStrSubGroupCode()));
		    objModel.setStrRawMaterial(objGlobal.funIfNull(objBean.getStrRawMaterial(),"N","Y"));
		    String taxIndicator = objBean.getStrTaxIndicator();
		    if (taxIndicator==null)
		    {
		    	taxIndicator =" ";
		    }
		    objModel.setStrTaxIndicator(taxIndicator);
		    objModel.setDblPurchaseRate(objBean.getDblPurchaseRate());
		    objModel.setStrRevenueHead(objBean.getStrRevenueHead());
		    objModel.setDblSalePrice(objBean.getDblSalePrice());
		    objModel.setIntProcDay(objBean.getIntProcDay());
		    objModel.setIntProcTimeMin(objBean.getIntProcTimeMin());
		    objModel.setDblMinLevel(objBean.getDblMinLevel());
		    objModel.setDblMaxLevel(objBean.getDblMaxLevel());
		    objModel.setStrStockInEnable(objGlobal.funIfNull(objBean.getStrStockInEnable(),"N","Y"));
		    objModel.setStrOpenItem(objGlobal.funIfNull(objBean.getStrOpenItem(),"N","Y"));
		    objModel.setStrItemWiseKOTYN(objGlobal.funIfNull(objBean.getStrItemWiseKOTYN(),"N","Y"));
		    objModel.setStrItemDetails(objBean.getStrItemDetails());
		    objModel.setStrUserCreated(userCode);
		    objModel.setStrUserEdited(userCode);
		    objModel.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		    objModel.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		    objModel.setStrDiscountApply(objGlobal.funIfNull(objBean.getStrDiscountApply(),"N",objBean.getStrDiscountApply()));
		    objModel.setStrDataPostFlag("N");
		    objModel.setStrExciseBrandCode("");
		    objModel.setStrItemImage("");
		    objModel.setTmeTargetMiss(objBean.getTmeTargetMiss());
		    objModel.setStrNoDeliveryDays("");
		    objModel.setStrItemWeight("0.000");
		    objModel.setStrUrgentOrder("N");
		    objModel.setStrWSProdCode("NA");
		    objModel.setStrUOM(objBean.getStrUOM());
		    String strOperationalYN=objBean.getStrOperationalYN();
		    if(strOperationalYN==null)
		    {
		    	strOperationalYN="N";
		    }
		    else
		    {
		    	strOperationalYN="Y";
		    }
		   
		    objModel.setStrOperationalYN(strOperationalYN);
		    objModel.setStrRecipeUOM(objBean.getStrRecipeUOM());
		    objModel.setDblReceivedConversion(objBean.getDblReceivedConversion());
		    objModel.setDblRecipeConversion(objBean.getDblRecipeConversion());
		    objModel.setStrHSNNo(objBean.getStrHSNNo());
		    if (file!=null && file.getSize() != 0) {
				System.out.println(file.getOriginalFilename());
				File imgFolder = new File(System.getProperty("user.dir") + "\\ProductIcon");
				if (!imgFolder.exists()) {
					if (imgFolder.mkdir()) {
						System.out.println("Directory is created! " + imgFolder.getAbsolutePath());
					} else {
						System.out.println("Failed to create directory!");
					}
				}
				
				try {
				File fileImageIcon = new File(System.getProperty("user.dir") + "\\ProductIcon\\" + file.getOriginalFilename());
				String formatName = "jpg";
				ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
				BufferedImage bufferedImage = ImageIO.read(funInputStreamToBytearrayInputStrean(file.getInputStream()));
				String path = fileImageIcon.getPath().toString();			
				ImageIO.write(bufferedImage, "jpg", new File(path));			
				BufferedImage bfImg = scaleImage(150, 155, path);
				ImageIO.write(bfImg, "jpg", byteArrayOutputStream);
				byte[] imageBytes = byteArrayOutputStream.toByteArray();
				ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(imageBytes);
				
					if (fileImageIcon.exists()) {
						fileImageIcon.delete();
						objModel.setImgImage(imageBytes);
					}
					else {
						//objModel.setStrMemberImage(funBlankBlob());
					}
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			else
			{
				String imagePath = servletContext.getRealPath("/resources/images/NoImageAlternate.png");
				

				/*System.out.println(file.getOriginalFilename());*/
				File imgFolder = new File(imagePath);
				if (!imgFolder.exists()) {
					if (imgFolder.mkdir()) {
						System.out.println("Directory is created! " + imgFolder.getAbsolutePath());
					} else {
						System.out.println("Failed to create directory!");
					}
				}
				
				try {
					if(file!=null && !file.isEmpty()){
				File fileImageIcon = new File(System.getProperty("user.dir") + "\\ProductIcon\\" + file.getOriginalFilename());
				String formatName = "jpg";
				ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
				BufferedImage bufferedImage = ImageIO.read(funInputStreamToBytearrayInputStrean(file.getInputStream()));
				String path = fileImageIcon.getPath().toString();	
				
				if(bufferedImage!=null)
				{
					ImageIO.write(bufferedImage, "jpg", new File(imagePath));	
				}
					
				
						
				BufferedImage bfImg = scaleImage(150, 155, imagePath);
				ImageIO.write(bfImg, "jpg", byteArrayOutputStream);
				byte[] imageBytes = byteArrayOutputStream.toByteArray();
				ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(imageBytes);
				
					if (fileImageIcon.exists()) {
						fileImageIcon.delete();
						objModel.setImgImage(imageBytes);
					}
					}
					else {
						//objModel.setStrMemberImage(funBlankBlob());
					}
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
				
			}
		    
		    objMasterService.funSaveUpdateMenuItemMaster(objModel);
						
		    if(objBean.getListChildItemDtl()!=null && objBean.getListChildItemDtl().size()>0)
		    {
		    	//List<clsRecipeDtlModel> listChildItemDtl=objBean.getListChildItemDtl();
		    	
		    	String recipeCode = objBean.getStrRecipeCode();
				if (recipeCode.trim().isEmpty())
				{
					long intCode =objUtilityController.funGetDocumentCodeFromInternal("Recipe",clientCode);
					recipeCode = "R" + String.format("%07d", intCode);
				}
		    	
				clsRecipeMasterModel objRecipe=new clsRecipeMasterModel();
				objRecipe.setStrRecipeCode(recipeCode);
				objRecipe.setStrClientCode(clientCode);
				objRecipe.setStrDataPostFlag("N");
				objRecipe.setStrPOSCode(posCode);
				objRecipe.setStrItemCode(itemCode);
				objRecipe.setStrUserCreated(userCode);
				objRecipe.setStrUserEdited(userCode);
				objRecipe.setDteDateCreated(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
				objRecipe.setDteDateEdited(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
				
				objRecipe.setDteFromDate(objBean.getDteFromDate());
				objRecipe.setDteToDate(objBean.getDteToDate());
				
				List<clsRecipeDtlModel> listChildItemDtl=new ArrayList<>();
				for(clsRecipeDtlModel objDtl:objBean.getListChildItemDtl() ){
					objDtl.setStrPOSCode(posCode);
					objDtl.setStrDataPostFlag("N");
					listChildItemDtl.add(objDtl);
				}
			    
				objRecipe.setListRecipeDtl(listChildItemDtl);
				
				objBaseServiceImpl.funSave(objRecipe);
		    }
			req.getSession().setAttribute("success", true);
			req.getSession().setAttribute("successMessage"," "+itemCode);
			
			String sql = "update tblmasteroperationstatus set dteDateEdited='"+objGlobal.funGetCurrentDateTime("yyyy-MM-dd")+"'  where strTableName='MenuItem' "
			+" and strClientCode='" + clientCode + "'";
			objBaseServiceImpl.funExecuteUpdate(sql, "sql");
									
			return new ModelAndView("redirect:/frmPOSMenuItem.html?saddr="+urlHits);
		}
		catch(Exception ex)
		{
			urlHits="1";
			ex.printStackTrace();
			return new ModelAndView("redirect:/frmFail.html");
		}
   }
	
	
	@RequestMapping(value ="/checkItemName" ,method =RequestMethod.GET)
	public  @ResponseBody boolean funCheckMenuName(@RequestParam("itemName") String itemName,@RequestParam("itemCode") String itemCode, HttpServletRequest req) 
	{
		String clientCode =req.getSession().getAttribute("gClientCode").toString();
		int count=objPOSGlobal.funCheckName(itemName,itemCode,clientCode,"POSMenuItem");

		if(count>0)
			return false;
		else
			return true;
	}
	
	@RequestMapping(value ="/loadRecipeData" ,method =RequestMethod.GET)
	public  @ResponseBody clsRecipeMasterModel funLoadRecipeData(@RequestParam("itemCode") String itemCode, HttpServletRequest req) 
	{
		String clientCode =req.getSession().getAttribute("gClientCode").toString();
		clsRecipeMasterModel objModel=new clsRecipeMasterModel();
		StringBuilder sbSql=new StringBuilder(); 
		try
		{
			List<clsPOSMenuItemMasterBean> listChildItemDtl=new ArrayList<>();
			clsPOSMenuItemMasterBean objDtlModel=null;
			objModel=(clsRecipeMasterModel)objMasterService.funGetSelectedRecipeMasterData(itemCode, clientCode);
			if(objModel.getStrRecipeCode()!=null){
				sbSql.setLength(0);
				sbSql.append("select a.strRecipeCode,a.strChildItemCode,a.dblQuantity,ifnull(b.strRecipeUOM,''),b.strItemName from tblrecipedtl a,tblitemmaster b "   
						+" where a.strChildItemCode=b.strItemCode and a.strClientCode=b.strClientCode "
						+"   and a.strRecipeCode='"+objModel.getStrRecipeCode() +"' and a.strClientCode ='"+clientCode+"';");
				
				List listRecipeDtl=objBaseServiceImpl.funGetList(sbSql,"sql");
				
				if(listRecipeDtl !=null && listRecipeDtl.size()>0){
					for(int i=0;i<listRecipeDtl.size();i++){
						objDtlModel=new clsPOSMenuItemMasterBean();
						Object ob[]=(Object[]) listRecipeDtl.get(i);
						objDtlModel.setStrItemCode(ob[1].toString());
						objDtlModel.setDblRecipeQty(Double.parseDouble(ob[2].toString()));
						objDtlModel.setStrItemName(ob[4].toString());
						objDtlModel.setStrUOM(ob[3].toString());
						listChildItemDtl.add(objDtlModel);
					}
					
					objModel.setListChildItemDtl(listChildItemDtl);
				}
			}
			
		}
		catch (Exception e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		

		return objModel;
	}
	//
	@SuppressWarnings("resource")
	@RequestMapping(value = "/loadGuestImage", method = RequestMethod.GET)
	public void getImage(@RequestParam("guestCode") String itemCode, HttpServletRequest req, HttpServletResponse response) throws Exception {
		String clientCode = req.getSession().getAttribute("gClientCode").toString();			
		StringBuilder sbSql = new StringBuilder();
		clsPOSMenuItemMasterBean objMenuItemMasterBean=null;
		
		clsMenuItemMasterModel objMenuItemMasterModel = objMasterService.funGetMenuItemMasterData(itemCode,clientCode);
		objMenuItemMasterBean=new clsPOSMenuItemMasterBean();
		
		try {
			//Blob image = null;
			
			if(objMenuItemMasterModel!=null && !objMenuItemMasterModel.toString().isEmpty())
			{
				byte[] imgData = null;
				imgData =objMenuItemMasterModel.getImgImage();
				response.setContentType("image/jpeg, image/jpg, image/png, image/gif");
				OutputStream o = response.getOutputStream();
				o.write(imgData);
				o.flush();
				o.close();
			}
			//}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@SuppressWarnings("finally")
	private ByteArrayInputStream funInputStreamToBytearrayInputStrean(java.io.InputStream inputStream) {
		ByteArrayInputStream byteArrayInputStream = null;
		try {
			byte[] buff = new byte[8000];

			int bytesRead = 0;

			ByteArrayOutputStream bao = new ByteArrayOutputStream();

			while ((bytesRead = inputStream.read(buff)) != -1) {
				bao.write(buff, 0, bytesRead);
			}

			byte[] data = bao.toByteArray();

			byteArrayInputStream = new ByteArrayInputStream(data);

		} catch (Exception ex) {
			ex.printStackTrace();

		} finally {
			return byteArrayInputStream;
		}
	}
	
	public BufferedImage scaleImage(int WIDTH, int HEIGHT, String filename) {
		BufferedImage bi = null;
		try {
			ImageIcon ii = new ImageIcon(filename);// path to image
			bi = new BufferedImage(WIDTH, HEIGHT, BufferedImage.TYPE_INT_RGB);
			Graphics2D gra2d = (Graphics2D) bi.createGraphics();
			gra2d.addRenderingHints(new RenderingHints(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY));
			gra2d.drawImage(ii.getImage(), 0, 0, WIDTH, HEIGHT, null);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		return bi;
	}

}


