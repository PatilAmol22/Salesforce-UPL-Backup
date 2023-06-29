public class BrazilPriceBookCreate {  
    //modified to usekit brand if kit pricebook  
    @InvocableMethod  
    public static void CreatePriceBook(List<Id> ListPriceListId){  
        try{  
            Id PriceListId = ListPriceListId[0];  
            system.debug('id'+PriceListId);  
            Price_Book__c ParentPBBrazil = [select Id, Name, Valid_From__c,
                                            Is_Approved__c,  
                                            Interest_Date__c,  
                                            Expiry_Date__c,  
                                            Currency__c,  
                                            Status__c,  
                                            Customer_Group__c,                                                                               
                                            Product_Discount__c,  
                                            Base_Price_Book__c,  
                                            Interest_Rate_R__c,  
                                            Interest_Rate_U__c,  
                                            Use_Campaign__c,  
                                            Campaign_Type__c,  
                                            Sales_Order_Block_Date__c,  
                                            CurrencyIsoCode,  
                                            OwnerId,  
                                            Division__c,Kit_Price_Book__c,  
                                            Apply_Discount_Matrix__c,
                                            Apply_Minimum_Price__c,
                                            Simulation_Price_Book__c,
                                            Apply_Increase_Decrease_Percentage__c,
                                            AVEC_Price_Book__c,
                                            Last_Month_Of_The_Season__c,
                                            USD_Rate__c  
                                            from Price_Book__c  
                                            where id = :PriceListId]; //Query Modified by wipro
             Boolean apply_discount = ParentPBBrazil.Apply_Discount_Matrix__c;
             Boolean applyMinPrice = ParentPBBrazil.Apply_Minimum_Price__c; //added by Priya For RITM0237685
            //ParentPBBrazil.Base_Price_Book__c = true;  
            //update ParentPBBrazil;  
            //This Feature is availabe for Normal priceBook and Simple campaign  
            if(ParentPBBrazil.Campaign_Type__c!='Structured'){  
                list<Price_Book_Sales_District__c> PBSD = [select id, Sales_District_Code__c,Sales_District1__c,  
                                                           Sales_District1__r.name   
                                                           from Price_Book_Sales_District__c   
                                                           where Price_Book__c = :PriceListId];  
                system.debug('PBSD'+PBSD);  
                //code added by Sagar@Wipro for PB-003& PB-004 Start--
                list<Price_Book_Crop_Culture__c> PBCC = [select id, Crop_Culture_Code__c,Crop_Culture1__c,  
                                                           Crop_Culture_Name__c ,Price_Book_Brazil__c  
                                                           from Price_Book_Crop_Culture__c   
                                                           where Price_Book_Brazil__c = :PriceListId];  
                system.debug('PBCC'+PBCC);
                
                
                list<Customer_Group_Price_Book__c> PBCG = [select id, Price_Book_Brazil__c,Customer_Group__c,Customer_Group_Code__c 
                                                           from Customer_Group_Price_Book__c   
                                                           where Price_Book_Brazil__c = :PriceListId];  
                system.debug('PBCG'+PBCG);
                
                list<Customer__c> PBCN = [select id, Price_Book_Brazil__c,Account__c  
                                                           from Customer__c   
                                                           where Price_Book_Brazil__c = :PriceListId];  
                system.debug('PBCN'+PBCN);
                 //code added by Sagar@Wipro for PB-003& PB-004 End--
                List<Price_Book_Details__c> Materials = [select Id,SKU__c,  
                                                         Sales_District1__c,  
                                                         Volume__c,   
                                                         SKU__r.Brand_Name__c,  
                                                         Future_Sales_Price__c,  
                                                         Future_Sales_Price_R__c,  
                                                         Future_Sales_Price_U__c,  
                                                         Minimum_Price__c,  
                                                         Minimum_Price_R__c,  
                                                         Minimum_Price_U__c,  
                                                         Unit_Price__c,  
                                                         Sellout_Price_BRL__c,
                                                         Sellout_Price_USD__c,
                                                         GM__c,
                                                         GM_USD__c,     
                                                         Sellout_Factor__c, 
                                                         Sellout_Factor_USD__c,     
                                                         Type__c,           
                                                         Type_USD__c,   
                                                         MinValue_Factor__c,    
                                                         Minimum_Value_Factor_USD__c,
                                                         Unit_Price_R__c,  
                                                         Unit_Price_U__c,  
                                                         Monthly_Interest_Rate__c,  
                                                         Price_Book__c,  
                                                         Kit_SKU__r.Brand_Name__c   
                                                         from Price_Book_Details__c  
                                                         where Price_Book__c = :PriceListId];  
                system.debug('Materials'+Materials);  
                List<Price_Book__c> liPB = new List<Price_Book__c>();  
                  Set<Id> myIds =new Set<Id>(); 
                for (Price_Book_Sales_District__c PBS:PBSD){  
                    Price_Book__c PB = new Price_Book__c();  
                    PB.Name = ParentPBBrazil.name + '-' +   
                        PBS.Sales_District_Code__c; //+ '-' + PBS.Sales_District1__r.name  
                    //ParentPBBrazil.CurrencyIsoCode;  
                    PB.Is_Approved__c = ParentPBBrazil.Is_Approved__c; 
                    PB.Customer_Group__c = ParentPBBrazil.Customer_Group__c; 
                    PB.Base_Price_Book__c = false;  
                    PB.Interest_Date__c = ParentPBBrazil.Interest_Date__c;  
                    PB.Valid_From__c = ParentPBBrazil.Valid_From__c;  
                    PB.CurrencyIsoCode = ParentPBBrazil.CurrencyIsoCode;  
                    PB.Status__c = ParentPBBrazil.Status__c;  
                    PB.Expiry_Date__c = ParentPBBrazil.Expiry_Date__c;  
                    PB.Currency__c = ParentPBBrazil.Currency__c;  
                    PB.Sales_Order_Block_Date__c = ParentPBBrazil.Sales_Order_Block_Date__c;  
                    PB.Campaign_Type__c = ParentPBBrazil.Campaign_Type__c;  
                    PB.Use_Campaign__c = ParentPBBrazil.Use_Campaign__c;  
                    //kit pb  
                    PB.Kit_Price_Book__c=ParentPBBrazil.Kit_Price_Book__c;  
                    PB.Division__c = ParentPBBrazil.Division__c;  
                    PB.Product_Discount__c = ParentPBBrazil.Product_Discount__c;  
                    PB.OwnerId = ParentPBBrazil.OwnerId;  
                    PB.Apply_Discount_Matrix__c = ParentPBBrazil.Apply_Discount_Matrix__c; //Divya
                    PB.Apply_Minimum_Price__c = ParentPBBrazil.Apply_Minimum_Price__c; //added by Priya For RITM0237685
                    PB.AVEC_Price_Book__c= ParentPBBrazil.AVEC_Price_Book__c; //added by wipro
                    PB.Simulation_Price_Book__c= ParentPBBrazil.Simulation_Price_Book__c; //added by wipro
                    PB.Apply_Increase_Decrease_Percentage__c= ParentPBBrazil.Apply_Increase_Decrease_Percentage__c; //added by wipro
                    PB.USD_Rate__c = ParentPBBrazil.USD_Rate__c; //Divya  
                    PB.Last_Month_Of_The_Season__c = ParentPBBrazil.Last_Month_Of_The_Season__c; //added by wipro
                    if(!string.isBlank(string.valueOf(ParentPBBrazil.Interest_Rate_R__c))) 
                        PB.Interest_Rate_R__c = ParentPBBrazil.Interest_Rate_R__c;  
                    if(!string.isBlank(string.valueOf(ParentPBBrazil.Interest_Rate_U__c)))  
                        PB.Interest_Rate_U__c = ParentPBBrazil.Interest_Rate_U__c;  
                    liPB.add(PB);  
                      
                }  
                  
                insert liPB;  
                if(liPB.size() > 0) {
                    for(Price_Book__c oPB: liPB) {
                        myIds.add(oPB.Id);
                    }
                }

                system.debug(liPB);

                system.debug(myIds);

                  if(myIds.size() > 0){

                // added for Price Book files by atish@wipro
                 Set<Id> documentIds = new Set<Id>(); 
                      
                List<Price_Book__c> pbId =[Select Id  from Price_Book__c where Id IN:myIds];
                system.debug(pbId);
                list<ContentDocumentLink > PBFiles = [SELECT ContentDocumentId, LinkedEntityId  FROM ContentDocumentLink where LinkedEntityId=:PriceListId];
                                system.debug('PBFiles'+PBFiles);
                 for(ContentDocumentLink cdLink:PBFiles){  
           documentIds.add(cdLink.ContentDocumentId);  
                 
             system.debug('documentIds'+documentIds);
                 }
                list<ContentVersion> converList =[Select Id,ContentDocumentId,PathOnClient,ContentLocation,Title,VersionData FROM ContentVersion where ContentDocumentId IN:documentIds ];
                ContentVersion[] insertContent = new  ContentVersion[]{};
                 for(ContentVersion cv :converList)
                {
                  ContentVersion cvs= new ContentVersion(ContentLocation= 'S',PathOnClient= cv.PathOnClient,Title=cv.Title,VersionData=cv.VersionData); 
                insertContent.add(cvs);
                    system.debug('insertContent'+insertContent);
                }
                if(insertContent.size()>0)
                {
                    insert insertContent;
         Id conDoc =[Select ContentDocumentId,CreatedDate from ContentVersion ORDER BY CreatedDate DESC LIMIT 1].ContentDocumentId;
                    ContentDocumentLink[] conDocLink = new ContentDocumentLink[]{};
                        for(Price_Book__c pr :pbId){
                ContentDocumentLink cdl = new ContentDocumentLink(LinkedEntityId=pr.Id ,ContentDocumentId= conDoc,shareType ='V') ;  
                       conDocLink.add(cdl);

                        }
                    insert conDocLink;
                    
                }
                else
                {
                    system.debug('Record Insertion failed');
                }
                    
                  } 
                else
                {
                                       system.debug(' Failed');
 
                } 
                //payment term calculation  
                list<Campaign_Payment_Terms__c> CampPT = [select Price_Book_Brazil__c,Name,  
                                                          Payment_Term__c,Payment_Term_in_Date__c  
                                                          from Campaign_Payment_Terms__c  
                                                          where Price_Book_Brazil__c = :PriceListId];  
                  
                list<Campaign_Payment_Terms__c> newCampPT = new list<Campaign_Payment_Terms__c>();  
                for(Price_Book__c PB: liPB){  
                    for(Campaign_Payment_Terms__c CamPT: CampPT){  
                        Campaign_Payment_Terms__c CPT = new Campaign_Payment_Terms__c();  
                        CPT.Price_Book_Brazil__c = PB.Id;  
                        CPT.Payment_Term__c = CamPT.Payment_Term__c;  
                        CPT.Payment_Term_in_Date__c = CamPT.Payment_Term_in_Date__c;  
                        newCampPT.add(CPT);  
                    }  
                      
                }  
                insert newCampPT;   
                //end  
                  
                list<Price_Book_Sales_District__c> LiPBSDNew = new list<Price_Book_Sales_District__c>();  
                for (Price_Book__c PB: liPB){  
                    for (Price_Book_Sales_District__c PBS:PBSD){  
                        if(PB.Name.contains(PBS.Sales_District_Code__c)){ //Sales_District1__r.name  
                            system.debug('sales'+PBS.Sales_District_Code__c);  
                            Price_Book_Sales_District__c PBSDNew = new Price_Book_Sales_District__c();  
                            PBSDNew.Sales_District1__c = PBS.Sales_District1__c;  
                            //PBSDNew.Sales_District_Code__c = PBS.Sales_District_Code__c;   
                            PBSDNew.Price_Book__c = PB.Id;  
                            LiPBSDNew.add(PBSDNew);  
                        }  
                    }  
                }  
                insert LiPBSDNew;  
                
        //code added by Sagar@Wipro for PB-003 & PB-004 Start--
                list<Price_Book_Crop_Culture__c> LiPBSDNew1 = new list<Price_Book_Crop_Culture__c>();  
                for (Price_Book__c PB1: liPB){  
                    for (Price_Book_Crop_Culture__c PBS1:PBCC){  
                       // if(PB.Name.contains(PBS.Sales_District_Code__c)){ //Sales_District1__r.name  
                          //  system.debug('sales'+PBS.Sales_District_Code__c);  
                            Price_Book_Crop_Culture__c PBSDNew1 = new Price_Book_Crop_Culture__c();  
                            PBSDNew1.Crop_Culture1__c = PBS1.Crop_Culture1__c;  
                            //PBSDNew.Sales_District_Code__c = PBS.Sales_District_Code__c;   
                            PBSDNew1.Price_Book_Brazil__c = PB1.Id;  
                            LiPBSDNew1.add(PBSDNew1);  
                       // }  
                    }  
                }
                system.debug('LiPBSDNew1'+LiPBSDNew1);
                insert LiPBSDNew1;
                
                 list<Customer__c> LiPBCNNew = new list<Customer__c>();  
                for (Price_Book__c PB1: liPB){  
                    for (Customer__c PBS1:PBCN){  
                       // if(PB.Name.contains(PBS.Sales_District_Code__c)){ //Sales_District1__r.name  
                          //  system.debug('sales'+PBS.Sales_District_Code__c);  
                            Customer__c PBSDNew1 = new Customer__c();  
                            PBSDNew1.Account__c = PBS1.Account__c;  
                            //PBSDNew1.Customer_Group_Code__c = PBS1.Customer_Group_Code__c;   
                            PBSDNew1.Price_Book_Brazil__c = PB1.Id;  
                            LiPBCNNew.add(PBSDNew1);  
                       // }  
                    }  
                }
                   system.debug('LiPBCNNew'+LiPBCNNew);
                insert LiPBCNNew;
                
                 list<Customer_Group_Price_Book__c> LiPBCGNew = new list<Customer_Group_Price_Book__c>();  
                for (Price_Book__c PB1: liPB){  
                    for (Customer_Group_Price_Book__c PBS1:PBCG){  
                       // if(PB.Name.contains(PBS.Sales_District_Code__c)){ //Sales_District1__r.name  
                          //  system.debug('sales'+PBS.Sales_District_Code__c);  
                            Customer_Group_Price_Book__c PBCGNew1 = new Customer_Group_Price_Book__c();  
                            PBCGNew1.Customer_Group__c = PBS1.Customer_Group__c;  
                            PBCGNew1.Customer_Group_Code__c = PBS1.Customer_Group_Code__c;   
  
                            PBCGNew1.Price_Book_Brazil__c = PB1.Id;  
                            LiPBCGNew.add(PBCGNew1);  
                       // }  
                    }  
                }
                system.debug('LiPBCGNew'+LiPBCGNew);
                insert LiPBCGNew;
                 //code added by Sagar@Wipro for PB-003 & PB-004 End--
                
                 
                set<id> Setids = new set<id>();  
                for(Price_Book_Sales_District__c PBSDSingle:LiPBSDNew){  
                    Setids.add(PBSDSingle.Id);  
                }  
                list<Price_Book_Sales_District__c> liPBSDApex = [select Price_Book__c,Sales_District_Code__c  
                                                                 from Price_Book_Sales_District__c  
                                                                 where id in :Setids];  
                map<string,String> MapSalesDistrictPriceBook = new map<string,String>();  
                for (Price_Book_Sales_District__c PBSDSingle: liPBSDApex){  
                    MapSalesDistrictPriceBook.put(PBSDSingle.Price_Book__c, PBSDSingle.Sales_District_Code__c);//Sales_District1__c  
                }  
                 
                  
                Map<string, Sales_District_Cost__c> mapSDC = new Map<string, Sales_District_Cost__c>();  
                for(Sales_District_Cost__c SDC : [select id, Region__c,Region__r.name,Region__r.RegionCode__c,  
                                                  Sales_District_Cost__c  
                                                  from Sales_District_Cost__c]){  
                                                      mapSDC.put(SDC.Region__r.RegionCode__c, SDC)  ;//Region__r.name  
                                                  }  
                  
                Map<string, Market_Variation__c> mapMV = new Map<string, Market_Variation__c>();  
                for(Market_Variation__c MV : [select id, SKU_Brand__c,Sales_District__c,  
                                              Region_Code__c,Combination_Key__c,  
                                              Market_Variation__c  
                                              from Market_Variation__c]){  
                                                  mapMV.put(MV.Combination_Key__c, MV)  ;  
                                              }  
                  
                  
                Map<string,Discount_Matrix__c> MapDM = new Map<string,Discount_Matrix__c>();  
                for (Discount_Matrix__c DM: [select id, Brand_Name__c, BU_Manager__c,  
                                             Sales_Director__c, Sales_District_Manager__c,  
                                             Sales_Person__c from Discount_Matrix__c]){  
                                                 MapDM.put(DM.Brand_Name__c, DM);     
                                             }  
                  
                List<Price_Book_Details__c> LiMat = new List<Price_Book_Details__c>();  
                  
                for (Price_Book__c PB: liPB){//  
                    for(Price_Book_Details__c Material: Materials){  
                        system.debug('in'+PB.name+'*'+Material.SKU__c);  
                        decimal DistrictCost = 1;  
                        decimal MarketVariation = 1;  
                        decimal DiscountMatrixSR = 1;  
                        decimal DiscountMatrixSDM = 1;  
                        decimal DiscountMatrixBU = 1;  
                        decimal DiscountMatrixSD = 1;  
                        decimal MultiplicationFactor = 1;  
                        decimal MultiplicationFactorMP = 1; //Divya Singh: 14/08/2020: Added for SCTASK0233819   
                        Price_Book_Details__c Mat = new Price_Book_Details__c();  
                        Mat.SKU__c = Material.SKU__c;  
                        Mat.Sales_District1__c = Material.Sales_District1__c;  
                        Mat.Volume__c = Material.Volume__c;  
                        Mat.OwnerId = ParentPBBrazil.OwnerId;  
                          
                        if(PB.name.contains(MapSalesDistrictPriceBook.get(PB.Id))){//Region  
                            //system.debug('**dis'+);
                            DistrictCost = mapSDC.get(MapSalesDistrictPriceBook.get(PB.Id)).Sales_District_Cost__c/100; // Region  
                        }
                        system.debug('DistrictCost'+DistrictCost);
                        if(PB.Kit_Price_Book__c==true){  
                            system.debug('in kit pb');  
                            Mat.Kit_SKU__c = Material.Kit_SKU__c;  
                            if(string.isNotBlank(Material.Kit_SKU__r.Brand_Name__c)){  
                            if(mapMV.containskey(MapSalesDistrictPriceBook.get(PB.Id)+Material.Kit_SKU__r.Brand_Name__c+'5191')){  
                            MarketVariation = mapMV.get(MapSalesDistrictPriceBook.get(PB.Id)+Material.Kit_SKU__r.Brand_Name__c+'5191').Market_Variation__c/100;  
                           system.debug('hello'+MarketVariation);  
                            }  
                                
                        }  
                          
                        if(string.isNotBlank(Material.Kit_SKU__r.Brand_Name__c)){  
                            if(MapDM.containskey(Material.Kit_SKU__r.Brand_Name__c)){  
                            DiscountMatrixSR = MapDM.get(Material.Kit_SKU__r.Brand_Name__c).Sales_Person__c/100;  
                            DiscountMatrixSDM =  MapDM.get(Material.Kit_SKU__r.Brand_Name__c).Sales_District_Manager__c/100;  
                            DiscountMatrixBU =  MapDM.get(Material.Kit_SKU__r.Brand_Name__c).BU_Manager__c/100;  
                            DiscountMatrixSD =  MapDM.get(Material.Kit_SKU__r.Brand_Name__c).Sales_Director__c/100;
                                system.debug('**'+DiscountMatrixSR+''+DiscountMatrixSDM+''+DiscountMatrixBU+''+DiscountMatrixSD);
                            }  
                              
                        }  
                        }else{  
                          
                        if(string.isNotBlank(Material.SKU__r.Brand_Name__c)){  
                            if(mapMV.containskey(MapSalesDistrictPriceBook.get(PB.Id)+Material.SKU__r.Brand_Name__c+'5191')){  
                            MarketVariation = mapMV.get(MapSalesDistrictPriceBook.get(PB.Id)+Material.SKU__r.Brand_Name__c+'5191').Market_Variation__c/100;  
                            }  
                                
                        }  
                          
                        if(string.isNotBlank(Material.SKU__r.Brand_Name__c)){  
                            if(MapDM.containskey(Material.SKU__r.Brand_Name__c)){  
                            DiscountMatrixSR = MapDM.get(Material.SKU__r.Brand_Name__c).Sales_Person__c/100;  
                            DiscountMatrixSDM =  MapDM.get(Material.SKU__r.Brand_Name__c).Sales_District_Manager__c/100;  
                            DiscountMatrixBU =  MapDM.get(Material.SKU__r.Brand_Name__c).BU_Manager__c/100;  
                            DiscountMatrixSD =  MapDM.get(Material.SKU__r.Brand_Name__c).Sales_Director__c/100;  
                            }  
                              
                        }  
                        }  
                        //MultiplicationFactor calculation  
                        if(DistrictCost == 1){  
                            DistrictCost = 0;  
                        }  
                        if(MarketVariation == 1){  
                            MarketVariation = 0;  
                        }  
                        if(DiscountMatrixSD == 1){  
                            DiscountMatrixSD = 0;  
                        }if(DiscountMatrixBU == 1){  
                            DiscountMatrixBU = 0;  
                        }  
                        if(DiscountMatrixSDM == 1){  
                            DiscountMatrixSDM = 0;  
                        }  
                        if(DiscountMatrixSR == 1){  
                            DiscountMatrixSR = 0;  
                        }  
                        // apply discount matrix and usdrate
                       if (apply_discount==true)  
                        {  
                            MultiplicationFactor = (((((1*(1+DistrictCost)*(1+MarketVariation))  
                                                   /(1-DiscountMatrixSD))  
                                                  /(1-DiscountMatrixBU))  
                                                 /(1-DiscountMatrixSDM))  
                                                /(1-DiscountMatrixSR));  
                        }  
                        else{  
                            MultiplicationFactor = (1*((1+DistrictCost)*(1+MarketVariation))); //Divya  
                        }    
                        MultiplicationFactorMP = (1*((1+DistrictCost)*(1+MarketVariation))); //Divya Singh: 14/08/2020: Added for SCTASK0233819  
                        system.debug(MultiplicationFactor+'MultiplicationFactor');
                        system.debug(MultiplicationFactorMP+'MultiplicationFactorMP');

                        //Minimum Price  
                        if(Material.Minimum_Price__c != null){  
                            Mat.Minimum_Price__c  = Material.Minimum_Price__c*MultiplicationFactorMP; //Divya Singh:14/08/2020:Replaced MultiplicationFactor by MultiplicationFactorMP for SCTASK0233819  
                            Mat.Minimum_Price__c  = Mat.Minimum_Price__c.setScale(2);  
                        }  
                        if(Material.Minimum_Price_R__c != null){  
                            Mat.Minimum_Price_R__c  = Material.Minimum_Price_R__c*MultiplicationFactorMP; //Divya Singh:14/08/2020:Replaced MultiplicationFactor by MultiplicationFactorMP for SCTASK0233819  
                            Mat.Minimum_Price_R__c  = Mat.Minimum_Price_R__c.setScale(2);  
                        }  
                        if(Material.Minimum_Price_U__c != null){  
                            Mat.Minimum_Price_U__c  = Material.Minimum_Price_U__c*MultiplicationFactorMP; //Divya Singh:14/08/2020:Replaced MultiplicationFactor by MultiplicationFactorMP for SCTASK0233819  
                            Mat.Minimum_Price_U__c  = Mat.Minimum_Price_U__c.setScale(2);  
                        }  
                          
                        //Unit Price  
                        if(Material.Future_Sales_Price__c != null){  
                            Mat.Future_Sales_Price__c  = Material.Future_Sales_Price__c*MultiplicationFactor;  
                            Mat.Future_Sales_Price__c  = Mat.Future_Sales_Price__c.setScale(2);  
                        }  
                        if(Material.Future_Sales_Price_R__c != null){  
                            Mat.Future_Sales_Price_R__c  = Material.Future_Sales_Price_R__c*MultiplicationFactor;  
                            Mat.Future_Sales_Price_R__c  = Mat.Future_Sales_Price_R__c.setScale(2);  
                        }  
                        if(Material.Future_Sales_Price_U__c != null){  
                            Mat.Future_Sales_Price_U__c  = Material.Future_Sales_Price_U__c*MultiplicationFactor;  
                            Mat.Future_Sales_Price_U__c  = Mat.Future_Sales_Price_U__c.setScale(2);  
                        }  
                          
                        //Future Price  
                        if(Material.Unit_Price__c != null){  
                            Mat.Unit_Price__c  = Material.Unit_Price__c*MultiplicationFactor;  
                            Mat.Unit_Price__c  = Mat.Unit_Price__c.setScale(2);  
                        }  
                        if(Material.Unit_Price_R__c != null){  
                            Mat.Unit_Price_R__c  = Material.Unit_Price_R__c*MultiplicationFactor;  
                            Mat.Unit_Price_R__c  = Mat.Unit_Price_R__c.setScale(2);  
                        }  
                        if(Material.Unit_Price_U__c != null){  
                            Mat.Unit_Price_U__c  = Material.Unit_Price_U__c*MultiplicationFactor;  
                            Mat.Unit_Price_U__c  = Mat.Unit_Price_U__c.setScale(2);  
                        }
                        if(Material.Sellout_Price_BRL__c != null){      
                            Mat.Sellout_Price_BRL__c  = Material.Sellout_Price_BRL__c.setScale(2);  
                        }   
                        if(Material.Sellout_Price_USD__c != null){  
                            Mat.Sellout_Price_USD__c  = Material.Sellout_Price_USD__c.setScale(2);  
                        }   
                        if(Material.GM__c != null){     
                            Mat.GM__c  = Material.GM__c.setScale(2);    
                        }   
                        if(Material.GM_USD__c != null){     
                            Mat.GM_USD__c  = Material.GM_USD__c.setScale(2);    
                        }   
                        if(Material.Sellout_Factor__c != null){ 
                            Mat.Sellout_Factor__c  = Material.Sellout_Factor__c.setScale(2);    
                        }   
                        if(Material.Sellout_Factor_USD__c != null){ 
                            Mat.Sellout_Factor_USD__c  = Material.Sellout_Factor_USD__c.setScale(2);    
                        }   
                        if(Material.Type__c != null){       
                            Mat.Type__c  = Material.Type__c;    
                        }   
                        if(Material.Type_USD__c != null){       
                            Mat.Type_USD__c  = Material.Type_USD__c;    
                        }   
                        if(Material.MinValue_Factor__c != null){    
                            Mat.MinValue_Factor__c  = Material.MinValue_Factor__c.setScale(2);  
                        }   
                        if(Material.Minimum_Value_Factor_USD__c != null){       
                            Mat.Minimum_Value_Factor_USD__c  = Material.Minimum_Value_Factor_USD__c.setScale(2);    
                        }  
                          
                        Mat.Price_Book__c = PB.Id;  
                        LiMat.add(Mat);  
                    }  
                      
                      
                      
                }  
                system.debug('LiMat**'+LiMat);  
                insert LiMat;  
                  
                //deleting sales district price book for Base Price book  
                //delete PBSD;  
            }  
        }  
        catch(Exception e){  
            System.debug('Exception occured ... '+e+':'+e.getLineNumber());    
        }  
          
          
    }  
      
}