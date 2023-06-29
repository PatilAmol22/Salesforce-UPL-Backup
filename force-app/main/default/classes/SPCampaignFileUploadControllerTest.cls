@isTest
public class SPCampaignFileUploadControllerTest {
static testMethod void method(){
    Profile p = [SELECT Id FROM Profile WHERE Name = 'Poland(wholesale sales Manager)' LIMIT 1];
    ApexPages.StandardController sc = new ApexPages.StandardController(p);
  SPCampaignFileUploadController fileObjnew= new SPCampaignFileUploadController(sc);
    fileObjnew.getItems();
}
    
}