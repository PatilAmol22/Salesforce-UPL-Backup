public class SalesOrderChileController {
    public PageReference redirectToVF() {
        PageReference p = new PageReference('/apex/SOChileComp_VF');
        p.setRedirect(true);
        return p;
    }
}