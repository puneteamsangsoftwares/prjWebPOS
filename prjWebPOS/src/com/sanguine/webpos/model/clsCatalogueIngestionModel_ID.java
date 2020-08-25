package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
@Embeddable
@SuppressWarnings("serial")

public class clsCatalogueIngestionModel_ID implements Serializable{

//Variable Declaration
	/*@Column(name="categoriesId")
	private String categoriesId;
	
	@Column(name="ItemId")
	private String ItemId;
	
	@Column(name="optionGrpId")
	private String optionGrpId;
	
	@Column(name="optionId")
	private String optionId;
*/
	@Column(name="strClientCode")
	private String strClientCode;
	
	@Column(name="dteCurrentDate")
	private String dteCurrentDate;
	
	public clsCatalogueIngestionModel_ID()
	{
		
	}
	
	/*public clsCatalogueIngestionModel_ID(String categoriesId,String ItemId,String optionGrpId ,String optionId){
		this.categoriesId=categoriesId;
		this.ItemId=ItemId;
		this.optionGrpId=optionGrpId;
		this.optionId=optionId;
	}*/
	
	public clsCatalogueIngestionModel_ID(String strClientCode,String dteCurrentDate){
		this.strClientCode=strClientCode;
		this.dteCurrentDate=dteCurrentDate;
	}


//Setter-Getter Methods
	/*public String getCategoriesId()
	{
		return categoriesId;
	}
	public void setCategoriesId(String categoriesId)
	{
		this.categoriesId = categoriesId;
	}
	public String getItemId()
	{
		return ItemId;
	}
	public void setItemId(String itemId)
	{
		ItemId = itemId;
	}
	public String getOptionGrpId()
	{
		return optionGrpId;
	}
	public void setOptionGrpId(String optionGrpId)
	{
		this.optionGrpId = optionGrpId;
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

	public String getDteCurrentDate()
	{
		return dteCurrentDate;
	}

	public void setDteCurrentDate(String dteCurrentDate)
	{
		this.dteCurrentDate = dteCurrentDate;
	}

	//HashCode and Equals Funtions
	//@Override
	/*public boolean equals(Object obj) {
		clsCatalogueIngestionModel_ID objModelId = (clsCatalogueIngestionModel_ID)obj;
		if(this.categoriesId.equals(objModelId.getCategoriesId())&& this.ItemId.equals(objModelId.getItemId())&& this.optionGrpId.equals(objModelId.getOptionGrpId())&& this.optionId.equals(objModelId.getOptionId())){
			return true;
		}
		else{
			return false;
		}
	}

	@Override
	public int hashCode() {
		return this.categoriesId.hashCode()+this.ItemId.hashCode()+this.optionGrpId.hashCode()+this.optionId.hashCode();
	}*/

}
