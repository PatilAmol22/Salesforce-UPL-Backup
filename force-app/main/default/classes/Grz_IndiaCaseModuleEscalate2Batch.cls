public class Grz_IndiaCaseModuleEscalate2Batch implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful {
    
    BusinessHours bh = [SELECT Id, Name FROM BusinessHours WHERE Name = 'IndiaCaseModuleBH'];
    public Database.QueryLocator start(Database.BatchableContext BC){
    //DateTime currTime = System.now();
    //system.debug('currTime ==>'+currTime );
    //DateTime hrBefore = currTime.addHours(-24);
    //system.debug('hrBefore ==>'+hrBefore);
    
        return Database.getQueryLocator('Select Id, CreatedById, sub_category__c, Escalation_Level__c, catesub__c, LastModifiedDate, level2__c, Is_Auto_Escalated__c,  Count_Open_Values__c, status, CaseOwner__c, CaseNumber, CaseCommentdate__c, Type From Case WHERE Recordtype.Name = \'Distributor\' AND Catesub__c != null AND sub_Category__c != null AND Escalation_Level__c =\'\' AND Is_Auto_Escalated__c = false  AND  Count_Open_Values__c < 2  AND Status !=\'Closed\'  AND CaseOwner__c!=\'\' ');  //   AND ID = \'5001m000006qMrPAAU\' LIMIT 1     
                           //  Comment_updated_in_24_hrs__c!=true ' AND Is_Auto_Escalated__c = false     
    }
    
    public void execute(Database.BatchableContext BC, List<Case> scope){
		System.debug('Grz_IndiaCaseModuleEscalate2Batch execute');        
        List<Id> escComplain24Hrs = new List<Id>();
        List<Id> escRequest48Hrs = new List<Id>();
        
        for(Case c:scope){
            DateTime startdate;
            if(c.CaseCommentDate__c != null){
                   startdate = c.CaseCommentDate__c;
            }
            else{
                   startdate = c.LastModifiedDate;
            }
            
            DateTime systemnow = system.now();
            long startl = startdate.getTime();
            long nowl   = systemnow.getTime();
            long diffl  = BusinessHours.diff(bh.id,startdate,systemnow);
            //system.debug('startl: ' + startl);
            //system.debug('nowl: '   + nowl);
            //system.debug('nowl - startl: ' + (nowl - startl));
            //system.debug('diffl: '  + diffl);
            Integer hour1 = Integer.ValueOf(Label.Grz_24Hours); // Added by Swaran(Grazitti) APPS-4632
             Integer hour2 = Integer.ValueOf(Label.Grz_48Hours);
             System.debug('hour1---' +hour1);
             System.debug('hour2-----' +hour2);
            
            System.debug('c.CateSub__c' + c.CateSub__c);
            System.debug('c.Sub_Category__c' + c.Sub_Category__c);
            if(c.catesub__c != null && c.CateSub__c == 'Complaint' && diffl >=  hour1){  //  600  // 86400000
                  if(c.Sub_Category__c == 'Invoice, Schemes & Discount related' || c.Sub_Category__c == 'Dispatch related' || c.Sub_Category__c == 'Payments & Receipts' || c.Sub_Category__c == 'Product Availability' || c.Sub_Category__c == 'Product Complaints by Farmers' ||  c.Sub_Category__c == 'Product Leakage / damage while shipping' || c.Sub_Category__c == 'Product related'  || c.Sub_Category__c == 'Quality Complaint'){
                       escComplain24Hrs.add(c.Id);
                 }
            }
            if(c.CateSub__c != null && c.CateSub__c == 'Request' && diffl >= hour2){  //  1000  172800000
               if(c.Sub_Category__c == 'Credit Limit' || c.Sub_Category__c == 'Outstanding' || c.Sub_Category__c == 'Account Related' || c.Sub_Category__c == 'Customer master updation' || c.Sub_Category__c == 'Order Cancellation' ||c.Sub_Category__c == 'Order Update' ||c.Sub_Category__c == 'Schemes & Price Communication from HO' ){
                       escRequest48Hrs.add(c.Id);     
               }
            }
        }
        
        System.debug('escComplain24Hrs==> '+escComplain24Hrs.size());
        System.debug('escRequest48Hrs==> '+escRequest48Hrs.size());
        if(!escComplain24Hrs.isEmpty()){
                Grz_CaseDetailClass.escalatePortalCase(escComplain24Hrs,'Batch');  // original  Grz_CaseDetailClass  //  Grazitti_IndiaCaseModuleController
        }
        if(!escRequest48Hrs.isEmpty()){
                Grz_CaseDetailClass.escalatePortalCase(escRequest48Hrs,'Batch');  // original  Grz_CaseDetailClass  //  Grazitti_IndiaCaseModuleController
        }
    }
    
    public void finish(Database.BatchableContext BC){
       // if(!caseList.isEmpty()){
       //     ID jobID = System.enqueueJob(new Grz_SendSmsQueueableClass(caseList));
       // }
    }

}