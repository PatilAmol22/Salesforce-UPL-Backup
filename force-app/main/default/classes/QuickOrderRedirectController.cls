public class QuickOrderRedirectController {
    public Id accountId;
    
    public QuickOrderRedirectController(ApexPages.StandardController controller) {
		accountId = ApexPages.currentpage().getparameters().get('id');
    }

    public PageReference redirectPage(){
        PageReference prObj = new PageReference('/apex/CatalogHome?acid='+accountId);
        prObj.setRedirect(true);
        return prObj;
    }
}