/**************************************************************************************************
* Name             : grz_returnSalesOrderHandler                                                      
* Description      : Handler to populate ZSM,SBU and Tm onto the return sales order,map equivalent
statuses on return sales order line items and provide
certain custom validations(error messages) via apex.
* Test Class       : grz_ReturnSalesOrderControllerTest
* Created Date     : 17-01-2023                                                                        
* Project/JIRA     : APPS-2818                                                                        
* Created By       : Gurubaksh Grewal (Grazitti)                                                                        
* Last Modified By : Gurubaksh Grewal (Grazitti) 06-03-2023                                                                        
**************************************************************************************************/
public class grz_returnSalesOrderHandler {
    public static void afterReturnInsert(map<id,Return_Sales_Order__c>TriggernewMap){
        list<Return_Sales_Order__c> rsoSFDC = new list<Return_Sales_Order__c>();
        for(Return_Sales_Order__c rso:[SELECT ID,SFDC_Order_Number__c,Name FROM Return_Sales_Order__c WHERE ID in : TriggernewMap.KeySet()]){
            if(rso.SFDC_Order_Number__c==null){
                rso.SFDC_Order_Number__c=rso.name.left(4)+rso.name.right(8);
                rsoSFDC.add(rso);
            }
        }
        if(rsoSFDC!=null && !rsoSFDC.isEmpty())update rsoSFDC;
    }
    
    public static void afterReturnUpdate(map<id,Return_Sales_Order__c>TriggernewMap,list<Return_Sales_Order__c>triggerold){
        map<string,string>retOrderWithChangedStatus=new map<string,string>();
        list<Return_Sales_Order_Line_Item__c> rsol2update = new list<Return_Sales_Order_Line_Item__c>();
        for(Return_Sales_Order__c rso:triggerold){
            if(rso.Order_Status__c != triggernewMap.get(rso.id).Order_Status__c){
                retOrderWithChangedStatus.put(rso.id,triggernewMap.get(rso.id).Order_Status__c);
            }
        }
        for(Return_Sales_Order_Line_Item__c rr:[SELECT ID,RSOLI_Combination_Key__c,Item_Number__c,Status__c,Return_Sales_Order__c,Return_Sales_Order__r.Order_status__c,Return_Sales_Order__r.SAP_Order_Number__c FROM Return_Sales_Order_Line_Item__c WHERE Return_Sales_Order__c in: retOrderWithChangedStatus.keySet()]){
            string parentStatus=retOrderWithChangedStatus.get(rr.Return_Sales_Order__c);
            if(parentStatus!=null&&(parentStatus=='Draft'||parentStatus=='Pending For Approval'||parentStatus=='Open')){
                rr.Status__c=parentStatus;
                rsol2update.add(rr);
            }else if(rr.Return_Sales_Order__r.SAP_Order_Number__c!=null &&(rr.Return_Sales_Order__r.Order_status__c=='Not yet processed'||rr.Return_Sales_Order__r.Order_status__c=='Partially processed'||rr.Return_Sales_Order__r.Order_status__c=='Completely processed'||rr.Return_Sales_Order__r.Order_status__c=='Partially Rejected'||rr.Return_Sales_Order__r.Order_status__c=='Rejected')){
                rr.RSOLI_Combination_Key__c=rr.Return_Sales_Order__r.SAP_Order_Number__c+'-'+rr.Item_Number__c;
                rsol2update.add(rr);
            }
            
        }
        
        if(rsol2update!=null && !rsol2update.isEmpty())update rsol2update;
    }
    
    public static void beforeReturnUpdateInsert(map<id,Return_Sales_Order__c>TriggernewMap,list<Return_Sales_Order__c>triggerold,list<Return_Sales_Order__c>triggernew){
        //SalesOrder__c Invoice__c 
        set<string> invoices2get =new set<string>(); 
        set<string> salesOrder2get =new set<string>(); 
        set<string> accounts2get =new set<string>(); 
        map<string,string> inv2salesAreaKey = new map<string,string>();
        map<string,string> inv2shipTo = new map<string,string>();
        map<string,string> inv2So = new map<string,string>();
        map<string,string> inv2BillTo = new map<string,string>();
        map<string,string> so2shipTo = new map<string,string>();
        map<string,string> so2BillTo = new map<string,string>();
        map<string,string> sold2shipTo = new map<string,string>();
        map<string,string> sold2BillTo = new map<string,string>();
        map<string,string> so2soldTo = new map<string,string>();
        map<string,list<string>> soldTo2soList = new map<string,list<string>>();
        map<string,map<string,string>> salesAreaKey2userIds =new map<string,map<string,string>>();
        map<string,map<string,string>> salesAreaKey2ZonRegSBU =new map<string,map<string,string>>();
        string currentProfileName='';
        for(User u: [SELECT id,Profile.Name from USER WHERE id =: UserInfo.getUserId()]){
            currentProfileName=u.Profile.Name;
        }
        
        
        for(Return_Sales_Order__c rso:triggernew){
            invoices2get.add(rso.Invoice__c);
            salesOrder2get.add(rso.SalesOrder__c);
        }
        
        for(Invoice__c inv:[SELECT Ship_To_Party__c,Sales_Order__c,Bill_To_Party__c,Sales_Org__c,Division__c,Distribution_Channel__c,Id FROM Invoice__c WHERE Id in: invoices2get]){
            string salesAreaKey='';
            salesAreaKey=salesAreaKey+((inv.Sales_Org__c==null?'':inv.Sales_Org__c))+((inv.Division__c==null?'':inv.Division__c))+((inv.Distribution_Channel__c==null?'':inv.Distribution_Channel__c));
            inv2salesAreaKey.put(inv.id,salesAreaKey);
            inv2shipTo.put(inv.id,inv.Ship_To_Party__c);
            inv2SO.put(inv.id,inv.Sales_Order__c);
            inv2billTo.put(inv.id,inv.Bill_To_Party__c);
        }
        
        for(Sales_Order__c so:[Select id,Sold_to_Party__c,Ship_To_Party__c,Bill_To_Party__c from Sales_Order__c WHERE Id in:salesOrder2get]){
            so2soldTo.put(so.id,so.Sold_to_Party__c);
            so2shipTo.put(so.id,so.Ship_To_Party__c);
            so2billTo.put(so.id,so.Bill_To_Party__c);
            
        }
        
        for(Account acc:[SELECT Id,Account_Type__c,Sold_To_Party__c FROM Account WHERE Sold_To_Party__c in: so2soldTo.values()]){
            if(acc.Account_Type__c=='Bill To Party')sold2BillTo.put(acc.Sold_To_Party__c,acc.id);
            //if(acc.Account_Type__c=='Ship To Party')sold2ShipTo.put(acc.Sold_To_Party__c,acc.id);
        }
        
        for(Shipping_Location__c sl:[SELECT Id,Distributor__c FROM Shipping_Location__c WHERE Distributor__c in: so2soldTo.values()]){
            sold2ShipTo.put(sl.Distributor__c,sl.id);
        }
        
        for(DistributorSalesAreaMapping__c dsam:[SELECT ID,SalesOrg__c,Division__c,DistributionChannel__c,Territory__c,Territory__r.Zone__c,Territory__r.Zone__r.Name,
                                                 Territory__r.TerritoryManager__c,Territory__r.Zone__r.ZonalHead__c,Territory__r.Zone__r.ZMMUser__c,
                                                 Territory__r.Zone__r.ZonalHead__r.Profile.Name,Territory__r.Zone__r.ZMMUser__r.Profile.Name,
                                                 Territory__r.SBU__c,Territory__r.SBU__r.SBUUser__c,Territory__r.SBU__r.SBUMarketingHeads__c,Territory__r.SBU__r.Name,
                                                 Territory__r.Region__c,Territory__r.Region__r.RegionHead__c,Territory__r.Region__r.FMM_User__c,Territory__r.Region__r.Name,
                                                 Territory__r.Region__r.RegionHead__r.Profile.Name,Territory__r.Region__r.FMM_User__r.Profile.Name,
                                                 Territory__r.TerritoryManager__r.Profile.Name FROM DistributorSalesAreaMapping__c WHERE Distributor__c in: so2soldTo.values()]){
                                                     string salesAreaKey='';  
                                                     map<string,string>regZonSBU=new map<string,string>{'SBU'=>null,'Zone'=>null,'Region'=>null};
                                                         salesAreaKey=salesAreaKey+((dsam.SalesOrg__c==null?'':dsam.SalesOrg__c))+((dsam.Division__c==null?'':dsam.Division__c))+((dsam.DistributionChannel__c==null?'':dsam.DistributionChannel__c));
                                                     map<string,string> profile2user = new map<string,string>{'TM'=>null,'ZM'=>null,'ZMM'=>null,'SBU'=>null,'SBUM'=>null,'RH'=>null,'FMM'=>null};
                                                         system.debug('dsam.Territory__c=========='+JSON.serializePretty(dsam));
                                                     if(dsam.Territory__c!=null){
                                                         if(dsam.Territory__r.Zone__c!=null){
                                                             regZonSBU.put('Zone',dsam.Territory__r.Zone__r.Name);
                                                             profile2user.put('ZM',dsam.Territory__r.Zone__r.ZonalHead__c);   
                                                             profile2user.put('ZMProfile',dsam.Territory__r.Zone__r.ZonalHead__r.Profile.Name);   
                                                             profile2user.put('ZMM',dsam.Territory__r.Zone__r.ZMMUser__c);   
                                                             profile2user.put('ZMMProfile',dsam.Territory__r.Zone__r.ZMMUser__r.Profile.Name);   
                                                         }
                                                         if(dsam.Territory__r.SBU__c!=null){
                                                             regZonSBU.put('SBU',dsam.Territory__r.SBU__r.Name);
                                                             profile2user.put('SBU',dsam.Territory__r.SBU__r.SBUUser__c);   
                                                             profile2user.put('SBUM',dsam.Territory__r.SBU__r.SBUMarketingHeads__c);   
                                                         }
                                                         if(dsam.Territory__r.Region__c!=null){
                                                             regZonSBU.put('Region',dsam.Territory__r.Region__r.Name);
                                                             profile2user.put('RH',dsam.Territory__r.Region__r.RegionHead__c);   
                                                             profile2user.put('RHProfile',dsam.Territory__r.Region__r.RegionHead__r.Profile.Name);   
                                                             profile2user.put('FMM',dsam.Territory__r.Region__r.FMM_User__c);   
                                                             profile2user.put('FMMProfile',dsam.Territory__r.Region__r.FMM_User__r.Profile.Name);   
                                                         }
                                                         if(dsam.Territory__r.TerritoryManager__c!=null){
                                                             profile2user.put('TM',dsam.Territory__r.TerritoryManager__c); 
                                                             profile2user.put('TMProfile',dsam.Territory__r.TerritoryManager__r.Profile.Name);    
                                                         }
                                                         
                                                     }
                                                     salesAreaKey2userIds.put(salesAreaKey,profile2user);
                                                     salesAreaKey2ZonRegSBU.put(salesAreaKey,regZonSBU);                                        
                                                 }
        
        for(Return_Sales_Order__c rso:triggernew){
            if(currentProfileName=='Neebal Integration User' ){
                if(trigger.isInsert)rso.Created_From__c='SAP';
                if(rso.Invoice__c!=null && inv2SO.containsKey(rso.Invoice__c))rso.SalesOrder__c=inv2SO.get(rso.Invoice__c);
            }
            if(rso.Created_From__c=='SFDC')rso.Order_Date__c=system.today();
            string salesAreaKey=inv2salesAreaKey.get(rso.Invoice__c);
            if(so2soldTo.containsKey(rso.SalesOrder__c))rso.Sold_To_Party1__c=so2soldTo.get(rso.SalesOrder__c);
            
            if(inv2shipTo.containsKey(rso.Invoice__c) && inv2shipTo.get(rso.Invoice__c)!=null)rso.Ship_To_Party__c=inv2shipTo.get(rso.Invoice__c);
            else if(so2shipTo.containsKey(rso.SalesOrder__c) && so2shipTo.get(rso.SalesOrder__c)!=null)rso.Ship_To_Party__c=so2shipTo.get(rso.SalesOrder__c);
            else if(sold2ShipTo.containsKey(rso.Sold_To_Party1__c) && sold2ShipTo.get(rso.Sold_To_Party1__c)!=null)rso.Ship_To_Party__c=sold2ShipTo.get(rso.Sold_To_Party1__c);
            
            if(inv2BillTo.containsKey(rso.Invoice__c) && inv2BillTo.get(rso.Invoice__c)!=null)rso.Bill_To_Party__c=inv2BillTo.get(rso.Invoice__c);
            else if(so2BillTo.containsKey(rso.SalesOrder__c) && so2BillTo.get(rso.SalesOrder__c)!=null)rso.Bill_To_Party__c=so2BillTo.get(rso.SalesOrder__c);
            else if(sold2BillTo.containsKey(rso.Sold_To_Party1__c) && sold2BillTo.get(rso.Sold_To_Party1__c)!=null)rso.Bill_To_Party__c=sold2BillTo.get(rso.Sold_To_Party1__c);
            if(salesAreaKey2ZonRegSBU.containsKey(salesAreaKey)){
                map<string,string> regZonSBU= salesAreaKey2ZonRegSBU.get(salesAreaKey);
                rso.SBU_name__c=regZonSBU.get('SBU');
                rso.Zone__c=regZonSBU.get('Zone');
                rso.Region__c=regZonSBU.get('Region');
            }
            
            if(salesAreaKey2userIds.containsKey(salesAreaKey)){
                map<string,string> profile2user= salesAreaKey2userIds.get(salesAreaKey);
                //rso.SBU__c=profile2user.get('SBU');
                //rso.ZSM__c=profile2user.get('ZSM');
                //rso.Territory_Manager__c=profile2user.get('TM');
                //rso.OwnerId=rso.Territory_Manager__c;
                
                if(rso.Sales_Org_Code__c=='1210'){
                    rso.Submitter_1__c=profile2user.get('TM');
                    rso.Submitter_1_Profile__c=profile2user.get('TMProfile');
                    if(profile2user.get('FMM')!=null){
                        rso.Submitter_3__c=profile2user.get('FMM');
                        rso.Submitter_3_profile__c=profile2user.get('FMMProfile');
                        rso.Approver_1__c=profile2user.get('FMM');
                    }
                    if(profile2user.get('RH')!=null){
                        rso.Submitter_2__c=profile2user.get('RH');
                        rso.Submitter_2_Profile__c=profile2user.get('RHProfile');
                        rso.Approver_1__c=profile2user.get('RH');
                    }
                    
                    if(profile2user.get('ZMM')!=null){
                        rso.Approver_2__c=profile2user.get('ZMM');
                    }
                    if(profile2user.get('ZM')!=null){
                        rso.Approver_2__c=profile2user.get('ZM');
                    }
                }
                else{
                    rso.Submitter_1__c=profile2user.get('TM');
                    rso.Submitter_1_Profile__c=profile2user.get('TMProfile');
                    if(profile2user.get('ZMM')!=null){
                        rso.Submitter_3__c=profile2user.get('ZMM');
                        rso.Submitter_3_Profile__c=profile2user.get('ZMMProfile');
                        rso.Approver_1__c=profile2user.get('ZMM');
                    }
                    if(profile2user.get('ZM')!=null){
                        rso.Submitter_2__c=profile2user.get('ZM');
                        rso.Submitter_2_Profile__c=profile2user.get('ZMProfile');
                        rso.Approver_1__c=profile2user.get('ZM');
                    }
                    
                    if(profile2user.get('SBUM')!=null){
                        rso.Approver_2__c=profile2user.get('SBUM');
                    }
                    if(profile2user.get('SBU')!=null){
                        rso.Approver_2__c=profile2user.get('SBU');
                    }
                }
                string prof=userInfo.getProfileId();
                profile pr=[SELECT Id,Name FROM Profile WHERE Id =:prof];
                system.debug('Created_by_Profile__c======='+rso.Created_by_Profile__c);
                system.debug('prName======='+pr.name);
                system.debug(rso.Submitter_2_Profile__c+'SubmitterProfile======='+rso.Submitter_3_Profile__c);
                //Changes made by Gurubaksh Grewal for multi Approval processes (APPS-4957)                
                if(pr.name==rso.Submitter_1_Profile__c){
                    rso.isApprover1__c=true;
                    rso.isApprover2__c=true;
                    system.debug('*******170********');
                }
                if(pr.name==rso.Submitter_2_Profile__c||pr.name==rso.Submitter_3_Profile__c){
                    rso.isApprover1__c=false;
                    rso.isApprover2__c=true;
                    system.debug('*******174********');
                    
                }
                //Changes made by Gurubaksh Grewal for multi Approval processes (APPS-4957)                
                
                if(pr.name=='System Administrator'){
                    rso.isApprover1__c=true;
                    rso.isApprover2__c=true;
                }
                if(rso.Submitter_1__c!=null)rso.OwnerId=rso.Submitter_1__c;
            }
        }
    }
}