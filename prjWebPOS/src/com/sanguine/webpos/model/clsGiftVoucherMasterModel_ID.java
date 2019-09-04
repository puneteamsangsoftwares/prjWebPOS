package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.Column;

public class clsGiftVoucherMasterModel_ID implements Serializable
{
	// Variable Declaration
    @Column(name = "strGiftVoucherCode")
    private String strGiftVoucherCode;
    
    @Column(name = "strClientCode")
    private String strClientCode;
    
    public clsGiftVoucherMasterModel_ID()
    {
    }
    
    public clsGiftVoucherMasterModel_ID(String strGiftVoucherCode, String strClientCode)
    {
	this.strGiftVoucherCode = strGiftVoucherCode;
	this.strClientCode = strClientCode;
    }
    
    // Setter-Getter Methods
    public String getstrGiftVoucherCode()
    {
	return strGiftVoucherCode;
    }
    
    public void setstrGiftVoucherCode(String strGiftVoucherCode)
    {
	this.strGiftVoucherCode = strGiftVoucherCode;
    }
    
    public String getStrClientCode()
    {
	return strClientCode;
    }
    
    public void setStrClientCode(String strClientCode)
    {
	this.strClientCode = strClientCode;
    }
    
    // HashCode and Equals Funtions
    @Override
    public boolean equals(Object obj)
    {
    	clsGiftVoucherMasterModel_ID objModelId = (clsGiftVoucherMasterModel_ID) obj;
	if (this.strGiftVoucherCode.equals(objModelId.getstrGiftVoucherCode()) && this.strClientCode.equals(objModelId.getStrClientCode()))
	{
	    return true;
	}
	else
	{
	    return false;
	}
    }
    
    @Override
    public int hashCode()
    {
	return this.strGiftVoucherCode.hashCode() + this.strClientCode.hashCode();
    }
    
}
