/**************************************************************************************************
* Name             : grz_SalesOrderReturnFnlControllerTest                                                      
* Description      : Test class for return sales order controllers
* Created Date     : 10-12-2022                                                                        
* Project/JIRA     : APPS-2818                                                                        
* Created By       : Aashima Puri (Grazitti)                                                                        
* Last Modified By : Gurubaksh Grewal (Grazitti) 06-03-2023                                                                        
**************************************************************************************************/
@isTest
public class grz_SalesOrderReturnFnlControllerTest {
    public static testMethod void test1(){
        
        Account a = new Account();
        a.name = 'Test';
        Insert a;
         
        Sales_Order_Return_Config__c co = new Sales_Order_Return_Config__c();
        co.months__c = 6;
        co.Sales_Org__c = '1000';
        insert co;
        
        Sales_Org__c sOrg = new Sales_Org__c();
        sOrg.name = 'India';
        sOrg.Sales_Org_Code__c = '1000';
        insert sOrg;
        Sales_Order__c sOrd = new Sales_Order__c();
        sord.sold_to_party__c=a.id;
        sord.Sales_Org_lk__c=sorg.id;
        insert sOrd;
        Date d=System.today().addMonths(-7);

Depot__c dp =new Depot__c ();
            dp.Name='Pune';
            dp.Country__c='India';
            dp.Location__c='Pune';
            dp.Depot_Code__c='PUN1';
            insert dp;
        
         SKU__c sku1 = new SKU__c();
        sku1.SKU_Description__c = 'product_name_sku';
        sku1.SKU_code__c = '001';
        sku1.Active__c = true;
        sku1.Brand_Name__c = 'brand';
        insert sku1; 
        
         Product2 productObj = new Product2(
            Name = 'BISECT',                     // Product Name
            ProductCode = '71501',                 // Product Code
            Product_Code__c = '71501',             // Product Code
            IsActive = false,                      // Active
            Active__c = false,                     // Active
            Sales_Org__c = sOrg.id,      // Sales Org
            Combination_Key__c = '7150156311010',  // Combination Key
            Popular__c = false,                    // Popular
            Power_Brand__c = false,                // Power Brand
            Active_For_Liquidation__c = false     // Active For Liquidation
        );
        insert productObj;
        
        invoice__c inv = new invoice__c();
        inv.Sales_Org__c = sOrg.id;
        inv.Sold_To_Party__c = a.id;
        inv.Billing_Date__c =d;
        inv.Sales_Order__c=sOrd.id;
        inv.Billing_Date__c=system.today();
        inv.Depot__c=dp.id;
        insert inv;
        
        Invoice_Line_Item__c invLI=new Invoice_Line_Item__c();
        invLI.invoice__c=inv.Id;
        invLI.Quantity__c=20;
        invLI.UOM__c='L';
        invLI.Invoice_Item_Key__c='L67889';
        invLI.SKU__c=sku1.id;
        invLI.Batch__c='L';
        invLI.Product__c=productObj.id;
        insert invLI;
        
        Return_Sales_Order__c returnOrder=new Return_Sales_Order__c (SalesOrder__c =sOrd.id,invoice__c=inv.id,order_status__c='Draft');
        insert returnOrder;
        
        Return_Sales_Order_Line_Item__c returnRecord=new Return_Sales_Order_Line_Item__c (invoice_line_Item__c=invLI.id,Return_Sales_Order__c=returnOrder.Id);
        insert returnRecord;
        
       
        
         test.startTest();
        Test.setMock(HttpCalloutMock.class, new Grz_SapIntegrationMockTestDataFactory(true));
        
        grz_SalesOrderReturnFnlController.getDetails(inv.Id);
        grz_SalesOrderReturnFnlController.getDetailsReprocess(returnOrder.Id);
        test.stopTest();
        List<grz_SalesOrderReturnFnlController.forList> listData=new List<grz_SalesOrderReturnFnlController.forList>();
        grz_SalesOrderReturnFnlController.forList aa=new grz_SalesOrderReturnFnlController.forList();
        aa.returnQty ='20';
        aa.returnReason ='20';
        aa.id =invLI.Id;
        listData.add(aa);
       
        string recII=grz_SalesOrderReturnFnlController.saveRec(listData, inv.id, false, '','101 Poor quality',userInfo.getUserId(), userInfo.getUserId(), true,true);
        
               
        object oo=Grz_RsoApprovalController.fetchApprovals();
        //Grz_RsoApprovalController.processApprovals(pid[0].id,'Rejected','11');
            system.debug('ob___________________'+JSON.serializePretty(oo));
        list<object> obList=(list<object>)JSON.deserializeUntyped(JSON.serialize(oo));
        for(object ob:obList){
            map<string,object> obMap=(map<string,object>)(ob);
            system.debug('ob___________________'+JSON.serializePretty(ob));
            Grz_RsoApprovalController.processApprovals(string.valueOf(obMap.get('wi')),'Reject','11');
        }
         
        grz_SalesOrderReturnFnlController.upInv(new map<string,date>{invli.id=>system.today()});
       
        
    }
}