package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.Column;

public class clsPOSCounterMasterModel_ID implements Serializable
{
	 /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	// Variable Declaration
    @Column(name = "strCounterCode")
    private String strCounterCode;
    
    @Column(name = "strClientCode")
    private String strClientCode;

    
    public clsPOSCounterMasterModel_ID()
    {
    }
    
	public clsPOSCounterMasterModel_ID(String strCounterCode, String strClientCode)
	{
		super();
		this.strCounterCode = strCounterCode;
		this.strClientCode = strClientCode;
	}

	public String getStrCounterCode()
	{
		return strCounterCode;
	}

	public void setStrCounterCode(String strCounterCode)
	{
		this.strCounterCode = strCounterCode;
	}

	public String getStrClientCode()
	{
		return strClientCode;
	}

	public void setStrClientCode(String strClientCode)
	{
		this.strClientCode = strClientCode;
	}
    
    
    
    
}
