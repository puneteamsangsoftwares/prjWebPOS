package com.sanguine.webpos.model;

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
@Table(name = "tblzonemaster")
@IdClass(clsPOSZoneMasterModel_ID.class)
@NamedQueries({ @NamedQuery(name = "getALLZone", 
query = "select m.strZoneCode,m.strZoneName " 
		+ "from clsPOSZoneMasterModel m where m.strClientCode=:clientCode"),

		@NamedQuery(name = "getZoneMaster", query = "from clsPOSZoneMasterModel where strZoneCode=:zoneCode and strClientCode=:clientCode") })
public class clsPOSZoneMasterModel extends clsBaseModel implements Serializable
{
	private static final long serialVersionUID = 1L;

	public clsPOSZoneMasterModel()
	{
	}

	public clsPOSZoneMasterModel(clsPOSZoneMasterModel_ID objModelID)
	{
		strZoneCode = objModelID.getStrZoneCode();
		strClientCode = objModelID.getStrClientCode();

	}
	@Id
    @AttributeOverrides(
    { @AttributeOverride(name = "strZoneCode", column = @Column(name = "strZoneCode")), @AttributeOverride(name = "strClientCode", column = @Column(name = "strClientCode"))})
	@Column(name = "strZoneCode")
	private String strZoneCode;

	@Column(name = "strZoneName")
	private String strZoneName;

	@Column(name = "strUserCreated")
	private String strUserCreated;

	@Column(name = "dteDateCreated")
	private String dteDateCreated;

	@Column(name = "dteDateEdited")
	private String dteDateEdited;

	@Column(name = "strClientCode")
	private String strClientCode;

	@Column(name = "strDataPostFlag")
	private String strDataPostFlag;

	@Column(name = "strUserEdited")
	private String strUserEdited;
	public String getStrZoneCode()
	{
		return strZoneCode;
	}

	public void setStrZoneCode(String strZoneCode)
	{
		this.strZoneCode = strZoneCode;
	}

	public String getStrZoneName()
	{
		return strZoneName;
	}

	public void setStrZoneName(String strZoneName)
	{
		this.strZoneName = strZoneName;
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

	public String getDteDateEdited()
	{
		return dteDateEdited;
	}

	public void setDteDateEdited(String dteDateEdited)
	{
		this.dteDateEdited = dteDateEdited;
	}

	public String getStrClientCode()
	{
		return strClientCode;
	}

	public void setStrClientCode(String strClientCode)
	{
		this.strClientCode = strClientCode;
	}

	public String getStrDataPostFlag()
	{
		return strDataPostFlag;
	}

	public void setStrDataPostFlag(String strDataPostFlag)
	{
		this.strDataPostFlag = strDataPostFlag;
	}

	public static long getSerialversionuid()
	{
		return serialVersionUID;
	}

	public String getStrUserEdited()
	{
		return strUserEdited;
	}

	public void setStrUserEdited(String strUserEdited)
	{
		this.strUserEdited = strUserEdited;
	}

	
	
}
