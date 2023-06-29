public class CaseOverride_Controller {
    //public static string lightRecordType;
    @AuraEnabled
    public static List<boolean> getReordInformation(string recId ,string recTypeId, string accId){
        system.debug('recordId>>--->'+recId);
        system.debug('recTypeId>>--->'+recTypeId);
        case caserecord = new case();
        if(!String.isEmpty(recId)){
            caserecord = [Select id ,recordTypeId,caseNumber from case WHERE id =: recId];         
        }
        User u = [SELECT Id, Name,Profile.name FROM USER WHERE id =: userInfo.getUserId()];
        //lightRecordType ='';
        string caseRecordType  = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Data Pattern Calling form').getRecordTypeId();
         string colCaseRecordType  =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Colombia Case').getRecordTypeId();
        List<boolean> booleanList = new List<boolean>();
        List<Farmer_Promotional_Product__c> fppObjList = new List<Farmer_Promotional_Product__c>();
        
        if(recTypeId != caseRecordType){
           
            if(recTypeId != string.valueOf(Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId())){
                
                if(recTypeId == null && u.Profile.name =='Business Center Coordinator Colombia'){
                    booleanList.add(false);
                    booleanList.add(false);
                     //Added by Varun Shrivastava Start
                    booleanList.add(false);
                    //Added by Varun Shrivastava End
                   //Added by prashant chinchpure 2 july 2020 Start
                    booleanList.add(true);
                    //Added by prashant chinchpure End
                    return booleanList;  
                }else{
                    system.debug('--------------------------------------------------------------');
                    booleanList.add(false);
                    booleanList.add(false);
                     //Added by Varun Shrivastava Start
                    booleanList.add(false);
                    //Added by Varun Shrivastava End
                   //Added by prashant chinchpure 2 july 2020 Start
                    booleanList.add(false);
                    //Added by prashant chinchpure End
                    return booleanList;    
                }
                
            }
            else{
                fppObjList =   [select id,Accounts__c,Cases__c,Month__c,Financial_Year__c,Promotional_Product__c from Farmer_Promotional_Product__c where CreatedDate = THIS_MONTH and accounts__c=:accId limit 1];
                if(fppObjList.size()>0){
                    booleanList.add(true);
                    booleanList.add(false);
                    //Added by Varun Shrivastava Start
                    booleanList.add(true);
                    //Added by Varun Shrivastava End
                    //Added by prashant chinchpure 2 july 2020 Start
                booleanList.add(false);
                //Added by prashant chinchpure End
                    return booleanList;
                }else{
                    booleanList.add(false);
                    booleanList.add(false);
                    //Added by Varun Shrivastava Start
                    booleanList.add(true);
                    //Added by Varun Shrivastava End
                    //Added by prashant chinchpure 2 july 2020 Start
                booleanList.add(false);
                //Added by prashant chinchpure End
                    return booleanList;
                }
            }
        }
        else{
           // lightRecordType = recTypeId;
            //system.debug('recTypeId>>--->'+lightRecordType);
            booleanList.add(false);
            booleanList.add(true);
            //Added by Varun Shrivastava Start
            booleanList.add(false);
            //Added by Varun Shrivastava End
            //Added by prashant chinchpure 2 july 2020 Start
                booleanList.add(false);
                //Added by prashant chinchpure End
            return booleanList;
            //return true;
        }
        
    }
    
}