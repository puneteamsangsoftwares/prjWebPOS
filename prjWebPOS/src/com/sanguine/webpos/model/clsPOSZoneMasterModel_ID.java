package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
@Embeddable
@SuppressWarnings("serial")
public class clsPOSZoneMasterModel_ID  implements Serializable
{
	// Variable Declaration
    @Column(name = "strZoneCode")
    private String strZoneCode;
    
    @Column(name = "strClientCode")
    private String strClientCode;
    
  
    public clsPOSZoneMasterModel_ID()
    {
    }
    
    public clsPOSZoneMasterModel_ID(String strZoneCode, String strClientCode)
    {
	this.strZoneCode = strZoneCode;
	this.strClientCode = strClientCode;
	
    }

	public String getStrZoneCode()
	{
		return strZoneCode;
	}

	public void setStrZoneCode(String strZoneCode)
	{
		this.strZoneCode = strZoneCode;
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
