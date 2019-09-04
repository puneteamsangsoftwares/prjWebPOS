/*package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

import com.sanguine.base.model.clsBaseModel;



@Entity
@Table(name = "tblgiftvoucher")
@IdClass(clsGiftVoucherMasterModel_ID.class)
@NamedQueries({ @NamedQuery(name = "getAllGiftVoucherMaster", 
query = "select a.strGiftVoucherCode,a.strGiftVoucherName,a.strGiftVoucherSeries,a.intTotalGiftVouchers,a.strGiftVoucherValueType,"
		+ "a.dblGiftVoucherValue,a.dteValidFrom,a.dteValidTo " 
		+ "from clsGiftVoucherMasterModel m where m.strClientCode=:clientCode "),

		@NamedQuery(name = "getGiftVoucherMaster", 
		query = "from clsGiftVoucherMasterModel where strGiftVoucherCode=:giftVoucherCode and strClientCode=:clientCode")})

public class clsGiftVoucherMasterModel extends clsBaseModel implements Serializable
{
private static final long serialVersionUID = 1L;
    
    public clsGiftVoucherMasterModel()
    {
    }
    
    public clsGiftVoucherMasterModel(clsGiftVoucherMasterModel_ID objModelID)
    {
    	strGiftVoucherCode=objModelID.getstrGiftVoucherCode();
    	strClientCode = objModelID.getStrClientCode();
    	
    }
    @Id
    @AttributeOverrides(
    { @AttributeOverride(name = "strGiftVoucherCode", column = @Column(name = "strGiftVoucherCode")), @AttributeOverride(name = "strClientCode", column = @Column(name = "strClientCode")) })
    // Variable Declaration
    
    @Column(name = "strDataPostFlag")
    private String strDataPostFlag;
    
    public String getStrDataPostFlag()
	{
		return strDataPostFlag;
	}

	public void setStrDataPostFlag(String strDataPostFlag)
	{
		this.strDataPostFlag = strDataPostFlag;
	}

	public String getStrGiftVoucherShortName()
	{
		return strGiftVoucherShortName;
	}

	public void setStrGiftVoucherShortName(String strGiftVoucherShortName)
	{
		this.strGiftVoucherShortName = strGiftVoucherShortName;
	}
	@Column(name = "strGiftVoucherSeriesCode")
	private String strGiftVoucherSeriesCode;
	@Column(name = "strGiftVoucherCode")
    private String strGiftVoucherCode;
    
    @Column(name = "strGiftVoucherName")
    private String strGiftVoucherName;
    
    @Column(name = "strGiftVoucherSeries")
    private String strGiftVoucherSeries;
    
   
    @Column(name = "strGiftVoucherValueType")
    private String strGiftVoucherValueType;
    
    @Column(name = "intGiftVoucherStartNo")
    private double intGiftVoucherStartNo;
    
    @Column(name = "intGiftVoucherEndNo")
    private double intGiftVoucherEndNo;
    
    @Column(name = "strClientCode")
    private String strClientCode;
    
    @Column(name = "intTotalGiftVouchers")
    private int intTotalGiftVouchers;
    
    @Column(name = "dblGiftVoucherValue")
    private double dblGiftVoucherValue;
    
    @Column(name="strGiftVoucherShortName")
    private String strGiftVoucherShortName;
    
    @Column(name="dteValidFrom")
    private String dteValidFrom;
    
    @Column(name="dteValidTo")
    private String dteValidTo;
    
    @Column(name = "strUserCreated")
    private String strUserCreated;
    
    @Column(name = "strUserEdited")
    private String strUserEdited;
    
    @Column(name = "dteDateCreated")
    private String dteDateCreated;
    
    @Column(name = "dteDateEdited")
    private String dteDateEdited;
  
 
  
  public int getIntTotalGiftVouchers()
{
	return intTotalGiftVouchers;
}

public void setIntTotalGiftVouchers(int intTotalGiftVouchers)
{
	this.intTotalGiftVouchers = intTotalGiftVouchers;
}

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



public String getStrGiftVoucherSeriesCode()
{
	return strGiftVoucherSeriesCode;
}

public void setStrGiftVoucherSeriesCode(String strGiftVoucherSeriesCode)
{
	this.strGiftVoucherSeriesCode = strGiftVoucherSeriesCode;
}

public String getStrGiftVoucherSeries()
{
	return strGiftVoucherSeries;
}

public void setStrGiftVoucherSeries(String strGiftVoucherSeries)
{
	this.strGiftVoucherSeries = strGiftVoucherSeries;
}

public String getStrGiftVoucherValueType()
{
	return strGiftVoucherValueType;
}

public void setStrGiftVoucherValueType(String strGiftVoucherValueType)
{
	this.strGiftVoucherValueType = strGiftVoucherValueType;
}

public String getStrClientCode()
{
	return strClientCode;
}

public void setStrClientCode(String strClientCode)
{
	this.strClientCode = strClientCode;
}



public double getDblGiftVoucherValue()
{
	return dblGiftVoucherValue;
}

public void setDblGiftVoucherValue(double dblGiftVoucherValue)
{
	this.dblGiftVoucherValue = dblGiftVoucherValue;
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

public void setDteValidTo(String dteValidTo)
{
	this.dteValidTo = dteValidTo;
}



public String getStrUserCreated()
{
	return strUserCreated;
}

public void setStrUserCreated(String strUserCreated)
{
	this.strUserCreated = strUserCreated;
}

public String getStrUserEdited()
{
	return strUserEdited;
}

public void setStrUserEdited(String strUserEdited)
{
	this.strUserEdited = strUserEdited;
}

public String getDteDateCreated()
{
	return dteDateCreated;
}

public void setDteDateCreated(String dteDateCreated)
{
	this.dteDateCreated = dteDateCreated;
}

public String getDteDateEdited()
{
	return dteDateEdited;
}

public void setDteDateEdited(String dteDateEdited)
{
	this.dteDateEdited = dteDateEdited;
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


  
  
  
  

}
*/