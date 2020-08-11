package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.Embeddable;

@Embeddable
public class clsStoreActionModel implements Serializable
{
	 private String strAction;
	 private String strPlatform;
	 private String strLocationRefId;
	 private String strStatus;
	 private String strRefernceId;
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
	public String getStrLocationRefId()
	{
		return strLocationRefId;
	}
	public void setStrLocationRefId(String strLocationRefId)
	{
		this.strLocationRefId = strLocationRefId;
	}
	public String getStrStatus()
	{
		return strStatus;
	}
	public void setStrStatus(String strStatus)
	{
		this.strStatus = strStatus;
	}
	public String getStrRefernceId()
	{
		return strRefernceId;
	}
	public void setStrRefernceId(String strRefernceId)
	{
		this.strRefernceId = strRefernceId;
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
