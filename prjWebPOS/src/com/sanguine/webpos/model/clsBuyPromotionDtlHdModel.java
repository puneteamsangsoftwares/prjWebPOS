package com.sanguine.webpos.model;

import javax.persistence.Column;

public class clsBuyPromotionDtlHdModel
{
	
	
	@Column(name = "strPromoCode")
	private String strPromoCode;
	
	@Column(name = "strBuyPromoItemCode")
	private String strBuyPromoItemCode;

	
	@Column(name = "dblBuyItemQty")
	private double dblBuyItemQty;
	
	@Column(name = "strOperator")
	private String strOperator;
	

	@Column(name = "strDataPostFlag")
	private String strDataPostFlag;

	public String getStrPromoCode()
	{
		return strPromoCode;
	}

	public void setStrPromoCode(String strPromoCode)
	{
		this.strPromoCode = strPromoCode;
	}

	public String getStrBuyPromoItemCode()
	{
		return strBuyPromoItemCode;
	}

	public void setStrBuyPromoItemCode(String strBuyPromoItemCode)
	{
		this.strBuyPromoItemCode = strBuyPromoItemCode;
	}

	

	public String getStrOperator()
	{
		return strOperator;
	}

	public void setStrOperator(String strOperator)
	{
		this.strOperator = strOperator;
	}

	
	public String getStrDataPostFlag()
	{
		return strDataPostFlag;
	}

	public void setStrDataPostFlag(String strDataPostFlag)
	{
		this.strDataPostFlag = strDataPostFlag;
	}

	public double getDblBuyItemQty()
	{
		return dblBuyItemQty;
	}

	public void setDblBuyItemQty(double dblBuyItemQty)
	{
		this.dblBuyItemQty = dblBuyItemQty;
	}

	
	
}
