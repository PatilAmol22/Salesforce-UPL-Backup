/*******************************************************************************************
* @Name         Sales Forecast Schedule Updation (Dutch)
* @Author       Nikhil Dhoke
* @Date         16/05/2023
* @Group        SKI
* @Description  This class contains methods used to call batch class and Schedule updation.
*******************************************************************************************/
public without sharing class DCH_SalesAgreementController {

    /*
    * @Description - This method get called on click of Update Metrix Button. From this mthod we call a batch.
    * @Param String - Salesagreement record id.
    * @return  -   N/A.
    */
    @AuraEnabled
    public static void callBatchClass(String recId){
        //system.debug('callBatchClass recId - ' + recId);
        try{
            if(String.IsNotBlank(recId)){
                List<SalesAgreement> saList = new List<SalesAgreement>();
                saList = [SELECT Id, AccountId, Year__c, StartDate, Sale_Org_Code__c FROM SalesAgreement WHERE Id =: recId];
                //system.debug('saList - ' + JSON.serializePretty(saList));
                if(saList.size()> 0 && (saList[0].Sale_Org_Code__c == '2191' || saList[0].Sale_Org_Code__c == '2192')){
                    //system.debug('batch called - ');
                    DCH_SalesAgreementScheduleUpdateBatch batch = new DCH_SalesAgreementScheduleUpdateBatch(saList[0].Id, saList[0].StartDate.year(), true, saList[0].Sale_Org_Code__c);
                    ID batchId = Database.executeBatch(batch,1);
                }
            }
        }
        catch(Exception ex){
            system.debug('Exception in callBatchClass method ');
            system.debug('Exception is - ' + ex);
            system.debug('Exception at Line no  - ' + ex.getLineNumber());
        }
    }

    /*
    * @Description - This method get called from batch class. In this method we update salesagreement product 
                     schedule record with previous and previous to previous year sold quamtity.
    * @Param saId - Salesagreement record id,
             accId - account id,
             year - year value,
             salesOrgCode - sales org codes (2191 or 2192),
             prevSAId - previous year salesagreement id,
             prevPrevSAId - previous to previous year salesagreement id.
    * @return  -   N/A.
    */
    @AuraEnabled
    public static void updateSchedules(String saId, String accId, Integer year, String salesOrgCode, String prevSAId, String prevPrevSAId) {
        /* system.debug('saId - ' + saId);
        system.debug('accId - ' + accId);
        system.debug('year - ' + year);
        system.debug('salesOrgCode - ' + salesOrgCode);
        system.debug('prevSAId - ' + prevSAId);
        system.debug('prevPrevSAId - ' + prevPrevSAId); */
        try{
            Integer prevYr = year - 1;
            Integer prevPrevYr = year - 2;
            String freq = 'Yearly';
            Map<String,SalesAgreementProductSchedule> prevScheduleMap = new Map<String,SalesAgreementProductSchedule>();
            Map<String,SalesAgreementProductSchedule> prevPrevScheduleMap = new Map<String,SalesAgreementProductSchedule>();

            List<SalesAgreementProductSchedule> scheduleList = [SELECT Id, Name, Sold_Quantity__c, SalesAgreementProductId, 
                                                                SalesAgreementProduct.SalesAgreementId, Year__c,   
                                                                Quantity_Sold_in_PY__c, Quantity_Sold_in_PY_1__c, 
                                                                SalesAgreementProduct.SalesAgreement.Account.SAP_Code__c, 
                                                                SalesAgreementProduct.Product.Product_Code__c, 
                                                                SalesAgreementProduct.SalesAgreement.StartDate  
                                                                FROM SalesAgreementProductSchedule WHERE 
                                                                SalesAgreementProduct.SalesAgreement.AccountId =: accId AND
                                                                SalesAgreementProduct.SalesAgreementId =: saId AND 
                                                                CALENDAR_YEAR(SalesAgreementProduct.SalesAgreement.StartDate) =: year AND 
                                                                Sales_Org__c =: salesOrgCode AND 
                                                                SalesAgreementProduct.SalesAgreement.ScheduleFrequency = 'Yearly' AND 
                                                                SalesAgreementProduct.SalesAgreement.ScheduleCount = 1];

            if(scheduleList.size()>0){
                List<SalesAgreementProductSchedule> prevScheduleList = new List<SalesAgreementProductSchedule>();
                String prevSchedQuery = '';
                prevSchedQuery = 'SELECT Id, Name, Sold_Quantity__c, SalesAgreementProductId, SalesAgreementProduct.SalesAgreementId, Year__c, '+
                                +' Quantity_Sold_in_PY__c, Quantity_Sold_in_PY_1__c, SalesAgreementProduct.SalesAgreement.Account.SAP_Code__c, '+
                                +'SalesAgreementProduct.Product.Product_Code__c, SalesAgreementProduct.SalesAgreement.StartDate FROM SalesAgreementProductSchedule WHERE '+
                                +'SalesAgreementProduct.SalesAgreement.AccountId =\''+ accId +'\' AND '+
                                +'Sales_Org__c =\''+ salesOrgCode+'\' AND '+ 
                                +'SalesAgreementProduct.SalesAgreement.ScheduleFrequency = \''+ freq +'\' AND '+
                                +'SalesAgreementProduct.SalesAgreement.ScheduleCount = 1 AND '+
                                +'CALENDAR_YEAR(SalesAgreementProduct.SalesAgreement.StartDate) ='+ prevYr;

                if(prevSAId != null || String.IsNotBlank(prevSAId)){
                    prevSchedQuery += ' AND SalesAgreementProduct.SalesAgreementId =\''+ prevSAId +'\'';
                }
                
                prevScheduleList = Database.query(prevSchedQuery);
                //system.debug('prevScheduleList - ' + JSON.serializePretty(prevScheduleList));
                if(prevScheduleList.size()>0){
                    for(SalesAgreementProductSchedule ps : prevScheduleList){
                        String key1 = ps.SalesAgreementProduct.SalesAgreement.Account.SAP_Code__c + ps.SalesAgreementProduct.Product.Product_Code__c + prevYr;

                        if(prevScheduleMap.containsKey(key1)){
                            SalesAgreementProductSchedule schdl = prevScheduleMap.get(key1);
                            if(schdl.Sold_Quantity__c == null){
                                schdl.Sold_Quantity__c = 0;
                            }
                            if(ps.Sold_Quantity__c == null){
                                ps.Sold_Quantity__c = 0;
                            }
                            schdl.Sold_Quantity__c = schdl.Sold_Quantity__c + ps.Sold_Quantity__c;
                            prevScheduleMap.put(key1,schdl);
                        }
                        else{
                            prevScheduleMap.put(key1,ps);
                        }
                    }
                } 
                //system.debug('prevScheduleMap - ' + JSON.serializePretty(prevScheduleMap));
                List<SalesAgreementProductSchedule> prevPrevScheduleList = new List<SalesAgreementProductSchedule>();
                String prevPrevSchedQuery = '';
                prevPrevSchedQuery = 'SELECT Id, Name, Sold_Quantity__c, SalesAgreementProductId, SalesAgreementProduct.SalesAgreementId, Year__c, '+
                                    +' Quantity_Sold_in_PY__c, Quantity_Sold_in_PY_1__c, SalesAgreementProduct.SalesAgreement.Account.SAP_Code__c, '+
                                    +'SalesAgreementProduct.Product.Product_Code__c, SalesAgreementProduct.SalesAgreement.StartDate FROM SalesAgreementProductSchedule WHERE '+
                                    +'SalesAgreementProduct.SalesAgreement.AccountId =\''+ accId +'\' AND '+
                                    +'Sales_Org__c =\''+ salesOrgCode+'\' AND '+
                                    +'SalesAgreementProduct.SalesAgreement.ScheduleFrequency = \''+ freq +'\' AND '+
                                    +'SalesAgreementProduct.SalesAgreement.ScheduleCount = 1 AND '+
                                    +'CALENDAR_YEAR(SalesAgreementProduct.SalesAgreement.StartDate) ='+ prevPrevYr;

                if(prevPrevSAId != null || String.IsNotBlank(prevPrevSAId)){
                    prevPrevSchedQuery += ' AND SalesAgreementProduct.SalesAgreementId =\''+ prevPrevSAId +'\'';
                }

                prevPrevScheduleList = Database.query(prevPrevSchedQuery);
                //system.debug('prevPrevScheduleList - ' + JSON.serializePretty(prevPrevScheduleList));
                if(prevPrevScheduleList.size()>0){
                    for(SalesAgreementProductSchedule ps2 : prevPrevScheduleList){
                        String key2 = ps2.SalesAgreementProduct.SalesAgreement.Account.SAP_Code__c + ps2.SalesAgreementProduct.Product.Product_Code__c + prevPrevYr;

                        if(prevPrevScheduleMap.containsKey(key2)){
                            SalesAgreementProductSchedule schdl = prevPrevScheduleMap.get(key2);
                            if(schdl.Sold_Quantity__c == null){
                                schdl.Sold_Quantity__c = 0;
                            }
                            if(ps2.Sold_Quantity__c == null){
                                ps2.Sold_Quantity__c = 0;
                            }
                            schdl.Sold_Quantity__c = schdl.Sold_Quantity__c + ps2.Sold_Quantity__c;
                            prevPrevScheduleMap.put(key2,schdl);
                        }
                        else{
                            prevPrevScheduleMap.put(key2,ps2);
                        }
                    }
                } 
                //system.debug('prevPrevScheduleMap - ' + JSON.serializePretty(prevPrevScheduleMap));
                for(SalesAgreementProductSchedule ps3 : scheduleList){
                    String key3 = ps3.SalesAgreementProduct.SalesAgreement.Account.SAP_Code__c + ps3.SalesAgreementProduct.Product.Product_Code__c + prevYr;
                    String key4 = ps3.SalesAgreementProduct.SalesAgreement.Account.SAP_Code__c + ps3.SalesAgreementProduct.Product.Product_Code__c + prevPrevYr;

                    if(prevScheduleMap.containsKey(key3)){
                        if(ps3.Quantity_Sold_in_PY__c == null){
                            ps3.Quantity_Sold_in_PY__c = 0;
                        }
                        if(prevScheduleMap.get(key3).Sold_Quantity__c != null){
                            ps3.Quantity_Sold_in_PY__c = prevScheduleMap.get(key3).Sold_Quantity__c;
                        }
                    }

                    if(prevPrevScheduleMap.containsKey(key4)){
                        if(ps3.Quantity_Sold_in_PY_1__c == null){
                            ps3.Quantity_Sold_in_PY_1__c = 0;
                        }
                        if(prevPrevScheduleMap.get(key4).Sold_Quantity__c != null){
                            ps3.Quantity_Sold_in_PY_1__c = prevPrevScheduleMap.get(key4).Sold_Quantity__c;
                        }
                    }
                }
                //system.debug('scheduleList - ' + JSON.serializePretty(scheduleList));
                UPDATE scheduleList;
            }                                                    
        }
        catch(Exception ex){
            system.debug('Exception in updateSchedules method ');
            system.debug('Exception is - ' + ex);
            system.debug('Exception at Line no  - ' + ex.getLineNumber());
        }
    }
}