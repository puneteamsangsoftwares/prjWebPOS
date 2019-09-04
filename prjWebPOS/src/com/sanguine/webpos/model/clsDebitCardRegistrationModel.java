package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.IdClass;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

import com.sanguine.base.model.clsBaseModel;
@Entity
@Table(name = "tbldebitcardmaster")
@IdClass(clsDebitCardRegistrationModel_ID.class)
/*@NamedQueries({ @NamedQuery(name = "getAllDebitcardMaster", 
query = "select m.strAreaCode,m.strAreaName,m.strPOSCode " 
		+ "from clsAreaMasterModel m where m.strClientCode=:clientCode "),

		@NamedQuery(name = "getAreaMaster", 
		query = "from clsAreaMasterModel where strAreaCode=:areaCode and strClientCode=:clientCode")})*/
public class clsDebitCardRegistrationModel extends clsBaseModel implements Serializable
{

	@Column(name = "dblRedeemAmt")
	private double dblRedeemAmt;

	@Column(name = "intPassword")
	private int intPassword;

	@Column(name = "strCardTypeCode")
	private String strCardTypeCode;

	@Column(name = "strCardNo")
	private String strCardNo;

	@Column(name = "strCardString")
	private String strCardString;

	@Column(name = "strReachrgeRemark")
	private String strReachrgeRemark;

	@Column(name = "dteDateCreated")
	private String dteDateCreated;

	@Column(name = "strUserCreated")
	private String strUserCreated;

	@Column(name = "strClientCode")
	private String strClientCode;
	
	@Column(name = "strRefMemberCode")
	private String strRefMemberCode;
	
	@Column(name = "strManualNo")
	private String strManualNo;
	
	
	@Column(name = "strCustomerCode")
	private String strCustomerCode;
	
	public double getDblRedeemAmt()
	{
		return dblRedeemAmt;
	}
	public void setDblRedeemAmt(double dblRedeemAmt)
	{
		this.dblRedeemAmt = dblRedeemAmt;
	}
	public int getIntPassword()
	{
		return intPassword;
	}
	public void setIntPassword(int intPassword)
	{
		this.intPassword = intPassword;
	}
	public String getStrCardTypeCode()
	{
		return strCardTypeCode;
	}
	public void setStrCardTypeCode(String strCardTypeCode)
	{
		this.strCardTypeCode = strCardTypeCode;
	}
	public String getStrCardNo()
	{
		return strCardNo;
	}
	public void setStrCardNo(String strCardNo)
	{
		this.strCardNo = strCardNo;
	}
	public String getStrCardString()
	{
		return strCardString;
	}
	public void setStrCardString(String strCardString)
	{
		this.strCardString = strCardString;
	}
	public String getStrReachrgeRemark()
	{
		return strReachrgeRemark;
	}
	public void setStrReachrgeRemark(String strReachrgeRemark)
	{
		this.strReachrgeRemark = strReachrgeRemark;
	}
	public String getDteDateCreated()
	{
		return dteDateCreated;
	}
	public void setDteDateCreated(String dteDateCreated)
	{
		this.dteDateCreated = dteDateCreated;
	}
	public String getStrUserCreated()
	{
		return strUserCreated;
	}
	public void setStrUserCreated(String strUserCreated)
	{
		this.strUserCreated = strUserCreated;
	}
	public String getStrClientCode()
	{
		return strClientCode;
	}
	public void setStrClientCode(String strClientCode)
	{
		this.strClientCode = strClientCode;
	}
	public String getStrRefMemberCode()
	{
		return strRefMemberCode;
	}
	public void setStrRefMemberCode(String strRefMemberCode)
	{
		this.strRefMemberCode = strRefMemberCode;
	}
	public String getStrManualNo()
	{
		return strManualNo;
	}
	public void setStrManualNo(String strManualNo)
	{
		this.strManualNo = strManualNo;
	}
	public String getStrCustomerCode()
	{
		return strCustomerCode;
	}
	public void setStrCustomerCode(String strCustomerCode)
	{
		this.strCustomerCode = strCustomerCode;
	}
	
}
