@isTest
public class TestClassForJavaScriptClass {
    static testMethod void CoverClass(){
        List<Price_Book__c> PriceList = new List<Price_Book__c>();
    
        Price_Book__c pb=new Price_Book__c();
        pb.Name='testbook';
        pb.isActive__c=true;
        insert pb;
       // PriceList.add(pb);
        Test.startTest();
      ApexPages.StandardSetController setCon = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT ID FROM Price_Book__c LIMIT 2]));
setCon.setSelected([SELECT Id  FROM Price_Book__c LIMIT 2]); // this method gives selected records
JavaScriptClass t = new JavaScriptClass(setCon);
JavaScriptClass.setActiveDeactive(); 
        Test.stopTest();
    }
}