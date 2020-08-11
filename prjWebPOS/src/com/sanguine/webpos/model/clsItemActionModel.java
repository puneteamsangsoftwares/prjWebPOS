package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.Embeddable;

@Embeddable
public class clsItemActionModel implements Serializable
{
	 private String strAction;
	 private String strPlatform;
	 private String strRefernceId;
	 private String strUpItemId;
	 private String strItemCode;
	 private String strItemStatus;
	
	 private String strUpLocationId;
	 private String strLocationCode;
	
	 private int ts_utc;
	 public String getStrAction()
	{
		return strAction;
	}

	public void setStrAction(String strAction)
	{
		this.strAction = strAction;
	}

	public String getStrPlatform()
	{
		return strPlatform;
	}

	public void setStrPlatform(String strPlatform)
	{
		this.strPlatform = strPlatform;
	}

	public String getStrRefernceId()
	{
		return strRefernceId;
	}

	public void setStrRefernceId(String strRefernceId)
	{
		this.strRefernceId = strRefernceId;
	}

	public String getStrUpItemId()
	{
		return strUpItemId;
	}

	public void setStrUpItemId(String strUpItemId)
	{
		this.strUpItemId = strUpItemId;
	}

	public String getStrItemCode()
	{
		return strItemCode;
	}

	public void setStrItemCode(String strItemCode)
	{
		this.strItemCode = strItemCode;
	}

	public String getStrItemStatus()
	{
		return strItemStatus;
	}

	public void setStrItemStatus(String strItemStatus)
	{
		this.strItemStatus = strItemStatus;
	}

	public String getStrUpLocationId()
	{
		return strUpLocationId;
	}

	public void setStrUpLocationId(String strUpLocationId)
	{
		this.strUpLocationId = strUpLocationId;
	}

	public String getStrLocationCode()
	{
		return strLocationCode;
	}

	public void setStrLocationCode(String strLocationCode)
	{
		this.strLocationCode = strLocationCode;
	}

	public int getTs_utc()
	{
		return ts_utc;
	}

	public void setTs_utc(int ts_utc)
	{
		this.ts_utc = ts_utc;
	}

	 
}
