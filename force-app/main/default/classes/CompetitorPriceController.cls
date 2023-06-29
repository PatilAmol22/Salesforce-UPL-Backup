public without sharing class CompetitorPriceController {
    
    public Static Id LoginUserID;
    public Static User currentUser;
    public Static String sales_org;
    
    
    
    /* public CompetitorPriceController(){

LoginUserID = UserInfo.getUserId();
System.debug('LoginUserID:---'+LoginUserID);

currentUser = [select id, Country from user where id =: UserInfo.getUserId() ];

// brandList=[SELECT Id, Name, Approved__c, Brand_Code__c, Sales_Org__c, Category__c FROM Brand__c where Approved__c=true];
// companyList=[select id, Name, Approved__c, Company_Code__c, Sales_Org__c from Company__c where Approved__c=true];
// packSizeList=[select id, Name, Approved__c, Pack_Size_Code__c, Sales_Org__c from Pack_Size__c where Approved__c=true];
// pestList=[select id, Name, Pest_Code__c, Sales_Org__c from Pest__c ];

if(String.IsNotBlank(currentUser.Country)){
if(currentUser.Country=='India'){
sales_org='1000';
}
else if(currentUser.Country=='SWAL'){
sales_org='1210';
}
else{
sales_org='';
}
}
System.debug('sales_org:---'+sales_org);
if(sales_org!=''){
//  cropList = [SELECT Id, Name FROM Crop__c where  Sales_Org_Code__c =:sales_org];
}

}*/
    
    @AuraEnabled
    public static List<Brand_Category__c> getBrandCategorys(){
        List <Brand_Category__c> lstBrandCategory = new List<Brand_Category__c>();
        lstBrandCategory = [SELECT Id, Name FROM Brand_Category__c order by Name asc];
        Map<String,Brand_Category__c> mapBrandCategory = new  Map<String,Brand_Category__c>();
        for(Brand_Category__c objs:lstBrandCategory){
            mapBrandCategory.put(objs.Name,objs);
        }
        return mapBrandCategory.values();
    }
    
    
    @AuraEnabled
    public static List<Product_Detail__c> getBrandList(){
        
        List<Product_Detail__c> groupedResults =[SELECT Id, Name, Formulation__c,Formulation__r.Name, Company__c, Company__r.Name, Brand__c, 
                                                 Brand__r.Name, Brand_Approved__c, Company_Approved__c, Formulation_Approved__c 
                                                 FROM Product_Detail__c where Brand_Approved__c=true AND Company__c != '' AND Formulation__c !='' AND Brand__c !='' order by Brand__r.Name asc]; 
        
        Map<String,Product_Detail__c> brndMap=new Map<String,Product_Detail__c>();
        
        for(Product_Detail__c PD:groupedResults){
            brndMap.put(PD.Brand__r.Name,PD);//This is map and hence it will always have unique values 
        }
        
        return brndMap.values();
        
        /*return [SELECT Id, Name, Formulation__c,Formulation__r.Name, Company__c, Company__r.Name, Brand__c, 
Brand__r.Name, Brand_Approved__c, Company_Approved__c, Formulation_Approved__c 
FROM Product_Detail__c where Brand_Approved__c=true order by Brand__r.Name asc]; */
    }
    
    @AuraEnabled
    public static List<Product_Detail__c> getCmpnyList(){
        List<Product_Detail__c> groupedResults =[SELECT Id, Name, Formulation__c,Formulation__r.Name, Company__c, Company__r.Name, Brand__c, 
                                                 Brand__r.Name, Brand_Approved__c, Company_Approved__c, Formulation_Approved__c 
                                                 FROM Product_Detail__c where Company_Approved__c=true AND Company__c != '' AND Formulation__c !='' AND Brand__c !='' order by Company__r.Name asc]; 
        
        Map<String,Product_Detail__c> cmpnyMap=new Map<String,Product_Detail__c>();
        
        for(Product_Detail__c PD:groupedResults){
            System.debug('PD.Company__r.Name '+PD.Company__r.Name);
            cmpnyMap.put(PD.Company__r.Name,PD);//This is map and hence it will always have unique values 
        }
        
        return cmpnyMap.values();
        /* return [SELECT Id, Name, Formulation__c,Formulation__r.Name, Company__c, Company__r.Name, Brand__c, 
Brand__r.Name, Brand_Approved__c, Company_Approved__c, Formulation_Approved__c 
FROM Product_Detail__c where Company_Approved__c=true order by Company__r.Name asc]; */
    }
    
    @AuraEnabled
    public static List<Pack_Size__c> getPackList(String searchKeyWordPackSize){
        List <Pack_Size__c> returnList = new List <Pack_Size__c> ();
        
        
        String usrID = UserInfo.getUserId();
        User userObj = new User();
        userObj = [Select Id,Country From User WHERE Id=: usrID];
        String countryName =userObj.Country;
        String cntryNm ='';
        
        if(countryName=='India' || countryName=='SWAL'){
            cntryNm = 'India';
        }
        
        if(countryName == 'Spain' || countryName=='Portugal' || countryName =='Naturagri Spain'){
            cntryNm ='Iberia';
        }
        String sQuery ='';
        if(searchKeyWordPackSize.length()== 0){
            sQuery = 'select id, Name, Approved__c, Pack_Size_Code__c, Sales_Org__c from Pack_Size__c WHERE Country_Name__c=:cntryNm AND Approved__c = true ';
        }else{
            sQuery = 'select id, Name, Approved__c, Pack_Size_Code__c, Sales_Org__c from Pack_Size__c WHERE Country_Name__c=:cntryNm AND Name like \'%'+searchKeyWordPackSize+'%\'AND Approved__c = true ' ;
        }
        List <Pack_Size__c> lstOfRecords = Database.query(sQuery);
        for (Pack_Size__c obj: lstOfRecords) {
            returnList.add(obj); 
        }
        Map<String,Pack_Size__c> cmpMap=new Map<String,Pack_Size__c>();
        
        for(Pack_Size__c PD:returnList){
            cmpMap.put(PD.Name,PD);//This is map and hence it will always have unique values 
        }
        return cmpMap.values();
        
    }
    
    @AuraEnabled
    public static Product_Detail__c formulationDetails(String brnd_id, String cmpny_id){
        
        Product_Detail__c pd= new Product_Detail__c();
        
        pd= [SELECT Id, Name, Formulation__c,Formulation__r.Name, Company__c, Company__r.Name, Brand__c, 
             Brand__r.Name, Brand_Approved__c, Company_Approved__c, Formulation_Approved__c 
             FROM Product_Detail__c where Formulation_Approved__c=true AND Brand__c=:brnd_id AND Company__c=:cmpny_id limit 1];
        
        
        return pd;
        
        
    }
    
    @AuraEnabled
    public static List<Product_Detail__c> getBrandListOnCmpny(String cmpnyId){
        System.debug('getBrandListOnCmpny brand list is '+cmpnyId);
        return [SELECT Id, Name, Formulation__c,Formulation__r.Name, Company__c, Company__r.Name, Brand__c, 
                Brand__r.Name, Brand_Approved__c, Company_Approved__c, Formulation_Approved__c 
                FROM Product_Detail__c where Brand_Approved__c=true AND Company_Approved__c=true AND Company__c=:cmpnyId order by Brand__r.Name asc];
    }
    
    @AuraEnabled
    public static Product_Detail__c getCmpnyListOnBrnd(String brndId){
        Product_Detail__c pd1= new Product_Detail__c();
        pd1 = [SELECT Id, Name, Formulation__c,Formulation__r.Name, Company__c, Company__r.Name, Brand__c, 
               Brand__r.Name, Brand_Approved__c, Company_Approved__c, Formulation_Approved__c 
               FROM Product_Detail__c where Company_Approved__c=true AND Brand_Approved__c=true AND Brand__c=:brndId order by Company__r.Name asc LIMIT 1];
        
        return pd1;
        
        
        /*return [SELECT Id, Name, Formulation__c,Formulation__r.Name, Company__c, Company__r.Name, Brand__c, 
Brand__r.Name, Brand_Approved__c, Company_Approved__c, Formulation_Approved__c 
FROM Product_Detail__c where Company_Approved__c=true AND Brand_Approved__c=true AND Brand__c=:brndId order by Company__r.Name asc LIMIT 1];*/
    }
    
    @AuraEnabled
    public static List<Crop__c> cropList(String searchKeyWordCrop){
        System.debug('searchKeyWordCrop '+searchKeyWordCrop);
        List <Crop__c> returnList = new List <Crop__c> ();
        Map<String,Crop__c> cmpMap=new Map<String,Crop__c>();
        LoginUserID = UserInfo.getUserId();
        System.debug('LoginUserID:---'+LoginUserID);
        List<Crop__c> cropList=new List<Crop__c>();
        currentUser = [select Id, country from user where Id =: userInfo.getUserId() limit 1 ];
        String sQuery ='';
        //System.debug('currentUser.Country '+currentUser.Country);
        
        if(String.IsNotBlank(currentUser.country)){
            if(currentUser.country =='India'){
                if(searchKeyWordCrop.length() == 0){
                    sQuery = 'SELECT Id, Name FROM Crop__c where  Sales_Org_Code__c =\'1000\' order by Name asc';
                }else{
                    sQuery = 'SELECT Id, Name FROM Crop__c WHERE Name like \'%'+searchKeyWordCrop+'%\' AND  Sales_Org_Code__c =\'1000\' order by Name asc';
                }
                
            }
            if(currentUser.country=='SWAL'){
                if(searchKeyWordCrop.length()== 0){
                    sQuery = 'SELECT Id, Name FROM Crop__c where  Sales_Org_Code__c =\'1210\' order by Name asc';
                }else{
                    sQuery = 'SELECT Id, Name FROM Crop__c WHERE Name like \'%'+searchKeyWordCrop+'%\' AND  Sales_Org_Code__c =\'1210\' order by Name asc';
                }
            }
            
            //newly added patch for Spain and Portugal
            // for Spain
            if(currentUser.country=='Spain'){
                // change the sales org code
                if(searchKeyWordCrop.length()== 0){
                    sQuery = 'SELECT Id, Name FROM Crop__c where  Sales_Org_Code__c =\'2510\' order by Name asc';
                }else{
                    sQuery = 'SELECT Id, Name FROM Crop__c WHERE Name like \'%'+searchKeyWordCrop+'%\' AND  Sales_Org_Code__c =\'2510\' order by Name asc';
                }
            }
            
            if(currentUser.country=='Portugal'){
                // change the sales org code
                if(searchKeyWordCrop.length()== 0){
                    sQuery = 'SELECT Id, Name FROM Crop__c where  Sales_Org_Code__c =\'2510\' order by Name asc';
                }else{
                // changes made by vishal UPL-CR131  changes from 2520 to 2481
                    sQuery = 'SELECT Id, Name FROM Crop__c WHERE Name like \'%'+searchKeyWordCrop+'%\' AND  Sales_Org_Code__c =\'2481\' order by Name asc';
                }
            }
            
            if(currentUser.country=='Naturagri Spain'){
                // change the sales org code
                if(searchKeyWordCrop.length()== 0){
                    sQuery = 'SELECT Id, Name FROM Crop__c where  Sales_Org_Code__c =\'2510\' order by Name asc';
                }else{
                    sQuery = 'SELECT Id, Name FROM Crop__c WHERE Name like \'%'+searchKeyWordCrop+'%\' AND  Sales_Org_Code__c =\'2541\' order by Name asc';
                }
            }
            
            
            List <Crop__c> lstOfRecords = Database.query(sQuery);
            System.debug('@@@@ lstOfRecords '+lstOfRecords);
            
            for (Crop__c obj: lstOfRecords) {
                returnList.add(obj);
            }
            
            
            for(Crop__c PD:returnList){
                cmpMap.put(PD.Name,PD);//This is map and hence it will always have unique values 
            }
            
            
        }
        return cmpMap.values();
        
    }
    
    @AuraEnabled
    public static List<Pest__c> pestList(String searchKeyWordPest){
        List <Pest__c> returnList = new List <Pest__c> ();
        Map<String,Pest__c> pstMap=new Map<String,Pest__c>();
        String sQuery ='';
        if(searchKeyWordPest.length()== 0){
            sQuery = 'select id, Name, Pest_Code__c, Sales_Org__c from Pest__c order by Name asc LIMIT 20';
        }else{
            sQuery = 'select id, Name, Pest_Code__c, Sales_Org__c from Pest__c WHERE Name like \'%'+searchKeyWordPest+'%\'' ;
        }
        List <Pest__c> lstOfRecords = Database.query(sQuery);
        for (Pest__c obj: lstOfRecords) {
            returnList.add(obj);
        }
        for(Pest__c PS:returnList){
            pstMap.put(PS.Name,PS);//This is map and hence it will always have unique values 
        }
        return pstMap.values();
    }
    
    
    
    @AuraEnabled
    public static Brand__c newBrandEntry(String brnd_nm, String cat){
        List<Brand__c> brndList= new List<Brand__c>();
        Brand__c brnd= new Brand__c();
        brndList=[Select Id, Name from Brand__c where Name=:brnd_nm AND Approved__c=true];
        if(brndList.size() == 0){
            System.debug('Cat val--- '+cat.length());
            brnd.Name = brnd_nm;
            //brnd.Brand_Code__c = cod;
            if(cat.length()!=0){
                brnd.Brand_Category__c = cat;
            }
            insert brnd;
        }
        else{
            return null;
        }
        return brnd;
    }
    
    @AuraEnabled
    public static Company__c newCmpnyEntry(String cmpny_nm, String site){
        List<Company__c> cmpnyList= new List<Company__c>();
        Company__c cmpny= new Company__c();
        cmpnyList=[Select id, Name from Company__c where Name=:cmpny_nm AND Approved__c=true];
        if(cmpnyList.size() == 0){
            cmpny.Name = cmpny_nm;
            //  cmpny.Company_code__c = cod;
            cmpny.web_site__c = site;
            
            insert cmpny;
        }
        else{
            return null;
        }
        
        return cmpny;
    }
    
    @AuraEnabled
    public static Formulation__c newFrmltnEntry(String frml_nm,String brnd_id, String cmpny_id){
        System.debug('newFrmltnEntry called.. frml_nm '+frml_nm);
        System.debug('newFrmltnEntry called..brnd_id '+brnd_id);
        System.debug('newFrmltnEntry called..cmpny_id '+cmpny_id);
        Formulation__c frmltn= new Formulation__c();
        frmltn.Name = frml_nm;
        //  frmltn.Formulation_Code__c = cod;
        frmltn.Brand__c = brnd_id;
        frmltn.Company__c = cmpny_id;
        
        insert frmltn;
        System.debug('newFrmltnEntry ..'+ frmltn.id);
        
        return frmltn;
    }
    
    @AuraEnabled
    public static Pack_Size__c newPacktnEntry(String name){
        
        Pack_Size__c pck= new Pack_Size__c();
        pck.Name = name;
        //  pck.Pack_Size_Code__c = cod;
        
        insert pck;
        
        return pck;
    }
    
    
    
    @AuraEnabled
    public static String newCompetitorEntry(sObject c_pricObjt, String updateLabel, String comPriceId){
        
        String result='';
        Id sales_org_id;
        Id territory_id;
        Id compID=comPriceId;
        Competitor_Price__c compPrice = new Competitor_Price__c();
        List<Update_Label_Claim__c> updateLabelsList = new List<Update_Label_Claim__c>();
        Competitor_Price__c cp_price= new Competitor_Price__c();
        LoginUserID = UserInfo.getUserId();
        System.debug('LoginUserID:---'+LoginUserID);
        currentUser = [select id, Country from user where id =: UserInfo.getUserId() ];
        System.debug('currentUser:---'+currentUser);
        
        if(String.IsNotBlank(currentUser.Country)){
            if(currentUser.Country=='India'){
                sales_org='1000';
            }
            else if(currentUser.Country=='SWAL'){
                sales_org='1210';
            }else if(currentUser.Country=='Spain'){
                sales_org='2510';
            }else if(currentUser.Country=='Portugal'){
            // changes made by vishal UPL-CR131  changes from 2520 to 2481
                sales_org='2481';
            }else if(currentUser.Country=='Naturagri Spain'){
                sales_org='2541';
            }else{
                sales_org='';
            }
        }
        
        try{
            if(sales_org!=''){
                Sales_Org__c org = [select id,Sales_Org_Code__c from Sales_Org__c where Sales_Org_Code__c=:sales_org limit 1];
                sales_org_id=org.id;
                System.debug('sales_org_id:---'+sales_org_id);
                // changes made by vishal UPL-CR131  changes from 2520 to 2481
                if(org.Sales_Org_Code__c =='2510' || org.Sales_Org_Code__c =='2481' || org.Sales_Org_Code__c =='2541'){
                    System.debug('Inside Spain another ');
                    territory_id= null;
                }else{
                    System.debug('outside Spain another ');
                    Territory_Distributor__c ter= [select id,Name from Territory_Distributor__c where TerritoryManager__c=:LoginUserID];
                    territory_id= ter.id;  
                }
                
                
                System.debug('territory_id:---'+territory_id);
                System.debug('After all Save '+c_pricObjt);
                System.debug('comPriceId:---'+comPriceId);
                System.debug('updatelabel:---'+updateLabel);
                
                if(comPriceId==null){
                    if(c_pricObjt != null || test.isRunningTest()){
                        
                        compPrice = (Competitor_Price__c) c_pricObjt; 
                        
                        // cp_price= new Competitor_Price__c();
                        cp_price.Reporting_Type__c = compPrice.Reporting_Type__c;//compPrice.reporting_tp;
                        cp_price.Brand__c = compPrice.Brand__c;//compPrice.brand;
                        
                        System.debug('compPrice.Company__c  '+compPrice.Company__c);
                        cp_price.Company__c = compPrice.Company__c;//compPrice.company;
                        cp_price.Formulation__c = compPrice.Formulation__c;//compPrice.formulation;
                        cp_price.Sales_Org__c = sales_org_id;
                        cp_price.Territory__c = territory_id;
                        System.debug('cp_price:---'+cp_price);
                        insert cp_price;
                        compID=cp_price.id;
                        
                        List<Product_Detail__c> pdList=new List<Product_Detail__c>();
                        pdList=[Select id,Brand__c,Company__c,Formulation__c from Product_Detail__c where
                                Brand__c=:compPrice.Brand__c AND Company__c=:compPrice.Company__c 
                                AND Formulation__c=:compPrice.Formulation__c];
                        System.debug('Pd List- '+pdList);
                        
                        if(pdList.size()==0){
                            Product_Detail__c pd=new Product_Detail__c();
                            pd.Brand__c=compPrice.Brand__c;
                            pd.Company__c=compPrice.Company__c;
                            pd.Formulation__c=compPrice.Formulation__c;
                            pd.Territory__c=territory_id;
                            insert pd;
                        }
                        
                        
                        result=compID;
                    }
                }
                
                if(updateLabel != null){
                    List<UpdateClaim> updateList = (List<UpdateClaim>)JSON.deserialize(updateLabel, List<UpdateClaim>.class) ;     
                    if(updateList.size()>0){
                        for(UpdateClaim pd : updateList){
                            Update_Label_Claim__c ulc = new Update_Label_Claim__c();
                            ulc.Competitor_Price__c= compID;
                            ulc.Crop__c= pd.crp;
                            ulc.Dose__c= pd.dos;
                            ulc.UOM__c= pd.uom;
                            ulc.Per_Acre_Cost__c= pd.acr_cst;
                            ulc.Pest__c= pd.pst;
                            ulc.Sales_Org__c= sales_org_id;
                            ulc.Territory__c= territory_id;
                            
                            updateLabelsList.add(ulc);
                        }
                    }
                    System.debug('updateLabelsList:---'+updateLabelsList);
                }
                
                if(!updateLabelsList.isEmpty()){
                    insert updateLabelsList;
                    result=compID;
                }
                
                if(compID!=null){
                    List<Price_Scheme_Detail__c> psd= new List<Price_Scheme_Detail__c>();
                    psd=[select Id,Comment__c,Competitor_Price__c,Distributor_Price__c,Farmer_Price__c,MRP__c,
                         Pack_Size__c,Pack_Size__r.Name, Retailer_Price__c,Scheme__c from Price_Scheme_Detail__c 
                         where status__c='Draft' AND Competitor_Price__c=:compID];
                    if(psd.size()>0){
                        for(Price_Scheme_Detail__c sd:psd){
                            sd.status__c='Completed';
                        }
                        update psd;
                        
                    }
                    result=compID;
                }  
                
            }
        }
        catch(Exception e){
            System.debug('Exception occured--- '+ e);
            return null;
        } 
        System.debug('Result-'+ result);
        return result;
    }
    
    @AuraEnabled
    public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId,integer imagelength,string imageNamelabel) {
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert, 
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with reamins chunks   
        system.debug('imagelength>>---> '+imagelength);
        if (fileId == '') {
            fileId = saveTheFile(parentId, fileName, base64Data, contentType,imagelength,imageNamelabel);
        } else {
            appendToFile(fileId, base64Data);
        }
        return Id.valueOf(fileId);
    }
    
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType ,integer counter,string imageNamelabel) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        Attachment oAttachment = new Attachment();
        oAttachment.parentId = parentId;
        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.Name = fileName;
        oAttachment.ContentType = contentType;
        insert oAttachment;
        
        string imageName = imageNamelabel;
        string url = '/servlet/servlet.FileDownload?file=';
        system.debug('counter ClassController>>--->'+counter);
        Price_Scheme_Detail__c priceSchDetlObj = new Price_Scheme_Detail__c();
        if(counter == 1 && imageName == 'scheme'){
            priceSchDetlObj = [Select Id,Scheme_Image_1__c FROM Price_Scheme_Detail__c WHERE id =:parentId];
            priceSchDetlObj.Scheme_Image_1__c = url+''+oAttachment.id;
            system.debug('counter>>--->'+counter);
        }
        if(counter == 2 && imageName == 'scheme'){
            priceSchDetlObj = [Select Id,Scheme_Image_2__c FROM Price_Scheme_Detail__c WHERE id =:parentId]; 
            priceSchDetlObj.Scheme_Image_2__c =  url+''+oAttachment.id;
        }
        if(counter == 3 && imageName == 'scheme'){
            priceSchDetlObj = [Select Id,Scheme_Image_3__c FROM Price_Scheme_Detail__c WHERE id =:parentId]; 
            priceSchDetlObj.Scheme_Image_3__c =  url+''+oAttachment.id;
            system.debug('counter>>--->'+counter);
        }
        if(counter == 4  && imageName == 'scheme' ){
            priceSchDetlObj = [Select Id,Scheme_Image_4__c FROM Price_Scheme_Detail__c WHERE id =:parentId];   
            priceSchDetlObj.Scheme_Image_4__c = url+''+oAttachment.id;
            system.debug('counter>>--->'+counter);
        }
        if(counter == 5  && imageName == 'scheme'){
            priceSchDetlObj = [Select Id,Scheme_Image_5__c FROM Price_Scheme_Detail__c WHERE id =:parentId]; 
            priceSchDetlObj.Scheme_Image_5__c = url+''+oAttachment.id;
            system.debug('counter>>--->'+counter);
        }
        
        
        if(counter == 1 && imageName == 'packshot'){
            priceSchDetlObj = [Select Id,Pack_Image_1__c FROM Price_Scheme_Detail__c WHERE id =:parentId];  
            priceSchDetlObj.Pack_Image_1__c =  url+''+oAttachment.id;
            system.debug('counter>>--->'+counter);
        }
        if(counter == 2 && imageName == 'packshot'){
            priceSchDetlObj = [Select Id,Pack_Image_2__c FROM Price_Scheme_Detail__c WHERE id =:parentId];   
            priceSchDetlObj.Pack_Image_2__c =  url+''+oAttachment.id;
        }
        if(counter == 3 && imageName == 'packshot'){
            priceSchDetlObj = [Select Id,Pack_Image_3__c FROM Price_Scheme_Detail__c WHERE id =:parentId]; 
            priceSchDetlObj.Pack_Image_3__c =  url+''+oAttachment.id;
            system.debug('counter>>--->'+counter);
        }
        if(counter == 4  && imageName == 'packshot' ){
            priceSchDetlObj = [Select Id,Pack_Image_4__c FROM Price_Scheme_Detail__c WHERE id =:parentId];   
            priceSchDetlObj.Pack_Image_4__c =  url+''+oAttachment.id;
            system.debug('counter>>--->'+counter);
        }
        if(counter == 5  && imageName == 'packshot'){
            priceSchDetlObj = [Select Id,Pack_Image_5__c FROM Price_Scheme_Detail__c WHERE id =:parentId];
            priceSchDetlObj.Pack_Image_5__c =  url+''+oAttachment.id;
            system.debug('counter>>--->'+counter);
        }
        
        if(counter == 1 && imageName == 'label'){
            priceSchDetlObj = [Select Id,Label_Image_1__c FROM Price_Scheme_Detail__c WHERE id =:parentId];  
            priceSchDetlObj.Label_Image_1__c =  url+''+oAttachment.id;
            system.debug('counter>>--->'+counter);
        }
        if(counter == 2 && imageName == 'label'){
            priceSchDetlObj = [Select Id,Label_Image_2__c FROM Price_Scheme_Detail__c WHERE id =:parentId];   
            priceSchDetlObj.Label_Image_2__c = url+''+oAttachment.id;
        }
        if(counter == 3 && imageName == 'label'){
            priceSchDetlObj = [Select Id,Label_Image_3__c FROM Price_Scheme_Detail__c WHERE id =:parentId]; 
            priceSchDetlObj.Label_Image_3__c =  url+''+oAttachment.id;
            system.debug('counter>>--->'+counter);
        }
        if(counter == 4  && imageName == 'label' ){
            priceSchDetlObj = [Select Id,Label_Image_4__c FROM Price_Scheme_Detail__c WHERE id =:parentId];   
            priceSchDetlObj.Label_Image_4__c = url+''+oAttachment.id;
            system.debug('counter>>--->'+counter);
        }
        if(counter == 5  && imageName == 'label'){
            priceSchDetlObj = [Select Id,Label_Image_5__c FROM Price_Scheme_Detail__c WHERE id =:parentId];
            priceSchDetlObj.Label_Image_5__c =  url+''+oAttachment.id; 
            system.debug('counter>>--->'+counter);
        }
        if(priceSchDetlObj != Null){
            system.debug('imageName>>--->'+imageName);
            system.debug('counter>>--->'+counter);
            update priceSchDetlObj;
        }
        
        return oAttachment.Id;
    }
    
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        Attachment a = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id =: fileId
        ];
        
        String existingBody = EncodingUtil.base64Encode(a.Body);
        
        a.Body = EncodingUtil.base64Decode(existingBody + base64Data);
        
        update a;
    }
    
    @AuraEnabled
    public static Price_Scheme_Detail__c saveCPEntry(sObject c_pricObjt, sObject schemeObjt, String comPriceId){
        
        System.debug('c_pricObjt '+c_pricObjt);
        String result='false';
        Id compId=comPriceId;
        Id sales_org_id;
        Id territory_id;
        Competitor_Price__c compPrice = new Competitor_Price__c();
        Competitor_Price__c cp_price= new Competitor_Price__c();
        Price_Scheme_Detail__c psd = new Price_Scheme_Detail__c();
        Price_Scheme_Detail__c pDetails = new Price_Scheme_Detail__c();
        Price_Scheme_Detail__c psd1=new Price_Scheme_Detail__c();
        LoginUserID = UserInfo.getUserId();
        System.debug('LoginUserID:---'+LoginUserID);
        currentUser = [select id, Country from user where id =: UserInfo.getUserId() ];
        System.debug('currentUser:---'+currentUser);
        
        if(String.IsNotBlank(currentUser.Country)){
            if(currentUser.Country=='India'){
                sales_org='1000';
            }
            else if(currentUser.Country=='SWAL'){
                sales_org='1210';
            }else if(currentUser.Country=='Spain'){
                 sales_org='2510';
            }else if(currentUser.Country=='Portugal'){
            // changes made by vishal UPL-CR131  changes from 2520 to 2481
                 sales_org='2481';
            }else if(currentUser.Country=='Naturagri Spain'){
                 sales_org='2541';
            }
            else{
                sales_org='';
            }
        }
        
        try {
            
            if(sales_org!=''){
                Sales_Org__c org = [select id,Sales_Org_Code__c from Sales_Org__c where Sales_Org_Code__c=:sales_org limit 1];
                sales_org_id=org.id;
                System.debug('org.Sales_Org_Code__c '+org.Sales_Org_Code__c);
                // changes made by vishal UPL-CR131  changes from 2520 to 2481
                if(org.Sales_Org_Code__c =='2510' || org.Sales_Org_Code__c=='2481' || org.Sales_Org_Code__c=='2541'){
                    System.debug('Inside Spain ');
                    territory_id= null;
                }else{
                    System.debug('outside Spain ');
                    Territory_Distributor__c ter= [select id,Name from Territory_Distributor__c where TerritoryManager__c=:LoginUserID];    
                    territory_id= ter.id;
                    
                }
                
               
                
                if(comPriceId==null){
                    if(c_pricObjt != null){
                        
                        compPrice = (Competitor_Price__c) c_pricObjt; 
                        
                        // cp_price= new Competitor_Price__c();
                        cp_price.Reporting_Type__c = compPrice.Reporting_Type__c;//compPrice.reporting_tp;
                        cp_price.Brand__c = compPrice.Brand__c;//compPrice.brand;
                        System.debug('compPrice.Company__c '+compPrice.Company__c);
                        System.debug('compPrice.Brand__c '+compPrice.Brand__c);
                        cp_price.Company__c = compPrice.Company__c;//compPrice.company;
                        cp_price.Formulation__c = compPrice.Formulation__c;//compPrice.formulation;
                        cp_price.Sales_Org__c = sales_org_id;
                        cp_price.Territory__c = territory_id;
                        
                        System.debug('cp_price:---'+cp_price);
                        insert cp_price;
                        List<Product_Detail__c> pdList=new List<Product_Detail__c>();
                        pdList=[Select id,Brand__c,Company__c,Formulation__c from Product_Detail__c where
                                Brand__c=:compPrice.Brand__c AND Company__c=:compPrice.Company__c 
                                AND Formulation__c=:compPrice.Formulation__c];
                        System.debug('Pd List- '+pdList);
                        
                        if(pdList.size()==0){
                            Product_Detail__c pd=new Product_Detail__c();
                            pd.Brand__c=compPrice.Brand__c;
                            pd.Company__c=compPrice.Company__c;
                            pd.Formulation__c=compPrice.Formulation__c;
                            pd.Territory__c=territory_id;
                            insert pd;
                        }
                        
                        compId=cp_price.id;
                        result='true';
                    }
                }
                
                if(schemeObjt != null){
                    pDetails = (Price_Scheme_Detail__c) schemeObjt;
                    psd.Comment__c = pDetails.Comment__c;
                    psd.Competitor_Price__c = compId;//cp_price.id;
                    psd.Distributor_Price__c = pDetails.Distributor_Price__c;
                    psd.Farmer_Price__c = pDetails.Farmer_Price__c;
                    psd.MRP__c = pDetails.MRP__c;
                    System.debug(' pDetails.Pack_Size__c '+pDetails.Pack_Size__c);
                    psd.Pack_Size__c = pDetails.Pack_Size__c;
                    psd.Retailer_Price__c = pDetails.Retailer_Price__c;
                    psd.Sales_Org__c = sales_org_id;
                    psd.Scheme__c = pDetails.Scheme__c;
                    psd.Territory__c = territory_id;
                    psd.Status__c = 'Draft';
                    if(psd!=null){
                        insert psd;
                        psd1= [select Id,Comment__c,Competitor_Price__c,Distributor_Price__c,Farmer_Price__c,MRP__c,
                               Pack_Size__c,Pack_Size__r.Name, Retailer_Price__c,Scheme__c from Price_Scheme_Detail__c where id=:psd.id];
                    }   
                    System.debug('price:---'+psd);
                    System.debug('price:---'+psd1);
                    
                }
                
            }
        }
        catch(Exception e){
            System.debug('Exception occured--- '+ e);
            System.debug('Exception occured--- '+ e.getLineNumber());
            System.debug('Exception occured--- '+ e.getMessage());
            return null;
        } 
        if(psd1!=null){
            return psd1;
        }
        else{
            return null;
        }
    }
    
    @AuraEnabled
    public static Boolean deletePriceEntry(String price_id){
        
        Boolean result=false;
        
        if(price_id!=null){
            Price_Scheme_Detail__c psd= new Price_Scheme_Detail__c();
            psd=[select Id,Comment__c,Competitor_Price__c,Distributor_Price__c,Farmer_Price__c,MRP__c,
                 Pack_Size__c,Pack_Size__r.Name, Retailer_Price__c,Scheme__c from Price_Scheme_Detail__c where id=:price_id];
            delete psd;
            result= true;
        }
        
        return result;
    }
    
    
    @AuraEnabled
    public static Boolean cancelPriceEntry(String compPriceId){
        System.debug('cancelPriceEntry..'); 
        Boolean result=false;
        System.debug('Id..'+ compPriceId);
        if(compPriceId!=null){
            List<Price_Scheme_Detail__c> psd= new List<Price_Scheme_Detail__c>();
            psd=[select Id,Comment__c,Competitor_Price__c,Distributor_Price__c,Farmer_Price__c,MRP__c,
                 Pack_Size__c,Pack_Size__r.Name, Retailer_Price__c,Scheme__c from Price_Scheme_Detail__c 
                 where status__c='Draft' AND Competitor_Price__c=:compPriceId];
            System.debug('psd..'+psd); 
            if(psd.size()>0){
                delete psd;
                result= true;
            }
            
            List<Competitor_Price__c> cpd= new List<Competitor_Price__c>(); 
            cpd=[Select id, Name from Competitor_Price__c where id=:compPriceId];
            System.debug('cpd..'+cpd);
            if(cpd.size()>0){
                delete cpd;
            }
            
        }
        
        return result;
    }
    
    
    @AuraEnabled
    public static List<UpdateClaim> updateClaimList(String brandId){
        
        List<UpdateClaim> ucl=new List<UpdateClaim>();
        List<Update_Label_Claim__c> ucList= new List<Update_Label_Claim__c>();
        
        if(brandId!=null){
            ucList=[Select Id,Name,Crop__c,Crop__r.Name,Pest__c,Pest__r.Name,Dose__c,UOM__c,Per_Acre_Cost__c,Sales_Org__c,
                    Territory__c,Competitor_Price__c,Competitor_Price__r.Brand__c from Update_Label_Claim__c 
                    where Competitor_Price__r.Brand__c=:brandId];
        }
        
        if(ucList.size()>0 || test.isRunningTest()){
            for(Update_Label_Claim__c ulc:ucList){
                UpdateClaim upClaim= new UpdateClaim();
                upClaim.copetitorPrice=ulc.Competitor_Price__c;
                upClaim.crp=ulc.Crop__c;
                upClaim.dos=ulc.Dose__c;
                upClaim.uom=ulc.UOM__c;
                upClaim.acr_cst=ulc.Per_Acre_Cost__c;
                upClaim.pst=ulc.Pest__c;
                upClaim.sales_org=ulc.Sales_Org__c;
                upClaim.territory=ulc.Territory__c;
                upClaim.crpNm=ulc.Crop__r.Name;
                upClaim.pstNm=ulc.Pest__r.Name;
                upClaim.brand_Id=ulc.Competitor_Price__r.Brand__c;
                ucl.add(upClaim);
            }
        }
        if(ucl.size()>0){
            return ucl;
        }
        else{
            return null;
        }
    }
    
    
    
    
    @AuraEnabled
    public static List<Product_Detail__c> getformulationList(){
        
        List<Product_Detail__c> pd= new List<Product_Detail__c>();
        Map<String ,Product_Detail__c> formulationMap = new Map<String ,Product_Detail__c>();
        try{
            pd= [SELECT Id, Name, Formulation__c,Formulation__r.Name, Company__c, Company__r.Name, Brand__c, 
                 Brand__r.Name, Brand_Approved__c, Company_Approved__c, Formulation_Approved__c 
                 FROM Product_Detail__c 
                 where Formulation_Approved__c=true 
                 AND Company__c != '' 
                 AND Formulation__c !='' 
                 AND Brand__c !='' ORDER BY Formulation__r.Name ASC NULLS LAST];  
            
            for(Product_Detail__c PDObj:pd){
                formulationMap.put(PDObj.Formulation__r.Name,PDObj);//This is map and hence it will always have unique values 
            }
            
            if(pd.size()>0){
                return formulationMap.values();
            }
            else{
                return null;
            }
        }catch(DmlException e){
            System.debug('The following exception has occurred: ' + e.getMessage());
            System.debug('The following exception has occurred: ' + e.getLineNumber());
            return null;
        }
        
    }
    
    //Added by vishal 
    @AuraEnabled
    public static List<Product_Detail__c> fetchBrandList(String searchKeyWordBrand){
        System.debug('searchKeyWordBrand in class '+searchKeyWordBrand.length());
        List <Product_Detail__c> returnList = new List <Product_Detail__c> ();
        String usrID = UserInfo.getUserId();
        User userObj = new User();
        userObj = [Select Id,Country From User WHERE Id=: usrID];
        String countryName =userObj.Country;
        String cntryNm ='';
        
        if(countryName=='India' || countryName=='SWAL'){
            cntryNm = 'India';
        }
        
        if(countryName == 'Spain' || countryName=='Portugal' || countryName =='Naturagri Spain'){
            cntryNm ='Iberia';
        }
        
        
        String sQuery ='';
        if(searchKeyWordBrand.length()==0){
            returnList =[SELECT Id, Name, Formulation__c,Formulation__r.Name, Company__c, Company__r.Name, Brand__c, 
                         Brand__r.Name, Brand_Approved__c, Company_Approved__c, Formulation_Approved__c 
                         FROM Product_Detail__c 
                         where Brand_Approved__c=true 
                         AND Company__c != '' 
                         AND Formulation__c !='' 
                         AND Brand__c !='' 
                         AND Country_Name__c=:cntryNm order by Brand__r.Name asc LIMIT 30]; 
        }else{
            sQuery ='SELECT Id, Name, Formulation__c,Formulation__r.Name, Company__c, Company__r.Name, Brand__c, Brand__r.Name, Brand_Approved__c, Company_Approved__c, Formulation_Approved__c  FROM Product_Detail__c where Country_Name__c=:cntryNm AND Company__c =\''+searchKeyWordBrand+'\'  AND Brand_Approved__c=true  AND Formulation__c !=\'\' AND Brand__c !=\'\'  ';
            
            System.debug('sQuery '+sQuery);
            List <Product_Detail__c> lstOfRecords = Database.query(sQuery);
            
            for (Product_Detail__c obj: lstOfRecords) {
                returnList.add(obj);
            }
            
            
            
        }// end of else part
        
        Map<String,Product_Detail__c> brndMap=new Map<String,Product_Detail__c>();
        
        for(Product_Detail__c PD:returnList){
            brndMap.put(PD.Brand__r.Name,PD);//This is map and hence it will always have unique values 
        }
        System.debug('brndMap.values() in Brand List '+brndMap.values());
        return brndMap.values();
        
        
    }    
    
    
    
    @AuraEnabled
    public static List<Product_Detail__c> fetchCompanyList(String searchKeyWordCompany){
        
             
        String usrID = UserInfo.getUserId();
        User userObj = new User();
        userObj = [Select Id,Country From User WHERE Id=: usrID];
        String countryName =userObj.Country;
        String cntryNm ='';
        
        if(countryName=='India' || countryName=='SWAL'){
            cntryNm = 'India';
        }
        
        if(countryName == 'Spain' || countryName=='Portugal' || countryName =='Naturagri Spain'){
            cntryNm ='Iberia';
        }
        
        List<Product_Detail__c> groupedResults =[SELECT Id, Name, Formulation__c,Formulation__r.Name, Company__c, Company__r.Name, Brand__c, 
                                                 Brand__r.Name, Brand_Approved__c, Company_Approved__c, Formulation_Approved__c 
                                                 FROM Product_Detail__c 
                                                 where Brand_Approved__c=true 
                                                 AND Company__c != '' 
                                                 AND Formulation__c !='' 
                                                 AND Country_Name__c=:cntryNm
                                                 AND Brand__c !='' order by Brand__r.Name asc]; 
        
        Map<String,Product_Detail__c> brndMap=new Map<String,Product_Detail__c>();
        
        for(Product_Detail__c PD:groupedResults){
            brndMap.put(PD.Company__r.Name,PD);//This is map and hence it will always have unique values 
        }
        
        return brndMap.values();
    }
    
    @AuraEnabled
    public static List<Product_Detail__c> searchHelperOnBrandKeyPres(String searchKeyWordBrand){
        System.debug('searchKeyWordBrand '+searchKeyWordBrand);
        String searchKey = '%'+searchKeyWordBrand+'%';
        
        
        String usrID = UserInfo.getUserId();
        User userObj = new User();
        userObj = [Select Id,Country From User WHERE Id=: usrID];
        String countryName =userObj.Country;
        String cntryNm ='';
        
        if(countryName=='India' || countryName=='SWAL'){
            cntryNm = 'India';
        }
        
        if(countryName == 'Spain' || countryName=='Portugal' || countryName =='Naturagri Spain'){
            cntryNm ='Iberia';
        }
        
        
        
        List <Product_Detail__c> returnList = new List <Product_Detail__c> ();
        
        String sQuery = 'SELECT Id, Name, Company__c, Company__r.Name, Brand__c, Brand__r.Name FROM Product_Detail__c WHERE Country_Name__c=:cntryNm AND  Brand__r.Name like \'%'+searchKeyWordBrand+'%\'AND Brand_Approved__c= true  AND Company__c != \'\'  AND Formulation__c !=\'\'  AND Brand__c !=\'\'  order by Brand__r.Name asc' ;
        
        
        
        //'select name,id from account where name like \'%'+searchstring+'%\' Limit 20'; 
        
        System.debug('sQuery '+sQuery);
        List <Product_Detail__c> lstOfRecords = Database.query(sQuery);
        
        for (Product_Detail__c obj: lstOfRecords) {
            returnList.add(obj);
        }
        
        
        
        System.debug('returnListin return '+returnList);
        Map<String,Product_Detail__c> brndMap=new Map<String,Product_Detail__c>();
        
        for(Product_Detail__c PD:returnList){
            brndMap.put(PD.Brand__r.Name,PD);//This is map and hence it will always have unique values 
        }
        
        return brndMap.values();
        
        
    }
    
    
    @AuraEnabled
    public static List<Product_Detail__c> searchHelperOnCompanyKeyPres(String searchKeyWordCompany){
        List <Product_Detail__c> returnList = new List <Product_Detail__c> ();
        
        
        String usrID = UserInfo.getUserId();
        User userObj = new User();
        userObj = [Select Id,Country From User WHERE Id=: usrID];
        String countryName =userObj.Country;
        String cntryNm ='';
        
        if(countryName=='India' || countryName=='SWAL'){
            cntryNm = 'India';
        }
        
        if(countryName == 'Spain' || countryName=='Portugal' || countryName =='Naturagri Spain'){
            cntryNm ='Iberia';
        }
        
        String sQuery = 'SELECT Id, Name, Company__c, Company__r.Name, Brand__c, Brand__r.Name FROM Product_Detail__c WHERE Country_Name__c=:cntryNm AND  Company__r.Name like \'%'+searchKeyWordCompany+'%\'AND Brand_Approved__c= true  AND Company__c != \'\'  AND Formulation__c !=\'\'  AND Brand__c !=\'\' ' ;
        
        //'select name,id from account where name like \'%'+searchstring+'%\' Limit 20'; 
        
        System.debug('sQuery '+sQuery);
        List <Product_Detail__c> lstOfRecords = Database.query(sQuery);
        
        for (Product_Detail__c obj: lstOfRecords) {
            returnList.add(obj);
        }
        System.debug('returnListin return '+returnList);
        Map<String,Product_Detail__c> cmpMap=new Map<String,Product_Detail__c>();
        
        for(Product_Detail__c PD:returnList){
            cmpMap.put(PD.Company__r.Name,PD);//This is map and hence it will always have unique values 
        }
        return cmpMap.values();
    }    
    
    
    @AuraEnabled
    public static List<Product_Detail__c> fetchFormulationList(String searchKeyWordFormulation){
        List<Product_Detail__c> pd= new List<Product_Detail__c>();
        Map<String ,Product_Detail__c> formulationMap = new Map<String ,Product_Detail__c>();
        
        String usrID = UserInfo.getUserId();
        User userObj = new User();
        userObj = [Select Id,Country From User WHERE Id=: usrID];
        String countryName =userObj.Country;
        String cntryNm ='';
        
        if(countryName=='India' || countryName=='SWAL'){
            cntryNm = 'India';
        }
        
        if(countryName == 'Spain' || countryName=='Portugal' || countryName =='Naturagri Spain'){
            cntryNm ='Iberia';
        }
        
        try{
            pd= [SELECT Id, Name, Formulation__c,Formulation__r.Name, Company__c, Company__r.Name, Brand__c, 
                 Brand__r.Name, Brand_Approved__c, Company_Approved__c, Formulation_Approved__c 
                 FROM Product_Detail__c 
                 where Formulation_Approved__c=true 
                 AND Company__c != '' 
                 AND Formulation__c !='' 
                 AND Country_Name__c=:cntryNm
                 AND Brand__c !='' ORDER BY Formulation__r.Name ASC NULLS LAST LIMIT 40];   
            
            for(Product_Detail__c PDObj:pd){
                formulationMap.put(PDObj.Formulation__r.Name,PDObj);//This is map and hence it will always have unique values 
            }
            
            if(pd.size()>0){
                return formulationMap.values();
            }
            else{
                return null;
            }
        }catch(DmlException e){
            System.debug('The following exception has occurred: ' + e.getMessage());
            System.debug('The following exception has occurred: ' + e.getLineNumber());
            return null;
        }
    }
    
    @AuraEnabled
    public static List<Product_Detail__c> searchHelperOnFormulationKeyPres(String searchKeyWordFormulation){
        List <Product_Detail__c> returnList = new List <Product_Detail__c> ();
        
        
        String usrID = UserInfo.getUserId();
        User userObj = new User();
        userObj = [Select Id,Country From User WHERE Id=: usrID];
        String countryName =userObj.Country;
        String cntryNm ='';
        
        if(countryName=='India' || countryName=='SWAL'){
            cntryNm = 'India';
        }
        
        if(countryName == 'Spain' || countryName=='Portugal' || countryName =='Naturagri Spain'){
            cntryNm ='Iberia';
        }
        
        String sQuery = 'SELECT Id, Name, Company__c, Company__r.Name,Formulation__c,Formulation__r.Name, Brand__c, Brand__r.Name FROM Product_Detail__c WHERE Country_Name__c=:cntryNm AND Formulation__r.Name like \'%'+searchKeyWordFormulation+'%\'AND Brand_Approved__c= true  AND Company__c != \'\'  AND Formulation__c !=\'\'  AND Brand__c !=\'\' ' ;
        
        //'select name,id from account where name like \'%'+searchstring+'%\' Limit 20'; 
        
        System.debug('sQuery '+sQuery);
        List <Product_Detail__c> lstOfRecords = Database.query(sQuery);
        
        for (Product_Detail__c obj: lstOfRecords) {
            returnList.add(obj);
        }
        System.debug('returnListin return '+returnList);
        Map<String,Product_Detail__c> cmpMap=new Map<String,Product_Detail__c>();
        
        for(Product_Detail__c PD:returnList){
            cmpMap.put(PD.Formulation__r.Name,PD);//This is map and hence it will always have unique values 
        }
        return cmpMap.values();
    }
    
    @AuraEnabled
    public static String gettingLoginUserIds(){
        System.debug(' @@@ userinfo.getuserid()  '+userinfo.getuserid());
        User userObj = new User();
        userObj = [Select Id, Name,Country From User Where Id=:userinfo.getuserid()];
        return userObj.Country;
        
        
    }
    
    
    
    
    public class CompetitorPrice{
        @AuraEnabled public String brand{get;set;} 
        @AuraEnabled public String company{get;set;}
        @AuraEnabled public String formulation{get;set;}
        @AuraEnabled public String reporting_tp{get;set;}
        @AuraEnabled public String sales_org{get;set;}
        @AuraEnabled public String territory{get;set;}
        
        public CompetitorPrice(){
            brand=''; 
            company='';
            formulation='';
            reporting_tp='';
            sales_org='';
            territory='';
        }
    }
    
    public class PriceSchemeDetails{
        @AuraEnabled public String cmnt{get;set;}
        @AuraEnabled public String copetitorPrice{get;set;}
        @AuraEnabled public Decimal dis_price{get;set;}
        @AuraEnabled public Decimal frm_price{get;set;}
        @AuraEnabled public Decimal mrp{get;set;}
        @AuraEnabled public String pck_size{get;set;}
        @AuraEnabled public Decimal ret_price{get;set;}
        @AuraEnabled public String sales_org{get;set;}
        @AuraEnabled public String schm{get;set;}
        @AuraEnabled public String territory{get;set;}
        @AuraEnabled public String pck_id{get;set;}
        @AuraEnabled public String pck_nm{get;set;}
        
        public PriceSchemeDetails(){
            cmnt='';
            copetitorPrice='';
            dis_price=0;
            frm_price=0;
            mrp=0;
            pck_size='';
            ret_price=0;
            sales_org='';
            schm='';
            territory='';
            pck_id='';
            pck_nm='';
        }
    }
    
    public class UpdateClaim{
        @AuraEnabled public String copetitorPrice{get;set;}
        @AuraEnabled public String crp{get;set;}
        @AuraEnabled public Decimal dos{get;set;}
        @AuraEnabled public String uom{get;set;}
        @AuraEnabled public Decimal acr_cst{get;set;}
        @AuraEnabled public String pst{get;set;}
        @AuraEnabled public String sales_org{get;set;}
        @AuraEnabled public String territory{get;set;}
        @AuraEnabled public String crpNm{get;set;}
        @AuraEnabled public String pstNm{get;set;}
        @AuraEnabled public String brand_Id{get;set;}
        public UpdateClaim(){
            copetitorPrice='';
            crp='';
            dos=0;
            uom='';
            acr_cst=0;
            pst='';
            sales_org='';
            territory='';
            crpNm='';
            pstNm='';
            brand_Id='';
        }
        
    }
    
}