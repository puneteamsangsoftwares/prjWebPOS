package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

import com.sanguine.base.model.clsBaseModel;

@Entity
@Table(name = "tblfactorymaster")
@IdClass(clsFactoryMasterModel_ID.class)
@NamedQueries({ @NamedQuery(name = "getAllFactoryMaster", query = "select m.strFactoryCode,m.strFactoryName,m.strUserCreated,m.strUserEdited,m.dteDateCreated " + "from clsFactoryMasterModel m where m.strClientCode=:clientCode "),

@NamedQuery(name = "getFactoryMaster", query = "from clsFactoryMasterModel where strFactoryCode=:factoryCode and strClientCode=:clientCode") })
public class clsFactoryMasterModel extends clsBaseModel implements Serializable
{
	private static final long serialVersionUID = 1L;

	public clsFactoryMasterModel()
	{
	}

	public clsFactoryMasterModel(clsFactoryMasterModel_ID objModelID)
	{
		strFactoryCode = objModelID.getStrFactoryCode();
		strClientCode = objModelID.getStrClientCode();

	}

	@Id
	@AttributeOverrides({ @AttributeOverride(name = "strFactoryCode", column = @Column(name = "strFactoryCode")), @AttributeOverride(name = "strClientCode", column = @Column(name = "strClientCode")) })
	@Column(name = "strFactoryCode")
	private String strFactoryCode;

	@Column(name = "strFactoryName")
	private String strFactoryName;

	@Column(name = "strUserCreated")
	private String strUserCreated;

	@Column(name = "strUserEdited")
	private String strUserEdited;

	@Column(name = "dteDateCreated")
	private String dteDateCreated;

	@Column(name = "dteDateEdited")
	private String dteDateEdited;

	@Column(name = "strClientCode")
	private String strClientCode;

	@Column(name = "strDataPostFlag")
	private String strDataPostFlag;

	public String getStrFactoryCode()
	{
		return strFactoryCode;
	}

	public void setStrFactoryCode(String strFactoryCode)
	{
		this.strFactoryCode = strFactoryCode;
	}

	public String getStrFactoryName()
	{
		return strFactoryName;
	}

	public void setStrFactoryName(String strFactoryName)
	{
		this.strFactoryName = strFactoryName;
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

}
