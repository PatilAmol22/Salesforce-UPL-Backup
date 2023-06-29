@isTest 
public class InterdictionProcessControllerTest {
     @testSetup static void setup() {
          InterdictionProcessInstanceSetting__c custInstance =new InterdictionProcessInstanceSetting__c();
      custInstance.Sim__c=0;
     custInstance.Nao__c=0;
        custInstance.Name='test record';
     insert custInstance;
        Interdiction_Process__c ip=new Interdiction_Process__c();
         
         ip.IS_AN_INTERDICTION__c='Sim';
         ip.TERM_NUMBER__c='123';
         ip.DUE_DATE__c=system.today();
         ip.PRIORITY__c='URGENTE';
         ip.REASON__c='EMBALAGEM';
         ip.CNPJ_CPF__c='test';
         ip.INSCRI_O_ESTADUAL__c='test';
         ip.CITY__c='Panchkula';
        ip.Instance_Number__c='REC0011';
         ip.RAZ_O_SOCIAL__c='test';
         ip.Contact__c='1223445666';
         ip.AGENT_EMAIL_Brazil__c='123@gmail.com';
         insert ip;
             
    }
    static testMethod void testMethod1() {
        
         //String json = '[{"IS_AN_INTERDICTION__c":"Sim","TERM_NUMBER__c":"12","DUE_DATE__c":"2023-06-03","PRIORITY__c":"URGENTE","REASON__c":"EMBALAGEM","CNPJ_CPF__c":"test","INSCRI_O_ESTADUAL__c":"test","CITY__c":"Panchkula","STATE__c":"Haryana","RAZ_O_SOCIAL__c":"test","Contact__c":"1224567","AGENT_EMAIL_Brazil__c":"123@gmail.com"}]';
        String json='[{"value":"Sim","key":"IS_AN_INTERDICTION__c"},{"value":"PRAZO CURTO","key":"PRIORITY__c"},{"value":"VALIDADE VENCIDA","key":"REASON__c"},{"value":"vv","key":"CNPJ_CPF__c"},{"value":"nn","key":"INSCRI_O_ESTADUAL__c"},{"value":"bb","key":"RAZ_O_SOCIAL__c"},{"value":"234555","key":"Contact__c"},{"value":"123@gmail.com","key":"AGENT_EMAIL_Brazil__c"},{"value":"bb","key":"STATE__c"},{"value":"07/02/2023","key":"DUE_DATE__c"},{"value":"Panchkula","key":"CITY__c"}]';
         InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        Test.startTest();
        InderdictionProcessController.saveDetails(json);
        InderdictionProcessController.getPicklistTypeFields();
        Test.stopTest();
    }
     static testMethod void testMethod2() {
         
       Id ip=[Select id,IS_AN_INTERDICTION__c,TERM_NUMBER__c,DUE_DATE__c,PRIORITY__c,REASON__c,CNPJ_CPF__c,INSCRI_O_ESTADUAL__c,CITY__c,STATE__c,RAZ_O_SOCIAL__c,Contact__c,AGENT_EMAIL_Brazil__c from Interdiction_Process__c].id;
       InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
         List<Interdiction_Product__c > ipList=new  List<Interdiction_Product__c >();
         Interdiction_Product__c iproduct=new Interdiction_Product__c();
         iproduct.Name='testproduct';
         iproduct.Batch__c='12';
         iproduct.Expire_Date__c=System.today();
         iproduct.Quantity__c='12';
         ipList.add(iproduct);
      
     String json = '[{"name":"xyz","Batch__c":"12","Expire_Date__c":"2023-06-03","Quantity__c":"12"}]';
        
         Test.startTest();
         
         InderdictionProcessController.saveProductDetails(ip,json);
        
     
         Test.stopTest();
    }
    static testMethod void testMethod3(){
         InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        List<Id> idList=new List<Id>();
    Id ip=[Select id,IS_AN_INTERDICTION__c,TERM_NUMBER__c,DUE_DATE__c,PRIORITY__c,REASON__c,CNPJ_CPF__c,INSCRI_O_ESTADUAL__c,CITY__c,STATE__c,RAZ_O_SOCIAL__c,Contact__c,AGENT_EMAIL_Brazil__c from Interdiction_Process__c].id;

        ContentVersion cv = new ContentVersion(
            Title = 'Some document',
            PathOnClient = 'some document.txt',
            VersionData = Blob.valueOf('Lorem ipsum dolor sit amet...')
        );
        insert cv;
        if(cv!=null){
       Id documentID= [SELECT Id FROM ContentDocument WHERE LatestPublishedVersionId = :cv.Id].Id;
         System.debug('cdoc'+documentID);
         IdList.add(documentID);
        }
        Test.startTest();
         InderdictionProcessController.updateFileRecord(ip,IdList);
        InderdictionProcessController.updatecheckBoxFileRecord(IdList);
       InderdictionProcessController.getProduct();
        Test.stopTest();

       
    }
    static testMethod void testMethod4(){
         InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
        List<Id> idList=new List<Id>();
      ContentVersion cv = new ContentVersion(
            Title = 'Some document',
            PathOnClient = 'some document.txt',
            VersionData = Blob.valueOf('Lorem ipsum dolor sit amet...')
        );
        insert cv;
       Id documentID= [SELECT Id FROM ContentDocument WHERE LatestPublishedVersionId = :cv.Id].Id;
         System.debug('cdoc'+documentID);
         IdList.add(documentID);
        List<ContentVersion> cvList=new List<ContentVersion>();
        if(documentID!=null){
        ContentVersion content=[SELECT AutoFileUpload__c,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId=:documentID];
        
            content.AutoFileUpload__c=true;
        
        cvList.add(content);
        }
        if(cvList.size()>0 && !cvList.isEmpty()){
        update cvList;
        System.debug(' after cvList@@ '+cvList[0].AutoFileUpload__c);
        }
       
        Test.startTest();
        InderdictionProcessController.DeleteFilesOnChange(IdList);
        Test.stopTest();

       
    }
    static testMethod void testMethod5(){
         InterdictionProcessInstanceSetting__c DataFromInterdictioncustom=[Select id,Sim__c, Nao__c from InterdictionProcessInstanceSetting__c ];
                 List<String> ipList=new  List<String >();
                Interdiction_Process__c ip=new Interdiction_Process__c();
         
         ip.IS_AN_INTERDICTION__c='Sim';
         ip.TERM_NUMBER__c='123';
         ip.DUE_DATE__c=system.today();
         ip.PRIORITY__c='URGENTE';
         ip.REASON__c='EMBALAGEM';
         ip.CNPJ_CPF__c='test';
         ip.INSCRI_O_ESTADUAL__c='test';
         ip.CITY__c='Panchkula';
        
         ip.RAZ_O_SOCIAL__c='test';
         ip.Contact__c='1223445666';
         ip.AGENT_EMAIL_Brazil__c='123@gmail.com';
         insert ip;
          Interdiction_Process__c ip1=new Interdiction_Process__c();
         
         ip1.IS_AN_INTERDICTION__c='Não';
         ip1.TERM_NUMBER__c='123';
         ip1.DUE_DATE__c=system.today();
         ip1.PRIORITY__c='URGENTE';
         ip1.REASON__c='EMBALAGEM';
         ip1.CNPJ_CPF__c='test';
         ip1.INSCRI_O_ESTADUAL__c='test';
         ip1.CITY__c='Panchkula';
        
         ip1.RAZ_O_SOCIAL__c='test';
         ip1.Contact__c='1223445666';
         ip1.AGENT_EMAIL_Brazil__c='123@gmail.com';
         insert ip1;
        ipList.add(ip.id);
        ipList.add(ip1.id);
        System.debug('ipList'+ipList);
        Test.startTest();
        //InterdictionInstanceNumberHandler.updateInstanceNumber(ipList);
        Test.stopTest();
        
        
    }

}