package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.Embeddable;

@Embeddable
public class clsOnlineOrderAddUpdateStoreModel implements Serializable
{
 private int updatedStore;
 private int errors;
 private int createdStore;
 
private String error;
 private String strId;
 private String strAction;
 
 public String getStrId()
{
	return strId;
}
public void setStrId(String strId)
{
	this.strId = strId;
}
public String getStrAction()
{
	return strAction;
}
public void setStrAction(String strAction)
{
	this.strAction = strAction;
}

public String getError()
{
	return error;
}
public void setError(String error)
{
	this.error = error;
}

public int getUpdatedStore()
{
	return updatedStore;
}
public void setUpdatedStore(int updatedStore)
{
	this.updatedStore = updatedStore;
}
public int getErrors()
{
	return errors;
}
public void setErrors(int errors)
{
	this.errors = errors;
}
public int getCreatedStore()
{
	return createdStore;
}
public void setCreatedStore(int createdStore)
{
	this.createdStore = createdStore;
}

 
}

