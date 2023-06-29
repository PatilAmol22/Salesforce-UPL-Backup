@isTest(SeeAllData=true)
public with sharing class FileUpload_TWB_Test {
     @isTest
    public static void FileUpload_TWBTestmethod(){
        
        String str1 = 'Territory Code,Product Code,Distribution Channel,Division,Budget,Month,Year\n183,71450,20,10,"1,20,000",12,2021\n184,71451,20,10,10000,3,2021';
        ContentVersion cv1=new Contentversion(); 
        cv1.title='TWB'; 
        cv1.PathOnClient ='test'; 
        Blob b1=Blob.valueOf(str1); 
        cv1.versiondata=b1; 
        insert cv1; 
        
        ContentVersion  testContentInsert = [select id, ContentDocumentId from ContentVersion WHERE Id =: cv1.Id];
        
        Test.startTest();  
        FileUpload_TWB.getAllRecordId();
        FileUpload_TWB.getDownloadURLForTemplates();
        FileUpload_TWB.readCSVFile(testContentInsert.ContentDocumentId);
        Test.stopTest(); 

      
    }

}