public class Grz_LiquidationReportVFBrandController {
public static Grz_POGLiquidationReportController.VFData POGWrapDataList{get;set;}
    /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :05-06-2022 */
    public static List<Integer> size{get;set;}
     /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :05-06-2022 */
    public static List<String> colHeaders{get;set;}
    //public static String test{get;set;}
    
    public static void getPOGLiquidationReport() {
        String distributor = ApexPages.currentPage().getParameters().get('distributor');
        //String distributorName = ApexPages.currentPage().getParameters().get('distributorName');
        String year = ApexPages.currentPage().getParameters().get('year');
        String quarter = ApexPages.currentPage().getParameters().get('quarter');
        String brandStringList = ApexPages.currentPage().getParameters().get('brandList');
        String search = ApexPages.currentPage().getParameters().get('search');  /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :05-06-2022 */
        String selectedColumn = ApexPages.currentPage().getParameters().get('selectedColumn').replace('-@-','%').replace('--@@--','+').replace('"','').replace('[','').replace(']','');  /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :05-06-2022 */
        /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :05-06-2022 */  
        List<String> selectedColumnList = new List<String>();
         if(selectedColumn != null && selectedColumn != ''){
             selectedColumnList = selectedColumn.split(',');
         }
        if(selectedColumnList.contains(System.Label.All)){
            selectedColumnList.remove(selectedColumnList.indexof(System.Label.All));
        }
        colHeaders = selectedColumnList;
        /*-----*/
        Boolean excludeDisInventory = false;        
        if( ApexPages.currentPage().getParameters().get('excludezero') == 'true'){
            excludeDisInventory = true;
        }
        
        System.debug('distributor : '+distributor);
        //System.debug('distributorName : '+distributorName);
        System.debug('year : '+year);
        System.debug('quarter : '+quarter);
        System.debug('brandStringList : '+brandStringList);
        List<String> brandList;
        List<String> distributorList = new List<String>();
        
        if(distributor != null && distributor != ''){
            System.debug('distributor : '+distributor);
            distributorList = distributor.split(',');
        }
        
        if(brandStringList != null && brandStringList != ''){
            System.debug('brandStringList : '+brandStringList);
            brandList = brandStringList.split(',');
        }
        /* ------------Start GRZ(Butesh Singla) : APPS-1395 PO And Delivery Date :05-06-2022 */
        System.debug('brandList : '+brandList);
        POGWrapDataList = Grz_POGLiquidationReportController.getPOGLiquidationReportDataBrandForVF(distributorList, year, quarter, brandList,excludeDisInventory,search);
         list<Integer> listSize = new list<Integer>();
        for(Integer i = 0; i< POGWrapDataList.mapping.get(System.Label.Brand).size() ; i++ ){
             listSize.add(i);
        }
        size = listSize;
        /* -- */
        System.debug('POGWrapDataList : '+POGWrapDataList);    
    } 
}