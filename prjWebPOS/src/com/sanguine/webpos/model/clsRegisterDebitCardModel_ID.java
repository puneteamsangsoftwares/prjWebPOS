package com.sanguine.webpos.model;

import javax.persistence.Column;

public class clsRegisterDebitCardModel_ID
{
	 // Variable Declaration
    @Column(name = "strCardNo")
    private String strCardNo;
    
    @Column(name = "strClientCode")
    private String strClientCode;

	public String getStrCardNo()
	{
		return strCardNo;
	}

	public void setStrCardNo(String strCardNo)
	{
		this.strCardNo = strCardNo;
	}

	public String getStrClientCode()
	{
		return strClientCode;
	}

	public void setStrClientCode(String strClientCode)
	{
		this.strClientCode = strClientCode;
	}
	 public clsRegisterDebitCardModel_ID()
	    {
	    }
	public clsRegisterDebitCardModel_ID(String strCardNo, String strClientCode)
	{
		super();
		this.strCardNo = strCardNo;
		this.strClientCode = strClientCode;
	}
    
    
    
}
