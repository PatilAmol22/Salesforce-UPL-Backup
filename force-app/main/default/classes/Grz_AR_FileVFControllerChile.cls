public with sharing class Grz_AR_FileVFControllerChile{
   // public List<ARWrapper> arWrap{get;set;}
    public static String customerName{get;set;}
    public static  String customerSAP{get;set;}
    //added by Akhilesh w.r.t Uconnect Mobile App
    public static String imgUrl {get;set;}
    public static String isoverduedimg {get;set;}
    public static String notoverduedimg {get;set;}//AK end
    public static  String city{get;set;}
    public static  List<Grz_AccountReceivablesChile.Lineitems> data{get;set;}
    public static void Grz_ARactionVF() {
        System.debug('---InController-->>');
        String refSearch = ApexPages.currentPage().getParameters().get('refSearch');
        String dueDateStart = ApexPages.currentPage().getParameters().get('dueDateStart');
        String dueDateEnd = ApexPages.currentPage().getParameters().get('dueDateEnd');
        String startDate = ApexPages.currentPage().getParameters().get('startDate');
        String endDate = ApexPages.currentPage().getParameters().get('endDate');
        String customerCode = ApexPages.currentPage().getParameters().get('customerCode');
        String companyCode = ApexPages.currentPage().getParameters().get('companyCode');
        String sapUserId = ApexPages.currentPage().getParameters().get('sapUserId');
         String distributorValue = ApexPages.currentPage().getParameters().get('distributorValue');
        String isInternal  = ApexPages.currentPage().getParameters().get('isInternal');
         
        if(Test.isRunningTest()){       
            startDate = '2021-01-01';
            endDate = '2021-12-31';
            customerCode = '0001085776';
            sapUserId = 'UPLINTCRM';
            companyCode = '5660';
            dueDateStart = '2021-01-01';
            dueDateEnd = '2022-12-31';
            refSearch = '';
            isInternal = 'true';
        }

        //below URL code added by Akhilesh w.r.t Uconnect Mobile app.
       String sfdcBaseURL = ApexPages.currentPage().getHeaders().get('Referer');
       System.debug('sfdcBaseURL URL: ' + sfdcBaseURL); 
       String baseUrl = sfdcBaseURL?.split('/s/')[0];
       
       if(string.isNotBlank(baseUrl) && baseUrl.containsIgnoreCase('uplpartnerportalstd')){
           imgUrl = '/uplpartnerportalstd/resource/1617949256000/Grz_Resourse/Grz_Resourse/Images/UPL_LOGO.png';
           isoverduedimg = '/uplpartnerportalstd/resource/1617949256000/Grz_Resourse/Grz_Resourse/Images/error_Icon.png';
           notoverduedimg = '/uplpartnerportalstd/resource/1617949256000/Grz_Resourse/Grz_Resourse/Images/sucess_Icon.png';
       }else{
           imgUrl = '/uplpartnerportal/resource/1617949256000/Grz_Resourse/Grz_Resourse/Images/UPL_LOGO.png';
           isoverduedimg = '/uplpartnerportal/resource/1617949256000/Grz_Resourse/Grz_Resourse/Images/error_Icon.png';
           notoverduedimg = '/uplpartnerportal/resource/1617949256000/Grz_Resourse/Grz_Resourse/Images/sucess_Icon.png';
       }

        if(isInternal.endsWithIgnoreCase('false')){
        Grz_AccountReceivablesChile.ResultWrapper rapper = Grz_AccountReceivablesChile.getuserInfo();
        customerName = rapper.name;
        customerSAP = rapper.customerCode;
        city = rapper.city;
        }else{
         Grz_AccountReceivablesChile.ResultWrapper rapper = Grz_AccountReceivablesChile.getCustomerRecord(customerCode);
        customerName = rapper.name;
        customerSAP = rapper.customerCode;
        city = rapper.city;
        }
         Grz_AccountReceivablesChile.ResultWrapper ARdata = Grz_AccountReceivablesChile.getAccountReceivables(customerCode,sapUserId,companyCode,refSearch,dueDateStart,dueDateEnd,startDate,endDate,true);
         data = ARdata.ar.Lineitems;
     }
}