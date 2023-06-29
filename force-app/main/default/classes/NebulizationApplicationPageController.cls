/*
* Class Name - NebulizationApplicationPageController
* Created Date - 10th Dec, 2022
* Author - Abhinay
* Description - Created a Controller for VF page NebulizationApplicationPage. 
* */

public with sharing class NebulizationApplicationPageController {    
    public String Customername {get;set;}
    public String Destination {get;set;}
    public Date Dte {get;set;}
    public String Assretailer {get;set;}
    public String Username {get;set;}
    public String Email {get;set;}
    public String Phone {get;set;}
    public String Mobile {get;set;}
    public String Billstreet {get;set;}
    public String Billzip {get;set;}
    public String Billcity {get;set;}
    public String Neobuildingname {get;set;}
    public String Buildingcapacity {get;set;}
    public Decimal Gpslatitude {get;set;}
    public Decimal Gpslongitude {get;set;}
    public String Conditioning {get;set;}
    public String Refrigeration {get;set;}
    public String Maleichydrazine  {get;set;}
    public String Sitevisite {get;set;}
    public String Variety {get;set;}
    public String Tubertemp {get;set;}
    public String Humidity {get;set;}
    public String Germinationwhitepoint {get;set;}
    public String Earth {get;set;}
    public String Sprouting1 {get;set;}
    public String Sprouting2 {get;set;} 
    public String Strokes {get;set;}
    public Boolean CO2 {get;set;}
    public String Refrigerationstopdate  {get;set;}
    public String Refrigerationstoptime  {get;set;}
    public String Buildingfilllevel {get;set;}
    public Boolean Shutters {get;set;}
    public Boolean Forcedventilation {get;set;}
    public String Product {get;set;}
    public String Nebulizedqtty {get;set;}
    public String Namm {get;set;}
    public String Applieddose {get;set;}
    public String Nebulizationtemp {get;set;}
    public String Applieddoseliter {get;set;}
    public String Batchnumber {get;set;}
    public String Storagetime {get;set;}
    public String Equipment {get;set;}
    public String Treatment {get;set;}
    public String Remark {get;set;}
    public String CreatedDate {get;set;} 
    public String CreatedTime {get;set;}
    public String CertificateNo {get;set;}
    public String Airing {get;set;}
    
    // Terms and Condition Variables
    public string ChampApplication {get;set;}
    public string ChampApplication1  {get;set;}
    public string ChampApplication2  {get;set;}
    public string ChampApplication3  {get;set;}
    public string CommandeAnnulation  {get;set;}
    public string CommandeAnnulation1  {get;set;}
    public string CommandeAnnulation2  {get;set;}
    public string ConditionPrestations  {get;set;}
    public string ConditionPrestations1  {get;set;}
    public string ConditionPrestations2  {get;set;}
    public string ConditionPrestations3  {get;set;}
    public string ConditionPrestations4 {get;set;} 
    public string ConditionPrestations5  {get;set;}
    public string ConditionPrestations6  {get;set;}
    public string ConditionPrestations7  {get;set;}
    public string ConditionPrestations8  {get;set;}
    public string Prix  {get;set;}
    public string Prix1  {get;set;}
    public string Prix2  {get;set;}
    public string Prix3  {get;set;}
    public string LimitationDeRes  {get;set;}
    public string LimitationDeRes1  {get;set;}
    public string LimitationDeRes2  {get;set;}
    public string LimitationDeRes3 {get;set;}
    public string ForceMajeure {get;set;}
    public string ForceMajeureDet {get;set;}
    public string SousT {get;set;}
    public string  SousTDeails  {get;set;}
    public string  LoiApplicable   {get;set;}
    public string  LoiApplicableDetails  {get;set;}

    //Variable length capacity
    Integer charaterlength = 3;
    Integer charaterlengthtwo = 2;
    Integer charaterlengthfour = 4;    
    Integer charaterlengthfive = 5;
    Integer charaterlengthten = 10;
    Integer charaterlengthmax = 15;
    Integer charaterlengthmaxi = 45;
    Integer remarkcharaterlength = 200;
        
    //added save
    public string  currentRecordId  {get;set;}
    public String PDFNo{get;set;}
    public boolean show{get;set;}
    public boolean showpdf{get;set;}
    public ApexPages.PageReference page2{get;set;}
    
	//String currentRecordId;
    Id recordTypeId = Schema.SObjectType.Customer_Visit__c.getRecordTypeInfosByName().get('FR NeoFog teams').getRecordTypeId();
            
    private ApexPages.StandardController sc;
    public NebulizationApplicationPageController(ApexPages.StandardController sc){
        this.sc=sc;
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
	    System.debug('id'+currentRecordId);
        FetchData(currentRecordId);
        MycusMetadata();
    }
    public void FetchData(String CusId){
        List<Customer_Visit__c> cusList = [Select id,Customer_Name__r.Name,Destination__c,Date__c,Associated_retailer__c,
                                           User_Name__c,Email__c,Phone__c,Mobile__c,Billing_City__c,Billing_Street__c,
                                           Billing_Zip_Postal_Code__c,NeoFog_Building_Name__r.Name,Building_Capacity__c,
                                           GPS_Coordinates_Latitude__c,GPS_Coordinates_Longitude__c,Conditionning__c,
                                           Refrigeration__c,Maleic_hydrazine__c,Site_Visit__c,Variety__c,Tubers_temp__c,
                                           Humidity__c,Germination_white_dots__c,Earth__c,Germination_1mm__c,Germination_1mmm__c,
                                           Strokes__c,CO_extraction__c,Refrigeration_Stop_Date__c,Refrigeration_stop_time__c,
                                           Building_fill_level__c,Shutters__c,Forced_ventilation_before_application__c,Product__c,
                                           Nebulizated_qtty__c,N_AMM__c,Applied_dose__c,Nebulization_temp__c,Applied_dose_in_Liter__c,
                                           Batch_number__c,Storage_time_month__c,Equipment__c,Treatment__c,Remark__c,CreatedDate,CreatedbyID,
                                           Certificate_number__c,Airing__c,RecordType.Id From Customer_Visit__c Where id=:CusId];
        if(cusList.size()>0){
            if(cusList[0].RecordType.Id == recordTypeId)
            {
                Customername = cusList[0].Customer_Name__r.Name;
                Destination = cusList[0].Destination__c;
                Dte = cusList[0].Date__c;
                Assretailer = cusList[0].Associated_retailer__c;
                Username = cusList[0].User_Name__c;
                Email = cusList[0].Email__c;
                Phone = cusList[0].Phone__c;
                Mobile = cusList[0].Mobile__c;
                Billstreet = cusList[0].Billing_City__c;
                Billzip = cusList[0].Billing_Street__c;
                Billcity = cusList[0].Billing_Zip_Postal_Code__c;
                Neobuildingname=String.valueOf(cusList[0].NeoFog_Building_Name__r.Name);
                if(Neobuildingname!=null){
                    if(Neobuildingname.length()>=charaterlengthmax){
                    Neobuildingname = Neobuildingname.substring(0,charaterlengthmax);
                	}
                }
                Buildingcapacity = String.valueOf(cusList[0].Building_Capacity__c);
                if(Buildingcapacity!=null){
                    if(Buildingcapacity.length()>=charaterlengthmax){
                    Buildingcapacity = Buildingcapacity.substring(0,charaterlengthmax);
                	}
                }
                Gpslatitude = cusList[0].GPS_Coordinates_Latitude__c;
                Gpslongitude = cusList[0].GPS_Coordinates_Longitude__c;
                Conditioning = cusList[0].Conditionning__c;
                Refrigeration = cusList[0].Refrigeration__c;
                Maleichydrazine = cusList[0].Maleic_hydrazine__c;
                Sitevisite = cusList[0].Site_Visit__c;
                Variety = cusList[0].Variety__c;
                if(Variety!=null){
                    if(Variety.length()>=charaterlengthmaxi){
                    Variety = Variety.substring(0,charaterlengthmaxi);
                	}
                } 
                Tubertemp = String.valueOf(cusList[0].Tubers_temp__c )+ '°C';
                if(Tubertemp!=null){
                    if(Tubertemp.length()>=charaterlengthtwo){
                    Tubertemp = Tubertemp.substring(0,charaterlengthtwo);
                	}
                }                
                Humidity = String.valueOf(cusList[0].Humidity__c);
                if(Humidity!=null){
                    if(Humidity.length()>=charaterlength){
                    Humidity = Humidity.substring(0,charaterlength);
                	}
                }
                Germinationwhitepoint = String.valueOf(cusList[0].Germination_white_dots__c);
                if(Germinationwhitepoint!=null){
                    if(Germinationwhitepoint.length()>=charaterlength){
                    Germinationwhitepoint = Germinationwhitepoint.substring(0,charaterlength);
                	}
                }
                Earth = String.valueOf(cusList[0].Earth__c);
                if(Earth!=null){
                    if(Earth.length()>=charaterlength){
                    Earth = Earth.substring(0,charaterlength);
                	}
                }
                Sprouting1 = String.valueOf(cusList[0].Germination_1mm__c);
                if(Sprouting1!=null){
                    if(Sprouting1.length()>=charaterlength){
                    Sprouting1 = Sprouting1.substring(0,charaterlength);
                	}
                }
                Sprouting2 = String.valueOf(cusList[0].Germination_1mmm__c);
                if(Sprouting2!=null){
                    if(Sprouting2.length()>=charaterlength){
                    Sprouting2 = Sprouting2.substring(0,charaterlength);
                	}
                }
                Strokes = String.valueOf(cusList[0].Strokes__c);
                if(Strokes!=null){
                    if(Strokes.length()>=charaterlength){
                    Strokes = Strokes.substring(0,charaterlength);
                	}
                }
                if(cusList[0].CO_extraction__c == 'activée'){
                	CO2 = true;
                }
                else if(cusList[0].CO_extraction__c == 'Désactivée'){
                    CO2 = false;
                }
                if(cusList[0].Refrigeration_Stop_Date__c!=null){
                	String Refstop = String.valueOf(cusList[0].Refrigeration_Stop_Date__c.Day() +'/'+cusList[0].Refrigeration_Stop_Date__c.Month()+'/'+cusList[0].Refrigeration_Stop_Date__c.Year());
                	Refrigerationstopdate = Refstop;
                }
                else {
                    Refrigerationstopdate = null;
                }
                if(cusList[0].Refrigeration_stop_time__c!=null){
                	Datetime myDateTime = Datetime.newInstance(Date.today(), cusList[0].Refrigeration_stop_time__c);
                	Refrigerationstoptime=myDateTime.format('h:mm a');
                }
                else {
                    Refrigerationstoptime = null;
                }
                Buildingfilllevel = String.valueOf(cusList[0].Building_fill_level__c);
                if(Buildingfilllevel!=null){
                    if(Buildingfilllevel.length()>=charaterlengthfive){
                    Buildingfilllevel = Buildingfilllevel.substring(0,charaterlengthfive);
                	}
                }
                if(cusList[0].Shutters__c == 'Ouverts'){
                	Shutters = true;
                }
                else{
                    Shutters = false;
                }
                if(cusList[0].Forced_ventilation_before_application__c == 'OUI'){
                	Forcedventilation = true;
                }
                else{
                    Forcedventilation = false;
                }
                Product = cusList[0].Product__c;
                Nebulizedqtty = String.valueOf(cusList[0].Nebulizated_qtty__c);
                if(Nebulizedqtty!=null){
                    if(Nebulizedqtty.length()>=charaterlengthfive){
                    Nebulizedqtty = Nebulizedqtty.substring(0,charaterlengthfive);
                	}
                }
                Namm = cusList[0].N_AMM__c;
                Applieddose = String.valueOf(cusList[0].Applied_dose__c);
                if(Applieddose!=null){
                    if(Applieddose.length()>=charaterlength){
                    Applieddose = Applieddose.substring(0,charaterlength);
                	}
                }
                Nebulizationtemp = cusList[0].Nebulization_temp__c;
                Applieddoseliter = String.valueOf(cusList[0].Applied_dose_in_Liter__c);
                if(Applieddoseliter!=null){
                    if(Applieddoseliter.length()>=charaterlengthfour){
                    Applieddoseliter = Applieddoseliter.substring(0,charaterlengthfour);
                	}
                }
                Batchnumber = cusList[0].Batch_number__c;
                if(Batchnumber!=null){
                    if(Batchnumber.length()>=charaterlengthmaxi){
                    Batchnumber = Batchnumber.substring(0,charaterlengthmaxi);
                	}
                }
                Storagetime = cusList[0].Storage_time_month__c;
                if(Storagetime!=null){
                    if(Storagetime.length()>=charaterlengthtwo){
                    Storagetime = Storagetime.substring(0,charaterlengthtwo);
                	}
                }
                Equipment = cusList[0].Equipment__c;
                if(Equipment!=null){
                    if(Equipment.length()>=charaterlengthten){
                    Equipment = Equipment.substring(0,charaterlengthten);
                	}
                }
                Treatment = cusList[0].Treatment__c;
                //Remark = cusList[0].Remark__c; 
                Remark = StringReduceClass.splitLines(cusList[0].Remark__c,100);
                if(Remark!=null){
                    if(Remark.length()>=remarkcharaterlength){
                    Remark = Remark.substring(0,remarkcharaterlength);
                    }
                }
                CreatedDate = String.valueOf(cusList[0].CreatedDate.Day() +'/'+cusList[0].CreatedDate.Month()+'/'+cusList[0].CreatedDate.Year());
                CreatedTime=cusList[0].CreatedDate.format('h:mm a');
                
                CertificateNo = cusList[0].Certificate_number__c;
                Airing = cusList[0].Airing__c;
            }
        }
    }
    
    //Added save data
    public PageReference Cancel()
    {
        PageReference Pdf = new PageReference('/'+currentRecordId);
        pdf.setredirect(True);
        return Pdf;
    }
    
    public PageReference pdfAction()
    {
        PageReference savepage ;
        savepage = Page.NebulizationApplicationPage;
        savepage.getParameters().put('id',currentRecordId);
        system.debug('id:- '+currentRecordId);
        blob pdfBlob;
        if (!Test.isRunningTest()) {
            pdfBlob = savepage.getContent(); //generate the pdf blob
        } else { 
            pdfBlob = Blob.valueOf('Test');
        }
        List<ContentDocumentLink> notesattch = [select id, ContentDocument.Title,LinkedEntityId from ContentDocumentLink where LinkedEntityId =: currentRecordId order by ContentDocument.Title asc];    
        system.debug('notesattch## ' + notesattch);
        if(notesattch.size() > 0)
        {
            string title =  notesattch[0].ContentDocument.Title;
            system.debug('title111 ' + title);
            List<String> titleSplit = title.split('R');
            //String FinalTitle = titleSplit[0]+'R0'+notesattch.size();
            String FinalTitle = 'Attestaton d application format PDF'+notesattch.size();
            system.debug('FinalTitle22 ' + FinalTitle);
            PDFNo=FinalTitle;
            
            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
            conVer.PathOnClient = FinalTitle+'.pdf'; 
            conVer.Title = FinalTitle; 
            conVer.VersionData = pdfBlob;
            system.debug('conVer@@ ' + conVer);
            insert conVer;  
            
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
            
            ContentDocumentLink conDocLink = New ContentDocumentLink();
            conDocLink.LinkedEntityId = currentRecordId;
            conDocLink.ContentDocumentId = conDoc; 
            conDocLink.shareType = 'V';
            insert conDocLink;
            
            show=false;
            showpdf=true;
            PageReference savepage2 = new PageReference('/'+currentRecordId);
            //PageReference savepage2 = Page.NebulizationApplicationPage;
            savepage2.getParameters().put('id',currentRecordId);
            if(!show)
                savepage2.getParameters().put('show','0');
            savepage2.setRedirect(true);
            return savepage2;
            
        }
        
        
        {
            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
            conVer.PathOnClient = PDFNo+'.pdf'; 
            conVer.Title = 'Attestaton d application format PDF'; 
            conVer.VersionData = pdfBlob;
            if(!Test.isRunningTest()){
                insert conVer;  
                
                Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
                
                ContentDocumentLink conDocLink = New ContentDocumentLink();
                conDocLink.LinkedEntityId = currentRecordId;
                conDocLink.ContentDocumentId = conDoc; 
                conDocLink.shareType = 'V';
                insert conDocLink;
            }
            
            
            show=false;
            showpdf=true;
            PageReference savepage2 = new PageReference('/'+currentRecordId);
            //PageReference savepage2 = Page.NebulizationApplicationPage;//Cafactionpage;CAFFormPDF
            savepage2.getParameters().put('id',currentRecordId);
            if(!show)
                savepage2.getParameters().put('show','0');
            savepage2.setRedirect(true);
            return savepage2;
        }
    }
    
    
    
    public void MycusMetadata(){

        List <Nebulization_Application_Page_France__mdt>  ListCM = [SELECT champ_application__c,champ_application_details_1_1__c,champ_application_details_1_2__c,champ_application_details_1_3__c,
   				Commande_Annulation__c,Commande_2_1__c,Commande_2_2__c,Conditions_d_ex_cution_des_Prestations__c,Conditions_d_ex_cution_des_Prestations1__c,
  				Conditions_d_ex_cution_des_Prestations2__c,Conditions_d_ex_cution_des_Prestations3__c ,Conditions_d_ex_cution_des_Prestations4__c ,
   				Conditions_d_ex_cution_des_Prestations5__c,Conditions_d_ex_cution_des_Prestations6__c,Conditions_d_ex_cution_des_Prestations7__c,
   				Conditions_d_ex_cution_des_Prestations8__c,Prix_Paiement__c,Prix_Paiement4_1__c,Prix_Paiement4_2__c,Prix_Paiement4_3__c ,
   				Limitation_de_Responsabilit__c,Limitation_5_1__c,Limitation_de_Responsabilit_5_2__c,Limitation_de_Responsabilit_5_3__c,
   				Force_Majeure__c,Force_Majeure_details__c,Sous_traitance__c,Sous_traitance_details__c,
   				Loi_Applicable_Litiges__c,Loi_Applicable_Litiges_details__c   FROM Nebulization_Application_Page_France__mdt];
  
        
        ChampApplication = ListCM[0].Champ_Application__c;
        ChampApplication1 = ListCM[0].champ_application_details_1_1__c;
        ChampApplication2 = ListCM[0].champ_application_details_1_2__c;
        ChampApplication3 = ListCM[0].champ_application_details_1_3__c;
        CommandeAnnulation = ListCM[0].Commande_Annulation__c;
        CommandeAnnulation1 = ListCM[0].Commande_2_1__c;
        CommandeAnnulation2 = ListCM[0].Commande_2_2__c;
     	ConditionPrestations = ListCM[0].Conditions_d_ex_cution_des_Prestations__c;
     	ConditionPrestations1 = ListCM[0].Conditions_d_ex_cution_des_Prestations1__c;
     	ConditionPrestations2 = ListCM[0].Conditions_d_ex_cution_des_Prestations2__c;
     	ConditionPrestations3 = ListCM[0].Conditions_d_ex_cution_des_Prestations3__c ;
     	ConditionPrestations4 = ListCM[0].Conditions_d_ex_cution_des_Prestations4__c ;
     	ConditionPrestations5 = ListCM[0].Conditions_d_ex_cution_des_Prestations5__c;
     	ConditionPrestations6 = ListCM[0].Conditions_d_ex_cution_des_Prestations6__c;
     	ConditionPrestations7 = ListCM[0].Conditions_d_ex_cution_des_Prestations7__c;
     	ConditionPrestations8 = ListCM[0].Conditions_d_ex_cution_des_Prestations8__c;
     	Prix = ListCM[0].Prix_Paiement__c;
     	Prix1 = ListCM[0].Prix_Paiement4_1__c;
     	Prix2= ListCM[0].Prix_Paiement4_2__c;
     	Prix3 = ListCM[0].Prix_Paiement4_3__c ;
     	LimitationDeRes = ListCM[0].Limitation_de_Responsabilit__c;
    	LimitationDeRes1 = ListCM[0].Limitation_5_1__c;
    	LimitationDeRes2 = ListCM[0].Limitation_de_Responsabilit_5_2__c;
    	LimitationDeRes3 = ListCM[0].Limitation_de_Responsabilit_5_3__c;
    	ForceMajeure = ListCM[0].Force_Majeure__c;
    	ForceMajeureDet = ListCM[0].Force_Majeure_details__c;
    	SousT = ListCM[0].Sous_traitance__c;
    	SousTDeails = ListCM[0].Sous_traitance_details__c;
    	LoiApplicable = ListCM[0].Loi_Applicable_Litiges__c;
    	LoiApplicableDetails = ListCM[0].Loi_Applicable_Litiges_details__c ;
       }
}