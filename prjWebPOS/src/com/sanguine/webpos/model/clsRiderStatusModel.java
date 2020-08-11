package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.Embeddable;

@Embeddable
public class clsRiderStatusModel implements Serializable
{

	private String channel;
	private String channel_orderId;
	private String orderState;
	private String deliveryPersonPhoneNo;
	private String deliveryPersonAltNo;
	private String deliveryPersonName;
	private String deliveryUserId;
	private String riderMode;
	private String upOrderId;
	private int storeId;
	private String posCode;
	private String assignComments;
	private String dteAssign;
	private String assignStatus;
	private String unassignComments;
	private String dteUnassign;
	private String unassignStatus;
	private String reassignComments;
	private String dteReassign;
	private String reAssignStatus;
	private String atStoreCommits;
	private String dteAtStore;
	private String atstoreStatus;
	private String outForDelComments;
	private String dteOutForDel;
	private String outForDelStatus;
	private String deliveredComments;
	private String dteDelivered;
	private String deliverdStatus;
	
	public String getChannel()
	{
		return channel;
	}
	public void setChannel(String channel)
	{
		this.channel = channel;
	}
	public String getChannel_orderId()
	{
		return channel_orderId;
	}
	public void setChannel_orderId(String channel_orderId)
	{
		this.channel_orderId = channel_orderId;
	}
	public String getOrderState()
	{
		return orderState;
	}
	public void setOrderState(String orderState)
	{
		this.orderState = orderState;
	}
	public String getDeliveryPersonPhoneNo()
	{
		return deliveryPersonPhoneNo;
	}
	public void setDeliveryPersonPhoneNo(String deliveryPersonPhoneNo)
	{
		this.deliveryPersonPhoneNo = deliveryPersonPhoneNo;
	}
	public String getDeliveryPersonAltNo()
	{
		return deliveryPersonAltNo;
	}
	public void setDeliveryPersonAltNo(String deliveryPersonAltNo)
	{
		this.deliveryPersonAltNo = deliveryPersonAltNo;
	}
	public String getDeliveryPersonName()
	{
		return deliveryPersonName;
	}
	public void setDeliveryPersonName(String deliveryPersonName)
	{
		this.deliveryPersonName = deliveryPersonName;
	}
	public String getDeliveryUserId()
	{
		return deliveryUserId;
	}
	public void setDeliveryUserId(String deliveryUserId)
	{
		this.deliveryUserId = deliveryUserId;
	}
	public String getRiderMode()
	{
		return riderMode;
	}
	public void setRiderMode(String riderMode)
	{
		this.riderMode = riderMode;
	}
	public String getUpOrderId()
	{
		return upOrderId;
	}
	public void setUpOrderId(String upOrderId)
	{
		this.upOrderId = upOrderId;
	}
	public int getStoreId()
	{
		return storeId;
	}
	public void setStoreId(int storeId)
	{
		this.storeId = storeId;
	}
	public String getPosCode()
	{
		return posCode;
	}
	public void setPosCode(String posCode)
	{
		this.posCode = posCode;
	}
	public String getAssignComments()
	{
		return assignComments;
	}
	public void setAssignComments(String assignComments)
	{
		this.assignComments = assignComments;
	}
	public String getDteAssign()
	{
		return dteAssign;
	}
	public void setDteAssign(String dteAssign)
	{
		this.dteAssign = dteAssign;
	}
	public String getAssignStatus()
	{
		return assignStatus;
	}
	public void setAssignStatus(String assignStatus)
	{
		this.assignStatus = assignStatus;
	}
	public String getUnassignComments()
	{
		return unassignComments;
	}
	public void setUnassignComments(String unassignComments)
	{
		this.unassignComments = unassignComments;
	}
	public String getDteUnassign()
	{
		return dteUnassign;
	}
	public void setDteUnassign(String dteUnassign)
	{
		this.dteUnassign = dteUnassign;
	}
	public String getUnassignStatus()
	{
		return unassignStatus;
	}
	public void setUnassignStatus(String unassignStatus)
	{
		this.unassignStatus = unassignStatus;
	}
	public String getReassignComments()
	{
		return reassignComments;
	}
	public void setReassignComments(String reassignComments)
	{
		this.reassignComments = reassignComments;
	}
	public String getDteReassign()
	{
		return dteReassign;
	}
	public void setDteReassign(String dteReassign)
	{
		this.dteReassign = dteReassign;
	}
	public String getReAssignStatus()
	{
		return reAssignStatus;
	}
	public void setReAssignStatus(String reAssignStatus)
	{
		this.reAssignStatus = reAssignStatus;
	}
	public String getAtStoreCommits()
	{
		return atStoreCommits;
	}
	public void setAtStoreCommits(String atStoreCommits)
	{
		this.atStoreCommits = atStoreCommits;
	}
	public String getDteAtStore()
	{
		return dteAtStore;
	}
	public void setDteAtStore(String dteAtStore)
	{
		this.dteAtStore = dteAtStore;
	}
	public String getAtstoreStatus()
	{
		return atstoreStatus;
	}
	public void setAtstoreStatus(String atstoreStatus)
	{
		this.atstoreStatus = atstoreStatus;
	}
	public String getOutForDelComments()
	{
		return outForDelComments;
	}
	public void setOutForDelComments(String outForDelComments)
	{
		this.outForDelComments = outForDelComments;
	}
	public String getDteOutForDel()
	{
		return dteOutForDel;
	}
	public void setDteOutForDel(String dteOutForDel)
	{
		this.dteOutForDel = dteOutForDel;
	}
	public String getOutForDelStatus()
	{
		return outForDelStatus;
	}
	public void setOutForDelStatus(String outForDelStatus)
	{
		this.outForDelStatus = outForDelStatus;
	}
	
	public String getDeliveredComments()
	{
		return deliveredComments;
	}
	public void setDeliveredComments(String deliveredComments)
	{
		this.deliveredComments = deliveredComments;
	}
	public String getDteDelivered()
	{
		return dteDelivered;
	}
	public void setDteDelivered(String dteDelivered)
	{
		this.dteDelivered = dteDelivered;
	}
	public String getDeliverdStatus()
	{
		return deliverdStatus;
	}
	public void setDeliverdStatus(String deliverdStatus)
	{
		this.deliverdStatus = deliverdStatus;
	}
	
	
}
