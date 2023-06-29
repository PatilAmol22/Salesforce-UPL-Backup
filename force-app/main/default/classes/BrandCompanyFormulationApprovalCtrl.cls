public class BrandCompanyFormulationApprovalCtrl {
    public static list<Product_Detail__c> listProductDetails;
    public static list<Competitor_Price__c> listCompetitorPrice;
    public static list<Product_Detail__c> UpdatelistProductDetails;
    public static list<Competitor_Price__c> UpdatelistCompetitorPrice;
    public static list<Formulation__c> listFormulation;
    public static list<Formulation__c> updatelistFormulation;
    
    @AuraEnabled
    public static Brand__c updateBrandRef(sobject brand,list<sobject> brands){
        system.debug('Brand >>--->'+(Brand__c)brand);
        system.debug('Brand >>--->'+(list<Brand__c>)brands);
        Brand__c apprBrand = new Brand__c();
        list<Brand__c> listUnapprBrands = new list<Brand__c>();
        list<Brand__c> UpdatelistUnapprBrands = new list<Brand__c>();
        list<string> listBrandIds = new list<string>();
        
        listProductDetails = new list<Product_Detail__c>();
        listCompetitorPrice = new list<Competitor_Price__c>();
        UpdatelistProductDetails = new list<Product_Detail__c>();
        UpdatelistCompetitorPrice = new list<Competitor_Price__c>();
        listFormulation = new list<Formulation__c>();
        updatelistFormulation = new list<Formulation__c>();
        try{
        apprBrand = (Brand__c)brand;
        listUnapprBrands = (list<Brand__c>)brands; 
        for(Brand__c brnd : listUnapprBrands){
            system.debug('brnd>>--->'+brnd);
            listBrandIds.add(brnd.id);
        }
        system.debug(listBrandIds);
        listProductDetails  = [SELECT Id, Name, Brand__c FROM Product_Detail__c WHERE Brand__c IN : listBrandIds];
        listCompetitorPrice = [SELECT Id, Name,Brand__c  FROM Competitor_Price__c WHERE Brand__c IN : listBrandIds];
        listFormulation = [SELECT Id, Name,Brand__c  FROM Formulation__c WHERE Brand__c IN : listBrandIds];
        
        system.debug('listProductDetails>>--->'+listProductDetails);
        system.debug('listCompetitorPrice>>--->'+listCompetitorPrice);
        if(!listProductDetails.isEmpty()){   
            for(Product_Detail__c pdt : listProductDetails){
                Product_Detail__c pd = new Product_Detail__c();
                pd = pdt;
                pd.Brand__c = apprBrand.id;
                UpdatelistProductDetails.add(pd);
            }
        }  
        if(!listCompetitorPrice.isEmpty()){  
            for(Competitor_Price__c cmpr : listCompetitorPrice){
                Competitor_Price__c cp = new Competitor_Price__c();
                cp = cmpr;
                cp.Brand__c = apprBrand.id;
                UpdatelistCompetitorPrice.add(cp);
            }
        }
        if(!listFormulation.isEmpty()){
            for(Formulation__c form : listFormulation){
                Formulation__c frm = new Formulation__c();
                frm = form;
                frm.Brand__c = apprBrand.id;
                updatelistFormulation.add(frm);
            }       
        }    
        system.debug('listUnapprBrands>>--->'+listUnapprBrands);
        system.debug('UpdatelistCompetitorPrice>>--->'+UpdatelistCompetitorPrice);
        system.debug('UpdatelistProductDetails>>--->'+UpdatelistProductDetails);  
        if(!UpdatelistProductDetails.isEmpty()){
            update UpdatelistProductDetails;    
        }
        if(!UpdatelistCompetitorPrice.isEmpty()){
            update UpdatelistCompetitorPrice;
        } 
        for(Brand__c brnd : listUnapprBrands){
            Brand__c brd = new Brand__c();
            brd = brnd;
            brd.Tagged_To_Approved__c = true;
            UpdatelistUnapprBrands.add(brd);  
        }
        system.debug('UpdatelistUnapprBrands>>--->'+UpdatelistUnapprBrands);
        if(!updatelistFormulation.isEmpty()){
            update updatelistFormulation;      
        }
        if(!UpdatelistUnapprBrands.isEmpty()){
            update UpdatelistUnapprBrands;
        }
            
        system.debug('apprBrand>>--->'+apprBrand);
        return apprBrand;    
        }catch(DmlException e){
            system.debug('Line Number'+e.getLineNumber());
            system.debug('Message'+e.getMessage());
            return null;
        }
        
    }
     @AuraEnabled
    public static Company__c updateCmpRef(sobject company,list<sobject> companies){
        system.debug('company >>--->'+(Company__c)company);
        system.debug('companies >>--->'+(list<Company__c>)companies);
        Company__c apprCompany = new Company__c();
        list<Company__c> listUnapprCompanies = new list<Company__c>();
        list<Company__c> UpdatelistUnapprCompanies = new list<Company__c>();
        list<string> listCompanyIds = new list<string>();
        listProductDetails = new list<Product_Detail__c>();
        listCompetitorPrice = new list<Competitor_Price__c>();
        UpdatelistProductDetails = new list<Product_Detail__c>();
        UpdatelistCompetitorPrice = new list<Competitor_Price__c>();
        listFormulation = new list<Formulation__c>();
        updatelistFormulation = new list<Formulation__c>();
        try{
        apprCompany = (Company__c)company;
        listUnapprCompanies = (list<Company__c>)companies; 
        for(Company__c cmp : listUnapprCompanies){
            system.debug('cmp>>--->'+cmp);
            listCompanyIds.add(cmp.id);
        }
        system.debug(listCompanyIds);
        listProductDetails  = [SELECT Id, Name, Company__c FROM Product_Detail__c WHERE Company__c IN : listCompanyIds];
        listCompetitorPrice = [SELECT Id, Name, Company__c FROM Competitor_Price__c WHERE Company__c IN : listCompanyIds];
        listFormulation = [SELECT Id, Name,Company__c  FROM Formulation__c WHERE Company__c IN : listCompanyIds];
            
        system.debug('listProductDetails>>--->'+listProductDetails);
        system.debug('listCompetitorPrice>>--->'+listCompetitorPrice);
        if(!listProductDetails.isEmpty()){   
            for(Product_Detail__c pdt : listProductDetails){
                Product_Detail__c pd = new Product_Detail__c();
                pd = pdt;
                pd.Company__c = apprCompany.id;
                UpdatelistProductDetails.add(pd);
            }
        }  
        if(!listCompetitorPrice.isEmpty()){  
            for(Competitor_Price__c cmpr : listCompetitorPrice){
                Competitor_Price__c cp = new Competitor_Price__c();
                cp = cmpr;
                cp.Company__c = apprCompany.id;
                UpdatelistCompetitorPrice.add(cp);
            }
        }
         if(!listFormulation.isEmpty()){
            for(Formulation__c form : listFormulation){
                Formulation__c frm = new Formulation__c();
                frm = form;
                frm.Company__c =  apprCompany.id;
                updatelistFormulation.add(frm);
            }       
        }    
        system.debug('listUnapprBrands>>--->'+listUnapprCompanies);
        system.debug('updatelistFormulation>>--->'+updatelistFormulation);
        system.debug('UpdatelistCompetitorPrice>>--->'+UpdatelistCompetitorPrice);
        system.debug('UpdatelistProductDetails>>--->'+UpdatelistProductDetails);  
        if(!UpdatelistProductDetails.isEmpty()){
            update UpdatelistProductDetails;    
        }
        if(!UpdatelistCompetitorPrice.isEmpty()){
            update UpdatelistCompetitorPrice;
        } 
        for(Company__c cmp : listUnapprCompanies){
            Company__c cm = new Company__c();
            cm = cmp;
            cm.Tagged_To_Approved__c = true;
            UpdatelistUnapprCompanies.add(cm);  
        }
        system.debug('UpdatelistUnapprBrands>>--->'+UpdatelistUnapprCompanies);
        if(!updatelistFormulation.isEmpty()){
            update updatelistFormulation;      
        }
            
        if(!UpdatelistUnapprCompanies.isEmpty()){
            update UpdatelistUnapprCompanies;
        }
         
        system.debug('apprBrand>>--->'+apprCompany);
        return apprCompany;
        }catch(DmlException e){
            system.debug('Line Number'+e.getLineNumber());
            system.debug('Message'+e.getMessage());
            return null;
        }
        
    }
     @AuraEnabled
    public static Formulation__c  updateFrmRef(sobject formulation,list<sobject> formulations){
        system.debug('formulation >>--->'+(Formulation__c)formulation); 
        system.debug('formulations >>--->'+(list<Formulation__c>)formulations);
        Formulation__c apprForm = new Formulation__c();
        list<Formulation__c> listUnapprForms = new list<Formulation__c>();
        list<Formulation__c> UpdatelistUnapprForms = new list<Formulation__c>();
        list<string> listFormIds = new list<string>();
        listProductDetails = new list<Product_Detail__c>();
        listCompetitorPrice = new list<Competitor_Price__c>();
        UpdatelistProductDetails = new list<Product_Detail__c>();
        UpdatelistCompetitorPrice = new list<Competitor_Price__c>();
      
        try{
        apprForm = (Formulation__c)formulation;
        listUnapprForms = (list<Formulation__c>)formulations; 
        for(Formulation__c brnd : listUnapprForms){
            system.debug('brnd>>--->'+brnd);
            listFormIds.add(brnd.id);
        }
        system.debug(listFormIds);
        listProductDetails  = [SELECT Id, Name, Formulation__c FROM Product_Detail__c WHERE Formulation__c IN : listFormIds];
        listCompetitorPrice = [SELECT Id, Name, Formulation__c FROM Competitor_Price__c WHERE Formulation__c IN : listFormIds];
        system.debug('listProductDetails>>--->'+listProductDetails);
        system.debug('listCompetitorPrice>>--->'+listCompetitorPrice);
        if(!listProductDetails.isEmpty()){   
            for(Product_Detail__c pdt : listProductDetails){
                Product_Detail__c pd = new Product_Detail__c();
                pd = pdt;
                pd.Formulation__c = apprForm.id;
                UpdatelistProductDetails.add(pd);
            }
        }  
        if(!listCompetitorPrice.isEmpty()){  
            for(Competitor_Price__c cmpr : listCompetitorPrice){
                Competitor_Price__c cp = new Competitor_Price__c();
                cp = cmpr;
                cp.Formulation__c = apprForm.id;
                UpdatelistCompetitorPrice.add(cp);
            }
        }
        system.debug('listUnapprBrands>>--->'+listUnapprForms);
        system.debug('UpdatelistCompetitorPrice>>--->'+UpdatelistCompetitorPrice);
        system.debug('UpdatelistProductDetails>>--->'+UpdatelistProductDetails);  
        if(!UpdatelistProductDetails.isEmpty()){
            update UpdatelistProductDetails;    
        }
        if(!UpdatelistCompetitorPrice.isEmpty()){
            update UpdatelistCompetitorPrice;
        } 
        for(Formulation__c form : listUnapprForms){
            Formulation__c frm = new Formulation__c();
            frm = form;
            frm.Tagged_To_Approved__c = true;
            UpdatelistUnapprForms.add(frm);  
        }
        system.debug('UpdatelistUnapprBrands>>--->'+UpdatelistUnapprForms);
        if(!UpdatelistUnapprForms.isEmpty()){
            update UpdatelistUnapprForms;
        }
         
        system.debug('apprBrand>>--->'+apprForm);
        return apprForm;
        }catch(DmlException e){
            system.debug('Line Number'+e.getLineNumber());
            system.debug('Message'+e.getMessage());
            return Null;
        }
        
    }
}