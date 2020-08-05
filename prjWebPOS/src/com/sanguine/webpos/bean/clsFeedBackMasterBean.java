package com.sanguine.webpos.bean;

public class clsFeedBackMasterBean{
//Variable Declaration
	private String strQuestionCode;

	private String strQuestion;

	private String strAnswer;

	private String strOperational;

	private String strType;

	private int intRating;
	
	private int intSequence;

	private String strPOSCode;

	private String strClientCode;

	private String strUserCreated;

	private String strUserEdited;

	private String strDateCreated;

	private String strDateEdited;

//Setter-Getter Methods

	public String getStrQuestion(){
		return strQuestion;
	}
	public void setStrQuestion(String strQuestion){
		this.strQuestion=strQuestion;
	}

	public String getStrAnswer(){
		return strAnswer;
	}
	public void setStrAnswer(String strAnswer){
		this.strAnswer=strAnswer;
	}

	public String getStrOperational(){
		return strOperational;
	}
	public void setStrOperational(String strOperational){
		this.strOperational=strOperational;
	}

	public String getStrType(){
		return strType;
	}
	public void setStrType(String strType){
		this.strType=strType;
	}

	public String getStrPOSCode(){
		return strPOSCode;
	}
	public void setStrPOSCode(String strPOSCode){
		this.strPOSCode=strPOSCode;
	}

	public String getStrClientCode(){
		return strClientCode;
	}
	public void setStrClientCode(String strClientCode){
		this.strClientCode=strClientCode;
	}

	public String getStrUserCreated(){
		return strUserCreated;
	}
	public void setStrUserCreated(String strUserCreated){
		this.strUserCreated=strUserCreated;
	}

	public String getStrUserEdited(){
		return strUserEdited;
	}
	public void setStrUserEdited(String strUserEdited){
		this.strUserEdited=strUserEdited;
	}

	public String getStrDateCreated(){
		return strDateCreated;
	}
	public void setStrDateCreated(String strDateCreated){
		this.strDateCreated=strDateCreated;
	}

	public String getStrDateEdited(){
		return strDateEdited;
	}
	public void setStrDateEdited(String strDateEdited){
		this.strDateEdited=strDateEdited;
	}
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
