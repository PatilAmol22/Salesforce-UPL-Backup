/*
* Name: ItalyShipLocationShare
* Created On: 7 august 2019
* Author: Ganesh Chaurasia (ganesh.chaurasia@skinternational.com)
* Description: Apex Class to get Shipping Location Records with Sharing (Called from OrderItalyController)
*/

public with sharing  class ItalyShipLocationShare {
    public static Map<String,Shipping_Location__c> getShippingLocation(String accountId){
        
        Map<String,Shipping_Location__c> options = new Map<String,Shipping_Location__c>();
        List<Shipping_Location__c> shippinList = new List<Shipping_Location__c>();
        shippinList = [SELECT Id,OwnerId, Name,Location_Name__c, Distributor__c, City__c, 
                                        Region__c, Pincode__c, State__c, Country__c,Shipping_Notes__c,House_Number__c,
                                        Sold_To_Party_SAP_Code__c, SAP_Code__c,Billing_Street_1__c,Billing_Street_2__c,
                                        Billing_Street_3__c,Billing_Street_4__c,Billing_Street_5__c,Billing_Street_6__c,Expiry_Date__c
                                        FROM Shipping_Location__c
                                        WHERE Distributor__c =:accountId And Active__c=true];
        
        System.debug('shippinList while Community user place Order '+shippinList);
        System.debug('shippinList while Community user place Order size '+shippinList.size());
        
        
        for(Shipping_Location__c slObj:[SELECT Id,OwnerId, Name,Location_Name__c, Distributor__c, City__c, 
                                        Region__c, Pincode__c, State__c, Country__c,Shipping_Notes__c,House_Number__c,
                                        Sold_To_Party_SAP_Code__c, SAP_Code__c,Billing_Street_1__c,Billing_Street_2__c,
                                        Billing_Street_3__c,Billing_Street_4__c,Billing_Street_5__c,Billing_Street_6__c,Expiry_Date__c
                                        FROM Shipping_Location__c
                                        WHERE Distributor__c =:accountId And Active__c=true ORDER BY Location_Name__c ASC]){
                                            options.put(slObj.Name, slObj);
                                        }
        
        return options;
        
    }
}