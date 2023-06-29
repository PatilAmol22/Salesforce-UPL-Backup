/**
 * Apexclass Name: UPLConstantClass
 * Author: EY
 * CR: APPS-2074
 * CreatedDate: 28-Oct-2022
 * ModifiedDate: 28-Oct-2022 02:10 AM IST
 * 				 02-Nov-2022 19:01 AM IST
 * Modified By: Divya BJ
 * Description: Constant class
 * */
public without sharing class UPLConstantClass {

    public static final String INVOICE ='Invoice';
    public static final String CREDITLIMIT ='Credit Limit'; 
    public static final String DISPATCH = 'Dispatch';//'Despachos';
    public static final String PAYMENTSANDRECEIPTS ='Payments & Receipts'; 
    public static final String PRODUCTAVAILABILITY ='Product Availability';
    public static final String PRODUCTCOMPLAINTSBYFARMERS ='Product Complaints by Farmers'; 
    public static final String ORDERUPDATE = 'Order Update';
    public static final String ORDERCANCELLATION = 'Order Cancellation';
    public static final String OTHER = 'Other';
    public static final String SHIPPINGADDRESS ='Shipping Address';//'Dirección de Envío - Actualización información del cliente';
    public static final String OUTSTANDING ='Outstanding';
    public static final String PRODUCTLEAKAGE ='Product Leakage';
    public static final String ProductRelated ='Product Related';
    public static final String ESCALATED = System.Label.Colombia_Case_Escalated;
    public static final Id nurtureRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('nurture_farm_care').getRecordTypeId();
    public static final Id distributorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
    public static final String UPL_SAS_SalesOrg = '1410';
    public static final Id argentinaCaseDistributorRTId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Argentina_Distributor').getRecordTypeId();
    public static final Id farmerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Farmer').getRecordTypeId();
    public static final Id preRegisteredfarmerRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PreRegistered_Farmer').getRecordTypeId();
    public static final Id akcRetailerRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('AKC_Retailer').getRecordTypeId();
    public static final Id unRegisteredFarmerRetailerRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('UnRegistered_Farmer_Retailer').getRecordTypeId();
}