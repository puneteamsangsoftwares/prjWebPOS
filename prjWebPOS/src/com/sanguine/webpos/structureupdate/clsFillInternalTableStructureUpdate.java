package com.sanguine.webpos.structureupdate;

import java.util.List;
import java.util.Map;

public class clsFillInternalTableStructureUpdate
{

	  private Map<String, List<String>> mapStructureUpdater;

	    public clsFillInternalTableStructureUpdate(Map<String, List<String>> mapStructureUpdater)
	    {
	    	this.mapStructureUpdater = mapStructureUpdater;
	    }

	    public void funFillInternalTableStructureUpdate()
	    {
		//funCheckInternalTable();funCheckInternalTable
		mapStructureUpdater.get("internalTableStructure").add("funCheckInternalTable");
	    }
}
