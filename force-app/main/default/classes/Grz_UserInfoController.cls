global with sharing class Grz_UserInfoController{
    string userIp;
    public String details{get; set;}
    @TestVisible private static String accountName;
    public Grz_UserInfoController() {
        userIp = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
    }
    public String strCountry{get;set;}
    
    public pageReference onValueUpdate() {
        String country = details;
        
        if(Test.isRunningTest()){
			country = accountName;
        }
        
        String countryinitial;
        system.debug('country--'+country);
        
        if(country == 'India'){
            countryinitial = 'IN';
        }
        
        else if(country == 'Brazil'){
            countryinitial = 'BR';
        }

        //If the user selects Argentina the countryinitial is set
        //to render the Argentina Community login page,GRZ(Gurubaksh Grewal) : APPS-1757 added on: 11-08-2022
        else if(country == 'Argentina'){
            countryinitial = 'AR';
        }
        
        else if(country == 'Mexico'){
            countryinitial = 'MX';
        }
		else if(country == 'Chile'){
            countryinitial = 'CH';
        }        
        else if(country == 'Columbia'){
            countryinitial = 'CO';
        }
        
        else if(country == 'Spain'){
            countryinitial = 'ES';
        }
        
        else if(country == 'Poland'){
            countryinitial = 'PL';
        }
        
        else if(country == 'Portugal'){
            countryinitial = 'PT';
        }

        else if(country == 'Turkey'){
            countryinitial = 'TR';
        }
        
        else if(country == 'Japan'){
            countryinitial = 'JA';
        }
        system.debug('countryinitial--'+countryinitial);
        PageReference pg;
        if(countryinitial!=null) {
            if(countryinitial=='BR'){
                pg = new pageReference('https://uconnect.openag.net/uplpartnerportal/login');
                //redirectURL=pg.getUrl();
                return pg.setRedirect(true);
            }
            else if(countryinitial=='IN'){
                pg = new PageReference('https://uconnect.openag.net/uplpartnerportal/login');
                //redirectURL=pg.getUrl();
                //pg = new PageReference('https://uconnect.openag.net/uplpartnerportal/login');
                system.debug('redirectURL---'+redirectURL);
                return pg.setRedirect(true);
            }
            else if(countryinitial=='MX'){
                pg = new PageReference('https://uconnect.openag.net/uplpartnerportal/login');
                // redirectURL=pg.getUrl();
                system.debug('redirectURL---'+redirectURL);
                return pg.setRedirect(true);
            }
            //If the user selects Argentina the snippet below
        	//renders the Argentina Community login page,GRZ(Gurubaksh Grewal) : APPS-1757 added on: 11-08-2022
			else if(countryinitial=='AR'){
                pg = new PageReference('https://uconnect.openag.net/uplpartnerportalstd/login');
                //pg = new PageReference('https://uat-upl.cs72.force.com/uplpartnerportalstd/login');
                // redirectURL=pg.getUrl();
                system.debug('redirectURL---'+redirectURL);
                return pg.setRedirect(true);
            }
            else if(countryinitial=='CH'){
                pg = new PageReference('https://uconnect.openag.net/uplpartnerportal/login');
                return pg.setRedirect(true);
            }
            else if(countryinitial=='CO'){
                pg = new pageReference('https://uconnect.openag.net/customers/s/login/?language=es_CO');
                // redirectURL=pg.getUrl();
                system.debug('redirectURL---'+redirectURL);
                return pg.setRedirect(true);
            }
            else if(countryinitial=='ES'){
                pg = new pageReference('https://uconnect.openag.net/customers/s/login/?language=es');
                // redirectURL=pg.getUrl();
                return pg.setRedirect(true);
            }
            else if(countryinitial=='PL'){
                pg = new pageReference('https://uconnect.openag.net/customers/s/login/?language=pl');
                // redirectURL=pg.getUrl();
                return pg.setRedirect(true);
            }
            else if(countryinitial=='PT'){
                pg = new pageReference('https://uconnect.openag.net/customers/s/login/?language=pt_PT');
                // redirectURL=pg.getUrl();
                system.debug('redirectURL---'+redirectURL);
                return pg.setRedirect(true);
            }
            else if(countryinitial=='TR'){
                pg = new pageReference('https://uconnect.openag.net/customers/s/login/?language=tr');
                // redirectURL=pg.getUrl();
                return pg.setRedirect(true);
            }
            else if(countryinitial=='JA'){
                pg = new pageReference('https://uconnect.openag.net/customers/s/login/?language=ja');
                // redirectURL=pg.getUrl();
                return pg.setRedirect(true);
            }
            
        } 
        system.debug('pg--'+pg);
        system.debug('test1--'+redirectURL);
        return null;
    }
    
    public void getIPGeolocation(){
        System.debug('Inside getipgeo');
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
        String userIPAddress = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
        String endpoint = 'http://ipinfo.io/'+userIPAddress+'/json';
        
        //String endpoint='http://ipinfo.io/217.61.20.213/json';
        
        request.setEndPoint(endpoint);
        request.setMethod('GET');
        HttpResponse response = httpProtocol.send(request);
        System.debug(response.getBody());
        JSONParser parser = JSON.createParser(response.getBody());
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'country')) {
                parser.nextToken();                
                strCountry = parser.getText();
                System.debug('strCountry : '+strCountry);
            }
        }
        System.debug('strCountry12 : '+strCountry);
        login(strCountry);
    }
    
    public string redirectURL{get;set;}
    public string countryURL{get;set;}
    
    public string login(string Input){
        system.debug('input'+Input);
        PageReference pg;
        if(Input!=null) {
            if(Input=='BR'){
                pg = new pageReference('https://uconnect.openag.net/uplpartnerportal/login');
                redirectURL=pg.getUrl();
            }
            else if(Input=='IN'){
                pg = new PageReference('https://uconnect.openag.net/uplpartnerportal/login');
                redirectURL=pg.getUrl();
                system.debug('redirectURL---'+redirectURL);
            }
            else if(Input=='MX'){
                pg = new PageReference('https://uconnect.openag.net/uplpartnerportal/login');
                redirectURL=pg.getUrl();
                system.debug('redirectURL---'+redirectURL);
            }
            else if(Input=='CH'){
                pg = new PageReference('https://uconnect.openag.net/uplpartnerportal/login');
                redirectURL=pg.getUrl();
                system.debug('redirectURL---'+redirectURL);
            }
            //If the user selects Argentina the snippet below
        	//renders the Argentina Community login page,GRZ(Gurubaksh Grewal) : APPS-1757 added on: 11-08-2022
			else if(Input=='AR'){
                pg = new PageReference('https://uconnect.openag.net/uplpartnerportalstd/login');
               // pg = new PageReference('https://uat-upl.cs72.force.com/uplpartnerportalstd/login');
                redirectURL=pg.getUrl();
                system.debug('redirectURL---'+redirectURL);
            }
            else if(Input=='CO'){
                pg = new pageReference('https://uconnect.openag.net/customers/s/login/?language=es_CO');
                redirectURL=pg.getUrl();
                system.debug('redirectURL---'+redirectURL);
            }
            else if(Input=='ES'){
                pg = new pageReference('https://uconnect.openag.net/customers/s/login/?language=es');
                redirectURL=pg.getUrl();
            }
            else if(Input=='PL'){
                pg = new pageReference('https://uconnect.openag.net/customers/s/login/?language=pl');
                redirectURL=pg.getUrl();
            }
            else if(Input=='PT'){
                pg = new pageReference('https://uconnect.openag.net/customers/s/login/?language=pt_PT');
                redirectURL=pg.getUrl();
                system.debug('redirectURL---'+redirectURL);
            }
            else if(Input=='TR'){
                pg = new pageReference('https://uconnect.openag.net/customers/s/login/?language=tr');
                redirectURL=pg.getUrl();
            }
            else if(Input=='JA'){
                pg = new pageReference('https://uconnect.openag.net/customers/s/login/?language=ja');
                redirectURL=pg.getUrl();
            }
            else{
                //pg = new PageReference ('/apex/Grz_countrySelection');                
                //pg = new pageReference('http://country-selector-uat.upl-ltd.com/new_country_selector.php');
                pg = new PageReference ('https://uplltd.secure.force.com/DistributorCountrySelection');
                redirectURL=pg.getUrl();
                //return pg.setRedirect(true);
            }
        } 
        system.debug('pg--'+pg);
        system.debug('redirectURL-- '+redirectURL);
        return redirectURL;
    }
}