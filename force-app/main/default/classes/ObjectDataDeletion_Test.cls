@isTest
public class ObjectDataDeletion_Test{
    
      static testMethod void Method(){
                  
          Test.startTest();
          
          ObjectDataDeletion obj = new ObjectDataDeletion();
          
         
          obj.ObjName = 'BusinessDashboard__c';
          obj.dtObj = System.Today()-10;
          obj.GetObjectOptions();
          
           BusinessDashboard__c bdObj1 = new BusinessDashboard__c();
           
              bdObj1.As_of_now__c = System.today();
              bdObj1.DataErrors__c = 0 ;
              insert bdObj1; 
          
          
          obj.dtObj = System.Today()+10;
          obj.todayDtObj = System.Today()+11;
          obj.DeleteObjData();          
         Test.stopTest();
      }
      
      static testMethod void Method1(){
          Test.startTest();
          
          ObjectDataDeletion obj = new ObjectDataDeletion();
          
          obj.dtObj = System.Today()+1;
          obj.ObjName = 'BusinessDashboard__c';
          obj.GetObjectOptions();
          obj.DeleteObjData();
          
          Test.stopTest();
      }
      
      static testMethod void method3(){
        Test.StartTest();
        Database.executeBatch(new Batch_DelObjectDataOfSpecifiedDate('BusinessDashboardData__c', (System.now()-10)),100);
        Test.stopTest();
    }
    
}