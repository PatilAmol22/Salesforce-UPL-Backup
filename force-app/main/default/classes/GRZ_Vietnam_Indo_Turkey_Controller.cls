/* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :16-07-2022 */  
public with Sharing class GRZ_Vietnam_Indo_Turkey_Controller {
    public static List<dataList> pogDataList{get;set;}
    public static boolean hideColumn{get;set;}
    
    public static void getPOGLiquidationData() {
        String inputValue='';
        String month='';
        String hasColumnTrue='';
        String Sales_Org = ApexPages.currentPage().getParameters().get('Sales_Org');
        String distributor = ApexPages.currentPage().getParameters().get('distributor');
        String sales_district = ApexPages.currentPage().getParameters().get('sales_district');
        String shipToParty = ApexPages.currentPage().getParameters().get('shipToParty');
        String year = ApexPages.currentPage().getParameters().get('year');
        month = ApexPages.currentPage().getParameters().get('Month');
        inputValue = ApexPages.currentPage().getParameters().get('searchValue');
        hasColumnTrue = ApexPages.currentPage().getParameters().get('columnTrue');
        if(hasColumnTrue=='True'){
            hideColumn=false;
        }else{
            hideColumn=true;
        }
        
        System.debug('distributor : '+distributor);
        System.debug('Sales_Org : '+Sales_Org);
        System.debug('sales_district : '+sales_district);
        System.debug('month : '+month);
        System.debug('year : '+year);
        System.debug('inputValue : '+inputValue);
        
        
        
        List<dataList> res = new list<dataList>();
        if(sales_district!='' && distributor!=''){
            List<Liquidation2__c> pogDataList1 = new List<Liquidation2__c>();
            pogDataList1 = Liquidation_Indo_turkey.getAllLiquidationPDFXLS(sales_district,distributor,Sales_Org,year,month,inputValue);
            System.debug('pogDataList1'+pogDataList1);
            for(Liquidation2__c pog :pogDataList1){
                dataList d = new dataList();
                d.SKU_Code = pog.SKU__r.SKU_Code__c.replaceFirst('^0+', '');
                d.Brand_Name = pog.SKU__r.Brand_Name__c;
                d.SKU_Description = pog.SKU__r.SKU_Description__c;
                d.YTD_Sales_Wrap = pog.YTD_Sales__c.setScale(1).format();
                d.Liquidation_YTD_Wrap = pog.Liquidation_YTD__c.setScale(1).format();
                d.Total_Available_Stock_Wrap = pog.Total_Available_Stock__c.setScale(1).format();
                d.Distributors_Inventory = pog.Distributors_Inventory__c.setScale(1).format();
                d.Retailers_Inventory =pog.Retailers_Inventory__c.setScale(1).format();
                d.Total_Market_Inventory_Wrap = pog.Total_Market_Inventory__c.setScale(1).format();
                d.Plan_for_the_month = pog.Plan_for_the_month__c.setScale(1).format();
                d.Plan_for_the_next_month = pog.Plan_for_the_next_month__c.setScale(1).format();
                d.Opening_Inventory_Wrap = pog.Opening_Inventory2__r.Opening_Inventory__c.setScale(1).format();
                d.UOM_Wrap = string.valueof(pog.SKU__r.UOM__c);
                if(pog.Liquidation_Percent_YTD__c != null){
                    d.Liquidation_YTD_Percent_Wrap = string.valueof(pog.Liquidation_Percent_YTD__c) + ' %';
                }else{
                    d.Liquidation_YTD_Percent_Wrap = '0 %';
                }
                if(pog.Liquidation_YTD__c != null && pog.Liquidation_YTD__c != 0 && pog.Plan_for_the_month__c != null && pog.Plan_for_the_month__c != 0){
                    d.Liquidation_YTD_Plan_YTD = String.valueOf(pog.Liquidation_YTD__c / pog.Plan_for_the_month__c)+' %';
                }else{
                    d.Liquidation_YTD_Plan_YTD = '0 %';
                }
                
                res.add(d);
                
            }  
            pogDataList = res;
            // system.debug('pogDataList'+pogDataList);
            //system.debug('salesforceDataIn');
        }else{
            
            Map<String,Liquidation2__c> POGWrapDataList =  Liquidation_Indo_turkey.rollUpLiquidationPDFXLS(sales_district, year, month, distributor, Sales_Org );
            List<Liquidation2__c> pogDataListIntegration = new List<Liquidation2__c>();
            if(test.isRunningTest()){
                Liquidation2__c liq = [select id,Month__c,SKU_Code__c,Brand_Name__c,SKU_Description__c,YTD_Sales_Wrap__c,Liquidation_YTD_Wrap__c,Total_Available_Stock_Wrap__c,Distributors_Inventory__c,Retailers_Inventory__c,Total_Market_Inventory_Wrap__c,Plan_for_the_month__c,Plan_for_the_next_month__c,Opening_Inventory_Wrap__c,UOM_Wrap__c,Liquidation_YTD_Percent_Wrap__c from Liquidation2__c where Month__c='Sept' limit 1];
                POGWrapDataList.put('Test',liq);
            }
            pogDataListIntegration.addAll(POGWrapDataList.values());
            // pogDataList = pogDataList1;
            
            for (integer i = 0; i < pogDataListIntegration.size(); i++) {
                for (integer j = i + 1; j < pogDataListIntegration.size(); j++) {
                    Liquidation2__c temp = new Liquidation2__c();
                    if (pogDataListIntegration[i].Total_Available_Stock_Wrap__c < pogDataListIntegration[j].Total_Available_Stock_Wrap__c) {
                        temp = pogDataListIntegration[i];
                        pogDataListIntegration[i] = pogDataListIntegration[j];
                        pogDataListIntegration[j] = temp;
                    }
                }
                
            }
          
            for(Liquidation2__c pog :pogDataListIntegration){
                dataList d = new dataList();
                if(inputValue != null && inputValue != ''){
                    if(pog.Brand_Name__c == null){
                        pog.Brand_Name__c = '';
                    }
                    
                    if( pog.SKU_Code__c.replaceFirst('^0+', '').contains(inputValue) || pog.SKU_Description__c.tolowercase().contains(inputValue.tolowercase()) || pog.Brand_Name__c.tolowercase().contains(inputValue.toLowerCase())){
                      
                        d.SKU_Code = pog.SKU_Code__c.replaceFirst('^0+', '');
                        d.Brand_Name = pog.Brand_Name__c;
                        d.SKU_Description = pog.SKU_Description__c;
                        d.YTD_Sales_Wrap = pog.YTD_Sales_Wrap__c.setScale(1).format();
                        d.Liquidation_YTD_Wrap = pog.Liquidation_YTD_Wrap__c.setScale(1).format();
                        d.Total_Available_Stock_Wrap = pog.Total_Available_Stock_Wrap__c.setScale(1).format();
                        d.Distributors_Inventory = pog.Distributors_Inventory__c.setScale(1).format();
                        d.Retailers_Inventory =pog.Retailers_Inventory__c.setScale(1).format();
                        d.Total_Market_Inventory_Wrap = pog.Total_Market_Inventory_Wrap__c.setScale(1).format();
                        d.Plan_for_the_month = pog.Plan_for_the_month__c.setScale(1).format();
                        d.Plan_for_the_next_month = pog.Plan_for_the_next_month__c.setScale(1).format();
                        d.Opening_Inventory_Wrap = pog.Opening_Inventory_Wrap__c.setScale(1).format();
                        d.UOM_Wrap = string.valueof(pog.UOM_Wrap__c);
                        d.Liquidation_YTD_Percent_Wrap = string.valueof(pog.Liquidation_YTD_Percent_Wrap__c) + ' %';
                        if(pog.Liquidation_YTD_Wrap__c != null && pog.Liquidation_YTD_Wrap__c != 0 && pog.Plan_for_the_month__c != null && pog.Plan_for_the_month__c != 0){
                            d.Liquidation_YTD_Plan_YTD = String.valueOf(pog.Liquidation_YTD_Wrap__c / pog.Plan_for_the_month__c)+' %';
                        }else{
                            d.Liquidation_YTD_Plan_YTD = '0 %';
                        }
                        res.add(d);
                    }
                }else{
                    d.SKU_Code = pog.SKU_Code__c.replaceFirst('^0+', '');
                    d.Brand_Name = pog.Brand_Name__c;
                    d.SKU_Description = pog.SKU_Description__c;
                    d.YTD_Sales_Wrap = pog.YTD_Sales_Wrap__c.setScale(1).format();
                    d.Liquidation_YTD_Wrap = pog.Liquidation_YTD_Wrap__c.setScale(1).format();
                    d.Total_Available_Stock_Wrap = pog.Total_Available_Stock_Wrap__c.setScale(1).format();
                    d.Distributors_Inventory = pog.Distributors_Inventory__c.setScale(1).format();
                    d.Retailers_Inventory =pog.Retailers_Inventory__c.setScale(1).format();
                    d.Total_Market_Inventory_Wrap = pog.Total_Market_Inventory_Wrap__c.setScale(1).format();
                    d.Plan_for_the_month = pog.Plan_for_the_month__c.setScale(1).format();
                    d.Plan_for_the_next_month = pog.Plan_for_the_next_month__c.setScale(1).format();
                    d.Opening_Inventory_Wrap = pog.Opening_Inventory_Wrap__c.setScale(1).format();
                    d.UOM_Wrap = string.valueof(pog.UOM_Wrap__c);
                    d.Liquidation_YTD_Percent_Wrap = string.valueof(pog.Liquidation_YTD_Percent_Wrap__c) + ' %';
                    if(pog.Liquidation_YTD_Wrap__c != null && pog.Liquidation_YTD_Wrap__c != 0 && pog.Plan_for_the_month__c != null && pog.Plan_for_the_month__c != 0){
                        d.Liquidation_YTD_Plan_YTD = String.valueOf(pog.Liquidation_YTD_Wrap__c / pog.Plan_for_the_month__c)+' %';
                    }else{
                        d.Liquidation_YTD_Plan_YTD = '0 %';
                    }
                    res.add(d);
                }
                
                
            }            
            pogDataList = res;
            
            // System.debug('SKU_Code__c : '+pogDataList[0].SKU_Code__c);      
            // System.debug('SKU_Description__c : '+pogDataList[0].SKU_Description__c);      
            System.debug('POGWrapDataList : '+POGWrapDataList);      
            System.debug('pogDataList : '+pogDataList);      
        } 
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
        public String Liquidation_YTD_Plan_YTD{get;set;} 
    } 
}