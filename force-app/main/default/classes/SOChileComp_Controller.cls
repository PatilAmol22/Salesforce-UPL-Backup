public class SOChileComp_Controller {
	public String selectedId {get;set;}
    public String salesOrgCode {get;set;}
    public static Boolean userProfileAllowed {get;set;}
    
    public SOChileComp_Controller(Apexpages.Standardsetcontroller cont){
        Id id1 = UserInfo.getProfileId();
		userProfileAllowed = false;        
        System.debug('******************Profile ID' +id1);
        String userProfile = [Select Name from Profile where Id =:id1].Name;
        if(userProfile == 'Chile Customer Service' || userProfile== 'System Administrator' || userProfile=='Chile Read Only'){ //CR#169 -Chile Margin Block -SKI- kalpesh chande - 02/02/2023 
            userProfileAllowed = true;
        }
        System.debug('SalesOrgCode');
        String recordId = ApexPages.currentpage().getparameters().get('recordId');    
        if( String.isNotBlank(recordId)){
            selectedId = recordId;
            Account Acc = [Select Id, Sales_Org_Code__c From Account Where Id =: selectedId];
            salesOrgCode = Acc.Sales_Org_Code__c;
            System.debug('SalesOrgCode'+SalesOrgCode);
        }
        else{
            salesOrgCode='0000';
            System.debug('SalesOrgCode'+SalesOrgCode);
        }
    }
}