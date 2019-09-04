package com.sanguine.webpos.model;

import java.io.Serializable;
import javax.persistence.Embeddable;
import javax.persistence.Column;
@Embeddable
@SuppressWarnings("serial")

public class clsNonChargableKOTModel_ID implements Serializable{

//Variable Declaration
	@Column(name="strTableNo")
	private String strTableNo;

	@Column(name="strItemCode")
	private String strItemCode;

	@Column(name="strKOTNo")
	private String strKOTNo;

	@Column(name="strClientCode")
	private String strClientCode;
	
	
	public clsNonChargableKOTModel_ID(){}
	public clsNonChargableKOTModel_ID(String strTableNo,String strItemCode,String strKOTNo,String strClientCode){
		this.strTableNo=strTableNo;
		this.strItemCode=strItemCode;
		this.strKOTNo=strKOTNo;
		this.strClientCode=strClientCode;
	}

//Setter-Getter Methods
	public String getStrTableNo(){
		return strTableNo;
	}
	public void setStrTableNo(String strTableNo){
		this. strTableNo = strTableNo;
	}

	public String getStrItemCode(){
		return strItemCode;
	}
	public void setStrItemCode(String strItemCode){
		this. strItemCode = strItemCode;
	}

	public String getStrKOTNo(){
		return strKOTNo;
	}
	public void setStrKOTNo(String strKOTNo){
		this. strKOTNo = strKOTNo;
	}


//HashCode and Equals Funtions
	@Override
	public boolean equals(Object obj) {
		clsNonChargableKOTModel_ID objModelId = (clsNonChargableKOTModel_ID)obj;
		if(this.strTableNo.equals(objModelId.getStrTableNo())&& this.strItemCode.equals(objModelId.getStrItemCode())&& this.strKOTNo.equals(objModelId.getStrKOTNo())){
			return true;
		}
		else{
			return false;
		}
	}

	@Override
	public int hashCode() {
		return this.strTableNo.hashCode()+this.strItemCode.hashCode()+this.strKOTNo.hashCode();
	}
	public String getStrClientCode()
	{
		return strClientCode;
	}
	public void setStrClientCode(String strClientCode)
	{
		this.strClientCode = strClientCode;
	}

}
