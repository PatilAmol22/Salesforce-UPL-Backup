/*
* Name: CaseTrigger
* Created On: 8 Nov 2015
* Author: Anant (anant.agarwal@comprotechnologies.com)
*  Description: Trigger is used to create a child object(SMS FO) of Employee on case when Neebal Integration Status=Ready For
*  Creation and Status=Closed or Escalated-L2
* Change Log History:
* |---------------------------------------------------------------------------|
* | Version | Changes By | Date      | Description                            |
* |---------------------------------------------------------------------------|
* |   0.1   | Anant      | 8-11-15   | Initial version of trigger             |
* |   0.2   | Anant      | 7-12-15   | Send SMS On Escalated L2 or Other  
|   0.3   | Anant      | 11-12-15  | SMS_Sent__c Checkbox on Case           |     
* |---------------------------------------------------------------------------| 
*/


trigger CaseTrigger on Case (before insert, after insert, after update, before update) {
    List<Case> c=new List<Case>();
    List<Id> villageIdList = new List<Id>();
    Map <Id, Id> caseIdMap = new Map<Id, Id>();
    
    List<SMS_Fo__c> sfList = new List<SMS_Fo__c>();
    
    Map<Id,Case> caseMap=new Map<Id,Case>();

    for(Case cse : [SELECT Account.Id, Account.Village__pc, Account.FirstName, Account.LastName, Account.PersonContact.MobilePhone, Account.Village__pr.Name, IsClosed, Products_Recommended__c, Status, Subject, SMS_Sent__c From Case WHERE Id IN: Trigger.New AND Neebal_Integration_Status__c='Ready for Creation' AND SMS_Sent__c=true]){
      System.debug('cse=====>'+cse); 
        if(trigger.isUpdate)                                    // Update Trigger
        {
            
            if(trigger.oldMap.get(cse.Id).SMS_Sent__c <>true )
            {
                /* Creating a list of villages related to the case account */
                villageIdList.add(cse.Account.Village__pc);
                caseIdMap.put(cse.Account.Village__pc, cse.Id); // Map containing village id and case id
                caseMap.put(cse.Id,cse);                        //Map containing case id and case 
                
                /*  prodRecomendMap.put(cse.Id,cse.Products_Recommended__c);
                statusMap.put(cse.Id,cse.Status);
                isClosedMap.put(cse.Id,cse.IsClosed);*/
            }
        }
        else{                                                   // Insert Trigger
            villageIdList.add(cse.Account.Village__pc);
            caseIdMap.put(cse.Account.Village__pc, cse.Id);    
            caseMap.put(cse.Id,cse);
            /*prodRecomendMap.put(cse.Id,cse.Products_Recommended__c);
            statusMap.put(cse.Id,cse.Status);
            isClosedMap.put(cse.Id,cse.IsClosed);*/
        }
        
    }
    System.debug('Villages : '+villageIdList);
    /* Creating a child object of Employee Object */
    for(Employee_Village_Mapping__c evm : [SELECT Employee__c, Village__c FROM Employee_Village_Mapping__c WHERE Village__c IN: villageIdList AND Active__c=true AND (From__c<=:System.today() AND To__c>=:System.today()) AND Employee__r.Active__c=:true ]){
        SMS_FO__c s = new SMS_FO__c();
        if(caseIdMap.get(evm.Village__c) <> NULL)
            s.Case__c = caseIdMap.get(evm.Village__c);
        s.Employee__c = evm.Employee__c;
        if(caseMap.get(caseIdMap.get(evm.Village__c)).status=='Escalated-L2')  // Status is Escalated-L2
        {
            s.SMS_Type1__c='Escalated';
        }
        else    //Status is closed
        {
            //Check whether Product recommended is empty or not
            if(caseMap.get(caseIdMap.get(evm.Village__c)).Products_Recommended__c<>NULL ) 
            {
                s.Product_Recommended1__c=caseMap.get(caseIdMap.get(evm.Village__c)).Products_Recommended__c;
                s.SMS_Type1__c='Product Recommended';
            }
            else
            {
                s.Product_Recommended1__c='None';
                s.SMS_Type1__c='Product Recommended';
                //s.SMS_Type1__c='Not Sent';
            }
        }
        
        //s.SMS_Type1__c= statusMap.get(caseIdMap.get(evm.Village__c));
        /* Setting fields of SMS FO Object */
        
        s.Account_First_Name1__c=caseMap.get(caseIdMap.get(evm.Village__c)).Account.FirstName;
        s.Account_Last_Name1__c=caseMap.get(caseIdMap.get(evm.Village__c)).Account.LastName;
        s.Account_Mobile1__c=caseMap.get(caseIdMap.get(evm.Village__c)).Account.PersonContact.MobilePhone;
        s.Account_Village_Name1__c=caseMap.get(caseIdMap.get(evm.Village__c)).Account.Village__pr.Name;
        //s.Subject1__c=caseMap.get(caseIdMap.get(evm.Village__c)).Subject;
        
        sfList.add(s);
    }
    System.debug('sfList :'+sfList);
    if(sfList.size() > 0)
        insert sfList;
    
    /*for(Integer i=0;i<c.size();i++)
    {
    if(c[i].Account.Village__pc!=null)
    {
    e_mapping=[SELECT Employee__c FROM Employee_Village_Mapping__c WHERE Village__c =:c[i].Account.Village__pc ];
    
    for(Integer j=0;j<e_mapping.size();j++)
    {
    SMS_FO__c s=new SMS_FO__c();
    s.Case__c=trigger.New[i].Id;
    s.Employee__c=e_mapping[j].Employee__c;
    sf.add(s);
    }
    }
    }
    insert sf;*/
        /* List<Case> c=Trigger.New;
    List<ID> a;
    List<Account> v;
    List<String> s;
    List<Employee__c> e;
    for(Case ca:c)
    a.add(ca.AccountID);
    v=[SELECT Village__pc FROM Account WHERE Id=:a];
    for(Integer i=0;i<v.size();i++)
    {
    //   s.add(v[i]);
    }
    
    List<Employee_Village_Mapping__c> e_mapping;
    e_mapping=[SELECT Employee_Id__c FROM Employee_Village_Mapping__c WHERE Village__c=:v.Village__pc];*/
    
    //Map to fetch custom setting
    Map<String, Trigger_Settings__c> settingsMap = Trigger_Settings__c.getAll(); 
    Boolean isActive = settingsMap.get('CaseTrigger').IsActive__c;
    System.debug('isActive: '+isActive);
    
    if(isActive){
        //Logic to create new Account on the basis of Email ID, if no Account with the Supplied Email exists on SFDC
        if(Trigger.isBefore){
            CaseTriggerHandler cthObj = new CaseTriggerHandler();
            
            if(Trigger.isInsert){
                cthObj.createAccountfromTask(Trigger.new);
                cthObj.addCropCode(Trigger.new); 
            }
            if(Trigger.isUpdate){
                cthObj.addCropCode(Trigger.new);
            }
        }
        
        
        if(Trigger.isAfter && (!Test.isRunningTest())){
            CaseTriggerHandler cthObj = new CaseTriggerHandler();
            if(Trigger.isInsert||Trigger.isUpdate){
                cthObj.addCaseLineItem(Trigger.new);  
            }
        }
    }
}