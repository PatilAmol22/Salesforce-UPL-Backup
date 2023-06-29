/**************************************************************************************************
* Name             : grz_UpdateAccountOnApprovalTestClass                                                     
* Description      : To cover the Apex class grz_UpdateAccountOnApprovalHandler,grz_UpdateAccountOnAgrementApproval					 
* Created Date     : 19-01-2023                                                                       
* Project/JIRA     : UPL                                                                 
* Created By       : Ranjeet Sharma  (Grazitti)                                                                        
* Last Modified By : Ranjeet Sharma (Grazitti) 19-01-2023                                                                     
**************************************************************************************************/
@isTest
public class grz_UpdateAccountOnApprovalTestClass {
    @istest static void updateAccountOnApprovaltest(){
        
        
        Sales_Org__c objSalesOrg = new Sales_Org__c();
        objSalesOrg.Name = 'test1';
        objSalesOrg.Sales_Org_Code__c = '3710';
        insert objSalesOrg;
        
        
        Id stExam = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        
        Account objAcc = new Account();
        objAcc.RecordTypeId = stExam;
        objAcc.Name = 'Test';
        objAcc.Sales_Org__c = objSalesOrg.Id;
        objAcc.Email__c='taruni.uce@test.com';
        insert objAcc;
        
        Division__c objDiv = new Division__c();
        objDiv.Name = 'Testing';
        objDiv.Division_Code__c = '20';
        insert objDiv;
        
        Distribution_Channel__c objDivChannel = new Distribution_Channel__c();
        objDivChannel.Name = 'Testt';
        objDivChannel.Distribution_Channel_Code__c = '10';
        
        insert objDivChannel;
        
        User us=[select id,email from User where id=:userinfo.getUserId()];
        us.email='taruni.uce@test.com';
        update us;
        System.debug('us>>>'+us);
        
        DistributorSalesAreaMapping__c objSalesArea = new DistributorSalesAreaMapping__c();
        objSalesArea.AccountType__c = 'Bill To Party';
        objSalesArea.Distributor__c = objAcc.Id;
        objSalesArea.Division__c = objDiv.Id;
        objSalesArea.DistributionChannel__c = objDivChannel.Id;
        objSalesArea.SalesOrg__c = objSalesOrg.Id;
        objSalesArea.Stage__c='Pending with customer';
        
        objSalesArea.First_Approver__c= us.Id;
        
        
        insert objSalesArea;
      
        
        
        //Inserting the Agreement
        echosign_dev1__SIGN_Agreement__c agrmt = new echosign_dev1__SIGN_Agreement__c ();
        agrmt.Name = 'Test Agreement Send Auto '+system.now();
        agrmt.echosign_dev1__Message__c = 'test from anonymous block';
        agrmt.echosign_dev1__SignatureOrder__c = 'Recipient signs, then I sign';
        agrmt.echosign_dev1__SignatureType__c = 'e-Signature';
        agrmt.echosign_dev1__Signature_Flow__c = 'Order Entered';
        agrmt.echosign_dev1__SenderSigns__c = true;
        agrmt.echosign_dev1__Recipient_Addresses__c = 'xxxxx@gmail.com,';
        agrmt.Sales_Area__c=objSalesArea.Id;
        
        
        
        insert agrmt;
        
        System.debug('agrmt>>'+agrmt);
        
        
        
        echosign_dev1__SIGN_AgreementEvent__c echosignAgreement=new echosign_dev1__SIGN_AgreementEvent__c();
        
        echosignAgreement.echosign_dev1__Acting_User_Email__c='taruni.uce@test.com';
        echosignAgreement.echosign_dev1__Participant_Email__c='taruni.uce@test.com';
        echosignAgreement.echosign_dev1__SIGN_Agreement__c=agrmt.id;
        echosignAgreement.echosign_dev1__Description__c='sent out for signature to';
        
        
        
        insert echosignAgreement;
        
        grz_UpdateAccountOnApprovalTestClass.updateAccountOnApprovaltest2(echosignAgreement.id,objSalesArea.id);
         grz_UpdateAccountOnApprovalTestClass.updateAccountOnApprovaltest4(echosignAgreement.id,objSalesArea.id);
         grz_UpdateAccountOnApprovalTestClass.updateAccountOnApprovaltest5(echosignAgreement.id,objSalesArea.id);
        
       
    }
    
    
    static void updateAccountOnApprovaltest2(id echosigns,id objSalesAreaId){
        echosign_dev1__SIGN_AgreementEvent__c echosignAgreement=new echosign_dev1__SIGN_AgreementEvent__c();
        echosignAgreement.id=echosigns;
        echosignAgreement.echosign_dev1__Description__c='sent out for approval to';
        
        update echosignAgreement;
        System.debug('echosignAgreement??'+echosignAgreement);
        
         Decimal num=Math.random();
        User uss=[select id,email,username from User where id=:userinfo.getUserId()];
        uss.email='taruni.uce@test.com';
      
        update uss;
        System.debug('us127>'+uss);
        
        DistributorSalesAreaMapping__c objSalesArea = new DistributorSalesAreaMapping__c();
        objSalesArea.id=objSalesAreaId;
        objSalesArea.Stage__c='Pending with approver 1';
        objSalesArea.First_Approver__c= uss.Id;
        update objSalesArea;
        
        
      
        grz_UpdateAccountOnApprovalTestClass.updateAccountOnApprovaltest3(echosignAgreement.id,objSalesArea.id,uss.Id);
        
        List<echosign_dev1__SIGN_AgreementEvent__c> listEchoSign=[SELECT echosign_dev1__Acting_User_Email__c,
                                                                  echosign_dev1__Participant_Email__c,echosign_dev1__Type__c,Sales_Area_Id__c from echosign_dev1__SIGN_AgreementEvent__c where id=:echosignAgreement.Id];
        grz_UpdateAccountOnApprovalHandler.updateAccountOnApproval(listEchoSign);
        
        
        
    }
    static void updateAccountOnApprovaltest3(id echosigns2,id objSalesAreaId2,id urssr){
    
        User us1=[select id,FirstName,email,username from User where id=:urssr];
        
      
        update us1;
       System.debug('us1???'+us1);
  

        DistributorSalesAreaMapping__c objSalesArea = new DistributorSalesAreaMapping__c();
        objSalesArea.id=objSalesAreaId2;
        objSalesArea.Stage__c='Pending with company signing authority (ZBH/SBU)';
        objSalesArea.First_Approver__c= us1.Id;
        objSalesArea.Second_Approver__c= us1.Id;
        update objSalesArea;
    
          DistributorSalesAreaMapping__c salMap=[SELECT id,Stage__c,Substage__c,Customer_Email__c,First_Approver__c,First_Approver__r.Email,Second_Approver__c,Second_Approver__r.Email 
                                               FROM DistributorSalesAreaMapping__c where id=:objSalesArea.id];
        System.debug('salMap??'+salMap);
        
        
        
        List<echosign_dev1__SIGN_AgreementEvent__c> listEchoSign2=[SELECT echosign_dev1__Acting_User_Email__c,
                                                                   echosign_dev1__Participant_Email__c,echosign_dev1__Type__c,Sales_Area_Id__c from echosign_dev1__SIGN_AgreementEvent__c where id=:echosigns2];
        System.debug('listEchoSign2?'+listEchoSign2);
        
     //   User listofUsers=[select id, email from user where id in (SELECT UserOrGroupId FROM GroupMember where Group.DeveloperName='GBS_Approver_Group') Limit 1];
      //  System.debug('listofUsers????'+listofUsers);
      //  listofUsers.Email='taruni.uce@test.com';
       // update listofUsers;
       // GroupMember grpm=new GroupMember();
       
        //grpm.UserOrGroupId = us1.id;
       // insert grpm;
        
        grz_UpdateAccountOnApprovalHandler.updateAccountOnApproval(listEchoSign2);
    }
    
      static void updateAccountOnApprovaltest4(id echosigns,id objSalesAreaId){
          
          echosign_dev1__SIGN_AgreementEvent__c echosignAgreement=new echosign_dev1__SIGN_AgreementEvent__c();
        echosignAgreement.id=echosigns;
        echosignAgreement.echosign_dev1__Description__c='approved by';
        
        update echosignAgreement;
        System.debug('echosignAgreement?4?'+echosignAgreement);
        
        
        User uss=[select id,email,username from User where id=:userinfo.getUserId()];
        uss.email='taruni.uce@test.com';
      
        update uss;
        System.debug('us199>'+uss);
       
           List<User> listofUsers=[select id, email from user where id in (SELECT UserOrGroupId FROM GroupMember where Group.DeveloperName='GBS_Approver_Group') Limit 1];
          if(!listofUsers.isEmpty()){
              listofUsers[0].Email='taruni.uce@test.com';
        update listofUsers;
          }
        
        List<echosign_dev1__SIGN_AgreementEvent__c> listEchoSign0=[SELECT echosign_dev1__Acting_User_Email__c,
                                                                  echosign_dev1__Participant_Email__c,echosign_dev1__Type__c,Sales_Area_Id__c from echosign_dev1__SIGN_AgreementEvent__c where id=:echosignAgreement.Id];
        grz_UpdateAccountOnApprovalHandler.updateAccountOnApproval(listEchoSign0);
      }
    
     static void updateAccountOnApprovaltest5(id echosigns,id objSalesAreaId){
          
          echosign_dev1__SIGN_AgreementEvent__c echosignAgreement=new echosign_dev1__SIGN_AgreementEvent__c();
        echosignAgreement.id=echosigns;
        echosignAgreement.echosign_dev1__Description__c='declined by';
        
        update echosignAgreement;
        System.debug('echosignAgreement?4?'+echosignAgreement);
        
        
        User uss=[select id,email,username from User where id=:userinfo.getUserId()];
        uss.email='taruni.uce@test.com';
      
        update uss;
        System.debug('us199>'+uss);
       
           List<User> listofUsers=[select id, email from user where id in (SELECT UserOrGroupId FROM GroupMember where Group.DeveloperName='GBS_Approver_Group') Limit 1];
       if(!listofUsers.isEmpty()){
              listofUsers[0].Email='taruni.uce@test.com';
        update listofUsers;
          }
        System.debug('listofUsers????'+listofUsers);
        List<echosign_dev1__SIGN_AgreementEvent__c> listEchoSign0=[SELECT echosign_dev1__Acting_User_Email__c,
                                                                  echosign_dev1__Participant_Email__c,echosign_dev1__Type__c,Sales_Area_Id__c from echosign_dev1__SIGN_AgreementEvent__c where id=:echosignAgreement.Id];
        grz_UpdateAccountOnApprovalHandler.updateAccountOnApproval(listEchoSign0);
      }
    
    
    
}