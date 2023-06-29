/**************************************************************************************************
* Name               : Grz_ColombiaControllerAR                                                      
* Description        : Controller class for Grz_ColombiaReportAR and Grz_ColombiaAR Component
* Test Class         : Grz_ColombiaControllerARTest
* Created By         : RITM0537888 Nikhil Verma (Grazitti) 12-04-2023
**************************************************************************************************/
public with sharing class Grz_ColombiaControllerAR {
   
    /**************************************************************************************************
    * Name               : getAccountReceivables                                                      
    * Description        : Method will return Account Receivables data via API callout from SAP to generate Pie graph and provides data for table
    * Created By         : Nikhil Verma (Grazitti) 12-04-2023                                                                     
    **************************************************************************************************/
    @AuraEnabled
    public static Wrapper getAccountReceivables(){
        Wrapper response = new Wrapper();
        Id userId;
        if(Test.isRunningTest()){
            List<User> user = [SELECT Id FROM User WHERE Profile.Name ='Brazil Partner Community Distributor Profile' AND LastName = 'Testing' AND Email ='test@grazitti.com' LIMIT 1];
            userId = user[0].Id;
        }
        else{
            userId = UserInfo.getUserId();
        }
        List<User> user = [SELECT Id, AccountId, Account.SAP_Customer_Code__c,Account.Company_Code__c ,Account.Sap_UserId__c FROM User WHERE Id =: userId];
        String customerCode = user[0].Account.SAP_Customer_Code__c;
        String companyCode = user[0].Account.Company_Code__c;
        String sapUserId = user[0].Account.Sap_UserId__c;
        if(customerCode != null && companyCode != null && sapUserId != null){
            DateTime todaysDate = System.today();
            Date keyDate = todaysDate.dateGMT();
            DateTime today0_30 = todaysDate + 30;
            Date todaysDateStr1 = today0_30.dateGMT();
            DateTime today31_60 = today0_30 + 30;
            Date todaysDateStr2 = today31_60.dateGMT();
            DateTime today61_90 = today31_60 + 30;
            Date todaysDateStr3 = today61_90.dateGMT();
            String sapData = Grz_SapCommonIntegration.overdueSummary(customerCode, sapUserId, companyCode, String.ValueOf(keyDate), 'x', 'x');
            if(sapData == null || sapData == 'Error_In_Sap'){
                response.success = false;
                response.message = 'Error while fetching data.';
            }else{
                sapData = sapData.replace('"Return"', '"ReturnData"');
                List<Lineitems> lineItem = new List<Lineitems>();
                Grz_OverdueWrapper data = (Grz_OverdueWrapper) JSON.deserialize(sapData, Grz_OverdueWrapper.class);
                response.totalOverdue = 0;
                response.notYetDue = 0;
                response.upto_0_30 = 0;
                response.upto_31_60 = 0;
                response.upto_61_90 = 0;
                response.after_91 = 0;
                if(data.Lineitems != null){
                    Map<String,Grz_Customer360_Doc_Type__mdt> docMap = new Map<String,Grz_Customer360_Doc_Type__mdt>();
                    for(Grz_Customer360_Doc_Type__mdt doc: Grz_Customer360_Doc_Type__mdt.getAll().values()){
                        docMap.put(doc.Short_Form__c, doc);
                    }
                    String userLang = 'en_US__c'; 
                    /*String currentLang = UserInfo.getLanguage().toLowerCase() + '__c';
                    Schema.DescribeSObjectResult r = Grz_Customer360_Doc_Type__mdt.sObjectType.getDescribe();
                    for(string apiName : r.fields.getMap().keySet()){
                        if(apiName == currentLang){
                            userLang = apiName;
                            break;
                        }
                    }*/
                    for(Lineitems ifo : data.Lineitems){
                        if(ifo.DbCrInd != null && ifo.DbCrInd != '' && ifo.DbCrInd == 'H'){
                            ifo.AmtDoccur = '-' + ifo.AmtDoccur;
                        }
                        ifo.decimalAmt = decimal.valueOf(ifo.AmtDoccur);
                        if(docMap != null && docMap.get(ifo.DocType) != null && docMap.get(ifo.DocType).get(userLang) != null){
                            ifo.docDes = String.valueOf(docMap.get(ifo.DocType).get(userLang));
                        }else{
                            ifo.docDes = '-';
                        }
                        Date dt = date.valueOf(ifo.BlineDate);
                        ifo.DueDate = String.valueOf(dt.addDays(Integer.valueOf(ifo.DsctDays1)));
                        Date todayDate = system.today();
                        Date dueDate = date.valueOf(ifo.DueDate);
                        ifo.overDued = todayDate.daysBetween(dueDate) >= 0 ? false : true;

                        if(date.valueOf(ifo.dueDate) < date.valueOf(keyDate)){
                            response.totalOverdue += decimal.valueOf(ifo.AmtDoccur);
                        }else if(date.valueOf(ifo.dueDate) >= date.valueOf(keyDate)){
                            response.notYetDue += decimal.valueOf(ifo.AmtDoccur);
                        }
                        if(date.valueOf(ifo.dueDate) >= date.valueOf(keyDate)  && date.valueOf(ifo.dueDate) < date.valueOf(todaysDateStr1)){
                            response.upto_0_30 += decimal.valueOf(ifo.AmtDoccur);
                        }
                        if(date.valueOf(ifo.dueDate) >= date.valueOf(todaysDateStr1)  && date.valueOf(ifo.dueDate) < date.valueOf(todaysDateStr2)){
                            response.upto_31_60 += decimal.valueOf(ifo.AmtDoccur);
                        }
                        if(date.valueOf(ifo.dueDate) >= date.valueOf(todaysDateStr2)  && date.valueOf(ifo.dueDate) < date.valueOf(todaysDateStr3)){
                            response.upto_61_90 += decimal.valueOf(ifo.AmtDoccur);
                        }
                        if(date.valueOf(ifo.dueDate) >= date.valueOf(todaysDateStr3)){
                            response.after_91 += decimal.valueOf(ifo.AmtDoccur);
                        }
                        lineItem.add(ifo);
                    }
                }
                if(sapData.contains('"Lineitems":')){
                    if(!lineItem.isEmpty()){
                        response.lineitems = lineItem;
                    }else{
                        response.success = false;
                        response.message = 'No Data found.';
                    }
                }else if(data.ReturnData.Message != '' || data.ReturnData.Message != null){
                    response.success = false;
                    response.message = 'No Overdue Invoices.';
                }else{
                    response.success = false;
                    response.message = 'Something went wrong.';
                }
                
                List<ARReportData> arData = new List<ARReportData>();
                Decimal totalAmt =  response.totalOverdue + response.upto_0_30 + response.upto_31_60 + response.upto_61_90 + response.after_91;
                arData.add(new ARReportData('Vencida', (response.totalOverdue * 100 / totalAmt).setScale(2))); 
                arData.add(new ARReportData('0 a 30 Días', (response.upto_0_30 * 100 / totalAmt).setScale(2)));
                arData.add(new ARReportData('De 31 a 60 Días', (response.upto_31_60 * 100 / totalAmt).setScale(2)));
                arData.add(new ARReportData('De 61 a 90 Días', (response.upto_61_90 * 100 / totalAmt).setScale(2)));
                arData.add(new ARReportData('Mayor a 91 días', (response.after_91 * 100 / totalAmt).setScale(2)));
                response.ARReportWrap = arData; 
            }
        }else{
            response.success = false;
            response.message = 'Required Data missing at Account level.';
        }
        return response;
    }

    public class Wrapper {
        @AuraEnabled public String message                      { get; set; }
        @AuraEnabled public Boolean success                     { get; set; }
        @AuraEnabled public decimal totalOverdue                { get; set; }
        @AuraEnabled public decimal notYetDue                   { get; set; }
        @AuraEnabled public decimal upto_0_30                   { get; set; }
        @AuraEnabled public decimal upto_31_60                  { get; set; }
        @AuraEnabled public decimal upto_61_90                  { get; set; }
        @AuraEnabled public decimal after_91                    { get; set; }
        @AuraEnabled public List<Lineitems> lineitems           { get;set; }
        @AuraEnabled public list<ARReportData> ARReportWrap     { get;set; }
    
        public Wrapper(){
            this.message = 'Success';
            this.success = true;
        }
    }

    public class ARReportData {
        @AuraEnabled public String name         { get; set; }
        @AuraEnabled public Decimal value       { get; set; }

        public ARReportData(String name, Decimal value) {
            this.name = name;
            this.value = value;
        }
    }

    public class Grz_OverdueWrapper{
        @AuraEnabled public List<Lineitems> Lineitems   {get;set;}
        @AuraEnabled public ReturnData ReturnData       {get;set;}
    }

    public class Lineitems {
        @AuraEnabled public String DocNo        {get;set;}
        @AuraEnabled public String DocDate      {get;set;}
        @AuraEnabled public String AmtDoccur    {get;set;}
        @AuraEnabled public Decimal decimalAmt  {get;set;}
        @AuraEnabled public String DsctDays1    {get;set;}
        @AuraEnabled public String BlineDate    {get;set;}
        @AuraEnabled public String CompCode     {get;set;}
        @AuraEnabled public String Customer     {get;set;}
        @AuraEnabled public String DocType      {get;set;}
        @AuraEnabled public String docDes       {get;set;}
        @AuraEnabled public String DueDate      {get;set;}
        @AuraEnabled public String DbCrInd      {get;set;}
        @AuraEnabled public boolean overDued    {get;set;}
    }
    public class ReturnData {
        @AuraEnabled public String Type         {get;set;}
        @AuraEnabled public String Code         {get;set;}
        @AuraEnabled public String Message      {get;set;}
    }
}