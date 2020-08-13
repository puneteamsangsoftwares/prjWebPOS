package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;

import com.sanguine.base.model.clsBaseModel;
@Embeddable
@SuppressWarnings("serial")

public class clsOnlineOrderAddUpdateStoreModel_ID extends clsBaseModel implements Serializable{

//Variable Declaration
	@Column(name="strId")
	private String strId;

	public clsOnlineOrderAddUpdateStoreModel_ID(){}
	public clsOnlineOrderAddUpdateStoreModel_ID(String strId){
		this.strId=strId;
	}

//Setter-Getter Methods
	public String getStrId(){
		return strId;
	}
	public void setStrId(String strId){
		this. strId = strId;
	}


//HashCode and Equals Funtions
	@Override
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

}
