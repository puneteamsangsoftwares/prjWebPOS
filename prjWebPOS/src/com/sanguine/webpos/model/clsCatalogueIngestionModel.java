package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.Embeddable;

@Embeddable
public class clsCatalogueIngestionModel implements Serializable
{
	private int catgUpdate;
	private int catgError;
	private int catgCreated;
	private int catgDeleted;
	private int itemUpdate;
	private int itemError;
	private int itemCreated;
	private int itemDeleted;
	private int optionGrpUpdate;
	private int optionGrpError;
	private int optionGrpCreated;
	private int optionGrpDeleted;
	private int optionUpdate;
	private int optionError;
	private int optionCreated;
	private int optionDeleted;
	private String categoriesAct;
	private String categoriesErr;
	private String categoriesId;
	private String ItemAct;
	private String ItemErr;
	private String ItemId;
	private String optionGrpAct;
	private String optionGrpErr;
	private String optionGrpId;
	private String optionAct;
	private String optionErr;
	private String optionId;
	
	public int getCatgUpdate()
	{
		return catgUpdate;
	}
	public void setCatgUpdate(int catgUpdate)
	{
		this.catgUpdate = catgUpdate;
	}
	public int getCatgError()
	{
		return catgError;
	}
	public void setCatgError(int catgError)
	{
		this.catgError = catgError;
	}
	public int getCatgCreated()
	{
		return catgCreated;
	}
	public void setCatgCreated(int catgCreated)
	{
		this.catgCreated = catgCreated;
	}
	public int getCatgDeleted()
	{
		return catgDeleted;
	}
	public void setCatgDeleted(int catgDeleted)
	{
		this.catgDeleted = catgDeleted;
	}
	public int getItemUpdate()
	{
		return itemUpdate;
	}
	public void setItemUpdate(int itemUpdate)
	{
		this.itemUpdate = itemUpdate;
	}
	public int getItemError()
	{
		return itemError;
	}
	public void setItemError(int itemError)
	{
		this.itemError = itemError;
	}
	public int getItemCreated()
	{
		return itemCreated;
	}
	public void setItemCreated(int itemCreated)
	{
		this.itemCreated = itemCreated;
	}
	public int getItemDeleted()
	{
		return itemDeleted;
	}
	public void setItemDeleted(int itemDeleted)
	{
		this.itemDeleted = itemDeleted;
	}
	public int getOptionGrpUpdate()
	{
		return optionGrpUpdate;
	}
	public void setOptionGrpUpdate(int optionGrpUpdate)
	{
		this.optionGrpUpdate = optionGrpUpdate;
	}
	public int getOptionGrpError()
	{
		return optionGrpError;
	}
	public void setOptionGrpError(int optionGrpError)
	{
		this.optionGrpError = optionGrpError;
	}
	public int getOptionGrpCreated()
	{
		return optionGrpCreated;
	}
	public void setOptionGrpCreated(int optionGrpCreated)
	{
		this.optionGrpCreated = optionGrpCreated;
	}
	public int getOptionGrpDeleted()
	{
		return optionGrpDeleted;
	}
	public void setOptionGrpDeleted(int optionGrpDeleted)
	{
		this.optionGrpDeleted = optionGrpDeleted;
	}
	public int getOptionUpdate()
	{
		return optionUpdate;
	}
	public void setOptionUpdate(int optionUpdate)
	{
		this.optionUpdate = optionUpdate;
	}
	public int getOptionError()
	{
		return optionError;
	}
	public void setOptionError(int optionError)
	{
		this.optionError = optionError;
	}
	public int getOptionCreated()
	{
		return optionCreated;
	}
	public void setOptionCreated(int optionCreated)
	{
		this.optionCreated = optionCreated;
	}
	public int getOptionDeleted()
	{
		return optionDeleted;
	}
	public void setOptionDeleted(int optionDeleted)
	{
		this.optionDeleted = optionDeleted;
	}
	public String getCategoriesAct()
	{
		return categoriesAct;
	}
	public void setCategoriesAct(String categoriesAct)
	{
		this.categoriesAct = categoriesAct;
	}
	public String getCategoriesErr()
	{
		return categoriesErr;
	}
	public void setCategoriesErr(String categoriesErr)
	{
		this.categoriesErr = categoriesErr;
	}
	public String getCategoriesId()
	{
		return categoriesId;
	}
	public void setCategoriesId(String categoriesId)
	{
		this.categoriesId = categoriesId;
	}
	public String getItemAct()
	{
		return ItemAct;
	}
	public void setItemAct(String itemAct)
	{
		ItemAct = itemAct;
	}
	public String getItemErr()
	{
		return ItemErr;
	}
	public void setItemErr(String itemErr)
	{
		ItemErr = itemErr;
	}
	public String getItemId()
	{
		return ItemId;
	}
	public void setItemId(String itemId)
	{
		ItemId = itemId;
	}
	public String getOptionGrpAct()
	{
		return optionGrpAct;
	}
	public void setOptionGrpAct(String optionGrpAct)
	{
		this.optionGrpAct = optionGrpAct;
	}
	public String getOptionGrpErr()
	{
		return optionGrpErr;
	}
	public void setOptionGrpErr(String optionGrpErr)
	{
		this.optionGrpErr = optionGrpErr;
	}
	public String getOptionGrpId()
	{
		return optionGrpId;
	}
	public void setOptionGrpId(String optionGrpId)
	{
		this.optionGrpId = optionGrpId;
	}
	public String getOptionAct()
	{
		return optionAct;
	}
	public void setOptionAct(String optionAct)
	{
		this.optionAct = optionAct;
	}
	public String getOptionErr()
	{
		return optionErr;
	}
	public void setOptionErr(String optionErr)
	{
		this.optionErr = optionErr;
	}
	public String getOptionId()
	{
		return optionId;
	}
	public void setOptionId(String optionId)
	{
		this.optionId = optionId;
	}
	
}
