/**************************************************************************************************
* Name             : grz_returnSalesOrderLineItemHandler                                                     
* Description      : Handler to provide certain custom validations(error messages) like available 
                     quantitites to return and UOM check via apex along with the profiles that have
                     access to edit the record. 
* Test Class       : grz_ReturnSalesOrderControllerTest
* Created Date     : 17-01-2023                                                                        
* Project/JIRA     : APPS-2818                                                                        
* Created By       : Gurubaksh Grewal (Grazitti)                                                                        
* Last Modified By : Gurubaksh Grewal (Grazitti) 24-01-2023                                                                        
**************************************************************************************************/

public class grz_returnSalesOrderLineItemHandler {
    
    
    public static void afterReturnInsUp(list<Return_Sales_Order_Line_Item__c> triggernew){
        
		list<Return_Sales_Order_Line_Item__c>rsol2del=new list<Return_Sales_Order_Line_Item__c>();
        list<string> relevantCodes=new list<string>{'1410','1000','1510','1210'};
        for(Return_Sales_Order_Line_Item__c rr:[Select id,Quantity__c,Sales_Org_Code__c from Return_Sales_Order_Line_Item__c where id in:triggernew AND Sales_Org_Code__c in:relevantCodes]){
            if(rr.Quantity__c==null || rr.Quantity__c==0)rsol2del.add(rr);
        }
        if(rsol2del!=null && !rsol2del.isEmpty())delete rsol2del;
    }
    public static void beforeReturnInsert(list<Return_Sales_Order_Line_Item__c> triggernew){
        map<string,string>rso2sfdc=new map<string,string>();        
        for(Return_Sales_Order_Line_Item__c rr:triggernew){
            if(rr.Status__c=='Completely rejected'||rr.Status__c=='Rejected'){
                rr.Partially_Returned_Quantity__c=0;
                rr.Quantity__c=0;
            }
            if(rr.Quantity__c!=null&&rr.Net_Price_Per_Unit__c!=null)rr.Net_Amount__c=rr.Quantity__c*rr.Net_Price_Per_Unit__c;
             if(rr.Partially_Returned_Quantity__c==null)rr.Partially_Returned_Quantity__c=0;
            else rr.Net_Amount__c=rr.Quantity__c*rr.Net_Price_Per_Unit__c;
            //if(rr.Status__c=='Partially rejected' || rr.Status__c== 'Partially processed')rr.Quantity__c=rr.Partially_Returned_Quantity__c;
            rso2sfdc.put(rr.Return_Sales_Order__c,null);
            
        }
        for(Return_Sales_Order__c rr:[SELECT id,SFDC_Order_Number__c FROM Return_Sales_Order__c WHERE ID in: rso2sfdc.keySet()]){
            rso2sfdc.put(rr.id,rr.SFDC_Order_Number__c);
        }
        for(Return_Sales_Order_Line_Item__c rr:triggernew){
            //if(rr.SAP_Order_Number__c!=null)rr.RSOLI_Combination_Key__c=rr.SAP_Order_Number__c+'-'+rr.Item_Number__c;
            if(rso2sfdc.get(rr.Return_Sales_Order__c)!=null){
             rr.Order_Item_Key__c=rso2sfdc.get(rr.Return_Sales_Order__c)+rr.Item_Number__c;
             //rr.RSOLI_Combination_Key__c=rso2sfdc.get(rr.Return_Sales_Order__c)+'-'+rr.Item_Number__c;
            }
            if(rr.Quantity__c!=null&&rr.Net_Price_Per_Unit__c!=null)rr.Net_Amount__c=rr.Quantity__c*rr.Net_Price_Per_Unit__c;
        
        }
        
    }
    public static void beforeReturnUpdate(list<Return_Sales_Order_Line_Item__c> triggernew,list<Return_Sales_Order_Line_Item__c> triggerold,map<id,Return_Sales_Order_Line_Item__c> triggernewMap,map<id,Return_Sales_Order_Line_Item__c> triggerOldMap){
        
    Profile currentUserProfile = [Select Name from Profile where Id =: userinfo.getProfileid()]; 
        string currentProfileName='';
        currentProfileName=currentUserProfile.Name;
        
        map<string,string>rsol2Profile=new map<string,string>();
        
        for(Return_Sales_Order_Line_Item__c rsoli:[SELECT Id,CreatedBy.Profile.Name FROM Return_Sales_Order_Line_Item__c WHERE id in: trigger.newMap.keySet()]){
            rsol2Profile.put(rsoli.id,rsoli.CreatedBy.Profile.Name);
        }
    Map<String,Decimal> rsol2qty = new Map <String,Decimal>();
    Map<String,string> inv2rsol = new Map <String,string>();
    set<string>rsolWithModifiedQty=new set<string>();
    for(Return_Sales_Order_Line_Item__c rr :triggerold){
        if(rr.Return_Sales_Order__c!=(triggernewMap.get(rr.id).Return_Sales_Order__c))rr.addError('Once created you can not re-parent a return sales order line item');
        if(rr.Quantity__c!=(triggernewMap.get(rr.id).Quantity__c))rsolWithModifiedQty.add(rr.id);
    }
    for(Return_Sales_Order_Line_Item__c rr : [SELECT id,Invoice_Line_Item__c,Invoice_Line_Item__r.Quantity__c FROM Return_Sales_Order_Line_Item__c WHERE ID in :rsolWithModifiedQty]){
        rsol2qty.put(rr.id,rr.Invoice_Line_Item__r.Quantity__c);
        inv2rsol.put(rr.Invoice_Line_Item__c,rr.id);
    }
    
    for(Return_Sales_Order_Line_Item__c rr:[SELECT id,Status__c,Partially_Returned_Quantity__c,Invoice_Line_Item__c,Quantity__c FROM Return_Sales_Order_Line_Item__c WHERE Invoice_Line_Item__c in :inv2rsol.keySet() AND (Status__c='Completely processed' OR Status__c='Partially rejected')]){
        string currentRsol=inv2rsol.get(rr.Invoice_Line_Item__c);
        decimal invQty=rsol2qty.get(currentRsol);
        double qty=0;
        if(rr.Quantity__c!=null && rr.Status__c!='Partially rejected')qty=rr.Quantity__c;
        if(rr.Partially_Returned_Quantity__c!=null && rr.Status__c=='Partially rejected')qty=rr.Partially_Returned_Quantity__c;
        if(qty!=null)invQty=invQty-qty;
        rsol2qty.put(currentRsol,invQty);
    }
    
    for(Return_Sales_Order_Line_Item__c rr:triggernew){
        if(rr.Status__c=='Partially rejected')rr.Quantity__c=rr.Partially_Returned_Quantity__c;
        //Added by GRZ(Gurubaksh Grewal) change made to resolve the issue where completely processed records quantities are being set to zero
        if(rr.Status__c== 'Completely processed' && (rr.Partially_Returned_Quantity__c!=null && rr.Partially_Returned_Quantity__c!=0 ))rr.Quantity__c=rr.Partially_Returned_Quantity__c;
        if(rr.Status__c=='Completely rejected'||rr.Status__c=='Rejected'){
                rr.Partially_Returned_Quantity__c=0;
                rr.Quantity__c=0;
            }
        if(rsolWithModifiedQty.contains(rr.id)){
            string status1=triggerOldMap.get(rr.id).Status__c;
            system.debug('statusOld===='+status1);
            system.debug('statusNew===='+rr.Status__c);
            if(status1=='Open')rr.addError('You do not currently have the permission to modify the Quantity while the Status is open');
            /*if(currentUserProfile.Name!='SBU Profile') {
              
                if(currentUserProfile.Name!='Regional/Zonal Managers' && currentUserProfile.Name!='Regional/Zonal Manager SWAL'){
                   if(status1!='Error from SAP'&&status1!='Draft') rr.addError('You do not currently have the permission to modify the Quantity');
                }
                if((currentUserProfile.Name=='Regional/Zonal Managers' || currentUserProfile.Name=='Regional/Zonal Manager SWAL') && currentUserProfile.Name==rsol2Profile.get(rr.id)){
                   if(status1!='Error from SAP'&&status1!='Draft') rr.addError('You do not currently have the permission to modify the Quantity');
                }
            }*/
        }
        if(rr.quantity__c!=null&&rsolWithModifiedQty.contains(rr.id)){
            decimal permittedQty=rsol2qty.get(rr.id);
            if(currentProfileName!='Neebal Integration User' ){
            if(rr.Quantity__c>permittedQty)rr.addError((currentProfileName+' Quantity Exceeded: You cannot enter a value more than '+string.valueOf(permittedQty)+' for Return Sales Order:'+rr.name));
           } 
            if(rr.UOM__c=='NOS' || rr.UOM__c=='EA'){
                string stringQty=string.valueOf(rr.Quantity__c);
                if(stringQty.contains('.')){
                    Integer pointVal=(stringQty.split('.').size()>0)?Integer.valueOf(stringQty.split('.')[1]):0;
                    if(pointVal>0){rr.addError(('You must enter a whole number for this UOM'));}
                        
                    }
                }
            }
        if(rr.Quantity__c!=null&&rr.Net_Price_Per_Unit__c!=null)rr.Net_Amount__c=rr.Quantity__c*rr.Net_Price_Per_Unit__c;
        
        }
    }
}