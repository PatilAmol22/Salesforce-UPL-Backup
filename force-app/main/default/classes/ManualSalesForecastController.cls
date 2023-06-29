public without sharing class ManualSalesForecastController {

    @AuraEnabled
    public static Boolean checkAccount(String accId){
        Boolean flag = false;

        try{
            if(accId != ''){
                List<Forecast_Account__c> accList = new List<Forecast_Account__c>();
                accList = [SELECT Id, Name, Account__c, Territory__c FROM Forecast_Account__c 
                            WHERE Account__c =: accId AND 
                            Territory__r.TerritoryManager__c =: UserInfo.getUserId()];

                if(accList.size()>0){
                    flag = true;
                }
            }
            
        }
        catch(Exception ex){
            system.debug('Exception in checkAccount method ');
            system.debug('Exception is - ' + ex);
            system.debug('Exception at Line no  - ' + ex.getLineNumber());
        }

        return flag;
    }

    @AuraEnabled
    public static List<Forecast_Account__c> getCustomerRegions(String accId) {
        List<Forecast_Account__c> custRegList = new List<Forecast_Account__c>();
        String country ='';
        String salesOrg_Code = '';
        String recordType = '';
        String accountType = '';
        Boolean forecastReq = false;
        try{
            /* User user = [SELECT Id, Name, Country, State, Division, IsActive, UserType, 
                        ManagerId FROM User where Id =: UserInfo.getUserId()];

            Login_Country__c logCntry = [SELECT Id, Name, For_Contry__c FROM Login_Country__c where Name =:user.Country limit 1];

            if(logCntry != null){
                country = logCntry.For_Contry__c;
            }
            
            if(country == 'Brazil'){
                salesOrg_Code = '5191';
                recordType = 'Distributor';
                accountType = 'Sold To Party';
                forecastReq = true;
            } */

            if(accId != ''){
                custRegList = [SELECT Id, Name, Account__c, Territory__c, Territory__r.Region__c,
                                Account__r.SAP_Code__c, Territory__r.TerritoryCode__c, Territory__r.Name, 
                                Territory__r.TerritoryManager__c, Territory__r.Region__r.RegionHead__c 
                                FROM Forecast_Account__c WHERE Account__c =: accId AND 
                                Territory__r.TerritoryManager__c =: UserInfo.getUserId()];
            }
            
        }
        catch(Exception ex){
            system.debug('Exception in getCustomerRegions method ');
            system.debug('Exception is - ' + ex);
            system.debug('Exception at Line no  - ' + ex.getLineNumber());
        }
        return custRegList;
    }

    @AuraEnabled
    public static String getActiveMonth(){
        String mnthName = '';
        String country ='';
        String salesOrg_Code = '';

        try{
            User user = [SELECT Id, Name, Country, State, Division, IsActive, UserType, 
                        ManagerId FROM User where Id =: UserInfo.getUserId()];

                        //system.debug('UserInfo.getUserId() ****' + UserInfo.getUserId());
        
            Login_Country__c logCntry = [SELECT Id, Name, For_Contry__c FROM Login_Country__c where Name =:user.Country limit 1];

            if(logCntry != null){
                country = logCntry.For_Contry__c;
            }
            //system.debug('country - ' + country);

            if(country == 'Brazil'){
                salesOrg_Code = '5191';
            }

           // system.debug('salesOrg_Code - ' + salesOrg_Code);

            if(salesOrg_Code != ''){
                Sales_Forecast_Setting__c sfs = new Sales_Forecast_Setting__c();
                sfs = [SELECT Id, Name, CurrencyIsoCode, Sales_Org__c, Sales_Agreement_Schedule_Frequency_Allow__c, 
                        Active_Forecast_Month__c, Schedule_Frequency_Allowed__c, Currency_Allowed__c, 
                        Start_Day_Of_Approval__c, End_Day_Of_Approval__c, Configuration_on_Sales_Forecast_Metric__c, 
                        Clone_the_existing_Forecast_Previous_mon__c, Create_a_forecast_based_on_the__c, 
                        Admin_Profile_Name__c, Start_Day_of_Submission__c, End_Day_of_Submission__c, 
                        Sales_Org__r.Sales_Org_code__c  
                        FROM Sales_Forecast_Setting__c WHERE Sales_Org__r.Sales_Org_code__c =: salesOrg_Code 
                        ORDER BY LastModifiedDate LIMIT 1];

                if(sfs != null){
                    mnthName = sfs.Active_Forecast_Month__c;
                }
            }
            
        }
        catch(Exception ex){
            system.debug('Exception in getActiveMonth method ');
            system.debug('Exception is - ' + ex);
            system.debug('Exception at Line no  - ' + ex.getLineNumber());
        }

        return mnthName;
    }

    @AuraEnabled
    public static String createForecastManual(String accId, String terId, String yr) {
        /* system.debug('accId is - ' + accId);
        system.debug('terId is - ' + terId);
        system.debug('yr is - ' + yr); */

        String country ='';
        String salesOrg_Code = '';
        String msg = '';

        try{
            
            User user = [SELECT Id, Name, Country, State, Division, IsActive, UserType, Email, 
                        ManagerId FROM User where Id =: UserInfo.getUserId()];

           // system.debug('UserInfo.getUserId() ****' + UserInfo.getUserId());

            Login_Country__c logCntry = [SELECT Id, Name, For_Contry__c FROM Login_Country__c where Name =:user.Country limit 1];

            if(logCntry != null){
                country = logCntry.For_Contry__c;
            }

            if(country == 'Brazil'){
                salesOrg_Code = '5191';
            }

            if(salesOrg_Code != ''){
                Sales_Forecast_Setting__c sfs = new Sales_Forecast_Setting__c();
                sfs = [SELECT Id, Name, CurrencyIsoCode, Sales_Org__c, Sales_Agreement_Schedule_Frequency_Allow__c, 
                        Active_Forecast_Month__c, Schedule_Frequency_Allowed__c, Currency_Allowed__c, 
                        Start_Day_Of_Approval__c, End_Day_Of_Approval__c, Configuration_on_Sales_Forecast_Metric__c, 
                        Clone_the_existing_Forecast_Previous_mon__c, Create_a_forecast_based_on_the__c, 
                        Admin_Profile_Name__c, Start_Day_of_Submission__c, End_Day_of_Submission__c, 
                        Sales_Org__r.Sales_Org_code__c  
                        FROM Sales_Forecast_Setting__c WHERE Sales_Org__r.Sales_Org_code__c =: salesOrg_Code 
                        ORDER BY LastModifiedDate LIMIT 1];

                List<Forecast_Account__c> custRegList = new List<Forecast_Account__c>(); 
                custRegList = [SELECT Id, Name, Account__c, Territory__c, Territory__r.Region__c,
                                Account__r.SAP_Code__c, Territory__r.TerritoryCode__c, Territory__r.TerritoryManager__c, 
                                Territory__r.Region__r.RegionHead__c 
                                FROM Forecast_Account__c WHERE Account__c =: accId AND 
                                Territory__c =: terId];

                Map<String,String> monthMap = new Map<String,String>();
                monthMap.put('January','01');
                monthMap.put('February','02');
                monthMap.put('March','03');
                monthMap.put('April','04');
                monthMap.put('May','05');
                monthMap.put('June','06');
                monthMap.put('July','07');
                monthMap.put('August','08');
                monthMap.put('September','09');
                monthMap.put('October','10');
                monthMap.put('November','11');
                monthMap.put('December','12');  
                
                String mnth2 = monthMap.get(sfs.Active_Forecast_Month__c);

                SalesForeCastController.createSalesForeCast(custRegList[0].Account__c,custRegList[0].Territory__r.Region__c,custRegList[0].Account__r.SAP_Code__C,custRegList[0].Territory__r.TerritoryCode__c,custRegList[0].Territory__c,custRegList[0].Territory__r.TerritoryManager__c,mnth2,yr,sfs,'Manual',custRegList[0].Territory__r.Region__r.RegionHead__c);

                msg = 'Success';

                List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

                List<String> sendTo = new List<String>();
                sendTo.add(user.Email);
                mail.setToAddresses(sendTo);
                
                List<String> ccTo = new List<String>();
                ccTo.add('pedro.nery@upl-ltd.com');
                ccTo.add('rafael.chiavenato@upl-ltd.com');
                mail.setCcAddresses(ccTo);

                /* mail.setReplyTo('sirdavid@bankofnigeria.com');
                mail.setSenderDisplayName('Official Bank of Nigeria'); */
                String sub = 'Planejamento de Vendas : '+mnth2+'-'+yr;
                mail.setSubject(sub);

                String body = 'Caro usuário,<br></br><br></br> A criação do planejamento de vendas para o mês '+mnth2+'-'+yr+ ' está finalizada.  <br></br> <br></br> Atenciosamente,<br></br>Administração Salesforce UPL';

                mail.setHtmlBody(body);

                mails.add(mail);

                Messaging.sendEmail(mails);
            }
            else{
                msg = 'Failed';
            }

        }
        catch(Exception ex){
            msg = 'Failed';
            system.debug('Exception in createForecastManual method ');
            system.debug('Exception is - ' + ex);
            system.debug('Exception at Line no  - ' + ex.getLineNumber());
        }
        return msg;
    }
}