public class RetailerWiseBusinessController {
    public string SBUName{get;set;}
    public string SBUCode{get;set;}
    public string zoneName{get;set;}
    public string zoneCode{get;set;}
    public string territoryName{get;set;}
    public string territoryCode{get;set;}
    public RetailerWiseBusinessController(){
        SBUName = '';
        SBUCode ='';
        zoneName = '';
        zoneCode = '';
        territoryName = ''; 
        territoryCode = '';
        id userId =UserInfo.getUserId();
        List<Territory_Distributor__c> territoryList = [SELECT Zonal_Manager_Id__c,TerritoryManager__c,SBU_Head_Id__c,SBU_Marketing_heads_Id__c,Zone__r.Name,SBU_Code__c,SBU_Name__c,Zone_Code__c,Name,TerritoryCode__c,Zonal_Marketing_Manager_1_Id__c,
                                                        ZonalManager__c, SBU__c,  Zone__c, SBUHead__c,Zonal_Marketing_Manager_2_Id__c, Zonal_Marketing_Manager_3_Id__c
                                                        FROM Territory_Distributor__c 
                                                        WHERE (TerritoryManager__c =:userId
                                                        Or ZonalManager__c =:userId
                                                        OR Zonal_Marketing_Manager_1_Id__c =:userId 
                                                        OR Zonal_Marketing_Manager_2_Id__c =:userId 
                                                        OR Zonal_Marketing_Manager_3_Id__c =:userId
                                                        OR SBU_Head_Id__c =:userId OR SBU_Marketing_heads_Id__c=:userId ) AND SalesOrg__r.Sales_Org_Code__c = '1000'
                                                       ];
        if(!territoryList.isEmpty()){
            if (territoryList[0].TerritoryManager__c == userId){
                SBUName = territoryList[0].SBU_Name__c;
                SBUCode = territoryList[0].SBU_Code__c;
                zoneName = territoryList[0].Zone__r.Name;
                zoneCode = territoryList[0].Zone_Code__c;
                territoryName = territoryList[0].Name; 
                territoryCode = territoryList[0].TerritoryCode__c;
            }
            if (territoryList[0].Zonal_Manager_Id__c == userId ||territoryList[0].Zonal_Marketing_Manager_1_Id__c == userId || territoryList[0].Zonal_Marketing_Manager_2_Id__c == userId || territoryList[0].Zonal_Marketing_Manager_3_Id__c == userId){
                SBUName = territoryList[0].SBU_Name__c;
                SBUCode = territoryList[0].SBU_Code__c;
                zoneName = territoryList[0].Zone__r.Name;
                zoneCode = territoryList[0].Zone_Code__c;
            }
            if (territoryList[0].SBU_Head_Id__c == userId ||territoryList[0].SBU_Marketing_heads_Id__c == userId ){
                SBUName = territoryList[0].SBU_Name__c;
                SBUCode = territoryList[0].SBU_Code__c;
                
            }
        }else{
        List<Zone__c> zoneList = [select Name,ZoneCode__c,SBUCode__c,SBU_Code__c,SBU_Name__c from Zone__c where (ZMMUser__c =:userId
                                                                   OR ZMMUser2__c =:userId
                                                                   OR ZMMUser3__c =:userId
                                                                   OR ZonalHead__c =:userId) AND SalesOrg__r.Sales_Org_Code__c = '1000'];
            if(!zoneList.isEmpty()){
                zoneName = zoneList[0].Name;
                zoneCode = zoneList[0].ZoneCode__c;
                SBUName = zoneList[0].SBU_Name__c;
                SBUCode = zoneList[0].SBU_Code__c;
            }
            else{
                List<SBU__c> sbuList = [select Name,SBUCode__c from SBU__c where (SBUMarketingheads__c =:userId OR SBUUser__c =:userId) AND SalesOrg__r.Sales_Org_Code__c = '1000'];
                if(!sbuList.isEmpty()){
                    SBUName = sbuList[0].Name;
                    SBUCode = sbuList[0].SBUCode__c;
                }
            }
        }
                                                               
    }
    public Flow.Interview.Retailer_wise_business_flow myflow { get; set; }
    public Flow.Interview.New_Pronutiva_Kits_Survey myFlow1 { get; set; }
    /*public PageReference getNewAbsenceId() {
        PageReference p = new PageReference('');
        if (myFlow==null) 
            p.setRedirect(false);
        else {
            system.debug('@@'+myflow.NewAbsenceId);
            p = new PageReference('/' + myflow.NewAbsenceId);
            p.setRedirect(true);
        }
        return p;
        
    }*/
    public String getmyID() {
        if (myFlow==null && myFlow1!=null) {return myFlow1.NewAbsenceId;}
        else if (myFlow!=null && myFlow1==null) {return myFlow.NewAbsenceId;}
       else return '';
     }

    public PageReference getOID(){
    PageReference p = new PageReference('/' + getmyID() );
    p.setRedirect(true);
    return p;
    }
}