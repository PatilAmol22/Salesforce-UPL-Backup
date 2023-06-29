/*Scheduler for sending email to users of sales district if no liquidation data is created for previous month
 * -------------------Written by Virag Mhatre, 26/10/20 ------------------*/

global class MultiCountrySalesDistrictLiqReminder implements Schedulable{
    
    public List<Sales_District__c> ListOfTurkeySalesDistrict = new List<Sales_District__c>();
    public List<AggregateResult> ListOfTurkeyLiquidations = new List<AggregateResult>();
    public List<String> ListOfEmails = new List<String>();
    public Map<Integer,String> MonthMap =new map<Integer,String>();
    Set<Id> SalesDistId= new Set<Id>();
       
    global void execute(SchedulableContext SC) {
        
    Integer PreviousMonth;
    String PreviousMonthInString;
    Integer FiscalYear;
       
        MonthMap.put(1,'JAN');
        MonthMap.put(2,'Feb');
        MonthMap.put(3,'Mar');
        MonthMap.put(4,'Apr');
        MonthMap.put(5,'May');
        MonthMap.put(6,'Jun');
        MonthMap.put(7,'Jul');
        MonthMap.put(8,'Aug');
        MonthMap.put(9,'Sept');
        MonthMap.put(10,'Oct');
        MonthMap.put(11,'Nov');
        MonthMap.put(12,'Dec');
       
        //Fetching previous month 
        PreviousMonth = ((Date.today()).Month())-1;
        if(PreviousMonth==0){
            PreviousMonth=12;
        }
        PreviousMonthInString = MonthMap.get(PreviousMonth);
        
        //Getting current fiscal year (Last year if previous month is Jan, feb or March)
        If(PreviousMonthInString=='JAN' || PreviousMonthInString=='Feb' || PreviousMonthInString=='Mar'){
            FiscalYear = (Date.today().Year())-1;
        }
        else{
            FiscalYear = Date.today().Year(); 
        }
      
       //Getting list of all sales district of Turkey
      ListOfTurkeySalesDistrict = [SELECT Id, User__r.Email
                                      FROM Sales_District__c 
                                      WHERE User__r.Country = 'Turkey'
                                     ];
        
       //Getting list of all liquidations created for Turkey and creating Set of liquidation sales district
       ListOfTurkeyLiquidations = [SELECT SUM(Distributors_Inventory__c),SUM(Retailers_Inventory__c), SUM(Plan_for_the_next_month__c), Sales_District__c, Month__c
                                   FROM Liquidation2__c 
                                   WHERE Sales_District__c IN :ListOfTurkeySalesDistrict
                                   AND Month__c = :PreviousMonthInString
                                   AND CALENDAR_YEAR (Liquidation_Annual_Plan__r.Fiscal_Start_Date__c) = :FiscalYear
                                   GROUP BY Sales_District__c, Month__c];
        
        for(AggregateResult liq: ListOfTurkeyLiquidations){
            if(liq.get('expr0')==0 && liq.get('expr1')==0 && liq.get('expr0')==0){
                SalesDistId.add((Id)liq.get('Sales_District__c'));
            }
        }
        
       /*  ListOfTurkeySalesDistrict = [SELECT Id, User__r.Email
                                      FROM Sales_District__c 
                                      WHERE User__r.Country = 'Turkey'
                                      AND Id IN :SalesDistId]; */
        
        for(Sales_District__c TSD : ListOfTurkeySalesDistrict){ 
            if(SalesDistId.contains(TSD.Id)){
                ListOfEmails.add(TSD.User__r.Email);
            }                 
        } 
        
        //Sending Mails to user if there is atleast one sales district with no liquidation data for previous month
        system.debug('Emails --->'+ListOfEmails);
        if(ListOfEmails.size()>0){
            SendMail();
        }
    }
    
    public void sendMail(){
      //Logic for getting previous month full name
      DateTime dt = Datetime.now().addMonths(-1);
      String PreviousMonthFullName = dt.format('MMMM');
      
      Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
      email.setSubject('Notification for liquidation creation');
      email.setPlainTextBody('Hi User,\n\nGentle Reminder, Please fill in the POG details for the month of '+PreviousMonthFullName+'.\n\nThanks,\nUPL Team');
      email.setToAddresses(ListOfEmails);
      Messaging.sendEmail(New Messaging.SingleEmailMessage[]{email});
   }
}