package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
@Embeddable
@SuppressWarnings("serial")

public class clsFeedBackMasterModel_ID implements Serializable{

//Variable Declaration
	@Column(name="strFBCode")
	private String strFBCode;

	@Column(name="strClientCode")
	private String strClientCode;

	public clsFeedBackMasterModel_ID(){}
	public clsFeedBackMasterModel_ID(String strFBCode,String strClientCode){
		this.strFBCode=strFBCode;
		this.strClientCode=strClientCode;
	}

//Setter-Getter Methods
	public String getStrFBCode(){
		return strFBCode;
	}
	public void setStrFBCode(String strFBCode){
		this. strFBCode = strFBCode;
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
		clsFeedBackMasterModel_ID objModelId = (clsFeedBackMasterModel_ID)obj;
		if(this.strFBCode.equals(objModelId.getStrFBCode())&& this.strClientCode.equals(objModelId.getStrClientCode())){
			return true;
		}
		else{
			return false;
		}
	}

	@Override
	public int hashCode() {
		return this.strFBCode.hashCode()+this.strClientCode.hashCode();
	}

}
