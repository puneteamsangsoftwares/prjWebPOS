package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;

import com.sanguine.base.model.clsBaseModel;
@Embeddable
@SuppressWarnings("serial")

public class clsOnlineOrderAddUpdateStoreModel_ID extends clsBaseModel implements Serializable{

//Variable Declaration
/*	@Column(name="strId")
	private String strId;
	*/
	@Column(name="strClientCode")
	private String strClientCode;

	@Column(name="dteCurrentDate")
	private String dteCurrentDate;

	
	public clsOnlineOrderAddUpdateStoreModel_ID(){}
	public clsOnlineOrderAddUpdateStoreModel_ID(String strClientCode,String dteCurrentDate){
		//this.strId=strId;
		this.strClientCode=strClientCode;
		this.dteCurrentDate=dteCurrentDate;
	}

//Setter-Getter Methods
	/*public String getStrId(){
		return strId;
	}
	public void setStrId(String strId){
		this. strId = strId;
	}*/


public String getStrClientCode()
	{
		return strClientCode;
	}
	public void setStrClientCode(String strClientCode)
	{
		this.strClientCode = strClientCode;
	}
	//HashCode and Equals Funtions
	/*@Override
	public boolean equals(Object obj) {
		clsOnlineOrderAddUpdateStoreModel_ID objModelId = (clsOnlineOrderAddUpdateStoreModel_ID)obj;
		if(this.strId.equals(objModelId.getStrId())){
			return true;
		}
		else{
			return false;
		}
	}

	@Override
	public int hashCode() {
		return this.strId.hashCode();
	}
*/
	public String getDteCurrentDate()
	{
		return dteCurrentDate;
	}
	public void setDteCurrentDate(String dteCurrentDate)
	{
		this.dteCurrentDate = dteCurrentDate;
	}
}
