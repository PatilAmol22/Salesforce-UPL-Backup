@isTest(seeAllData =false)
public class RetailerUpload_Test {
    
static testMethod void CallRetailerUpload()
{
    
    Document d = new Document();
    d.Name= 'Retailer Upload Template';
    d.FolderId=[select id from folder where name = 'Shared Documents'].id;
    insert d;
    Account acc = TestDataFactory.CreateAccount('0001046736');
    acc.ebid__c='ebid123';
    update acc;
    Sales_Org__c sorg = TestDataFactory.CreateSalesOrgCode();
    RetailerUploadController.getDocument(); 
    RetailerUploadController.returnWrapper results;
    Test.startTest();
   String file='Testr1,t1@gmail.com,2342342342,ebid456,ebid123,s1,s2,s2,chennai,600100,tamilnadu,India,3100,Linked\nTestr1,t1@gmail.com,2342342342,ebid456,ebid123,s1,s2,s2,chennai,600100,tamilnadu,India,3100,Linked\n';
    results= RetailerUploadController.passFileAura(file);

    String filel='Testr1,t1@gmail.com,2342342342,ebid456,ebid123,s1,s2,s2,chennai,600100,tamilnadu,India,3100,Linked\n"Testr1,INC",t1@gmail.com,2342342342,ebid456,ebid123,s1,s2,s2,chennai,600100,tamilnadu,India,3100,Linked\n';
    results= RetailerUploadController.passFileAura(filel);
  	String filebatch='Testr1,t1@gmail.com,2342342342,ebid456,ebid123,s1,s2,s2,chennai,600100,tamilnadu,India,3100,Linked\r\nTestr1,t1@gmail.com,2342342342,ebid456,ebid123,s1,s2,s2,chennai,600100,tamilnadu,India,3100,Linked\r\n';
	RetailerUploadBatch batch= new RetailerUploadBatch(filebatch);
    database.executeBatch(batch,2000);
    String filebatch0='Testr1,t1@gmail.com,2342342342,ebid456,ebid123,s1,s2,s2,chennai,600100,tamilnadu,India,3100,Linked\r\nTestr1,t1@gmail.com,2342342342,ebid456,,s1,s2,s2,chennai,600100,tamilnadu,India,3100,\r\n';
	RetailerUploadBatch batch1= new RetailerUploadBatch(filebatch0);
    database.executeBatch(batch1,2000);
   String filebatch9='Testr1,t1@gmail.com,2342342342,ebid456,ebid123,s1,s2,s2,chennai,600100,tamilnadu,India,3100,Linked\r\nTestr1,null,2342342342,s1,s2,s2,chennai,600100,tamilnadu,India,3100,Linked\r\n';
	RetailerUploadBatch batch9= new RetailerUploadBatch(filebatch0);
    database.executeBatch(batch9,2000);
    String filebatch2='Testr1,t1@gmail.com,2342342342,ebid456,ebid123,s1,s2,s2,chennai,600100,tamilnadu,India,3100,Linked\r\nTestr1,t1@gmail.com,2342342342,ebid456,s1,s2,s2,chennai,600100,tamilnadu,India,3100\r\nTestr1,t1@gmail.com,2342342342,ebid456,ebid123,s1,s2,s2,chennai,600100,tamilnadu,India,3100,Linked\r\n';
	RetailerUploadBatch batch2= new RetailerUploadBatch(filebatch2);
    database.executeBatch(batch1,2000);
    String filesales='Testr1,t1@gmail.com,2342342342,ebid456,ebid123,s1,s2,s2,chennai,600100,tamilnadu,India,3100,Linked\nTestr1,t1@gmail.com,2342342342,ebid456,ebid123,s1,s2,s2,chennai,600100,tamilnadu,India,3200,Linked\n';
    results= RetailerUploadController.passFileAura(filesales);
    String filesales3='Testr1,t1@gmail.com,2342342342,null,ebid123,s1,s2,s2,chennai,600100,tamilnadu,India,3100,Linked\nTestr1,t1@gmail.com,2342342342,ebid456,ebid123,s1,s2,s2,chennai,600100,tamilnadu,India,3200,Linked\n';
    results= RetailerUploadController.passFileAura(filesales3);
   
    Test.stopTest();
    
}
    
static testMethod void CallRetailerUpload1()
{
    Test.startTest();
    Document d = new Document();
    d.Name= 'Retailer Upload Template';
    d.FolderId=[select id from folder where name = 'Shared Documents'].id;
    insert d;
    Account acc = TestDataFactory.CreateAccount('0001046736');
    acc.ebid__c='ebid123';
    update acc;
    Sales_Org__c sorg = TestDataFactory.CreateSalesOrgCode();
    RetailerUploadController.getDocument(); 
    RetailerUploadController.returnWrapper results;
    String file1='Testr1,t1@gmail.com,2342342342,ebid456,ebid1234,s1,s2,s2,chennai,600100,tamilnadu,India,3100,Linked\nTestr1,t1@gmail.com,2342342342,ebid456,ebid1234,s1,s2,s2,chennai,600100,tamilnadu,India,3100,Linked\n';
    results= RetailerUploadController.passFileAura(file1);
    String file3='Testr1,t1@gmail.com,2342342342,ebid456,ebid1234,s1,s2,s2,chennai,600100,tamilnadu,India,3100,Linked\n,t1@gmail.com,2342342342,,ebid1234,s1,s2,s2,chennai,tamilnadu,600100,India,3100,Linked\n';
    results= RetailerUploadController.passFileAura(file3);
    String file4='Testr1,t1@gmail.com,2342342342,ebid456,ebid1234,s1,s2,s2,chennai,600100,tamilnadu,India,3100,Linked\nTestr1,,2342342342,ebid456,ebid1234,s1,s2,s2,chennai,600100,tamilnadu,ndia,3100,Linked\n';
    results= RetailerUploadController.passFileAura(file4);
    String file5='Testr1,t1@gmail.com,2342342342,ebid456,ebid1234,s1,s2,s2,chennai,600100,tamilnadu,India,3100,Linked\nTestr1,t1@gmail.com,,ebid456,ebid1234,s1,s2,s2,chennai,600100,tamilnadu,India,3100,Linked\n';
    results= RetailerUploadController.passFileAura(file5);
    String file6='Testr1,t1@gmail.com,2342342342,ebid456,ebid1234,s1,s2,s2,chennai,600100,tamilnadu,India,3100,Linked\nTestr1,t1@gmail.com,2342342342,,ebid1234,s1,s2,s2,chennai,600100,tamilnadu,India,null,Linked\n';
    //results= RetailerUploadController.passFileAura(file6);
    String file2='Testr1,t1@gmail.com,2342342342,ebid456,ebid1234,s1,s2,s2,chennai,600100,tamilnadu,India,3100,Linked\nTestr2,t2@gmail.com,2342342341,,ebid1234,\n';
    //results= RetailerUploadController.passFileAura(file2); 
    
    //RetailerUploadBatch batch = new RetailerUploadBatch(cc); 
    Test.stopTest();
    
}    

  
}