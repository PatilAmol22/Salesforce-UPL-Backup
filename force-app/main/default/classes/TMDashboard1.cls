Global class TMDashboard1{
    
    public String s1 {get;set;}
    public String s2 {get;set;}
    public String s3 {get;set;}
    public String s4 {get;set;}
    public String s5 {get;set;}
    public String s6 {get;set;}
    public String s7 {get;set;}
    public String s8 {get;set;}
    public String s9 {get;set;}
    public String s10 {get;set;}
    public String s11 {get;set;}
    public String s12 {get;set;}
    public String s13 {get;set;}
    public String s14 {get;set;}
    public String s15 {get;set;}
    public String s16 {get;set;}
    public String s17 {get;set;}
    public String s18 {get;set;}
    public String s19 {get;set;}
    
    global Integer presentMonth ;
    global Integer presentyear ;
    
    global TMDashboard1(){
    
    }
    
    webservice static string totaldata(){
         integer presentMonth = 0;
         integer presentyear = 0;
         
         List<AggregateResult> registeredfarmerMTD = new List<AggregateResult>();
         List<AggregateResult> AkcFarmers = new List<AggregateResult>();
         List<AggregateResult> casesMTD = new List<AggregateResult>();
         List<AggregateResult> productcasesMTD = new List<AggregateResult>();
         
         Map<String,Territorywrap> TerritoryDataMap = new Map<String,Territorywrap>();
         
         Date Today_date = date.today();
         presentMonth = Today_date.month();
         presentyear = Today_date.year();
         
         //akc registered farmers
         registeredfarmerMTD = [select personContact.Village__r.Territory__c terri,Calendar_Month(personContact.Fully_Registered_Date__c),
                         Calendar_YEAR(personContact.Fully_Registered_Date__c), count(id)numb from Account 
                         Where RecordType.DeveloperName != 'Distributor' AND personContact.Registration_Status__c =: 'Fully Registered' 
                         group by personContact.Village__r.Territory__c, Calendar_Month(personContact.Fully_Registered_Date__c), 
                         Calendar_YEAR(personContact.Fully_Registered_Date__c) Having Calendar_Month(personContact.Fully_Registered_Date__c) =: presentMonth 
                         AND Calendar_YEAR(personContact.Fully_Registered_Date__c) =: presentyear];
        
        for(AggregateResult aggObj: registeredfarmerMTD){
            String tempterri = (String)aggObj.get('terri');
            Integer Tempcount = (Integer)aggObj.get('numb');
            if(String.isBlank(tempterri) && Tempcount>0 ){
                if(TerritoryDataMap.containsKey('Not Defined')){
                    TerritoryDataMap.get('Not Defined').regAccMTD = Tempcount;
                }
                else{
                    Territorywrap temp = new Territorywrap();
                    temp.Territory = 'Not Defined';
                    temp.regAccMTD = Tempcount;
                    TerritoryDataMap.put('Not Defined',temp);
                }
            }else{
                if(TerritoryDataMap.containsKey(tempterri)){
                    TerritoryDataMap.get(tempterri).regAccMTD = Tempcount;
                }
                else{
                    Territorywrap temp = new Territorywrap();
                    temp.Territory = tempterri;
                    temp.regAccMTD = Tempcount;
                    TerritoryDataMap.put(tempterri,temp);
                }
            }
        }
        
        //for akc farmers
        AkcFarmers = [select  personContact.Village__r.Territory__c terri,  count(id)numb from Account 
                        Where RecordType.DeveloperName != 'Distributor' group by  personContact.Village__r.Territory__c];
        for(AggregateResult aggObj: AkcFarmers){
            String tempterri = (String)aggObj.get('terri');
            Integer Tempcount = (Integer)aggObj.get('numb');
            if(String.isBlank(tempterri) && Tempcount>0 ){
                if(TerritoryDataMap.containsKey('Not Defined')){
                    TerritoryDataMap.get('Not Defined').AkcAcc = 
                        TerritoryDataMap.get('Not Defined').AkcAcc+Tempcount;
                }
                else{
                    Territorywrap temp = new Territorywrap();
                    temp.Territory = 'Not Defined';
                    temp.AkcAcc = Tempcount;
                    TerritoryDataMap.put('Not Defined',temp);
                }
            }else{
                if(TerritoryDataMap.containsKey(tempterri)){
                    TerritoryDataMap.get(tempterri).AkcAcc = 
                        TerritoryDataMap.get(tempterri).AkcAcc+Tempcount;
                }
                else{
                    Territorywrap temp = new Territorywrap();
                    temp.Territory = tempterri;
                    temp.AkcAcc = Tempcount;
                    TerritoryDataMap.put(tempterri,temp);
                }
            }
        }
        
        //Inbound calls MTD
        casesMTD = [select  Contact.Village__r.Territory__c terri,Calendar_Month(CreatedDate),Calendar_YEAR(CreatedDate), count(id) numb from Case 
                        Where RecordType.DeveloperName =: 'UPL_General_Case' 
                        group by Contact.Village__r.Territory__c, Calendar_Month(CreatedDate), Calendar_YEAR(CreatedDate) 
                        Having Calendar_Month(CreatedDate) =: presentMonth AND Calendar_YEAR(CreatedDate) =: presentyear];
        for(AggregateResult aggObj: casesMTD){
            String tempterri = (String)aggObj.get('terri');
            Integer Tempcount = (Integer)aggObj.get('numb');
            if(String.isBlank(tempterri) && Tempcount>0 ){
                if(TerritoryDataMap.containsKey('Not Defined')){
                    TerritoryDataMap.get('Not Defined').CaseMTD = Tempcount;
                }
                else{
                    Territorywrap temp = new Territorywrap();
                    temp.Territory = 'Not Defined';
                    temp.CaseMTD = Tempcount;
                    TerritoryDataMap.put('Not Defined',temp);
                }
            }else{
                if(TerritoryDataMap.containsKey(tempterri)){
                    TerritoryDataMap.get(tempterri).CaseMTD = Tempcount;
                }
                else{
                    Territorywrap temp = new Territorywrap();
                    temp.Territory = tempterri;
                    temp.CaseMTD = Tempcount;
                    TerritoryDataMap.put(tempterri,temp);
                }
            }
        }
        
        //Inbound product recommended
        productcasesMTD = [select  Contact.Village__r.Territory__c terri,Calendar_Month(CreatedDate),Calendar_YEAR(CreatedDate), count(id) numb from Case 
                        Where RecordType.DeveloperName =: 'UPL_General_Case' And Products_Recommended__c != NULL 
                        group by Contact.Village__r.Territory__c, Calendar_Month(CreatedDate), Calendar_YEAR(CreatedDate) 
                        Having Calendar_Month(CreatedDate) =: presentMonth AND Calendar_YEAR(CreatedDate) =: presentyear];
        for(AggregateResult aggObj: productcasesMTD){
            String tempterri = (String)aggObj.get('terri');
            Integer Tempcount = (Integer)aggObj.get('numb');
            if(String.isBlank(tempterri) && Tempcount>0 ){
                if(TerritoryDataMap.containsKey('Not Defined')){
                    TerritoryDataMap.get('Not Defined').CaseProMTD = Tempcount;
                }
                else{
                    Territorywrap temp = new Territorywrap();
                    temp.Territory = 'Not Defined';
                    temp.CaseProMTD = Tempcount;
                    TerritoryDataMap.put('Not Defined',temp);
                }
            }else{
                if(TerritoryDataMap.containsKey(tempterri)){
                    TerritoryDataMap.get(tempterri).CaseProMTD = Tempcount;
                }
                else{
                    Territorywrap temp = new Territorywrap();
                    temp.Territory = tempterri;
                    temp.CaseProMTD = Tempcount;
                    TerritoryDataMap.put(tempterri,temp);
                }
            }
        }
        
        return JSON.serialize(TerritoryDataMap);
        
    }
    
    Global class Territorywrap{
        Public String territory {get;set;}
        Public Integer regAccMTD {get;set;}
        Public Integer AkcAcc {get;set;}
        Public Integer CaseMTD {get;set;}
        Public Integer CaseProMTD {get;set;}
        
        public Territorywrap(){
            territory = '';
            regAccMTD = 0;
            AkcAcc = 0;
            CaseMTD = 0;
            CaseProMTD = 0;
        }
    }
}