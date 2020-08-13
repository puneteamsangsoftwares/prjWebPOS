package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
@Embeddable
@SuppressWarnings("serial")

public class clsMPesaOnlinePaymentModel_ID implements Serializable{

//Variable Declaration
	@Column(name="strTransID")
	private String strTransID;

	@Column(name="strBusinessShortCode")
	private String strBusinessShortCode;

	public clsMPesaOnlinePaymentModel_ID(){}
	public clsMPesaOnlinePaymentModel_ID(String strTransID,String strBusinessShortCode){
		this.strTransID=strTransID;
		this.strBusinessShortCode=strBusinessShortCode;
	}

//Setter-Getter Methods
	public String getStrTransID(){
		return strTransID;
	}
	public void setStrTransID(String strTransID){
		this. strTransID = strTransID;
	}

	public String getStrBusinessShortCode(){
		return strBusinessShortCode;
	}
	public void setStrBusinessShortCode(String strBusinessShortCode){
		this. strBusinessShortCode = strBusinessShortCode;
	}


//HashCode and Equals Funtions
	@Override
	public boolean equals(Object obj) {
		clsMPesaOnlinePaymentModel_ID objModelId = (clsMPesaOnlinePaymentModel_ID)obj;
		if(this.strTransID.equals(objModelId.getStrTransID())&& this.strBusinessShortCode.equals(objModelId.getStrBusinessShortCode())){
			return true;
		}
		else{
			return false;
		}
	}

	@Override
	public int hashCode() {
		return this.strTransID.hashCode()+this.strBusinessShortCode.hashCode();
	}

}
