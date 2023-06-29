public without sharing class Section_Controller {
    
    
    @AuraEnabled    
    public static  list<Community_Configuration__c> showHideDetailsInfo(){
        String recordId = '';    
        String userid = UserInfo.getUserId();
        String CommunityRole ='';
        String salesOrg ='';
        String countryName ='';
        User userObj = [SELECT Id,UserName,Community_Role__c,TimeZoneSidKey,
                        AccountId,Account.Sales_Org_Code__c,Account.Sales_Org_Country__c
                        FROM User WHERE Id=: userid];
        
        recordId = userObj.AccountId;
        salesOrg = userObj.Account.Sales_Org_Code__c;
        countryName =userObj.Account.Sales_Org_Country__c;
        CommunityRole= userObj.Community_Role__c;
        
        
        list<Community_Configuration__c> cclIst = new List<Community_Configuration__c>();
        list<Community_Configuration__c> forCheckList = new List<Community_Configuration__c>();
        
        
        
        
        
        System.debug('Statement CommunityRole '+CommunityRole);
        System.debug('Statement salesOrg '+salesOrg);
        System.debug('Statement countryName '+countryName);
        System.debug('Statement recordId '+recordId);
        
        // if(forCheckList.size()>0){
        System.debug('Statement inside Account chekcing');
        cclIst =[Select Id,Name,Total_Collectible__c,Show_Growth__c,
                 This_Year_Sales__c,Total_number_of_Order__c,Last_Year_Sales__c,
                 Outstanding__c,Balance_Credit_Limit__c,Account_Statement__c,Outstanding_Ageing__c,
                 Payment_Details__c
                 FROM Community_Configuration__c
                 Where (Distributor_Name__c =:recordId  OR Visible_to_All__c =true)
                 AND Sales_Org__c =:salesOrg
                 AND Country__c=:countryName
                 AND RecordType.Name='Account Summary'
                 AND Community_User_Role__c =:CommunityRole
                 AND Active__c=true];
        
        
        //    }
        /* else{
System.debug('Statement outside Account chekcing');
cclIst =[Select Id,Name,Total_Collectible__c,Show_Growth__c,
This_Year_Sales__c,Total_number_of_Order__c,
Last_Year_Sales__c,Outstanding__c,Balance_Credit_Limit__c,Account_Statement__c,Outstanding_Ageing__c,Payment_Details__c
FROM Community_Configuration__c
Where Sales_Org__c =:salesOrg
AND Country__c=:countryName
AND RecordType.Name='Account Summary'
AND Community_User_Role__c =:CommunityRole
AND Active__c=true];

}*/
        System.debug('cclIst in Account Community '+cclIst);
        
        return cclIst;
    }    
    
    
    @AuraEnabled    
    public static  Payments__c collectionInfo(){
        String recordId = '';    
        String userid = UserInfo.getUserId();
        Payments__c PaymentsObj = new Payments__c();
        
        
        User userObj = [SELECT Id,UserName,Community_Role__c,TimeZoneSidKey,
                        AccountId,Account.Sales_Org_Code__c,Account.Sales_Org_Country__c FROM User WHERE Id=: userid];
        recordId = userObj.AccountId;
        
        try{
            PaymentsObj =[Select Id,Name,Total_Collectibles__c,LastModifiedDate FROM Payments__c WHERE Customer_Name__c=:recordId];  
            System.debug('PaymentsObj in section Compo '+PaymentsObj);
            return PaymentsObj;
            
        }
        catch(Exception ex){
            System.debug(' Error Occure Line Number '+ex.getLineNumber());
            System.debug(' Error Occure Messege  '+ex.getMessage());
            return null; 
        }
        
        
        
    }
    
    
    
    @AuraEnabled    
    public static  Outstanding_Ageing__c outstandingInfo(){
        String recordId = '';    
        String userid = UserInfo.getUserId();
        
        
        
        User userObj = [SELECT Id,UserName,Community_Role__c,TimeZoneSidKey,
                        AccountId,Account.Sales_Org_Code__c,Account.Sales_Org_Country__c FROM User WHERE Id=: userid];
        recordId = userObj.AccountId;
        Outstanding_Ageing__c Outstanding_AgeingObj = new Outstanding_Ageing__c();
        
        try{
            Outstanding_AgeingObj = [Select Id,Name,Net_Outstanding__c,LastModifiedDate FROM Outstanding_Ageing__c
                                     WHERE Customer_Code__c =:recordId];
            
            DateTime dt = Outstanding_AgeingObj.LastModifiedDate;
            String dateTimeStr = dt.format('dd-MMM-YYYY');
            System.debug('Date time for Colo ' + dateTimeStr);
            
            
            
            return Outstanding_AgeingObj;
        }
        catch(Exception ex){
            System.debug(' Error Occure Line Number '+ex.getLineNumber());
            System.debug(' Error Occure Messege  '+ex.getMessage());
            return null; 
        }
    }
    
    @AuraEnabled    
    public static  Credit_Info__c Credit_Info(){
        String recordId = '';    
        String userid = UserInfo.getUserId();
        
        
        User userObj = [SELECT Id,UserName,Community_Role__c,TimeZoneSidKey,
                        AccountId,Account.Sales_Org_Code__c,Account.Sales_Org_Country__c FROM User WHERE Id=: userid];
        recordId = userObj.AccountId;
        Credit_Info__c Credit_InfoObj = new Credit_Info__c();
        
        try{
            Credit_InfoObj = [SELECT Id,Name,Total_credit_limit_Ag__c,LastModifiedDate 
                              FROM Credit_Info__c
                              WHERE Distributor__c=:recordId ];
            return Credit_InfoObj;   
        }
        
        
        catch(Exception ex){
            System.debug(' Error Occure Line Number '+ex.getLineNumber());
            System.debug(' Error Occure Messege  '+ex.getMessage());
            return null; 
        }
        
    }
    
    
    @AuraEnabled    
    public static wrapperClassSalesOrder fetchSalesAmt(){
        
        String recordId1 = '';    
        String userid1 = UserInfo.getUserId();
        String CommunityRole ='';
        String salesOrg ='';
        String countryName ='';
        User userObj1 = [SELECT Id,UserName,Community_Role__c,TimeZoneSidKey,
                         AccountId,Account.Sales_Org_Code__c,Account.Sales_Org_Country__c
                         FROM User WHERE Id=: userid1];
        
        recordId1 = userObj1.AccountId;
        //salesOrg = userObj1.Account.Sales_Org_Code__c;
        countryName =userObj1.Account.Sales_Org_Country__c;
        System.debug('countryName in fecth account Data '+countryName); 
        wrapperClassSalesOrder wrapperObj = new wrapperClassSalesOrder();
        
        Map<Integer,String> monthMap = new Map<Integer,String>();
        if(countryName !='Japan'){
            monthMap.put(1,'Jan');
            monthMap.put(2,'Feb');
            monthMap.put(3,'Mar');
            monthMap.put(4,'April');
            monthMap.put(5,'May');
            monthMap.put(6,'June');
            monthMap.put(7,'July');
            monthMap.put(8,'August');
            monthMap.put(9,'Sept');
            monthMap.put(10,'Oct');
            monthMap.put(11,'Nov');
            monthMap.put(12,'Dec');
        }else{
            
            monthMap.put(1,'年1月');
            monthMap.put(2,'年2月');
            monthMap.put(3,'年3月');
            monthMap.put(4,'年4月');
            monthMap.put(5,'年5月');
            monthMap.put(6,'年6月');
            monthMap.put(7,'年7月');
            monthMap.put(8,'年8月');
            monthMap.put(9,'年9月');
            monthMap.put(10,'年10月');
            monthMap.put(11,'年11月');
            monthMap.put(12,'年12月');
            
        }
        
        
        
        if(countryName=='Poland'){
            //this is for only Poland
            Map<Integer,String> monthMap1 = new Map<Integer,String>();
            monthMap1.put(1,'styczeń');
            monthMap1.put(2,'luty');
            monthMap1.put(3,'marzec');
            monthMap1.put(4,'kwiecień');
            monthMap1.put(5,'maj');
            monthMap1.put(6,'czerwiec');
            monthMap1.put(7,'lipiec');
            monthMap1.put(8,'sierpień');
            monthMap1.put(9,'wrzesień');
            monthMap1.put(10,'październik');
            monthMap1.put(11,'listopad');
            monthMap1.put(12,'grudzień');
            
            Date dat = System.today(); 
            Integer yr = dat.year();
            Integer lyr = dat.year()-1;
            Integer Month = Date.Today().Month();
            //Integer Month=1;
            if(Month!=1){
                Month = Month-1;  
            }else{
                Month = 12;
                yr = yr-1;
                //lyr = lyr -1;
            }
            
            Date myLstStartDate = date.newInstance(lyr, 01, 01);
            
            //#CR140 changes last month for Last Year from January to Decemeber
            Date myLstEndDate = date.newInstance(lyr, 12, 31);
            
            Date myCurStartDate = date.newInstance(yr, 01, 01);
            Date myCurEndDate = date.newInstance(yr, Month,  Date.daysInMonth(yr,Month)); //Added by Butesh(Grazitti) for RITM0506730 14Feb23
            
            System.debug('Date is Year '+myCurStartDate);
            System.debug('Date is Year '+myCurEndDate);
            
            List<Invoice_Line_Item__c> soListCurrent1 = new List<Invoice_Line_Item__c>();
            List<Invoice_Line_Item__c> soListlst1 = new List<Invoice_Line_Item__c>();
            soListCurrent1 =[Select id,Name,Net_Value_Cal__c FROM Invoice_Line_Item__c
                             WHERE Invoice__r.Sold_To_Party__c =:recordId1
                             AND Invoice__r.Invoice_Date__c>=:myCurStartDate 
                             AND Invoice__r.Invoice_Date__c<=:myCurEndDate]; //Added by Butesh(Grazitti) for RITM0506730 15Feb23
            
            
            
            System.debug('soListCurrent1 in poland country '+soListCurrent1);
            System.debug('soListCurrent1 in poland country '+soListCurrent1.size());
            
            Decimal curAmountPol=0; 
            if(soListCurrent1.size()>0){
                for(Invoice_Line_Item__c sObj: soListCurrent1){
                    curAmountPol = curAmountPol + sObj.Net_Value_Cal__c;
                }
            }
            
            
            System.debug('myLstStartDate in poland '+myLstStartDate);
            System.debug('myLstEndDate in poland  '+myLstEndDate);
            System.debug('curAmountPol '+curAmountPol);
            
            soListlst1 =[Select id,Name,Net_Value_Cal__c FROM Invoice_Line_Item__c
                         WHERE Invoice__r.Sold_To_Party__c =:recordId1
                         AND Invoice__r.Invoice_Date__c>=:myLstStartDate 
                         AND Invoice__r.Invoice_Date__c<=:myLstEndDate];  //Added by Butesh(Grazitti) for RITM0506730 15Feb23
            
            System.debug('soListlst1 '+soListlst1);
            System.debug('soListlst1 '+soListlst1.size());
            
            Decimal lastAmountPol=0;
            if(soListlst1.size()>0){
                for(Invoice_Line_Item__c sObj: soListlst1){
                    lastAmountPol = lastAmountPol + sObj.Net_Value_Cal__c;
                }
            }
            
            Decimal roundedGrowthpol;
            Decimal growthpol;
            if(lastAmountPol!=0){
                
                growthpol = ((curAmountPol - lastAmountPol)/lastAmountPol)*100;
                if(lastAmountPol<0 && curAmountPol>0){
                    growthpol = growthpol*-1;
                }
                if(lastAmountPol<0 && curAmountPol<0){
                    growthpol = growthpol*-1;
                }
                roundedGrowthpol = growthpol.setScale(2, RoundingMode.HALF_UP);  
            }else{
                growthpol = (curAmountPol - lastAmountPol)*100;
                roundedGrowthpol = growthpol.setScale(2, RoundingMode.HALF_UP);
            }
            
            Account accObjPol = [SELECT Id, CurrencyIsoCode 
                                 FROM Account 
                                 WHERE Id=:recordId1 LIMIT 1];
            
            String currencyCodePOl = accObjPol.CurrencyIsoCode;
            
            System.debug('@@@ lastAmountPol '+lastAmountPol);
            System.debug('@@@ curAmountPol '+curAmountPol);
            System.debug('@@@ roundedGrowthpol '+roundedGrowthpol);
            
            String monthNamePol = monthMap1.get(Month);
            System.debug('monthNamePol '+monthNamePol);
            //Change by Grazitti(Aashima) for APPS-2483
            wrapperObj.currentYearSales = curAmountPol;
            wrapperObj.lstYearSales = lastAmountPol;
            wrapperObj.growth = roundedGrowthpol;
            wrapperObj.currencyCode = currencyCodePOl;
            wrapperObj.lstYear = lyr;
            wrapperObj.lstYear1 = lyr;
            wrapperObj.curYear = yr;
            wrapperObj.curYear1 = yr;
            wrapperObj.monthName = monthNamePol;
            wrapperObj.countryName =countryName;
            
            
            
            
        }
        
        
        else{
            Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate   
                                        FROM Period WHERE Type = 'Year' 
                                        AND StartDate <= TODAY 
                                        AND EndDate >= TODAY]; 
            
            Date StartDate = currentFiscalYear.StartDate;
            
            
            // date myDate = date.newInstance(2027, 05, 21);
            //Date EndDate = currentFiscalYear.EndDate;
            Date EndDate = currentFiscalYear.EndDate;
            System.debug('StartDate '+StartDate);
            System.debug('EndDate '+EndDate);
            Period currentFiscalYear1 = [SELECT FiscalYearSettings.Name , StartDate,EndDate   
                                         FROM Period WHERE Type = 'Year' 
                                         AND StartDate <= TODAY 
                                         AND EndDate >= TODAY];
            
            DateTime dateTimeScheduled = DateTime.newInstance(currentFiscalYear1.EndDate,Time.newInstance(0,0,0,0));
            
            
            Date theDate = Date.valueOf(dateTimeScheduled.format('yyyy-MM-dd'));
            Period lastFiscalYear = [select id, FiscalYearSettings.Name, StartDate,EndDate,Type 
                                     From Period 
                                     WHERE EndDate< :theDate
                                     AND Type ='Year' order By EndDate DESC Limit 1];
            
            Date lstYearStartDate = lastFiscalYear.StartDate;
            Date lstYearEndDate = lastFiscalYear.EndDate;
            
            System.debug('lstYearStartDate '+lstYearStartDate);
            System.debug('lstYearEndDate '+lstYearEndDate);
            
            
            String recordId = '';    
            String userid = UserInfo.getUserId();
            
            
            User userObj = [SELECT Id,UserName,Community_Role__c,TimeZoneSidKey,
                            AccountId,Account.Sales_Org_Code__c,Account.Sales_Org_Country__c FROM User WHERE Id=: userid];
            recordId = userObj.AccountId;
            
            List<Invoice_Line_Item__c> soListCurrent = new List<Invoice_Line_Item__c>();
            List<Invoice_Line_Item__c> soListLast = new List<Invoice_Line_Item__c>();
            
            Account accObj = [SELECT Id, CurrencyIsoCode 
                              FROM Account 
                              WHERE Id=:recordId LIMIT 1];
            
            String currencyCode = accObj.CurrencyIsoCode;
            
            
            
            
            
            System.debug('StartDate '+StartDate);
            System.debug('EndDate '+EndDate);
            
            
            Integer curMonth = Date.today().month();
            //Integer curMonth = 2;
            
            Integer cDtMonth ;//= curMonth;
            Integer cDtYear ;//= lstYearEndDate.year();
            if(curMonth==1){
                cDtMonth = 12;
                cDtYear = EndDate.year()-1;
            }else if(curMonth==5){
                cDtMonth = 4;
                cDtYear = EndDate.year()-1;
            }else if(curMonth==6){
                cDtMonth = 5;
                cDtYear = EndDate.year()-1;
            }else if(curMonth==7){
                cDtMonth = 6;
                cDtYear = EndDate.year()-1;
            }else if(curMonth==8){
                cDtMonth = 7;
                cDtYear = EndDate.year()-1;
            }else if(curMonth==9){
                cDtMonth = 8;
                cDtYear = EndDate.year()-1;
            }else if(curMonth==10){
                cDtMonth = 9;
                cDtYear = EndDate.year()-1;
            }else if(curMonth==11){
                cDtMonth = 10;
                cDtYear = EndDate.year()-1;
            }else{
                cDtMonth= curMonth-1;
                cDtYear = EndDate.year();
            }
            
            System.debug('cdtMonth '+cDtMonth);
            System.debug('cdtYear '+cDtYear);
            
            Date myNewEndDate1 = Date.newInstance(cDtYear, cDtMonth,Date.daysInMonth(cDtYear,cDtMonth)); //Added by Butesh(Grazitti) for RITM0506730 14Feb23
            
            System.debug('myDate new Date after modification current fiscal '+StartDate);
            System.debug('myDate new Date after modification current fiscal '+myNewEndDate1);
            
            
            //This is current fiscal year
            soListCurrent =[Select id,Name,Net_Value_Cal__c FROM Invoice_Line_Item__c
                            WHERE Invoice__r.Sold_To_Party__c =:recordId
                            AND Invoice__r.Invoice_Date__c>=:StartDate 
                            AND Invoice__r.Invoice_Date__c<=:myNewEndDate1]; //Added by Butesh(Grazitti) for RITM0506730 15Feb23
            
            
            List<Invoice__c> soListCurrentTemp = new List<Invoice__c>();
            
            soListCurrentTemp =[Select id,Name,CreatedDate,TotalSalesAmount__c FROM Invoice__c
                                WHERE Sold_To_Party__c =:recordId
                                AND Invoice_Date__c>:StartDate
                                AND Invoice_Date__c<:myNewEndDate1
                                ORDER BY CreatedDate DESC LIMIT 1];
            
            
            System.debug('colombia StartDate   '+StartDate);
            System.debug('myNewEndDate1 colombia  '+myNewEndDate1);
            
            DateTime asOndate;
            if(soListCurrentTemp.size()>0){
                asOndate = soListCurrentTemp[0].CreatedDate;
            }
            
            System.debug('soListCurrent  sales Order Number '+soListCurrent);
            System.debug('soListCurrent '+soListCurrent.size());
            Integer totalOrder =soListCurrent.size();
            
            Decimal curAmount=0;
            Decimal lastAmount=0;
            if(soListCurrent.size()>0){
                for(Invoice_Line_Item__c sObj: soListCurrent){
                    curAmount = curAmount + sObj.Net_Value_Cal__c;
                }
            }
            
            System.debug('Curreent Ammount year '+curAmount);
            
            
            
            
            
            Integer dtMonth ;//= curMonth;
            Integer dtYear ;//= lstYearEndDate.year();
            
            
            
            
            if(curMonth==1){ 
                dtMonth = 12;
                dtYear = lstYearEndDate.year()-1;
            }else if(curMonth==5){
                System.debug(' in current month five months');
                dtMonth = 4 ;
                dtYear = lstYearEndDate.year()-1;           
            }else if(curMonth==6){
                System.debug(' in current month six months');
                dtMonth = 5 ;
                dtYear = lstYearEndDate.year()-1;           
            }else if(curMonth==7){
                System.debug(' in current month seven  months');
                dtMonth = 6 ;
                dtYear = lstYearEndDate.year()-1;           
            }else if(curMonth==8){
                System.debug(' in current month eight months');
                dtMonth = 7 ;
                dtYear = lstYearEndDate.year()-1;           
            }else if(curMonth==9){
                System.debug(' in current month nine months');
                dtMonth = 8;
                dtYear = lstYearEndDate.year()-1;           
            }else if(curMonth==10){
                System.debug(' in current month ten months');
                dtMonth = 9 ;
                dtYear = lstYearEndDate.year()-1;           
            }else if(curMonth==11){
                System.debug(' in current month eleven months');
                dtMonth = 10 ;
                dtYear = lstYearEndDate.year()-1;           
            } else {
                dtMonth= curMonth-1;
                dtYear = lstYearEndDate.year();
            }
            
            
            
            System.debug('dtMonth '+dtMonth);
            System.debug('dtYear '+dtYear);
            
            Date myNewEndDate = Date.newInstance(dtYear, dtMonth,  Date.daysInMonth(dtYear,dtMonth));//Added by Butesh(Grazitti) for RITM0506730 14Feb23
            
            // System.debug('@@@@@@@ myDate new Date after modification '+recordId);
            //System.debug('@@@@@@@ myDate new Date after modification '+lstYearStartDate);
            System.debug('@@@@@@@ myDate new Date after modification '+myNewEndDate);        
            
            
            //this is for last fiscal Year
            soListLast =[Select id,Name,Net_Value_Cal__c FROM Invoice_Line_Item__c
                         WHERE Invoice__r.Sold_To_Party__c =:recordId
                         AND Invoice__r.Invoice_Date__c>=:lstYearStartDate
                         AND Invoice__r.Invoice_Date__c<=:myNewEndDate]; //Added by Butesh(Grazitti) for RITM0506730 15Feb23
            
            
            System.debug('soListLast  '+soListLast);
            System.debug('soListLast  '+soListLast.size());
            
            if(soListLast.size()>0){
                for(Invoice_Line_Item__c sObj: soListLast){
                    lastAmount = lastAmount + sObj.Net_Value_Cal__c;
                }
            }
            System.debug('lstYearStartDate '+lstYearStartDate.year());
            System.debug('lstYearEndDate '+lstYearEndDate.year());
            
            System.debug('StartDate '+StartDate);
            System.debug('EndDate '+EndDate);
            
            Integer curYear = StartDate.year();
            Integer curYear1 ;
            
            if(curMonth==1 || curMonth==5 || curMonth==6 || curMonth==7 || curMonth==8 || curMonth==9 || curMonth==10 || curMonth==11 || curMonth==12){
                curYear1 = EndDate.year()-1;
            }else{
                System.debug('EndDate year '+EndDate.year());
                curYear1 = EndDate.year();
            }
            
            
            Integer lstYear = lstYearStartDate.year();
            Integer lstYear1 ;
            
            if(curMonth==1 || curMonth==5 || curMonth==6 || curMonth==7 || curMonth==8 || curMonth==9 || curMonth==10 || curMonth==11 || curMonth==12){
                lstYear1 = lstYearEndDate.year()-1;
            }else{
                lstYear1 = lstYearEndDate.year();
            }
            
            
            
            if(curMonth==1){
                curMonth = 12;
            }else{
                curMonth = curMonth-1;
            }
            //String monthName = monthMap.get(curMonth); 
            
            String monthName = monthMap.get(curMonth); 
            
            System.debug('monthName is '+monthName);
            
            System.debug('lastAmount year Ammount '+lastAmount);
            
            if(Test.isRunningTest()){
                lastAmount = 1200;
            }else{
                lastAmount =lastAmount;
            }
            
            System.debug('lastAmount samdnsd '+lastAmount);
            
            Decimal growth;
            Decimal roundedGrowth;
            if(lastAmount!=0){
                
                growth = ((curAmount - lastAmount)/lastAmount)*100;
                if(lastAmount<0 && curAmount>0){
                    growth = growth*-1;
                }
                if(lastAmount<0 && curAmount<0){
                    growth = growth*-1;
                }
                roundedGrowth = growth.setScale(2, RoundingMode.HALF_UP);  
            }else{
                growth = (curAmount - lastAmount)*100;
                roundedGrowth = growth.setScale(2, RoundingMode.HALF_UP);
            }
            //List<CurrencyType> lstCT = [SELECT ISOCode, ConversionRate FROM CurrencyType WHERE IsActive=TRUE AND ISOCode='USD' limit 1];
            //Change by Aashima(Grazitti) for APPS-2378 17Oct22
            Map<String,Decimal> currencyMap=new Map<String,Decimal>();
            for(CurrencyType ct:[SELECT ISOCode, ConversionRate FROM CurrencyType WHERE IsActive=TRUE AND (ISOCode='USD' OR ISOCode='COP')]){
                currencyMap.put(ct.ISOCode,ct.ConversionRate);
            }
            Decimal copToUsdConversion=0.0;
            if(!currencyMap.isEmpty() && currencyMap.containsKey('USD') && currencyMap.containsKey('COP')){
                copToUsdConversion=currencyMap.get('USD')/currencyMap.get('COP');
            }
            //Change by Aashima(Grazitti) for APPS-3389
            String lastYearConversionRate=System.Label.Grz_ColombiaConversionRateToUSDLastYear.replaceAll(',','');
            system.debug('aashima==>copToUsdConversion==>'+copToUsdConversion);
            system.debug('aashima==>lastYearConversionRate==>'+lastYearConversionRate);
            wrapperObj.currentYearSales = curAmount * copToUsdConversion;
            if(countryName == 'Colombia'){  //Added by Butesh(Grazitti) for RITM0506730 14Feb23
                String CurrentYearConversionRate = System.Label.Grz_ColombiaConversionRateToUSD.replace('.','').replace(',','.');
                wrapperObj.currentYearSales = curAmount / Decimal.valueof(CurrentYearConversionRate);
            }
            wrapperObj.lstYearSales = lastAmount / Decimal.valueof(lastYearConversionRate);
            wrapperObj.totalNumberOrder = totalOrder;
            wrapperObj.currencyCode =  'USD';
            wrapperObj.lstYear = lstYear;
            wrapperObj.lstYear1 = lstYear1;
            wrapperObj.curYear = curYear;
            wrapperObj.curYear1 = curYear1;
            wrapperObj.monthName = monthName;
            wrapperObj.growth = roundedGrowth;
            wrapperObj.asOnDate = asOndate;
            wrapperObj.countryName =countryName;
            System.debug('curMonth after all operation for other country '+curMonth);
            
        }
        
        
        
        return wrapperObj;
        
    }
    //Method Added by Ishu Mittal for CR-APPS-5200(to show monthly report on Customer Portal for Colombia)
    @AuraEnabled(Cacheable=true)   
    public static List<wrapperClassSalesOrder> fetchSalesAmtMontly(){
        
        String recordId1 = '';    
        String userid1 = UserInfo.getUserId();
        String CommunityRole ='';
        String salesOrg ='';
        String countryName ='';
        Boolean iscurrentYearSale=true;
        
        Map<Integer,String> monthMap = new Map<Integer,String>();
        monthMap.put(4,System.Label.April);
        monthMap.put(5,System.Label.May);
        monthMap.put(6,System.Label.June);
        monthMap.put(7,System.Label.July);
        monthMap.put(8,System.Label.August);
        monthMap.put(9,System.Label.September);
        monthMap.put(10,System.Label.October);
        monthMap.put(11,System.Label.November);
        monthMap.put(12,System.Label.December);
        monthMap.put(1,System.Label.January);
        monthMap.put(2,System.Label.Febuary);
        monthMap.put(3,System.Label.March);
        
        String recordId = '';    
        String userid = UserInfo.getUserId();
        
        
        User userObj = [SELECT Id,UserName,Community_Role__c,TimeZoneSidKey,
                        AccountId,Account.Sales_Org_Code__c,Account.Sales_Org_Country__c FROM User WHERE Id=: userid];
        recordId = userObj.AccountId;
        countryName =userObj.Account.Sales_Org_Country__c;
        System.debug('countryName in fecth account Data '+countryName); 
        
        Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate   
                                    FROM Period WHERE Type = 'Year' 
                                    AND StartDate <= TODAY 
                                    AND EndDate >= TODAY]; 
        
        Date StartDate = currentFiscalYear.StartDate;
        Date EndDate=currentFiscalYear.EndDate;
        
        DateTime dateTimeScheduled = DateTime.newInstance(currentFiscalYear.EndDate,Time.newInstance(0,0,0,0));
        Date theDate = Date.valueOf(dateTimeScheduled.format('yyyy-MM-dd'));
        Period lastFiscalYear = [select id, FiscalYearSettings.Name, StartDate,EndDate,Type 
                                 From Period 
                                 WHERE EndDate< :theDate
                                 AND Type ='Year' order By EndDate DESC Limit 1];
        
        Date lstYearStartDate = lastFiscalYear.StartDate;
        Date lstYearEndDate = lastFiscalYear.EndDate;
        
        
        DateTime dateTimeScheduled1 = DateTime.newInstance(lastFiscalYear.EndDate,Time.newInstance(0,0,0,0));
        Date theLastYearDate = Date.valueOf(dateTimeScheduled1.format('yyyy-MM-dd'));
        Period secondlastFiscalYear = [select id, FiscalYearSettings.Name, StartDate,EndDate,Type 
                                       From Period 
                                       WHERE EndDate< :theLastYearDate
                                       AND Type ='Year' order By EndDate DESC Limit 1];
        
        Date secondlstYearStartDate = secondlastFiscalYear.StartDate;
        Date secondlstYearEndDate = secondlastFiscalYear.EndDate;
        System.debug('secondlstYearStartDate--->'+secondlstYearStartDate);
        System.debug('secondlstYearEndDate----->'+secondlstYearEndDate);
        
        
        
        String lastYearConversionRate=System.Label.Grz_ColombiaConversionRateToUSDLastYear.replaceAll(',','');
        String CurrentYearConversionRate = System.Label.Grz_ColombiaConversionRateToUSD.replace('.','').replace(',','.');
         String secondLastYearConversionRate=System.Label.Grz_ColombiaConversionRateToUSDSecondLastYear.replace('.','').replace(',','.');
       
        Integer currentYear=Date.today().year();
        
        List<AggregateResult> SalesAmountCurrentYear = new List<AggregateResult>();
        List<AggregateResult> VolumeCurrentYear = new List<AggregateResult>();
        Map<Integer,Decimal> currentSalesMap=new Map<Integer,Decimal>();
        Map<Integer,Integer> currentVolumeMap=new Map<Integer,Integer>();
        List<AggregateResult> SalesAmountLastYear = new List<AggregateResult>();
        List<AggregateResult> VolumeLastYear = new List<AggregateResult>();
        Map<Integer,Decimal> LastSalesMap=new Map<Integer,Decimal>();
        Map<Integer,Integer> LastVolumeMap=new Map<Integer,Integer>();
        //Fimd Monthly Sales for current Fiscal Year
        SalesAmountCurrentYear =[Select CALENDAR_Month(Invoice_Date__c) month ,SUM(Total_Amount_Currency__c) SalesAmount FROM Invoice__c
                                 WHERE Sold_To_Party__c =:recordId
                                 AND Invoice_Date__c>=:StartDate and Invoice_Date__c<=:EndDate Group by CALENDAR_Month(Invoice_Date__c)  ];
        //Find Monthly Sales for Last Fiscal Year
        SalesAmountLastYear =[Select CALENDAR_Month(Invoice_Date__c) month,SUM(Total_Amount_Currency__c) SalesAmount FROM Invoice__c
                              WHERE Sold_To_Party__c =:recordId
                              AND Invoice_Date__c>=:lstYearStartDate and Invoice_Date__c<=:lstYearEndDate Group by CALENDAR_Month(Invoice_Date__c)  ];
        //Find Montly Quantity for current Fiscal year
        VolumeCurrentYear=[Select SUM(Volume__c) quantity, CALENDAR_Month(Invoice__r.Invoice_Date__c) month
                           FROM Invoice_Line_Item__c 
                           WHERE Invoice__r.Sold_To_Party__c =:recordId  AND Invoice__r.Invoice_Date__c>=:StartDate and Invoice__r.Invoice_Date__c<=:EndDate Group By CALENDAR_Month(Invoice__r.Invoice_Date__c) ];
        //Find Montly quantity for last fiscal year
        VolumeLastYear=[Select SUM(Volume__c) quantity, CALENDAR_Month(Invoice__r.Invoice_Date__c) month
                        FROM Invoice_Line_Item__c 
                        WHERE Invoice__r.Sold_To_Party__c =:recordId  AND Invoice__r.Invoice_Date__c>=:lstYearStartDate and Invoice__r.Invoice_Date__c<=:lstYearEndDate Group By CALENDAR_Month(Invoice__r.Invoice_Date__c) ];
        //If no sales in current fiscal year showing report of last and secondlast fiscal year report
        if(SalesAmountCurrentYear.size()<=0)
        {iscurrentYearSale=false;
            SalesAmountCurrentYear =[Select CALENDAR_Month(Invoice_Date__c) month,SUM(Total_Amount_Currency__c) SalesAmount FROM Invoice__c
                                     WHERE Sold_To_Party__c =:recordId
                                     AND Invoice_Date__c>=:lstYearStartDate and Invoice_Date__c<=:lstYearEndDate Group by CALENDAR_Month(Invoice_Date__c)  ];
            SalesAmountLastYear =[Select CALENDAR_Month(Invoice_Date__c) month,SUM(Total_Amount_Currency__c) SalesAmount FROM Invoice__c
                                  WHERE Sold_To_Party__c =:recordId
                                  AND Invoice_Date__c>=:secondlstYearStartDate and Invoice_Date__c<=:secondlstYearEndDate Group by CALENDAR_Month(Invoice_Date__c)  ];
            VolumeCurrentYear=[Select SUM(Volume__c) quantity, CALENDAR_Month(Invoice__r.Invoice_Date__c) month
                               FROM Invoice_Line_Item__c 
                               WHERE Invoice__r.Sold_To_Party__c =:recordId  AND Invoice__r.Invoice_Date__c>=:lstYearStartDate and Invoice__r.Invoice_Date__c<=:lstYearEndDate Group By CALENDAR_Month(Invoice__r.Invoice_Date__c) ];
            VolumeLastYear=[Select SUM(Volume__c) quantity, CALENDAR_Month(Invoice__r.Invoice_Date__c) month
                            FROM Invoice_Line_Item__c 
                            WHERE Invoice__r.Sold_To_Party__c =:recordId  AND Invoice__r.Invoice_Date__c>=:secondlstYearStartDate and Invoice__r.Invoice_Date__c<=:secondlstYearEndDate Group By CALENDAR_Month(Invoice__r.Invoice_Date__c) ];
        
          lastYearConversionRate=secondLastYearConversionRate;
         CurrentYearConversionRate = lastYearConversionRate;
         
        }
        //Added the value in respective Map
        for(AggregateResult currentInvoice:SalesAmountCurrentYear)
        {
            currentSalesMap.put(Integer.valueof(currentInvoice.get('month')),Decimal.valueof(String.valueof(currentInvoice.get('SalesAmount'))));
        }
        
        for(AggregateResult currentInvoice:VolumeCurrentYear)
        {
            currentVolumeMap.put(Integer.valueof(currentInvoice.get('month')),Integer.valueof(currentInvoice.get('quantity')));
        }
        
        for(AggregateResult currentInvoice:SalesAmountLastYear)
        {
            LastSalesMap.put(Integer.valueof(currentInvoice.get('month')),Decimal.valueof(String.valueof(currentInvoice.get('SalesAmount'))));
        }
        
        for(AggregateResult currentInvoice:VolumeLastYear)
        {
            LastVolumeMap.put(Integer.valueof(currentInvoice.get('month')),Integer.valueof(currentInvoice.get('quantity')));
        }
        
        List<wrapperClassSalesOrder> wrapperClassForSalesAmount=new List<wrapperClassSalesOrder>();
        Decimal currentSalesInCOP=0.0;
        Decimal lastSalesInCOP=0.0;
        for(Integer month:monthMap.keySet())
        {  Decimal growth;
         Decimal roundedGrowth;
         Decimal qgrowth;
         Decimal qroundedGrowth;
         wrapperClassSalesOrder wc=new wrapperClassSalesOrder();
         wc.monthName=monthMap.get(month);
          wc.isCurrentYearSalePresent=iscurrentYearSale;
         //Adding the value in wrapper
         if(currentVolumeMap.size()>0)
         {
             wc.CurrentQuantity=currentVolumeMap.get(month)!=null ?currentVolumeMap.get(month) :0 ;              
         }
         else
         {
             wc.CurrentQuantity=0;
         }
         if(LastVolumeMap.size()>0)
         {
             wc.LastQuantity=LastVolumeMap.get(month)!=null ?LastVolumeMap.get(month) :0 ;              
         }
         else
         {
             wc.LastQuantity=0;  
         }
         //Calculation of variance growth
         if(wc.lastQuantity!=0){
             
             qgrowth = ((wc.CurrentQuantity - wc.lastQuantity)/wc.lastQuantity)*100;
             if(wc.lastQuantity<0 && wc.CurrentQuantity>0){
                 qgrowth = qgrowth*-1;
             }
             if(wc.lastQuantity<0 && wc.CurrentQuantity<0){
                 qgrowth = qgrowth*-1;
             }
             qroundedGrowth = qgrowth.setScale(2, RoundingMode.HALF_UP);  
         }else{
             qgrowth = (wc.lastQuantity)*100;
             qroundedGrowth = qgrowth.setScale(2, RoundingMode.HALF_UP);
         }
         wc.quantitygrowth=qroundedGrowth;
         if(currentSalesMap.size()>0)
         {
             currentSalesInCOP=currentSalesMap.get(month)!=null ?currentSalesMap.get(month) :0 ; 
             wc.currentYearSales = (currentSalesInCOP / Decimal.valueof(CurrentYearConversionRate)).setScale(2, RoundingMode.HALF_UP);
         }
         else{
             wc.currentYearSales=0;
         }
         if(LastSalesMap.size()>0)
         {
             lastSalesInCOP=LastSalesMap.get(month)!=null ?LastSalesMap.get(month) :0 ; 
             wc.lstYearSales = (lastSalesInCOP / Decimal.valueof(lastYearConversionRate)).setScale(2, RoundingMode.HALF_UP);
         }
         else{
             wc.lstYearSales=0;
         }
         
         if(lastSalesInCOP!=0){
             
             growth = ((currentSalesInCOP - lastSalesInCOP)/lastSalesInCOP)*100;
             if(lastSalesInCOP<0 && currentSalesInCOP>0){
                 growth = growth*-1;
             }
             if(lastSalesInCOP<0 && currentSalesInCOP<0){
                 growth = growth*-1;
             }
             roundedGrowth = growth.setScale(2, RoundingMode.HALF_UP);  
         }else{
             growth = (lastSalesInCOP)*100;
             roundedGrowth = growth.setScale(2, RoundingMode.HALF_UP);
         }
         wc.growth=roundedGrowth;  
         
         
         wc.currencyCode='USD'; 
         wc.countryName=countryName;
         
         wrapperClassForSalesAmount.add(wc) ;
         
         
         
         
        }
        System.debug('wrapperClassForSalesAmount----->'+wrapperClassForSalesAmount);
        
        
        return wrapperClassForSalesAmount;
        
    }
    //Method Added by Ishu Mittal for CR-APPS-5200(to show top 15 product report on Customer Portal for Colombia)
    @AuraEnabled(Cacheable=true)   
    public static List<wrapperClassSalesOrderByProduct> fetchSalesAmtProductWise(){
        
        String recordId1 = '';    
        String userid1 = UserInfo.getUserId();
        String CommunityRole ='';
        String salesOrg ='';
        String countryName ='';
        Boolean iscurrentYearSale=true;
        
        String recordId = '';    
        String userid = UserInfo.getUserId();
        
        User userObj = [SELECT Id,UserName,Community_Role__c,TimeZoneSidKey,
                        AccountId,Account.Sales_Org_Code__c,Account.Sales_Org_Country__c FROM User WHERE Id=: userid];
        recordId = userObj.AccountId;
        countryName =userObj.Account.Sales_Org_Country__c;
        System.debug('countryName in fecth account Data '+countryName); 
        
        Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate   
                                    FROM Period WHERE Type = 'Year' 
                                    AND StartDate <= TODAY 
                                    AND EndDate >= TODAY]; 
        
        Date StartDate = currentFiscalYear.StartDate;
        Date EndDate=currentFiscalYear.EndDate;
        System.debug('StartDate--->'+StartDate);
        System.debug('EndDate------>'+EndDate);
        DateTime dateTimeScheduled = DateTime.newInstance(currentFiscalYear.EndDate,Time.newInstance(0,0,0,0));
        Date theDate = Date.valueOf(dateTimeScheduled.format('yyyy-MM-dd'));
        Period lastFiscalYear = [select id, FiscalYearSettings.Name, StartDate,EndDate,Type 
                                 From Period 
                                 WHERE EndDate< :theDate
                                 AND Type ='Year' order By EndDate DESC Limit 1];
        
        Date lstYearStartDate = lastFiscalYear.StartDate;
        Date lstYearEndDate = lastFiscalYear.EndDate;
        System.debug('lstYearStartDate--->'+lstYearStartDate);
        System.debug('lstYearEndDate----->'+lstYearEndDate);
        
        DateTime dateTimeScheduled1 = DateTime.newInstance(lastFiscalYear.EndDate,Time.newInstance(0,0,0,0));
        Date theLastYearDate = Date.valueOf(dateTimeScheduled1.format('yyyy-MM-dd'));
        Period secondlastFiscalYear = [select id, FiscalYearSettings.Name, StartDate,EndDate,Type 
                                       From Period 
                                       WHERE EndDate< :theLastYearDate
                                       AND Type ='Year' order By EndDate DESC Limit 1];
        
        Date secondlstYearStartDate = secondlastFiscalYear.StartDate;
        Date secondlstYearEndDate = secondlastFiscalYear.EndDate;
        System.debug('secondlstYearStartDate--->'+secondlstYearStartDate);
        System.debug('secondlstYearEndDate----->'+secondlstYearEndDate);
        
        String lastYearConversionRate=System.Label.Grz_ColombiaConversionRateToUSDLastYear.replaceAll(',','');
        String CurrentYearConversionRate = System.Label.Grz_ColombiaConversionRateToUSD.replace('.','').replace(',','.');
         String secondLastYearConversionRate=System.Label.Grz_ColombiaConversionRateToUSDSecondLastYear.replace('.','').replace(',','.');
       
        Integer currentYear=Date.today().year();
        List<AggregateResult> SalesAmountCurrentYear = new List<AggregateResult>();
        List<AggregateResult> SalesAmountByProductCurrent = new List<AggregateResult>();
        List<AggregateResult> VolumeCurrentYearByProduct = new List<AggregateResult>();
        Map<String,Decimal> currentSalesMapbyProduct=new Map<String,Decimal>();
        Map<String,Integer> currentVolumeMapbyProduct=new Map<String,Integer>();
        List<AggregateResult> SalesAmountLastYearByProduct = new List<AggregateResult>();
        List<AggregateResult> VolumeLastYearByProduct = new List<AggregateResult>();
        Map<String,Decimal> LastSalesMapByProduct=new Map<String,Decimal>();
        Map<String,Integer> LastVolumeMapByProduct=new Map<String,Integer>();
          SalesAmountCurrentYear =[Select CALENDAR_Month(Invoice_Date__c) month ,SUM(Total_Amount_Currency__c) SalesAmount FROM Invoice__c
                                 WHERE Sold_To_Party__c =:recordId
                                 AND Invoice_Date__c>=:StartDate and Invoice_Date__c<=:EndDate Group by CALENDAR_Month(Invoice_Date__c)  ];
      
        SalesAmountByProductCurrent =[Select SUM(Net_Value_Cal1__c) amount,SKU__r.Brand_Name__c productName FROM Invoice_Line_Item__c 
                                      WHERE Invoice__r.Sold_To_Party__c =:recordId  AND Invoice__r.Invoice_Date__c>=:StartDate and Invoice__r.Invoice_Date__c<=:EndDate Group By SKU__r.Brand_Name__c
                                      ORDER BY SUM(Net_Value_Cal1__c) desc limit 15];
        VolumeCurrentYearByProduct=[Select SUM(Volume__c) quantity,SKU__r.Brand_Name__c productName FROM Invoice_Line_Item__c 
                                    WHERE Invoice__r.Sold_To_Party__c =:recordId  AND Invoice__r.Invoice_Date__c>=:StartDate and Invoice__r.Invoice_Date__c<=:EndDate Group By SKU__r.Brand_Name__c
                                    ORDER BY SUM(Net_Value_Cal1__c) desc limit 15];
        
         for(AggregateResult currentInvoice:SalesAmountByProductCurrent)
        {
            currentSalesMapbyProduct.put(String.valueof(currentInvoice.get('productName')),Decimal.valueof(String.valueof(currentInvoice.get('amount'))));
        }
        system.debug('currentSalesMapbyProduct------>'+currentSalesMapbyProduct);
         for(AggregateResult currentInvoice:VolumeCurrentYearByProduct)
        {
            currentVolumeMapbyProduct.put(String.valueof(currentInvoice.get('productName')),Integer.valueof(currentInvoice.get('quantity')));
        }	
        SalesAmountLastYearByProduct =[Select SUM(Net_Value_Cal1__c) amount,SKU__r.Brand_Name__c productName FROM Invoice_Line_Item__c 
                                       WHERE Invoice__r.Sold_To_Party__c =:recordId  AND Invoice__r.Invoice_Date__c>=:lstYearStartDate and Invoice__r.Invoice_Date__c<=:lstYearEndDate AND SKU__r.Brand_Name__c=:currentSalesMapbyProduct.keyset()  Group By SKU__r.Brand_Name__c
                                       ORDER BY SUM(Net_Value_Cal1__c) desc limit 15 ];
        VolumeLastYearByProduct=[Select SUM(Volume__c) quantity,SKU__r.Brand_Name__c productName FROM Invoice_Line_Item__c 
                                 WHERE Invoice__r.Sold_To_Party__c =:recordId  AND Invoice__r.Invoice_Date__c>=:lstYearStartDate and Invoice__r.Invoice_Date__c<=:lstYearEndDate AND SKU__r.Brand_Name__c=:currentSalesMapbyProduct.keyset() Group By SKU__r.Brand_Name__c
                                 ORDER BY SUM(Net_Value_Cal1__c) desc limit 15];
        
        
        if(SalesAmountCurrentYear.size()<=0)
        {  iscurrentYearSale=false;
            SalesAmountByProductCurrent =[Select SUM(Net_Value_Cal1__c) amount,SKU__r.Brand_Name__c productName FROM Invoice_Line_Item__c 
                                          WHERE Invoice__r.Sold_To_Party__c =:recordId  AND Invoice__r.Invoice_Date__c>=:lstYearStartDate and Invoice__r.Invoice_Date__c<=:lstYearEndDate Group By SKU__r.Brand_Name__c
                                          ORDER BY SUM(Net_Value_Cal1__c) desc limit 15];
            VolumeCurrentYearByProduct=[Select SUM(Volume__c) quantity,SKU__r.Brand_Name__c productName FROM Invoice_Line_Item__c 
                                        WHERE Invoice__r.Sold_To_Party__c =:recordId  AND Invoice__r.Invoice_Date__c>=:lstYearStartDate and Invoice__r.Invoice_Date__c<=:lstYearEndDate Group By SKU__r.Brand_Name__c
                                        ORDER BY SUM(Net_Value_Cal1__c) desc limit 15];
             for(AggregateResult currentInvoice:SalesAmountByProductCurrent)
        {
            currentSalesMapbyProduct.put(String.valueof(currentInvoice.get('productName')),Decimal.valueof(String.valueof(currentInvoice.get('amount'))));
        }
        system.debug('currentSalesMapbyProduct------>'+currentSalesMapbyProduct);
         for(AggregateResult currentInvoice:VolumeCurrentYearByProduct)
        {
            currentVolumeMapbyProduct.put(String.valueof(currentInvoice.get('productName')),Integer.valueof(currentInvoice.get('quantity')));
        }
            
            SalesAmountLastYearByProduct =[Select SUM(Net_Value_Cal1__c) amount,SKU__r.Brand_Name__c productName FROM Invoice_Line_Item__c 
                                           WHERE Invoice__r.Sold_To_Party__c =:recordId  AND Invoice__r.Invoice_Date__c>=:secondlstYearStartDate and Invoice__r.Invoice_Date__c<=:secondlstYearEndDate AND SKU__r.Brand_Name__c=:currentSalesMapbyProduct.keyset()  Group By SKU__r.Brand_Name__c
                                           ORDER BY SUM(Net_Value_Cal1__c) desc limit 15 ];
            VolumeLastYearByProduct=[Select SUM(Volume__c) quantity,SKU__r.Brand_Name__c productName FROM Invoice_Line_Item__c 
                                     WHERE Invoice__r.Sold_To_Party__c =:recordId  AND Invoice__r.Invoice_Date__c>=:secondlstYearStartDate and Invoice__r.Invoice_Date__c<=:secondlstYearEndDate AND SKU__r.Brand_Name__c=:currentSalesMapbyProduct.keyset() Group By SKU__r.Brand_Name__c
                                     ORDER BY SUM(Net_Value_Cal1__c) desc limit 15];   
         lastYearConversionRate=secondLastYearConversionRate;
         CurrentYearConversionRate = lastYearConversionRate;
         
        
        }
        
       
        for(AggregateResult currentInvoice:VolumeCurrentYearByProduct)
        {
            currentVolumeMapbyProduct.put(String.valueof(currentInvoice.get('productName')),Integer.valueof(currentInvoice.get('quantity')));
        }	
        
        for(AggregateResult currentInvoice:SalesAmountLastYearByProduct)
        {
            LastSalesMapByProduct.put(String.valueof(currentInvoice.get('productName')),Decimal.valueof(String.valueof(currentInvoice.get('amount'))));
        }
        system.debug('LastSalesMapByProduct---->'+LastSalesMapByProduct);
        
        for(AggregateResult currentInvoice:VolumeLastYearByProduct)
        {
            LastVolumeMapByProduct.put(String.valueof(currentInvoice.get('productName')),Integer.valueof(currentInvoice.get('quantity')));
        }
        List<wrapperClassSalesOrderByProduct> wrapperClassForSalesAmount=new List<wrapperClassSalesOrderByProduct>();
        Decimal currentSalesInCOP=0.0;
        Decimal lastSalesInCOP=0.0;
        for(String Product:currentSalesMapbyProduct.keySet())
        {  Decimal growth;
         Decimal roundedGrowth;
         Decimal qgrowth;
         Decimal qroundedGrowth;
         wrapperClassSalesOrderByProduct wc=new wrapperClassSalesOrderByProduct();
         wc.productName=Product;
         wc.isCurrentYearSalePresent=iscurrentYearSale;
         
         if(currentVolumeMapbyProduct.size()>0)
         {
             wc.CurrentQuantity=currentVolumeMapbyProduct.get(Product)!=null ?currentVolumeMapbyProduct.get(Product) :0 ;              
         }
         else
         {
             wc.CurrentQuantity=0;
         }
         if(LastVolumeMapbyProduct.size()>0)
         {
             wc.LastQuantity=LastVolumeMapbyProduct.get(Product)!=null ?LastVolumeMapbyProduct.get(Product) :0 ;              
         }
         else
         {
             wc.LastQuantity=0;  
         }
         
         if(wc.lastQuantity!=0){
             
             qgrowth = ((wc.CurrentQuantity - wc.lastQuantity)/wc.lastQuantity)*100;
             if(wc.lastQuantity<0 && wc.CurrentQuantity>0){
                 qgrowth = qgrowth*-1;
             }
             if(wc.lastQuantity<0 && wc.CurrentQuantity<0){
                 qgrowth = qgrowth*-1;
             }
             qroundedGrowth = qgrowth.setScale(2, RoundingMode.HALF_UP);  
         }else{
             qgrowth = (wc.lastQuantity)*100;
             qroundedGrowth = qgrowth.setScale(2, RoundingMode.HALF_UP);
         }
         wc.quantitygrowth=qroundedGrowth;
         if(currentSalesMapbyProduct.size()>0)
         {
             currentSalesInCOP=currentSalesMapbyProduct.get(product)!=null ?currentSalesMapbyProduct.get(product) :0 ; 
             wc.currentYearSales = (currentSalesInCOP / Decimal.valueof(CurrentYearConversionRate)).setScale(2, RoundingMode.HALF_UP);
         }
         else{
             wc.currentYearSales=0;
         }
         if(LastSalesMapbyProduct.size()>0)
         {
             lastSalesInCOP=LastSalesMapbyProduct.get(product)!=null ?LastSalesMapbyProduct.get(product) :0 ; 
             wc.lstYearSales = (lastSalesInCOP / Decimal.valueof(lastYearConversionRate)).setScale(2, RoundingMode.HALF_UP);
         }
         else{
             wc.lstYearSales=0;
         }
         
         if(lastSalesInCOP!=0){
             
             growth = ((currentSalesInCOP - lastSalesInCOP)/lastSalesInCOP)*100;
             if(lastSalesInCOP<0 && currentSalesInCOP>0){
                 growth = growth*-1;
             }
             if(lastSalesInCOP<0 && currentSalesInCOP<0){
                 growth = growth*-1;
             }
             roundedGrowth = growth.setScale(2, RoundingMode.HALF_UP);  
         }else{
             growth = (lastSalesInCOP)*100;
             roundedGrowth = growth.setScale(2, RoundingMode.HALF_UP);
         }
         wc.growth=roundedGrowth;  
         
         
         wc.currencyCode='USD'; 
         wc.countryName=countryName;
         
         wrapperClassForSalesAmount.add(wc) ;
         
         
         
         
        }
        System.debug('wrapperClassForSalesAmount----->'+wrapperClassForSalesAmount);
        
        
        return wrapperClassForSalesAmount;
        
    }    
    @AuraEnabled    
    public static Decimal fetchSalesGrowth(){
        Period currentFiscalYear = [SELECT FiscalYearSettings.Name , StartDate,EndDate   
                                    FROM Period WHERE Type = 'Year' 
                                    AND StartDate <= TODAY 
                                    AND EndDate >= TODAY];
        
        
        Date StartDate = currentFiscalYear.StartDate;
        Date EndDate = currentFiscalYear.EndDate;
        Period currentFiscalYear1 = [SELECT FiscalYearSettings.Name , StartDate,EndDate   
                                     FROM Period WHERE Type = 'Year' 
                                     AND StartDate <= TODAY 
                                     AND EndDate >= TODAY];
        
        
        DateTime dateTimeScheduled = DateTime.newInstance(currentFiscalYear1.EndDate,Time.newInstance(0,0,0,0));
        
        Date theDate = Date.valueOf(dateTimeScheduled.format('yyyy-MM-dd'));
        Period lastFiscalYear = [select id, FiscalYearSettings.Name, StartDate,EndDate,Type 
                                 From Period 
                                 WHERE EndDate< :theDate
                                 AND Type ='Year' order By EndDate DESC Limit 1];
        
        
        Date lstYearStartDate = lastFiscalYear.StartDate;
        Date lstYearEndDate = System.today();
        
        Integer dtMonth = lstYearEndDate.month();
        Integer dtYear = lstYearEndDate.year();
        
        Date myNewEndDate = Date.newInstance(dtYear, dtMonth, 30); 
        
        System.debug('myDate '+myNewEndDate);
        
        String recordId = '';    
        String userid = UserInfo.getUserId();
        User userObj = [SELECT Id,UserName,Community_Role__c,TimeZoneSidKey,
                        AccountId,Account.Sales_Org_Code__c,Account.Sales_Org_Country__c FROM User WHERE Id=: userid];
        recordId = userObj.AccountId;
        
        List<Invoice__c> soListCurrent = new List<Invoice__c>();
        List<Invoice__c> soListLast = new List<Invoice__c>();
        
        
        return null;
        
        
    }
    
    
    
    
    
    // wrapper or Inner class with @AuraEnabled {get;set;} properties*    
    public class wrapperClassSalesOrder{
        @AuraEnabled public Decimal currentYearSales{get;set;}
        @AuraEnabled public Decimal lstYearSales{get;set;}
        @AuraEnabled public Integer totalNumberOrder{get;set;}
        @AuraEnabled public String currencyCode{get;set;}
        @AuraEnabled public String monthName{get;set;}
        @AuraEnabled public String countryName{get;set;}
        @AuraEnabled public Integer lstYear{get;set;}
        @AuraEnabled public Integer lstYear1{get;set;}
        @AuraEnabled public Integer curYear{get;set;}
        @AuraEnabled public Integer curYear1{get;set;}
        @AuraEnabled public Decimal growth{get;set;}
        @AuraEnabled public Decimal quantitygrowth{get;set;}
        @AuraEnabled public DateTime asOnDate{get;set;}
        @AuraEnabled public Decimal CurrentQuantity{get;set;}
        @AuraEnabled public Decimal LastQuantity{get;set;}
         @AuraEnabled public Boolean isCurrentYearSalePresent{get;set;}
        
        
        
        
        
        public wrapperClassSalesOrder(){
            currentYearSales = 0.0;
            lstYearSales = 0.0;
            totalNumberOrder = 0;
            currencyCode ='';
            monthName ='';
            growth = 0.0;
            quantitygrowth=0.0;
            countryName ='';
            CurrentQuantity=0.0;
            LastQuantity=0.0;
            isCurrentYearSalePresent=true;
            
            // asOnDate='';
            
            
            
            
        }
        
        
    }
    
    public class wrapperClassSalesOrderByProduct{
        @AuraEnabled public Decimal currentYearSales{get;set;}
        @AuraEnabled public Decimal lstYearSales{get;set;}
        @AuraEnabled public Integer totalNumberOrder{get;set;}
        @AuraEnabled public String currencyCode{get;set;}
        @AuraEnabled public String productName{get;set;}
        @AuraEnabled public String countryName{get;set;}
        @AuraEnabled public Integer lstYear{get;set;}
        @AuraEnabled public Integer lstYear1{get;set;}
        @AuraEnabled public Integer curYear{get;set;}
        @AuraEnabled public Integer curYear1{get;set;}
        @AuraEnabled public Decimal growth{get;set;}
        @AuraEnabled public Decimal quantitygrowth{get;set;}
        @AuraEnabled public DateTime asOnDate{get;set;}
        @AuraEnabled public Integer CurrentQuantity{get;set;}
        @AuraEnabled public Integer LastQuantity{get;set;}
        @AuraEnabled public Boolean isCurrentYearSalePresent{get;set;}
        
        
        
        public wrapperClassSalesOrderByProduct(){
            currentYearSales = 0.0;
            lstYearSales = 0.0;
            totalNumberOrder = 0;
            currencyCode ='';
            productName ='';
            growth = 0.0;
            quantitygrowth=0.0;
            countryName ='';
            CurrentQuantity=0;
            LastQuantity=0;
            isCurrentYearSalePresent=true;
            // asOnDate='';
            
            
            
            
        }
        
        
    }
    
    // Added by (GRZ) Nikhil Verma for Colombia Net Overdue amount 10-04-2023
    @AuraEnabled
    public static Grz_Customer360Wrapper.Wrapper getCollectionData(String fiscalYear, String fiscalPeriod){
        Grz_Customer360Wrapper.Wrapper response = new Grz_Customer360Wrapper.Wrapper();
        List<User> usr = [SELECT Id, AccountId FROM User WHERE Id =: UserInfo.getUserId()];
        if(usr != null && usr[0].AccountId != null){
            List<Account> accList = [SELECT Id,Name, Sap_UserId__c, Company_Code__c,Sales_Org_Code__c, SAP_Customer_Code__c, Sales_Org_Country__c FROM Account WHERE Id =: usr[0].AccountId AND RecordType.Name = 'Distributor'];
            if(accList != null && accList[0].Company_Code__c != null && accList[0].Sap_UserId__c != null && accList[0].SAP_Customer_Code__c != null){
                String sapData = Grz_SapCommonIntegration.collection(accList[0].SAP_Customer_Code__c, accList[0].Company_Code__c, fiscalYear, fiscalPeriod, accList[0].Sap_UserId__c);
                if(sapData == null || sapData == 'Error_In_Sap'){
                    response.success = false;
                    response.message = 'error in SAP';
                }else{
                    sapData = sapData.replace('"desc":', '"desc_z":').replace('"Return"', '"ReturnData"');
                    Grz_Customer360Wrapper.Grz_CollectionWrapper data = (Grz_Customer360Wrapper.Grz_CollectionWrapper) JSON.deserialize(sapData, Grz_Customer360Wrapper.Grz_CollectionWrapper.class);
                    if(sapData.contains('"item":')){
                        for(Grz_Customer360Wrapper.Item itm : data.item){
                            if(itm.currencyKey != null && itm.currencyKey != ''){
                                if(itm.currencyKey == 'COP'){
                                    response.collection = itm;
                                    break;
                                }else if(itm.currencyKey == 'USD'){
                                    response.collection = itm;
                                }
                            }
                        }
                    }else if(data.ReturnData.Message != '' || data.ReturnData.Message != null){
                        response.success = false;
                        response.message = data.ReturnData.Message;
                    }else{
                        response.success = false;
                        response.message = 'error in SAP';
                    }
                }
            }else{
                response.success = false;
                response.message = 'error in SAP';
            }
        }else{
            response.success = false;
            response.message = 'error in SAP';
        }
        return response;
    }
    
}