Public class ZoneAndTerritoryReport{
    
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
    
    public static List<AggregateResult> ZoneAccYTD {get;set;}
    public static List<AggregateResult> ZoneAccMTD {get;set;}
    public static List<AggregateResult> ZoneCaseYTD {get;set;}
    public static List<AggregateResult> ZoneCaseMTD {get;set;}
    public static List<AggregateResult> TerritoryAccYTD {get;set;}
    public static List<AggregateResult> TerritoryAccMTD {get;set;}
    public static List<AggregateResult> TerritoryCaseYTD {get;set;}
    public static List<AggregateResult> TerritoryCaseMTD {get;set;}
    public static Integer presentMonth {get;set;}
    public static Integer presentyear {get;set;}
    public static Integer nextyear {get;set;}
    public static Map<String,Zonewrap> ZoneDataMap {get;set;}
    public static Map<String,Territorywrap> TerritoryDataMap {get;set;}
    
    Public ZoneAndTerritoryReport(){
        ZoneAccYTD = new List<AggregateResult>();
        ZoneAccMTD= new List<AggregateResult>();
        ZoneCaseYTD = new List<AggregateResult>();
        ZoneCaseMTD = new List<AggregateResult>();
        TerritoryAccYTD = new List<AggregateResult>();
        TerritoryAccMTD = new List<AggregateResult>();
        TerritoryCaseYTD = new List<AggregateResult>();
        TerritoryCaseMTD = new List<AggregateResult>();
        ZoneDataMap = new Map<String,Zonewrap>();
        TerritoryDataMap = new Map<String,Territorywrap>();
       
        presentMonth = 0;
        presentyear = 0;
        nextyear = 0;
        
        date myDate = date.today();
        presentMonth = myDate.month();
        presentyear = myDate.year();
        Integer FiscalYearStartMonth = [select FiscalYearStartMonth from Organization 
                                            where id=:Userinfo.getOrganizationId()].FiscalYearStartMonth;
        nextyear = 0;
        if(presentMonth < FiscalYearStartMonth){
            nextyear = presentyear-1;
        }
        else{
            nextyear = presentyear+1;
        }
        
        System.debug('presentMonth   :'+presentMonth);
        System.debug('presentyear   :'+presentyear);
        System.debug('nextyear   :'+nextyear);
       
        Zonedata();
        Territorydata();
    }
    
    @RemoteAction
    @readOnly
    Public static void Zonedata(){
    
    
        System.debug('presentMonth   :'+presentMonth);
        System.debug('presentyear   :'+presentyear);
        System.debug('nextyear   :'+nextyear);
        try{
        // Account zone wise MTD
        ZoneAccMTD = [select personContact.Village__r.Zone__c zone,Calendar_Month(CreatedDate),Calendar_YEAR(CreatedDate), count(id)numb from Account 
                        Where RecordType.DeveloperName != 'Distributor' group by personContact.Village__r.Zone__c, Calendar_Month(CreatedDate), Calendar_YEAR(CreatedDate) 
                        Having Calendar_Month(CreatedDate) =: presentMonth AND Calendar_YEAR(CreatedDate) =: presentyear];
        for(AggregateResult aggObj: ZoneAccMTD){
            String tempzone = (String)aggObj.get('zone');
            Integer Tempcount = (Integer)aggObj.get('numb');
            if(String.isBlank(tempzone) && Tempcount>0 ){
                if(ZoneDataMap.containsKey('Not Defined')){
                    ZoneDataMap.get('Not Defined').AccMTD = Tempcount;
                }
                else{
                    Zonewrap temp = new Zonewrap();
                    temp.zone = 'Not Defined';
                    temp.AccMTD = Tempcount;
                    ZoneDataMap.put('Not Defined',temp);
                }
            }else{
                if(ZoneDataMap.containsKey(tempzone)){
                    ZoneDataMap.get(tempzone).AccMTD = Tempcount;
                }
                else{
                    Zonewrap temp = new Zonewrap();
                    temp.zone = tempzone;
                    temp.AccMTD = Tempcount;
                    ZoneDataMap.put(tempzone,temp);
                }
            }
        }
        
        //ACCOUNT ZONE WISE YTD removed Having FISCAL_YEAR(CreatedDate) =: presentyear OR FISCAL_YEAR(CreatedDate) =: nextyear /, FISCAL_YEAR(CreatedDate)
        ZoneAccYTD = [select  personContact.Village__r.Zone__c zone, count(id)numb from Account Where RecordType.DeveloperName !=: 'Distributor' 
                        group by personContact.Village__r.Zone__c];
        for(AggregateResult aggObj: ZoneAccYTD){
            String tempzone = (String)aggObj.get('zone');
            Integer Tempcount = (Integer)aggObj.get('numb');
            if(String.isBlank(tempzone) && Tempcount>0 ){
                if(ZoneDataMap.containsKey('Not Defined')){
                    ZoneDataMap.get('Not Defined').AccYTD = Tempcount;
                }
                else{
                    Zonewrap temp = new Zonewrap();
                    temp.zone = 'Not Defined';
                    temp.AccYTD = Tempcount;
                    ZoneDataMap.put('Not Defined',temp);
                }
            }else{
                if(ZoneDataMap.containsKey(tempzone)){
                    ZoneDataMap.get(tempzone).AccYTD = ZoneDataMap.get(tempzone).AccYTD+Tempcount;
                }
                else{
                    Zonewrap temp = new Zonewrap();
                    temp.zone = tempzone;
                    temp.AccYTD = Tempcount;
                    ZoneDataMap.put(tempzone,temp);
                }
            }
        }
        
        //CASE ZONE WISE MTD removed And Products_Recommended__c != NULL 
        ZoneCaseMTD = [select  Contact.Village__r.Zone__c zone,Calendar_Month(CreatedDate),Calendar_YEAR(CreatedDate), count(id)numb from Case 
                        Where RecordType.DeveloperName =: 'UPL_General_Case' group by Contact.Village__r.Zone__c, Calendar_Month(CreatedDate), Calendar_YEAR(CreatedDate) 
                        Having Calendar_Month(CreatedDate) =: presentMonth AND Calendar_YEAR(CreatedDate) =: presentyear];
        for(AggregateResult aggObj: ZoneCaseMTD){
            String tempzone = (String)aggObj.get('zone');
            Integer Tempcount = (Integer)aggObj.get('numb');
            if(String.isBlank(tempzone) && Tempcount>0 ){
                if(ZoneDataMap.containsKey('Not Defined')){
                    ZoneDataMap.get('Not Defined').CaseMTD = Tempcount;
                }
                else{
                    Zonewrap temp = new Zonewrap();
                    temp.zone = 'Not Defined';
                    temp.CaseMTD = Tempcount;
                    ZoneDataMap.put('Not Defined',temp);
                }
            }else{
                if(ZoneDataMap.containsKey(tempzone)){
                    ZoneDataMap.get(tempzone).CaseMTD = Tempcount;
                }
                else{
                    Zonewrap temp = new Zonewrap();
                    temp.zone = tempzone;
                    temp.CaseMTD = Tempcount;
                    ZoneDataMap.put(tempzone,temp);
                }
            }
        }
        
        //CASE ZONE WISE YTD
        /*select  Contact.Village__r.Zone__c zone,FISCAL_YEAR(CreatedDate), count(id) from Case Where RecordType.DeveloperName = 'UPL_General_Case'  And Products_Recommended__c != NULL 
                        group by Contact.Village__r.Zone__c, FISCAL_YEAR(CreatedDate) Having FISCAL_YEAR(CreatedDate) =: presentyear OR FISCAL_YEAR(CreatedDate) =: nextyear*/
        ZoneCaseYTD = [select  Contact.Village__r.Zone__c zone,Calendar_Month(CreatedDate),Calendar_YEAR(CreatedDate), count(id)numb from Case 
                        Where RecordType.DeveloperName =: 'UPL_General_Case' And Products_Recommended__c != NULL group by Contact.Village__r.Zone__c, Calendar_Month(CreatedDate), Calendar_YEAR(CreatedDate) 
                        Having Calendar_Month(CreatedDate) =: presentMonth AND Calendar_YEAR(CreatedDate) =: presentyear];
        for(AggregateResult aggObj: ZoneCaseYTD){
            String tempzone = (String)aggObj.get('zone');
            Integer Tempcount = (Integer)aggObj.get('numb');
            if(String.isBlank(tempzone) && Tempcount>0 ){
                if(ZoneDataMap.containsKey('Not Defined')){
                    ZoneDataMap.get('Not Defined').CaseYTD = ZoneDataMap.get(tempzone).CaseYTD+Tempcount;
                }
                else{
                    Zonewrap temp = new Zonewrap();
                    temp.zone = 'Not Defined';
                    temp.CaseYTD = Tempcount;
                    ZoneDataMap.put('Not Defined',temp);
                }
            }else{
                if(ZoneDataMap.containsKey(tempzone)){
                    ZoneDataMap.get(tempzone).CaseYTD = 
                        ZoneDataMap.get(tempzone).CaseYTD+Tempcount;
                }
                else{
                    Zonewrap temp = new Zonewrap();
                    temp.zone = tempzone;
                    temp.CaseYTD = Tempcount;
                    ZoneDataMap.put(tempzone,temp);
                }
            }
        }
        }
        catch(exception ex){
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }
    }
    
    @RemoteAction
    @readOnly
    Public static void Territorydata(){
    try{
        // Account zone wise MTD
        TerritoryAccMTD = [select  personContact.Village__r.Territory__c terri,Calendar_Month(CreatedDate),Calendar_YEAR(CreatedDate), count(id) numb from Account 
                        Where RecordType.DeveloperName != 'Distributor' group by personContact.Village__r.Territory__c, Calendar_Month(CreatedDate), Calendar_YEAR(CreatedDate) 
                        Having Calendar_Month(CreatedDate) =: presentMonth AND Calendar_YEAR(CreatedDate) =: presentyear];
        for(AggregateResult aggObj: TerritoryAccMTD){
            String tempzone = (String)aggObj.get('terri');
            Integer Tempcount = (Integer)aggObj.get('numb');
            if(String.isBlank(tempzone) && Tempcount>0 ){
                if(TerritoryDataMap.containsKey('Not Defined')){
                    TerritoryDataMap.get('Not Defined').AccMTD = Tempcount;
                }
                else{
                    Territorywrap temp = new Territorywrap();
                    temp.Territory = 'Not Defined';
                    temp.AccMTD = Tempcount;
                    TerritoryDataMap.put('Not Defined',temp);
                }
            }else{
                if(TerritoryDataMap.containsKey(tempzone)){
                    TerritoryDataMap.get(tempzone).AccMTD = Tempcount;
                }
                else{
                    Territorywrap temp = new Territorywrap();
                    temp.Territory = tempzone;
                    temp.AccMTD = Tempcount;
                    TerritoryDataMap.put(tempzone,temp);
                }
            }
        }
        
        //ACCOUNT Territory WISE YTD /FISCAL_YEAR(CreatedDate), / Having FISCAL_YEAR(CreatedDate) =: presentyear OR FISCAL_YEAR(CreatedDate) =: nextyear
        TerritoryAccYTD = [select  personContact.Village__r.Territory__c terri, count(id) numb from Account Where RecordType.DeveloperName !=: 'Distributor' 
                        group by personContact.Village__r.Territory__c];
        for(AggregateResult aggObj: TerritoryAccYTD){
            String tempterri = (String)aggObj.get('terri');
            Integer Tempcount = (Integer)aggObj.get('numb');
            if(String.isBlank(tempterri) && Tempcount>0 ){
                if(TerritoryDataMap.containsKey('Not Defined')){
                    TerritoryDataMap.get('Not Defined').AccYTD = TerritoryDataMap.get('Not Defined').AccYTD+Tempcount;
                }
                else{
                    Territorywrap temp = new Territorywrap();
                    temp.Territory = 'Not Defined';
                    temp.AccYTD = Tempcount;
                    TerritoryDataMap.put('Not Defined',temp);
                }
            }else{
                if(TerritoryDataMap.containsKey(tempterri)){
                    TerritoryDataMap.get(tempterri).AccYTD = 
                        TerritoryDataMap.get(tempterri).AccYTD+Tempcount;
                }
                else{
                    Territorywrap temp = new Territorywrap();
                    temp.Territory = tempterri;
                    temp.AccYTD = Tempcount;
                    TerritoryDataMap.put(tempterri,temp);
                }
            }
        }
        
        //CASE Territory WISE MTD
        TerritoryCaseMTD = [select  Contact.Village__r.Territory__c terri,Calendar_Month(CreatedDate),Calendar_YEAR(CreatedDate), count(id) numb from Case 
                        Where RecordType.DeveloperName =: 'UPL_General_Case' group by Contact.Village__r.Territory__c, Calendar_Month(CreatedDate), Calendar_YEAR(CreatedDate) 
                        Having Calendar_Month(CreatedDate) =: presentMonth AND Calendar_YEAR(CreatedDate) =: presentyear];
        for(AggregateResult aggObj: TerritoryCaseMTD){
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
        
        //CASE Territory WISE YTD
        TerritoryCaseYTD = [select  Contact.Village__r.Territory__c terri,Calendar_Month(CreatedDate),Calendar_YEAR(CreatedDate), count(id) numb from Case 
                        Where RecordType.DeveloperName =: 'UPL_General_Case' And Products_Recommended__c != NULL group by Contact.Village__r.Territory__c, Calendar_Month(CreatedDate), Calendar_YEAR(CreatedDate) 
                        Having Calendar_Month(CreatedDate) =: presentMonth AND Calendar_YEAR(CreatedDate) =: presentyear];
        for(AggregateResult aggObj: TerritoryCaseYTD){
            String tempterri = (String)aggObj.get('terri');
            Integer Tempcount = (Integer)aggObj.get('numb');
            if(String.isBlank(tempterri) && Tempcount>0 ){
                if(TerritoryDataMap.containsKey('Not Defined')){
                    TerritoryDataMap.get('Not Defined').CaseYTD = TerritoryDataMap.get(tempterri).CaseYTD+Tempcount;
                }
                else{
                    Territorywrap temp = new Territorywrap();
                    temp.Territory = 'Not Defined';
                    temp.CaseYTD = Tempcount;
                    TerritoryDataMap.put('Not Defined',temp);
                }
            }else{
                if(TerritoryDataMap.containsKey(tempterri)){
                    TerritoryDataMap.get(tempterri).CaseYTD = 
                        TerritoryDataMap.get(tempterri).CaseYTD+Tempcount;
                }
                else{
                    Territorywrap temp = new Territorywrap();
                    temp.Territory = tempterri;
                    temp.CaseYTD = Tempcount;
                    TerritoryDataMap.put(tempterri,temp);
                }
            }
        }
        }
        catch(exception ex){
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }
    }
    
    Public class Zonewrap{
        Public String zone {get;set;}
        Public Integer AccYTD {get;set;}
        Public Integer AccMTD {get;set;}
        Public Integer CaseYTD {get;set;}
        Public Integer CaseMTD {get;set;}
        
        public Zonewrap(){
            zone = '';
            AccYTD = 0;
            AccMTD = 0;
            CaseYTD = 0;
            CaseMTD = 0;
        }
    }
    
    Public class Territorywrap{
        Public String territory {get;set;}
        Public Integer AccYTD {get;set;}
        Public Integer AccMTD {get;set;}
        Public Integer CaseYTD {get;set;}
        Public Integer CaseMTD {get;set;}
        
        public Territorywrap(){
            territory = '';
            AccYTD = 0;
            AccMTD = 0;
            CaseYTD = 0;
            CaseMTD = 0;
        }
    }
}