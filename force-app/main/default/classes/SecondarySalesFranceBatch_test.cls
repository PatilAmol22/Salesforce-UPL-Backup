@isTest
public class SecondarySalesFranceBatch_test {
     @isTest
    private static void testMethod1()
    {
        Test.startTest();
            
        SalesOrgCode__c sorg = new SalesOrgCode__c(Name ='France', Code__c = '2710'); 
		insert sorg;
        
        //account details  
        /*Account acc = new Account();
        acc.Name='Test Sales1';
        acc.Email__c = 'ganesh039@gmail.com';
        acc.Last_Name__c='PASSINATO';
        acc.SAP_Code__c='0002028843';
        acc.Mobile__c='9967341759';
        acc.Phone='01234567891';
        acc.Tax_Number_3__c='114415455';
        acc.Tax_Number_1__c='114414523';
        acc.Customer_Region__c='AC';
        acc.Customer_Group__c='001';
        acc.Program_Margin_Discount__c=0.00;
        acc.Active__c=true;
        acc.Search_Terms_1__c='LEONARDO PASSINATO';
        acc.Search_Terms_2__c='FAZ SEUBAK';
        insert acc; 
        */
        Account acc1 = new Account();
        acc1.Name='Test Sales1';
        acc1.Email__c = 'ganesh039@gmail.com';
        acc1.Last_Name__c='PASSINATO';
        acc1.SAP_Code__c='0000001345';
        acc1.Ship_To_Party_SAP_Code__c='0000001345';
        acc1.Combination_Key__c='00000013450000001345';
        acc1.Mobile__c='9967341759';
        acc1.Phone='01234567891';
        acc1.Tax_Number_3__c='114415455';
        acc1.Tax_Number_1__c='114414523';
        acc1.Customer_Region__c='AC';
        acc1.Customer_Group__c='001';
        acc1.Program_Margin_Discount__c=0.00;
        acc1.Active__c=true;
        acc1.Search_Terms_1__c='LEONARDO PASSINATO';
        acc1.Search_Terms_2__c='FAZ SEUBAK';
        insert acc1;     
        
        Account ac = new Account();
        ac.Name='Test Sales2';
        ac.Email__c = 'ganesh038@gmail.com';
        ac.Last_Name__c='PASSINATI';
        ac.SAP_Code__c='0000001344';
        ac.Ship_To_Party_SAP_Code__c='0000001344';
        ac.Combination_Key__c='00000013440000001344';
        ac.Mobile__c='9967341758';
        ac.Phone='01234567892';
        ac.Tax_Number_3__c='114415452';
        ac.Tax_Number_1__c='114414521';
        ac.Customer_Region__c='AC';
        ac.Customer_Group__c='003';
        ac.Program_Margin_Discount__c=0.00;
        ac.Active__c=true;
        ac.Search_Terms_1__c='LEONARDO PASSINATI';
        ac.Search_Terms_2__c='FAZ SEUBAKI';
        insert ac;      
        
        SKU__c skuRecord = new SKU__c(
            Name = 'Test_SKU',                                // SKU Name
            SKU_Code__c = '000000000006302802',                      // SKU Code
            SKU_Description__c = 'MANZATE 800WP 25KG PAPER BAG_BR',  // SKU Description
            UOM__c = 'KG',
            Multiple_of__c = 25.00,                                  // Multiple Of
            Combination_Key__c = '519110000000000006302802',         // Combination Key
            Active__c = true                                         // Active
        );
        insert skuRecord;
        
        
    	SecondarySalesFrance.getDocument();
        
        
        String file1='SAP sold-to,SAP Ship-to,Product Code,Customer Product Code,Month(In Number),Year,Quantity\r\n0000001345,0000001345,00000000006302802,1209877,02,2019,3\r\n000001344,0000001345,00000000006302802,1209879,12,20,4\r\n';
        SecondarySalesFranceBatch batch= new SecondarySalesFranceBatch(file1);
        database.executeBatch(batch,2000);
        String results1 = SecondarySalesFrance.passFile(file1);
        String result2=  SecondarySalesFrance.passFileAura(file1);          
        List<Secondary_Sales_Data__c> stlist = [select id,Customer_Product_Code__c,createddate from Secondary_Sales_Data__c where Customer_Product_Code__c in ('1209877','1209879') and createddate = today];
        //System.assertEquals(2, stlist.size(),'Success');
            
        String file2='SAP sold-to,SAP Ship-to,Product Code,Customer Product Code,Month(In Number),Year,Quantity\n2028847,2028847,000000000006301802,33467775,abc,,abc\n2028845,,,13,,4\r\n';
        String results2 = SecondarySalesFrance.passFile(file2);
        
        Test.stopTest();
    } 
        
    }