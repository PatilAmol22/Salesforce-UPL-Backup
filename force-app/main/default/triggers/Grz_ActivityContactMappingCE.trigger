trigger Grz_ActivityContactMappingCE on Event (after insert,after update) {
    if(Trigger.isAfter){
        
        list<profile> p =[select Name from profile where id =: userinfo.getProfileId()];
        if(p[0].name.contains('Central Europe')){
            Map<Id,String> conAccRTMap=new Map<Id,String>();
            Map<Id,String> conRTMap=new Map<Id,String>();
            for(event c:[select id,recordtypeid,recordtype.developername,account.recordtype.developername from event where id in : trigger.new]){
                conAccRTMap.put(c.Id,c.account.recordtype.developername);
                conRTMap.put(c.Id,c.recordtype.developername);
            }
            system.debug('conAccRTMap-->>'+ conAccRTMap);
            system.debug('conRTMap-->>'+ conRTMap);
            for(event c : trigger.new) {
                if(!conRTMap.isEmpty() && (conRTMap.containskey(c.Id))){
                    if((conRTMap.get(c.Id) == 'Europe_Farmer_Activity' && conAccRTMap.get(c.Id) != 'Europe_Farmer_Account') || (conRTMap.get(c.Id) == 'Europe_Retailer_Activity' && conAccRTMap.get(c.Id) != 'Europe_Retailer_Account') || (conRTMap.get(c.Id) == 'Europe_Distributor_Activity' && conAccRTMap.get(c.Id) != 'Distributor')){
                        c.addError('Please create Event for related account type');
                        system.debug('if inside'+c.Id);
                    }
                    else{
                        system.debug('else inside'+c.Id);
                    }
                } 
            }
        }
    }}