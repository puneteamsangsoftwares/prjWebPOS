package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;

@Embeddable
@SuppressWarnings("serial")
public class clsPOSSMSSetupModel_ID implements Serializable
{
	@Column(name = "strClientCode")
	private String	strClientCode;

	@Column(name = "strPOSCode")
	private String	strPOSCode;
	
	@Column(name = "strTransactionName")
	private String	strTransactionName;
	
	public clsPOSSMSSetupModel_ID()
	{
	}

	public clsPOSSMSSetupModel_ID(String strClientCode, String strPOSCode,String strTransactionName)
	{
		this.strClientCode = strClientCode;
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

	public String getStrPOSCode()
	{
		return strPOSCode;
	}

	public void setStrPOSCode(String strPOSCode)
	{
		this.strPOSCode = strPOSCode;
	}

	public String getStrTransactionName()
	{
		return strTransactionName;
	}

	public void setStrTransactionName(String strTransactionName)
	{
		this.strTransactionName = strTransactionName;
	}
	
	
}
