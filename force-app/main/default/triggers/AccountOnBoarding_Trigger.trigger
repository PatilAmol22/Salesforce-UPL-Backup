/*
* Name: AccountOnBoarding_Trigger
* Author: Ketan Khatri (ketan.khatri@skinternational.com)
* Last Modified By :- vishal Pawar (vishal.pawar@skinternational.com)
* Date:- 30.01.2020
Last Modified By :- Pallavi Gite (pallavi.gite@skinternational.com)
* Date:- 6.01.2021
* Description: Trigger to manage the type of documents uploaded for account onboarding
* Supporting Class: AccountOnBoardingTrig_Test (Test Class)
*/
trigger AccountOnBoarding_Trigger on DistributorDocument__c (after insert,before delete) {
    
    
    String DocTypeInsert = '';
    String DocTypeDelete = '';
    
    Map<Id,Account> AccMapInsert = new Map<Id,Account>();
    Map<Id,Account> AccMapDelete = new Map<Id,Account>();
    
    //For insertion on the new distributor document
    if(Trigger.isInsert){
        for(DistributorDocument__c Ddoc : Trigger.new){
            Account acc = new Account();
            acc.Id = Ddoc.Distributor__c;
            Account accTest = [SELECT ID,RecordTypeId FROM Account WHERE ID=:Ddoc.Distributor__c];
            System.debug('accTest.RecordTypeId  =>'+accTest.RecordTypeId);
            if(accTest.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId())  
            {
                DocTypeInsert = Ddoc.Document_List__c;
                System.debug('DocTypeInsert while insert '+DocTypeInsert);
                
                
                if(DocTypeInsert == 'Photograph (Owner)'){
                    acc.Photograph_Owner__c = True;
                }
                else if(DocTypeInsert == 'Photograph (Selfie with Customer)'){
                    acc.Photograph_Selfie_with_Customer__c = True;
                }
                
                    
                else if(DocTypeInsert == 'Photograph (Shop)'){
                    acc.Photograph_Shop__c = True;
                }
                else if(DocTypeInsert == 'Security cheques along with deceleration annexure'){
                    acc.Scanned_Security_Cheque__c = True;
                }
                else if(DocTypeInsert == 'Copy of Pesticide / Seed License'){
                    acc.Copy_of_Pesticide_Seed_License__c = True;
                }
                else if(DocTypeInsert == 'GST certificate/ customer deceleration for NON-REGISTERED GSTN'){
                    acc.GST_Certificate__c = True;
                }
                else if(DocTypeInsert == 'Copy of Partnership Firm/ Company/HUF/Prop. Affidavit'){
                    acc.Copy_of_Partnership_Firm_Company_HUF_Pr__c = True;
                }
                else if(DocTypeInsert == 'Signed Business Policy'){
                    acc.Signed_Business_Policy__c = True;
                }
                else if(DocTypeInsert == 'Blank Letter Pad for Address Proof'){
                    acc.Blank_Letter_Pad_for_Address_Proof__c = True;
                }
                else if(DocTypeInsert == 'PAN Card'){
                    acc.PAN_Card__c = True;
                }
                else if(DocTypeInsert == 'Demand Draft(DD)'){
                    acc.Demand_Draft_DD__c = True;
                }
                //Added by Pallavi
                else if(DocTypeInsert == 'Dealer booklet'){
                    acc.Dealer_booklet__c = True;
                }
                else if(DocTypeInsert == 'Annexure of declaration of relation'){
                    acc.Annexure_of_declaration_of_relation__c = True;
                }
                else if(DocTypeInsert == 'Annexure of declaration of signing documents'){
                    acc.Annexure_of_declaration_of_signing_docs__c = True;
                }
                else if(DocTypeInsert == 'Latest bank statement of last 3 months'){
                    acc.Latest_bank_statement_of_last_3_months__c = True;
                }
                else if(DocTypeInsert == 'Owner/PARTNERs/Director ADHAAR Copy'){
                    acc.Owner_PARTNERs_Director_ADHAAR_Copy__c = True;
                }
                else if(DocTypeInsert == 'Residential Address Proof Proprietor/Partner/Director'){
                    acc.Residential_Address_Proof_Proprietor_Par__c = True;
                }
                
                AccMapInsert.put(Ddoc.Distributor__c, acc);
            }
            if(!AccMapInsert.isEmpty()){
                update AccMapInsert.values();
            }
            
        }
    }
    
    
    //For Deletion on the Distributor Document
    if(Trigger.isDelete){
        for(DistributorDocument__c Ddoc : Trigger.old){
            Account acc = new Account();
            acc.Id = Ddoc.Distributor__c;
            DocTypeDelete = Ddoc.Document_List__c;
            
            Account accTest = [SELECT ID,RecordTypeId FROM Account WHERE ID=:Ddoc.Distributor__c];
            
            if(accTest.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId())  
            {
                if(DocTypeDelete == 'Photograph (Owner)'){
                    acc.Photograph_Owner__c = False;
                }
                else if(DocTypeDelete == 'Photograph (Selfie with Customer)'){
                    acc.Photograph_Selfie_with_Customer__c = False;
                }
                else if(DocTypeDelete == 'Photograph (Shop)'){
                    acc.Photograph_Shop__c = False;
                }
                else if(DocTypeDelete == 'Security cheques along with deceleration annexure'){
                    acc.Scanned_Security_Cheque__c = False;
                }
                else if(DocTypeDelete == 'Copy of Pesticide / Seed License'){
                    acc.Copy_of_Pesticide_Seed_License__c = False;
                }
                else if(DocTypeDelete == 'GST certificate/ customer deceleration for NON-REGISTERED GSTN'){
                    acc.GST_Certificate__c = False;
                }
                else if(DocTypeDelete == 'Copy of Partnership Firm/ Company/HUF/Prop. Affidavit'){
                    acc.Copy_of_Partnership_Firm_Company_HUF_Pr__c = False;
                }
                else if(DocTypeDelete == 'Signed Business Policy'){
                    acc.Signed_Business_Policy__c = False;
                }
                else if(DocTypeDelete == 'Blank Letter Pad for Address Proof'){
                    acc.Blank_Letter_Pad_for_Address_Proof__c = False;
                }
                else if(DocTypeDelete == 'PAN Card'){
                    acc.PAN_Card__c = False;
                }
                else if(DocTypeDelete == 'Demand Draft(DD)'){
                    acc.Demand_Draft_DD__c = False;
                }
                //Added by Pallavi
                else if(DocTypeInsert == 'Dealer booklet'){
                    acc.Dealer_booklet__c = False;
                }
                else if(DocTypeInsert == 'Annexure of declaration of relation'){
                    acc.Annexure_of_declaration_of_relation__c = False;
                }
                else if(DocTypeInsert == 'Annexure of declaration of signing documents'){
                    acc.Annexure_of_declaration_of_signing_docs__c = False;
                }
                else if(DocTypeInsert == 'Latest bank statement of last 3 months'){
                    acc.Latest_bank_statement_of_last_3_months__c = False;
                }
                else if(DocTypeInsert == 'Owner/PARTNERs/Director ADHAAR Copy'){
                    acc.Owner_PARTNERs_Director_ADHAAR_Copy__c = False;
                }
                else if(DocTypeInsert == 'Residential Address Proof Proprietor/Partner/Director'){
                    acc.Residential_Address_Proof_Proprietor_Par__c = False;
                }
                
                AccMapDelete.put(Ddoc.Distributor__c, acc);
            }   
            if(!AccMapDelete.isEmpty()){
                update AccMapDelete.values();
            }
        } 
    }
}