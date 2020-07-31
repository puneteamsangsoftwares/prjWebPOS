package com.sanguine.webpos.bean;

public class clsPaymentSetupBean{
//Variable Declaration
	private String strChannelName;

	private String strChannelID;

	private String strClientCode;

	private String strOperational;

	private String strUserCreated;

	private String strUserEdited;

	private String dteDateCreated;

	private String dteDateEdited;

//Setter-Getter Methods
	public String getStrChannelName(){
		return strChannelName;
	}
	public void setStrChannelName(String strChannelName){
		this.strChannelName=strChannelName;
	}

	public String getStrChannelID(){
		return strChannelID;
	}
	public void setStrChannelID(String strChannelID){
		this.strChannelID=strChannelID;
	}

	public String getStrClientCode(){
		return strClientCode;
	}
	public void setStrClientCode(String strClientCode){
		this.strClientCode=strClientCode;
	}

	public String getStrOperational(){
		return strOperational;
	}
	public void setStrOperational(String strOperational){
		this.strOperational=strOperational;
	}

	public String getStrUserCreated(){
		return strUserCreated;
	}
	public void setStrUserCreated(String strUserCreated){
		this.strUserCreated=strUserCreated;
	}

	public String getStrUserEdited(){
		return strUserEdited;
	}
	public void setStrUserEdited(String strUserEdited){
		this.strUserEdited=strUserEdited;
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



}
