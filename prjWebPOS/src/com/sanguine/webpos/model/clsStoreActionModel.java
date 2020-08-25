package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.IdClass;
import javax.persistence.Table;
import javax.persistence.Id;

import com.sanguine.base.model.clsBaseModel;

@Entity
@Table(name="tblonlineorderstoreaction")
@IdClass(clsStoreActionModel_ID.class)

public class clsStoreActionModel extends clsBaseModel implements Serializable{
	private static final long serialVersionUID = 1L;
	public clsStoreActionModel(){}

	public clsStoreActionModel(clsStoreActionModel_ID objModelID){
		strLocationRefId = objModelID.getStrLocationRefId();
		strClientCode = objModelID.getStrClientCode();
	}

	@Id
	@AttributeOverrides({
		@AttributeOverride(name="strLocationRefId",column=@Column(name="strLocationRefId")),
@AttributeOverride(name="strClientCode",column=@Column(name="strClientCode"))
	})

//Variable Declaration
	@Column(name="strAction")
	private String strAction;

	@Column(name="strLocationRefId")
	private String strLocationRefId;

	@Column(name="strClientCode")
	private String strClientCode;

	@Column(name="strPlatform")
	private String strPlatform;

	@Column(name="strStatus")
	private String strStatus;

	@Column(name="ts_utc")
	private String ts_utc;

	

//Setter-Getter Methods
	public String getStrAction(){
		return strAction;
	}
	public void setStrAction(String strAction){
		this. strAction = (String) setDefaultValue( strAction, "NA");
	}

	public String getStrLocationRefId(){
		return strLocationRefId;
	}
	public void setStrLocationRefId(String strLocationRefId){
		this. strLocationRefId = (String) setDefaultValue( strLocationRefId, "NA");
	}

	public String getStrClientCode(){
		return strClientCode;
	}
	public void setStrClientCode(String strClientCode){
		this. strClientCode = (String) setDefaultValue( strClientCode, "NA");
	}

	public String getStrPlatform(){
		return strPlatform;
	}
	public void setStrPlatform(String strPlatform){
		this. strPlatform = (String) setDefaultValue( strPlatform, "NA");
	}

	public String getStrStatus(){
		return strStatus;
	}
	public void setStrStatus(String strStatus){
		this. strStatus = (String) setDefaultValue( strStatus, "NA");
	}

	
	

	public String getTs_utc()
	{
		return ts_utc;
	}

	public void setTs_utc(String ts_utc)
	{
		this.ts_utc = ts_utc;
	}

	public static long getSerialversionuid()
	{
		return serialVersionUID;
	}


//Function to Set Default Values
	/*private Object setDefaultValue(Object value, Object defaultValue){
		if(value !=null && (value instanceof String && value.toString().length()>0)){
			return value;
		}
		else if(value !=null && (value instanceof Double && value.toString().length()>0)){
			return value;
		}
		else if(value !=null && (value instanceof Integer && value.toString().length()>0)){
			return value;
		}
		else if(value !=null && (value instanceof Long && value.toString().length()>0)){
			return value;
		}
		else{
			return defaultValue;
		}
	}
*/
}
