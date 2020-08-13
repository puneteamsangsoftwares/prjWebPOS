package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
@Embeddable
@SuppressWarnings("serial")

public class clsStoreActionModel_ID implements Serializable{

//Variable Declaration
	@Column(name="strLocationRefId")
	private String strLocationRefId;

	@Column(name="strClientCode")
	private String strClientCode;

	public clsStoreActionModel_ID(){}
	public clsStoreActionModel_ID(String strLocationRefId,String strClientCode){
		this.strLocationRefId=strLocationRefId;
		this.strClientCode=strClientCode;
	}

//Setter-Getter Methods
	public String getStrLocationRefId(){
		return strLocationRefId;
	}
	public void setStrLocationRefId(String strLocationRefId){
		this. strLocationRefId = strLocationRefId;
	}

	public String getStrClientCode(){
		return strClientCode;
	}
	public void setStrClientCode(String strClientCode){
		this. strClientCode = strClientCode;
	}


//HashCode and Equals Funtions
	@Override
	public boolean equals(Object obj) {
		clsStoreActionModel_ID objModelId = (clsStoreActionModel_ID)obj;
		if(this.strLocationRefId.equals(objModelId.getStrLocationRefId())&& this.strClientCode.equals(objModelId.getStrClientCode())){
			return true;
		}
		else{
			return false;
		}
	}

	@Override
	public int hashCode() {
		return this.strLocationRefId.hashCode()+this.strClientCode.hashCode();
	}

}
