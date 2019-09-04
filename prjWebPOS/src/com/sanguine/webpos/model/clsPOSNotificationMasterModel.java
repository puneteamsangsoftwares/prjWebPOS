package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.Table;

import org.hibernate.annotations.NamedQueries;
import org.hibernate.annotations.NamedQuery;

import com.sanguine.base.model.clsBaseModel;
@Entity
@Table(name = "tblnotificationmaster")
@IdClass(clsPOSNotificationMasterModel_ID.class)

@NamedQueries(
		{ @NamedQuery (name="POSNotificationMaster" 
		, query="select m.strNotificationCode,m.strAreaCode,m.strPOSCode from clsPOSNotificationMasterModel m where m.strClientCode=:clientCode" ),


		@NamedQuery(name = "getNotification", query = "from clsPOSNotificationMasterModel where strNotificationCode=:strNotificationCode and strClientCode=:clientCode")}
	)

public class clsPOSNotificationMasterModel extends clsBaseModel implements Serializable
{
	private static final long	serialVersionUID	= 1L;

	public clsPOSNotificationMasterModel()
	{
	}
	public clsPOSNotificationMasterModel(clsPOSNotificationMasterModel_ID objModelID)
	{
		strNotificationCode = objModelID.getStrNotificationCode();
		strClientCode = objModelID.getStrClientCode();
	}
	
	 @Id
	    @AttributeOverrides(
	    { @AttributeOverride(name = "strNotificationCode", column = @Column(name = "strNotificationCode")), @AttributeOverride(name = "strClientCode", column = @Column(name = "strClientCode"))})
	@Column(name = "strNotificationCode")
	 
	 
	private String strNotificationCode;

	@Column(name = "strPOSCode")
	private String strPOSCode;

	@Column(name = "strAreaCode")
	private String strAreaCode;

	@Column(name = "dteFromDate")
	private String dteFromDate;

	@Column(name = "dteToDate")
	private String dteToDate;

	@Column(name = "strNotificationText")
	private String strNotificationText;

	@Column(name = "strNotificationType")
	private String strNotificationType;

	@Column(name = "strUserCreated")
	private String strUserCreated;

	@Column(name = "dteDateCreated")
	private String dteDateCreated;

	@Column(name = "strClientCode")
	private String strClientCode;

	public String getStrNotificationCode()
	{
		return strNotificationCode;
	}

	public void setStrNotificationCode(String strNotificationCode)
	{
		this.strNotificationCode = strNotificationCode;
	}

	public String getStrPOSCode()
	{
		return strPOSCode;
	}

	public void setStrPOSCode(String strPOSCode)
	{
		this.strPOSCode = strPOSCode;
	}

	public String getStrAreaCode()
	{
		return strAreaCode;
	}

	public void setStrAreaCode(String strAreaCode)
	{
		this.strAreaCode = strAreaCode;
	}

	public String getDteFromDate()
	{
		return dteFromDate;
	}

	public void setDteFromDate(String dteFromDate)
	{
		this.dteFromDate = dteFromDate;
	}

	public String getDteToDate()
	{
		return dteToDate;
	}

	public void setDteToDate(String dteToDate)
	{
		this.dteToDate = dteToDate;
	}

	public String getStrNotificationText()
	{
		return strNotificationText;
	}

	public void setStrNotificationText(String strNotificationText)
	{
		this.strNotificationText = strNotificationText;
	}

	public String getStrNotificationType()
	{
		return strNotificationType;
	}

	public void setStrNotificationType(String strNotificationType)
	{
		this.strNotificationType = strNotificationType;
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

	public String getStrClientCode()
	{
		return strClientCode;
	}

	public void setStrClientCode(String strClientCode)
	{
		this.strClientCode = strClientCode;
	}

}
