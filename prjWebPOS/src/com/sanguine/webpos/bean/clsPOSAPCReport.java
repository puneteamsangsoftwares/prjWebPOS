/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.sanguine.webpos.bean;

/**
 *
 * @author ajjim
 */
public class clsPOSAPCReport
{
    private String strPOSCode;
    private String strPOSName;
    private String dteBillDate;
    private String strWaiterName;
    private String strBillNo;
    private double dblSubTotal;
    private double dblDiscountAmt;
    private double dblPAXNo;
    private double netTotal;
    private double grandTotal;
    private double dblDiningNoBill;
    private double dblDiningAmt;
    private double dblHDNoBill;
    private double dblDiningAvg;
    private double dblAPCPer;
    private double dblHDAmt;
    private double dblHdAvg;
    private double dblTAAmt;
    private double dblTANoBill;
    private double dblTAAvg;
    
    public String getStrPOSCode()
    {
        return strPOSCode;
    }

    public void setStrPOSCode(String strPOSCode)
    {
        this.strPOSCode = strPOSCode;
    }

    public String getStrPOSName()
    {
        return strPOSName;
    }

    public void setStrPOSName(String strPOSName)
    {
        this.strPOSName = strPOSName;
    }

    public String getDteBillDate()
    {
        return dteBillDate;
    }

    public void setDteBillDate(String dteBillDate)
    {
        this.dteBillDate = dteBillDate;
    }

   
    public double getDblPAXNo()
    {
        return dblPAXNo;
    }

    public void setDblPAXNo(double dblPAXNo)
    {
        this.dblPAXNo = dblPAXNo;
    }

    public String getStrWaiterName()
    {
        return strWaiterName;
    }

    public void setStrWaiterName(String strWaiterName)
    {
        this.strWaiterName = strWaiterName;
    }

    

    public String getStrBillNo()
    {
        return strBillNo;
    }

    public void setStrBillNo(String strBillNo)
    {
        this.strBillNo = strBillNo;
    }

    public double getDblSubTotal()
    {
        return dblSubTotal;
    }

    public void setDblSubTotal(double dblSubTotal)
    {
        this.dblSubTotal = dblSubTotal;
    }

    public double getDblDiscountAmt()
    {
        return dblDiscountAmt;
    }

    public void setDblDiscountAmt(double dblDiscountAmt)
    {
        this.dblDiscountAmt = dblDiscountAmt;
    }

    public double getNetTotal()
    {
        return netTotal;
    }

    public void setNetTotal(double netTotal)
    {
        this.netTotal = netTotal;
    }

    public double getGrandTotal()
    {
        return grandTotal;
    }

    public void setGrandTotal(double grandTotal)
    {
        this.grandTotal = grandTotal;
    }

    public double getDblDiningNoBill()
    {
        return dblDiningNoBill;
    }

    public void setDblDiningNoBill(double dblDiningNoBill)
    {
        this.dblDiningNoBill = dblDiningNoBill;
    }

    public double getDblHDNoBill()
    {
        return dblHDNoBill;
    }

    public void setDblHDNoBill(double dblHDNoBill)
    {
        this.dblHDNoBill = dblHDNoBill;
    }

    public double getDblDiningAvg()
    {
        return dblDiningAvg;
    }

    public void setDblDiningAvg(double dblDiningAvg)
    {
        this.dblDiningAvg = dblDiningAvg;
    }

    public double getDblDiningAmt()
    {
        return dblDiningAmt;
    }

    public void setDblDiningAmt(double dblDiningAmt)
    {
        this.dblDiningAmt = dblDiningAmt;
    }

    public double getDblAPCPer()
    {
        return dblAPCPer;
    }

    public void setDblAPCPer(double dblAPCPer)
    {
        this.dblAPCPer = dblAPCPer;
    }
    
  //new changes 2/2/2019 mahesh
    public double getDblHDAmt()
   	{
   		return dblHDAmt;
   	}

   	public void setDblHDAmt(double dblHDAmt)
   	{
   		this.dblHDAmt = dblHDAmt;
   	}

   	public double getDblHdAvg()
   	{
   		return dblHdAvg;
   	}

   	public void setDblHdAvg(double dblHdAvg)
   	{
   		this.dblHdAvg = dblHdAvg;
   	}

   	public double getDblTAAmt()
   	{
   		return dblTAAmt;
   	}

   	public void setDblTAAmt(double dblTAAmt)
   	{
   		this.dblTAAmt = dblTAAmt;
   	}

   	public double getDblTANoBill()
   	{
   		return dblTANoBill;
   	}

   	public void setDblTANoBill(double dblTANoBill)
   	{
   		this.dblTANoBill = dblTANoBill;
   	}

   	public double getDblTAAvg()
   	{
   		return dblTAAvg;
   	}

   	public void setDblTAAvg(double dblTAAvg)
   	{
   		this.dblTAAvg = dblTAAvg;
   	}
    

}
