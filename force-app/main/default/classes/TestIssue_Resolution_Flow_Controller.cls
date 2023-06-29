@isTest
public class TestIssue_Resolution_Flow_Controller {
    public static TestMethod void testFinishPage()
    {
        Account acc=new Account();
       	ApexPages.StandardController sc= new ApexPages.StandardController(acc);
        Issue_Resolution_Flow_Controller iss=new Issue_Resolution_Flow_Controller(sc);
        PageReference p=iss.getFinishPage();
    }

}