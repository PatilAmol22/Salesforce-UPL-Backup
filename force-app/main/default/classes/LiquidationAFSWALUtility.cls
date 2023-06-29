public class LiquidationAFSWALUtility {
	
    public static Boolean LiquidationStatusMail(String salesOrg){
        Boolean validLiqPeriod = false;   
        Integer dayNum = System.today().day();
        Integer currMonth = System.today().Month();
        MultiCountry_Liquidation__c mcLiq = MultiCountry_Liquidation__c.getValues(salesOrg);
        Decimal startDateNum = mcLiq.Liquidation_Start_Day__c;
        Integer daysCount = Integer.valueOf(System.Label.StatusMailDaysCount); //Get days count from custom Label

        if(mcLiq.Active__c = true && (dayNum <= startDateNum+daysCount) && mcLiq.Active_Month__c){
            validLiqPeriod = true;
        }
        return validLiqPeriod;
    }

    public static String getFiscalYear(){
        String fiscalYear;

        Integer curMonth = Date.Today().Month();
        /**Create custom Date */
        /*
        Date myDate = date.newinstance(2023, 4, 17);
        System.debug('myDate = '+myDate);
                Integer curMonth = myDate.Month();
        System.debug('curMonth = '+curMonth);
        */

        String currentFiscalYear = [SELECT FiscalYearSettings.Name FROM Period WHERE Type = 'Year' AND StartDate <= TODAY AND EndDate >= TODAY].FiscalYearSettings.Name;
        if(curMonth == 4){
            Integer fiscalyr = Integer.valueOf(currentFiscalYear)-2;
            fiscalYear = String.valueOf(fiscalyr)+'-'+String.valueOf(Integer.valueOf(currentFiscalYear)-1);
        }else{
            Integer fiscalyr = Integer.valueOf(currentFiscalYear)-1;
            fiscalYear = String.valueOf(fiscalyr)+'-'+currentFiscalYear;
        }

        return fiscalYear;
    }

    //Send Email to Admin
    public static void sendEmail(String actionName, String actionObj){
        try{
            //get OrgWideEmailAddressId
            String owaEmail = System.Label.OWAEmailId;
            List<OrgWideEmailAddress> owaList = new List<OrgWideEmailAddress>();
            String adminEmail = System.Label.AdminEmail;
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            //get OWA ID
            owaList = [SELECT Id FROM OrgWideEmailAddress WHERE Address = :owaEmail];
            if(owaList.size() > 0){
                message.setOrgWideEmailAddressId(owaList[0].Id);
            }
            message.subject = 'Opening Inventory created for '+actionName+' - '+actionObj;
            message.plainTextBody = 'Hi, \nOpening Inventory is created for '+actionName+' - '+actionObj+'\n\nRegards,\nUPL Ltd';
            message.toAddresses = new String[] {adminEmail};
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            if (results[0].success) 
            {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' +  results[0].errors[0].message);
            }
        }catch(Exception exp){
            System.debug('Something went wrong - '+exp.getMessage());
        }
    }
}