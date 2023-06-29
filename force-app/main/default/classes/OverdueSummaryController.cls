//#INC-391051:- Overdue summary page:- change customer transction filter to get all doc type related to Argentina
public class  OverdueSummaryController{
    
    public List<CustomerTransaction__c> customerTransList{get;set;}
    public List<WrapCustomertransaction> wrapCustomerTransList{get;set;}
    
    public List<WrapOutstandingAgeing> wrapOutstandingAgeingList{get;set;}
    public List<Outstanding_Ageing__c> outstandingAgeingList{get;set;}

    
    public String AccId {get;set;}
    //public Decimal TotalCr{get;set;}
    //public Decimal TotalDr{get;set;}
    public String CustName{get;set;}
    public String CustSAPcode{get;set;}
    public String currencyiso {get;set;}
    public Integer totalOverDueDays {get;set;}
    
    
    
    
    
    public OverdueSummaryController(ApexPages.StandardController stdController){
        try{
            //TotalCr =0;
            //TotalDr =0;
            
            CustName ='';
            CustSAPcode='';
            totalOverDueDays = 0;
            
            System.debug('AccId-->'+ApexPages.currentPage().getParameters().get('AccId') );
            
            //String s = ApexPages.currentPage().getParameters().get('AccId');
            //AccId = [SELECT Id,Account__c from Account_Statement__c where id=:s][0].Account__c;
            
            AccId = ApexPages.currentPage().getParameters().get('AccId');
            customerTransList = new List<CustomerTransaction__c>();
            wrapCustomerTransList = new List<WrapCustomertransaction>();
            wrapOutstandingAgeingList = new List<WrapOutstandingAgeing>();
            customerTransList = [SELECT Id, Billing_Date__c, Clearing_doc__c, Amount__c, Payment_Term__c,
                                 DocType__c,Customer__r.name,Customer__r.SAP_Code__c,
                                 PostingDate__c,DocNumber__c, Customer__c, Status__c, CreatedDate,currencyISOCode 
                                 FROM CustomerTransaction__c 
                                 WHERE Customer__c=:AccId AND Clearing_doc__c = '' AND DocType__c  In ('AB','R1','R3','R4','R5','SA','SB','RV','DR','DS','BR','BP','BR')];
            
              
            outstandingAgeingList = [Select X0_30__c,X16_30__c,X1_15__c,
                                     X31_60__c,X61_75__c,X76_90__c,X91_120__c,X121_150__c,X151_180__c,X181_210__c,X211_Above__c, Total_Outstanding__c,Total_Overdue__c from Outstanding_Ageing__c
                                     WHERE  Customer_Code__c=:AccId];
          
            currencyiso =' '+customerTransList[0].currencyISOCode;
            
            System.debug('customerTransList size '+customerTransList.size());
            
            Integer dayss ;//=  D1-D2;
            
            //looping start
            for(CustomerTransaction__c ctObj : customerTransList){
                WrapCustomertransaction wrapObj = new WrapCustomertransaction();
                DateTime D1 =(ctObj.Billing_Date__c).addDays(Integer.valueOf(ctObj.Payment_Term__c));
                DateTime D2 = System.Today();
                Double tempAmt = 0.0;     //RITM0340457 Change made by Abhimanyu. 
                System.debug('value of D1 '+D1);
                System.debug('value of D2 '+D2);
                
                
                integer Days = Integer.valueOf((D2.getTime() - D1.getTime())/(1000*60*60*24));
                System.debug('Days diffrence '+Days);
                
                
                
                
                System.debug('D1 Days Adder '+D1);
                System.debug('D2 now Date '+D2);
                wrapObj.BillingDate = ctObj.Billing_Date__c;
                wrapObj.DocNumber = ctObj.DocNumber__c;
                wrapObj.CleaningDocument = ctObj.Clearing_doc__c;
                tempAmt = ctObj.Amount__c;     //RITM0340457 Change made by Abhimanyu. 
                wrapObj.Amount = tempAmt.format();     //RITM0340457 Change made by Abhimanyu. 
                wrapObj.Payment_term = String.valueOf(ctObj.Payment_Term__c); 
                wrapObj.CurrencyISOCode =' '+ctObj.CurrencyIsoCode;
                wrapObj.Overdue_Days = Integer.valueOf((D2.getTime() - D1.getTime())/(1000*60*60*24));
                totalOverDueDays =totalOverDueDays + Days;
                
                
                System.debug('Date is  '+ctObj.Billing_Date__c+' Payment Terms '+ctobj.Payment_Term__c+' System.Now() '+System.Today());
                if(D1>D2){
                    wrapObj.flag = true;    
                }else{
                    wrapObj.flag = false;    
                }
                String dateFormatString = 'MM/dd/yyyy';
                wrapObj.overdueDate =  D1.format(dateFormatString);
                wrapCustomerTransList.add(wrapObj);
            }// end of for loop
            
             WrapOutstandingAgeing wrapObj1 = new WrapOutstandingAgeing();
            
            // Pratham
            for(Outstanding_Ageing__c OAObj : outstandingAgeingList){
                wrapObj1.TotalOutstanding=OAObj.Total_Outstanding__c;
                wrapObj1.oneToFifteen=OAObj.X1_15__c;
                wrapObj1.sixteenToThirty=OAObj.X16_30__c;
                wrapObj1.thirtyToThreeSixty=OAObj.X31_60__c+OAObj.X61_75__c+OAObj.X76_90__c+OAObj.X91_120__c+OAObj.X121_150__c+OAObj.X151_180__c+OAObj.X181_210__c+OAObj.X211_Above__c;
                wrapObj1.TotalOverdue=OAObj.Total_Overdue__c;
                wrapObj1.TotalNotDue=wrapObj1.TotalOutstanding-wrapObj1.TotalOverdue;
            }
              wrapOutstandingAgeingList.add(wrapObj1);
            
            System.debug('OutstandingAgeingList' +wrapOutstandingAgeingList);
            //Pratham
            totalOverDueDays = totalOverDueDays/customerTransList.size();
            
            System.debug('totalOverDueDays '+totalOverDueDays);
            totalOverDueDays =totalOverDueDays/customerTransList.size();
            
            //Payment_Term__c>90 
            if(customerTransList.size()>0){
                CustName = customerTransList[0].Customer__r.name; 
                CustSAPcode =customerTransList[0].Customer__r.SAP_Code__c; 
            }
        }
        catch(Exception e){
            System.debug('Error : '+e);
        }
    }
    
    public PageReference  generatePDF(){
        System.debug('Calling From pdf button ');
        PageReference pr = new PageReference('/apex/OverdueSummaryPDF?AccId='+AccId);
        pr.setRedirect(true); 
        return pr;
    }
    
    
    
    public class WrapCustomertransaction {
        public Date BillingDate {get;set;}
        public String overdueDate {get;set;}
        public String DocNumber {get;set;}
        public String CleaningDocument {get;set;}
        public String Amount {get;set;}
        public String CurrencyISOCode {get;set;}
        public Boolean flag {get;set;}
        public integer Overdue_Days {get;set;}
        public String Payment_term {get;set;}
        
        WrapCustomertransaction(){
            
        } // end of Wrapper class constuctor
        
    } //end of wrapper class    
      public class WrapOutstandingAgeing {
        public Decimal TotalOutstanding {get;set;}
        public Decimal oneToFifteen {get;set;}
        public Decimal sixteenToThirty {get;set;}
        public Decimal thirtyToThreeSixty {get;set;}
        public Decimal TotalOverdue {get;set;}
        public Decimal TotalNotDue {get;set;}
        
    }
}// end of class