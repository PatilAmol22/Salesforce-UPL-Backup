@isTest
public class MyCustomControllerTest {
    
    static testmethod void InformationBlast() {
        
        Information_Blast__c IB = new Information_Blast__c();
        IB.Information_1__c = 'test data';
        IB.Information_2__c = 'test data';
        IB.Information_3__c = 'test data';
        IB.Information_4__c = 'test data';
        IB.Information_5__c = 'test data';
        
        insert IB;
        
        MyCustomController mccObj = new MyCustomController();
    }

static testmethod void InformationBlast1() {
        
        Information_Blast__c IB = new Information_Blast__c();
        
        insert IB;
        
        MyCustomController mccObj = new MyCustomController();
    }
    
}