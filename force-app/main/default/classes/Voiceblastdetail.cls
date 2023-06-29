Public Class Voiceblastdetail{
    
    public String filters {get;set;}
    
    Public Voiceblastdetail(){
         
         filters = '';
         
         //String state = ApexPages.currentpage().getparameters().get('selstate');
         String district = ApexPages.currentpage().getparameters().get('seldist');
         String zone = ApexPages.currentpage().getparameters().get('selzone');
         String territory = ApexPages.currentpage().getparameters().get('selteri');
         String crop = ApexPages.currentpage().getparameters().get('selcrop');
         
         if(String.IsNotBlank(district)){
             district = district.removeStart('[').removeEnd(']');
         }
         if(String.IsNotBlank(zone)){
             zone = zone.removeStart('[').removeEnd(']');
         }
         if(String.IsNotBlank(territory)){
             territory = territory.removeStart('[').removeEnd(']');
         }
         if(String.IsNotBlank(crop)){
             crop = crop.removeStart('[').removeEnd(']');
         }
         
         system.debug('district'+district);
         
         filters = '[';
         
         /*if(String.IsNotBlank(state)){
             filters = filters + '{\"column\":\"Contact.State__c\",\"operator\":\"equals\", \"value\":\"'+state+'\"}';
         }
         if(String.IsNotBlank(district) && String.IsNotBlank(state)){
             filters = filters + ',{\"column\":\"Contact.District__c\",\"operator\":\"equals\", \"value\":\"'+district+'\"}';
         }else */
         if(String.IsNotBlank(district)){
             filters = filters + '{\"column\":\"Contact.District__c\",\"operator\":\"equals\", \"value\":\"'+district+'\"}';
         }
         if(String.IsNotBlank(zone) && String.IsNotBlank(district)){
             filters = filters + ',{\"column\":\"Contact.Zone__c\",\"operator\":\"equals\", \"value\":\"'+zone+'\"}';
         }else if(String.IsNotBlank(zone)){
             filters = filters + '{\"column\":\"Contact.Zone__c\",\"operator\":\"equals\", \"value\":\"'+zone+'\"}';
         }
         if(String.IsNotBlank(territory) && String.IsNotBlank(zone)){
             filters = filters + ',{\"column\":\"Contact.Territory__c\",\"operator\":\"equals\", \"value\":\"'+territory+'\"}';
         }else if(String.IsNotBlank(territory)){
             filters = filters + '{\"column\":\"Contact.Territory__c\",\"operator\":\"equals\", \"value\":\"'+territory+'\"}';
         }
         if(String.IsNotBlank(crop) && String.IsNotBlank(territory)){
             filters = filters + ',{\"column\":\"Crop_Wise_Acerage__c.Crop__c\",\"operator\":\"equals\", \"value\":\"'+crop+'\"}';
         }else if(String.IsNotBlank(crop)){
             filters = filters + '{\"column\":\"Crop_Wise_Acerage__c.Crop__c\",\"operator\":\"equals\", \"value\":\"'+crop+'\"}';
         }
         
         filters = filters+']';
         
         system.debug('filters :'+filters);
         //filters = JSON.serialize(filters);
         //system.debug('filters Jason:'+filters);
    }
}