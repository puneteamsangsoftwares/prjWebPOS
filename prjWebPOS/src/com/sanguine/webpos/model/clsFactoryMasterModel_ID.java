package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;

@Embeddable
@SuppressWarnings("serial")
public class clsFactoryMasterModel_ID implements Serializable
{
	 // Variable Declaration
    @Column(name = "strFactoryCode")
    private String strFactoryCode;
    
    @Column(name = "strClientCode")
    private String strClientCode;

    public clsFactoryMasterModel_ID()
    {
    }
    
    public clsFactoryMasterModel_ID(String strFactoryCode, String strClientCode)
    {
	this.strFactoryCode = strFactoryCode;
	this.strClientCode = strClientCode;
	
    }
    
	public String getStrFactoryCode()
	{
		return strFactoryCode;
	}

	public void setStrFactoryCode(String strFactoryCode)
	{
		this.strFactoryCode = strFactoryCode;
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
