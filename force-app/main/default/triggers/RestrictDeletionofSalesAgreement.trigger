trigger RestrictDeletionofSalesAgreement on SalesAgreement (before delete) {
String profileName = [select Name from profile where id = :UserInfo.getProfileId()].Name;
if(Trigger.isBefore){
if(Trigger.IsDelete )
   { 
     for (SalesAgreement sa : trigger.old)
  {
    if (String.isNotBlank(sa.id))
     { 
         if((profileName !='System Administrator'))
         {
  			sa.addError('You cannot delete This SalesAgreement Please contact your Salesforce.com Administrator for assistance.');
         }     
         }
         } 
   }
}
    
}