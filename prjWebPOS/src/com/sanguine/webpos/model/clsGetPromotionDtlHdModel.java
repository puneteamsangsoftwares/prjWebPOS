package com.sanguine.webpos.model;

import javax.persistence.Column;

public class clsGetPromotionDtlHdModel
{

	@Column(name = "StrPromoItemCode")
	private String StrPromoItemCode;
	@Column(name = "DblGetQty")
	private double DblGetQty;
	@Column(name = "DblDiscount")
	private double DblDiscount;

	@Column(name = "StrDiscountType")
	private String StrDiscountType;
	
	@Column(name = "strPromotionOn")
	private String strPromotionOn;
	
	

	public String getStrPromoItemCode()
	{
		return StrPromoItemCode;
	}

	public void setStrPromoItemCode(String strPromoItemCode)
	{
		StrPromoItemCode = strPromoItemCode;
	}

	public double getDblGetQty()
	{
		return DblGetQty;
	}

	public void setDblGetQty(double dblGetQty)
	{
		DblGetQty = dblGetQty;
	}

	public double getDblDiscount()
	{
		return DblDiscount;
	}

	public void setDblDiscount(double dblDiscount)
	{
		DblDiscount = dblDiscount;
	}

	public String getStrDiscountType()
	{
		return StrDiscountType;
	}

	public void setStrDiscountType(String strDiscountType)
	{
		StrDiscountType = strDiscountType;
	}

	public String getStrPromotionOn()
	{
		return strPromotionOn;
	}

	public void setStrPromotionOn(String strPromotionOn)
	{
		this.strPromotionOn = strPromotionOn;
	}
	

}
