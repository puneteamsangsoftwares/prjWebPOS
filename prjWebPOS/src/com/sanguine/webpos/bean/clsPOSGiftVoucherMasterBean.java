package com.sanguine.webpos.bean;

public class clsPOSGiftVoucherMasterBean
{

	private String strGiftVoucherCode; 
	private String	strGiftVoucherName; 
	private String strGiftVoucherSeries;
	private String strGiftVoucherValueType; 
	private String strVoucherValue; 
	private String dteValidFrom;
	private String dteValidTo;
	private String strDataPostFlag;
	private String strGiftVoucherSeriesCode;
	private int intTotalGiftVouchers;
	private double intGiftVoucherStartNo, intGiftVoucherEndNo,  dblGiftVoucherValue;
	


	public String getStrGiftVoucherCode()
	{
		return strGiftVoucherCode;
	}


	public void setStrGiftVoucherCode(String strGiftVoucherCode)
	{
		this.strGiftVoucherCode = strGiftVoucherCode;
	}


	public String getStrGiftVoucherName()
	{
		return strGiftVoucherName;
	}


	public void setStrGiftVoucherName(String strGiftVoucherName)
	{
		this.strGiftVoucherName = strGiftVoucherName;
	}


	

	public String getStrGiftVoucherSeries()
	{
		return strGiftVoucherSeries;
	}


	public void setStrGiftVoucherSeries(String strGiftVoucherSeries)
	{
		this.strGiftVoucherSeries = strGiftVoucherSeries;
	}
	public String getStrGiftVoucherSeriesCode()
	{
		return strGiftVoucherSeriesCode;
	}


	public void setStrGiftVoucherSeriesCode(String strGiftVoucherSeriesCode)
	{
		this.strGiftVoucherSeriesCode = strGiftVoucherSeriesCode;
	}


	public String getStrDataPostFlag()
	{
		return strDataPostFlag;
	}


	public void setStrDataPostFlag(String strDataPostFlag)
	{
		this.strDataPostFlag = strDataPostFlag;
	}


	public void setDteValidTo(String dteValidTo)
	{
		this.dteValidTo = dteValidTo;
	}


	public String getStrGiftVoucherValueType()
	{
		return strGiftVoucherValueType;
	}


	public void setStrGiftVoucherValueType(String strGiftVoucherValueType)
	{
		this.strGiftVoucherValueType = strGiftVoucherValueType;
	}


	public String getDteValidFrom()
	{
		return dteValidFrom;
	}


	public void setDteValidFrom(String dteValidFrom)
	{
		this.dteValidFrom = dteValidFrom;
	}


	public String getDteValidTo()
	{
		return dteValidTo;
	}


	public void setDteValideTo(String dteValidTo)
	{
		this.dteValidTo = dteValidTo;
	}


	


	public double getIntGiftVoucherStartNo()
	{
		return intGiftVoucherStartNo;
	}


	public void setIntGiftVoucherStartNo(double intGiftVoucherStartNo)
	{
		this.intGiftVoucherStartNo = intGiftVoucherStartNo;
	}


	public double getIntGiftVoucherEndNo()
	{
		return intGiftVoucherEndNo;
	}


	public void setIntGiftVoucherEndNo(double intGiftVoucherEndNo)
	{
		this.intGiftVoucherEndNo = intGiftVoucherEndNo;
	}


	


	public int getIntTotalGiftVouchers()
	{
		return intTotalGiftVouchers;
	}


	public void setIntTotalGiftVouchers(int intTotalGiftVouchers)
	{
		this.intTotalGiftVouchers = intTotalGiftVouchers;
	}


	public double getDblGiftVoucherValue()
	{
		return dblGiftVoucherValue;
	}


	public void setDblGiftVoucherValue(double dblGiftVoucherValue)
	{
		this.dblGiftVoucherValue = dblGiftVoucherValue;
	}


	public String getStrVoucherValue()
	{
		return strVoucherValue;
	}


	public void setStrVoucherValue(String strVoucherValue)
	{
		this.strVoucherValue = strVoucherValue;
	}


	
}
