package com.sanguine.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.sanguine.base.service.clsBaseServiceImpl;
import com.sanguine.webpos.model.clsCatalogueIngestionModel;
import com.sanguine.webpos.model.clsItemActionModel;
import com.sanguine.webpos.model.clsOnlineOrderAddUpdateStoreModel;
import com.sanguine.webpos.model.clsOnlineOrderDiscDtlModel;
import com.sanguine.webpos.model.clsOnlineOrderDtlModel;
import com.sanguine.webpos.model.clsOnlineOrderModelHd;
import com.sanguine.webpos.model.clsOnlineOrderModel_ID;
import com.sanguine.webpos.model.clsOnlineOrderModifierDtlModel;
import com.sanguine.webpos.model.clsOnlineOrderSettlementDtlModel;
import com.sanguine.webpos.model.clsOnlineOrderTaxDtl;
import com.sanguine.webpos.model.clsRiderStatusModel;
import com.sanguine.webpos.model.clsStoreActionModel;


@Controller
public class clsOnlineOrderController
{

	@Autowired
	clsBaseServiceImpl objBaseServiceImpl;
	@Autowired
	clsGlobalFunctions objGlobal;
	
	public void funSaveOnlineOrderData(JSONObject jobOnlineOrder) {
		
		

		try
		{
		String strOrderId="",strClientCode="",strOrderDate="";
		
		HashMap<Object, Object> hmOrder= (HashMap) jobOnlineOrder.get("order");
		HashMap<Object, Object> hmCust= (HashMap) jobOnlineOrder.get("customer");
		
		//JSONObject jObOrder= (JSONObject) jobOnlineOrder.get("order");
		
		//JSONObject jObCustomer= (JSONObject) jobOnlineOrder.get("customer");
		
		HashMap<Object, Object> hmCustAddr= (HashMap) hmCust.get("address");
		
		HashMap<Object, Object> hmClientDetail= (HashMap) hmOrder.get("store");
		
		
		strClientCode=(String)hmClientDetail.get("merchant_ref_id");
		strClientCode=strClientCode.substring(0, 7);
		String clientid=hmClientDetail.get("id").toString();
		String clientName=(String)hmClientDetail.get("name");
		
		HashMap<Object, Object> hmOrderDetail= (HashMap) hmOrder.get("details");
		//strOrderId=(String)hmOrderDetail.get("merchant_ref_id");
		strOrderId=hmOrderDetail.get("id").toString();
		
		long longDateCreated=Long.parseLong(hmOrderDetail.get("created").toString());
		long longDateDelivery=Long.parseLong(hmOrderDetail.get("delivery_datetime").toString());
		
		strOrderDate = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date (longDateCreated)); 
		String DateDelivery = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date (longDateDelivery));
		
		clsOnlineOrderModelHd objOrderHD=new clsOnlineOrderModelHd(new clsOnlineOrderModel_ID(strOrderId, strClientCode, strOrderDate));
		funDeleteOrderDataFromDtlTables(strOrderId, strClientCode, strOrderDate);
		objOrderHD.setStrbiz_id(hmOrderDetail.get("biz_id").toString());
		objOrderHD.setDelivery_datetime(DateDelivery);
		objOrderHD.setChannel(objGlobal.funIfNull(hmOrderDetail.get("channel").toString(),"",hmOrderDetail.get("channel").toString()));
		if(hmOrderDetail.get("merchant_ref_id")!=null) {
			objOrderHD.setOrderMerchant_ref_id(objGlobal.funIfNull(hmOrderDetail.get("merchant_ref_id").toString(),"",hmOrderDetail.get("merchant_ref_id").toString()));	
		}else {
			objOrderHD.setOrderMerchant_ref_id("");
		}
		
		objOrderHD.setOrder_state(objGlobal.funIfNull(hmOrderDetail.get("order_state").toString(),"",hmOrderDetail.get("order_state").toString()));
		objOrderHD.setOrder_type(objGlobal.funIfNull(hmOrderDetail.get("order_type").toString(),"",hmOrderDetail.get("order_type").toString()));
		objOrderHD.setState(objGlobal.funIfNull(hmOrderDetail.get("state").toString(),"",hmOrderDetail.get("state").toString()));
		
		
		objOrderHD.setDiscount((Double)hmOrderDetail.get("discount"));
		objOrderHD.setOrder_subtotal((Double)hmOrderDetail.get("order_subtotal"));
		objOrderHD.setOrder_total((Double)hmOrderDetail.get("order_total"));
		
		objOrderHD.setTotal_external_discount(Double.parseDouble(hmOrderDetail.get("total_external_discount").toString()));
		objOrderHD.setItem_level_total_charges(Double.parseDouble(hmOrderDetail.get("item_level_total_charges").toString()));
		objOrderHD.setItem_level_total_taxes(Double.parseDouble(hmOrderDetail.get("item_level_total_taxes").toString()));
		
		objOrderHD.setItem_taxes(Double.parseDouble(hmOrderDetail.get("item_taxes").toString()));
		
		objOrderHD.setOrder_level_total_charges(Double.parseDouble(hmOrderDetail.get("order_level_total_charges").toString()));
		objOrderHD.setOrder_level_total_taxes(Double.parseDouble(hmOrderDetail.get("order_level_total_taxes").toString()));
		
		//total_charges
		objOrderHD.setTotal_charges(Double.parseDouble(hmOrderDetail.get("total_charges").toString()));
		objOrderHD.setTotal_taxes(Double.parseDouble(hmOrderDetail.get("total_taxes").toString()));

		
		objOrderHD.setCoupon(objGlobal.funIfNull((String)hmOrderDetail.get("coupon"),"",(String)hmOrderDetail.get("coupon")));
		objOrderHD.setInstructions(objGlobal.funIfNull((String)hmOrderDetail.get("instructions"),"",(String)hmOrderDetail.get("instructions")));
		//objOrderHD.setOrderMerchant_ref_id((String)jObOrderDetail.get("merchant_ref_id"));
		//
		
		objOrderHD.setNext_state(objGlobal.funIfNull((String)hmOrderDetail.get("next_state"),"",(String)hmOrderDetail.get("next_state")));
		
		
		
		objOrderHD.setStoreId(clientid);
		objOrderHD.setStoreName(clientName);
		objOrderHD.setCustName((String)hmCust.get("name"));
		objOrderHD.setCustPhone(objGlobal.funIfNull(hmCust.get("phone").toString(),"",hmCust.get("phone").toString()));
		objOrderHD.setCustEmail(objGlobal.funIfNull((String)hmCust.get("email"),"",(String)hmCust.get("email")));

		objOrderHD.setCustAddr1(objGlobal.funIfNull((String)hmCustAddr.get("line_1"),"",(String)hmCustAddr.get("line_1")));
		objOrderHD.setCustAddr2(objGlobal.funIfNull((String)hmCustAddr.get("line_2"),"",(String)hmCustAddr.get("line_2")));
		
		objOrderHD.setCustCity(objGlobal.funIfNull((String)hmCustAddr.get("city"), "", (String)hmCustAddr.get("city")));
		
		
		
		List<clsOnlineOrderDtlModel> listOrderDtl=new ArrayList<clsOnlineOrderDtlModel>();
		List<clsOnlineOrderDiscDtlModel> listOrderDiscDtl=new ArrayList<clsOnlineOrderDiscDtlModel>();
		List<clsOnlineOrderModifierDtlModel> listOrderModDtl=new ArrayList<clsOnlineOrderModifierDtlModel>();
		List<clsOnlineOrderTaxDtl> listOrderTaxDtl=new ArrayList<clsOnlineOrderTaxDtl>();
		List<clsOnlineOrderSettlementDtlModel> listOrderSettlementDtl=new ArrayList<clsOnlineOrderSettlementDtlModel>();

		clsOnlineOrderDtlModel objOrderDtlModel=null; 
		clsOnlineOrderModifierDtlModel objOrderModifierDtlModel=null;
		HashMap<String,String> hmTaxNameValue=new HashMap<String, String>();
		HashMap<String,String> hmTaxNamePercent=new HashMap<String, String>();

		ArrayList<Object> alItemDetail= (ArrayList) hmOrder.get("items");
		for(int i=0;i<alItemDetail.size();i++) {
			
			HashMap hmItem=(HashMap)alItemDetail.get(i);
			
			objOrderDtlModel=new clsOnlineOrderDtlModel();
			objOrderDtlModel.setItemId(hmItem.get("id").toString());
			objOrderDtlModel.setItemName(hmItem.get("title").toString());
			String itemCode=hmItem.get("merchant_id").toString();
			objOrderDtlModel.setMerchant_id(itemCode);
			double itemQty=Double.parseDouble(hmItem.get("quantity").toString());
			objOrderDtlModel.setPrice(Double.parseDouble(hmItem.get("price").toString()));
			objOrderDtlModel.setQuantity(itemQty);
			objOrderDtlModel.setDiscount(Double.parseDouble(hmItem.get("discount").toString()));
			objOrderDtlModel.setTotal(Double.parseDouble(hmItem.get("total").toString()));
			objOrderDtlModel.setTotal_with_tax(Double.parseDouble(hmItem.get("total_with_tax").toString()));
			objOrderDtlModel.setStrSequenceNo(String.valueOf(i));
			double dblExtraCharges=0;
			ArrayList<Object> alExtraCharges =(ArrayList<Object>)hmItem.get("charges");
			for(int m=0;m<alExtraCharges.size();m++) {
				HashMap hmExtraCharges=(HashMap)alExtraCharges.get(m);
				dblExtraCharges= dblExtraCharges + Double.parseDouble(hmExtraCharges.get("value").toString());
			}
			objOrderDtlModel.setDblExtracharges(dblExtraCharges);
			//dblExtracharges 
			listOrderDtl.add(objOrderDtlModel);
			
			ArrayList<Object> alModDetail =(ArrayList<Object>)hmItem.get("options_to_add");
			for(int k=0;k<alModDetail.size();k++) {
				
				HashMap hmItemMod=(HashMap)alModDetail.get(k);
				objOrderModifierDtlModel =new clsOnlineOrderModifierDtlModel();
				objOrderModifierDtlModel.setStrItemId(hmItemMod.get("id").toString());
				objOrderModifierDtlModel.setStrModifierCode(hmItemMod.get("merchant_id").toString());
				objOrderModifierDtlModel.setStrItemCode(itemCode);
				objOrderModifierDtlModel.setStrModifierName(hmItemMod.get("title").toString());
				objOrderModifierDtlModel.setDblQuantity(itemQty);//Mod quantity same as item quantity 
				objOrderModifierDtlModel.setDblAmount(Double.parseDouble(hmItemMod.get("price").toString()));
				objOrderModifierDtlModel.setStrSequenceNo(String.valueOf(i)+"."+String.valueOf(k+1));
				
				listOrderModDtl.add(objOrderModifierDtlModel);
			}
			
			ArrayList<Object> alTaxDetail =(ArrayList<Object>)hmItem.get("taxes");
			for(int k=0;k<alTaxDetail.size();k++) {
				
				HashMap hmtaxData=(HashMap)alTaxDetail.get(k);
				if(hmTaxNameValue.containsKey(hmtaxData.get("title").toString())) {
					
					double dblTaxvalue= Double.parseDouble(hmTaxNameValue.get(hmtaxData.get("title").toString()))+Double.parseDouble(hmtaxData.get("value").toString());
					
					hmTaxNameValue.put(hmtaxData.get("title").toString(),String.valueOf(dblTaxvalue));
				}else {
					hmTaxNameValue.put(hmtaxData.get("title").toString(),hmtaxData.get("value").toString());	
				}
				hmTaxNamePercent.put(hmtaxData.get("title").toString(), hmtaxData.get("rate").toString());
				
			}
		}
		
		clsOnlineOrderTaxDtl objOrderTaxDtl=null; 
		for(Map.Entry<String, String> entry:hmTaxNameValue.entrySet()) {
			objOrderTaxDtl=new clsOnlineOrderTaxDtl();
			objOrderTaxDtl.setDblTaxAmount(Double.parseDouble(entry.getValue()));
			objOrderTaxDtl.setStrTaxName(entry.getKey());
			objOrderTaxDtl.setDblTaxRate(Double.parseDouble(hmTaxNamePercent.get(entry.getKey())));
			
			listOrderTaxDtl.add(objOrderTaxDtl);
		}
		
		clsOnlineOrderDiscDtlModel objOrderDiscDtlModel=null; 
		ArrayList alExtra=(ArrayList)hmOrderDetail.get("ext_platforms");
		for(int i=0;i<alExtra.size();i++) {
			HashMap<Object, Object> hmExtra=(HashMap)alExtra.get(i);
			
			if(hmExtra.containsKey("discounts")) {
				ArrayList alDiscount=(ArrayList)hmExtra.get("discounts");
				for(int k=0;k<alDiscount.size();k++) {
					HashMap<Object, Object> hmDisc=(HashMap)alDiscount.get(k);
					objOrderDiscDtlModel=new clsOnlineOrderDiscDtlModel();
					objOrderDiscDtlModel.setIsMerchantDiscount(hmDisc.get("is_merchant_discount").toString());
					objOrderDiscDtlModel.setDblDiscAmt(Double.parseDouble(hmDisc.get("value").toString()));
					if(hmDisc.containsKey("rate")) {
						objOrderDiscDtlModel.setDblDiscPer(Double.parseDouble(hmDisc.get("rate").toString()));	
					}
					if(hmDisc.containsKey("code")) {
						objOrderDiscDtlModel.setCode(hmDisc.get("code").toString());	
					}else {
						objOrderDiscDtlModel.setCode("");
					}
					if(hmDisc.containsKey("title")) {
						objOrderDiscDtlModel.setTitle(hmDisc.get("title").toString());	
					}else {
						objOrderDiscDtlModel.setTitle("");
					}
					
					
					listOrderDiscDtl.add(objOrderDiscDtlModel);
				}
			}
			if(hmExtra.containsKey("id")) {
				if(objOrderHD.getOrderMerchant_ref_id().equals("")) {
					objOrderHD.setOrderMerchant_ref_id(hmExtra.get("id").toString());
				}
			}
			if(hmExtra.containsKey("delivery_type")) {
				objOrderHD.setDelivery_type(hmExtra.get("delivery_type").toString());
			}
		}
		
		//HashMap<Object, Object> hmPayment= (HashMap) hmOrder.get("payment");
		clsOnlineOrderSettlementDtlModel objOrderSettlementDtlModel=null; 
		ArrayList alPayment=(ArrayList) hmOrder.get("payment");
		for(int i=0;i<alPayment.size();i++) {
			HashMap<Object, Object> hmPayment=(HashMap)alPayment.get(i);
			objOrderSettlementDtlModel=new clsOnlineOrderSettlementDtlModel();
			objOrderSettlementDtlModel.setStrSettlementName(hmPayment.get("option").toString());
			objOrderSettlementDtlModel.setDblSettlementAmt(Double.parseDouble(hmPayment.get("amount").toString()));
			if(hmPayment.containsKey("srvr_trx_id")) {
				if(hmPayment.get("srvr_trx_id")!=null) {
					objOrderSettlementDtlModel.setSrvr_trx_id(hmPayment.get("srvr_trx_id").toString());	
				}	
			}
		
			listOrderSettlementDtl.add(objOrderSettlementDtlModel);
		}
		
				
		objOrderHD.setListOnlineOrderDtlModel(listOrderDtl);
		objOrderHD.setListOnlineOrderDiscDtlModel(listOrderDiscDtl);
		objOrderHD.setListOnlineOrderModifierDtlModel(listOrderModDtl);
		objOrderHD.setListOnlineOrderTaxDtl(listOrderTaxDtl);
	objOrderHD.setListOnlineOrderSettlementDtlModel(listOrderSettlementDtl);
		
		
			objBaseServiceImpl.funSave(objOrderHD);
		}
		catch (Exception e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	
	private void funDeleteOrderDataFromDtlTables(String strOrderId,String  strClientCode,String  strOrderDate) {
		try {
			strOrderDate=strOrderDate.split(" ")[0];
			String sbSql="delete from tblonlineorderdtl  where strOrderId='"+strOrderId+"' and strClientCode='"+strClientCode+"' and date(dtOrderDate)='"+strOrderDate+"';";
			objBaseServiceImpl.funExecuteUpdate(sbSql, "sql");
			
			sbSql="delete  from tblonlineordermodifierdtl  where strOrderId='"+strOrderId+"' and strClientCode='"+strClientCode+"' and date(dtOrderDate)='"+strOrderDate+"';";
			objBaseServiceImpl.funExecuteUpdate(sbSql, "sql");
			
			sbSql="delete  from tblonlineorderdiscdtl  where strOrderId='"+strOrderId+"' and strClientCode='"+strClientCode+"' and date(dtOrderDate)='"+strOrderDate+"';";
			objBaseServiceImpl.funExecuteUpdate(sbSql, "sql");
			
			sbSql="delete  from tblonlineordertaxdtl  where strOrderId='"+strOrderId+"' and strClientCode='"+strClientCode+"' and date(dtOrderDate)='"+strOrderDate+"';";
			objBaseServiceImpl.funExecuteUpdate(sbSql, "sql");
			
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
public void funUpdateOnlineOrderStatus(JSONObject jobOnlineOrder) {
		

		try
		{
		String strOrderId="",strClientCode="",strOrderDate="";
		
		System.out.println(jobOnlineOrder.get("order_id"));
		strOrderId=jobOnlineOrder.get("order_id").toString();
		String new_state=jobOnlineOrder.get("new_state").toString();
		String store_id=jobOnlineOrder.get("store_id").toString();
		strClientCode=store_id.substring(0, 7);
		
		String sqlStatus="update tblonlineorderhd a set a.order_state='"+new_state+"' where a.strOrderId='"+strOrderId+"' and a.strClientCode='"+strClientCode+"'; ";
		
		objBaseServiceImpl.funExecuteUpdate(sqlStatus, "sql");
		
		
//		HashMap<Object, Object> hmOrder= (HashMap) jobOnlineOrder.get("order");
//		HashMap<Object, Object> hmCust= (HashMap) jobOnlineOrder.get("customer");
//		
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
	}

public void funAddUpdateStore(JSONObject jobOnlineOrder,String strClientCode) 
{
	    try
		{
	    
	    HashMap<Object, Object> hmstats= (HashMap) jobOnlineOrder.get("stats");
	    clsOnlineOrderAddUpdateStoreModel objStoreAddUpdate=new clsOnlineOrderAddUpdateStoreModel();
	    objStoreAddUpdate.setStrClientCode(strClientCode);
	    objStoreAddUpdate.setUpdatedStore(Integer.parseInt(hmstats.get("updated").toString()));
	    objStoreAddUpdate.setErrorsStore(Integer.parseInt(hmstats.get("errors").toString()));
	    objStoreAddUpdate.setCreatedStore(Integer.parseInt(hmstats.get("created").toString())); 
	    objStoreAddUpdate.setDteCurrentDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		 
	    
	   /* ArrayList alStore=(ArrayList) jobOnlineOrder.get("stores");
		for(int i=0;i<alStore.size();i++) {
			HashMap<Object, Object> hmstore=(HashMap)alStore.get(i);
			
			HashMap<Object, Object> hmurpstatus=(HashMap)hmstore.get("upipr_status");
			objStoreAddUpdate.setStrAction(hmurpstatus.get("action").toString());
			objStoreAddUpdate.setStrId(hmurpstatus.get("id").toString());
			objStoreAddUpdate.setError( hmurpstatus.get("error").toString());
			
			}*/
	    objBaseServiceImpl.funSave(objStoreAddUpdate);
	
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
	}

	public void funStoreAction(JSONObject jobOnlineOrder) 
	{
		    try
			{
		    	String locId=(String)jobOnlineOrder.get("location_ref_id");
		    	String strClientCode=locId.substring(0, 7);
		    	clsStoreActionModel objStoreAction=new clsStoreActionModel();
		    	objStoreAction.setStrAction(jobOnlineOrder.get("action").toString());
		    	objStoreAction.setStrLocationRefId((String)jobOnlineOrder.get("location_ref_id"));
		    	objStoreAction.setStrPlatform(jobOnlineOrder.get("platform").toString());
		    	objStoreAction.setStrClientCode(strClientCode);
		    	objStoreAction.setStrStatus(jobOnlineOrder.get("status").toString());
		    	long longDateCreated=Long.parseLong(jobOnlineOrder.get("ts_utc").toString());
				String strOrderDate = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new java.util.Date (longDateCreated)); 
				
				
		    	objStoreAction.setTs_utc(strOrderDate);
		    
		    
		    	objBaseServiceImpl.funSave(objStoreAction);
			
		    
			}catch (Exception e) {
		// TODO: handle exception
		    e.printStackTrace();
	        }
 }
	
	public void funItemAction(JSONObject jobOnlineOrder,String strClientCode) 
	{
		    try
			{
		    	
		    	clsItemActionModel objItemAction=new clsItemActionModel();
		    	objItemAction.setStrAction(jobOnlineOrder.get("action").toString());
		    	
		    	objItemAction.setStrPlatform(jobOnlineOrder.get("platform").toString());
		    	objItemAction.setStrClientCode(strClientCode);
		    	
		    	ArrayList alStatus=(ArrayList) jobOnlineOrder.get("status");
				for(int i=0;i<alStatus.size();i++) 
				{
					HashMap<Object, Object> hmstatus=(HashMap)alStatus.get(i);
					ArrayList alitem=(ArrayList) hmstatus.get("items");
					
					for(int k=0;k<alitem.size();k++) 
					{
						HashMap<Object, Object> hmitem=(HashMap)alitem.get(i);
						objItemAction.setStrUpItemId(hmitem.get("id").toString());
						objItemAction.setStrItemCode(hmitem.get("ref_id").toString());
						objItemAction.setStrItemStatus(hmitem.get("status").toString());
					}
					HashMap<Object, Object> hmLocation=(HashMap)hmstatus.get("location");
					objItemAction.setStrUpLocationId(hmLocation.get("id").toString());
					objItemAction.setStrLocationCode(hmLocation.get("ref_id").toString());
					
				}
		    	
		    	
				long longDateCreated=Long.parseLong(jobOnlineOrder.get("ts_utc").toString());
				String strOrderDate = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new java.util.Date (longDateCreated)); 
				
				
				objItemAction.setTs_utc(strOrderDate);
				
		        
		        objBaseServiceImpl.funSave(objItemAction);
		    	
			
		    
			}catch (Exception e) {
		// TODO: handle exception
		    e.printStackTrace();
	        }
 }
	
	public void funRiderStatus(JSONObject jobOnlineOrder,String strClientCode) 
	{
		    try
			{
		    	clsRiderStatusModel objRiderStatus=new clsRiderStatusModel();
		    	
		    	HashMap<Object, Object> hmaddInfo= (HashMap) jobOnlineOrder.get("additional_info");
		    	HashMap<Object, Object> hmextchannel= (HashMap) hmaddInfo.get("external_channel");
		    	objRiderStatus.setChannel(hmextchannel.get("name").toString());
		    	objRiderStatus.setChannel_orderId(hmextchannel.get("order_id").toString());
		    	
		    	HashMap<Object, Object> hmdeliveryInfo= (HashMap) jobOnlineOrder.get("delivery_info");
		    	objRiderStatus.setOrderState((String)hmdeliveryInfo.get("current_state"));
		    	HashMap<Object, Object> hmdelPersonDtl= (HashMap) hmdeliveryInfo.get("delivery_person_details");
		    	objRiderStatus.setDeliveryPersonAltNo(hmdelPersonDtl.get("alt_phone").toString());
		    	objRiderStatus.setDeliveryPersonName(hmdelPersonDtl.get("name").toString());
		    	objRiderStatus.setDeliveryPersonPhoneNo(hmdelPersonDtl.get("phone").toString());
		    	objRiderStatus.setDeliveryUserId(hmdelPersonDtl.get("user_id").toString());
		    	
		    	objRiderStatus.setRiderMode(hmdeliveryInfo.get("mode").toString());
		    	objRiderStatus.setStrClientCode(strClientCode);
             objRiderStatus.setUpOrderId((Integer)jobOnlineOrder.get("order_id"));
		    	
		    	HashMap<Object, Object> hmstore= (HashMap) jobOnlineOrder.get("store");
				objRiderStatus.setStoreId(hmstore.get("id").toString());
				objRiderStatus.setStoreRefId(hmstore.get("ref_id").toString());
		    	
				//objBaseServiceImpl.funSave(objRiderStatus);
				
		    	ArrayList alStatus=(ArrayList) hmdeliveryInfo.get("status_updates");
				for(int i=0;i<alStatus.size();i++) 
				{
					HashMap<Object, Object> hmstatus=(HashMap)alStatus.get(i);
					String strOrderDate="";
					long longDateCreated=Long.parseLong(hmstatus.get("created").toString());
					String DateDelivery = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new java.util.Date (longDateCreated));
					if(hmstatus.get("status").toString().equalsIgnoreCase("assigned"))
					{
						if(hmstatus.get("comments")!=null){
							objRiderStatus.setAssignComments(hmstatus.get("comments").toString());	
							
						}
						objRiderStatus.setAssignStatus(hmstatus.get("status").toString());
						objRiderStatus.setDteAssign(DateDelivery);
						
						
					}
					else if(hmstatus.get("status").toString().equalsIgnoreCase("reassigned"))
					{
						if(hmstatus.get("comments")!=null){
							objRiderStatus.setReassignComments(hmstatus.get("comments").toString());	
							
						}
						objRiderStatus.setReAssignStatus(hmstatus.get("status").toString());
						objRiderStatus.setDteReassign(objGlobal.funIfNull(DateDelivery, "", DateDelivery));
						
						
					}
					else if(hmstatus.get("status").toString().equalsIgnoreCase("unassigned"))
					{
						if(hmstatus.get("comments")!=null){
							objRiderStatus.setUnassignComments(hmstatus.get("comments").toString());	
							
						}
						objRiderStatus.setUnassignStatus(hmstatus.get("status").toString());
						objRiderStatus.setDteUnassign(DateDelivery);
						
					}
					else if(hmstatus.get("status").toString().equalsIgnoreCase("at-store"))
					{
						if(hmstatus.get("comments")!=null){
							objRiderStatus.setAtStoreCommits(hmstatus.get("comments").toString());	
							
						}
						objRiderStatus.setAtstoreStatus(hmstatus.get("status").toString());
						objRiderStatus.setDteAtStore(DateDelivery);
					}
						
						
					else if(hmstatus.get("status").toString().equalsIgnoreCase("out-for-delivery"))
					{
						if(hmstatus.get("comments")!=null){
							objRiderStatus.setOutForDelComments(hmstatus.get("comments").toString());	
					  }
						objRiderStatus.setOutForDelStatus(hmstatus.get("status").toString());
						objRiderStatus.setDteOutForDel(DateDelivery);

						
						
					}
					else if(hmstatus.get("status").toString().equalsIgnoreCase("delivered"))
					{
						if(hmstatus.get("comments")!=null){
							objRiderStatus.setDeliveredComments(hmstatus.get("comments").toString());
							
						}
						objRiderStatus.setDeliverdStatus(hmstatus.get("status").toString());
						objRiderStatus.setDteDelivered(DateDelivery); 
						
					}
					
					//objBaseServiceImpl.funSave(objRiderStatus);
				}
				objBaseServiceImpl.funSave(objRiderStatus);
				
				
				
		    	
				
				
			
		    
			}catch (Exception e) {
		// TODO: handle exception
		    e.printStackTrace();
	        }
 }
	
	public void funCatalogueIngestion(JSONObject jobOnlineOrder,String strClientCode) 
	{
	
		    try
			{
		    clsCatalogueIngestionModel objCatalogue=new clsCatalogueIngestionModel();
		    HashMap<Object,Object> hmStatus=(HashMap) jobOnlineOrder.get("stats");
		    HashMap<Object,Object> hmCategories=(HashMap)hmStatus.get("categories");
		    objCatalogue.setCatgUpdate(Integer.parseInt(hmCategories.get("updated").toString()));
		    objCatalogue.setCatgError(Integer.parseInt(hmCategories.get("errors").toString()));
		    objCatalogue.setCatgCreated(Integer.parseInt(hmCategories.get("created").toString()));
		    objCatalogue.setCatgDeleted(Integer.parseInt(hmCategories.get("deleted").toString()));
		    HashMap<Object,Object> hmItems=(HashMap)hmStatus.get("items");
		    objCatalogue.setItemUpdate(Integer.parseInt(hmItems.get("updated").toString()));
		    objCatalogue.setItemError(Integer.parseInt(hmItems.get("errors").toString()));
		    objCatalogue.setItemCreated(Integer.parseInt(hmItems.get("created").toString()));
		    objCatalogue.setItemDeleted(Integer.parseInt(hmItems.get("deleted").toString()));
		    HashMap<Object,Object> hmOptionGrp=(HashMap)hmStatus.get("option_groups");
		    objCatalogue.setOptionGrpUpdate(Integer.parseInt(hmOptionGrp.get("updated").toString()));
		    objCatalogue.setOptionGrpError(Integer.parseInt(hmOptionGrp.get("errors").toString()));
		    objCatalogue.setOptionGrpCreated(Integer.parseInt(hmOptionGrp.get("created").toString()));
		    objCatalogue.setOptionGrpDeleted(Integer.parseInt(hmOptionGrp.get("deleted").toString()));
		    HashMap<Object,Object> hmOption=(HashMap)hmStatus.get("options");
		    objCatalogue.setOptionUpdate(Integer.parseInt(hmOption.get("updated").toString()));
		    objCatalogue.setOptionError(Integer.parseInt(hmOption.get("errors").toString()));
		    objCatalogue.setOptionCreated(Integer.parseInt(hmOption.get("created").toString()));
		    objCatalogue.setOptionDeleted(Integer.parseInt(hmOption.get("deleted").toString()));
		    
		    objCatalogue.setDteCurrentDate(objGlobal.funGetCurrentDateTime("yyyy-MM-dd"));
		    objCatalogue.setStrClientCode(strClientCode);
		    /*ArrayList alCategories=(ArrayList) jobOnlineOrder.get("categories");
			for(int i=0;i<alCategories.size();i++) 
			{
				
				HashMap<Object, Object> hmupCatgStatus=(HashMap)alCategories.get(i);
				HashMap<Object, Object> hmCatagegory=(HashMap)hmupCatgStatus.get("upipr_status");
				objCatalogue.setCategoriesAct(hmCatagegory.get("action").toString());
				objCatalogue.setCategoriesId(hmCatagegory.get("id").toString());
				objCatalogue.setCategoriesErr(hmCatagegory.get("error").toString());
			}
			
			ArrayList alItems=(ArrayList) jobOnlineOrder.get("items");
			for(int i=0;i<alItems.size();i++) 
			{
				
				HashMap<Object, Object> hmupItemStatus=(HashMap)alItems.get(i);
				HashMap<Object, Object> hmItem=(HashMap)hmupItemStatus.get("upipr_status");
				objCatalogue.setItemAct(hmItem.get("action").toString());
				objCatalogue.setItemId(hmItem.get("id").toString());
				objCatalogue.setItemErr(hmItem.get("error").toString());
			}
			
			ArrayList alOptionGrp=(ArrayList) jobOnlineOrder.get("option_groups");
			for(int i=0;i<alOptionGrp.size();i++) 
			{
				
				HashMap<Object, Object> hmupOptionGrpStatus=(HashMap)alOptionGrp.get(i);
				HashMap<Object, Object> hmOptionGroup=(HashMap)hmupOptionGrpStatus.get("upipr_status");
				objCatalogue.setItemAct(hmOptionGroup.get("action").toString());
				objCatalogue.setItemId(hmOptionGroup.get("id").toString());
				objCatalogue.setItemErr(hmOptionGroup.get("error").toString());
			}
			
			ArrayList alOption=(ArrayList) jobOnlineOrder.get("options");
			for(int i=0;i<alOption.size();i++) 
			{
				
				HashMap<Object, Object> hmupOptionStatus=(HashMap)alOption.get(i);
				HashMap<Object, Object> hmOption1=(HashMap)hmupOptionStatus.get("upipr_status");
				objCatalogue.setItemAct(hmOption1.get("action").toString());
				objCatalogue.setItemId(hmOption1.get("id").toString());
				objCatalogue.setItemErr(hmOption1.get("error").toString());
			}*/
		   
			objBaseServiceImpl.funSave(objCatalogue);
        
			}catch (Exception e) {
		// TODO: handle exception
		    e.printStackTrace();
	        }
 }


}
