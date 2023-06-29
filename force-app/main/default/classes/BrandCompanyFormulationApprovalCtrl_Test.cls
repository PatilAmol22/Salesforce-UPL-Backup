@isTest
public class BrandCompanyFormulationApprovalCtrl_Test {
			
    public static TestMethod void BrandCompanyFormulationApprovalmethod(){
       Brand__c Brand = new Brand__c(
        Name ='ABC', 
        Approved__c = true,
        Brand_Code__c = '1234'
         );
        insert  Brand;
        
         company__c Company = new Company__c(
        Name ='ABC', 
        Approved__c = true,
        Company_Code__c = '1234'
         );
        insert  Company;
        
         Formulation__c Formulation = new Formulation__c(
        Approved__c = true, 
        Formulation_Code__c = '123',
        Company__c = Company.id,
        Brand__c = Brand.id  
         );
        insert  Formulation ;
        
         Brand__c unappBrand = new Brand__c(
        Name ='ABC', 
        Tagged_To_Approved__c = false,
        Approved__c = false,
        Brand_Code__c = ''
         );
        insert  unappBrand;
        
         company__c unappCompany = new Company__c(
        Name ='ABC', 
        Tagged_To_Approved__c = false,
        Approved__c = false,
        Company_Code__c = ''
         );
        insert  unappCompany;
        
         Formulation__c unappFormulation = new Formulation__c(
        Approved__c = false, 
        Tagged_To_Approved__c = false,
        Formulation_Code__c = '',
        Company__c = Company.id,
        Brand__c = Brand.id  
         );
        insert  unappFormulation ;
        
        Competitor_Price__c cp= new Competitor_Price__c (
                 Reporting_Type__c ='New Company, New Brand',
                 Brand__c = unappBrand.id,
                 Company__c = unappCompany.id ,
                 Formulation__c = unappFormulation.id
                 );
            insert cp;
        Product_Detail__c productDetail = new Product_Detail__c( Formulation__c = unappFormulation.id, 
        Company__c =unappCompany.id,
        Brand__c = unappBrand.id);
        
        insert productDetail;
        list<Brand__c> brands = new list<Brand__c>();
        brands.add(unappBrand);
         list<Company__c> companies = new list<Company__c>();
        companies.add(unappCompany);
         list<Formulation__c> formulations = new list<Formulation__c>();
        formulations.add(unappFormulation);
        BrandCompanyFormulationApprovalCtrl.updateBrandRef(Brand,brands);
        BrandCompanyFormulationApprovalCtrl.updateCmpRef(Company,companies);
        BrandCompanyFormulationApprovalCtrl.updateFrmRef(Formulation,formulations);
    }
    public static TestMethod void multiSelectLookupMethod(){
        Brand__c Brand = new Brand__c(
        Name ='ABC', 
        Approved__c = true,
        Brand_Code__c = '1234'
         );
        insert  Brand;
        Brand__c Brand1 = new Brand__c(
        Name ='ABC1', 
        Approved__c = false,
        Brand_Code__c = ''
         );
        insert  Brand1;
        list<Brand__c> brands = new list<Brand__c>();
        brands.add(Brand1);
        MultiSelectLookupController.fetchLookUpValues('ABC','Brand__c',brands, 'Brand_Code__c','' );
    }
    public static TestMethod void singleSelectLookupMethod(){
      Brand__c Brand = new Brand__c(
        Name ='ABC', 
        Approved__c = true,
        Brand_Code__c = '1234'
         );
        insert  Brand;  
   
    SingleSelectLookupController.fetchLookUpValues( 'Name','ABC','Brand_Code__c','Brand__c', '');
    }
}