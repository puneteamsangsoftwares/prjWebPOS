package com.sanguine.webpos.structureupdate;

import java.util.List;
import java.util.Map;

public class clsFillIMasterStatusTableStructureUpdate
{


    private Map<String, List<String>> mapStructureUpdater;

    public clsFillIMasterStatusTableStructureUpdate(Map<String, List<String>> mapStructureUpdater)
    {
	this.mapStructureUpdater = mapStructureUpdater;
    }

    public void funFillIMasterStatusTableStructureUpdate()
    {
	//funCheckMasterTableStatus();
	mapStructureUpdater.get("masterTableStatusStructure").add("funCheckMasterTableStatus");
    }
}
