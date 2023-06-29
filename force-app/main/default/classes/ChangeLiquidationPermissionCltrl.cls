/*----------Nikhil--------------*/

public with sharing class ChangeLiquidationPermissionCltrl{

    public list<Liquidation2__c> listLiqdtn2;
    public string selMonth{get;set;}
    public string selLiqType{get;set;}
    public string liqanlPlanId{get;set;}
    public string territoryId{get;set;}
    public string sucessMsg{get;set;}
    public string userId;
    public string profileName;  
    public list<string> rmlstMonth{get;set;}
    public list<Territory_Distributor__c> lstTerritories{get;set;}
    public list<Liquidation_Annual_Plan__c> lstliqdtnAnlPln{get;set;}
    public list<AggregateResult> rmlstLiqdtnDetail{get;set;}
    public list<State__c> stateList{get;set;}
    
    
    public ChangeLiquidationPermissionCltrl(){
       selMonth ='';
       selLiqType ='';
       sucessMsg = '';
      rmlstMonth = new list<string>();
          userId = UserInfo.getUserId();
          profileName = [select Name from Profile WHERE id =: UserInfo.getProfileId()].Name;
          
          lstTerritories = new list<Territory_Distributor__c>();
         
         lstliqdtnAnlPln = new list<Liquidation_Annual_Plan__c>();
          rmlstLiqdtnDetail = new list<AggregateResult>();
         rmlstMonth = new list<string>();
         stateList = new list<State__c>();
       }
       
       public void stateTerritoryList(){
           system.debug('In stateTerritoryList method --lstliqdtnAnlPln -Type>>----->'+selLiqType);
              
              system.debug('UserId:- '+userId );
          
             if(selLiqType=='Trade'){
                 lstTerritories = new list<Territory_Distributor__c>();
                 lstTerritories = [Select id,name,Region__c FROM Territory_Distributor__c WHERE Present_in_KEDE__c = true AND Neglected__c = false AND TerritoryCode__c != '#' order by name ]; 
             }
              else{
                  stateList = new list<State__c>();
                  stateList = [Select id,name FROM State__c order by name ]; 
              }
          
          system.debug('lstTerritories>>----->'+lstTerritories);
          system.debug('lststate>>----->'+stateList);
           
       }
       
       public void liqdtnAnlPlnPicklist(){
           system.debug('lstliqdtnAnlPln -Territory Id>>----->'+territoryId);
           system.debug('lstliqdtnAnlPln -Type>>----->'+selLiqType);
       
          lstliqdtnAnlPln  = new list<Liquidation_Annual_Plan__c>();
          if(selLiqType=='Trade'){
              lstliqdtnAnlPln = [SELECT Id,Territory_Name__r.name,Territory_Name__c, FIscal_Year__c, Name FROM Liquidation_Annual_Plan__c WHERE Territory_Name__c =: territoryId AND RecordType.Name=: selLiqType];
           }
           else{
              lstliqdtnAnlPln = [SELECT Id,State__c,State__r.name, FIscal_Year__c, Name FROM Liquidation_Annual_Plan__c WHERE State__c =: territoryId AND RecordType.Name=: selLiqType];
           }
                   
          system.debug('lstliqdtnAnlPln>>----->'+lstliqdtnAnlPln);
       }
       
        public void liqMonthPicklist(){
           system.debug('inside liquidation month list method-liqMonthPicklist()>>----->');
            system.debug('territoryId >>----->'+territoryId );
             system.debug('liqanlPlanId >>----->'+liqanlPlanId );
             system.debug('lstliqdtnAnlPln -Type>>----->'+selLiqType);
             
           rmlstLiqdtnDetail = new list<AggregateResult>();
           rmlstMonth = new list<string>();
           
           if(selLiqType == 'Trade'){
             rmlstLiqdtnDetail = [SELECT Month__c mnth FROM Liquidation2__c  WHERE Territory__c =: territoryId AND Liquidation_Annual_Plan__c =:liqanlPlanId GROUP BY Month__c ];
           }
           else if(selLiqType == 'SAIB'){
             rmlstLiqdtnDetail = [SELECT Month__c mnth FROM Liquidation2__c  WHERE State__c =: territoryId AND Liquidation_Annual_Plan__c =:liqanlPlanId GROUP BY Month__c ];
           }
           system.debug('rmlstLiqdtnDetail>>----->'+rmlstLiqdtnDetail);
           
           system.debug('rmlstMonth>>----->'+rmlstMonth);
       } 

   public void updtLiqDetailPermission(){
       system.debug('inside updtLiqDetailPermission>>----->');
       string territoryName = '';
       system.debug('lstliqdtnAnlPln -Territory Id>>----->'+territoryId);
       system.debug('selMonth >>----->'+selMonth );
       system.debug('selLiqType >>----->'+selLiqType);
       system.debug('liqanlPlanId >>----->'+liqanlPlanId );
       
       listLiqdtn2 = new list<Liquidation2__c>();
       
       if(Test.isRunningTest()){
        //do something
          listLiqdtn2 =[SELECT Id,Name,RecordType.Name,Month__c,submitted__c,State__r.name,submitted_trade__c,Territory__r.name,Product__r.Product_Code__c,Product__r.Name FROM Liquidation2__c];
             
        }
           
       if(selLiqType == 'Trade'){
              listLiqdtn2 =[SELECT Id,Name,RecordType.Name,Month__c,submitted_trade__c,Territory__r.name,Product__r.Product_Code__c,Product__r.Name FROM Liquidation2__c  WHERE Territory__r.Id =: territoryId AND Liquidation_Annual_Plan__c =:liqanlPlanId AND Month__c  =:selMonth AND RecordType.Name='Trade' ];

       for(Liquidation2__c  liq :listLiqdtn2){
           liq.submitted_trade__c= false;
           territoryName =liq.Territory__r.name;
           }
          }
       
        if(selLiqType == 'SAIB'){
               listLiqdtn2 =[SELECT Id,Name,RecordType.Name,Month__c,submitted__c,State__r.name,Product__r.Product_Code__c,Product__r.Name FROM Liquidation2__c  WHERE State__c =: territoryId AND Liquidation_Annual_Plan__c =:liqanlPlanId AND Month__c  =:selMonth AND RecordType.Name='SAIB' ];

        for(Liquidation2__c  liq :listLiqdtn2){
           liq.submitted__c= false;
           territoryName =liq.Territory__r.name;
           }
          }
          
           lstTerritories = new list<Territory_Distributor__c>();
           lstliqdtnAnlPln = new list<Liquidation_Annual_Plan__c>();
           rmlstLiqdtnDetail = new list<AggregateResult>();
           rmlstMonth = new list<string>();
           stateList = new list<State__c>();
          
       system.debug('selMonth >>----->'+selMonth );
       system.debug('listLiqdtn2>>----->'+listLiqdtn2);
       system.debug('listLiqdtn2 size>>----->'+listLiqdtn2.size());
       system.debug('Territpry name>>----->'+territoryName);
       if(listLiqdtn2.size()>0){
           update listLiqdtn2;
           sucessMsg = 'Your permission has been granted for '+territoryName;
       }
      }

}