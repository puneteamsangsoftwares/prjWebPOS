package com.sanguine.webpos.model;

import javax.persistence.Column;

import com.sanguine.base.model.clsBaseModel;

public class clsPOSSMSSetupModel extends clsBaseModel
{
	@Column(name = "strPOSCode")
private String strPOSCode;

	@Column(name = "strClientCode")
	private String strClientCode;

	@Column(name = "strTransactionName")
	private String strTransactionName;
	
	@Column(name = "strSendSMSYN")
	private String strSendSMSYN;
	
	@Column(name = "longMobileNo")
	private String longMobileNo;
	
	@Column(name = "strUserCreated")
	private String strUserCreated;
	
	@Column(name = "strUserEdited")
	private String strUserEdited;
	
	@Column(name = "strDataPostFlag")
	private String strDataPostFlag;

	public String getStrPOSCode()
	{
		return strPOSCode;
	}

	public void setStrPOSCode(String strPOSCode)
	{
		this.strPOSCode = strPOSCode;
	}

	public String getStrClientCode()
	{
		return strClientCode;
	}

	public void setStrClientCode(String strClientCode)
	{
		this.strClientCode = strClientCode;
	}

	public String getStrTransactionName()
	{
		return strTransactionName;
	}

	public void setStrTransactionName(String strTransactionName)
	{
		this.strTransactionName = strTransactionName;
	}

	public String getStrSendSMSYN()
	{
		return strSendSMSYN;
	}

	public void setStrSendSMSYN(String strSendSMSYN)
	{
		this.strSendSMSYN = strSendSMSYN;
	}

	public String getLongMobileNo()
	{
		return longMobileNo;
	}

	public void setLongMobileNo(String longMobileNo)
	{
		this.longMobileNo = longMobileNo;
	}

	public String getStrUserCreated()
	{
		return strUserCreated;
	}

	public void setStrUserCreated(String strUserCreated)
	{
		this.strUserCreated = strUserCreated;
	}

	public String getStrUserEdited()
	{
		return strUserEdited;
	}

	public void setStrUserEdited(String strUserEdited)
	{
		this.strUserEdited = strUserEdited;
	}

	public String getStrDataPostFlag()
	{
		return strDataPostFlag;
	}

	public void setStrDataPostFlag(String strDataPostFlag)
	{
		this.strDataPostFlag = strDataPostFlag;
	}

}
