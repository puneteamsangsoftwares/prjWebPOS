package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
@Embeddable
@SuppressWarnings("serial")

public class clsPOSPrinterSetUpMasterModel_ID implements Serializable{

//Variable Declaration
	@Column(name="strPOSCode")
	private String strPOSCode;

	@Column(name="strAreaCode")
	private String strAreaCode;

	@Column(name="strCostCenterCode")
	private String strCostCenterCode;

	@Column(name="strClientCode")
	private String strClientCode;

	public clsPOSPrinterSetUpMasterModel_ID(){}
	public clsPOSPrinterSetUpMasterModel_ID(String strPOSCode,String strAreaCode,String strCostCenterCode,String strClientCode){
		this.strPOSCode=strPOSCode;
		this.strAreaCode=strAreaCode;
		this.strCostCenterCode=strCostCenterCode;
		this.strClientCode=strClientCode;
	}

//Setter-Getter Methods
	public String getStrPOSCode(){
		return strPOSCode;
	}
	public void setStrPOSCode(String strPOSCode){
		this. strPOSCode = strPOSCode;
	}

	public String getStrAreaCode(){
		return strAreaCode;
	}
	public void setStrAreaCode(String strAreaCode){
		this. strAreaCode = strAreaCode;
	}

	public String getStrCostCenterCode(){
		return strCostCenterCode;
	}
	public void setStrCostCenterCode(String strCostCenterCode){
		this. strCostCenterCode = strCostCenterCode;
	}

	public String getStrClientCode(){
		return strClientCode;
	}
	public void setStrClientCode(String strClientCode){
		this. strClientCode = strClientCode;
	}


/*//HashCode and Equals Funtions
	@Override
	public boolean equals(Object obj) {
		clsPOSPrinterSetUpMasterModel_ID objModelId = (clsPOSPrinterSetUpMasterModel_ID)obj;
		if(this.strPOSCode.equals(objModelId.getStrPOSCode())&& this.strAreaCode.equals(objModelId.getStrAreaCode())&& this.strCostCenterCode.equals(objModelId.getStrCostCenterCode())&& this.strClientCode.equals(objModelId.getStrClientCode())){
			return true;
		}
		else{
			return false;
		}
	}

	@Override
	public int hashCode() {
		return this.strPOSCode.hashCode()+this.strAreaCode.hashCode()+this.strCostCenterCode.hashCode()+this.strClientCode.hashCode();
	}*/

}
