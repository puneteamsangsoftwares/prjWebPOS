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
@Table(name="tblfeedbackmaster")
@IdClass(clsFeedBackMasterModel_ID.class)

@NamedQueries({ @NamedQuery(name = "getAllFeedbackMaster", 
query = "select m.strQuestionCode,m.strQuestion,m.strPOSCode,m.strOperational " 
		+ "from clsFeedBackMasterModel m where m.strClientCode=:clientCode "),

		@NamedQuery(name = "getFeedbackMaster", 
		query = "from clsFeedBackMasterModel where strQuestionCode=:strQuestionCode and strClientCode=:clientCode")})

public class clsFeedBackMasterModel extends clsBaseModel  implements Serializable{
	private static final long serialVersionUID = 1L;
	public clsFeedBackMasterModel(){}

	public clsFeedBackMasterModel(clsFeedBackMasterModel_ID objModelID){
		strQuestionCode = objModelID.getStrQuestionCode();
		strClientCode = objModelID.getStrClientCode();
	}

	@Id
	@AttributeOverrides({
		@AttributeOverride(name="strQuestionCode",column=@Column(name="strQuestionCode")),
@AttributeOverride(name="strClientCode",column=@Column(name="strClientCode"))
	})

//Variable Declaration
	@Column(name="strQuestionCode")
	private String strQuestionCode;

	@Column(name="strQuestion")
	private String strQuestion;


	@Column(name="strOperational")
	private String strOperational;

	@Column(name="strType")
	private String strType;

	@Column(name="intRating")
	private int intRating;

	@Column(name="intSequence")
	private int intSequence;

	@Column(name="strPOSCode")
	private String strPOSCode;

	@Column(name="strClientCode")
	private String strClientCode;

	@Column(name="strUserCreated")
	private String strUserCreated;

	@Column(name="strUserEdited")
	private String strUserEdited;

	@Column(name="strDateCreated")
	private String strDateCreated;

	@Column(name="strDateEdited")
	private String strDateEdited;

//Setter-Getter Methods

	public String getStrQuestion(){
		return strQuestion;
	}
	public void setStrQuestion(String strQuestion){
		this. strQuestion = (String) setDefaultValue( strQuestion, "NA");
	}

	public String getStrOperational(){
		return strOperational;
	}
	public void setStrOperational(String strOperational){
		this. strOperational = (String) setDefaultValue( strOperational, "NA");
	}

	public String getStrType(){
		return strType;
	}
	public void setStrType(String strType){
		this. strType = (String) setDefaultValue( strType, "NA");
	}

	public String getStrPOSCode(){
		return strPOSCode;
	}
	public void setStrPOSCode(String strPOSCode){
		this. strPOSCode = (String) setDefaultValue( strPOSCode, "NA");
	}

	public String getStrClientCode(){
		return strClientCode;
	}
	public void setStrClientCode(String strClientCode){
		this. strClientCode = (String) setDefaultValue( strClientCode, "NA");
	}

	public String getStrUserCreated(){
		return strUserCreated;
	}
	public void setStrUserCreated(String strUserCreated){
		this. strUserCreated = (String) setDefaultValue( strUserCreated, "NA");
	}

	public String getStrUserEdited(){
		return strUserEdited;
	}
	public void setStrUserEdited(String strUserEdited){
		this. strUserEdited = (String) setDefaultValue( strUserEdited, "NA");
	}

	public String getStrDateCreated(){
		return strDateCreated;
	}
	public void setStrDateCreated(String strDateCreated){
		this. strDateCreated = (String) setDefaultValue( strDateCreated, "NA");
	}

	public String getStrDateEdited(){
		return strDateEdited;
	}
	public void setStrDateEdited(String strDateEdited){
		this. strDateEdited = (String) setDefaultValue( strDateEdited, "NA");
	}


//Function to Set Default Values
	/*
	 * private Object setDefaultValue(Object value, Object defaultValue){ if(value
	 * !=null && (value instanceof String && value.toString().length()>0)){ return
	 * value; } else if(value !=null && (value instanceof Double &&
	 * value.toString().length()>0)){ return value; } else if(value !=null && (value
	 * instanceof Integer && value.toString().length()>0)){ return value; } else
	 * if(value !=null && (value instanceof Long && value.toString().length()>0)){
	 * return value; } else{ return defaultValue; } }
	 */
	public int getIntRating()
	{
		return intRating;
	}

	public void setIntRating(int intRating)
	{
		this.intRating = intRating;
	}

	public int getIntSequence()
	{
		return intSequence;
	}

	public void setIntSequence(int intSequence)
	{
		this.intSequence = intSequence;
	}

	public String getStrQuestionCode()
	{
		return strQuestionCode;
	}

	public void setStrQuestionCode(String strQuestionCode)
	{
		this.strQuestionCode = strQuestionCode;
	}



}
