package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

import com.sanguine.base.model.clsBaseModel;

@Entity
@Table(name="tblpaymentsetup")
@IdClass(clsPaymentSetupModel_ID.class)
@NamedQueries({@NamedQuery(name = "getPaymentSetup", 
		query = "from clsPaymentSetupModel where strChannelName=:channelName and strClientCode=:clientCode")})

//getAreaMaster
public class clsPaymentSetupModel extends clsBaseModel  implements Serializable{
	private static final long serialVersionUID = 1L;
	public clsPaymentSetupModel(){}

	public clsPaymentSetupModel(clsPaymentSetupModel_ID objModelID){
		strChannelName = objModelID.getStrChannelName();
		strClientCode = objModelID.getStrClientCode();
	}

	@Id
	@AttributeOverrides({
		@AttributeOverride(name="strChannelName",column=@Column(name="strChannelName")),
@AttributeOverride(name="strClientCode",column=@Column(name="strClientCode"))
	})

//Variable Declaration
	@Column(name="strChannelName")
	private String strChannelName;

	@Column(name="strChannelID")
	private String strChannelID;

	@Column(name="strClientCode")
	private String strClientCode;

	@Column(name="strOperational")
	private String strOperational;

	@Column(name="strUserCreated")
	private String strUserCreated;

	@Column(name="strUserEdited")
	private String strUserEdited;

	@Column(name="dteDateCreated")
	private String dteDateCreated;

	@Column(name="dteDateEdited")
	private String dteDateEdited;

//Setter-Getter Methods
	public String getStrChannelName(){
		return strChannelName;
	}
	public void setStrChannelName(String strChannelName){
		this. strChannelName = (String) setDefaultValue( strChannelName, "NA");
	}

	public String getStrChannelID(){
		return strChannelID;
	}
	public void setStrChannelID(String strChannelID){
		this. strChannelID = (String) setDefaultValue( strChannelID, "NA");
	}

	public String getStrClientCode(){
		return strClientCode;
	}
	public void setStrClientCode(String strClientCode){
		this. strClientCode = (String) setDefaultValue( strClientCode, "NA");
	}

	public String getStrOperational(){
		return strOperational;
	}
	public void setStrOperational(String strOperational){
		this. strOperational = (String) setDefaultValue( strOperational, "NA");
	}

	public String getStrUserCreated(){
		return strUserCreated;
	}
	public void setStrUserCreated(String strUserCreated){
		this. strUserCreated = (String) setDefaultValue( strUserCreated, "NA");
	}

	public String getStrUserEdited(){
		return strUserEdited;
	}
	public void setStrUserEdited(String strUserEdited){
		this. strUserEdited = (String) setDefaultValue( strUserEdited, "NA");
	}

	public String getDteDateCreated(){
		return dteDateCreated;
	}
	public void setDteDateCreated(String dteDateCreated){
		this.dteDateCreated=dteDateCreated;
	}

	public String getDteDateEdited(){
		return dteDateEdited;
	}
	public void setDteDateEdited(String dteDateEdited){
		this.dteDateEdited=dteDateEdited;
	}


//Function to Set Default Values
	/*
	 * private Object setDefaultValue(Object value, Object defaultValue){ if(value
	 * !=null && (value instanceof String && value.toString().length()>0)){ return
	 * value; } else if(value !=null && (value instanceof Double &&
	 * value.toString().length()>0)){ return value; } else if(value !=null && (value
	 * instanceof Integer && value.toString().length()>0)){ return value; } else
	 * if(value !=null && (value instanceof Long && value.toString().length()>0)){
	 * return value; } else{ return defaultValue; } }
	 */

}
