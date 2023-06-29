/**************************************************************************************************
* Name               : Grz_SAPSyncShipLocation                                                      
* Description        : Used for ShipLocation SAP integration
* Created Date       : 19/01/2022                                                                 
* Created By         : Gurubaksh Grewal (Grazitti)  
* JIRA               : APPS-2665
**************************************************************************************************/ 
public class Grz_SAPSyncShipLocation {
    @AuraEnabled
    public static map<string,object> initiateSync(String recordId){
        
        map<string,string> api2label=new map<string,string>();
        map<string,string> label2api=new map<string,string>();
        map<string,string> label2err=new map<string,string>();
        map<string,object> obj2ret=new map<string,object>{'error'=>null,'success'=>null};
            map<string,object> jsonMap=new map<string,object>();
        map<string,boolean> label2reqd=new map<string,boolean>();
        list<string> fldLst=new list<string>(); 
        list<string> keyLst=new list<string>(); 
        
        string currentProfileName='';
        for(User u: [SELECT id,Profile.Name from USER WHERE id =: UserInfo.getUserId()]){
            currentProfileName=u.Profile.Name;
        }
        system.debug('currentProfileName========='+currentProfileName);
        list<string> errorList=new list<string>();

        if(currentProfileName!='System Administrator')obj2ret.put('error',new list<string>{'The current user does not have permission to Sync with SAP!'});
        if(obj2ret.containsKey('error') && obj2ret.get('error')!=null) return obj2ret;
        for(Grz_Shipping_Field_Map__mdt fm:[SELECT ErrorMsg__c,ApiName__c,Label,Required__c FROM Grz_Shipping_Field_Map__mdt]){
            api2label.put(fm.ApiName__c,fm.label);
            label2api.put(fm.label,fm.ApiName__c);
            label2err.put(fm.label,fm.ErrorMsg__c);
            label2reqd.put(fm.label,fm.Required__c);
            keyLst.add(fm.label);
        } 
        fldLst.addAll((api2label.keySet()));
        string fields2ret=string.join(fldLst,',');
        fields2ret=fields2ret+',Non_GST_customer__c,SAP_Response__c,SAP_Code__c,Distributor__r.SAP_Code__c';
        String queryVal='Select Id,'+fields2ret+' from Shipping_Location__c where id = \''+recordId+'\' limit 1';
        List<Shipping_Location__c> shippingLoc=Database.query(queryVal);
        map<string,object>shippingMap=(map<string,object>)json.deserializeUntyped(json.serialize(shippingLoc[0]));
        for(string str:fldLst){ 
            
            if(shippingMap.containsKey((str)) || (str.contains('.') &&  shippingMap.containsKey((str.split('\\.')[0]))  )){
                if(str.contains('__r')){
                    map<string,object>shippingMapC=(map<string,object>)json.deserializeUntyped(json.serialize(shippingMap.get((str.split('\\.')[0]))));
                    if(shippingMapC.containsKey(str.split('\\.')[1])&&shippingMapC.get(str.split('\\.')[1])!=null){
                        jsonMap.put(api2label.get(str),shippingMapC.get(str.split('\\.')[1]));  
                        if(str=='Division__r.Division_Code__c'){
                            string dcode=string.valueOf(shippingMapC.get(str.split('\\.')[1]));
                            if(dcode=='10')jsonMap.put('AcctAssignmentGroup','04');
                            if(dcode=='92')jsonMap.put('AcctAssignmentGroup','15');
                        }if(str=='Sales_Org__r.Company_Code__c'){
                            jsonMap.put('CompanyCode',shippingMapC.get(str.split('\\.')[1]));
                            jsonMap.put('CorporateGroup',shippingMapC.get(str.split('\\.')[1]));
                        }
                        if(str=='Depot__r.Depot_Code__c'){
                            jsonMap.put('Authorization',shippingMapC.get(str.split('\\.')[1]));
                        }
                    }                                                                 
                }else{
                    if(shippingMap.get(str)!=null){
                        jsonMap.put(api2label.get(str),shippingMap.get(str));
                        if(str=='Country_Name__c'&&(((string.valueOf(shippingMap.get(str)))=='India')||((string.valueOf(shippingMap.get(str)))=='IN'))){
                            jsonMap.put('TransportaionZone','IN'); 
                            if(shippingLoc[0].Non_GST_customer__c==false)jsonMap.put('EInvoicecategory','1');   
                            if(shippingLoc[0].Non_GST_customer__c==true)jsonMap.put('EInvoicecategory','2');   
                        }
                        if(str=='Country_Name__c'&&(((string.valueOf(shippingMap.get(str)))=='Nepal')||((string.valueOf(shippingMap.get(str)))=='NP'))){
                            jsonMap.put('TransportaionZone','NP');   
                            jsonMap.put('E-invoice category','6');   
                        }
                    } 
                }
            }
        }
        if(shippingLoc[0].SAP_Code__c!=null)errorList.add('The Shipping Location has been already Synced');
        for(string str:keyLst){
            
            if(label2reqd.get(str)==true){
                
                if(!jsonMap.containsKey(str)){
                    system.Debug('str================================'+str);
                    if(label2err.containsKey(str))errorList.add(label2err.get(str));
                }
            }
        }
        system.debug(JSON.serializePretty(jsonMap));
        system.debug(JSON.serializePretty(errorList));
        
        if(errorList!=null && !errorList.isEmpty() && !Test.isRunningTest())obj2ret.put('error', errorList);
        else{
            //Error_In_Sap
            //Fetching endpoint as per sales org from custom metadata
            Map<String, Grz_Customer360IntegrationMappings__mdt> integrationSettingsMap = new Map<String, Grz_Customer360IntegrationMappings__mdt>();
            for(Grz_Customer360IntegrationMappings__mdt data: Grz_Customer360IntegrationMappings__mdt.getAll().values()){
                integrationSettingsMap.put(data.Sales_Org_Code__c, data);
            }
            Grz_Customer360IntegrationMappings__mdt metadataRecord=new Grz_Customer360IntegrationMappings__mdt();
            if(!integrationSettingsMap.isEmpty() && integrationSettingsMap.containsKey(shippingLoc[0].Sales_Org_Code__c)){
                metadataRecord=integrationSettingsMap.get(shippingLoc[0].Sales_Org_Code__c);
            }
            System.debug('metadataRecord==>'+metadataRecord);
            string response=Grz_OnboardingSAPIntegration.syncMethod(JSON.serialize(jsonMap),metadataRecord);
            if(response=='Error_In_Sap')obj2ret.put('error', (new list<string>{'Error while integrating with SAP'}));
            else {
                obj2ret.put('success', response);
                Shipping_Location__c sl=new Shipping_Location__c(id=recordId);
                system.debug('respJsp=================='+response);
                map<string,object> respMap=(map<string,object>)JSON.deserializeUntyped(response);
                if(respMap.containsKey('item')){
                    map<string,object> respMap1=(map<string,object>)respMap.get('item');
                    if(respMap1.containsKey('Combination_Key')&&respMap1.get('Combination_Key')!=null){
                        string ckey=string.valueOf(respMap1.get('Combination_Key'));
                        if(cKey.trim()!='')sl.combination_key__c=ckey;
                        sl.SAP_Code__c=ckey.split(shippingLoc[0].Distributor__r.SAP_Code__c)[1];
                        obj2ret.put('error', '');
                    }
                    else{
                        string ckey=string.valueOf(respMap1.get('SAP_Response'));
                        obj2ret.put('error', ckey);
                    }
                    if(respMap1.containsKey('SAP_Response')&&respMap1.get('SAP_Response')!=null){
                        string ckey=string.valueOf(respMap1.get('SAP_Response'));
                        if(cKey.trim()!=''){
                            sl.SAP_Response__c=ckey;
                            //if(ckey.contains('Ship to Party'))sl.SAP_Code__c=ckey.split(' ')[0];
                        }
                    }
                    update sl;
                }
                system.debug('return====================='+(response));
            }
        }
        
        
        return obj2ret;
    }
}