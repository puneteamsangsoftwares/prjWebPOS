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
@Table(name="tblonlineorderstoreaddupdate")
@IdClass(clsOnlineOrderAddUpdateStoreModel_ID.class)

public class clsOnlineOrderAddUpdateStoreModel extends clsBaseModel implements Serializable{
	private static final long serialVersionUID = 1L;
	public clsOnlineOrderAddUpdateStoreModel(){}

	public clsOnlineOrderAddUpdateStoreModel(clsOnlineOrderAddUpdateStoreModel_ID objModelID){
		//strId = objModelID.getStrId();
		strClientCode = objModelID.getStrClientCode();
	}

	@Id
	@AttributeOverrides({
		//@AttributeOverride(name="strId",column=@Column(name="strId")),
		@AttributeOverride(name="strClientCode",column=@Column(name="strClientCode"))
	})

//Variable Declaration
	/*@Column(name="strId")
	private String strId;

	@Column(name="strAction")
	private String strAction;

	@Column(name="error")
	private String error;*/

	@Column(name="updatedStore")
	private int updatedStore;

	@Column(name="errorsStore")
	private int errorsStore;

	@Column(name="createdStore")
	private int createdStore;
	
	@Column(name="strClientCode")
	private String strClientCode;
	
	@Column(name="dteCurrentDate")
	private String dteCurrentDate;

//Setter-Getter Methods
	/*public String getStrId(){
		return strId;
	}
	public void setStrId(String strId){
		this. strId = (String) setDefaultValue( strId, "NA");
	}

	public String getStrAction(){
		return strAction;
	}
	public void setStrAction(String strAction){
		this. strAction = (String) setDefaultValue( strAction, "NA");
	}
	
	public String getError()
	{
		return error;
	}

	public void setError(String error)
	{
		this.error = error;
	}*/

	public int getUpdatedStore()
	{
		return updatedStore;
	}

	public void setUpdatedStore(int updatedStore)
	{
		this.updatedStore = updatedStore;
	}

	public int getErrorsStore()
	{
		return errorsStore;
	}

	public void setErrorsStore(int errorsStore)
	{
		this.errorsStore = errorsStore;
	}

	public int getCreatedStore()
	{
		return createdStore;
	}

	public void setCreatedStore(int createdStore)
	{
		this.createdStore = createdStore;
	}

	public String getStrClientCode()
	{
		return strClientCode;
	}

	public void setStrClientCode(String strClientCode)
	{
		this.strClientCode = strClientCode;
	}

	public String getDteCurrentDate()
	{
		return dteCurrentDate;
	}

	public void setDteCurrentDate(String dteCurrentDate)
	{
		this.dteCurrentDate = dteCurrentDate;
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
