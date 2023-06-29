public with sharing class SearchPageController {
    public List<String> searchList {get;set;}
    public SearchPageController(ApexPages.StandardController controller){
        searchList = new List<String>();
        searchList.add('ULALA');
        searchList.add('SAAF');
        searchList.add('LANCER');
        searchList.add('KINADON');
    }
}