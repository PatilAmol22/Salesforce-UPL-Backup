public with sharing class CampaignRollUp {

    public List<Promotional_Input_Requirements__c> listPir {get;set;}
    public Id campaignId;
    public Promotional_Input_Requirements__c pir {get;set;}

    public CampaignRollUp(ApexPages.StandardController controller) {
    
         campaignId = controller.getRecord().id;
         pir = new Promotional_Input_Requirements__c();
         System.Debug('campaignId  ========= > ' +campaignId );
         listPir = new List<Promotional_Input_Requirements__c>();
         listPir = [SELECT Campaign_Name__r.Leaflets_per_unit_cost__c,
                    Campaign_Name__r.Jeep_per_unit_cost__c,
                    Campaign_Name__r.Demos_per_unit_cost__c,
                    Campaign_Name__r.Banners_per_unit_cost__c,
                    Campaign_Name__r.Danglers_per_unit_cost__c,
                    Campaign_Name__r.Audio_Video_CD_s_per_unit_cost__c,
                    Campaign_Name__r.Posters_per_unit_cost__c,
                    Campaign_Name__r.Brochures_per_unit_cost__c 
                    FROM Promotional_Input_Requirements__c WHERE Campaign_Name__r.id = :campaignId ];
         
         if(listPir.size() > 0){
             AggregateResult[] groupedResults = [SELECT SUM(Total_No_of_Jeep_Campaigns__c) jcpv,
                                                 SUM(Total_No_of_Demos__c) dpv,
                                                 SUM(Total_No_of_Brochures__c) bpv, 
                                                 SUM(Total_No_of_Banners__c) bpv1,
                                                 SUM(Total_No_of_Danglers__c) dpv1,
                                                 SUM(Total_No_of_Posters__c) ppv,
                                                 SUM(Total_No_of_Audio_CD_s__c) avcpv,
                                                 SUM(Total_No_of_Leaflets__c) lpv 
                                                 FROM Promotional_Input_Requirements__c WHERE Campaign_Name__r.id = :campaignId  ];
              System.Debug('groupedResults ================ >' + groupedResults );
             for(Promotional_Input_Requirements__c pi  : listPir){
                 pir = pi;
             }
          
                
             for (AggregateResult ar : groupedResults)  {
             //   System.debug('Campaign ID' + ar.get('CampaignId'));
             //   System.debug('Average amount' + ar.get('expr0'));
                pir.No_of_Jeep_Campaign_Per_Village__c = (decimal)ar.get('jcpv');
                pir.No_of_Demos_Per_Village__c = (decimal)ar.get('jcpv');
                pir.No_of_Brochures_Per_Village__c = (decimal)ar.get('bpv');
                pir.No_of_Banners_per_Village__c = (decimal)ar.get('bpv1');
                pir.No_of_Danglers_Per_Village__c = (decimal)ar.get('dpv1');
                pir.No_of_Posters_Per_Village__c = (decimal)ar.get('ppv');
                pir.No_of_Audio_Video_CD_s_per_Village__c = (decimal)ar.get('avcpv');
                pir.No_of_Leaflets_Per_Village__c = (decimal)ar.get('lpv');
            }
        
            System.Debug('pir ================ >' + pir);
                         
            pir.No_of_Jeep_Campaign_Per_Village__c = pir.No_of_Jeep_Campaign_Per_Village__c * pir.Campaign_Name__r.Jeep_per_unit_cost__c;
            pir.No_of_Demos_Per_Village__c = pir.No_of_Demos_Per_Village__c * pir.Campaign_Name__r.Demos_per_unit_cost__c;
            pir.No_of_Brochures_Per_Village__c = pir.No_of_Brochures_Per_Village__c * pir.Campaign_Name__r.Brochures_per_unit_cost__c;
            pir.No_of_Banners_per_Village__c = pir.No_of_Banners_per_Village__c * pir.Campaign_Name__r.Banners_per_unit_cost__c;
            pir.No_of_Danglers_Per_Village__c = pir.No_of_Danglers_Per_Village__c * pir.Campaign_Name__r.Danglers_per_unit_cost__c;
            pir.No_of_Posters_Per_Village__c = pir.No_of_Posters_Per_Village__c * pir.Campaign_Name__r.Posters_per_unit_cost__c;
            pir.No_of_Audio_Video_CD_s_per_Village__c = pir.No_of_Audio_Video_CD_s_per_Village__c * pir.Campaign_Name__r.Audio_Video_CD_s_per_unit_cost__c;
            pir.No_of_Leaflets_Per_Village__c = pir.No_of_Leaflets_Per_Village__c * pir.Campaign_Name__r.Leaflets_per_unit_cost__c;
       }     
            
    }

}