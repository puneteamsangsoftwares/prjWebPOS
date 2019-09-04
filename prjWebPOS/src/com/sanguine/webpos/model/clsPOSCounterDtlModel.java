package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.Column;

public class clsPOSCounterDtlModel implements Serializable
{
	
	private static final long serialVersionUID = 1L;

	public clsPOSCounterDtlModel()
	{
	}
	/*
	@Column(name = "strCounterCode")
	private String strCounterCode;*/
	
	@Column(name = "strMenuCode")
	private String strMenuCode;
	
/*	@Column(name = "strClientCode")
	private String strClientCode;*/

	/*public String getStrCounterCode()
	{
		return strCounterCode;
	}

	public void setStrCounterCode(String strCounterCode)
	{
		this.strCounterCode = strCounterCode;
	}*/

	public String getStrMenuCode()
	{
		return strMenuCode;
	}

	public void setStrMenuCode(String strMenuCode)
	{
		this.strMenuCode = strMenuCode;
	}


	
	
	

}
