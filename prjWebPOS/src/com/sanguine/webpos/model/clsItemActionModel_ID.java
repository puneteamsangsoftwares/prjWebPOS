package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
@Embeddable
@SuppressWarnings("serial")

public class clsItemActionModel_ID implements Serializable{

//Variable Declaration
	@Column(name="strUpItemId")
	private String strUpItemId;

	@Column(name="strUpLocationId")
	private String strUpLocationId;
	
	@Column(name="strClientCode")
	private String strClientCode;

	public clsItemActionModel_ID(){}
	public clsItemActionModel_ID(String strUpItemId,String strUpLocationId,String strClientCode){
		this.strUpItemId=strUpItemId;
		this.strUpLocationId=strUpLocationId;
		this.strClientCode=strClientCode;
	}

//Setter-Getter Methods
	public String getStrUpItemId(){
		return strUpItemId;
	}
	public void setStrUpItemId(String strUpItemId){
		this. strUpItemId = strUpItemId;
	}

	public String getStrUpLocationId(){
		return strUpLocationId;
	}
	public void setStrUpLocationId(String strUpLocationId){
		this. strUpLocationId = strUpLocationId;
	}

    public String getStrClientCode()
	{
		return strClientCode;
	}
	public void setStrClientCode(String strClientCode)
	{
		this.strClientCode = strClientCode;
	}
	//HashCode and Equals Funtions
	@Override
	public boolean equals(Object obj) {
		clsItemActionModel_ID objModelId = (clsItemActionModel_ID)obj;
		if(this.strUpItemId.equals(objModelId.getStrUpItemId())&& this.strUpLocationId.equals(objModelId.getStrUpLocationId())){
			return true;
		}
		else{
			return false;
		}
	}

	@Override
	public int hashCode() {
		return this.strUpItemId.hashCode()+this.strUpLocationId.hashCode();
	}

}
