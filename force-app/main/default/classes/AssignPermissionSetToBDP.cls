/*******************************************************************************************
* @Name         AssignPermissionSetToBDP
* @Author       Paresh Sondigara <paresh.sondigara@skinternational.com>
* @Date         31/5/2022
* @Group        SKI
* @Description  This class contains all service methods related to AssignPermissionSetToBDP).
*******************************************************************************************/
public class AssignPermissionSetToBDP{
    /*
    * @Description  This method used to dynamically assign permission sets('DPE Permission set','Data Pipeline Base User') to Brazil Demand Planner.
    * @Param        NA
    * @return       void
    */    
    @future
    public static void assignPermissionSet(){
        
        List<PermissionSet> ps= [SELECT Id, Name FROM PermissionSet where Name IN ('DPE_Permission_Set','AnalyticsStoreUser')];
        List<PermissionSetAssignment> psa = new List<PermissionSetAssignment>();
        String userId = UserInfo.getUserId();
        System.debug('userId--->'+userId);
        
        PermissionSetAssignment psa1 = new PermissionSetAssignment();
        psa1.PermissionSetId = ps[0].Id;
        psa1.AssigneeId = userId;
        psa.add(psa1);

        PermissionSetAssignment psa2 = new PermissionSetAssignment();
        psa2.PermissionSetId = ps[1].Id;
        psa2.AssigneeId = userId;
        psa.add(psa2);
                           
        Database.SaveResult[] insertPSA = Database.insert(psa,false); 
        Set<Id> insertedPSA = new Set<Id>();
        for(Database.SaveResult result: insertPSA){            
            insertedPSA.add(result.getId());                                                    
        }                
        System.debug('insertedPSA--->'+insertedPSA);                        
    }
    
    /*
    * @Description  Calling future method(removePermissionSet).
    * @Param        NA
    * @return       void
    */
    @InvocableMethod(label='Call Future')
    public static void callFutureMethod(){
        removePermissionSet();
        //Added By Paresh Sondigara : CR#162 
        sendMailToBDP();
    }
    
    /*
    * @Description  Remove dynamically permission sets('DPE Permission set','Data Pipeline Base User') from Brazil Demand Planner.
    * @Param        NA
    * @return       void
    */    
    @future
    public static void removePermissionSet(){  
                        
        List<PermissionSet> ps= [SELECT Id, Name FROM PermissionSet where Name IN ('DPE_Permission_Set','AnalyticsStoreUser')];
        
        //Added By Paresh Sondigara : CR#162
        List<PermissionSetLicense> psc =[SELECT Id FROM PermissionSetLicense where MasterLabel='Data Pipelines Base User'];
        
        Set<Id> permissionSetId = new Set<Id>();
        
        //Added By Paresh Sondigara : CR#162
        Set<Id> PermissionSetLicenseId = new Set<Id>();
        
        for(PermissionSet p : ps){
            permissionSetId.add(p.Id);
        }
        
        //Added By Paresh Sondigara : CR#162
        for(PermissionSetLicense pl : psc){
            PermissionSetLicenseId.add(pl.Id);
        }
        
        //Added By Paresh Sondigara : CR#162        
        List<PermissionSetAssignment> psa = [SELECT Id FROM PermissionSetAssignment WHERE PermissionSetId IN :permissionSetId];
        if(psa.size()>0){
            delete psa;
        }        
        
		//Added By Paresh Sondigara : CR#162        
        List<PermissionSetLicenseAssign> psla = [SELECT Id, PermissionSetLicenseId FROM PermissionSetLicenseAssign WHERE PermissionSetLicenseId IN :PermissionSetLicenseId]; 
        if(psla.size()>0){
            delete psla;
        }
                       
    }
    
    /*
    * @Description  Method used to send process completion mail.
    * @Param        NA
    * @return       void
    */
    @future
    public static void sendMailToBDP(){        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);        
        mail.setToAddresses(new String[] { System.Label.Email_Sent_to_SalesRep_or_SDM });
        mail.setCharset('UTF8');
        mail.setBccSender(false);
        mail.setUseSignature(false);
        //Added By Paresh Sondigara : CR#162
        mail.setSubject(System.Label.Pricebook_updated_successfully);
        //Added By Paresh Sondigara : CR#162
        mail.setHtmlBody(System.Label.Dear_User+',<br/><br/>'+System.Label.Pricebook_entries_and_Sales_Agreements_updated_successfully+'<br /><br />'+System.Label.Regards+',<br/>'+System.Label.UPL_Salesforce_Administrator+'<br/>');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });		
    }
    
    
    
}