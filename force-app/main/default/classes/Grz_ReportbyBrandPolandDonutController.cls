public without sharing class Grz_ReportbyBrandPolandDonutController {
    
    @AuraEnabled
    public static MainGlobalWrapper getPickListValuesIntoList( String quater, String Year){
        
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
        liqList = [Select submitted__c,Quarter__c from Liquidation2__c where submitted__c = true and SKU__r.Active_for_Liquidation__c = true and Quarter__c =:quater and Liquidation_Annual_Plan__r.Fiscal_Start_Date__c=:start_date and Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c =: salesOrgCode  and RecordTypeId=:rec_type limit 1];        
        if(liqList.size()>0){
            isSubmit = true;
        }
        list<Account> acc = new list<Account>();
        distributor dis = new distributor();
        list<distributor> disList = new list<distributor>();
        list<string> dis_ids = new list<string>();
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
            acc= [select Id,Name,SAP_Code__c from Account where Id IN:dis_ids and  Active_for_Liquidation__c=true and sales_org__r.Sales_Org_Code__c='2941'];
        }
        if(acc.size() >0){
            for(Account a : acc){
                dis = new distributor();
                dis.label = a.name;
                dis.value = a.id;
                disList.add(dis);
            }
        }
        res.picklist = pickListValuesList;
        res.submit = isSubmit;
        res.acc = disList;
        return res;
    }
    
    @AuraEnabled
    public static List<CredDonutData> getDonData(String Year, String month1234,List<String> Distributors) {
        List<AggregateResult> lst_liquidation = new List<AggregateResult>();
        String salesOrgCode=System.Label.Grz_PolandSalesOrgCode;
        Id rec_type = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        List<CredDonutData> CredData = new List<CredDonutData>();
        String country_name;
        if(test.isRunningTest()){
            country_name = 'Poland';
        }else{
           country_name = [Select id,Country from User where Id=:UserInfo.getUserId()].Country;
        }
        if(country_name=='Poland'){
            String query = 'SELECT SKU__r.Brand_Name__c brand,Sum(Distributors_Inventory_PLN__c)DisInv FROM Liquidation2__c where submitted__c = true and  SKU__r.Active_for_Liquidation__c = true and Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c=:salesOrgCode and RecordTypeId=:rec_type and Liquidation_Annual_Plan__r.FIscal_Year__c=:Year and Quarter__c=:month1234';
            
            // if(checkbox == true){
            //      query += ' and Distributors_Inventory_PLN__c != null and Distributors_Inventory_PLN__c != 0';
            //  }
            //  if( year != 'None'){
            //      query += ' and Liquidation_Annual_Plan__r.FIscal_Year__c=:Year';
            //  } 
            // if( month1234 != 'None'){
            
            //      query += ' and Quarter__c=:month1234';
            //    } 
            if( Distributors.size() > 0){
                query += ' and Distributor__c in : Distributors';
            } 
            query += ' group by SKU__r.Brand_Name__c HAVING Sum(Distributors_Inventory_PLN__c) != 0';
            lst_liquidation = database.query(query);
            
            if(lst_liquidation.size() >0){
                for(AggregateResult liqui : lst_liquidation){
                    CredData.add(new CredDonutData((String)liqui.get('brand'),(Decimal)liqui.get('DisInv')));
                }
            }
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