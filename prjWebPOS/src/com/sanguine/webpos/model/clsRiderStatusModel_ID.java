package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
@Embeddable
@SuppressWarnings("serial")

public class clsRiderStatusModel_ID implements Serializable{

//Variable Declaration
	@Column(name="channel_orderId")
	private String channel_orderId;

	

	@Column(name="upOrderId")
	private String upOrderId;

	@Column(name="storeId")
	private String storeId;
	
	public clsRiderStatusModel_ID()
	{
		
		
	}
	public clsRiderStatusModel_ID(String channel_orderId,String upOrderId ,String storeId){
		this.channel_orderId=channel_orderId;
		this.upOrderId=upOrderId;
		this.storeId=storeId;
	}

//Setter-Getter Methods
	public String getChannel_orderId()
	{
		return channel_orderId;
	}
	public void setChannel_orderId(String channel_orderId)
	{
		this.channel_orderId = channel_orderId;
	}
	public String getUpOrderId()
	{
		return upOrderId;
	}
	public void setUpOrderId(String upOrderId)
	{
		this.upOrderId = upOrderId;
	}
	public String getStoreId()
	{
		return storeId;
	}
	public void setStoreId(String storeId)
	{
		this.storeId = storeId;
	}
	
	
//HashCode and Equals Funtions
	@Override
	public boolean equals(Object obj) {
		clsRiderStatusModel_ID objModelId = (clsRiderStatusModel_ID)obj;
		if(this.channel_orderId.equals(objModelId.getChannel_orderId())&& this.upOrderId.equals(objModelId.getUpOrderId())&& this.storeId.equals(objModelId.getStoreId())){
			return true;
		}
		else{
			return false;
		}
	}

	@Override
	public int hashCode() {
		return this.channel_orderId.hashCode()+this.upOrderId.hashCode()+this.storeId.hashCode();
	}

}
