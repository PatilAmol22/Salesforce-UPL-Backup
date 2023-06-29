/* ------------Start GRZ(Dheeraj Sharma) : APPS-1395 PO And Delivery Date :06-07-2022 */ 
public with sharing class Grz_LiquidationPolandController {

  public static List<Grz_PolandLiquidation.POGDataWrapperData> POGWrapDataList{get;set;}

  public static void getPOGLiquidationpoland() {
      String inputValue='';
      String distributor = ApexPages.currentPage().getParameters().get('distributor');
      String distributorName = ApexPages.currentPage().getParameters().get('distributorName');
      String year = ApexPages.currentPage().getParameters().get('year');
      String quarter = ApexPages.currentPage().getParameters().get('quarter');
    inputValue = ApexPages.currentPage().getParameters().get('searchValue');
      
      System.debug('distributor : '+distributor);
      System.debug('distributorName : '+distributorName);
      System.debug('year : '+year);
      System.debug('quarter : '+quarter);
      System.debug('inputValue : '+inputValue);
       POGWrapDataList=  Grz_PolandLiquidation.getLiquidationPolandDataPDF(distributor, distributorName, year, quarter ,inputValue );
      
      System.debug('POGWrapDataList : '+POGWrapDataList);      
  } 
  


}