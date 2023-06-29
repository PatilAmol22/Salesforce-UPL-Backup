@isTest 
public class AllProductRecomdBatch_Test{

      /*
        This Month Product Recomdation Batch Test Class --
        
        Written By - Pravin J.
        Date - 30/10/2017  */
        
        
     public Static Id CaseRecType ;
     public Static contact  acnt ;
     public Static Village__c vl ;
     public Static Village__c vl1;
     public Static Tehsil__c ts;
     
     public static void init(){
     
         
         String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
            Id RecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Farmer').getRecordTypeId();
            CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AKC General Case').getRecordTypeId();
           
            Auto_Number__c auto = new Auto_Number__c();
            auto.Name='FarmerCodetest';
            auto.Sequence__c='67';
            
            insert auto;
            
            Trigger_Settings__c tsObj1 = new Trigger_Settings__c();
            tsObj1.Name = 'CaseTrigger';
            tsObj1.isActive__c = True;
            insert tsObj1;
            
             // State
             State__c st = new State__c();
             st.name = 'state1';
             insert st;
            
             // District
             District__c ds = new District__c();
             ds.Name = 'dist1';
             ds.State__c= st.id;
             insert ds;
             
             // Tehsil
             ts = new Tehsil__c();
             ts.Name = 'tehsil1';
             ts.District__c = ds.id;
             insert ts;
             
             
     }
     
     
      public static testMethod void test1(){
          
            init();  
            
             // Village
             vl = new Village__c(); 
             vl.Name = 'village1';
             vL.Fo_Map__c = true;
             vl.Tehsil__c = ts.id;
             insert vl;
             
            
            acnt = new contact();
            
            acnt.FirstName = 'Himanshu';
            acnt.LastName  = 'Mehta';
            acnt.Decision_Maker__c = 'Yes';
            acnt.Crops_Cultivated__c = 'Other';
            acnt.Crops_Cultivated__c   = 'Other';
            acnt.SMS_Voice_Msg_Call_Consent__c= 'No';
            acnt.Other_Acerage__c = '3 or Above';
            acnt.Fruit_Vegetable_Acerage__c = '1 or Above';
            acnt.Village__c = vl.id;
            
            insert acnt;           
            
            Case cs = new case();
            cs.Recordtypeid  = CaseRecType;
            cs.Contactid = acnt.id;
            cs.Status = 'New';
            cs.Type = 'Mandi Price';
            cs.Sub_Query__c = 'Mandi Price';
            cs.Products_Recommended__c ='ULALA';
            //cs.FO_Present__c = 1 ;
            cs.CreatedDate = system.today()-1;
            cs.Crop_pick__c ='Crop';
            
            insert cs;
            
            Case cs1 = new case();
            cs1.Recordtypeid  = CaseRecType;
            cs1.Contactid = acnt.id;
            cs1.Status = 'New';
            cs1.Type = 'Mandi Price';
            cs1.Sub_Query__c = 'Mandi Price';
            //cs1.FO_Present__c = 1 ;
            cs1.Products_Recommended__c ='PHOSKILL';
            cs1.CreatedDate = system.today()-2;
            cs1.Crop_pick__c ='Crop';
            
            insert cs1;
            
            
             test.startTest();
               
                ThisMonthProductRecomdBatch obj = new ThisMonthProductRecomdBatch();
                DataBase.executeBatch(obj);
                
             test.stopTest();
         
        }
        
        
         public static testMethod void test2(){
          
            init();  
            
             // Village
             vl = new Village__c(); 
             vl.Name = 'village1';
             vL.Fo_Map__c = true;
             vl.Tehsil__c = ts.id;
             insert vl;
             
            
            acnt = new contact();
            
            acnt.FirstName = 'Himanshu';
            acnt.LastName  = 'Mehta';
            acnt.Decision_Maker__c = 'Yes';
            acnt.Crops_Cultivated__c = 'Other';
            acnt.Crops_Cultivated__c   = 'Other';
            acnt.SMS_Voice_Msg_Call_Consent__c= 'No';
            acnt.Other_Acerage__c = '3 or Above';
            acnt.Fruit_Vegetable_Acerage__c = '1 or Above';
            acnt.Village__c = vl.id;
            
            insert acnt;           
            
            Case cs = new case();
            cs.Recordtypeid  = CaseRecType;
            cs.Contactid = acnt.id;
            cs.Status = 'New';
            cs.Type = 'Mandi Price';
            cs.Sub_Query__c = 'Mandi Price';
            cs.Products_Recommended__c ='ULALA';
            //cs.FO_Present__c = 1 ;
            cs.CreatedDate = system.today()-40;
            cs.Crop_pick__c ='Crop';
            
            insert cs;
            
            Case cs1 = new case();
            cs1.Recordtypeid  = CaseRecType;
            cs1.Contactid = acnt.id;
            cs1.Status = 'New';
            cs1.Type = 'Mandi Price';
            cs1.Sub_Query__c = 'Mandi Price';
            //cs1.FO_Present__c = 1 ;
            cs1.Products_Recommended__c ='PHOSKILL';
            cs1.CreatedDate = system.today()-50;
            cs1.Crop_pick__c ='Crop';
            
            insert cs1;
            
            
             test.startTest();
               
                ThisYearProductRecomdBatch obj = new ThisYearProductRecomdBatch();
                DataBase.executeBatch(obj);
                
             test.stopTest();
         
        }
        
        
         public static testMethod void test3(){
          
            init();  
            
             // Village
             vl = new Village__c(); 
             vl.Name = 'village1';
             vL.Fo_Map__c = true;
             vl.Tehsil__c = ts.id;
             insert vl;
             
            
            acnt = new contact();
            
            acnt.FirstName = 'Himanshu';
            acnt.LastName  = 'Mehta';
            acnt.Decision_Maker__c = 'Yes';
            acnt.Crops_Cultivated__c = 'Other';
            acnt.Crops_Cultivated__c   = 'Other';
            acnt.SMS_Voice_Msg_Call_Consent__c= 'No';
            acnt.Other_Acerage__c = '3 or Above';
            acnt.Fruit_Vegetable_Acerage__c = '1 or Above';
            acnt.Village__c = vl.id;
            
            insert acnt;           
            
            Case cs = new case();
            cs.Recordtypeid  = CaseRecType;
            cs.Contactid = acnt.id;
            cs.Status = 'New';
            cs.Type = 'Mandi Price';
            cs.Sub_Query__c = 'Mandi Price';
            cs.Products_Recommended__c ='ULALA';
            //cs.FO_Present__c = 1 ;
            cs.CreatedDate = system.today()-400;
            cs.Crop_pick__c ='Crop';
            
            insert cs;
            
            Case cs1 = new case();
            cs1.Recordtypeid  = CaseRecType;
            cs1.Contactid = acnt.id;
            cs1.Status = 'New';
            cs1.Type = 'Mandi Price';
            cs1.Sub_Query__c = 'Mandi Price';
            //cs1.FO_Present__c = 1 ;
            cs1.Products_Recommended__c ='PHOSKILL';
            cs1.CreatedDate = system.today()-500;
            cs1.Crop_pick__c ='Crop';
            
            insert cs1;
            
            
             test.startTest();
               
                LastYearProductRecomdBatch obj = new LastYearProductRecomdBatch();
                DataBase.executeBatch(obj);
                
             test.stopTest();
         
        }
        
        
       
         public static testMethod void test4(){
          
            init();  
            
             // Village
             vl = new Village__c(); 
             vl.Name = 'village1';
             vL.Fo_Map__c = true;
             vl.Tehsil__c = ts.id;
             insert vl;
             
            
            acnt = new contact();
            
            acnt.FirstName = 'Himanshu';
            acnt.LastName  = 'Mehta';
            acnt.Decision_Maker__c = 'Yes';
            acnt.Crops_Cultivated__c = 'Other';
            acnt.Crops_Cultivated__c   = 'Other';
            acnt.SMS_Voice_Msg_Call_Consent__c= 'No';
            acnt.Other_Acerage__c = '3 or Above';
            acnt.Fruit_Vegetable_Acerage__c = '1 or Above';
            acnt.Village__c = vl.id;
            
            insert acnt;           
            
            Case cs = new case();
            cs.Recordtypeid  = CaseRecType;
            cs.Contactid = acnt.id;
            cs.Status = 'New';
            cs.Type = 'Mandi Price';
            cs.Sub_Query__c = 'Mandi Price';
            cs.Products_Recommended__c ='ULALA';
            //cs.FO_Present__c = 1 ;
            cs.CreatedDate = DateTime.newInstance(2016,11,30);
            cs.Crop_pick__c ='Crop';
            
            insert cs;
            
            Case cs1 = new case();
            cs1.Recordtypeid  = CaseRecType;
            cs1.Contactid = acnt.id;
            cs1.Status = 'New';
            cs1.Type = 'Mandi Price';
            cs1.Sub_Query__c = 'Mandi Price';
            //cs1.FO_Present__c = 1 ;
            cs1.Products_Recommended__c ='PHOSKILL';
            cs1.CreatedDate = DateTime.newInstance(2016,11,15);
            cs1.Crop_pick__c ='Crop';
            
            insert cs1;
            
            
             test.startTest();
               
                CurrMonthLastYearProductRecomdBatch obj = new CurrMonthLastYearProductRecomdBatch();
                DataBase.executeBatch(obj);
                
             test.stopTest();
         
        }
}