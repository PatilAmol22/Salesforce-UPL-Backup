/**************************************************************************************************
* Name               : ScheduleFetchInvoiceBrazil                                                      
* Description        : Scheduler class for BatchUpdateInvoiceBrazil
* Test Class         : ScheduleFetchInvoiceBrazilTest
* Modified By        : Nikhil Verma (Grazitti) RITM0543410                                                                      
**************************************************************************************************/
global class ScheduleFetchInvoiceBrazil implements Schedulable{
    global void execute(SchedulableContext ctx) {
        List<WrapperDate> LiWrapDate = new list<WrapperDate>();
        date enddate = date.today() - 1;
        date startdate = date.today() - integer.valueOf(UPL_Settings__c.getOrgDefaults().OrderBatchDateRange__c);
        integer size = integer.valueOf(UPL_Settings__c.getOrgDefaults().OrderBatchSize__c);
        integer decrement = size+1;
        for (date d=enddate; d >  startdate; d=d-decrement){
            WrapperDate wrapdate = new WrapperDate();
            wrapdate.endDate = d;
            if(d-size>startdate){
                wrapdate.startDate = d-size;
            }else{
                wrapdate.startDate = startdate;
            }
            LiWrapDate.add(wrapdate);
        }           
        if(LiWrapDate != null && LiWrapDate.size() <= 100){
            BatchUpdateInvoiceBrazil bo = new BatchUpdateInvoiceBrazil(LiWrapDate);
            Database.executeBatch(bo,1);
        }else{
            system.debug('SFDC cannot perform more than 100 callouts in Batch');
        }
    }
}