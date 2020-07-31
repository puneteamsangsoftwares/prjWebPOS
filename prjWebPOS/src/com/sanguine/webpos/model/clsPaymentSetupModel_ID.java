package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
@Embeddable
@SuppressWarnings("serial")

public class clsPaymentSetupModel_ID implements Serializable{

//Variable Declaration
	@Column(name="strChannelName")
	private String strChannelName;

	@Column(name="strClientCode")
	private String strClientCode;

	public clsPaymentSetupModel_ID(){}
	public clsPaymentSetupModel_ID(String strChannelName,String strClientCode){
		this.strChannelName=strChannelName;
		this.strClientCode=strClientCode;
	}

//Setter-Getter Methods
	

	public String getStrClientCode(){
		return strClientCode;
	}
	public void setStrClientCode(String strClientCode){
		this. strClientCode = strClientCode;
	}


//HashCode and Equals Funtions
	@Override
	public boolean equals(Object obj) {
		clsPaymentSetupModel_ID objModelId = (clsPaymentSetupModel_ID)obj;
		if(this.strChannelName.equals(objModelId.getStrChannelName())&& this.strClientCode.equals(objModelId.getStrClientCode())){
			return true;
		}
		else{
			return false;
		}
	}

	@Override
	public int hashCode() {
		return this.strChannelName.hashCode()+this.strClientCode.hashCode();
	}
	public String getStrChannelName()
	{
		return strChannelName;
	}
	public void setStrChannelName(String strChannelName)
	{
		this.strChannelName = strChannelName;
	}

}
