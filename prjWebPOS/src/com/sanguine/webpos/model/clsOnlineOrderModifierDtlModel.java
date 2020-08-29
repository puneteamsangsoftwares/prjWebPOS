package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.Embeddable;
@Embeddable
public class clsOnlineOrderModifierDtlModel  implements Serializable
	
{
	private static final long serialVersionUID = 1L;

	public clsOnlineOrderModifierDtlModel() {}
	
	
	//private String strOrderId;

	private String strItemCode;

	private String strItemId;

	private String strModifierCode;

	private String strModifierName;

	private double dblQuantity;

	private double dblAmount;

	private String strSequenceNo;
	//private String strClientCode;

	//private String dtOrderDate;

	/*
	 * public String getStrOrderId() { return strOrderId; }
	 * 
	 * public void setStrOrderId(String strOrderId) { this.strOrderId = strOrderId;
	 * }
	 */
	public String getStrItemCode()
	{
		return strItemCode;
	}

	public void setStrItemCode(String strItemCode)
	{
		this.strItemCode = strItemCode;
	}

	public String getStrItemId()
	{
		return strItemId;
	}

	public void setStrItemId(String strItemId)
	{
		this.strItemId = strItemId;
	}

	public String getStrModifierCode()
	{
		return strModifierCode;
	}

	public void setStrModifierCode(String strModifierCode)
	{
		this.strModifierCode = strModifierCode;
	}

	public String getStrModifierName()
	{
		return strModifierName;
	}

	public void setStrModifierName(String strModifierName)
	{
		this.strModifierName = strModifierName;
	}

	public double getDblQuantity()
	{
		return dblQuantity;
	}

	public void setDblQuantity(double dblQuantity)
	{
		this.dblQuantity = dblQuantity;
	}

	public double getDblAmount()
	{
		return dblAmount;
	}

	public void setDblAmount(double dblAmount)
	{
		this.dblAmount = dblAmount;
	}

	public String getStrSequenceNo()
	{
		return strSequenceNo;
	}

	public void setStrSequenceNo(String strSequenceNo)
	{
		this.strSequenceNo = strSequenceNo;
	}


	/*
	 * public String getStrClientCode() { return strClientCode; }
	 * 
	 * public void setStrClientCode(String strClientCode) { this.strClientCode =
	 * strClientCode; }
	 * 
	 * public String getDtOrderDate() { return dtOrderDate; }
	 * 
	 * public void setDtOrderDate(String dtOrderDate) { this.dtOrderDate =
	 * dtOrderDate; }
	 */

}
