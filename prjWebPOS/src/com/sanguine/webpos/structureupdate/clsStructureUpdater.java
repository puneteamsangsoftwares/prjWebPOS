package com.sanguine.webpos.structureupdate;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.hibernate.Query;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;

import com.POSGlobal.view.frmOkPopUp;
import com.sanguine.service.clsGlobalFunctionsService;
import com.sanguine.webpos.util.clsPOSUtilityController;



@Controller
@Transactional(value = "webPOSTransactionManager")
public class clsStructureUpdater
{
	
	@Autowired
	private SessionFactory webPOSSessionFactory;

	 @Autowired
	 private clsPOSUtilityController objUtilityController;
	 
	 @Autowired
	 private clsGlobalFunctionsService objGlobalFunctionsService; 
	 
	    private Map<String, List<String>> mapStructureUpdater;
	    private StringBuilder queryBuilder;
	    private int recursionCount = 0;
	    private clsStructureUpdater objStructureUpdater;
	    private Map<String, Method> mapDeclaredMethods;
	    private clsFillDatabaseTablesStructureUpdate objFillDatabaseTablesStructureUpdate;
	    private clsFillFormsTableStructureUpdate objFillFormsTableStructureUpdate;
	    private clsFillIMasterStatusTableStructureUpdate objFillMasterStatusTableStructureUpdate;
	    private clsFillInternalTableStructureUpdate objFillInternalTableStructureUpdate;
	    private clsFillSuperUserTableStructureUpdate objFillSuperUserTableStructureUpdate;
	    private clsFillViewTableStructureUpdate objFillViewTableStructureUpdate;
	    private String gClientCode="",gPOSVerion="",gUserCode="";
	 
	    String posDate ="";// request.getSession().getAttribute("gPOSDate").toString().split(" ")[0];
	    /**
	     * This is at constructor level description.
	     *
	     * @author Vinayak
	     */
	    public void funStructureUpdater(HttpServletRequest req)
	    {
	    	
		objStructureUpdater = this;
		mapDeclaredMethods = new HashMap<>();
		
		gClientCode=req.getSession().getAttribute("gClientCode").toString();
		gUserCode= req.getSession().getAttribute("gUserCode").toString();
		gPOSVerion=req.getSession().getAttribute("gPOSVerion").toString();
		posDate =req.getSession().getAttribute("gPOSDate").toString();
		
		Method[] declaredMethods = this.getClass().getDeclaredMethods();
		for (Method method : declaredMethods)
		{
		    String methodName = method.getName();
		    int parameterCount = method.getParameterCount();

		    mapDeclaredMethods.put(methodName, method);
		}

		mapStructureUpdater = new HashMap<>();
		queryBuilder = new StringBuilder();

		objFillDatabaseTablesStructureUpdate = new clsFillDatabaseTablesStructureUpdate(mapStructureUpdater,gClientCode);
		objFillFormsTableStructureUpdate = new clsFillFormsTableStructureUpdate(mapStructureUpdater,gPOSVerion);
		objFillMasterStatusTableStructureUpdate = new clsFillIMasterStatusTableStructureUpdate(mapStructureUpdater);
		objFillInternalTableStructureUpdate = new clsFillInternalTableStructureUpdate(mapStructureUpdater);
		objFillSuperUserTableStructureUpdate = new clsFillSuperUserTableStructureUpdate(mapStructureUpdater);
		objFillViewTableStructureUpdate = new clsFillViewTableStructureUpdate(mapStructureUpdater);

		//fill structure updater Map
		mapStructureUpdater.put("dbStructure", new ArrayList<String>());
		mapStructureUpdater.put("tblStructure", new ArrayList<String>());
		mapStructureUpdater.put("frmStructure", new ArrayList<String>());
		mapStructureUpdater.put("superUserStructure", new ArrayList<String>());
		mapStructureUpdater.put("userStructure", new ArrayList<String>());
		mapStructureUpdater.put("viewStructure", new ArrayList<String>());
		mapStructureUpdater.put("internalTableStructure", new ArrayList<String>());
		mapStructureUpdater.put("masterTableStatusStructure", new ArrayList<String>());

		//.......filling structure update map for list of queries
		funFillStructureUpdaterMap();

	    }

	    /**
	     * This is at function level description.
	     *
	     * @author Ajim
	     */
	    public int structup()
	    {
		try
		{

		    recursionCount++;

		    try
		    {

			queryBuilder.setLength(0);
			queryBuilder.append("select * from tblstructureupdate ");
			Query rs = webPOSSessionFactory.getCurrentSession().createSQLQuery(queryBuilder.toString());
            List list = rs.list();
            if (list!=null && list.size()>0)
            {
            	for(int k=0;k<list.size();k++){
            		Object[] obj=(Object[])list.get(k);
            		

    			    String key = obj[0].toString();//rsStructureUpdate.getString(1);
    			    int lastUpdatedQueryIndex =Integer.parseInt( obj[2].toString());

    			    if (mapStructureUpdater.containsKey(key))
    			    {
    				List<String> listOfQueries = mapStructureUpdater.get(key);
    				int noOfQueriesInList = listOfQueries.size();

    				if (noOfQueriesInList == 0)
    				{
    				    continue;
    				}
    				else if (lastUpdatedQueryIndex > noOfQueriesInList)
    				{
    				    throw new Exception("Previous Structure Update not done properly for key:" + key);
    				}
    				else
    				{
    				    //need to execute all queries 
    				    if (key.equalsIgnoreCase("internalTableStructure"))//|| key.equalsIgnoreCase("masterTableStatusStructure")
    				    {
    					for (String sql : listOfQueries)
    					{
    					    if (sql.startsWith("fun") && mapDeclaredMethods.containsKey(sql))
    					    {
    						Method method = mapDeclaredMethods.get(sql);
    						method.invoke(objStructureUpdater,gClientCode);
    					    }
    					    else
    					    {
    						funExecuteUpdateQuery(sql);
    					    }
    					}
    				    }
    				    else if (key.equalsIgnoreCase("masterTableStatusStructure"))//|| key.equalsIgnoreCase("masterTableStatusStructure")
    				    {
	    					for (String sql : listOfQueries)
	    					{
	    					    if (sql.startsWith("fun") && mapDeclaredMethods.containsKey(sql))
	    					    {
		    						Method method = mapDeclaredMethods.get(sql);
		    						method.invoke(objStructureUpdater,gClientCode);
	    					    }
	    					    else
	    					    {
	    					    	funExecuteUpdateQuery(sql);
	    					    }
	    					}
    				    }
    				    else
    				    {
    					for (int queryNo = lastUpdatedQueryIndex; queryNo < noOfQueriesInList; queryNo++)
    					{
    					    queryBuilder.setLength(0);
    					    queryBuilder.append(listOfQueries.get(queryNo));
    					    if (queryBuilder.toString().startsWith("fun") && mapDeclaredMethods.containsKey(queryBuilder.toString()))
    					    {
    						System.out.println(queryBuilder.toString());
    						Method method = mapDeclaredMethods.get(queryBuilder.toString());
    						method.invoke(objStructureUpdater);
    					    }
    					    else
    					    {
    						System.out.println(queryNo +" "+queryBuilder.toString());
    						funExecuteUpdateQuery(queryBuilder.toString());
    					    }
    					}
    				    }

    				    if (key.equalsIgnoreCase("frmStructure"))
    				    {
    					noOfQueriesInList=8;
    				    }

    				    //update, structure update table for new updates
    				    queryBuilder.setLength(0);
    				    queryBuilder.append("update  tblstructureupdate "
    					    + "set intQueryNo='" + noOfQueriesInList + "' "
    					    + ",strUserEdited='" + gUserCode + "' "
    					    + ",dteDateEdited='" + objUtilityController.getCurrentDateTime() + "' "
    					    + "where strStructureCode='" + key + "' ");
    				    funExecuteUpdateQuery(queryBuilder.toString());

    				}
    			    }
    			    else
    			    {
    				throw new Exception("Structure Update Map does not have this key:" + key);
    			    }
    			
            	}
            }else{
			    funFillStructureUpdateTable();
			}
			

			//JOptionPane.showMessageDialog(null, "Update Successfully");                      
//			frmOkPopUp objOkPopUp = new frmOkPopUp(null, "Updated Successfully", "Success!!", 2);
	//		objOkPopUp.setVisible(true);

		    }
		    catch (Exception e)
		    {
			e.printStackTrace();
			if (recursionCount < 3)
			{
			    queryBuilder.setLength(0);
			    queryBuilder.append("CREATE TABLE if not exists `tblStructureUpdate` ( "
				    + "`strStructureCode` VARCHAR(50) NOT NULL, "
				    + "`strStructureName` VARCHAR(100) NOT NULL, "
				    + "`intQueryNo` INT(11) NOT NULL DEFAULT '0', "
				    + "`strClientCode` VARCHAR(11) NOT NULL DEFAULT '', "
				    + "`strUserCreated` VARCHAR(50) NOT NULL, "
				    + "`strUserEdited` VARCHAR(50) NOT NULL, "
				    + "`dteDateCreated` DATETIME NOT NULL, "
				    + "`dteDateEdited` DATETIME NOT NULL, "
				    + "`strDataPostFlag` VARCHAR(1) NOT NULL DEFAULT 'N', "
				    + "PRIMARY KEY (`strStructureCode`, `strClientCode`), "
				    + "INDEX `intStructureCode` (`strStructureCode`) "
				    + ") "
				    + "COLLATE='utf8_general_ci' "
				    + "ENGINE=InnoDB "
				    + "; ");
			    funExecuteUpdateQuery(queryBuilder.toString());

			    queryBuilder.setLength(0);
			    queryBuilder.append("select count(*) from tblstructureupdate ");
			    Query rs = webPOSSessionFactory.getCurrentSession().createSQLQuery(queryBuilder.toString());
	            List list = rs.list();
	            if (list!=null && list.size()>0)
	            {
	            	int countData = Integer.parseInt(list.get(0).toString());
	            	if (countData == 0)
					{
					    queryBuilder.setLength(0);
					    queryBuilder.append("INSERT INTO  tblstructureupdate  "
						    + "(`strStructureCode`, `strStructureName`,`intQueryNo`, `strClientCode`, `strUserCreated`, `strUserEdited`, `dteDateCreated`, `dteDateEdited`,`strDataPostFlag`)  "
						    + "VALUES  "
						    + "('dbStructure', 'Database Level Structure Update', 0,'" + gClientCode + "', '" + gUserCode + "', '" + gUserCode + "', '" + objUtilityController.getCurrentDateTime() + "', '" + objUtilityController.getCurrentDateTime() + "','N') "
						    + ",('tblStructure', 'Table Level Structure Update', 0,'" + gClientCode + "', '" + gUserCode + "', '" + gUserCode + "', '" + objUtilityController.getCurrentDateTime() + "', '" + objUtilityController.getCurrentDateTime() + "','N') "
						    + ",('frmStructure', 'Forms Structure Update', 0,'" + gClientCode + "', '" + gUserCode + "', '" + gUserCode + "', '" + objUtilityController.getCurrentDateTime() + "', '" + objUtilityController.getCurrentDateTime() + "','N') "
						    + ",('superUserStructure', 'Super User Entry Structure Update', 0,'" + gClientCode + "', '" + gUserCode + "', '" + gUserCode + "', '" + objUtilityController.getCurrentDateTime() + "', '" + objUtilityController.getCurrentDateTime() + "','N') "
						    + ",('userStructure', 'Normal User Entry Structure Update', 0,'" + gClientCode + "', '" + gUserCode + "', '" + gUserCode + "', '" + objUtilityController.getCurrentDateTime() + "', '" + objUtilityController.getCurrentDateTime() + "','N') "
						    + ",('viewStructure', 'Table View  Structure Update', 0,'" + gClientCode + "', '" + gUserCode + "', '" + gUserCode + "', '" + objUtilityController.getCurrentDateTime() + "', '" + objUtilityController.getCurrentDateTime() + "','N') "
						    + ",('internalTableStructure', 'Internal Table Structure Update', 0,'" + gClientCode + "', '" + gUserCode + "', '" + gUserCode + "', '" + objUtilityController.getCurrentDateTime() + "', '" + objUtilityController.getCurrentDateTime() + "','N') "
						    + ",('masterTableStatusStructure', 'Master Forms Table Structure Update', 0,'" + gClientCode + "', '" + gUserCode + "', '" + gUserCode + "', '" + objUtilityController.getCurrentDateTime() + "', '" + objUtilityController.getCurrentDateTime() + "','N') ");
					    funExecuteUpdateQuery(queryBuilder.toString());
					}
					else
					{
					    //already have data
					}

				    }
				    //rsCountData.close();

				    //call again structure update
				    structup();

	            }
				else
				{
				    throw new Exception("Recursion while in Structure Update.", e);
				}
		    }
		}
		catch (Exception e)
		{
		    e.printStackTrace();
		}

		return 0;
	    }
	    
	    private void funFillStructureUpdateTable(){
			try{
			    queryBuilder.setLength(0);
			    queryBuilder.append("select count(*) from tblstructureupdate ");
			    Query rs = webPOSSessionFactory.getCurrentSession().createSQLQuery(queryBuilder.toString());
	            List list = rs.list();
	            if (list!=null && list.size()>0)
	            {
	            	int countData = Integer.parseInt(list.get(0).toString());
	            	if (countData == 0)
					{
					    queryBuilder.setLength(0);
					    queryBuilder.append("INSERT INTO  tblstructureupdate  "
						    + "(`strStructureCode`, `strStructureName`,`intQueryNo`, `strClientCode`, `strUserCreated`, `strUserEdited`, `dteDateCreated`, `dteDateEdited`,`strDataPostFlag`)  "
						    + "VALUES  "
						    + "('dbStructure', 'Database Level Structure Update', 0,'" +  gClientCode + "', '" +  gUserCode + "', '" +  gUserCode + "', '" + objUtilityController.getCurrentDateTime() + "', '" + objUtilityController.getCurrentDateTime() + "','N') "
						    + ",('tblStructure', 'Table Level Structure Update', 0,'" +  gClientCode + "', '" +  gUserCode + "', '" +  gUserCode + "', '" + objUtilityController.getCurrentDateTime() + "', '" + objUtilityController.getCurrentDateTime() + "','N') "
						    + ",('frmStructure', 'Forms Structure Update', 0,'" +  gClientCode + "', '" +  gUserCode + "', '" +  gUserCode + "', '" + objUtilityController.getCurrentDateTime() + "', '" + objUtilityController.getCurrentDateTime() + "','N') "
						    + ",('superUserStructure', 'Super User Entry Structure Update', 0,'" +  gClientCode + "', '" +  gUserCode + "', '" +  gUserCode + "', '" + objUtilityController.getCurrentDateTime() + "', '" + objUtilityController.getCurrentDateTime() + "','N') "
						    + ",('userStructure', 'Normal User Entry Structure Update', 0,'" +  gClientCode + "', '" +  gUserCode + "', '" +  gUserCode + "', '" + objUtilityController.getCurrentDateTime() + "', '" + objUtilityController.getCurrentDateTime() + "','N') "
						    + ",('viewStructure', 'Table View  Structure Update', 0,'" +  gClientCode + "', '" +  gUserCode + "', '" +  gUserCode + "', '" + objUtilityController.getCurrentDateTime() + "', '" + objUtilityController.getCurrentDateTime() + "','N') "
						    + ",('internalTableStructure', 'Internal Table Structure Update', 0,'" +  gClientCode + "', '" +  gUserCode + "', '" +  gUserCode + "', '" + objUtilityController.getCurrentDateTime() + "', '" + objUtilityController.getCurrentDateTime() + "','N') "
						    + ",('masterTableStatusStructure', 'Master Forms Table Structure Update', 0,'" +  gClientCode + "', '" +  gUserCode + "', '" +  gUserCode + "', '" + objUtilityController.getCurrentDateTime() + "', '" + objUtilityController.getCurrentDateTime() + "','N') ");
					    funExecuteUpdateQuery(queryBuilder.toString());
					     structup();
					}
	            }
			   		   
			}catch(Exception e){
				e.printStackTrace();
			}
		
	    }
	  
	    private int funFillStructureUpdaterMap()
	    {
		try
		{
		    //main table structure update
		    objFillDatabaseTablesStructureUpdate.funFillDatabaseTablesStructureUpdate();
		    //tblForms
		    objFillFormsTableStructureUpdate.funFillFormsTableStructureUpdate();
		    //tblSuperUserDtl
		    objFillSuperUserTableStructureUpdate.funFillSuperUserTableStructureUpdate();
		    //views
	//deleted All views	   
//		    objFillViewTableStructureUpdate.funFillViewTableStructureUpdate();
		    
	//tblInternal
		    objFillInternalTableStructureUpdate.funFillInternalTableStructureUpdate();
		    //tblMasterStatus
		    objFillMasterStatusTableStructureUpdate.funFillIMasterStatusTableStructureUpdate();

		}
		catch (Exception s)
		{
		    frmOkPopUp objOkPopUp = new frmOkPopUp(null, "Error In Strucure Update", "Error!!", 2);
		    objOkPopUp.setVisible(true);

		    s.printStackTrace();
		}
		finally
		{
		    return 0;
		}
	    }

	    private void funCheckInternalTable(String strClientCode)
	    {
			funCheckMasterEntry("KOTNo",strClientCode);
			funCheckMasterEntry("stockInNo",strClientCode);
			funCheckMasterEntry("stockOutNo",strClientCode);
			funCheckMasterEntry("Area",strClientCode);
			funCheckMasterEntry("GiftVoucher",strClientCode);
			funCheckMasterEntry("Counter",strClientCode);
			funCheckMasterEntry("custtype",strClientCode);
			funCheckMasterEntry("Recipe",strClientCode);
			funCheckMasterEntry("LoyaltyCode",strClientCode);
			funCheckMasterEntry("Physicalstock",strClientCode);
			funCheckMasterEntry("Production",strClientCode);
			funCheckMasterEntry("AdvOrderType",strClientCode);
			funCheckMasterEntry("DebitCard",strClientCode);
			funCheckMasterEntry("DelBoyCategory",strClientCode);
			funCheckMasterEntry("Zone",strClientCode);
			funCheckMasterEntry("AdvReceipt",strClientCode);
			funCheckMasterEntry("RechargeNo",strClientCode);
			funCheckMasterEntry("RedeemNo",strClientCode);
			funCheckMasterEntry("CardNo",strClientCode);
			funCheckMasterEntry("MIReceiptNo",strClientCode);
			funCheckMasterEntry("PlaceOrder",strClientCode);
			funCheckMasterEntry("CreditReceipt",strClientCode);
			funCheckMasterEntry("PromoGroup",strClientCode);
			funCheckMasterEntry("LiquorBillCustomer",strClientCode);
			funCheckMasterEntry("OrderNo",strClientCode);
			funCheckMasterEntry("PlayZonePricing",strClientCode);

	    }

	    private int funCheckMasterEntry(String masterName,String strClientCode)
	    {

			try
			{
			    String sql = "select count(*) from tblinternal "
				    + "where strTransactionType='" + masterName + "' and strClientCode='"+strClientCode+"' ";
			    Query rs = webPOSSessionFactory.getCurrentSession().createSQLQuery(sql);
	            List list = rs.list();
	            if (list!=null && list.size()>0)
	            {
	            	int countData = Integer.parseInt(list.get(0).toString());
	            	if (countData == 0)
					{
					    String sql_Insert = "insert into tblinternal(strTransactionType,dblLastNo,strClientCode) "
						    + "values('" + masterName + "',0,'"+strClientCode+"')";
					    funExecuteUpdateQuery(sql_Insert);
					    
					    if (gClientCode.equals("024.001"))
					    {
						
					    	 funExecuteUpdateQuery("update tblinternal set dblLastNo=9856 where strTransactionType='AdvReceipt' and strClientCode='"+strClientCode+"' ");
					    }
					}
	            }
			}
			catch (Exception ex)
			{
			    ex.printStackTrace();
			}
		return 1;
	    }

	    private void funCheckMasterTableStatus(String strClinetCode)
	    {
		funCheckMasterTableEntry("Area",strClinetCode);
		funCheckMasterTableEntry("AreaWiseDC",strClinetCode);
		funCheckMasterTableEntry("Building",strClinetCode);
		funCheckMasterTableEntry("Counter",strClinetCode);
		funCheckMasterTableEntry("MenuItemPricing",strClinetCode);
		funCheckMasterTableEntry("MenuItem",strClinetCode);
		funCheckMasterTableEntry("Menu",strClinetCode);
		funCheckMasterTableEntry("Modifier",strClinetCode);
		funCheckMasterTableEntry("Group",strClinetCode);
		funCheckMasterTableEntry("SubGroup",strClinetCode);
		funCheckMasterTableEntry("CostCenter",strClinetCode);
		funCheckMasterTableEntry("Settlement",strClinetCode);
		funCheckMasterTableEntry("Tax",strClinetCode);
		funCheckMasterTableEntry("Table",strClinetCode);
		funCheckMasterTableEntry("Waiter",strClinetCode);
		funCheckMasterTableEntry("Reason",strClinetCode);
		funCheckMasterTableEntry("Customer",strClinetCode);
		funCheckMasterTableEntry("CustomerType",strClinetCode);
		funCheckMasterTableEntry("DeliveryBoy",strClinetCode);
		funCheckMasterTableEntry("DelBoyCat",strClinetCode);
		funCheckMasterTableEntry("AdvanceOrderType",strClinetCode);
		funCheckMasterTableEntry("User",strClinetCode);
		funCheckMasterTableEntry("Promotion",strClinetCode);
		funCheckMasterTableEntry("Order",strClinetCode);
		funCheckMasterTableEntry("Characteristics",strClinetCode);
		funCheckMasterTableEntry("Factory",strClinetCode);
		funCheckMasterTableEntry("PosWiseItemWiseIncentive",strClinetCode);
		funCheckMasterTableEntry("PromoGroup",strClinetCode);
		funCheckMasterTableEntry("DiscountMaster",strClinetCode);
		funCheckMasterTableEntry("BillSeries",strClinetCode);
		//funCheckMasterTableEntry("POS",strClinetCode);
		funCheckMasterTableEntry("SubMenuHead",strClinetCode);
	    }

	    private int funCheckMasterTableEntry(String tableName,String strClinetCode)
	    {
		try
		{
		    String sql = "select count(*) from tblmasteroperationstatus "
			    + " where strTableName='" + tableName + "' and strClientCode='"+strClinetCode+"' ";
		    Query rs = webPOSSessionFactory.getCurrentSession().createSQLQuery(sql);
            List list = rs.list();
            if (list!=null && list.size()>0)
            {
            	int countData = Integer.parseInt(list.get(0).toString());
            	if (countData == 0)
    			{
    			    if(null!=posDate){
    				String sqlInsert = "insert into tblmasteroperationstatus(strTableName,dteDateEdited,strClientCode) "
    				    + "values('" + tableName + "','" + posDate + "','" + strClinetCode + "')";
    				 funExecuteUpdateQuery(sqlInsert);
    			    }
    			}
            }
		  
		}
		catch (Exception ex)
		{
		    ex.printStackTrace();
		}
		return 1;
	    }

	    private String funGenerateAreaCode(String strClientCode)
	    {
		String areaCode = "";
		try
		{
		    String sql_Area = "select count(dblLastNo) from tblinternal where strTransactionType='Area' and strClientCode='"+strClientCode+"' ";
		    Query rs = webPOSSessionFactory.getCurrentSession().createSQLQuery(sql_Area);
            List list = rs.list();
            if (list!=null && list.size()>0)
            {
            	int areaCodeCnt = Integer.parseInt(list.get(0).toString());
            	 if (areaCodeCnt > 0)
	     		 {
	     			sql_Area = "select dblLastNo from tblinternal where strTransactionType='Area' and strClientCode='"+strClientCode+"' ";
	     			
	     			rs = webPOSSessionFactory.getCurrentSession().createSQLQuery(sql_Area);
	                List list1 = rs.list();
	                if (list1!=null && list1.size()>0)
	                {
	                	long code = Integer.parseInt(list1.get(0).toString());
	                	code = code + 1;
		     			areaCode = "A" + String.format("%03d", code);
		     			sql_Area = "update tblinternal set dblLastNo='" + code + "' where strTransactionType='Area' and strClientCode='"+strClientCode+"' ";
		     			funExecuteUpdateQuery(sql_Area);
	                }
	            	
	     		 }
     		    else
     		    {
	     			areaCode = "A001";
	     			sql_Area = "insert into tblinternal values('Area'," + 1 + ",'"+strClientCode+"')";
	     			funExecuteUpdateQuery(sql_Area);
     		    }
            }
            
		   
		    //System.out.println("A Code="+areaCode);
		}
		catch (Exception e)
		{
		    e.printStackTrace();
		}
		return areaCode;
	    }

	    private void funCreateAreaForAll() throws Exception
	    {
	    	String strClientCode="";
	    	List listClient= webPOSSessionFactory.getCurrentSession().createSQLQuery("select distinct(strClientCode) from tblsetup ").list();
            if (listClient!=null && listClient.size()>0)
            {
            	for(int k=0;k<listClient.size();k++)
            	{
            		strClientCode=listClient.get(k).toString();
            		String sql = "select count(strAreaCode) from tblareamaster where strAreaName='All' and strClientCode='"+strClientCode+"' ";
        			Query rs = webPOSSessionFactory.getCurrentSession().createSQLQuery(sql);
                    List list = rs.list();
                    if (list!=null && list.size()>0)
                    {
                    	int areaCodeCnt = Integer.parseInt(list.get(0).toString());
                    	if (areaCodeCnt == 0)
        			    {
        				String areaCode = funGenerateAreaCode(strClientCode);
        	
        				rs = webPOSSessionFactory.getCurrentSession().createSQLQuery("select count(strAreaCode) from tblareamaster where strAreaName=''");
        	            list = rs.list();
        	            if (list!=null && list.size()>0)
        	            {
        	            	areaCodeCnt = Integer.parseInt(list.get(0).toString());
        	            	if (areaCodeCnt == 0)
        				    {
        	            		funExecuteUpdateQuery("delete from tblareamaster where strAreaName=''");
        				    }
        	            }
        				
        				String sql_Area = "insert into tblareamaster (strAreaCode,strAreaName,strUserCreated,strUserEdited,dteDateCreated,dteDateEdited)values('" + areaCode + "'"
        					+ ",'All','" + gUserCode + "','" + gUserCode + "','" + objUtilityController.getCurrentDateTime() + "','" + objUtilityController.getCurrentDateTime() + "')";
        				//System.out.println(sql);
        				funExecuteUpdateQuery(sql_Area);
        				
        			    }
                    }

            	}
            }
			            
	    }

	    private void funStructureUpdateForTblItemrTemp()
	    {
		try
		{
		   // String sql = "select strSerialNo from tblitemrtemp ";
		   // ResultSet rsIsExistsTable = clsGlobalVarClass.dbMysql.executeResultSet(sql);
		    //            
		    //insert itemrtemp  data to itemrtempbackup
			String  sql = "truncate tblitemrtemp_bck";
		    funExecuteUpdateQuery(sql);
		    //insert itemrtemp  data to itemrtempbackup
		    sql = "insert into tblitemrtemp_bck(select * from tblitemrtemp)";
		    funExecuteUpdateQuery(sql);

		}
		catch (Exception e)
		{
		    //
		    String sql = "CREATE TABLE if not exists `tblitemrtemp` ( "
			    + "	`strSerialNo` VARCHAR(10) NOT NULL, "
			    + "	`strTableNo` VARCHAR(10) NOT NULL, "
			    + "	`strCardNo` VARCHAR(50) NULL DEFAULT NULL, "
			    + "	`dblRedeemAmt` DECIMAL(18,2) NULL DEFAULT NULL, "
			    + "	`strHomeDelivery` VARCHAR(50) NULL DEFAULT 'No', "
			    + "	`strCustomerCode` VARCHAR(50) NULL DEFAULT NULL, "
			    + "	`strPOSCode` VARCHAR(3) NOT NULL, "
			    + "	`strItemCode` VARCHAR(50) NOT NULL, "
			    + "	`strItemName` VARCHAR(200) NOT NULL, "
			    + "	`dblItemQuantity` DECIMAL(18,2) NOT NULL, "
			    + "	`dblAmount` DECIMAL(18,2) NOT NULL, "
			    + "	`strWaiterNo` VARCHAR(10) NOT NULL, "
			    + "	`strKOTNo` VARCHAR(10) NULL , "
			    + "	`intPaxNo` INT(11) NOT NULL, "
			    + "	`strPrintYN` CHAR(1) NULL DEFAULT NULL, "
			    + "	`strManualKOTNo` VARCHAR(10) NOT NULL DEFAULT '', "
			    + "	`strUserCreated` VARCHAR(10) NOT NULL, "
			    + "	`strUserEdited` VARCHAR(10) NOT NULL, "
			    + "	`dteDateCreated` DATETIME NOT NULL, "
			    + "	`dteDateEdited` DATETIME NOT NULL, "
			    + "	`strOrderBefore` VARCHAR(10) NOT NULL DEFAULT 'No', "
			    + "	`strTakeAwayYesNo` VARCHAR(10) NOT NULL DEFAULT 'No', "
			    + "	`tdhComboItemYN` VARCHAR(1) NOT NULL DEFAULT 'N', "
			    + "	`strDelBoyCode` VARCHAR(10) NOT NULL DEFAULT '', "
			    + "	`strNCKotYN` VARCHAR(1) NOT NULL DEFAULT 'N', "
			    + "	`strCustomerName` VARCHAR(100) NOT NULL DEFAULT '', "
			    + "	`strActiveYN` VARCHAR(1) NOT NULL DEFAULT 'N', "
			    + "	`dblBalance` DECIMAL(18,2) NOT NULL DEFAULT '0.00', "
			    + "	`dblCreditLimit` DECIMAL(18,2) NOT NULL DEFAULT '0.00', "
			    + "	`strCounterCode` VARCHAR(4) NOT NULL DEFAULT '', "
			    + "	`strPromoCode` VARCHAR(10) NOT NULL DEFAULT '', "
			    + "	`dblRate` DECIMAL(18,2) NOT NULL DEFAULT '0.00', "
			    + "	`intId` BIGINT(20) NULL DEFAULT NULL, "
			    + "	`strCardType` VARCHAR(50) NOT NULL DEFAULT '', "
			    + "	`dblTaxAmt` DECIMAL(18,2) NOT NULL DEFAULT '0.00',"
			    + " `strReason` VARCHAR(50) NOT NULL DEFAULT 'No', "
			    + "	PRIMARY KEY (`strTableNo`, `strItemCode`, `strKOTNo`,`strItemName`) "
			    + " ) "
			    + "COLLATE='utf8_general_ci' "
			    + "ENGINE=InnoDB "
			    + ";";
		    int i = funExecuteUpdateQuery(sql);

		    //            
		    //insert itemrtempbackup data to itemrtemp
		    sql = "insert into tblitemrtemp(select * from tblitemrtemp_bck)";
		    i = funExecuteUpdateQuery(sql);
		    //            
		}
		finally
		{

		}
	    }

	    private void funForButtonSequenceStrucureUpdate() throws Exception
	    {
		String sql = "DROP TABLE IF EXISTS `tbltransbtnsequence`;";
		int i = funExecuteUpdateQuery(sql);

		sql = "CREATE TABLE IF NOT EXISTS `tblbuttonsequence` ( "
			+ "  `strPOSCode` varchar(15) NOT NULL, "
			+ "  `strTransactionName` varchar(15) NOT NULL, "
			+ "  `strButtonName` varchar(50) NOT NULL, "
			+ "  `intSeqNo` int(11) NOT NULL, "
			+ "  `strUserCreated` varchar(10) NOT NULL, "
			+ "  `strUserEdited` varchar(10) NOT NULL, "
			+ "  `dteDateCreated` datetime NOT NULL, "
			+ "  `dteDateEdited` datetime NOT NULL, "
			+ "  `strClientCode` varchar(10) NOT NULL, "
			+ "  `strDataPostFlag` varchar(1) NOT NULL DEFAULT 'N', "
			+ "  PRIMARY KEY (`strPOSCode`,`strTransactionName`,`strButtonName`,`strClientCode`) "
			+ ") ENGINE=InnoDB DEFAULT CHARSET=utf8;";
		i = funExecuteUpdateQuery(sql);

		sql = "select count(*) FROM tblbuttonsequence";
		Query rs = webPOSSessionFactory.getCurrentSession().createSQLQuery(sql);
        List list = rs.list();
        int count =0;
        if (list!=null && list.size()>0)
        {
        	count = Integer.parseInt(list.get(0).toString());
        }
        if (count == 0)
		{
		    sql = "INSERT INTO `tblbuttonsequence` (`strPOSCode`, `strTransactionName`, `strButtonName`, `intSeqNo`, `strUserCreated`, `strUserEdited`, `dteDateCreated`, `dteDateEdited`, `strClientCode`, `strDataPostFlag`) "
			    + "VALUES "
			    + "('All', 'DirectBiller', 'Customer History', 2, '" + gUserCode + "', '" + gUserCode + "', '" + objUtilityController.getCurrentDateTime() + "', '" + objUtilityController.getCurrentDateTime() + "', '" + gClientCode + "', 'N'), "
			    + "('All', 'DirectBiller', 'Delivery Boy', 4, '" + gUserCode + "', '" + gUserCode + "', '" + objUtilityController.getCurrentDateTime() + "', '" + objUtilityController.getCurrentDateTime() + "', '" + gClientCode + "', 'N'), "
			    + "('All', 'DirectBiller', 'Done', 6, '" + gUserCode + "', '" + gUserCode + "', '" + objUtilityController.getCurrentDateTime() + "', '" + objUtilityController.getCurrentDateTime() + "', '" + gClientCode + "', 'N'), "
			    + "('All', 'DirectBiller', 'Home', 1, '" + gUserCode + "', '" + gUserCode + "', '" + objUtilityController.getCurrentDateTime() + "', '" + objUtilityController.getCurrentDateTime() + "', '" + gClientCode + "', 'N'), "
			    + "('All', 'DirectBiller', 'Home Delivery', 3, '" + gUserCode + "', '" + gUserCode + "', '" + objUtilityController.getCurrentDateTime() + "', '" + objUtilityController.getCurrentDateTime() + "', '" + gClientCode + "', 'N'), "
			    + "('All', 'DirectBiller', 'Take Away', 5, '" + gUserCode + "', '" + gUserCode + "', '" + objUtilityController.getCurrentDateTime() + "', '" + objUtilityController.getCurrentDateTime() + "', '" + gClientCode + "', 'N'), "
			    + "('All', 'MakeKOT', 'Home', 1, '" + gUserCode + "', '" + gUserCode + "', '" + objUtilityController.getCurrentDateTime() + "', '" + objUtilityController.getCurrentDateTime() + "', '" + gClientCode + "', 'N'), "
			    + "('All', 'MakeKOT', 'Settle Bill', 2, '" + gUserCode + "', '" + gUserCode + "', '" + objUtilityController.getCurrentDateTime() + "', '" + objUtilityController.getCurrentDateTime() + "', '" + gClientCode + "', 'N'), "
			    + "('All', 'MakeKOT', 'Home Delivery', 3, '" + gUserCode + "', '" + gUserCode + "', '" + objUtilityController.getCurrentDateTime() + "', '" + objUtilityController.getCurrentDateTime() + "', '" + gClientCode + "', 'N'), "
			    + "('All', 'MakeKOT', 'Delivery Boy', 4, '" + gUserCode + "', '" + gUserCode + "', '" + objUtilityController.getCurrentDateTime() + "', '" + objUtilityController.getCurrentDateTime() + "', '" + gClientCode + "', 'N'), "
			    + "('All', 'MakeKOT', 'Check KOT', 5, '" + gUserCode + "', '" + gUserCode + "', '" + objUtilityController.getCurrentDateTime() + "', '" + objUtilityController.getCurrentDateTime() + "', '" + gClientCode + "', 'N'), "
			    + "('All', 'MakeKOT', 'NC KOT', 6, '" + gUserCode + "', '" + gUserCode + "', '" + objUtilityController.getCurrentDateTime() + "', '" + objUtilityController.getCurrentDateTime() + "', '" + gClientCode + "', 'N'), "
			    + "('All', 'MakeKOT', 'Customer', 7, '" + gUserCode + "', '" + gUserCode + "', '" + objUtilityController.getCurrentDateTime() + "', '" + objUtilityController.getCurrentDateTime() + "', '" + gClientCode + "', 'N'), "
			    + "('All', 'MakeKOT', 'Done', 8, '" + gUserCode + "', '" + gUserCode + "', '" + objUtilityController.getCurrentDateTime() + "', '" + objUtilityController.getCurrentDateTime() + "', '" + gClientCode + "', 'N'), "
			    + "('All', 'MakeKOT', 'Make Bill', 9, '" + gUserCode + "', '" + gUserCode + "', '" + objUtilityController.getCurrentDateTime() + "', '" + objUtilityController.getCurrentDateTime() + "', '" + gClientCode + "', 'N'); ";

		    i = funExecuteUpdateQuery(sql);
		}
		else
		{
		    //don't do strucure update
		}

	    }
/*
	    private void funInsertTaxObGroupData() throws Exception
	    {
		String sql = "select count(*) FROM tbltaxongroup";
		ResultSet rs = clsGlobalVarClass.dbMysql.executeResultSet(sql);
		int count = 0;
		if (rs.next())
		{
		    count = rs.getInt(1);
		}
		rs.close();
		if (count == 0)
		{

		    sql = "select a.strTaxCode,a.strTaxDesc,a.dteValidFrom,a.dteValidTo from tbltaxhd a ; ";
		    ResultSet rsTaxes = clsGlobalVarClass.dbMysql.executeResultSet(sql);
		    while (rsTaxes.next())
		    {
			boolean isFirst = true;
			String taxCode = rsTaxes.getString(1);
			String fromDate = rsTaxes.getString(3);
			String toDate = rsTaxes.getString(4);

			String insertSql = "INSERT INTO tbltaxongroup "
				+ "(`strTaxCode`, `strGroupCode`, `strGroupName`, `strApplicable`, `dteFrom`, `dteTo` "
				+ ", `strUserCreated`, `strUserEdited`, `dteDateCreated`, `dteDateEdited`, `strClientCode`) "
				+ " VALUES ";

			sql = "select a.strGroupCode,a.strGroupName "
				+ "from tblgrouphd a ";

			ResultSet rsGroups = clsGlobalVarClass.dbMysql.executeResultSet(sql);
			while (rsGroups.next())
			{
			    String groupCode = rsGroups.getString(1);
			    String groupName = rsGroups.getString(2);
			    if (isFirst)
			    {
				insertSql += "('" + taxCode + "', '" + groupCode + "', '" + groupName + "', 'true', '" + fromDate + "', '" + toDate + "', '" + gUserCode + "'"
					+ ", '" + gUserCode + "' "
					+ ",'" + objUtilityController.getCurrentDateTime() + "','" + objUtilityController.getCurrentDateTime() + "','" + clsGlobalVarClass.gClientCode + "' )";

				isFirst = false;
			    }
			    else
			    {
				insertSql += ",('" + taxCode + "', '" + groupCode + "', '" + groupName + "', 'true', '" + fromDate + "', '" + toDate + "', '" + gUserCode + "'"
					+ ", '" + gUserCode + "' "
					+ ",'" + objUtilityController.getCurrentDateTime() + "','" + objUtilityController.getCurrentDateTime() + "','" + clsGlobalVarClass.gClientCode + "' )";

			    }
			}
			rsGroups.close();
			if (!isFirst)
			{
			    funExecuteUpdateQuery(insertSql);
			}
		    }
		    rsTaxes.close();
		}
		else
		{
		    //don't do strucure update
		}
	    }

	   */ 
	  
	    
	    private void funAddIndexing()
	    {
		String sql = "ALTER TABLE `tblbillcomplementrydtl` "
			+ "	ADD INDEX `strBillNo` (`strBillNo`);";
		int i = funExecuteUpdateQuery(sql);

		sql = "	ALTER TABLE `tblqbillcomplementrydtl` "
			+ "	ADD INDEX `strBillNo` (`strBillNo`);";
		i = funExecuteUpdateQuery(sql);

		sql = "	ALTER TABLE `tblbilldiscdtl` "
			+ "	ADD INDEX `strBillNo` (`strBillNo`);";
		i = funExecuteUpdateQuery(sql);

		sql = "ALTER TABLE `tblqbilldiscdtl` "
			+ "	ADD INDEX `strBillNo` (`strBillNo`);";
		i = funExecuteUpdateQuery(sql);

		sql = "	ALTER TABLE `tblbilldtl` "
			+ "	ADD INDEX `strBillNo` (`strBillNo`);";
		i = funExecuteUpdateQuery(sql);

		sql = "	ALTER TABLE `tblqbilldtl` "
			+ "	ADD INDEX `strBillNo` (`strBillNo`);";
		i = funExecuteUpdateQuery(sql);

		sql = "	ALTER TABLE `tblbillpromotiondtl` "
			+ "	ADD INDEX `strBillNo` (`strBillNo`);";
		i = funExecuteUpdateQuery(sql);

		sql = "ALTER TABLE `tblqbillpromotiondtl` "
			+ "	ADD INDEX `strBillNo` (`strBillNo`);";
		i = funExecuteUpdateQuery(sql);

		sql = "	ALTER TABLE `tblbillseries` "
			+ "	ADD INDEX `strBillSeries` (`strBillSeries`);";
		i = funExecuteUpdateQuery(sql);

		sql = "	ALTER TABLE `tblvoidbillhd` "
			+ "	ADD INDEX `strBillNo` (`strBillNo`);";
		i = funExecuteUpdateQuery(sql);

		sql = "	ALTER TABLE `tblvoidbilldtl` "
			+ "	ADD INDEX `strBillNo` (`strBillNo`);";
		i = funExecuteUpdateQuery(sql);

		sql = "	ALTER TABLE `tblvoidbillsettlementdtl` "
			+ "	ADD INDEX `strBillNo` (`strBillNo`);";
		i = funExecuteUpdateQuery(sql);

		sql = "	ALTER TABLE `tblhomedeldtl` "
			+ "	ADD INDEX `strBillNo` (`strBillNo`);";
		i = funExecuteUpdateQuery(sql);

		sql = "	ALTER TABLE `tbladvancereceiptdtl` "
			+ "	ADD INDEX `strReceiptNo` (`strReceiptNo`);";
		i = funExecuteUpdateQuery(sql);

		sql = "	ALTER TABLE `tbladvbooktaxdtl` "
			+ "	ADD INDEX `strAdvBookingNo` (`strAdvBookingNo`);";
		i = funExecuteUpdateQuery(sql);

		sql = "ALTER TABLE `tbltempomedelv` "
			+ "	ADD INDEX `strCustomerCode` (`strCustomerCode`);";
		i = funExecuteUpdateQuery(sql);

		sql = "	ALTER TABLE `tbladvancebookingtemp` "
			+ "	ADD INDEX `strCustomerCode` (`strCustomerCode`);";
		i = funExecuteUpdateQuery(sql);

		sql = "	ALTER TABLE `tbladvbooktaxtemp` "
			+ "	ADD INDEX `strTaxCode` (`strTaxCode`); "
			+ "	";
		i = funExecuteUpdateQuery(sql);

		sql = "	ALTER TABLE `tblareawisedelboywisecharges` "
			+ "	ADD INDEX `strCustAreaCode` (`strCustAreaCode`);";
		i = funExecuteUpdateQuery(sql);

		sql = "	ALTER TABLE `tblatvreport` "
			+ "	ADD INDEX `strPosCode` (`strPosCode`); "
			+ "	";
		i = funExecuteUpdateQuery(sql);

		sql = "	ALTER TABLE `tblaudit` "
			+ "	ADD INDEX `strDocNo` (`strDocNo`);";
		i = funExecuteUpdateQuery(sql);

		sql = "	ALTER TABLE `tblbuypromotiondtl` "
			+ "	ADD INDEX `strPromoCode` (`strPromoCode`);";
		i = funExecuteUpdateQuery(sql);

		sql = "	ALTER TABLE `tblcashiermanagement` "
			+ "	ADD INDEX `strTransactionId` (`strTransactionId`);";
		i = funExecuteUpdateQuery(sql);

		sql = "ALTER TABLE `tblcharactersticsmaster` "
			+ "	ADD INDEX `strCharCode` (`strCharCode`);";
		i = funExecuteUpdateQuery(sql);

		sql = "	ALTER TABLE `tblcharvalue` "
			+ "	ADD INDEX `strCharCode` (`strCharCode`);";
		i = funExecuteUpdateQuery(sql);

		sql = "	ALTER TABLE `tbldayendprocess` "
			+ "	ADD INDEX `strPOSCode_dtePOSDate` (`strPOSCode`, `dtePOSDate`);";
		i = funExecuteUpdateQuery(sql);

		sql = "	ALTER TABLE `tbldebitcardbilldetails` "
			+ "	ADD INDEX `strBillNo_strCardNo` (`strBillNo`, `strCardNo`);";
		i = funExecuteUpdateQuery(sql);

		sql = "ALTER TABLE `tbldebitcardmaster` "
			+ "	ADD INDEX `strCardTypeCode_strCardNo` (`strCardTypeCode`, `strCardNo`);";
		i = funExecuteUpdateQuery(sql);

		sql = "	ALTER TABLE `tbldebitcardrevenue` "
			+ "	ADD INDEX `strCardNo` (`strCardNo`);";
		i = funExecuteUpdateQuery(sql);

		sql = "ALTER TABLE `tbldebitcardsettlementdtl` "
			+ "	ADD INDEX `strSettlementCode` (`strSettlementCode`);";
		i = funExecuteUpdateQuery(sql);

		sql = "	ALTER TABLE `tbldebitcardtabletemp` "
			+ "	ADD INDEX `strCardNo` (`strCardNo`);";
		i = funExecuteUpdateQuery(sql);

		sql = "ALTER TABLE `tbldebitcardtype` "
			+ "	ADD INDEX `strCardTypeCode` (`strCardTypeCode`);";
		i = funExecuteUpdateQuery(sql);

		sql = "	ALTER TABLE `tbldeliveryboycategorymaster` "
			+ "	ADD INDEX `strDelBoyCategoryCode` (`strDelBoyCategoryCode`);";
		i = funExecuteUpdateQuery(sql);

		sql = "ALTER TABLE `tblforms` "
			+ "	ADD INDEX `strFormName` (`strFormName`);";
		i = funExecuteUpdateQuery(sql);

		sql = "ALTER TABLE `tblimportexcel` "
			+ "	ADD INDEX `strItemName` (`strItemName`);";
		i = funExecuteUpdateQuery(sql);

		sql = "ALTER TABLE `tblinternal` "
			+ "	ADD INDEX `strTransactionType` (`strTransactionType`);";
		i = funExecuteUpdateQuery(sql);

		sql = "ALTER TABLE `tblkottaxdtl` "
			+ "	ADD INDEX `strKOTNo` (`strKOTNo`);";
		i = funExecuteUpdateQuery(sql);

		sql = "	ALTER TABLE `tbllaststoreadvbookingbill` "
			+ "	ADD INDEX `strPosCode` (`strPosCode`);";
		i = funExecuteUpdateQuery(sql);

		sql = "ALTER TABLE `tbllinevoid` "
			+ "	ADD INDEX `strPosCode` (`strPosCode`);";
		i = funExecuteUpdateQuery(sql);

		sql = "ALTER TABLE `tblorderanalysis` "
			+ "	ADD INDEX `strField1` (`strField1`);";
		i = funExecuteUpdateQuery(sql);

		sql = "	ALTER TABLE `tbltempsalesflash` "
			+ "	ADD INDEX `strcode` (`strcode`);";
		i = funExecuteUpdateQuery(sql);

		sql = "ALTER TABLE `tbltempsalesflash1` "
			+ "	ADD INDEX `strbillno` (`strbillno`);";
		i = funExecuteUpdateQuery(sql);

	    }

	    private void funUpdateBillDate()
	    {
		String sql = "  update tblbilldiscdtl a  "
			+ " join tblbillhd b on a.strBillNo=b.strBillNo and a.strClientCode=b.strClientCode  "
			+ " set a.dteBillDate=b.dteBillDate "
			+ " where a.dteBillDate='0000-00-00 00:00:00' ;";
		int i = funExecuteUpdateQuery(sql);

		sql = "  update tblbillmodifierdtl a  "
			+ " join tblbillhd b on a.strBillNo=b.strBillNo and a.strClientCode=b.strClientCode  "
			+ " set a.dteBillDate=b.dteBillDate "
			+ " where a.dteBillDate='0000-00-00 00:00:00' ;";
		i = funExecuteUpdateQuery(sql);

		sql = "  update tblbillpromotiondtl a  "
			+ " join tblbillhd b on a.strBillNo=b.strBillNo and a.strClientCode=b.strClientCode  "
			+ " set a.dteBillDate=b.dteBillDate "
			+ " where a.dteBillDate='0000-00-00 00:00:00' ;";
		i = funExecuteUpdateQuery(sql);

		sql = "  update tblbilltaxdtl a  "
			+ " join tblbillhd b on a.strBillNo=b.strBillNo and a.strClientCode=b.strClientCode  "
			+ " set a.dteBillDate=b.dteBillDate "
			+ " where a.dteBillDate='0000-00-00 00:00:00' ;";
		i = funExecuteUpdateQuery(sql);

		sql = "  update tblbillsettlementdtl a  "
			+ " join tblbillhd b on a.strBillNo=b.strBillNo and a.strClientCode=b.strClientCode  "
			+ " set a.dteBillDate=b.dteBillDate "
			+ " where a.dteBillDate='0000-00-00 00:00:00' ;";
		i = funExecuteUpdateQuery(sql);

		sql = "  update tblhomedeldtl a  "
			+ " join tblbillhd b on a.strBillNo=b.strBillNo and a.strClientCode=b.strClientCode  "
			+ " set a.dteBillDate=b.dteBillDate "
			+ " where a.dteBillDate='0000-00-00 00:00:00' ;";
		i = funExecuteUpdateQuery(sql);

		sql = "update tblqbilldiscdtl a  "
			+ " join tblqbillhd b on a.strBillNo=b.strBillNo and a.strClientCode=b.strClientCode  "
			+ " set a.dteBillDate=b.dteBillDate "
			+ " where a.dteBillDate='0000-00-00 00:00:00' ;";
		i = funExecuteUpdateQuery(sql);

		sql = "  update tblqbillmodifierdtl a  "
			+ " join tblqbillhd b on a.strBillNo=b.strBillNo and a.strClientCode=b.strClientCode  "
			+ " set a.dteBillDate=b.dteBillDate "
			+ " where a.dteBillDate='0000-00-00 00:00:00' ;";
		i = funExecuteUpdateQuery(sql);

		sql = " update tblqbillpromotiondtl a  "
			+ " join tblqbillhd b on a.strBillNo=b.strBillNo and a.strClientCode=b.strClientCode  "
			+ " set a.dteBillDate=b.dteBillDate "
			+ " where a.dteBillDate='0000-00-00 00:00:00' ;";
		i = funExecuteUpdateQuery(sql);

		sql = "  update tblqbilltaxdtl a  "
			+ " join tblqbillhd b on a.strBillNo=b.strBillNo and a.strClientCode=b.strClientCode  "
			+ " set a.dteBillDate=b.dteBillDate "
			+ " where a.dteBillDate='0000-00-00 00:00:00' ;";
		i = funExecuteUpdateQuery(sql);

		sql = "  update tblqbillsettlementdtl a  "
			+ " join tblqbillhd b on a.strBillNo=b.strBillNo and a.strClientCode=b.strClientCode  "
			+ " set a.dteBillDate=b.dteBillDate "
			+ " where a.dteBillDate='0000-00-00 00:00:00' ;";
		i = funExecuteUpdateQuery(sql);

		sql = "  update tblhomedeldtl a  "
			+ " join tblqbillhd b on a.strBillNo=b.strBillNo and a.strClientCode=b.strClientCode  "
			+ " set a.dteBillDate=b.dteBillDate "
			+ " where a.dteBillDate='0000-00-00 00:00:00' ;";
		i = funExecuteUpdateQuery(sql);

		sql = "  update tblvoidmodifierdtl a  "
			+ " join tblvoidbillhd b on a.strBillNo=b.strBillNo and a.strClientCode=b.strClientCode  "
			+ " set a.dteBillDate=b.dteBillDate "
			+ " where a.dteBillDate='0000-00-00 00:00:00' ;";
		i = funExecuteUpdateQuery(sql);

		sql = "   update tblvoidbillsettlementdtl a  "
			+ " join tblvoidbillhd b on a.strBillNo=b.strBillNo and a.strClientCode=b.strClientCode  "
			+ " set a.dteBillDate=b.dteBillDate "
			+ " where a.dteBillDate='0000-00-00 00:00:00' ;";
		i = funExecuteUpdateQuery(sql);
	    }

	  /*  
	    private void funUpdateBillNote()
	    {
		try
		{
		    String billNote = "";
		    if (clsGlobalVarClass.gUseVatAndServiceTaxFromPos)
		    {
			if(null!=clsGlobalVarClass.gPrintVatNoPOS && clsGlobalVarClass.gPrintVatNoPOS.equals("Y")){
			    {
				billNote += "  Vat No. : " + clsGlobalVarClass.gPOSVatNo;
				billNote += " ";
			    }    
			}
			if (null!=clsGlobalVarClass.gPrintVatNoPOS && clsGlobalVarClass.gPrintServiceTaxNoPOS.equals("Y"))
			{
			    billNote += "  Service Tax No. : " + clsGlobalVarClass.gPOSServiceTaxNo;
			    billNote += " ";
			}
		    }
		    else
		    {
			if (clsGlobalVarClass.gPrintVatNo)
			{
			    billNote += "  Vat No. : " + clsGlobalVarClass.gVatNo;
			    billNote += " ";
			}
			if (clsGlobalVarClass.gPrintServiceTaxNo)
			{
			    billNote += "  Service Tax No. : " + clsGlobalVarClass.gServiceTaxNo;
			    billNote += " ";
			}
		    }

		    String sql = "select  a.strTaxCode,a.strTaxDesc,a.dteValidFrom,a.dteValidTo,a.strBillNote "
			    + "from tbltaxhd a "
			    + "where a.strBillNote='' ";
		    ResultSet rsBlankBillNote = clsGlobalVarClass.dbMysql.executeResultSet(sql);
		    while (rsBlankBillNote.next())
		    {
			clsGlobalVarClass.dbMysql.execute("update tbltaxhd "
				+ "set strBillNote='" + billNote + "' "
				+ "where strTaxCode='" + rsBlankBillNote.getString(1) + "' ");
		    }
		    rsBlankBillNote.close();
		}
		catch (Exception e)
		{
		    e.printStackTrace();
		}
	    }
*/
	  
	    
	    private void funUpdateDayEndPAX()
	    {
		try
		{
		    String sql = "select a.strPOSCode,date(a.dtePOSDate),a.intShiftCode,a.strDayEnd,a.strShiftEnd,a.intTotalPax "
			    + "from tbldayendprocess a "
			    + "where a.intTotalPax=0 "
			    + "and a.strDayEnd='Y' "
			    + "and a.strShiftEnd='Y' ";
		    Query rs = webPOSSessionFactory.getCurrentSession().createSQLQuery(sql);
            List list = rs.list();
            if (list!=null && list.size()>0)
            {
            	for(int i=0;i<list.size();i++){
            		Object[] obj=(Object[]) list.get(i);
            		String posCode = obj[0].toString();//posCode
        			String dayEndDate = obj[1].toString();//rsDayendPax.getString(2);//dayend date/bill date
        			String shiftCode = obj[2].toString();//rsDayendPax.getString(3);//shift

        			sql = "update tbldayendprocess set intTotalPax=IFNULL((select sum(intBillSeriesPaxNo) "
        				+ "from tblqbillhd  "
        				+ "where date(dteBillDate ) ='" + dayEndDate + "'  "
        				+ "and intShiftCode=" + shiftCode + " "
        				+ "and strPOSCode='" + posCode + "'),0) "
        				+ "where date(dtePOSDate)='" + dayEndDate + "'  "
        				+ "and strPOSCode='" + posCode + "' "
        				+ "and intShiftCode=" + shiftCode + " ";
        			 funExecuteUpdateQuery(sql);
            	}
            	
            }
		}
		catch (Exception e)
		{
		    e.printStackTrace();
		}
	    }

	/*    public final static int executeUpdateQuery(String Query)
	    {
			try
			{
			    clsGlobalVarClass.dbMysql.execute(Query);
			}
			catch (Exception e)
			{
			    //e.printStackTrace();
			}
		return 0;
	    }*/

	    private void funUpdateSuperUserForms()
	    {
		try
		{
		    //update super user detail
		    String sqlSuperUsers = "select a.strUserCode from tbluserhd a where a.strSuperType='super';";
		    Query rs = webPOSSessionFactory.getCurrentSession().createSQLQuery(sqlSuperUsers);
            List list = rs.list();
            StringBuilder sqlInsertQuery = new StringBuilder("INSERT INTO tblsuperuserdtl(strUserCode,strFormName,strButtonName,intSequence,strAdd,strEdit,strDelete,strView,strPrint,strSave,strGrant) VALUES ");
		    boolean flag = true;
		  
            if (list!=null && list.size()>0)
            {
            	for(int i=0;i<list.size();i++){
            		String userCode =  list.get(0).toString();//

        			String userForms = "select a.strModuleName,a.strImageName,a.intSequence "
        				+ "from tblforms a where a.strModuleName NOT IN (select b.strFormName  from tblsuperuserdtl b where strUserCode='" + userCode + "'  ) ";
        			
        			 rs = webPOSSessionFactory.getCurrentSession().createSQLQuery(sqlSuperUsers);
        	            List list1 = rs.list();
        	            if (list1!=null && list1.size()>0)
        	            {
        	            	for(int j=0;j<list1.size();j++){
        	            		Object[] obj=(Object[])list1.get(j);
        	            		if (flag)
                			    {
                				flag = false;
                				sqlInsertQuery.append("('" + userCode + "', '" + obj[0].toString() + "','" + obj[1].toString() + "','" + obj[2].toString() + "','true', 'true', 'true', 'true', 'true', 'true', 'true') ");
                			    }
                			    else
                			    {
                				sqlInsertQuery.append(",('" + userCode + "', '" + obj[0].toString() + "','" +obj[1].toString() + "','" +  obj[2].toString()  + "','true', 'true', 'true', 'true', 'true', 'true', 'true') ");
                			    }

        	            	}
        	            }

            	}
    			    		    
            }
		    
		    System.out.println("super->" + sqlInsertQuery);
		    if (sqlInsertQuery.length() > 150)
		    {
		    	 funExecuteUpdateQuery(sqlInsertQuery.toString());
			 //clsGlobalVarClass.dbMysql.execute(sqlInsertQuery.toString());
		    }
		    //updated super user detail	    
		}
		catch (Exception e)
		{
		    e.printStackTrace();
		}

	    }

	    private void funUpdateAreaForAll() throws Exception
	    {
		String sql = "select strAreaCode from tblareamaster where strAreaName='All'";
		Query rs = webPOSSessionFactory.getCurrentSession().createSQLQuery(sql);
        List list1 = rs.list();
        if (list1!=null && list1.size()>0)
        {
        	String areaCode = list1.get(0).toString();
		    sql = "update tblmenuitempricingdtl set strAreaCode='" + areaCode + "' where strAreaCode=''";
		    funExecuteUpdateQuery(sql);
        }
	
		}

	    public void funUpdateTblForms() throws IllegalAccessException, IllegalArgumentException, InvocationTargetException
	    {
			if (mapStructureUpdater.containsKey("frmStructure"))
			{
	
			    List<String> listOfQueries = mapStructureUpdater.get("frmStructure");
	
			    for (String sql : listOfQueries)
			    {
				if (sql.startsWith("fun") && mapDeclaredMethods.containsKey(sql))
				{
				    Method method = mapDeclaredMethods.get(sql);
				    method.invoke(objStructureUpdater);
				}
				else
				{
				    funExecuteUpdateQuery(sql);
				}
			    }
			}
	    }
	    
	    @SuppressWarnings("finally")
		private final int funExecuteUpdateQuery(String sql) {
			try {
				Query query = webPOSSessionFactory.getCurrentSession()
						.createSQLQuery(sql);
				query.executeUpdate();
			} catch (Exception e) {
			} finally {
				return 0;
			}
		}
		
}
