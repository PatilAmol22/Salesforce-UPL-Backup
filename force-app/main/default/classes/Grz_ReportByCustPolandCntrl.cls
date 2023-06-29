public without sharing class Grz_ReportByCustPolandCntrl {
    @AuraEnabled
    public static MainGlobalWrapper getPickListValuesIntoList( String quater, String Year, list<String> brand){
        MainGlobalWrapper res = new MainGlobalWrapper();
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = Liquidation_Annual_Plan__c.FIscal_Year__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }   
        Boolean isSubmit = false;
        String salesOrgCode=System.Label.Grz_PolandSalesOrgCode;
        Id rec_type = Schema.SObjectType.Liquidation2__c.getRecordTypeInfosByName().get('Multi Country').getRecordTypeId();
        List<Liquidation2__c> liqList = new List<Liquidation2__c>();
       
        list<aggregateresult > acc = new list<aggregateresult >();
        list<aggregateresult > description = new list<aggregateresult >();
        distributor dis = new distributor();
        list<distributor> disList = new list<distributor>();
        list<distributor> descriptionList = new list<distributor>();
        
       
        
        if(brand.size()> 0){
            description= [SELECT SKU_Description__c FROM SKU__c where Sales_Org_Code__c = '2941' and Active_for_Liquidation__c = true and Brand_Name__c in : brand and SKU_Description__c != null and SKU_Description__c != '' group by SKU_Description__c];
            if(description.size() >0){
                for(aggregateresult a : description){
                    dis = new distributor();
                    dis.label = (String)a.get('SKU_Description__c');
                    dis.value = (String)a.get('SKU_Description__c');
                    descriptionList.add(dis);
                }
            }
        }else{
            descriptionList = new list<distributor>();
            Date start_date = Date.newInstance(Integer.valueOf(year), 4, 1); 
            
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
        }
        
        res.picklist = pickListValuesList;
        res.submit = isSubmit;
        res.acc = disList;
        res.descriptionList = descriptionList;
        return res;
    }
    
    @AuraEnabled
    public static List<CredDonutData> getDonData(String Year, String month1234,List<String> Distributors, list<String> description) {
        
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
            String query = 'SELECT Distributor__r.name disName,Sum(Distributors_Inventory_PLN__c)DisInv FROM Liquidation2__c where submitted__c = true and  SKU__r.Active_for_Liquidation__c = true and Liquidation_Annual_Plan__r.Sales_Org__r.Sales_Org_Code__c=:salesOrgCode and RecordTypeId=:rec_type and Liquidation_Annual_Plan__r.FIscal_Year__c=:Year and Quarter__c=:month1234';
            
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
            query += ' group by Distributor__r.name HAVING Sum(Distributors_Inventory_PLN__c) != 0';
            lst_liquidation = database.query(query);
            
            if(lst_liquidation.size()>0){
                for(AggregateResult liqui : lst_liquidation){
                    CredData.add(new CredDonutData((String)liqui.get('disName'),(Decimal)liqui.get('DisInv')));
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
        @AuraEnabled  
        public list<distributor> descriptionList{get;set;}
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