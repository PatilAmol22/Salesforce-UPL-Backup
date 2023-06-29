public class ZoneTerrFarmerRegistrationExtensions{
 
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
    
 public List<AggregateResult> ZoneTerritoryFarmerAccountMonth ;
 public List<AggregateResult> ZoneTerritoryFarmerAccountYear ;
 public List<AggregateResult> ZoneTerritoryFarmerAccountTotal ;
 public List<AggregateResult> ZoneTerritoryFarmerGeneralCaseMonth;
 public List<AggregateResult> ZoneTerritoryFarmerGeneralCaseYear;
 public List<AggregateResult> ZoneTerritoryFarmerGeneralCaseTotal;
 public List<AggregateResult> ZoneTerritoryFarmerGeneralCaseProductMonth;
 public List<AggregateResult> ZoneTerritoryFarmerGeneralCaseProductYear;
 public List<AggregateResult> ZoneTerritoryFarmerGeneralCaseProductTotal;
 
 public Integer presentMonth ;
 public Integer presentyear ;
 public Integer nextyear ;
 public Integer startFY ;
 public Integer EndFY ;
 public Integer monthsinFY ;
 public Integer FiscalYearStartMonth ;
 Public Set<String> TerritorySet;
 Public Set<Integer> monthSet;
 public Map<String,Integer> FarmerAccountMonthMap;
 public Map<String,Integer> FarmerAccountYearMap;
 public Map<String,Integer> FarmerAccountTotalMap;
 public Map<String,Integer> GeneralCaseMonthMap;
 public Map<String,Integer> GeneralCaseYearMap;
 public Map<String,Integer> GeneralCaseTotalMap;
 public Map<String,Integer> GeneralCaseProductMonthMap;
 public Map<String,Integer> GeneralCaseProductYearMap;
 public Map<String,Integer> GeneralCaseProductTotalMap;
 public List<DisplayWrapper> DisplayWrapperList {get;set;} 
  
     public ZoneTerrFarmerRegistrationExtensions(){
         ZoneTerritoryFarmerAccountMonth = new List<AggregateResult>();
         ZoneTerritoryFarmerAccountYear = new List<AggregateResult>();
         ZoneTerritoryFarmerAccountTotal = new List<AggregateResult>();
         
         ZoneTerritoryFarmerGeneralCaseMonth = new List<AggregateResult>();
         ZoneTerritoryFarmerGeneralCaseYear = new List<AggregateResult>();
         ZoneTerritoryFarmerGeneralCaseTotal = new List<AggregateResult>();
         
         ZoneTerritoryFarmerGeneralCaseProductMonth = new List<AggregateResult>();
         ZoneTerritoryFarmerGeneralCaseProductYear = new List<AggregateResult>();
         ZoneTerritoryFarmerGeneralCaseProductTotal = new List<AggregateResult>();
         
         TerritorySet = new Set<String>();
         monthSet = new Set<Integer>();
         FarmerAccountMonthMap = new Map<String,Integer>(); 
         FarmerAccountYearMap = new Map<String,Integer>();
         FarmerAccountTotalMap = new Map<String,Integer>();
         
         GeneralCaseMonthMap = new Map<String,Integer>();
         GeneralCaseYearMap = new Map<String,Integer>();         
         GeneralCaseTotalMap = new Map<String,Integer>();
         
         GeneralCaseProductMonthMap = new Map<String,Integer>();
         GeneralCaseProductYearMap = new Map<String,Integer>();
         GeneralCaseProductTotalMap = new Map<String,Integer>();
         
         
         DisplayWrapperList = new List<DisplayWrapper>();
         
         presentMonth = 0;
         presentyear = 0;
         nextyear = 0;
         monthsinFY = 0;
         startFY = 0;
         EndFY = 0;
         
         FiscalYearStartMonth = [select FiscalYearStartMonth from Organization 
                                            where id=:Userinfo.getOrganizationId()].FiscalYearStartMonth;
         Date Today_date = date.today();
         presentMonth = Today_date.month();
         presentyear = Today_date.year();
         
        if(presentMonth < FiscalYearStartMonth){
            nextyear = presentyear-1;
            startFY = presentyear-1;
            EndFY = presentyear;
            monthsinFY = (12-FiscalYearStartMonth)+presentMonth+1;
        }
        else{
            nextyear = presentyear+1;
            startFY = presentyear;
            EndFY = presentyear+1;
            if(presentMonth == FiscalYearStartMonth){
                monthsinFY = 1;
            }else{
                monthsinFY = (presentMonth - FiscalYearStartMonth)+1;
            }
        }
         
         for(Integer i=0;i<=monthsinFY;i++){
             Integer temp = FiscalYearStartMonth + i;
             if(temp>12){
                 temp = temp - 12;
             }
             monthSet.add(temp);
         }
        System.debug('monthSet     :'+monthSet);
        System.debug('startFY     :'+startFY);
        System.debug('EndFY     :'+EndFY);
        System.debug('FiscalYearStartMonth     :'+FiscalYearStartMonth);
        System.debug('monthsinFY     :'+monthsinFY);
        
        List<Village__c> vlg = new List<Village__c>([select id , name, Territory__c from Village__c where Territory__c !='' ]);
        for(Village__c v: vlg){
            TerritorySet.add(v.Territory__c);
        }
        TerritorySet.add('Not Defined');
        
             ZoneTerritoryFarmerAccountMonth = [select personContact.Village__r.Zone__c zone, personContact.Village__r.Territory__c terri, Calendar_Month(CreatedDate),Calendar_YEAR(CreatedDate), count(id)numb from Account 
                        Where RecordType.DeveloperName != 'Distributor' group by personContact.Village__r.Zone__c, personContact.Village__r.Territory__c, Calendar_Month(CreatedDate), Calendar_YEAR(CreatedDate) 
                        Having Calendar_Month(CreatedDate) =: presentMonth AND Calendar_YEAR(CreatedDate) =: presentyear];
                
                for(AggregateResult ag: ZoneTerritoryFarmerAccountMonth){
                     if(String.Isblank((String)ag.get('terri'))&&(Integer)ag.get('numb')>0){
                         FarmerAccountMonthMap.put('Not Defined',(Integer)ag.get('numb')); 
                         system.debug('--- territory blank --'+ag.get('terri')+'---Count--'+ag.get('numb'));
                     }else{
                         FarmerAccountMonthMap.put((String)ag.get('terri'),(Integer)ag.get('numb')); 
                         system.debug('--- territory --'+ag.get('terri')+'---Count--'+ag.get('numb'));
                     }      
                }
                
                
             ZoneTerritoryFarmerAccountYear = [select personContact.Village__r.Zone__c zone, personContact.Village__r.Territory__c terri, FISCAL_YEAR(CreatedDate), count(id)numb from Account 
                        Where RecordType.DeveloperName != 'Distributor' group by personContact.Village__r.Zone__c, personContact.Village__r.Territory__c, FISCAL_YEAR(CreatedDate)
                        Having FISCAL_YEAR(CreatedDate) =: presentyear OR FISCAL_YEAR(CreatedDate) =: nextyear];  
            
            for(AggregateResult ag: ZoneTerritoryFarmerAccountYear){
                     if(String.Isblank((String)ag.get('terri'))&&(Integer)ag.get('numb')>0){
                         if(FarmerAccountYearMap.ContainsKey('Not Defined')){
                             Integer tempval = Integer.ValueOf(FarmerAccountYearMap.get('Not Defined') + (Integer)ag.get('numb'));
                             FarmerAccountYearMap.put('Not Defined',tempval);
                         }else{
                             FarmerAccountYearMap.put('Not Defined',(Integer)ag.get('numb'));
                         }
                     }else{
                         if(FarmerAccountYearMap.ContainsKey((String)ag.get('terri'))){
                             Integer tempval = Integer.ValueOf(FarmerAccountYearMap.get((String)ag.get('terri')) + (Integer)ag.get('numb'));
                             FarmerAccountYearMap.put((String)ag.get('terri'),tempval);
                         }else{
                             FarmerAccountYearMap.put((String)ag.get('terri'),(Integer)ag.get('numb'));
                         }
                     }
                     system.debug('--- territory --'+ag.get('terri')+'---Count--'+ag.get('numb'));      
                }
                
                
             ZoneTerritoryFarmerAccountTotal = [select  personContact.Village__r.Territory__c terri,  count(id)numb from Account 
                        Where RecordType.DeveloperName != 'Distributor' group by  personContact.Village__r.Territory__c];
                         
            
            for(AggregateResult ag: ZoneTerritoryFarmerAccountTotal){
                     if(String.Isblank((String)ag.get('terri'))&&(Integer)ag.get('numb')>0){
                         FarmerAccountTotalMap.put('Not Defined',(Integer)ag.get('numb'));
                     }else{
                         FarmerAccountTotalMap.put((String)ag.get('terri'),(Integer)ag.get('numb'));
                     }
                      
                     system.debug('--- territory --'+ag.get('terri')+'---Count--'+ag.get('numb'));      
                }  
                
              // General Cases  
                ZoneTerritoryFarmerGeneralCaseMonth = [select  Contact.Village__r.Territory__c terri,Calendar_Month(CreatedDate),Calendar_YEAR(CreatedDate), count(id) numb from Case 
                        Where RecordType.DeveloperName =: 'UPL_General_Case' group by Contact.Village__r.Territory__c, Calendar_Month(CreatedDate), Calendar_YEAR(CreatedDate) 
                        Having Calendar_Month(CreatedDate) =: presentMonth AND Calendar_YEAR(CreatedDate) =: presentyear];
                    
              for(AggregateResult ag: ZoneTerritoryFarmerGeneralCaseMonth){
                  if(String.Isblank((String)ag.get('terri'))&&(Integer)ag.get('numb')>0){
                      GeneralCaseMonthMap.put('Not Defined',(Integer)ag.get('numb'));
                  }else{
                      GeneralCaseMonthMap.put((String)ag.get('terri'),(Integer)ag.get('numb'));
                  }
                  
                  system.debug('--- territory --'+ag.get('terri')+'---Count--'+ag.get('numb'));      
              }
              
              ZoneTerritoryFarmerGeneralCaseYear = [select  Contact.Village__r.Territory__c terri,FISCAL_YEAR(CreatedDate),Calendar_Month(CreatedDate), count(id) numb 
                      from Case Where RecordType.DeveloperName =: 'UPL_General_Case' AND Calendar_Month(CreatedDate) In: monthSet 
                      group by Contact.Village__r.Territory__c, Calendar_Month(CreatedDate), FISCAL_YEAR(CreatedDate) 
                      Having (FISCAL_YEAR(CreatedDate) =: startFY AND Calendar_Month(CreatedDate) >=: FiscalYearStartMonth) 
                      OR (FISCAL_YEAR(CreatedDate) =: EndFY AND Calendar_Month(CreatedDate) <: FiscalYearStartMonth)];
              
              for(AggregateResult ag: ZoneTerritoryFarmerGeneralCaseYear){
                  if(String.Isblank((String)ag.get('terri'))&&(Integer)ag.get('numb')>0){
                    if(GeneralCaseYearMap.ContainsKey('Not Defined')){
                        Integer tempval = Integer.ValueOf(GeneralCaseYearMap.get('Not Defined') + (Integer)ag.get('numb'));
                        GeneralCaseYearMap.put('Not Defined',tempval);
                    }else{
                        GeneralCaseYearMap.put('Not Defined',(Integer)ag.get('numb'));
                    }
                  }else{
                    if(GeneralCaseYearMap.ContainsKey((String)ag.get('terri'))){
                        Integer tempval = Integer.ValueOf(GeneralCaseYearMap.get((String)ag.get('terri')) + (Integer)ag.get('numb'));
                        GeneralCaseYearMap.put((String)ag.get('terri'),tempval);
                    }else{
                        GeneralCaseYearMap.put((String)ag.get('terri'),(Integer)ag.get('numb'));
                    }
                  }
                  //GeneralCaseYearMap.put((String)ag.get('terri'),(Integer)ag.get('numb'));
                  system.debug('--- territory --'+ag.get('terri')+'---Count--'+ag.get('numb'));      
              }
              
              ZoneTerritoryFarmerGeneralCaseTotal = [select  Contact.Village__r.Territory__c terri,FISCAL_YEAR(CreatedDate),Calendar_Month(CreatedDate), count(id) numb 
                      from Case Where RecordType.DeveloperName =: 'UPL_General_Case' AND Calendar_Month(CreatedDate) In: monthSet 
                      group by Contact.Village__r.Territory__c, Calendar_Month(CreatedDate), FISCAL_YEAR(CreatedDate) 
                      Having (FISCAL_YEAR(CreatedDate) =: startFY-1 AND Calendar_Month(CreatedDate) >=: FiscalYearStartMonth) 
                      OR (FISCAL_YEAR(CreatedDate) =: EndFY-1 AND Calendar_Month(CreatedDate) <: FiscalYearStartMonth)];
              
              for(AggregateResult ag: ZoneTerritoryFarmerGeneralCaseTotal){
                  if(String.Isblank((String)ag.get('terri'))&&(Integer)ag.get('numb')>0){
                    if(GeneralCaseTotalMap.ContainsKey('Not Defined')){
                        Integer tempval = Integer.ValueOf(GeneralCaseTotalMap.get('Not Defined') + (Integer)ag.get('numb'));
                        GeneralCaseTotalMap.put('Not Defined',tempval);
                    }else{
                        GeneralCaseTotalMap.put('Not Defined',(Integer)ag.get('numb'));
                    }
                  }else{
                    if(GeneralCaseTotalMap.ContainsKey((String)ag.get('terri'))){
                        Integer tempval = Integer.ValueOf(GeneralCaseTotalMap.get((String)ag.get('terri')) + (Integer)ag.get('numb'));
                        GeneralCaseTotalMap.put((String)ag.get('terri'),tempval);
                    }else{
                        GeneralCaseTotalMap.put((String)ag.get('terri'),(Integer)ag.get('numb'));
                    }
                  }
                  //GeneralCaseTotalMap.put((String)ag.get('terri'),(Integer)ag.get('numb'));
                  system.debug('--- territory --'+ag.get('terri')+'---Count--'+ag.get('numb'));      
              } 
              
              //AND Products_Recommended__c != NULL  
              ZoneTerritoryFarmerGeneralCaseProductMonth = [select  Contact.Village__r.Territory__c terri,Calendar_Month(CreatedDate),Calendar_YEAR(CreatedDate), count(id) numb from Case 
                        Where RecordType.DeveloperName =: 'UPL_General_Case' AND Products_Recommended__c != NULL 
                        group by Contact.Village__r.Territory__c, Calendar_Month(CreatedDate), Calendar_YEAR(CreatedDate) 
                        Having Calendar_Month(CreatedDate) =: presentMonth AND Calendar_YEAR(CreatedDate) =: presentyear];
                    
              for(AggregateResult ag: ZoneTerritoryFarmerGeneralCaseProductMonth){
                  if(String.Isblank((String)ag.get('terri'))&&(Integer)ag.get('numb')>0){
                      GeneralCaseProductMonthMap.put('Not Defined',(Integer)ag.get('numb'));
                  }else{
                      GeneralCaseProductMonthMap.put((String)ag.get('terri'),(Integer)ag.get('numb'));
                  }
                  //GeneralCaseProductMonthMap.put((String)ag.get('terri'),(Integer)ag.get('numb'));
                  system.debug('--- territory --'+ag.get('terri')+'---Count--'+ag.get('numb'));      
              }
              
              ZoneTerritoryFarmerGeneralCaseProductYear = [select  Contact.Village__r.Territory__c terri,FISCAL_YEAR(CreatedDate),Calendar_Month(CreatedDate), count(id) numb 
                      from Case Where RecordType.DeveloperName =: 'UPL_General_Case' AND Calendar_Month(CreatedDate) In: monthSet AND Products_Recommended__c != NULL
                      group by Contact.Village__r.Territory__c, Calendar_Month(CreatedDate), FISCAL_YEAR(CreatedDate) 
                      Having (FISCAL_YEAR(CreatedDate) =: startFY AND Calendar_Month(CreatedDate) <: FiscalYearStartMonth) 
                      OR (FISCAL_YEAR(CreatedDate) =: EndFY AND Calendar_Month(CreatedDate) >=: FiscalYearStartMonth)];
              
              for(AggregateResult ag: ZoneTerritoryFarmerGeneralCaseProductYear){
                  if(String.Isblank((String)ag.get('terri'))&&(Integer)ag.get('numb')>0){
                    if(GeneralCaseProductYearMap.ContainsKey('Not Defined')){
                        Integer tempval = Integer.ValueOf(GeneralCaseProductYearMap.get('Not Defined') + (Integer)ag.get('numb'));
                        GeneralCaseProductYearMap.put('Not Defined',tempval);
                    }else{
                        GeneralCaseProductYearMap.put('Not Defined',(Integer)ag.get('numb'));
                    }
                  }else{
                    if(GeneralCaseProductYearMap.ContainsKey((String)ag.get('terri'))){
                        Integer tempval = Integer.ValueOf(GeneralCaseProductYearMap.get((String)ag.get('terri')) + (Integer)ag.get('numb'));
                        GeneralCaseProductYearMap.put((String)ag.get('terri'),tempval);
                    }else{
                        GeneralCaseProductYearMap.put((String)ag.get('terri'),(Integer)ag.get('numb'));
                    }
                  }
                  //GeneralCaseProductYearMap.put((String)ag.get('terri'),(Integer)ag.get('numb'));
                  system.debug('--- territory --'+ag.get('terri')+'---Count--'+ag.get('numb'));      
              }
              
              ZoneTerritoryFarmerGeneralCaseProductTotal = [select  Contact.Village__r.Territory__c terri,FISCAL_YEAR(CreatedDate),Calendar_Month(CreatedDate), count(id) numb 
                      from Case Where RecordType.DeveloperName =: 'UPL_General_Case' AND Calendar_Month(CreatedDate) In: monthSet AND Products_Recommended__c != NULL
                      group by Contact.Village__r.Territory__c, Calendar_Month(CreatedDate), FISCAL_YEAR(CreatedDate) 
                      Having (FISCAL_YEAR(CreatedDate) =: startFY-1 AND Calendar_Month(CreatedDate) <: FiscalYearStartMonth) 
                      OR (FISCAL_YEAR(CreatedDate) =: EndFY-1 AND Calendar_Month(CreatedDate) >=: FiscalYearStartMonth)];
              
              for(AggregateResult ag: ZoneTerritoryFarmerGeneralCaseProductTotal){
                  if(String.Isblank((String)ag.get('terri'))&&(Integer)ag.get('numb')>0){
                    if(GeneralCaseProductTotalMap.ContainsKey('Not Defined')){
                        Integer tempval = Integer.ValueOf(GeneralCaseProductTotalMap.get('Not Defined') + (Integer)ag.get('numb'));
                        GeneralCaseProductTotalMap.put('Not Defined',tempval);
                    }else{
                        GeneralCaseProductTotalMap.put('Not Defined',(Integer)ag.get('numb'));
                    }
                  }else{
                    if(GeneralCaseProductTotalMap.ContainsKey((String)ag.get('terri'))){
                        Integer tempval = Integer.ValueOf(GeneralCaseProductTotalMap.get((String)ag.get('terri')) + (Integer)ag.get('numb'));
                        GeneralCaseProductTotalMap.put((String)ag.get('terri'),tempval);
                    }else{
                        GeneralCaseProductTotalMap.put((String)ag.get('terri'),(Integer)ag.get('numb'));
                    }
                  }
                  //GeneralCaseProductTotalMap.put((String)ag.get('terri'),(Integer)ag.get('numb'));
                  system.debug('--- territory --'+ag.get('terri')+'---Count--'+ag.get('numb'));      
              }  
               try{
                  for(String ter : TerritorySet ){
                  system.debug('territory in set loop :'+ter);
                    if(FarmerAccountMonthMap.containsKey(ter) || FarmerAccountYearMap.containsKey(ter) || FarmerAccountTotalMap.containsKey(ter) || GeneralCaseMonthMap.containsKey(ter) || GeneralCaseYearMap.containsKey(ter) || GeneralCaseTotalMap.containsKey(ter) || GeneralCaseProductMonthMap.containsKey(ter) || GeneralCaseProductYearMap.containsKey(ter) || GeneralCaseProductTotalMap.containsKey(ter) ){
                        DisplayWrapper d = new DisplayWrapper();
                        d.Territory =  ter;
                        d.MonthCount = FarmerAccountMonthMap.get(ter);     
                        d.YearCount  = FarmerAccountYearMap.get(ter);
                        d.TotalCount = FarmerAccountTotalMap.get(ter);
                        d.GeneralCaseMonth = GeneralCaseMonthMap.get(ter);
                        //Need average
                        if(GeneralCaseYearMap.containsKey(ter)){
                            d.GeneralCaseYear = GeneralCaseYearMap.get(ter)/monthsinFY;
                        }
                        if(GeneralCaseTotalMap.containsKey(ter)){
                            d.GeneralCaseTotal = GeneralCaseTotalMap.get(ter)/monthsinFY;
                        }
                        d.GeneralCaseProductMonth = GeneralCaseProductMonthMap.get(ter);
                        if(GeneralCaseProductYearMap.containsKey(ter)){
                            d.GeneralCaseProductYear = GeneralCaseProductYearMap.get(ter)/monthsinFY;
                        }
                        if(GeneralCaseProductTotalMap.containsKey(ter)){
                            d.GeneralCaseProductTotal = GeneralCaseProductTotalMap.get(ter)/monthsinFY;
                        } 
                        DisplayWrapperList .add(d);
                      }
                  }
              }
               catch(exception ex){
                System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
               }                   
     }
     
     
     public class  DisplayWrapper {
     Public String Territory{get;set;}
     Public Integer MonthCount{get;set;}
     Public Integer YearCount{get;set;}
     Public Integer TotalCount{get;set;}
     Public Integer GeneralCaseMonth {get;set;}
     Public Integer GeneralCaseYear {get;set;}
     Public Integer GeneralCaseTotal {get;set;}
     Public Integer GeneralCaseProductMonth {get;set;}
     Public Integer GeneralCaseProductYear {get;set;}
     Public Integer GeneralCaseProductTotal {get;set;}
         public DisplayWrapper(){
             Territory = '';
             MonthCount = 0;
             YearCount =0;
             TotalCount =0;
             GeneralCaseMonth =0;
             GeneralCaseYear = 0;
             GeneralCaseTotal = 0;
             GeneralCaseProductMonth =0;
             GeneralCaseProductYear = 0;
             GeneralCaseProductTotal = 0;
         }
     
     
     }

}