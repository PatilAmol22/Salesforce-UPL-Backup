/**************************************************************************************************
* Name               : Grz_AR_FileVFController                                                      
* Description        : Controller for AR list download functionality for Brazil Community
* Test Class         : Grz_AR_FileVFControllerTest
* Created By         : Nikhil Verma (Grazitti)                                                                       
**************************************************************************************************/
public with sharing class Grz_AR_FileVFController{
    public List<ARWrapper> arWrap{ get; set; }
    public String customerName{ get; set; }
    public String customerSAP{ get; set; }

    public void Grz_ARactionVF(){
        String refSearch = ApexPages.currentPage().getParameters().get('refSearch');
        String dueDateStart = ApexPages.currentPage().getParameters().get('dueDateStart');
        String dueDateEnd = ApexPages.currentPage().getParameters().get('dueDateEnd');
        String startDate = ApexPages.currentPage().getParameters().get('startDate');
        String endDate = ApexPages.currentPage().getParameters().get('endDate');
        String customerCode = ApexPages.currentPage().getParameters().get('customerCode');
        String companyCode = ApexPages.currentPage().getParameters().get('companyCode');
        String sapUserId = ApexPages.currentPage().getParameters().get('sapUserId');
        String distributorValue = ApexPages.currentPage().getParameters().get('distributorValue');
        String subGroupId = ApexPages.currentPage().getParameters().get('subGroupId');//Updated Logic GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
        if (Test.isRunningTest()){
            startDate = '2019-04-02';
            endDate = '2021-07-02';
            customerCode = '0001033252';
            sapUserId = 'UPLINTCRM';
            companyCode = '5190';
            dueDateStart = '2019-04-02';
            dueDateEnd = '2030-07-02';
        }
        DateTime todaysDate = System.today();
        String todaysDateStr = String.valueOf(todaysDate.dateGMT());
        ResultWrapper rapper = new ResultWrapper();
        String res;
        Set<String> subGroupSapId = new Set<String>();
        if (!String.isEmpty(distributorValue)){
            if (distributorValue != 'All'){
                res = grz_SapIntegration.getBrazilAccountReceivables(distributorValue, sapUserId, companyCode, todaysDateStr);
            } else{//Else part added, Updated Logic GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
                if (subGroupId != null && subGroupId != ''){
                    for (Account acc : [SELECT SAP_Code__c
                                        FROM Account
                                        WHERE Sub_Parent_Account__r.SAP_Code__c = :subGroupId]){
                        subGroupSapId.add(acc.SAP_Code__c);
                    }
                    subGroupSapId.add(subGroupId);
                }
                res = grz_SapIntegration.getBrazilAccountReceivables(customerCode, sapUserId, companyCode, todaysDateStr);
            }
        }
        res = res.replace('name_1', 'CSname');
        res = res.replace('"date":', '"dueDate":');
        rapper.ar = (Br_Account_receivable)JSON.deserialize(res, Br_Account_receivable.class);
        List<ARWrapper> filterInfo = new List<ARWrapper>();
        for (ARWrapper ifo : rapper.ar.Account_Receivables){
            //Updated Logic GRZ(Nikhil Verma) : APPS-1394 PO & Delivery Date :28-07-2022
            if (distributorValue != customerCode){
                if(!subGroupSapId.isEmpty()){
                    if(subGroupSapId.contains(ifo.customer_number)){
                        if (date.valueOf(ifo.document_date_in_document) >= date.valueOf(startDate) && date.valueOf(ifo.document_date_in_document) <= date.valueOf(endDate)){
                            if (!String.isEmpty(refSearch)){
                                if (date.valueOf(ifo.dueDate) >= date.valueOf(dueDateStart) && date.valueOf(ifo.dueDate) <= date.valueOf(dueDateEnd) && ifo.Reference_Document_Number.toLowerCase().contains(refSearch.toLowerCase())){
                                    ifo.amount_in_document_currency_WRBTR = grz_SapIntegration.currencyBrazil(Decimal.valueOf(ifo.amount_in_document_currency_WRBTR).setScale(0));
                                    ifo.amount_in_document_currency_PRTVLR = grz_SapIntegration.currencyBrazil(Decimal.valueOf(ifo.amount_in_document_currency_PRTVLR).setScale(0));
                                    ifo.account_in_local_currency = grz_SapIntegration.currencyBrazil(Decimal.valueOf(ifo.account_in_local_currency).setScale(0));
                                    ifo.Cash_Discount_Percentage_1 = grz_SapIntegration.currencyBrazil(Decimal.valueOf(ifo.Cash_Discount_Percentage_1).setScale(1));
                                    filterInfo.add(ifo);
                                }
                            } else{
                                if (date.valueOf(ifo.dueDate) >= date.valueOf(dueDateStart) && date.valueOf(ifo.dueDate) <= date.valueOf(dueDateEnd)){
                                    ifo.amount_in_document_currency_WRBTR = grz_SapIntegration.currencyBrazil(Decimal.valueOf(ifo.amount_in_document_currency_WRBTR).setScale(0));
                                    ifo.amount_in_document_currency_PRTVLR = grz_SapIntegration.currencyBrazil(Decimal.valueOf(ifo.amount_in_document_currency_PRTVLR).setScale(0));
                                    ifo.Cash_Discount_Percentage_1 = grz_SapIntegration.currencyBrazil(Decimal.valueOf(ifo.Cash_Discount_Percentage_1).setScale(1));
                                    ifo.account_in_local_currency = grz_SapIntegration.currencyBrazil(Decimal.valueOf(ifo.account_in_local_currency).setScale(0));
                                    filterInfo.add(ifo);
                                }
                            }
                        }
                    }
                }else{
                    if (date.valueOf(ifo.document_date_in_document) >= date.valueOf(startDate) && date.valueOf(ifo.document_date_in_document) <= date.valueOf(endDate)){
                        if (!String.isEmpty(refSearch)){
                            if (date.valueOf(ifo.dueDate) >= date.valueOf(dueDateStart) && date.valueOf(ifo.dueDate) <= date.valueOf(dueDateEnd) && ifo.Reference_Document_Number.toLowerCase().contains(refSearch.toLowerCase())){
                                ifo.amount_in_document_currency_WRBTR = grz_SapIntegration.currencyBrazil(Decimal.valueOf(ifo.amount_in_document_currency_WRBTR).setScale(0));
                                ifo.amount_in_document_currency_PRTVLR = grz_SapIntegration.currencyBrazil(Decimal.valueOf(ifo.amount_in_document_currency_PRTVLR).setScale(0));
                                ifo.account_in_local_currency = grz_SapIntegration.currencyBrazil(Decimal.valueOf(ifo.account_in_local_currency).setScale(0));
                                ifo.Cash_Discount_Percentage_1 = grz_SapIntegration.currencyBrazil(Decimal.valueOf(ifo.Cash_Discount_Percentage_1).setScale(1));
                                filterInfo.add(ifo);
                            }
                        } else{
                            if (date.valueOf(ifo.dueDate) >= date.valueOf(dueDateStart) && date.valueOf(ifo.dueDate) <= date.valueOf(dueDateEnd)){
                                ifo.amount_in_document_currency_WRBTR = grz_SapIntegration.currencyBrazil(Decimal.valueOf(ifo.amount_in_document_currency_WRBTR).setScale(0));
                                ifo.amount_in_document_currency_PRTVLR = grz_SapIntegration.currencyBrazil(Decimal.valueOf(ifo.amount_in_document_currency_PRTVLR).setScale(0));
                                ifo.Cash_Discount_Percentage_1 = grz_SapIntegration.currencyBrazil(Decimal.valueOf(ifo.Cash_Discount_Percentage_1).setScale(1));
                                ifo.account_in_local_currency = grz_SapIntegration.currencyBrazil(Decimal.valueOf(ifo.account_in_local_currency).setScale(0));
                                filterInfo.add(ifo);
                            }
                        }
                    }
                }
            }else{
                if (ifo.customer_number == distributorValue){
                    if (date.valueOf(ifo.document_date_in_document) >= date.valueOf(startDate) && date.valueOf(ifo.document_date_in_document) <= date.valueOf(endDate)){
                        if (!String.isEmpty(refSearch)){
                            if (date.valueOf(ifo.dueDate) >= date.valueOf(dueDateStart) && date.valueOf(ifo.dueDate) <= date.valueOf(dueDateEnd) && ifo.Reference_Document_Number.toLowerCase().contains(refSearch.toLowerCase())){
                                ifo.amount_in_document_currency_WRBTR = grz_SapIntegration.currencyBrazil(Decimal.valueOf(ifo.amount_in_document_currency_WRBTR).setScale(0));
                                ifo.amount_in_document_currency_PRTVLR = grz_SapIntegration.currencyBrazil(Decimal.valueOf(ifo.amount_in_document_currency_PRTVLR).setScale(0));
                                ifo.account_in_local_currency = grz_SapIntegration.currencyBrazil(Decimal.valueOf(ifo.account_in_local_currency).setScale(0));
                                ifo.Cash_Discount_Percentage_1 = grz_SapIntegration.currencyBrazil(Decimal.valueOf(ifo.Cash_Discount_Percentage_1).setScale(1));
                                filterInfo.add(ifo);
                            }
                        } else{
                            if (date.valueOf(ifo.dueDate) >= date.valueOf(dueDateStart) && date.valueOf(ifo.dueDate) <= date.valueOf(dueDateEnd)){
                                ifo.amount_in_document_currency_WRBTR = grz_SapIntegration.currencyBrazil(Decimal.valueOf(ifo.amount_in_document_currency_WRBTR).setScale(0));
                                ifo.amount_in_document_currency_PRTVLR = grz_SapIntegration.currencyBrazil(Decimal.valueOf(ifo.amount_in_document_currency_PRTVLR).setScale(0));
                                ifo.Cash_Discount_Percentage_1 = grz_SapIntegration.currencyBrazil(Decimal.valueOf(ifo.Cash_Discount_Percentage_1).setScale(1));
                                ifo.account_in_local_currency = grz_SapIntegration.currencyBrazil(Decimal.valueOf(ifo.account_in_local_currency).setScale(0));
                                filterInfo.add(ifo);
                            }
                        }
                    }
                }
            }
        }

        List<ARWrapper> finalIfo = new List<ARWrapper>();
        for (ARWrapper ifo : filterInfo){
            if (ifo.Payment_Method_ZLSCH == ''){
                ifo.Payment_Method_ZLSCH = '--';
            }
            if (ifo.Payment_Method_ZLSCH == 'K' || ifo.Payment_Method_ZLSCH == 'R'){
                ifo.Payment_Method_ZLSCH = 'Cessão';
            }
            if (ifo.Payment_Method_ZLSCH == 'A'){
                ifo.Payment_Method_ZLSCH = 'Cobrança Simples';
            }
            if (ifo.Payment_Method_ZLSCH == 'Outros'){
                ifo.Payment_Method_ZLSCH = 'Pagamento em Carteira';
            }
            if (ifo.Short_Key_for_a_House_Bank == ''){
                ifo.Short_Key_for_a_House_Bank = '--';
            }
            ifo.dueDate = grz_SapIntegration.FormattedDateBrazil(Date.valueOf(ifo.dueDate));
            ifo.document_date_in_document = grz_SapIntegration.FormattedDateBrazil(Date.valueOf(ifo.document_date_in_document));
            finalIfo.add(ifo);
        }
        customerName = finalIfo[0].CSname;
        if (!String.isEmpty(distributorValue)){
            if (distributorValue != 'All'){
                customerSAP = distributorValue;
            } else{
                customerSAP = customerCode;
            }
        }

        arWrap = finalIfo;
    }

    public class ResultWrapper{
        @AuraEnabled
        public Br_Account_receivable ar{ get; set; }

    }

    public class Br_Account_receivable{
        @AuraEnabled
        public List<ARWrapper> Account_Receivables{ get; set; }

    }

    public class ARWrapper{
        @AuraEnabled
        public String document_date_in_document{ get; set; }

        @AuraEnabled
        public String customer_number{ get; set; }

        @AuraEnabled
        public String CSname{ get; set; }

        @AuraEnabled
        public String accounting_document_number{ get; set; }

        @AuraEnabled
        public String document_type{ get; set; }

        @AuraEnabled
        public String Reference_Document_Number{ get; set; }

        @AuraEnabled
        public String baseline_date_for_due_date_calculation{ get; set; }

        @AuraEnabled
        public String dueDate{ get; set; }

        @AuraEnabled
        public String amount_in_document_currency_WRBTR{ get; set; }

        @AuraEnabled
        public String currency_key_WAERS{ get; set; }

        @AuraEnabled
        public String amount_in_document_currency_PRTVLR{ get; set; }

        @AuraEnabled
        public String account_in_local_currency{ get; set; }

        @AuraEnabled
        public String Cash_Discount_Percentage_1{ get; set; }

        @AuraEnabled
        public String Special_GL_Indicator{ get; set; }

        @AuraEnabled
        public String Short_Key_for_a_House_Bank{ get; set; }

        @AuraEnabled
        public String Assignment_Number_for_Special_GL_Accounts{ get; set; }

        @AuraEnabled
        public String Payment_Method_ZLSCH{ get; set; }

        @AuraEnabled
        public String Customers_account_number_with_credit_limit_reference{ get; set; }

    }

}