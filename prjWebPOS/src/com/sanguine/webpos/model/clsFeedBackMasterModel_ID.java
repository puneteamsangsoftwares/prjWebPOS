package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
@Embeddable
@SuppressWarnings("serial")

public class clsFeedBackMasterModel_ID implements Serializable{

//Variable Declaration
	@Column(name="strQuestionCode")
	private String strQuestionCode;

	@Column(name="strClientCode")
	private String strClientCode;

	public clsFeedBackMasterModel_ID(){}
	public clsFeedBackMasterModel_ID(String strQuestionCode,String strClientCode){
		this.strQuestionCode=strQuestionCode;
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
		clsFeedBackMasterModel_ID objModelId = (clsFeedBackMasterModel_ID)obj;
		if(this.strQuestionCode.equals(objModelId.getStrQuestionCode())&& this.strClientCode.equals(objModelId.getStrClientCode())){
			return true;
		}
		else{
			return false;
		}
	}

	@Override
	public int hashCode() {
		return this.strQuestionCode.hashCode()+this.strClientCode.hashCode();
	}
	public String getStrQuestionCode()
	{
		return strQuestionCode;
	}
	public void setStrQuestionCode(String strQuestionCode)
	{
		this.strQuestionCode = strQuestionCode;
	}

}
