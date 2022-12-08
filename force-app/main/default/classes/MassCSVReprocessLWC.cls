public with sharing class MassCSVReprocessLWC {
    @AuraEnabled
  public static Date getcurrentdate(){

    Date d= system.today();
    System.debug(d);
    return d;
  }
}
