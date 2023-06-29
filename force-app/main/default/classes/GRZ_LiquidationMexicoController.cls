/* ------------Start GRZ(Dheeraj Sharma) : APPS-1395 PO And Delivery Date :19-07-2022 */ 
public with sharing class GRZ_LiquidationMexicoController {
    public static List<dataList> POGWrapDataList{get;set;}
    
    public static void getPOGLiquidationMexico() {
        System.debug('integ');

        String searchstr='';
        
        String saleOrgCode = ApexPages.currentPage().getParameters().get('saleOrgCode');
        String salesDistrict = ApexPages.currentPage().getParameters().get('salesDistrict');
        String distributor = ApexPages.currentPage().getParameters().get('distributor');
        String shipToParty = ApexPages.currentPage().getParameters().get('shipToParty');
        String year = ApexPages.currentPage().getParameters().get('year');
        String month = ApexPages.currentPage().getParameters().get('month');
        //        String lst_districtsIds = ApexPages.currentPage().getParameters().get('lst_districtsIds');
        //   String lst_distributorIds = ApexPages.currentPage().getParameters().get('lst_distributorIds');
        
        //   List<String> lst_districtsIdsList = new List<String>();
        //    List<String> lst_distributorIdsList = new List<String>();
        
        //	lst_districtsIds = lst_districtsIds.replace('"','').replace('[','').replace('',']');
        //     lst_districtsIdsList = (lst_districtsIds.split(','));
        
        //       lst_distributorIds = lst_distributorIds.replace('"','').replace('[','').replace('',']');
        //      lst_distributorIdsList = (lst_distributorIds.split(','));
        
        searchstr = ApexPages.currentPage().getParameters().get('searchStr');
        String allLabel=System.Label.All;
       System.debug('saleOrgCode : '+saleOrgCode);
        System.debug('salesDistrict : '+salesDistrict);
       System.debug('distributor : '+distributor);
        System.debug('shipToParty : '+shipToParty);
        System.debug('year : '+year);
        System.debug('month : '+month);
        System.debug('searchstr : '+searchstr);
     //   System.debug('allLabel : '+allLabel);
        //  System.debug('lst_districtsIds : '+lst_districtsIds);
        //  System.debug('lst_distributorIds : '+lst_distributorIds);
        
        
        List<dataList> res = new list<dataList>();
        if(salesDistrict == '' || distributor=='' || shipToParty=='') {
            
          //  System.debug('integ');
            
            List<Liquidation2__c> POGIntegration = new list<Liquidation2__c>();
            Map<String,Liquidation2__c>  POGMapDataList=LiquidationMexico.rollUpLiquidation('', '', salesDistrict, year, month, distributor, shipToParty, saleOrgCode);
         	system.debug('POGMapDataList==>>'+POGMapDataList);
            if(test.isRunningTest()){
                Liquidation2__c liq = [select id,Month__c,SKU_Code__c,Brand_Name__c,SKU_Description__c,YTD_Sales_Wrap__c,Liquidation_YTD_Wrap__c,Total_Available_Stock_Wrap__c,Distributors_Inventory__c,Retailers_Inventory__c,Total_Market_Inventory_Wrap__c,Plan_for_the_month__c,Plan_for_the_next_month__c,Opening_Inventory_Wrap__c,UOM_Wrap__c,Liquidation_YTD_Percent_Wrap__c from Liquidation2__c where Month__c='Nov' limit 1];
                POGMapDataList.put('Test',liq);
            }
            
            POGIntegration.addAll(POGMapDataList.values());
            //List<Liquidation2__c> POGIntegrationSorted = new list<Liquidation2__c>();
            System.debug('POGIntegration'+POGIntegration);
            for (integer i = 0; i < POGIntegration.size(); i++) {
            // Inner nested loop pointing 1 index ahead
            for (integer j = i + 1; j < POGIntegration.size(); j++) {
 				
                // Checking elements
                Liquidation2__c temp = new Liquidation2__c();
                if (POGIntegration[i].Total_Available_Stock_Wrap__c < POGIntegration[j].Total_Available_Stock_Wrap__c) {
 
                    // Swapping
                    temp = POGIntegration[i];
                    POGIntegration[i] = POGIntegration[j];
                    POGIntegration[j] = temp;
                }
            }
 
        }
            
            for(Liquidation2__c l : POGIntegration){
                dataList d = new dataList();
                if(searchstr != null && searchstr != ''){
                    if( l.SKU_Code__c.replaceFirst('^0+', '').contains(searchstr) || l.SKU_Description__c.tolowercase().contains(searchstr.tolowercase())){
                        d.SKU_Code = l.SKU_Code__c.replaceFirst('^0+', '');
                        d.Brand_Name = l.Brand_Name__c;
                        d.SKU_Description = l.SKU_Description__c;
                        d.YTD_Sales_Wrap = l.YTD_Sales_Wrap__c.setScale(1).format();
                        d.Liquidation_YTD_Wrap = l.Liquidation_YTD_Wrap__c.setScale(1).format();
                        d.Total_Available_Stock_Wrap = l.Total_Available_Stock_Wrap__c.setScale(1).format();
                        d.Distributors_Inventory = l.Distributors_Inventory__c.setScale(1).format();
                        d.Retailers_Inventory =l.Retailers_Inventory__c.setScale(1).format();
                        d.Total_Market_Inventory_Wrap = l.Total_Market_Inventory_Wrap__c.setScale(1).format();
                        d.Plan_for_the_month = l.Plan_for_the_month__c.setScale(1).format();
                        d.Plan_for_the_next_month = l.Plan_for_the_next_month__c.setScale(1).format();
                        d.Opening_Inventory_Wrap = l.Opening_Inventory_Wrap__c.setScale(1).format();
                        d.UOM_Wrap = string.valueof(l.UOM_Wrap__c);
                        d.Liquidation_YTD_Percent_Wrap = string.valueof(l.Liquidation_YTD_Percent_Wrap__c) + ' %';
                        res.add(d);
                    }
                }else{
                    d.SKU_Code = l.SKU_Code__c.replaceFirst('^0+', '');
                    d.Brand_Name = l.Brand_Name__c;
                    d.SKU_Description = l.SKU_Description__c;
                    d.YTD_Sales_Wrap = l.YTD_Sales_Wrap__c.setScale(1).format();
                    d.Liquidation_YTD_Wrap = l.Liquidation_YTD_Wrap__c.setScale(1).format();
                    d.Total_Available_Stock_Wrap = l.Total_Available_Stock_Wrap__c.setScale(1).format();
                    d.Distributors_Inventory = l.Distributors_Inventory__c.setScale(1).format();
                    d.Retailers_Inventory =l.Retailers_Inventory__c.setScale(1).format();
                    d.Total_Market_Inventory_Wrap = l.Total_Market_Inventory_Wrap__c.setScale(1).format();
                    d.Plan_for_the_month = l.Plan_for_the_month__c.setScale(1).format();
                    d.Plan_for_the_next_month = l.Plan_for_the_next_month__c.setScale(1).format();
                    d.Opening_Inventory_Wrap = l.Opening_Inventory_Wrap__c.setScale(1).format();
                    d.UOM_Wrap = string.valueof(l.UOM_Wrap__c);
                    d.Liquidation_YTD_Percent_Wrap = string.valueof(l.Liquidation_YTD_Percent_Wrap__c) + ' %';
                    res.add(d);
                }
               
            }
           // POGWrapDataList = POGIntegration;
        }else{
            List<Liquidation2__c> POGWrapDataList1 = new List<Liquidation2__c>();
            POGWrapDataList1=  LiquidationMexico.getAllLiquidationPDF(saleOrgCode, salesDistrict,distributor,shipToParty, year, month ,searchstr );
            System.debug('POGWrapDataList1'+POGWrapDataList1);
           for(Liquidation2__c l : POGWrapDataList1){
                dataList d = new dataList();
                d.SKU_Code = l.SKU__r.SKU_Code__c.replaceFirst('^0+', '');
               // d.Brand_Name = l.Brand_Name__c;
                d.SKU_Description = l.SKU__r.SKU_Description__c;
                d.YTD_Sales_Wrap = l.YTD_Sales__c.setScale(1).format();
                d.Liquidation_YTD_Wrap = l.Liquidation_YTD__c.setScale(1).format();
                d.Total_Available_Stock_Wrap = l.Total_Available_Stock__c.setScale(1).format();
                d.Distributors_Inventory = l.Distributors_Inventory__c.setScale(1).format();
                d.Retailers_Inventory = l.Retailers_Inventory__c.setScale(1).format();
                d.Total_Market_Inventory_Wrap = l.Total_Market_Inventory__c.setScale(1).format();
                d.Plan_for_the_month = l.Plan_for_the_month__c.setScale(1).format();
                d.Plan_for_the_next_month = l.Plan_for_the_next_month__c.setScale(1).format();
                d.Opening_Inventory_Wrap = l.Opening_Inventory2__r.Opening_Inventory__c.setScale(1).format();
                d.UOM_Wrap = string.valueof(l.SKU__r.UOM__c);
               if(l.Liquidation_Percent_YTD__c != null){
                   d.Liquidation_YTD_Percent_Wrap = String.valueof(l.Liquidation_Percent_YTD__c) + ' %';
               }else{
                   d.Liquidation_YTD_Percent_Wrap = '0 %';
               }
                //d.Liquidation_YTD_Percent_Wrap = string.valueof(l.Liquidation_Percent_YTD__c) + ' %';
                res.add(d);
            }
            //POGWrapDataList = POGWrapDataList1;
            
        }
        //System.debug('POGWrapDataList : '+POGWrapDataList); 
        POGWrapDataList = res;
        
    }
    
    public class dataList{
        public String SKU_Code{get;set;}
        public String Brand_Name{get;set;}
        public String SKU_Description{get;set;} 
        public String YTD_Sales_Wrap{get;set;} 
        public String Liquidation_YTD_Wrap{get;set;} 
        public String Total_Available_Stock_Wrap{get;set;} 
        public String Distributors_Inventory{get;set;} 
        public String Retailers_Inventory{get;set;} 
        public String Total_Market_Inventory_Wrap{get;set;} 
        public String Plan_for_the_month{get;set;} 
        public String Plan_for_the_next_month{get;set;} 
        public String Opening_Inventory_Wrap{get;set;} 
        public String UOM_Wrap{get;set;} 
        public String Liquidation_YTD_Percent_Wrap{get;set;} 
    } 
}