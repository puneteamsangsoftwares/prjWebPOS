package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
@Embeddable
@SuppressWarnings("serial")
public class clsPOSOrderMasterModel_ID implements Serializable
{
	
	public clsPOSOrderMasterModel_ID()
    {
    }
    
    public clsPOSOrderMasterModel_ID(String strOrderCode, String strClientCode)
    {
	this.strOrderCode = strOrderCode;
	this.strClientCode = strClientCode;
	
    }
	 // Variable Declaration
    @Column(name = "strOrderCode")
    private String strOrderCode;
    
    @Column(name = "strClientCode")
    private String strClientCode;
    

    @Column(name = "strPOSCode")
    private String strPOSCode;


	public String getStrOrderCode()
	{
		return strOrderCode;
	}


	public void setStrOrderCode(String strOrderCode)
	{
		this.strOrderCode = strOrderCode;
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
    
    
}
