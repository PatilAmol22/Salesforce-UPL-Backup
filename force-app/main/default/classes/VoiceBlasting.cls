public class VoiceBlasting{
    public String selectedZone {get;set;}
    public String selectedState {get;set;}
    public String selectedDistrict {get;set;}
    public String selectedTerritory {get;set;}
    public String selectedCrop {get;set;}
    public Integer farmerCount {get;set;}
    
    public List<SelectOption> states {get;set;}
    public List<SelectOption> districts {get;set;}
    public List<SelectOption> zones {get;set;}
    public List<SelectOption> territories {get;set;}
    public List<SelectOption> crops {get;set;}
    
    public Set<String> stateset {get;set;}
    public Set<String> districtset {get;set;}
    public Set<String> zoneset {get;set;}
    public Set<String> territoryset {get;set;}
    
    public Set<String> allselstates {get;set;}
    public Set<String> allseldists {get;set;}
    public Set<String> allselzones {get;set;}
    public Set<String> allselterri {get;set;}
    public Set<String> allselcrop {get;set;}
    
    public voiceblasting(){
        selectedZone = '';
        selectedTerritory = '';
        selectedCrop = '';
        selectedState = '';
        selectedDistrict = '';
        farmerCount = 0;
        
        states = new List<SelectOption>();
        districts = new List<SelectOption>();
        zones = new List<SelectOption>();
        territories = new List<SelectOption>();
        crops = new List<SelectOption>();
        
        stateset = new Set<String>();
        districtset = new Set<String>();
        zoneset = new Set<String>();
        territoryset = new Set<String>();
        
        allselstates = new Set<String>();
        allseldists = new Set<String>();
        allselzones = new Set<String>();
        allselterri = new Set<String>();
        allselcrop = new Set<String>();
        
        clearfilters();
    }
    
    public void clearfilters(){
        try{
        selectedZone = '';
        selectedTerritory = '';
        selectedCrop = '';
        selectedState = '';
        selectedDistrict = '';
        farmerCount = 0;
        
        states = new List<SelectOption>();
        districts = new List<SelectOption>();
        zones = new List<SelectOption>();
        territories = new List<SelectOption>();
        crops = new List<SelectOption>();
        
        allselstates = new Set<String>();
        allseldists = new Set<String>();
        allselzones = new Set<String>();
        allselterri = new Set<String>();
        allselcrop = new Set<String>();
        
        stateset = new Set<String>();
        
            List<State__c> stateList = new List<state__c>([Select Id, Name from State__c Order by Name]);
            for(State__c sobj:stateList){
                stateset.add(sobj.Name);
            }
            
            for(String s:stateset){states.add(new SelectOption(s,s));}
            
            Schema.DescribeFieldResult fieldResult = Crop_Wise_Acerage__c.Crop__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
            for( Schema.PicklistEntry f : ple)
            {
                crops.add(new SelectOption(f.getLabel(), f.getValue()));
            }
            System.debug('crops        : '+crops);
        }
        catch(exception ex){
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }
    }
    
    public void statecount(){
        
        System.debug('selectedState        : '+selectedState);
        try{
        farmerCount = 0;
        
        districts = new List<SelectOption>();
        zones = new List<SelectOption>();
        territories = new List<SelectOption>();
        
        districtset = new Set<String>();
        zoneset = new Set<String>();
        territoryset = new Set<String>();
        
        selectedState = selectedState.removeStart('[').removeEnd(']');
        List<String> newstates = selectedState.split(', ');
        System.debug('newstates        : '+newstates);
        allselstates = new Set<String>();
        allselstates.addAll(newstates);
        
        if(allselstates.size()<4){
        List<Village__c> vlg = new List<Village__c>([select id , name, State__c, District__c, Zone__c, Territory__c from Village__c 
                                            where Territory__c !='' 
                                           
                                            AND State__c IN: allselstates 
                                            Order By name]);
                for(Village__c v: vlg){
                    if(v.State__c!=null && v.State__c!=''){
                        stateset.add(v.State__c);
                    }
                    
                    if(v.Zone__c!=null && v.Zone__c!=''){
                        zoneset.add(v.Zone__c);
                    }
                    if(v.Territory__c!=null && v.Territory__c!=''){
                        territoryset.add(v.Territory__c);
                    }
                }
                
                for(String z:zoneset){zones.add(new SelectOption(z,z));}
                for(String t:territoryset){territories.add(new SelectOption(t,t));}
                
            
           
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'You can select at most 3 states.'));
        }
        }
        catch(exception ex){
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }
    }
    /*
    public void districtcount(){
        System.debug('selectedDistrict       : '+selectedDistrict);
        System.debug('selectedState        : '+selectedState);
        
        try{
            if(allselstates.size()>0){
                farmerCount = 0;
                
                zones = new List<SelectOption>();
                territories = new List<SelectOption>();
                
                zoneset = new Set<String>();
                territoryset = new Set<String>();
                
                selectedDistrict = selectedDistrict.removeStart('[').removeEnd(']');
                List<String> newdistricts = selectedDistrict.split(', ');
                System.debug('newdistricts       : '+newdistricts);
                allseldists = new Set<String>();
                allseldists.addAll(newdistricts);
                System.debug('allseldists       : '+allseldists);
                
                if(allseldists.size()<9){
                List<Village__c> vlg = new List<Village__c>([select id , name, State__c, District__c, Zone__c, Territory__c from Village__c 
                                            where Territory__c !='' 
                                            AND District__c IN: allseldists
                                            AND State__c IN: allselstates 
                                            Order By name]);
                for(Village__c v: vlg){
                    if(v.State__c!=null && v.State__c!=''){
                        stateset.add(v.State__c);
                    }
                    if(v.District__c!=null && v.District__c!=''){
                        districtset.add(v.District__c);
                    }
                    if(v.Zone__c!=null && v.Zone__c!=''){
                        zoneset.add(v.Zone__c);
                    }
                    if(v.Territory__c!=null && v.Territory__c!=''){
                        territoryset.add(v.Territory__c);
                    }
                }
                
                for(String z:zoneset){zones.add(new SelectOption(z,z));}
                for(String t:territoryset){territories.add(new SelectOption(t,t));}
                
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'You can select at most 8 districts.'));
                }
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'Please select states first.'));
            }
        }
        catch(exception ex){
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }
    }
    */
    public void zonecount(){
        System.debug('selectedZone       : '+selectedZone);
        System.debug('selectedDistrict       : '+selectedDistrict);
        System.debug('selectedState        : '+selectedState);
        
        try{
            if(allselstates.size()>0){
               
                farmerCount = 0;
                
             //   territories = new List<SelectOption>();
                
              //  territoryset = new Set<String>();
                
                selectedZone = selectedZone.removeStart('[').removeEnd(']');
                List<String> newzones = selectedZone.split(', ');
                System.debug('newzones       : '+newzones);
                allselzones = new Set<String>();
                allselzones.addAll(newzones);
                System.debug('allselzones       : '+allselzones);
                 if(allselzones.size()>0){
             /*   List<Village__c> vlg = new List<Village__c>([select id , name, State__c, District__c, Zone__c, Territory__c from Village__c 
                                            where Territory__c !='' 
                                            AND Zone__c IN: allselzones 
                                            AND State__c IN: allselstates
                                            Order By name]);
                for(Village__c v: vlg){
                    if(v.State__c!=null && v.State__c!=''){
                        stateset.add(v.State__c);
                    }
                    if(v.District__c!=null && v.District__c!=''){
                        districtset.add(v.District__c);
                    }
                    if(v.Zone__c!=null && v.Zone__c!=''){
                        zoneset.add(v.Zone__c);
                    }
                    if(v.Territory__c!=null && v.Territory__c!=''){
                        territoryset.add(v.Territory__c);
                    }
                }*/
                system.debug('allselzones- ab - '+allselzones);
               // for(String t:territoryset){territories.add(new SelectOption(t,t));}
                
                List<AggregateResult> AccountCount = new List<AggregateResult>();
                AccountCount = [select personContact.Village__r.Zone__c zone, count(id)numb from Account 
                                Where RecordType.DeveloperName != 'Distributor' AND SMS_Voice_Msg_Call_Consent__pc = 'Yes' 
                                AND personContact.Registration_Status__c =: 'Fully Registered' 
                                AND personContact.Village__r.Zone__c IN: allselzones
                                group by personContact.Village__r.Zone__c];
               System.debug('AccountCount '+AccountCount );
                for(AggregateResult aggObj: AccountCount){
                    string temp = (String)aggObj.get('zone');
                    if(allselzones.contains(temp)){
                        farmerCount = farmerCount + (Integer)aggObj.get('numb');
                         System.debug('farmerCount '+farmerCount );
                    }
                }
               
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'Please select at least one state.'));
                }
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'Please state first.'));
            }
        }
        catch(exception ex){
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }
    }
    
    public void territorycount(){
        System.debug('selectedTerritory       : '+selectedTerritory);
        System.debug('selectedZone       : '+selectedZone);
        System.debug('selectedDistrict       : '+selectedDistrict);
        System.debug('selectedState        : '+selectedState);
        
        try{
            if(allselzones.size()>0){
            farmerCount = 0;
            
            selectedTerritory = selectedTerritory.removeStart('[').removeEnd(']');
            List<String> newterri = selectedTerritory.split(', ');
            System.debug('newterri       : '+newterri);
            allselterri = new Set<String>();
            allselterri.addAll(newterri);
            System.debug('allselterri       : '+allselterri);
            if(allselterri.size()>0){
            List<AggregateResult> AccountCount = new List<AggregateResult>();
            AccountCount = [select personContact.Village__r.Territory__c terri, count(id)numb from Account 
                            Where RecordType.DeveloperName != 'Distributor' AND SMS_Voice_Msg_Call_Consent__pc = 'Yes' 
                            AND personContact.Registration_Status__c =: 'Fully Registered' 
                            AND personContact.Village__r.Territory__c IN: allselterri
                            AND personContact.Village__r.Zone__c IN: allselzones
                          
                            group by personContact.Village__r.Territory__c];
            for(AggregateResult aggObj: AccountCount){
                string temp = (String)aggObj.get('terri');
                if(allselterri.contains(temp)){
                    farmerCount = farmerCount + (Integer)aggObj.get('numb');
                }
             }
             }else{
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'Please select at least one Territory'));
             }
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'Please select zones first.'));
            }
        }
        catch(exception ex){
            System.debug('Exception: '+ex.getMessage()+ ' Line Number: '+ex.getLineNumber());
        }
    }
    
    public void cropcount(){
        System.debug('selectedCrop       : '+selectedCrop);
        System.debug('selectedTerritory       : '+selectedTerritory);
        System.debug('selectedZone       : '+selectedZone);
        System.debug('selectedDistrict       : '+selectedDistrict);
        System.debug('selectedState        : '+selectedState);
        
        farmerCount = 0;
            
        selectedCrop= selectedCrop.removeStart('[').removeEnd(']');
        List<String> newcrop = selectedCrop.split(', ');
        System.debug('newcrop       : '+newcrop);
        allselcrop = new Set<String>();
        allselcrop.addAll(newcrop);
        System.debug('allselcrop       : '+allselcrop);
        
        List<AggregateResult> AccountCount = new List<AggregateResult>();
        
        selectedTerritory = selectedTerritory.removeStart('[').removeEnd(']');
        selectedZone = selectedZone.removeStart('[').removeEnd(']');
        
        if(String.IsNotBlank(selectedTerritory)){
            if(allselcrop.size()>0){
            AccountCount = [Select Farmer__c acc, Count(id) From Crop_Wise_Acerage__c 
                            Where Crop__c IN: allselcrop 
                            AND Farmer__r.RecordType.DeveloperName != 'Distributor' 
                            AND Farmer__r.SMS_Voice_Msg_Call_Consent__pc = 'Yes' 
                            AND Farmer__r.personContact.Registration_Status__c =: 'Fully Registered'
                            AND Farmer__r.personContact.Village__r.Territory__c IN: allselterri
                            AND Farmer__r.personContact.Village__r.Zone__c IN: allselzones
                            group by Farmer__c];
                            
                            farmerCount = AccountCount.size();
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'Please Select at least one crop.'));
            }
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, 'Please Select all Filter before crop.'));
        }
        
    }
}