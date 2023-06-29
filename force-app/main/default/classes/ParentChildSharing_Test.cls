@isTest(SeeAllData=true)
public class ParentChildSharing_Test{
    public static testMethod void test(){
        Account parent = [select Id, Name from Account where Name='グリーンテック（株）' and Account_Type__c='Sold To Party'];
        Account child = [select Id, Name from Account where Name='グリーンテック（株）　熊本営業所' and Account_Type__c='Sold To Party'];
        
        Parent_Child_Mapping__c pcm = new Parent_Child_Mapping__c();
        pcm.Active__c=true;
        pcm.Parent_Account__c=parent.Id;
        pcm.Child_Account__c=child.Id;
        
        Test.startTest();
        
        insert pcm;
        
        pcm.Active__c = false;
        update pcm;
        
        pcm.Active__c = true;
        update pcm;
        
        delete pcm;
        
        Test.stopTest();
        
    }
}