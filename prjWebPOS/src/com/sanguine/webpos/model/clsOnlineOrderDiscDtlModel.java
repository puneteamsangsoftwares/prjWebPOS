package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.Embeddable;
@Embeddable
public class clsOnlineOrderDiscDtlModel implements Serializable
{
	private static final long serialVersionUID = 1L;
	public clsOnlineOrderDiscDtlModel(){}

	//private String strOrderId;

	private String isMerchantDiscount;

	private double dblDiscAmt;

	private double dblDiscPer;

	private String code;

	private String title;

	public String getIsMerchantDiscount()
	{
		return isMerchantDiscount;
	}

	public void setIsMerchantDiscount(String isMerchantDiscount)
	{
		this.isMerchantDiscount = isMerchantDiscount;
	}

	public double getDblDiscAmt()
	{
		return dblDiscAmt;
	}

	public void setDblDiscAmt(double dblDiscAmt)
	{
		this.dblDiscAmt = dblDiscAmt;
	}

	public double getDblDiscPer()
	{
		return dblDiscPer;
	}

	public void setDblDiscPer(double dblDiscPer)
	{
		this.dblDiscPer = dblDiscPer;
	}

	public String getCode()
	{
		return code;
	}

	public void setCode(String code)
	{
		this.code = code;
	}

	public String getTitle()
	{
		return title;
	}

	public void setTitle(String title)
	{
		this.title = title;
	}

	//private String strClientCode;

	//private String dtOrderDate;

	
}
