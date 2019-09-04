package com.sanguine.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sanguine.model.clsCompanyMasterModel;
import com.sanguine.model.clsTreeMasterModel;
import com.sanguine.model.clsUserLogsModel;




public interface clsGlobalFunctionsDao 
{

	public List funCheckName(String name, String strClientCode, String formName);


	public List funGetList(String sql, String queryType);
	
}
