@isTest
public class TestClassForInterdictionpdfGenerator {
    static testMethod void testMethod1() 
    {
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
        ip.STATE__c='Haryana';
        ip.RAZ_O_SOCIAL__c='test';
        ip.Contact__c='1223445666';
        ip.AGENT_EMAIL_Brazil__c='123@gmail.com';
        ip.EMAIL_LOGISTICS_OPERATOR_Brazil__c='testmail@gmail.com';
        insert ip;
        Test.StartTest(); 
        ApexPages.StandardController sc = new ApexPages.StandardController(ip);
        InterdictionPdfgenerator Ipdf = new InterdictionPdfgenerator(sc);
        PageReference pageRef = Page.InterdictionPdfGenerate;
        pageRef.getParameters().put('id', String.valueOf(ip.Id));
        Test.setCurrentPage(pageRef);
        Blob b = blob.valueof('error');
        Try { b = pageRef.getContent();}
        Catch(Exception e)
        {Attachment a = new Attachment(parentId = ip.id, name=ip.Instance_Number__c + '.pdf', body = b);
         insert a;}
        Ipdf.getProduct();
        Test.StopTest();
    }
    
}