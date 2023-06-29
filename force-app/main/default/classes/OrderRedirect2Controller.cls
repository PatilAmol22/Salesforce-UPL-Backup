public class OrderRedirect2Controller {
    public Id accountId;
    
    public OrderRedirect2Controller(ApexPages.StandardController controller) {
        accountId = ApexPages.currentpage().getparameters().get('id');
    }
    
    public PageReference redirectPage(){
        String country = [Select Id, Sales_Org_Country__c FROM Account WHERE Id=:accountId].Sales_Org_Country__c;
        PageReference prObj;
        if(String.isNotBlank(country)){
            if(country=='India'){
                prObj = new PageReference('/apex/OrderIndia?acid='+accountId);
            }
            else if(country=='SWAL'){
                prObj = new PageReference('/apex/OrderSWAL?acid='+accountId);
            }
            else if(country=='Indonesia'){
                prObj = new PageReference('/apex/OrderIndonesia?acid='+accountId);
            }
            else if(country=='Argentina'){
                prObj = new PageReference('/apex/OrderArgentina?acid='+accountId);
            }
            prObj.setRedirect(true);    
            return prObj;
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Account Sales Org not set'));
            return null;
        }
    }
}