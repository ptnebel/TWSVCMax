public with sharing class Reset_WO {
    public PageReference reset() {
        for (List <SVMXC__Service_Order__c> svolist: [Select Id, SVMXC__Service_Group__c, SVMXC__Group_Member__c, SVMXC__Scheduled_Date_Time__c, SVMXC__OptiMax_Status__c, SVMXC__Service_Duration__c
                                                                     from SVMXC__Service_Order__c where SVMXC__State__c in ('MD', 'DE', 'WV')])  {
        for (SVMXC__Service_Order__c svo: svolist) {
            svo.SVMXC__Service_Group__c = null;
            svo.SVMXC__Group_Member__c = null;
            svo.SVMXC__Scheduled_Date_Time__c = null;
            svo.SVMXC__OptiMax_Status__c = null;
            svo.SVMXC__Service_Duration__c = 7200;
        }
            update svolist;
        //  delete svolist;
            Set <String> stridset = new Set<String>();
            for (SVMXC__Service_Order__c svo : svolist)
                stridset.add(svo.Id);
            for (List <SVMXC__SVMX_Event__c> sve: [Select Id from SVMXC__SVMX_Event__c where SVMXC__WhatId__c in :stridset])
                delete sve;
        }
    
        return new PageReference('/home/home.jsp');     
    }
}