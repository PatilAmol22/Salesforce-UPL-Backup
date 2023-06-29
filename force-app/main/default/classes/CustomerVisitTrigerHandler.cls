public class CustomerVisitTrigerHandler{
    
    public static void beforeInsertProduct(List<Customer_Visit__c> newList){
    Date dt = System.today(); //current date
    Integer day = dt.Day(); //get day
    Integer month = dt.Month(); //get month
    Integer year = dt.Year(); //get year
    string s1=string.valueof(year).right(2);
    Integer Year1= Integer.valueof(s1);
    String currentFiscalYear = [SELECT FiscalYearSettings.Name FROM Period WHERE Type = 'Year' AND StartDate <= TODAY AND EndDate >= TODAY].FiscalYearSettings.Name;
    string s2=string.valueof(currentFiscalYear).right(2);
    Integer Year2= Integer.valueof(s2);
    Integer num = 0000;
    Id devCustomerVisitRecordTypeId = Schema.SObjectType.Customer_Visit__c.getRecordTypeInfosByName().get('FR NeoFog teams').getRecordTypeId();
       
    List<Customer_Visit__c> cvList = new List<Customer_Visit__c>();
    cvList = [Select Id, Name, Certificate_number__c  from Customer_Visit__c where Certificate_number__c != '' AND RecordTypeId =: devCustomerVisitRecordTypeId order by Certificate_number__c Desc limit 1]; 
    String[] splitted;
    Integer latestRecordYear;
        if(cvList.size()>0){
            splitted = cvList[0].Certificate_number__c.split(' - '); 
            latestRecordYear = Integer.ValueOf(splitted[0]);
        }
        
          //  String latestRecordYear = splitted[0];
        
        for(Customer_Visit__c cv : newList)
        {   
            if(latestRecordYear == null){ 
                     cv.Certificate_Number__c = Year2 + ' - 0001';
             }
            if(latestRecordYear == Year2 && latestRecordYear != null)
            {     
                Integer autoNumb = Integer.ValueOf(splitted[1]);
                autoNumb = autoNumb + 1;
                 if(autoNumb > 0 && autoNumb < 10){
                     cv.Certificate_number__c = Year2 + ' - 000' + String.valueOf(autoNumb); // 24 - 0001
                 }
                 if(autoNumb >= 10 && autoNumb < 100){
                     cv.Certificate_number__c = Year2 + ' - 00' + String.valueOf(autoNumb); // 24 - 0001
                 }
                 if(autoNumb >= 100 && autoNumb < 1000){
                     cv.Certificate_number__c = Year2 + ' - 0' + String.valueOf(autoNumb); // 24 - 0001 
                 }
            }
           else    
            {
                cv.Certificate_number__c =  Year2 + ' - 0001'; //  Certificate_number__c  //  AutoNumberText__c
            }
        }   
    }  
}