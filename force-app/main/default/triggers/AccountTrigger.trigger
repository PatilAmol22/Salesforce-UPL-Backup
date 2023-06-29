/*
* Name: AccountTrigger
* Created On: 24 Jan 2018
* Author: Bhavik Devdhar (bhavik.devdhar@skinternational.com)
* Description: Trigger to Map Distributor Depot on After Insert/Update for Order Modules (India/SWAL)
* Description1:- Trigger(before insert,before Update) for validation GSTIN Number with State code and PAN card only for recordType is Prospect(Onboarding) (Modified by Vishal Dated on 31.01.2020) 
* Description2:- Trigger(before delete) For prevent deletion of Distributor Account Added by Amol Patil (SKI)07/06/2023.
* Supporting Classes: AccountTriggerTest (For Test Coverage)
*/
trigger AccountTrigger on Account (after insert, after update,before insert, before update,before delete) {
     if(Trigger.isAfter && Trigger.isUpdate){
          AccountTriggerHandler.updateSalesArea(trigger.new,Trigger.oldMap);
    }
     Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
    
    // Added by Chakresh Verma/Abhinay kurmi
    if(Trigger.isUpdate && Trigger.isAfter && Grz_checkRecursiveTrigger.runOnce()){
        CaseFieldMappingFromAccountHandler.updateCaseFields(Trigger.new);
      
    }
    
    if(Trigger.isAfter){
        
        if(Trigger.isInsert || Trigger.isUpdate) {
            
            //Logic to Map Depot with Distributor in Distributor-Depot Mapping Object
            Set<String> depotCodeSet = new Set<String>();
            Set<String> distributorIdSet = new Set<String>();
            
            for(Account accObj:Trigger.New){
                if(accObj.RecordTypeId == recordTypeId){
                    if(String.isNotBlank(accObj.Depot_Code__c)){
                        depotCodeSet.add(accObj.Depot_Code__c);
                        distributorIdSet.add(accObj.Id);
                    }
                }
            }
            
            //Get recordType for 'Depot' in Depot__c
            Id depotRecordTypeId = Schema.SObjectType.Depot__c.getRecordTypeInfosByName().get('Depot').getRecordTypeId();   
            
            Map<String, String> depotMap = new Map<String, String>();
            
            //Get all Depots in a Map from Trigger.New (depotCodeSet) and Record Type Distributor
            for(Depot__c depotObj:[SELECT Id, Depot_Code__c FROM Depot__c 
                                   WHERE Depot_Code__c IN: depotCodeSet 
                                   AND RecordTypeId=:depotRecordTypeId]){
                                       
                                       depotMap.put(depotObj.Depot_Code__c, depotObj.Id);
                                   }
            System.debug('depotMap: '+depotMap);
            
            //Check if distributor depot mapping exists for the distributor accounts
            //Create a map with composite key ('Account Id'+'Depot Code') to check if depot already mapped for distributor
            Map<String, Distributor_Depot_Mapping__c> ddmMap = new Map<String, Distributor_Depot_Mapping__c>();
            for(Distributor_Depot_Mapping__c ddmObj:[Select id, Distributor__c, Depot__c, 
                                                     Depot__r.Depot_Code__c
                                                     FROM Distributor_Depot_Mapping__c 
                                                     WHERE Distributor__c IN:distributorIdSet]){
                                                         ddmMap.put(ddmObj.Distributor__c+''+ddmObj.Depot__r.Depot_Code__c, ddmObj);
                                                     }
            System.debug('ddmMap: '+ddmMap);
            
            //Two seperate lists for Insert/Update to optimize DML performance
            List<Distributor_Depot_Mapping__c> insertddmList = new List<Distributor_Depot_Mapping__c>();
            List<Distributor_Depot_Mapping__c> updateddmList = new List<Distributor_Depot_Mapping__c>();
            
            for(Account accObj:Trigger.New){
                if(accObj.RecordTypeId == recordTypeId){
                    if(String.isNotBlank(accObj.Depot_Code__c)){
                        if(depotMap.containsKey(accObj.Depot_Code__c)){
                            //If mapping exists, update mapping
                            if(ddmMap.containsKey(accObj.id+''+accObj.Depot_Code__c)){
                                Distributor_Depot_Mapping__c ddmObj = ddmMap.get(accObj.Id+''+accObj.Depot_Code__c);
                                ddmObj.Depot__c = depotMap.get(accObj.Depot_Code__c);
                                ddmObj.Distributor__c = accObj.Id;
                                updateddmList.add(ddmObj);
                            }
                            //else create new mapping for distributor-depot
                            else{
                                Distributor_Depot_Mapping__c ddmObj = new Distributor_Depot_Mapping__c();
                                ddmObj.Depot__c = depotMap.get(accObj.Depot_Code__c);
                                ddmObj.Distributor__c = accObj.Id;
                                insertddmList.add(ddmObj);
                            }
                        }
                    }
                }
            }
            
            //If depot mapping does not exist new mapping is created and it will be added to 'insertddmList' for insertion
            if(!insertddmList.isEmpty()){
                insert insertddmList;
            }
            System.debug('After insertddmList: '+insertddmList);            
            
            //If depot mapping exists then it will be added to 'updateddmList' for updation
            if(!updateddmList.isEmpty()){
                update updateddmList;
            }
            System.debug('After updateddmList: '+updateddmList);
            
            //End of Logic
        }
    }
    
    // isBefore logic created By Vishal Pawar for validation of GSTN 
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate) && Grz_checkRecursiveTrigger.runOnce()){
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        system.debug('Sayan00 record type-->'+devRecordTypeId);
        system.debug('Sayan00 user id-->'+userinfo.getUserId());
        List<Division__c> divList =  new List<Division__c>();
        divList = [Select Id,Name,Division_Code__c From Division__c];
        
        Map<String,String> divCodeVsIDMap = new Map<String,String>();
        for(Division__c divObj:divList){
            divCodeVsIDMap.put(divObj.Division_Code__c, divObj.Id);
        }
        
        System.debug('divCodeVsIDMap--> '+divCodeVsIDMap);
        System.debug('inside Trigger.isBefore ');
        Map<id,String> StateTaxStrMap = new Map<id,String>();
        List<State_Tax_Structure__c> sTacstrucList = [Select Id,GST_State_Code__c From State_Tax_Structure__c];
        for(State_Tax_Structure__c sstObj :sTacstrucList){
            StateTaxStrMap.put(sstObj.Id,sstObj.GST_State_Code__c);
        }
        
        Map<String,Pin_Code__c> mapOfPincode = new Map<String,Pin_Code__c>();
        Set<String> billingPostalCode = new Set<String>();
        for(Account accObj : Trigger.new){  
            if(accObj.BillingPostalCode != null){
                billingPostalCode.add(accObj.BillingPostalCode);
            }
        }
        
        if(!billingPostalCode.isEmpty()){
            for(Pin_Code__c pincode : [SELECT ID,Name,District__c FROM Pin_Code__c WHERE Name In : billingPostalCode]){  
                if(pincode.Name != null){
                    mapOfPincode.put(pincode.Name,pincode);
                }
            }
        }        
        
        for(Account accObj:Trigger.New){
            if(accObj.RecordTypeId == devRecordTypeId){
                if(accObj.Country__c.containsIgnoreCase('SWAL') || accObj.Country__c.containsIgnoreCase('India')){
                    if(mapOfPincode.containsKey(accObj.BillingPostalCode)){
                        accObj.Pin_Code__c = mapOfPincode.get(accObj.BillingPostalCode).Id;
                        accObj.District__c = mapOfPincode.get(accObj.BillingPostalCode).District__c;
                    }else{
                        accObj.BillingPostalCode.addError('Invalid PIN CODE');
                    }
                    
                    System.debug('Division_Code__c  vs Map--> '+accObj.Division__c+' VS '+divCodeVsIDMap.get('10'));   //division code restriction as per CR doc,  accObj.Division__r.Division_Code__c!='10'
                    if((accObj.Country__c=='SWAL' && (divCodeVsIDMap.get('10')!=accObj.Division__c && divCodeVsIDMap.get('92')!=accObj.Division__c)))
                    {
                        accObj.Division__c.addError('Invalid Division Code');   
                    }
                    System.debug('@@@ GSTN Number From Account '+accObj.Tax_Number_3__c);
                    System.debug('@@@ State code from '+accObj.State_Tax_Structure__c); 
                    System.debug('@@@ pan card Number  '+accObj.PAN_Number__c);
                    integer lenGSTN =0;
                    String gstn = accObj.Tax_Number_3__c;
                    String custClassification = accObj.Customer_Classification__c;
                    System.debug('@@@ custClassification '+custClassification);
                    
                    // 2 means B2C (Non Registered for GST)
                    if(custClassification!='2'){
                        if(gstn!=null){
                            lenGSTN = gstn.length(); 
                            System.debug('lenGSTN length '+lenGSTN);    
                            
                            if(gstn!='' && lenGSTN == 15){
                                System.debug('Inside Condition ');
                                String stateCode = gstn.substring(0,2);
                                String stateCodeFromSSt = StateTaxStrMap.get(accObj.State_Tax_Structure__c);
                                String panCard = gstn.substring(2,12);
                                
                                if(stateCode != stateCodeFromSSt || panCard != accObj.PAN_Number__c){
                                    accObj.Tax_Number_3__c.addError('Invalid GSTIN format.');
                                }else{
                                    System.debug('Success Account Created ');
                                }
                            }else{
                                accObj.Tax_Number_3__c.addError('GSTIN should be 15 digit.');
                            }
                        }else{
                            accObj.Tax_Number_3__c.addError('GSTIN should not be Empty.');
                        }
                    }else{
                        if(gstn!=null){
                            lenGSTN = gstn.length();  
                        }
                        
                        System.debug('gstn B2C '+gstn);
                        if(gstn!=null){
                            if(lenGSTN == 15){
                                System.debug('Inside Condition ');
                                String stateCode = gstn.substring(0,2);
                                
                                String stateCodeFromSSt = StateTaxStrMap.get(accObj.State_Tax_Structure__c);
                                String panCard = gstn.substring(2,12);
                                
                                if(stateCode != stateCodeFromSSt || panCard != accObj.PAN_Number__c){
                                    accObj.Tax_Number_3__c.addError('Invalid GSTIN format.');
                                }else{
                                    System.debug('Success Account Created ');
                                }
                            }else{
                                accObj.Tax_Number_3__c.addError('GSTIN should be 15 digit.');
                            }
                            
                        }
                        
                    }   
                }
            }      
        }// isInsert End
        
    }// Trigger.isBefore End
    
     //Added by Amol Patil (SKI) 07/06/2023 //Start//
        //Discription:- Prevent Delete record of Wholesaler(Distributor) record type 
        if(Trigger.isDelete && Trigger.isBefore){
        system.debug('@@@@@Enter');
            for(Account acct : trigger.old)
            {
                if ((acct.RecordTypeId== recordTypeId) && (acct.Account_Type__c == 'Sold To Party')
                    && (acct.Sales_Org_Code__c == '2191' || acct.Sales_Org_Code__c == '2192'))          
                {      
                    acct.addError('This Account Cannot be deleted');          
                }
            }
        }
        //Added by Amol Patil (SKI) 07/06/2023 //End//
        
    // Added by kuhinoor for HFX 
    if(Trigger.operationType == TriggerOperation.BEFORE_INSERT || Trigger.operationType == TriggerOperation.BEFORE_UPDATE){
        VillageMappingHandler.beforeInsertUpdate(Trigger.new, Trigger.oldMap, Trigger.isInsert, Trigger.isUpdate);
    }
    
    // RITM0566084 (To Update Account Owner for NAM when Territory is changed) Added by GRZ (Nikhil Verma) 03-06-2023
    if(Trigger.isBefore && Trigger.isUpdate){
        AccountTriggerHandler.updateAccountOwnerNAM(Trigger.new, Trigger.oldMap);
        //Description: Farmer first Implementation Project - Stamp the Expiry Date based on Gold or Silver selection.
        AccountTriggerHandler.caputureExpiryDate(Trigger.new, Trigger.oldMap,false,true);
    }
    
    //Description: Farmer first Implementation Project - Stamp the Expiry Date based on Gold or Silver selection.
    if(Trigger.isBefore && Trigger.isInsert){
        AccountTriggerHandler.caputureExpiryDate(Trigger.new, Trigger.newMap,true,false);
    }
   
}