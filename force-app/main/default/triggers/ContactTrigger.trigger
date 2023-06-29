trigger ContactTrigger on Contact (before insert,before update,after insert,after update) {
    if(Trigger.isBefore){
        Map<Id,Id> conAccMap=new Map<Id,Id>();
        string PhoneNumberRegex = '([0-9]|[-+#])+';
        
        for(Contact c:Trigger.New){
            system.debug('***'+c.Accountid+c.Account.Sales_Org_Code__c+c.Phone);
            if(c.Accountid!=null){
                conAccMap.put(c.id,c.AccountId);
            }
        }
        map<id,Account> aMap=new Map<id,Account>([select id,Sales_Org_Code__c from account where id in:conAccMap.values()]);
        for(Contact c:Trigger.New){
            if(conAccMap.get(c.id)!=null){
                system.debug('***'+c.Accountid+aMap.get(conAccMap.get(c.id)).Sales_Org_Code__c+c.Phone);
                //Boolean match;
                //match = Pattern.matches(PhoneNumberRegex, c.phone);
                //system.debug('match'+match);
                //Match match = Regex.Matches(String.valueOf(c.Phone), PhoneNumberRegex);
                
                //system.debug('**'+a);
                if(c.Accountid!=null && (aMap.get(conAccMap.get(c.id)).Sales_Org_Code__c=='3100' || aMap.get(conAccMap.get(c.id)).Sales_Org_Code__c=='3710') ){
                    if(c.Phone==null){        
                        c.addError('Phone Number is required');
                    }
                    if(c.phone!=null){
                        boolean a= Pattern.matches('[0-9(),+/\\-]+',c.Phone );
                        if(a==false){
                            c.addError('Phone Number is required and should not conatin special characters except' +'(,),-,+');
                        }
                        
                    }
                }
            }
        }
    }
    if(Trigger.isAfter){
        
        list<profile> p =[select Name from profile where id =: userinfo.getProfileId()];
        if(p[0].name.contains('Central Europe')){
            Map<Id,String> conAccRTMap=new Map<Id,String>();
            Map<Id,String> conRTMap=new Map<Id,String>();
            for(Contact c:[select id,name,recordtype.developername,account.recordtype.developername from contact where id in : trigger.new]){
                conAccRTMap.put(c.Id,c.account.recordtype.developername);
                conRTMap.put(c.Id,c.recordtype.developername);
            }
            system.debug('conAccRTMap-->>'+ conAccRTMap);
            system.debug('conRTMap-->>'+ conRTMap);
            for(contact c : trigger.new) {
                if(!conRTMap.isEmpty() && (conRTMap.containskey(c.Id))){
                    if((conRTMap.get(c.Id) == 'Europe_Farmer_Contact' && conAccRTMap.get(c.Id) != 'Europe_Farmer_Account') || (conRTMap.get(c.Id) == 'Europe_Retailer_Contact' && conAccRTMap.get(c.Id) != 'Europe_Retailer_Account') || conAccRTMap.get(c.Id) == 'Distributor'){
                        c.addError('Please create contact for related account type');
                        system.debug('if inside'+c.Id);
                    }
                    else{
                        system.debug('else inside'+c.Id);
                    }
                }
                
            } 
        }
    }
}