/*
* Name: LastLoginUpdateScheduler
* Author: Azhar Shaikh 
* Description: Update Country, Local Country, Region in Last Login.
* Date : 27-09-2019
*/

public class LastLoginUpdateScheduler implements Schedulable {

    public void execute(SchedulableContext ctx){
        List<String> UserFullNameList=new List<String>();
        List<Last_Login__c> lastLoginList = new List<Last_Login__c>();
        Map<String,Region_Country_Mapping__mdt> regioncountryMap = new Map<String,Region_Country_Mapping__mdt>();
          
        List<Region_Country_Mapping__mdt> regCountryList=[SELECT Id,Region__c, Country__c,Local_Country__c FROM Region_Country_Mapping__mdt];
        
        for(Region_Country_Mapping__mdt regCountryObj:regCountryList){
            if(regCountryObj.Local_Country__c!=null && regCountryObj.Local_Country__c!=''){
                String localCountry=regCountryObj.Local_Country__c;
                String localCountryKey=localCountry.toLowerCase();
                regioncountryMap.put(localCountryKey,regCountryObj);
            }
            
        }
        
        List<Last_Login__c> LastLoginUserList=[SELECT Id, Name, User_Full_Name__c, Country__c, Region__c, Local_Country__c FROM Last_Login__c Where CreatedDate=Today];
        
        for(Last_Login__c ll_Obj:LastLoginUserList){
            if(ll_Obj.Local_Country__c!=null && ll_Obj.Local_Country__c!=''){
                String countryStr=ll_Obj.Local_Country__c;
                String countryKey=countryStr.toLowerCase();
                
                if(regioncountryMap.containsKey(countryKey)){
                    Region_Country_Mapping__mdt regionCountrymappingObj=new Region_Country_Mapping__mdt();
                    regionCountrymappingObj=regioncountryMap.get(countryKey);
                    ll_Obj.Country__c=regionCountrymappingObj.Country__c;
                    ll_Obj.Region__c=regionCountrymappingObj.Region__c;
                    lastLoginList.add(ll_Obj);
                }
            }
            
        }
        if(lastLoginList.size()>0){
            update lastLoginList;
        }
    }
}