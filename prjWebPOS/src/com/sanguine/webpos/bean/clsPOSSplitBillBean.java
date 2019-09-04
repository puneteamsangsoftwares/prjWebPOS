package com.sanguine.webpos.bean;

import java.util.ArrayList;
import java.util.List;

public class clsPOSSplitBillBean
{

	private List<clsPOSBillItemDtl> listOfBillItemDtl = new ArrayList<clsPOSBillItemDtl>();
	private String strSplitType;
	private String strBillNo;
	private double dblBillAmount;
	private double dblBalAmount;
	private String strItemName;
	private double dblQuantity;
	private double dblAmount;
	private String strItemCode;
	private double dblDiscountAmt;
	
	private int strSplitQty;
	// Getter Setter
	public List<clsPOSBillItemDtl> getListOfBillItemDtl()
	{
		return listOfBillItemDtl;
	}

	public void setListOfBillItemDtl(List<clsPOSBillItemDtl> listOfBillItemDtl)
	{
		this.listOfBillItemDtl = listOfBillItemDtl;
	}

	public String getStrSplitType()
	{
		return strSplitType;
	}

	public void setStrSplitType(String strSplitType)
	{
		this.strSplitType = strSplitType;
	}

	public String getStrBillNo()
	{
		return strBillNo;
	}

	public void setStrBillNo(String strBillNo)
	{
		this.strBillNo = strBillNo;
	}

	public double getDblBillAmount()
	{
		return dblBillAmount;
	}

	public void setDblBillAmount(double dblBillAmount)
	{
		this.dblBillAmount = dblBillAmount;
	}

	public double getDblBalAmount()
	{
		return dblBalAmount;
	}

	public void setDblBalAmount(double dblBalAmount)
	{
		this.dblBalAmount = dblBalAmount;
	}

	public String getStrItemName()
	{
		return strItemName;
	}

	public void setStrItemName(String strItemName)
	{
		this.strItemName = strItemName;
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

	public String getStrItemCode()
	{
		return strItemCode;
	}

	public void setStrItemCode(String strItemCode)
	{
		this.strItemCode = strItemCode;
	}

	public double getDblDiscountAmt()
	{
		return dblDiscountAmt;
	}

	public void setDblDiscountAmt(double dblDiscountAmt)
	{
		this.dblDiscountAmt = dblDiscountAmt;
	}

	public int getStrSplitQty()
	{
		return strSplitQty;
	}

	public void setStrSplitQty(int strSplitQty)
	{
		this.strSplitQty = strSplitQty;
	}

}
