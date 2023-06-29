/**************************************************************************************************
* Name             : grz_ReturnSalesOrderController                                                      
* Description      : Controller for the gRZ_ReturnSalesOrderInv LWC component that fetches 
					 data from the sales order and provides certain validations related to it's return.  
* Test Class       : grz_ReturnSalesOrderControllerTest
* Created Date     : 04-11-2022                                                                        
* Project/JIRA     : APPS-2818                                                                        
* Created By       : Gurubaksh Grewal (Grazitti)                                                                        
* Last Modified By : Gurubaksh Grewal (Grazitti) 05-12-2022                                                                        
**************************************************************************************************/

public class grz_ReturnSalesOrderController {
    @AuraEnabled(cacheable=true)
    public static object getAllData(String parameterId){
        id pid=(ID)parameterId;
		string obType=string.valueOf(pid.getSobjectType());
        map<string,object>obj2return=new Map<string,object>();
        if(obType=='Invoice__c')obj2return=getInvoiceData(parameterId);
        if(obType=='Sales_Order__c')obj2return=getSalesOrderData(parameterId,true);
        system.debug('=========================='+obj2return);
        return obj2return;
    }
    public static map<string,object> getInvoiceData(String invId){
		map<string,object>obj2return=new map<string,object>();
        Invoice__c inv = [select Id,Name,Sold_To_Party__c,Sales_Org_Code__c,Billing_Date__c,Billing_Doc_Number__c,Sales_Order__r.id from invoice__c where id =: invId Limit 1];
        integer netAmt=0;
        if(inv.Sold_To_Party__c!=null){
        	AggregateResult arI = [SELECT SUM(TotalAmount__c)ta FROM Invoice__c WHERE Sold_To_Party__c=:inv.Sold_To_Party__c AND Billing_Date__c = THIS_FISCAL_YEAR];
			integer totalAmtInv=integer.valueOf(arI.get('ta'));
        	AggregateResult arR = [SELECT SUM(Total_Amount__c)ta FROM Return_Sales_Order__c WHERE Sold_To_Party1__c=:inv.Sold_To_Party__c AND Order_Status__c='Completely processed' AND Order_Date__c = THIS_FISCAL_YEAR];
			integer totalAmtRet=integer.valueOf(arR.get('ta'));
            if(totalAmtRet==null)totalAmtRet=0;
            system.debug(totalAmtInv+'==========Aggregate=========='+totalAmtRet);
            if(totalAmtInv>totalAmtRet){
                netAmt=totalAmtInv-totalAmtRet;
            }
        }
        obj2return.put('ytdAmt',netAmt);
        obj2return.put('InvDetails',inv);
		obj2return.put('Invoices',null);
		obj2return.put('SoDetails',getSalesOrderData(inv.Sales_Order__r.id,false).get('SoDetails'));
		obj2return.put('isError',getSalesOrderData(inv.Sales_Order__r.id,false).get('isError'));
		obj2return.put('errorMsg',getSalesOrderData(inv.Sales_Order__r.id,false).get('errorMsg'));
         
        return obj2return; 
	} 
    
    public static map<string,object> getSalesOrderData(String soId,boolean getInvoices){
		map<string,object>obj2return=new map<string,object>();
        obj2return.put('isError',false);

        map<string,string>availableProfiles=new map<string,string>();
        for(ReturnSalesOrderOrgProfileMapping__mdt rsoMdt: [SELECT Label,Sales_Order_Codes__c FROM ReturnSalesOrderOrgProfileMapping__mdt]){
            availableProfiles.put(rsoMdt.label,rsoMdt.Sales_Order_Codes__c);
        }
        Id profileId = UserInfo.getProfileId(); 
		String profileName =[Select Id, Name from Profile where Id=:profileId].Name; 
		system.debug('Profile Name : '+profileName);
        
        map<string,Return_Sales_Order_Time_Frame__mdt> rsotList=new map<string,Return_Sales_Order_Time_Frame__mdt>();
        for(Return_Sales_Order_Time_Frame__mdt rso:[SELECT DeveloperName,End_Day__c,Id,Label,Sales_Org_Code__c,Start_Day__c FROM Return_Sales_Order_Time_Frame__mdt]){
            rsotList.put(rso.Sales_Org_Code__c,rso);
        }
        
        Sales_Order__c so = [select ID,Sales_Org_lk__c,Sales_Org_lk__r.Name,Order_Status__c,SalesOrgCode__c,Name,Sold_to_Party__c,Sold_to_Party__r.Account_Name__c,Sold_to_Party__r.SAP_Code__c from Sales_Order__c where id =: soId Limit 1];
		obj2return.put('SoDetails',so);
       	obj2return.put('InvDetails',null);
        
        if(so.Order_Status__c!='Completely processed'/*&&so.Order_Status__c!='Partially Rejected'&&so.Order_Status__c!='Partially processed'*/){
            obj2return.put('isError',true);
           	//obj2return.put('errorMsg','The selected sales order cannot be returned as it is not completely/partially processed.');
           	obj2return.put('errorMsg','The selected sales order cannot be returned as it is not completely processed.');
        }
        if(getInvoices==true){
        	List<Invoice__c> inv = [select Id,name,Billing_Date__c,Billing_Doc_Number__c,Sold_To_Party__c,Sold_To_Party__r.Name,Bill_To_Party__c,Bill_To_Party__r.Name,Nota_Fiscal__c,Billing_Status__c from invoice__c where Sales_Order__r.id =: soId];
            obj2return.put('Invoices',inv);

		}
		list<Sales_Order_Return_Config__c> sorc=[select id,sales_org__c from Sales_Order_Return_Config__c limit 1];
        if(sorc!=null && !sorc.isEmpty() && sorc[0].sales_org__c!=null){
            if(so.SalesOrgCode__c==null){
            	obj2return.put('isError',true);
            	obj2return.put('errorMsg','The selected sales order does not have a sales org linked to it.');
            }else{
                if(!(sorc[0].sales_org__c.contains(so.SalesOrgCode__c))){
                	obj2return.put('isError',true);
            		obj2return.put('errorMsg','You cannot file a return for the current sales org.');
				}
            }
        }

        if(!availableProfiles.containsKey(profileName)){
                obj2return.put('isError',true);
            	obj2return.put('errorMsg',('The Logged in user\'s profile- '+profileName+' does not have the permission to return the sales order.'));
		}
        if(rsotList.containsKey(so.SalesOrgCode__c)){
            integer sd=Integer.valueOf(rsotList.get(so.SalesOrgCode__c).Start_Day__c);
            integer ed=Integer.valueOf(rsotList.get(so.SalesOrgCode__c).End_Day__c);
            integer cd=system.today().day();
            if(!(cd>=sd&&ed>=cd)){
                obj2return.put('isError',true);
            	obj2return.put('errorMsg','The selected sales order cannot be returned owing to the time frame set by the Admin.');
            }
        }
        return obj2return;
	}
}