@isTest
public class InterdictionProcessEditControllerTest {
    @testSetup static void GetData() {
        InterdictionProcessInstanceSetting__c custInstance =new InterdictionProcessInstanceSetting__c();
      custInstance.Sim__c=0;
     custInstance.Nao__c=0;
        custInstance.Name='test record';
     insert custInstance;
    }
 static testMethod void testMethod1() {
    InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
     Interdiction_Process__c ip=new Interdiction_Process__c();
         
         ip.IS_AN_INTERDICTION__c='Sim';
         ip.TERM_NUMBER__c='123';
         ip.DUE_DATE__c=system.today();
         ip.PRIORITY__c='URGENTE';
         ip.REASON__c='EMBALAGEM';
         ip.CNPJ_CPF__c='test';
         ip.INSCRI_O_ESTADUAL__c='test';
         ip.CITY__c='Panchkula';
         ip.STATE__c='Haryana';
         ip.RAZ_O_SOCIAL__c='test';
         ip.Contact__c='1223445666';
         ip.AGENT_EMAIL_Brazil__c='123@gmail.com';
         insert ip;
     Test.startTest();
     InterdictionProcessEditController.getInterRecords(ip.Id);
     Test.stopTest();
         
    }
     static testMethod void testMethod2() {
         InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
      Interdiction_Process__c ip=new Interdiction_Process__c();
         
         ip.IS_AN_INTERDICTION__c='Sim';
         ip.TERM_NUMBER__c='123';
         ip.DUE_DATE__c=system.today();
         ip.PRIORITY__c='URGENTE';
         ip.REASON__c='EMBALAGEM';
         ip.CNPJ_CPF__c='test';
         ip.INSCRI_O_ESTADUAL__c='test';
         ip.CITY__c='Panchkula';
         ip.STATE__c='Haryana';
         ip.RAZ_O_SOCIAL__c='test';
         ip.Contact__c='1223445666';
         ip.AGENT_EMAIL_Brazil__c='123@gmail.com';
         insert ip;
         Interdiction_Process__c ipro=[Select id,Status__c,IS_AN_INTERDICTION__c,TERM_NUMBER__c,DUE_DATE__c,PRIORITY__c,REASON__c,CNPJ_CPF__c,INSCRI_O_ESTADUAL__c,CITY__c,STATE__c,RAZ_O_SOCIAL__c,Contact__c,AGENT_EMAIL_Brazil__c from Interdiction_Process__c where id=:ip.id ];
         if(ipro!=null){
         ipro.Contact__c='12378990';
         update ipro;
         }
        
         Interdiction_Product__c iproduct=new Interdiction_Product__c();
         iproduct.Name='testproduct';
         iproduct.Batch__c='12';
         iproduct.Expire_Date__c=System.today();
         iproduct.Quantity__c='12';
        insert iproduct;
         List<id> proList=new List<Id>();
         proList.add(iproduct.id);
         
      
     String json = '[{"name":"testproduct1","Batch__c":"12","Expire_Date__c":"2023-06-03","Quantity__c":"12"}]';
         //String s=JSON.serialize(json);
         Test.startTest();
         InterdictionProcessEditController.getUserInfo();
        InterdictionProcessEditController.updateRecords(ipro,ip.Id);
         InterdictionProcessEditController.updateProductRecords(ip.Id,json);
        InterdictionProcessEditController.getInterProductRecords(ip.Id);
      InterdictionProcessEditController.DeleteProductRecords(proList);
         Test.stopTest();
    }
    static testMethod void testMethod3(){
        List<Id> idList=new List<Id>();
        InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
      Interdiction_Process__c ip=new Interdiction_Process__c();
         
         ip.IS_AN_INTERDICTION__c='Sim';
         ip.TERM_NUMBER__c='123';
         ip.DUE_DATE__c=system.today();
         ip.PRIORITY__c='URGENTE';
         ip.REASON__c='EMBALAGEM';
         ip.CNPJ_CPF__c='test';
         ip.INSCRI_O_ESTADUAL__c='test';
         ip.CITY__c='Panchkula';
         ip.STATE__c='Haryana';
         ip.RAZ_O_SOCIAL__c='test';
         ip.Contact__c='1223445666';
         ip.AGENT_EMAIL_Brazil__c='123@gmail.com';
         insert ip;

        ContentVersion cv = new ContentVersion(
            Title = 'Some document',
            PathOnClient = 'some document.txt',
            VersionData = Blob.valueOf('Lorem ipsum dolor sit amet...')
        );
        insert cv;
        if(cv.Id!=null){
         Id documentID= [SELECT Id FROM ContentDocument WHERE LatestPublishedVersionId = :cv.Id].Id;
         IdList.add(documentID);
        }
       
      
        Test.startTest();
         InterdictionProcessEditController.updateFileRecordOnCV(IdList,ip.Id);
        InterdictionProcessEditController.DeleteFilesOnChange(IdList);
        //InterdictionProcessEditController.InterdictionProcessEditController(IdList);
        Test.stopTest();

       
    }



    
}