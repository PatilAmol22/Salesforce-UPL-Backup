public class UtilityClass {
	public static String getSalesOrgIndiaSAS() { 
        return UPL_Settings__c.getInstance().India_SAS_Sales_Org__c;
  }
    public static String getCompanyCodeIndiaSAS() { 
        return UPL_Settings__c.getInstance().India_SAS_Company_Code__c;
  }
    public static String getSalesOrgIndiaOld() { 
        return UPL_Settings__c.getInstance().India_Old_Sales_Org_Code__c;
  }
    
/*
    * Description: Retrieve all sales org details exist in UPL_SalesOrg_details__mdt custom metadata Types
	* Param: NA
	* return : msalesOrgDetailsMap
    * */

  public static Map<String,UPL_SalesOrg_Detail__mdt> msalesOrgDetailsMap;
  public static Map<String, UPL_SalesOrg_Detail__mdt> getSalesOrgDetails(){
      if(msalesOrgDetailsMap == null){
          msalesOrgDetailsMap = new Map<String, UPL_SalesOrg_Detail__mdt>();
          List<UPL_SalesOrg_Detail__mdt> salesOrgDetailsList = [SELECT Label, value__c,Distribution_Channel_Code__c,Location__c FROM UPL_SalesOrg_Detail__mdt];
          for(UPL_SalesOrg_Detail__mdt salesOrgDetail : salesOrgDetailsList){
             msalesOrgDetailsMap.put(salesOrgDetail.Label, salesOrgDetail); 
          }
      }
	return msalesOrgDetailsMap;
  }
    
    /*
    * Description: Retrieve all sales org details exist in UPL_SalesOrg_details__mdt custom metadata Types
	* Param: NA
	* return : msalesOrgDetailsMap
    * */
    public static void exceptionCoverage(Boolean throwEx){
        if(Test.isRunningTest() && throwEx){
            Integer x = 1/0;
        }
    }
    
/*
   * Description: Retrieve all FreezePeriod details exist in Argentina_Freeze_Period__mdt custom metadata Types
	* Param: NA
	* return : mArgentinaFreezeperiodMap
    * */

  public static Map<String,Decimal> mArgentinaFreezeperiodMap;
  public static Map<String,Decimal> getArgentinaFreezePeriodDetails(){
      if(mArgentinaFreezeperiodMap == null){
          mArgentinaFreezeperiodMap = new Map<String,Decimal>();
          List<Argentina_Freeze_Period__mdt> freezePeriodList = [Select id,Depot_Code__c,Freeze_Period__c,State_Code__c,Type__c from Argentina_Freeze_Period__mdt];
          for(Argentina_Freeze_Period__mdt freezePeriodDetail : freezePeriodList){
             String freezeKey = freezePeriodDetail.Depot_Code__c + freezePeriodDetail.State_Code__c + freezePeriodDetail.Type__c;
             mArgentinaFreezeperiodMap.put(freezeKey, freezePeriodDetail.Freeze_Period__c);
          }
      }
	return mArgentinaFreezeperiodMap;
  }
/*
   * Description: Retrieve all Parent and it's respective child skus of Poland
	* Param: NA
	* return : childParentMap
    * */
 public static Map<String,String> childParentMap;
 public static Map<String,String> polandDependentSKU(){  
     if(childParentMap == null){
         childParentMap = new Map<String,String>();
         List<Poland_Dependent_SKU_Code__mdt> PD_Sku = [SELECT Id,Main_SKU_Code__c,Child_SKU_Code__c,Sub_SKU_Codes__c FROM Poland_Dependent_SKU_Code__mdt];
         for(Poland_Dependent_SKU_Code__mdt skuInfo:PD_Sku){
             for(String childSKu:skuInfo.Child_SKU_Code__c.split(',')){
                 childParentMap.put(childSKu,skuInfo.Main_SKU_Code__c);
             }
         }
     }
     return childParentMap;
 }
    
    
}