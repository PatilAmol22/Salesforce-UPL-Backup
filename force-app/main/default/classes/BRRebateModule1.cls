/*controller for the RebateCalculator Aura Component
 * test class: BRRebateModule_Test
 * Gurubaksh Grewal(Grazitti) (RITM0534476/RITM0523779 )
 * Date Created:15-03-23
 * Last Modified:17-04-23
 * */
public without sharing class BRRebateModule1 {
    
    @AuraEnabled
    public static object getgoalvsActualCalculations(string contractId){
        set<string> pcategory=new set<string>();
        set<string> brandNames=new set<string>();
        map<string,object> ob2ret=new map<string,object>();
        list<map<string,object>> rebList=new list<map<string,object>>();
        
        String companyCode= UPL_Settings__c.getOrgDefaults().Company_Code__c;
        String sales_Org = UPL_Settings__c.getOrgDefaults().BR_Sales_Org__c;
        Rebate_Contract__c re =[select Category_Code__c,Type_Code__c,Name,Type__c,Distributor_Name__c,
                                Region__c,Region__r.Zone__c,Region__r.Zone__r.Name, Category_Name__c, Region_Name__c,
                                Sales_Rep__c,Start_Date__c, End_Date__c, Distributor__c,Distributor__r.SAP_Code__c 
                                from Rebate_Contract__c WHERE Id=:contractId and Sales_Org__r.Sales_Org_Code__c =:sales_Org limit 1][0];
        string sYr=string.valueOf(system.today().year());
        if(re.Start_Date__c!=null) sYr=string.valueOf(re.Start_Date__c.year());
        map<string,decimal>percMap=new map<string,decimal>();
        for(Rebate_Percentage_Calculation__c rpc:[SELECT Percentage__c,Product_Classification__c 
                                                  FROM Rebate_Percentage_Calculation__c WHERE Type__c = :re.Type_Code__c 
                                                  AND Client_Classification__c = :re.Category_Code__c AND Year__c=: sYr
                                                  AND Percentage__c!=null AND Product_Classification__c!=null]){
                                                      percMap.put(rpc.Product_Classification__c,rpc.Percentage__c);  
                                                  }
        BRRebateModule.goalvsActualCalculations GAWrapper = new BRRebateModule.goalvsActualCalculations();
        GetContractRequestWrapper req = new GetContractRequestWrapper();
        req.initialContractNumber=re.Name;
        req.companyCode=companyCode;
        map<string,string>subDistMap=new map<string,string>();
        map<string,object> distMap=RebateServiceHelper.getDistributors(req);
        if(distMap!=null && distMap.containsKey('Distibutorlist')){
            map<string,object>itemMap=(map<string,object>)distMap.get('Distibutorlist');
            if(itemMap!=null && itemMap.containsKey('item')){
                system.debug('=======response11111111111=====>'+JSON.serializePretty(itemMap));
                list<object> itemList=new list<object>();
                
                try{
                    itemList=(list<object>)itemMap.get('item');
                }catch(exception e){
                    itemList.add(((map<string,object>)itemMap.get('item')));
                }
                if(itemList!=null && !itemList.isEmpty()){
                    for(object ob1:itemList){
                        map<string,object>itemMap1=(map<string,object>)ob1;
                        if(itemMap1!=null&&itemMap1.containsKey('SAPCode')){
                            string subSap=string.valueOf(itemMap1.get('SAPCode'));
                            if(subSap!=re.Distributor__r.SAP_Code__c){
                                subDistMap.put(subSap,null);
                            }
                        }
                    }
                }
            }
        }
        list<Sub_Distributor__c>sd2ins=new list<Sub_Distributor__c>();
        for(account acc:[SELECT ID,SAP_Code__c FROM Account WHERE SAP_Code__c in: subDistMap.keySet()]){
            subDistMap.put(acc.SAP_Code__c,acc.id);
        }
        if(subDistMap!=null && !subDistMap.values().isEmpty()){
            for(string accid:subDistMap.values()){
                if(accid!=null)sd2ins.add(new Sub_Distributor__c(Rebate_Contract__c=contractId,Distributor__c=accid));
            }
        }
        
        GetGoalActualsRequestWrapper act= new GetGoalActualsRequestWrapper();
        act.companyCode=companyCode;
        act.contractNumber=re.Name;//contract name
        Boolean response; 
        response=RebateServiceHelper.GetGoalActuals(act);
        delete [SELECT ID FROM Sub_Distributor__c WHERE Rebate_Contract__c=:contractId];
        system.debug('sd2ins=========='+JSON.serializePretty(sd2ins));
        if(sd2ins!=null && !sd2ins.isEmpty())insert sd2ins;
        
        if(!response){
            
            ob2ret.put('PCategory', null);
            ob2ret.put('liRebGoal',null);
            ob2ret.put('contract',null);
            ob2ret.put('error',true);
            return ob2ret;
        }else
        {
            list<Rebate_Goal_Brand__c> rebBrand = new list<Rebate_Goal_Brand__c>([SELECT Actual_Value__c,Actual_Volume__c,Product_Category_Code__c,
                                                                                  Attainment_Volume__c,Brand_Name__c,Product_Category__c,
                                                                                  Name,Net_Value__c,Net_Volume__c,Returns_Value__c,
                                                                                  Returns_Volume__c,Total_Actual_Value__c,Total_Returns_Value__c,
                                                                                  Value_LY__c,Value__c,Volume_LY__c,Volume__c FROM Rebate_Goal_Brand__c where Contract__r.name =:re.name and Contract__r.Sales_Org__r.Sales_Org_Code__c=:sales_Org]);
            double oAcva=0,oAcvo=0,ova=0,ovo=0,oRva=0,oRvo=0,oova=0,oovo=0;
            map<string,object>outro=new map<string,object>();
            map<string,double>prod2qty=new map<string,double>();
            map<string,double>prod2price=new map<string,double>();
            for(Rebate_Goal_Brand__c rB: rebBrand)
            {
                
                if(rb.Product_Category__c!='Outros'){
                    
                    map<string,object>ob=(map<string,object>)json.deserializeUntyped(json.serialize(rb));  
                    pcategory.add(rB.Product_Category__c);
                    if(rb.Product_Category_code__c!=null && percMap.containsKey(rb.Product_Category_code__c))ob.put('Rebate_Percent',percMap.get(rb.Product_Category_code__c));
                    else ob.put('Rebate_Percent',0);
                    ob.put('OO_Value__c',0);
                    ob.put('OO_Volume__c',0);
                    ob.put('CO_Value__c',0);
                    ob.put('CO_Volume__c',0);
                    ob.put('NN_Value__c',0);
                    ob.put('NN_Volume__c',0);
                    ob.put('ND_Value__c',0);
                    ob.put('ND_Volume__c',0);
                    rebList.add(ob);
                    prod2qty.put(rB.Brand_Name__c,0);
                    prod2price.put(rB.Brand_Name__c,0);
                    brandNames.add(rB.Brand_Name__c);
                }else
                {
                    outro=(map<string,object>)json.deserializeUntyped(json.serialize(rb));
                    oAcva=rb.Actual_Value__c==null?(oAcva+0):(oAcva+rb.Actual_Value__c);
                        oAcvo=rb.Actual_Volume__c==null?(oAcvo+0):(oAcvo+rb.Actual_Value__c);
                            ova=rb.Value__c==null?(ova+0):(ova+rb.Value__c);
                                ovo=rb.Volume__c==null?(ovo+0):(ovo+rb.Volume__c);
                                    oRva=rb.Returns_Value__c==null?(oRva+0):(oRva+rb.Returns_Value__c);
                                        oRvo=rb.Returns_Volume__c==null?(oRvo+0):(oRvo+rb.Returns_Volume__c); 
                                            }
            }
            if(outro.keySet()!=null && !outro.keySet().isEmpty()){
                outro.put('Brand_Name__c','DEMAIS PRODUTOS');
                outro.put('Product_Category__c','Demais');
                outro.put('Actual_Value__c',oacva);
                outro.put('Actual_Volume__c',oacvo);
                outro.put('Value__c',ova);
                outro.put('Volume__c',ovo);
                outro.put('Returns_Value__c',orva);
                outro.put('Returns_Volume__c',orvo);
                outro.put('OO_Value__c',0);
                outro.put('OO_Volume__c',0);
                outro.put('CO_Value__c',0);
                outro.put('CO_Volume__c',0);
                outro.put('NN_Value__c',0);
                outro.put('NN_Volume__c',0);
                outro.put('ND_Value__c',0);
                outro.put('ND_Volume__c',0);
                prod2qty.put('DEMAIS PRODUTOS',0);
                prod2price.put('DEMAIS PRODUTOS',0);
                outro.put('Rebate_Percent',0);
                rebList.add(outro);
            }
            date dt1= date.valueOf(re.start_date__c);
            date dt2= date.valueOf(re.end_date__c);
            //include end dt b4 deployment
            for(Open_Order__c oo:[SELECT Id,Product__c,Product__r.Brand_Name__c,Qty_ORD__c, Net_Sales_ORD__c,Data_de_Faturamento__c
                                  FROM Open_Order__c WHERE  (Customer__c=: re.Distributor__c OR Customer__c in: subDistMap.values())
                                  AND Data_de_Faturamento__c >=: dt1])
            {
                system.debug('openOrder==================>'+JSON.serializePretty(oo));
                if(oo.Product__c!=null&&oo.Product__r.Brand_Name__c!=null && brandNames.contains(oo.Product__r.Brand_Name__c)){
                    if(prod2qty.containsKey(oo.Product__r.Brand_Name__c)){
                        prod2qty.put(oo.Product__r.Brand_Name__c,(prod2qty.get(oo.Product__r.Brand_Name__c)+oo.Qty_ORD__c));
                        if(re.End_Date__c!=null&&re.End_Date__c<system.today())prod2qty.put(oo.Product__r.Brand_Name__c,0);    
                    }
                    if(prod2price.containsKey(oo.Product__r.Brand_Name__c)){
                        prod2price.put(oo.Product__r.Brand_Name__c,(prod2price.get(oo.Product__r.Brand_Name__c)+oo.Net_Sales_ORD__c));
                        if(re.End_Date__c!=null&&re.End_Date__c<system.today())prod2price.put(oo.Product__r.Brand_Name__c,0);
                    }
                    
                    
                }else{
                    if(prod2qty.containsKey('DEMAIS PRODUTOS')){
                        prod2qty.put('DEMAIS PRODUTOS',(prod2qty.get('DEMAIS PRODUTOS')+oo.Qty_ORD__c));
                        if(re.End_Date__c!=null&&re.End_Date__c<system.today())prod2qty.put(oo.Product__r.Brand_Name__c,0);    
                    }
                    if(prod2price.containsKey('DEMAIS PRODUTOS')){
                        prod2price.put('DEMAIS PRODUTOS',(prod2price.get('DEMAIS PRODUTOS')+oo.Net_Sales_ORD__c));
                        if(re.End_Date__c!=null&&re.End_Date__c<system.today())prod2price.put('DEMAIS PRODUTOS',0);
                    }
                }
            } 
            
            for(map<string,object>ob:rebList){
                if(prod2qty.containsKey(string.valueOf(ob.get('Brand_Name__c'))))ob.put('OO_Volume__c',double.valueOf(prod2qty.get(string.valueOf(ob.get('Brand_Name__c')))));
                else ob.put('DEMAIS PRODUTOS',double.valueOf(prod2qty.get(string.valueOf(ob.get('DEMAIS PRODUTOS')))));
                
                if(prod2price.containsKey(string.valueOf(ob.get('Brand_Name__c'))))ob.put('OO_Value__c',double.valueOf(prod2price.get(string.valueOf(ob.get('Brand_Name__c')))));
                else ob.put('DEMAIS PRODUTOS',double.valueOf(prod2price.get(string.valueOf(ob.get('DEMAIS PRODUTOS')))));
                
            }
            
            ob2ret.put('PCategory', PCategory);
            ob2ret.put('liRebGoal',rebList);
            if(re.Region__c!=null && re.Region__r.Zone__c!=null)ob2ret.put('BU',re.Region__r.Zone__r.Name); else ob2ret.put('BU','');
            ob2ret.put('contract',re);
            ob2ret.put('error',false);
            if(re.End_Date__c!=null&&re.End_Date__c<system.today())ob2ret.put('valid',false);
            else ob2ret.put('valid',true);
            return ob2ret;
            
        }
    }
    
    @future(callout=true)
    public static void pushSubDistributors(string contractId){
        getgoalvsActualCalculations(contractId);
    }
}