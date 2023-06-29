public class OrderRedirectController {
    public Id accountId;
    
    public OrderRedirectController(ApexPages.StandardController controller) {
		accountId = ApexPages.currentpage().getparameters().get('id');
    }

    public PageReference redirectPage(){
        PageReference prObj = new PageReference('/apex/OrderManagement?acid='+accountId);
        prObj.setRedirect(true);
        return prObj;
    }
}