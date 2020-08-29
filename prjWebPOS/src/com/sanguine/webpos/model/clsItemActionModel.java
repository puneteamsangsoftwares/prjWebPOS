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
@Table(name="tblonlineorderitemaction")
@IdClass(clsItemActionModel_ID.class)

public class clsItemActionModel extends clsBaseModel implements Serializable{
	private static final long serialVersionUID = 1L;
	public clsItemActionModel(){}

	public clsItemActionModel(clsItemActionModel_ID objModelID){
		strUpItemId = objModelID.getStrUpItemId();
		strUpLocationId = objModelID.getStrUpLocationId();
		strClientCode = objModelID.getStrClientCode();
	}

	@Id
	@AttributeOverrides({
		@AttributeOverride(name="strUpItemId",column=@Column(name="strUpItemId")),
@AttributeOverride(name="strUpLocationId",column=@Column(name="strUpLocationId")),
@AttributeOverride(name="strClientCode",column=@Column(name="strClientCode"))
	})

//Variable Declaration
	

	@Column(name="strAction")
	private String strAction;

	@Column(name="strPlatform")
	private String strPlatform;

	@Column(name="strUpItemId")
	private String strUpItemId;

	@Column(name="strItemCode")
	private String strItemCode;

	@Column(name="strUpLocationId")
	private String strUpLocationId;

	@Column(name="strLocationCode")
	private String strLocationCode;

	@Column(name="strItemStatus")
	private String strItemStatus;

	@Column(name="ts_utc")
	private String ts_utc;
	
	@Column(name="strClientCode")
	private String strClientCode;

//Setter-Getter Methods
	
	public String getStrAction(){
		return strAction;
	}
	public void setStrAction(String strAction){
		this. strAction = (String) setDefaultValue( strAction, "NA");
	}

	public String getStrPlatform(){
		return strPlatform;
	}
	public void setStrPlatform(String strPlatform){
		this. strPlatform = (String) setDefaultValue( strPlatform, "NA");
	}

	public String getStrUpItemId(){
		return strUpItemId;
	}
	public void setStrUpItemId(String strUpItemId){
		this. strUpItemId = (String) setDefaultValue( strUpItemId, "NA");
	}

	public String getStrItemCode(){
		return strItemCode;
	}
	public void setStrItemCode(String strItemCode){
		this. strItemCode = (String) setDefaultValue( strItemCode, "NA");
	}

	public String getStrUpLocationId(){
		return strUpLocationId;
	}
	public void setStrUpLocationId(String strUpLocationId){
		this. strUpLocationId = (String) setDefaultValue( strUpLocationId, "NA");
	}

	public String getStrLocationCode(){
		return strLocationCode;
	}
	public void setStrLocationCode(String strLocationCode){
		this. strLocationCode = (String) setDefaultValue( strLocationCode, "NA");
	}

	public String getStrItemStatus(){
		return strItemStatus;
	}
	public void setStrItemStatus(String strItemStatus){
		this. strItemStatus = (String) setDefaultValue( strItemStatus, "NA");
	}

	

	public String getStrClientCode()
	{
		return strClientCode;
	}

	public void setStrClientCode(String strClientCode)
	{
		this.strClientCode = strClientCode;
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
	}*/

}
