package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.Embeddable;
@Embeddable
public class clsOnlineOrderDtlModel  implements Serializable
{
	private static final long serialVersionUID = 1L;
	

	public clsOnlineOrderDtlModel() {}

	//private String strOrderId;

	private String itemId;

	private String itemName;

	//private String dtOrderDate;

	private String merchant_id;

	private double price;

	private double quantity;

	private double discount;

	private double total;

	private double total_with_tax;
	private double dblExtracharges;

	private String strSequenceNo;
	//private String strClientCode;

	public String getItemId()
	{
		return itemId;
	}

	public void setItemId(String itemId)
	{
		this.itemId = itemId;
	}

	public String getItemName()
	{
		return itemName;
	}

	public void setItemName(String itemName)
	{
		this.itemName = itemName;
	}

	
	public String getMerchant_id()
	{
		return merchant_id;
	}

	public void setMerchant_id(String merchant_id)
	{
		this.merchant_id = merchant_id;
	}

	public double getPrice()
	{
		return price;
	}

	public void setPrice(double price)
	{
		this.price = price;
	}

	public double getQuantity()
	{
		return quantity;
	}

	public void setQuantity(double quantity)
	{
		this.quantity = quantity;
	}

	public double getDiscount()
	{
		return discount;
	}

	public void setDiscount(double discount)
	{
		this.discount = discount;
	}

	public double getTotal()
	{
		return total;
	}

	public void setTotal(double total)
	{
		this.total = total;
	}

	public double getTotal_with_tax()
	{
		return total_with_tax;
	}

	public void setTotal_with_tax(double total_with_tax)
	{
		this.total_with_tax = total_with_tax;
	}

	public double getDblExtracharges()
	{
		return dblExtracharges;
	}

	public void setDblExtracharges(double dblExtracharges)
	{
		this.dblExtracharges = dblExtracharges;
	}

	public String getStrSequenceNo()
	{
		return strSequenceNo;
	}

	public void setStrSequenceNo(String strSequenceNo)
	{
		this.strSequenceNo = strSequenceNo;
	}



}
