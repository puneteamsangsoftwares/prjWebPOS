package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.IdClass;
import javax.persistence.Table;
import javax.persistence.Id;

import com.sanguine.base.model.clsBaseModel;

@Entity
@Table(name="tblonlinecatalogueingestion")
@IdClass(clsCatalogueIngestionModel_ID.class)

public class clsCatalogueIngestionModel extends clsBaseModel implements Serializable{
	private static final long serialVersionUID = 1L;
	public clsCatalogueIngestionModel(){}

	public clsCatalogueIngestionModel(clsCatalogueIngestionModel_ID objModelID){
		//categoriesId = objModelID.getCategoriesId();
		//ItemId = objModelID.getItemId();
		//optionGrpId = objModelID.getOptionGrpId();
		//optionId = objModelID.getOptionId();
		strClientCode = objModelID.getStrClientCode();
		dteCurrentDate=objModelID.getDteCurrentDate();
	}

	@Id
	@AttributeOverrides({
		//@AttributeOverride(name="categoriesId",column=@Column(name="categoriesId")),
//@AttributeOverride(name="ItemId",column=@Column(name="ItemId")),
//@AttributeOverride(name="optionGrpId",column=@Column(name="optionGrpId")),
//@AttributeOverride(name="optionId",column=@Column(name="optionId")),
@AttributeOverride(name="strClientCode",column=@Column(name="strClientCode")),
@AttributeOverride(name="dteCurrentDate",column=@Column(name="dteCurrentDate"))
	})

//Variable Declaration
	@Column(name="dteCurrentDate")
	private String dteCurrentDate;
	
	@Column(name="catgUpdate")
	private int catgUpdate;

	@Column(name="catgError")
	private int catgError;

	@Column(name="catgCreated")
	private int catgCreated;

	@Column(name="catgDeleted")
	private int catgDeleted;

	@Column(name="itemUpdate")
	private int itemUpdate;

	@Column(name="itemError")
	private int itemError;

	@Column(name="itemCreated")
	private int itemCreated;

	@Column(name="itemDeleted")
	private int itemDeleted;

	@Column(name="optionGrpUpdate")
	private int optionGrpUpdate;

	@Column(name="optionGrpError")
	private int optionGrpError;

	@Column(name="optionGrpDeleted")
	private int optionGrpDeleted;

	@Column(name="optionGrpCreated")
	private int optionGrpCreated;

	@Column(name="optionUpdate")
	private int optionUpdate;

	@Column(name="optionError")
	private int optionError;

	@Column(name="optionCreated")
	private int optionCreated;

	@Column(name="optionDeleted")
	private int optionDeleted;

	/*@Column(name="categoriesAct")
	private String categoriesAct;

	@Column(name="categoriesId")
	private String categoriesId;

	@Column(name="categoriesErr")
	private String categoriesErr;

	@Column(name="ItemAct")
	private String ItemAct;

	@Column(name="ItemErr")
	private String ItemErr;

	@Column(name="ItemId")
	private String ItemId;

	@Column(name="optionGrpAct")
	private String optionGrpAct;

	@Column(name="optionGrpErr")
	private String optionGrpErr;

	@Column(name="optionGrpId")
	private String optionGrpId;

	@Column(name="optionAct")
	private String optionAct;

	@Column(name="optionErr")
	private String optionErr;

	@Column(name="optionId")
	private String optionId;
*/	
	@Column(name="strClientCode")
	private String strClientCode;

//Setter-Getter Methods
	public String getDteCurrentDate()
	{
		return dteCurrentDate;
	}

	public void setDteCurrentDate(String dteCurrentDate)
	{
		this.dteCurrentDate = dteCurrentDate;
	}

	
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

	public int getOptionGrpDeleted()
	{
		return optionGrpDeleted;
	}

	public void setOptionGrpDeleted(int optionGrpDeleted)
	{
		this.optionGrpDeleted = optionGrpDeleted;
	}

	public int getOptionGrpCreated()
	{
		return optionGrpCreated;
	}

	public void setOptionGrpCreated(int optionGrpCreated)
	{
		this.optionGrpCreated = optionGrpCreated;
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

	/*public String getCategoriesAct()
	{
		return categoriesAct;
	}

	public void setCategoriesAct(String categoriesAct)
	{
		this.categoriesAct = categoriesAct;
	}

	public String getCategoriesId()
	{
		return categoriesId;
	}

	public void setCategoriesId(String categoriesId)
	{
		this.categoriesId = categoriesId;
	}

	public String getCategoriesErr()
	{
		return categoriesErr;
	}

	public void setCategoriesErr(String categoriesErr)
	{
		this.categoriesErr = categoriesErr;
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
	}*/

	public String getStrClientCode()
	{
		return strClientCode;
	}

	public void setStrClientCode(String strClientCode)
	{
		this.strClientCode = strClientCode;
	}

	public static long getSerialversionuid()
	{
		return serialVersionUID;
	}
	
	
	
//Function to Set Default Values
	/*private Object setDefaultValue(Object value, Object defaultValue){
		if(value !=null && (value instanceof String && value.toString().length()>0)){
			return value;
		}
		else if(value !=null && (value instanceof Double && value.toString().length()>0)){
			return value;
		}
		else if(value !=null && (value instanceof Integer && value.toString().length()>0)){
			return value;
		}
		else if(value !=null && (value instanceof Long && value.toString().length()>0)){
			return value;
		}
		else{
			return defaultValue;
		}
	}*/


}
