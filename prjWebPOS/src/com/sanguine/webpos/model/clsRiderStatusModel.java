package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.IdClass;
import javax.persistence.Table;
import javax.persistence.Id;

import com.sanguine.base.model.clsBaseModel;

@Entity
@Table(name="tblonlineriderstatus")
@IdClass(clsRiderStatusModel_ID.class)

public class clsRiderStatusModel extends clsBaseModel implements Serializable{
	private static final long serialVersionUID = 1L;
	public clsRiderStatusModel(){}

	public clsRiderStatusModel(clsRiderStatusModel_ID objModelID){
		channel_orderId = objModelID.getChannel_orderId();
		upOrderId = objModelID.getUpOrderId();
		storeId = objModelID.getStoreId();
		strClientCode = objModelID.getStrClientCode();
	}

	@Id
	@AttributeOverrides({
		@AttributeOverride(name="channel_orderId",column=@Column(name="channel_orderId")),
@AttributeOverride(name="upOrderId",column=@Column(name="upOrderId")),
@AttributeOverride(name="storeId",column=@Column(name="storeId")),
@AttributeOverride(name="strClientCode",column=@Column(name="strClientCode"))		
	})

//Variable Declaration
	@Column(name="channel")
	private String channel;

	@Column(name="channel_orderId")
	private String channel_orderId;

	@Column(name="orderState")
	private String orderState;

	@Column(name="deliveryPersonPhoneNo")
	private String deliveryPersonPhoneNo;

	@Column(name="deliveryPersonAltNo")
	private String deliveryPersonAltNo;

	@Column(name="deliveryPersonName")
	private String deliveryPersonName;

	@Column(name="deliveryUserId")
	private String deliveryUserId;

	@Column(name="riderMode")
	private String riderMode;

	@Column(name="upOrderId")
	private int upOrderId;

	@Column(name="storeId")
	private String storeId;

	@Column(name="storeRefId")
	private String storeRefId;

	@Column(name="assignComments")
	private String assignComments;

	@Column(name="assignStatus")
	private String assignStatus;

	@Column(name="dteAssign")
	private String dteAssign;

	@Column(name="unassignComments")
	private String unassignComments;

	@Column(name="dteUnassign")
	private String dteUnassign;

	@Column(name="unassignStatus")
	private String unassignStatus;

	@Column(name="reassignComments")
	private String reassignComments;

	@Column(name="dteReassign")
	private String dteReassign;

	@Column(name="reAssignStatus")
	private String reAssignStatus;

	@Column(name="atStoreCommits")
	private String atStoreCommits;

	@Column(name="dteAtStore")
	private String dteAtStore;

	@Column(name="atstoreStatus")
	private String atstoreStatus;

	@Column(name="outForDelComments")
	private String outForDelComments;

	@Column(name="dteOutForDel")
	private String dteOutForDel;

	@Column(name="outForDelStatus")
	private String outForDelStatus;

	@Column(name="deliveredComments")
	private String deliveredComments;

	@Column(name="dteDelivered")
	private String dteDelivered;

	@Column(name="deliverdStatus")
	private String deliverdStatus;
	
	@Column(name="strClientCode")
	private String strClientCode;

	
//Setter-Getter Methods
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

	

	public int getUpOrderId()
	{
		return upOrderId;
	}

	public void setUpOrderId(int upOrderId)
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

	

	public String getStoreRefId()
	{
		return storeRefId;
	}

	public void setStoreRefId(String storeRefId)
	{
		this.storeRefId = storeRefId;
	}

	public String getAssignComments()
	{
		return assignComments;
	}

	public void setAssignComments(String assignComments)
	{
		this.assignComments = assignComments;
	}

	public String getAssignStatus()
	{
		return assignStatus;
	}

	public void setAssignStatus(String assignStatus)
	{
		this.assignStatus = assignStatus;
	}

	public String getDteAssign()
	{
		return dteAssign;
	}

	public void setDteAssign(String dteAssign)
	{
		this.dteAssign = dteAssign;
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

	public String getStrClientCode()
	{
		return strClientCode;
	}

	public void setStrClientCode(String strClientCode)
	{
		this.strClientCode = strClientCode;
	}

	public static long getSerialversionuid()
	{
		return serialVersionUID;
	}
	


//Function to Set Default Values
	/*private Object setDefaultValue(Object value, Object defaultValue){
		if(value !=null && (value instanceof String && value.toString().length()>0)){
			return value;
		}
		else if(value !=null && (value instanceof Double && value.toString().length()>0)){
			return value;
		}
		else if(value !=null && (value instanceof Integer && value.toString().length()>0)){
			return value;
		}
		else if(value !=null && (value instanceof Long && value.toString().length()>0)){
			return value;
		}
		else{
			return defaultValue;
		}
	}
*/
}
