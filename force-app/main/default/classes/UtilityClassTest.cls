/*  
* Name: UtilityClassTest     
* Created On: 1 June 2023
* Author: Nandhini
* Description: Test Class for UtilityClass
*/ 

@isTest
public class UtilityClassTest {

    static testMethod void utilityMethods(){
        UtilityClass.getSalesOrgIndiaSAS();
        UtilityClass.getCompanyCodeIndiaSAS();
        UtilityClass.getSalesOrgIndiaOld();
        UtilityClass.getSalesOrgDetails();
        UtilityClass.getArgentinaFreezePeriodDetails();
    }
}