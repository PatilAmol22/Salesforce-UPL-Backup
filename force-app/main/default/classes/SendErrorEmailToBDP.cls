/*******************************************************************************************
* @Name         SendErrorEmailToBDP
* @Author       Paresh Sondigara <paresh.sondigara@skinternational.com>
* @Date         19/9/2022
* @Group        SKI
* @Description  This class contains all service methods related to SendErrorEmailToBDP).
*******************************************************************************************/
public class SendErrorEmailToBDP {
    /*
    * @Description  Method used to remove permission sets('DPE Permission set','Data Pipeline Base User') from Brazil Demand Planner.
    * @Param        NA
    * @return       NA
    */
	@InvocableMethod(label='Send Error Email')
    public static void sendErrorEmail(){
        
        List<PermissionSet> ps= [SELECT Id, Name FROM PermissionSet where Name IN ('DPE_Permission_Set','AnalyticsStoreUser')];
        List<PermissionSetLicense> psc =[SELECT Id FROM PermissionSetLicense where MasterLabel='Data Pipelines Base User'];
        Set<Id> permissionSetId = new Set<Id>();
        Set<Id> PermissionSetLicenseId = new Set<Id>();
        for(PermissionSet p : ps){
            permissionSetId.add(p.Id);
        }
        for(PermissionSetLicense pl : psc){
            PermissionSetLicenseId.add(pl.Id);
        }
        
        List<PermissionSetAssignment> psa = [SELECT Id FROM PermissionSetAssignment WHERE PermissionSetId IN :permissionSetId];
        if(psa.size()>0){
            delete psa;
        }        
                
        List<PermissionSetLicenseAssign> psla = [SELECT Id, PermissionSetLicenseId FROM PermissionSetLicenseAssign WHERE PermissionSetLicenseId IN :PermissionSetLicenseId]; 
        if(psla.size()>0){
            delete psla;
        }
        
        sendMailToBDP();
    }
    
    /*
    * @Description  Method used to send an error mail to brazil demand planners when data processing engine fails.
    * @Param        NA
    * @return       NA
    */
    @future
    public static void sendMailToBDP(){        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);        
        mail.setToAddresses(new String[] { System.Label.Email_Sent_to_SalesRep_or_SDM });
        mail.setCharset('UTF8');
        mail.setBccSender(false);
        mail.setUseSignature(false); 
        mail.setSubject(System.Label.Pricebook_upload_failed);
        mail.setHtmlBody(System.Label.Dear_User+',<br/><br/>'+System.Label.Failed_to_update_the_Pricebook_and_Sales_Agreement+'<br />'+System.Label.Please_do_not_proceed_with_Forecast_Generation_and_Update_Metrics_activity_until+'<br /><br />'+System.Label.Regards+',<br/>'+System.Label.UPL_Salesforce_Administrator+'<br/>');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });		
    }
}