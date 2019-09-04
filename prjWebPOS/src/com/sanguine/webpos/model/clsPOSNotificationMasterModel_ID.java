package com.sanguine.webpos.model;

import java.io.Serializable;

import javax.persistence.Column;

public class clsPOSNotificationMasterModel_ID implements Serializable
{
	
	public clsPOSNotificationMasterModel_ID()
	{
	}

	public clsPOSNotificationMasterModel_ID(String strNotificationCode, String strClientCode)
	{
		this.strNotificationCode = strNotificationCode;
		this.strClientCode = strClientCode;
	}

	//Variable Declaration
		@Column(name = "strNotificationCode")
		private String	strNotificationCode;

		@Column(name = "strClientCode")
		private String	strClientCode;

		public String getStrNotificationCode()
		{
			return strNotificationCode;
		}

		public void setStrNotificationCode(String strNotificationCode)
		{
			this.strNotificationCode = strNotificationCode;
		}

		public String getStrClientCode()
		{
			return strClientCode;
		}

		public void setStrClientCode(String strClientCode)
		{
			this.strClientCode = strClientCode;
		}
		
		
		
}
