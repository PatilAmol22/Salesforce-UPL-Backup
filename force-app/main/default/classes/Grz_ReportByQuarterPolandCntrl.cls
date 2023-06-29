public without sharing class Grz_ReportByQuarterPolandCntrl {
    @AuraEnabled
    public static MainGlobalWrapper getPickListValuesIntoList( String quater, String Year , list<String> brand){
        system.debug('test');
        MainGlobalWrapper res = new MainGlobalWrapper();
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = Liquidation_Annual_Plan__c.FIscal_Year__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }   
        Boolean isSubmit = false;
        Date start_date = Date.newInstance(Integer.valueOf(year), 4, 1);
        String salesOrgCode=System.Label.Grz_PolandSalesOrgCode;
        Id rec_type = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
        
        list<aggregateresult > acc = new list<aggregateresult >();
        list<aggregateresult > description = new list<aggregateresult >();
        distributor dis = new distributor();
        list<distributor> disList = new list<distributor>();
        list<distributor> descriptionList = new list<distributor>();
        
        list<distributor> distributorList = new list<distributor>();
        list<string> dis_ids = new list<string>();
        
        
        if(brand.size()> 0){
            description= [SELECT SKU_Description__c FROM SKU__c where Sales_Org_Code__c = '2941' and Active_for_Liquidation__c = true and SKU_Description__c != null and Brand_Name__c in : brand and SKU_Description__c != '' group by SKU_Description__c];
            if(description.size() >0){
                for(aggregateresult a : description){
                    dis = new distributor();
                    dis.label = (String)a.get('SKU_Description__c');
                    dis.value = (String)a.get('SKU_Description__c');
                    descriptionList.add(dis);
                }
            }
        }
        
        else{
            
            liqList = [Select submitted__c,Quarter__c from Liquidation2__c where submitted__c = true and SKU__r.Active_for_Liquidation__c = true and Quarter__c =:quater and Liquidation_Annual_Plan__r.Fiscal_Start_Date__c=:start_date and Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c =: salesOrgCode  and RecordTypeId=:rec_type limit 1];        
            if(liqList.size()>0){
                isSubmit = true;
            }
            
            
            acc= [SELECT Brand_Name__c FROM SKU__c where Sales_Org_Code__c = '2941' and Active_for_Liquidation__c = true and Brand_Name__c != null and Brand_Name__c != '' group by Brand_Name__c];
            if(acc.size() >0){
                for(aggregateresult a : acc){
                    dis = new distributor();
                    dis.label = (String)a.get('Brand_Name__c');
                    dis.value = (String)a.get('Brand_Name__c');
                    disList.add(dis);
                }
            }
            
            
            
            list<Account> accList = new list<Account>();
            distributor customer = new distributor();
            list<aggregateresult> disMap = [select count( Id), Distributor__c,Distributor__r.Name,Distributor__r.SAP_code__c from DistributorSalesAreaMapping__c where AccountType__c='Sold To Party' and Distributor__r.Active_for_Liquidation__c=true and Distributor__r.sales_org__r.Sales_Org_Code__c='2941' and Distributor__r.RecordType.Name='Distributor' group by Distributor__c ,Distributor__r.Name, Distributor__r.SAP_code__c HAVING count(ID) >=1];
            if(disMap.size() >0){
                for(aggregateresult disres : disMap){
                    dis_ids.add((String)disres.get('Distributor__c'));
                }
            }
            String country_name;
            if(test.isRunningTest()){
                country_name = 'Poland';
            }else{
                country_name = [Select id,Country from User where Id=:UserInfo.getUserId()].Country;
            }
            if(country_name=='Poland'){
                accList= [select Id,Name,SAP_Code__c from Account where Id IN:dis_ids and  Active_for_Liquidation__c=true and sales_org__r.Sales_Org_Code__c='2941'];
            }
            if(accList.size() >0){
                for(Account a : accList){
                    customer = new distributor();
                    customer.label = a.name;
                    customer.value = a.id;
                    distributorList.add(customer);
                }
            }
            
        }
        
        res.picklist = pickListValuesList;
        res.submit = isSubmit;
        res.acc = disList;
        res.descriptionList = descriptionList;
        res.distributorList = distributorList;
        return res;
    }
    
    @AuraEnabled
    public static List<CredDonutData> getDonData(List<String> Distributors, list<String> description, list<String> customer) {
        
        system.debug('Distributors-->>'+Distributors);
        system.debug('description-->>'+description);
        system.debug('customer-->>'+customer);
        
        Date dt = System.today();
        Integer month = dt.Month();
        Integer year = dt.Year(); 
        
        list<String> YearList = new list<String>();
        if(month <= 6){
            YearList.add(String.valueOf(year-2)+ '-'+ String.valueOf(year-1));
            YearList.add(String.valueOf(year-1)+ '-'+ String.valueOf(year));
        } else{
            YearList.add(String.valueOf(year-1)+ '-'+ String.valueOf(year));
            YearList.add(String.valueOf(year)+ '-'+ String.valueOf(year+1));
        }
        
        List<AggregateResult> lst_liquidation = new List<AggregateResult>();
        String salesOrgCode=System.Label.Grz_PolandSalesOrgCode;
        Id rec_type = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        List<CredDonutData> CredData = new CredDonutData[8];
        
        String country_name;
        if(test.isRunningTest()){
            country_name = 'Poland';
        }else{
            country_name = [Select id,Country from User where Id=:UserInfo.getUserId()].Country;
        }
        if(country_name=='Poland'){
            
            String query = 'SELECT Quarter__c,Liquidation_Annual_Plan__r.FIscal_Year__c fYear, Sum(Distributors_Inventory_PLN__c)DisInv FROM Liquidation2__c where submitted__c = true and  SKU__r.Active_for_Liquidation__c = true and Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c=:salesOrgCode and RecordTypeId=:rec_type and Liquidation_Annual_Plan__r.FIscal_Year__c in : YearList';
            // if(checkbox == true){
            //     query += ' and Distributors_Inventory_PLN__c != null and Distributors_Inventory_PLN__c != 0';
            // }
            // if( year != 'None'){
            //     query += ' and Liquidation_Annual_Plan__r.FIscal_Year__c=:Year';
            //  } 
            // if( month1234 != 'None'){
            
            //     query += ' and Quarter__c=:month1234';
            //  } 
            if( Distributors.size() > 0){
                query += ' and SKU__r.Brand_Name__c in : Distributors';
            } 
            if( description.size() > 0){
                
                query += ' and SKU__r.SKU_Description__c in : description';
            } 
            if( customer.size() > 0){
                
                query += ' and Distributor__c in : customer';
            } 
            query += ' group by Quarter__c,Liquidation_Annual_Plan__r.FIscal_Year__c HAVING Sum(Distributors_Inventory_PLN__c) != 0 order by Liquidation_Annual_Plan__r.FIscal_Year__c,Quarter__c asc';
            
            lst_liquidation = database.query(query);
            if(lst_liquidation.size() >0){
                for(AggregateResult liqui : lst_liquidation){
                    if(liqui.get('Quarter__c') == 'Quarter 1'){
                        if((String)liqui.get('fYear') == YearList[0]){
                            CredData[0] = (new CredDonutData(('Q1'+' ('+(String)liqui.get('fYear')+')'),(Decimal)liqui.get('DisInv')));  
                        }else{
                            CredData[4] = (new CredDonutData(('Q1'+' ('+(String)liqui.get('fYear')+')'),(Decimal)liqui.get('DisInv')));  
                            
                        }
                    }
                    if(liqui.get('Quarter__c') == 'Quarter 2'){
                        if((String)liqui.get('fYear') == YearList[0]){
                            CredData[1] = (new CredDonutData(('Q2'+' ('+(String)liqui.get('fYear')+')'),(Decimal)liqui.get('DisInv')));  
                        }else{
                            CredData[5] = (new CredDonutData(('Q2'+' ('+(String)liqui.get('fYear')+')'),(Decimal)liqui.get('DisInv')));  
                            
                        }
                    }
                    if(liqui.get('Quarter__c') == 'Quarter 3'){
                        if((String)liqui.get('fYear') == YearList[0]){
                            CredData[2] = (new CredDonutData(('Q3'+' ('+(String)liqui.get('fYear')+')'),(Decimal)liqui.get('DisInv')));  
                        }else{
                            CredData[6] = (new CredDonutData(('Q3'+' ('+(String)liqui.get('fYear')+')'),(Decimal)liqui.get('DisInv')));  
                            
                        }
                    }
                    if(liqui.get('Quarter__c') == 'Quarter 4'){
                        if((String)liqui.get('fYear') == YearList[0]){
                            CredData[3] = (new CredDonutData(('Q4'+' ('+(String)liqui.get('fYear')+')'),(Decimal)liqui.get('DisInv')));  
                        }else{
                            CredData[7] = (new CredDonutData(('Q4'+' ('+(String)liqui.get('fYear')+')'),(Decimal)liqui.get('DisInv')));  
                            
                        }
                    }
                    //  CredData.add(new CredDonutData(((String)liqui.get('Quarter__c')+' ('+(String)liqui.get('fYear')+')'),(Decimal)liqui.get('DisInv')));
                }
            }
            
            if(!CredData.tostring().contains(('Q1'+' ('+YearList[0]+')'))){
                CredData[0] = (new CredDonutData(('Q1'+' ('+YearList[0]+')'),0));
            }
            
            if(!CredData.tostring().contains(('Q2'+' ('+YearList[0]+')'))){
                CredData[1] = (new CredDonutData(('Q2'+' ('+YearList[0]+')'),0));
            }
            
            if(!CredData.tostring().contains(('Q3'+' ('+YearList[0]+')'))){
                CredData[2] = (new CredDonutData(('Q3'+' ('+YearList[0]+')'),0));
            }
            
            if(!CredData.tostring().contains(('Q4'+' ('+YearList[0]+')'))){
                CredData[3] = (new CredDonutData(('Q4'+' ('+YearList[0]+')'),0));
            }
            
            if(!CredData.tostring().contains(('Q1'+' ('+YearList[1]+')'))){
                CredData[4] = (new CredDonutData(('Q1'+' ('+YearList[1]+')'),0));
            }
            
            if(!CredData.tostring().contains(('Q2'+' ('+YearList[1]+')'))){
                CredData[5] = (new CredDonutData(('Q2'+' ('+YearList[1]+')'),0));
            }
            
            if(!CredData.tostring().contains(('Q3'+' ('+YearList[1]+')'))){
                CredData[6] = (new CredDonutData(('Q3'+' ('+YearList[1]+')'),0));
            }
            
            if(!CredData.tostring().contains(('Q4'+' ('+YearList[1]+')'))){
                CredData[7] = (new CredDonutData(('Q4'+' ('+YearList[1]+')'),0));
            }
            
            system.debug('CredData-->>'+CredData);
        }
        return CredData;
    } 
    
    
    
    public class distributor{
        @AuraEnabled  
        public String label{get;set;}
        @AuraEnabled  
        public String value{get;set;}
        
    }
    
    public class MainGlobalWrapper{
        @AuraEnabled  
        public List<String> picklist{get;set;}
        @AuraEnabled  
        public boolean submit{get;set;}
        @AuraEnabled  
        public list<distributor> acc{get;set;}
        @AuraEnabled  
        public list<distributor> descriptionList{get;set;}
        @AuraEnabled  
        public list<distributor> distributorList{get;set;}
    }
    
    public class CredDonutData {
        @AuraEnabled
        public String name {get; set;}
        @AuraEnabled
        public Decimal value {get; set;}
        public CredDonutData(String name, Decimal value) {
            this.name = name;
            this.value = value.intvalue();
        }
    }
  
}