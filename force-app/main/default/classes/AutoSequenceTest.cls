@isTest
public class AutoSequenceTest {
    static testMethod void test(){
        Auto_Number__c autObj = new Auto_Number__c();
        autObj.Name = 'MachineCode';
        autObj.Sequence__c = '0';
        insert autObj;
        
        /*Auto_Number__c autObj2 = new Auto_Number__c();
        autObj2.Name = 'CropCode';
        autObj2.Sequence__c = '0';
        insert autObj2;*/
        
        Auto_Number__c autObj3 = new Auto_Number__c();
        autObj3.Name = 'MachineOperatorCode';
        autObj3.Sequence__c = '0';
        insert autObj3;
        
        Machine__c sobj = new Machine__c(
            Machine_Code__c = 'Mac-002',  // Machine Code
            Category__c = 'Crop',           // Category
            //Tehsil__c = 'a05N0000005ltaM',  // Tehsil
            Active__c = true               // Active
        );
        insert sobj;
        
        Machine_Operator__c sobj2 = new Machine_Operator__c(
            Name = 'Operator1',                // Machine Operator Name
            Machine_Operator_Code__c = 'moc01',  // Machine Operator Code
            Mobile__c = '8512574896',            // Mobile
            Email__c = 'operator1@gmail.com',    // Email
            Active__c = true                    // Active
        );
        insert sobj2;
        
        /*Crop__c sobj3 = new Crop__c(
            Name = 'Onion',                      // Crop Name
            Crop_Type__c = 'Fruits & Vegetables',  // Crop Type
            Crop_Code__c = 'CR042',                // Crop Code
            Active__c = true                       // Active
        );
        insert sobj3;*/
    }
}