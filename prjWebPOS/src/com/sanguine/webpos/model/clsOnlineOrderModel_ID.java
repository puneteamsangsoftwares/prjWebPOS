package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
@Embeddable
@SuppressWarnings("serial")

public class clsOnlineOrderModel_ID implements Serializable{

//Variable Declaration
	@Column(name="strOrderId")
	private String strOrderId;

	
	@Column(name="dtOrderDate")
	private String dtOrderDate;

	@Column(name="strClientCode")
	private String strClientCode;

	
	public clsOnlineOrderModel_ID(){}
	public clsOnlineOrderModel_ID(String strOrderId,String strClientCode,String dtOrderDate){
		this.strOrderId=strOrderId;
		this.strClientCode=strClientCode;
		this.dtOrderDate=dtOrderDate;
	}

//Setter-Getter Methods
	public String getStrOrderId(){
		return strOrderId;
	}
	public void setStrOrderId(String strOrderId){
		this. strOrderId = strOrderId;
	}

	public String getStrClientCode(){
		return strClientCode;
	}
	public void setStrClientCode(String strClientCode){
		this. strClientCode = strClientCode;
	}


	public String getDtOrderDate()
		{
			return dtOrderDate;
		}
		public void setDtOrderDate(String dtOrderDate)
		{
			this.dtOrderDate = dtOrderDate;
		}
	//HashCode and Equals Funtions
	@Override
	public boolean equals(Object obj) {
		clsOnlineOrderModel_ID objModelId = (clsOnlineOrderModel_ID)obj;
		if(this.strOrderId.equals(objModelId.getStrOrderId())&& this.strClientCode.equals(objModelId.getStrClientCode())&& this.dtOrderDate.equals(objModelId.getDtOrderDate())){
			return true;
		}
		else{
			return false;
		}
	}

	@Override
	public int hashCode() {
		return this.strOrderId.hashCode()+this.dtOrderDate.hashCode()+this.strClientCode.hashCode();
	}

}
