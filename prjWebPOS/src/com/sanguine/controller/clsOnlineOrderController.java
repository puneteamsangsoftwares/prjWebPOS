package com.sanguine.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.sanguine.base.service.clsBaseServiceImpl;
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
		
		strOrderDate = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new java.util.Date (longDateCreated)); 
		String DateDelivery = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new java.util.Date (longDateDelivery));
		
		clsOnlineOrderModelHd objOrderHD=new clsOnlineOrderModelHd(new clsOnlineOrderModel_ID(strOrderId, strClientCode, strOrderDate));
		
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
			
			objOrderDtlModel.setPrice(Double.parseDouble(hmItem.get("price").toString()));
			objOrderDtlModel.setQuantity(Double.parseDouble(hmItem.get("quantity").toString()));
			objOrderDtlModel.setDiscount(Double.parseDouble(hmItem.get("discount").toString()));
			objOrderDtlModel.setTotal(Double.parseDouble(hmItem.get("total").toString()));
			objOrderDtlModel.setTotal_with_tax(Double.parseDouble(hmItem.get("total_with_tax").toString()));
			
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
				objOrderModifierDtlModel.setDblQuantity(1);
				objOrderModifierDtlModel.setDblAmount(Double.parseDouble(hmItemMod.get("price").toString()));
					
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
					objOrderDiscDtlModel.setDblDiscPer(Double.parseDouble(hmDisc.get("rate").toString()));
					objOrderDiscDtlModel.setCode(hmDisc.get("code").toString());
					objOrderDiscDtlModel.setTitle(hmDisc.get("title").toString());
					
					listOrderDiscDtl.add(objOrderDiscDtlModel);
				}
			}
			if(hmExtra.containsKey("id")) {
				if(objOrderHD.getOrderMerchant_ref_id().equals("")) {
					objOrderHD.setOrderMerchant_ref_id(hmExtra.get("id").toString());
						
				}
				
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

  

public void funAddUpdateStore(JSONObject jobOnlineOrder) 
   {
	    try
		{
	    
	    HashMap<Object, Object> hmstats= (HashMap) jobOnlineOrder.get("stats");
	    String updateStore=hmstats.get("updated").toString();
	    String error=hmstats.get("errors").toString();
	    String createdStore=hmstats.get("created").toString();
	    
		 
	    clsOnlineOrderAddUpdateStoreModel objStoreAddUpdate=null;
	    ArrayList alStore=(ArrayList) jobOnlineOrder.get("stores");
		for(int i=0;i<alStore.size();i++) {
			HashMap<Object, Object> hmstore=(HashMap)alStore.get(i);
			objStoreAddUpdate=new clsOnlineOrderAddUpdateStoreModel();
			HashMap<Object, Object> hmurpstatus=(HashMap)hmstore.get("upipr_status");
			objStoreAddUpdate.setStrAction(hmurpstatus.get("action").toString());
			objStoreAddUpdate.setStrId(hmurpstatus.get("id").toString());
			objStoreAddUpdate.setError( hmurpstatus.get("error").toString());
			
			}
	    
	
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
	}

	public void funStoreAction(JSONObject jobOnlineOrder) 
	{
		    try
			{
		    	String strClientCode="";
		    	String locationRefId=(String) jobOnlineOrder.get("location_ref_id");
		    	String[] clientCode=locationRefId.split(".");
		    	strClientCode=clientCode[0];
		    	
		    	HashMap<Object, Object> hmstoreAction= (HashMap) jobOnlineOrder.get("location_ref_id");
		    	clsStoreActionModel objStoreAction=new clsStoreActionModel();
		    	objStoreAction.setStrAction(jobOnlineOrder.get("action").toString());
		    	objStoreAction.setStrLocationRefId(locationRefId);
		    	objStoreAction.setStrPlatform(jobOnlineOrder.get("platform").toString());
		    	objStoreAction.setStrRefernceId(jobOnlineOrder.get("reference_id").toString());
		    	objStoreAction.setStrStatus(jobOnlineOrder.get("status").toString());
		    	objStoreAction.setTs_utc(Integer.parseInt(jobOnlineOrder.get("ts_utc").toString()));
		    
		    
		    	
			
		    
			}catch (Exception e) {
		// TODO: handle exception
		    e.printStackTrace();
	        }
    }
	
	public void funItemAction(JSONObject jobOnlineOrder) 
	{
		    try
			{
		    	String strClientCode="";
		    	String locationRefId=(String) jobOnlineOrder.get("location_ref_id");
		    	String[] clientCode=locationRefId.split(".");
		    	strClientCode=clientCode[0];
		    	
		    	clsItemActionModel objItemAction=new clsItemActionModel();
		    	objItemAction.setStrAction(jobOnlineOrder.get("action").toString());
		    	
		    	objItemAction.setStrPlatform(jobOnlineOrder.get("platform").toString());
		    	objItemAction.setStrRefernceId(jobOnlineOrder.get("reference_id").toString());
		    	
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
		    	
		    	
		    	
				objItemAction.setTs_utc(Integer.parseInt(jobOnlineOrder.get("ts_utc").toString()));
		        
		    
		    	
			
		    
			}catch (Exception e) {
		// TODO: handle exception
		    e.printStackTrace();
	        }
    }
	
	public void funRiderStatus(JSONObject jobOnlineOrder) 
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
		    	
		    	objRiderStatus.setRiderMode((String)jobOnlineOrder.get("mode"));
		    	
		    	ArrayList alStatus=(ArrayList) jobOnlineOrder.get("status_updates");
				for(int i=0;i<alStatus.size();i++) 
				{
					HashMap<Object, Object> hmstatus=(HashMap)alStatus.get(i);
					String strOrderDate="";
					long longDateCreated=Long.parseLong(hmstatus.get("created").toString());
					String DateDelivery = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new java.util.Date (longDateCreated));
					if(hmstatus.get("status").toString().equalsIgnoreCase("assigned"))
					{
						objRiderStatus.setAssignComments(hmstatus.get("comments").toString());
						objRiderStatus.setAssignStatus(hmstatus.get("status").toString());
						objRiderStatus.setDteAssign(DateDelivery);
					}
					else if(hmstatus.get("status").toString().equalsIgnoreCase("reassigned"))
					{
						objRiderStatus.setReassignComments(hmstatus.get("comments").toString());
						objRiderStatus.setReAssignStatus(hmstatus.get("status").toString());
						objRiderStatus.setDteReassign(DateDelivery);
					}
					else if(hmstatus.get("status").toString().equalsIgnoreCase("unassigned"))
					{
						objRiderStatus.setUnassignComments(hmstatus.get("comments").toString());
						objRiderStatus.setUnassignStatus(hmstatus.get("status").toString());
						objRiderStatus.setDteUnassign(DateDelivery);
					}
					else if(hmstatus.get("status").toString().equalsIgnoreCase("at-store"))
					{
						objRiderStatus.setAtStoreCommits(hmstatus.get("comments").toString());
						objRiderStatus.setAtstoreStatus(hmstatus.get("status").toString());
						objRiderStatus.setDteAtStore(DateDelivery);
					}
					else if(hmstatus.get("status").toString().equalsIgnoreCase("out-for-delivery"))
					{
						objRiderStatus.setOutForDelComments(hmstatus.get("comments").toString());
						objRiderStatus.setOutForDelStatus(hmstatus.get("status").toString());
						objRiderStatus.setDteOutForDel(DateDelivery);
					}
					else if(hmstatus.get("status").toString().equalsIgnoreCase("delivered"))
					{
						objRiderStatus.setDeliveredComments(hmstatus.get("comments").toString());
						objRiderStatus.setDeliverdStatus(hmstatus.get("status").toString());
						objRiderStatus.setDteDelivered(DateDelivery);
					}
					
					objRiderStatus.setUpOrderId((String)jobOnlineOrder.get("order_id"));
					HashMap<Object, Object> hmstore= (HashMap) jobOnlineOrder.get("store");
					objRiderStatus.setStoreId(Integer.parseInt(hmstore.get("id").toString()));
					objRiderStatus.setPosCode(hmstore.get("ref_id").toString());
				}
			
		    
			}catch (Exception e) {
		// TODO: handle exception
		    e.printStackTrace();
	        }
    }
}
