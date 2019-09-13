package com.sanguine.webpos.model;
import java.io.Serializable;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.Table;

import com.sanguine.base.model.clsBaseModel;

@Entity
@Table(name = "tblsmssetup")
@IdClass(clsPOSSMSSetupModel_ID.class)
public class clsPOSSMSSetupModel extends clsBaseModel implements Serializable
{
	private static final long serialVersionUID = 1L;

	public clsPOSSMSSetupModel()
	{
	}

	public clsPOSSMSSetupModel(clsPOSSMSSetupModel_ID objModelID)
	{
		strClientCode = objModelID.getStrClientCode();
		strPOSCode = objModelID.getStrPOSCode();
		strTransactionName=objModelID.getStrTransactionName();
	}
	@Id
	@AttributeOverrides({ @AttributeOverride(name = "strClientCode", column = @Column(name = "strClientCode")), @AttributeOverride(name = "strPOSCode", column = @Column(name = "strPOSCode")), @AttributeOverride(name = "strTransactionName", column = @Column(name = "strTransactionName")) })
	//Variable Declaration
	@Column(name = "strPOSCode")
    private String strPOSCode;

	@Column(name = "strClientCode")
	private String strClientCode;

	@Column(name = "strTransactionName")
	private String strTransactionName;
	
	@Column(name = "strSendSMSYN")
	private String strSendSMSYN;
	
	@Column(name = "longMobileNo")
	private String longMobileNo;
	
	@Column(name = "strUserCreated")
	private String strUserCreated;
	
	@Column(name = "strUserEdited")
	private String strUserEdited;
	
	@Column(name = "strDataPostFlag")
	private String strDataPostFlag;
	
	@Column(name = "dteDateCreated")
	private String dteDateCreated;
	
	@Column(name = "dteDateEdited")
	private String dteDateEdited;


	public String getStrPOSCode()
	{
		return strPOSCode;
	}

	public void setStrPOSCode(String strPOSCode)
	{
		this.strPOSCode = strPOSCode;
	}

	public String getStrClientCode()
	{
		return strClientCode;
	}

	public void setStrClientCode(String strClientCode)
	{
		this.strClientCode = strClientCode;
	}

	public String getStrTransactionName()
	{
		return strTransactionName;
	}

	public void setStrTransactionName(String strTransactionName)
	{
		this.strTransactionName = strTransactionName;
	}

	public String getStrSendSMSYN()
	{
		return strSendSMSYN;
	}

	public void setStrSendSMSYN(String strSendSMSYN)
	{
		this.strSendSMSYN = strSendSMSYN;
	}

	public String getLongMobileNo()
	{
		return longMobileNo;
	}

	public void setLongMobileNo(String longMobileNo)
	{
		this.longMobileNo = longMobileNo;
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

	public String getStrDataPostFlag()
	{
		return strDataPostFlag;
	}

	public void setStrDataPostFlag(String strDataPostFlag)
	{
		this.strDataPostFlag = strDataPostFlag;
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

}
