/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.sanguine.webpos.comparator;

import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

import com.sanguine.webpos.bean.clsPOSCounterMasterBean;


/**
 *
 * @author ajjim
 */
public class clsCounterComparator implements Comparator<clsPOSCounterMasterBean>
{

    private List<Comparator<clsPOSCounterMasterBean>> listComparators;

    @SafeVarargs
    public clsCounterComparator(Comparator<clsPOSCounterMasterBean>... comparators)
    {
        this.listComparators = Arrays.asList(comparators);
    }

    @Override
    public int compare(clsPOSCounterMasterBean o1, clsPOSCounterMasterBean o2)
    {
        for (Comparator<clsPOSCounterMasterBean> comparator : listComparators)
        {
            int result = comparator.compare(o1, o2);
            if (result != 0)
            {
                return result;
            }
        }
        return 0;
    }
    
}