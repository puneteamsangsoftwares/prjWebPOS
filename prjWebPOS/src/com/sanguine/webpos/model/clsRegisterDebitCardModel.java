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
@IdClass(clsRegisterDebitCardModel_ID.class)
@NamedQueries({ @NamedQuery(name = "getAllDebitMaster", 
query = "select m.strCardTypeCode,m.strCardNo,m.strPOSCode " 
		+ "from clsRegisterDebitCardModel m where m.strClientCode=:clientCode "),

		@NamedQuery(name = "getDebitMaster", 
		query = "from clsRegisterDebitCardModel where strCardNo=:code and strClientCode=:clientCode")})
public class clsRegisterDebitCardModel  extends clsBaseModel implements Serializable
{
	@Column(name = "strCardTypeCode")
	private String strCardTypeCode;
	
	@Column(name = "strCardNo")
	private String strCardNo;
	
	@Column(name = "dblRedeemAmt")
	private double dblRedeemAmt;
	
	@Column(name = "strStatus")
	private String strStatus;
	
	@Column(name = "intPassword")
	private int intPassword;
	
	@Column(name = "strCardString")
	private String strCardString;
	
	@Column(name = "strReachrgeRemark")
	private String strReachrgeRemark;
	
	@Column(name = "strRefMemberCode")
	private String strRefMemberCode;
	
	@Column(name = "strManualNo")
	private String strManualNo;

    @Column(name = "strDataPostFlag")
	private String strUserCreated;

    @Column(name = "strDataPostFlag")
	private String dteDateCreated;

    @Column(name = "strDataPostFlag")
    private String strDataPostFlag;
    
    @Column(name = "strPOSCode")
    private String strPOSCode;
    

    @Column(name = "StrUserEdited")
    private String StrUserEdited; 
	public clsRegisterDebitCardModel(clsRegisterDebitCardModel_ID clsRegisterDebitCardModel_ID)
	{
		// TODO Auto-generated constructor stub
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

	public double getDblRedeemAmt()
	{
		return dblRedeemAmt;
	}

	public void setDblRedeemAmt(double dblRedeemAmt)
	{
		this.dblRedeemAmt = dblRedeemAmt;
	}

	public String getStrStatus()
	{
		return strStatus;
	}

	public void setStrStatus(String strStatus)
	{
		this.strStatus = strStatus;
	}

	public int getIntPassword()
	{
		return intPassword;
	}

	public void setIntPassword(int intPassword)
	{
		this.intPassword = intPassword;
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

	public String getStrUserCreated()
	{
		return strUserCreated;
	}

	public void setStrUserCreated(String strUserCreated)
	{
		this.strUserCreated = strUserCreated;
	}

	public String getDteDateCreated()
	{
		return dteDateCreated;
	}

	public void setDteDateCreated(String dteDateCreated)
	{
		this.dteDateCreated = dteDateCreated;
	}

	public String getStrDataPostFlag()
	{
		return strDataPostFlag;
	}

	public void setStrDataPostFlag(String strDataPostFlag)
	{
		this.strDataPostFlag = strDataPostFlag;
	}

	public String getStrPOSCode()
	{
		return strPOSCode;
	}

	public void setStrPOSCode(String strPOSCode)
	{
		this.strPOSCode = strPOSCode;
	}

	
	
	
}
