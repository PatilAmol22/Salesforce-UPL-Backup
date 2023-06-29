/*******************************************************************************************
* @Name         Monitor Forecast 
* @Author       Sandeep Vishwakarma <sandeep.vishwakarma@skinternational.com>
* @Date         03/08/2022
* @Group        SKI
* @Description  This class contains all service methods related to Monitor Forecast).
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              Sandeep         08/03/2022           Initial Creation                                                      
*******************************************************************************************/
public without sharing class MonitoringForecast {

    /*
    * @Description  Brings classified sales agreement based on status RED,BLUE,YELLOW,GREEN.
    * @Param		String - filters : filters is string representaion of wrapper class FiltersWrapper passed by LWC 
    * @return       returns List of Sales Agreement Wrapper having color status
    */
    @AuraEnabled
    public static List<SalesAgreementWrapper> getAllSaleAgreements(String filters){
        FiltersWrapper filter = (FiltersWrapper)System.JSON.deserialize(filters,FiltersWrapper.class);
        System.debug(LoggingLevel.INFO,'Filters '+filter);
        String querySA = 'SELECT Id, Region__c,Region__r.TerritoryManager__c,Year__c, Sale_Org_Code__c, Name, SA_Status__c, Active_Forecast_Month__c, OwnerId,Owner.Name,Account.Id FROM SalesAgreement where Sale_Org_Code__c =\''+filter.salesorg+'\' and Active_Forecast_Month__c=\''+filter.month+'\' and  Year__c=\''+filter.year+'\'';


        String queryCRM = 'SELECT Id,Name,Territory__c,Account__c,Territory__r.TerritoryCode__c,Territory__r.TerritoryManager__r.Full_Name__c,Territory__r.Region__c,Territory__r.Region__r.Name,Territory__r.Region__r.RegionHead__r.Name from Forecast_Account__c where Territory__r.Sales_Org_Code__c =\''+filter.salesorg+'\'';

        if(String.isBlank(filter.salesDistrict) && !String.isBlank(filter.salesRep)){
            querySA = querySA+ ' and Region__r.TerritoryManager__c=\''+filter.salesRep+'\'';
            queryCRM =  queryCRM+' and Territory__r.TerritoryManager__c=\''+filter.salesRep+'\'';
        }else if(!String.isBlank(filter.salesDistrict) && String.isBlank(filter.salesRep)){
            querySA = querySA+' and Region__r.Region__c=\''+filter.salesDistrict+'\'';

            queryCRM = queryCRM+' and Territory__r.Region__c=\''+filter.salesDistrict+'\'';
        }else if(!String.isBlank(filter.salesDistrict) && !String.isBlank(filter.salesRep)){
            querySA = querySA+' and Region__r.Region__c=\''+filter.salesDistrict+'\' and Region__r.TerritoryManager__c=\''+filter.salesRep+'\'';

            queryCRM = queryCRM+' and Territory__r.Region__c=\''+filter.salesDistrict+'\' and Territory__r.TerritoryManager__c=\''+filter.salesRep+'\'';
        }
        System.debug('QuerySA -> '+querySA);
        System.debug('queryCRM -> '+queryCRM);
        
        List<SalesAgreement> salesAgreements = new List<SalesAgreement>();
        List<Forecast_Account__c> custom_region = new List<Forecast_Account__c>();
        // if(Schema.sObjectType.Forecast_Account__c.isAccessible()){
            salesAgreements = Database.query(querySA);
            custom_region = Database.query(queryCRM);
            System.debug('custom_region :'+custom_region);
        // }
        
        Map<String,List<Forecast_Account__c>> map_customer_region = new Map<String,List<Forecast_Account__c>>();
        Map<String,String> mapTerritoryCode = new Map<String,String>();

        Boolean isred =false;
        Boolean isblue=false;
        Boolean isyellow= false;
        Boolean isgreen = false;

        Integer redCount = 0;
        Integer blueCount = 0;       
        Integer yellowCount = 0;
        Integer greenCount = 0;
        Integer testcount = 0;

        for(Forecast_Account__c crm : custom_region){
            if(map_customer_region.containsKey(crm.Territory__r.TerritoryManager__c)){
                List<Forecast_Account__c> crList = map_customer_region.get(crm.Territory__r.TerritoryManager__c);
                crList.add(crm);
                map_customer_region.put(crm.Territory__r.TerritoryManager__c,crList);
            }else{
                List<Forecast_Account__c> crList = new List<Forecast_Account__c>();
                crList.add(crm);
                map_customer_region.put(crm.Territory__r.TerritoryManager__c,crList);
            }
            if(mapTerritoryCode.containsKey(crm.Territory__r.TerritoryManager__c)){
                String tcode =  mapTerritoryCode.get(crm.Territory__r.TerritoryCode__c)==null?'':mapTerritoryCode.get(crm.Territory__r.TerritoryCode__c);
                String territoryCode = crm.Territory__r.TerritoryCode__c+' '+tcode;
                mapTerritoryCode.put(crm.Territory__r.TerritoryManager__c,territoryCode);
            }else{
                String territoryCode = crm.Territory__r.TerritoryCode__c;
                mapTerritoryCode.put(crm.Territory__r.TerritoryManager__c,territoryCode);
            }
        }

        System.debug(LoggingLevel.INFO,'map_customer_region 64->'+map_customer_region);
        Map<String,SalesAgreement> map_saleAgreement = new Map<String,SalesAgreement>();
        for(SalesAgreement sa: salesAgreements){
            map_saleAgreement.put(sa.Region__r.TerritoryManager__c+''+sa.Account.Id,sa);
        }
        System.debug(LoggingLevel.INFO,'Map size-->'+map_saleAgreement.size());
        List<SalesAgreementWrapper> lstSalesAgreementWrapper = new List<SalesAgreementWrapper>();
        for(String territory:map_customer_region.keySet()){
            isred =false;
            isblue=false;
            isyellow= false;
            isgreen = false;

            redCount = 0;
            blueCount = 0;       
            yellowCount = 0;
            greenCount = 0;
            System.debug('Red '+isRed+' Blue '+isBlue+' Green '+isgreen+' yellow '+isyellow);
            System.debug('map_customer_region.get(territory) '+map_customer_region.get(territory));
            for(Forecast_Account__c crm:map_customer_region.get(territory)){
                // System.debug('map_saleAgreement key '+crm.Territory__r.TerritoryManager__c+''+crm.Account__c);
                if(map_saleAgreement.containskey(crm.Territory__r.TerritoryManager__c+''+crm.Account__c)){
                    testcount++;
                    // System.debug('Test count '+testcount);
                    if(!isred){
                        String status = map_saleAgreement.get(crm.Territory__r.TerritoryManager__c+''+crm.Account__c).SA_Status__c;
                        // System.debug('Territory Name 79'+crm.Territory__r.TerritoryManager__r.Full_Name__c+' Status --> '+status);
                        if(status=='Draft' || status=='Rejected'){
                            isyellow = true;yellowCount++;
                            isblue= false;
                            isgreen = false;
                        }
                        System.debug('is Yellow'+isyellow);
                        if(!isyellow){
                            if(status=='Pending'){
                                isblue = true;blueCount++;
                                isgreen = false;
                                System.debug('isBlue -->'+isblue);
                            }
                            if(!isblue){
                                if(status=='Approved' || status=='Activated'){
                                    isgreen = true;greenCount++;
                                }
                            }
                        }
                    }
                }else{
                    isred=true;redCount++;
                    isyellow = false;
                    isblue =  false;
                    isgreen = false;
                    //System.debug('Territory Name 102'+crm.Territory__r.TerritoryManager__r.Full_Name__c);
                }
            }
            System.debug('Red '+isRed+' Blue '+isBlue+' Green '+isgreen+' yellow '+isyellow);
            SalesAgreementWrapper saw = new SalesAgreementWrapper();
            saw.territory_id=map_customer_region.get(territory)[0].Territory__c;
            saw.salesRep=map_customer_region.get(territory)[0].Territory__r.TerritoryManager__r.Full_Name__c;
            saw.territoryCode = mapTerritoryCode.get(territory);
            saw.salesRep_id=map_customer_region.get(territory)[0].Territory__r.TerritoryManager__c;
            saw.salesDistrict=map_customer_region.get(territory)[0].Territory__r.Region__r.Name;
            saw.salesDistrictManager = map_customer_region.get(territory)[0].Territory__r.Region__r.RegionHead__r.Name;
            saw.month=filter.month;
            saw.year=filter.year;
            if(isred){
                saw.indicator='Red';
                saw.indicatorCount = redcount;
                saw.isRed = true;
            }
            if(isyellow){
                saw.indicator='Yellow';
                saw.indicatorCount = yellowCount;
                saw.isyellow = true;
            }
            if(isblue){
                System.debug('is Blue 125  ->'+isblue);
                saw.indicator='Blue';
                saw.indicatorCount = blueCount;
                saw.isblue = true;
            }
            if(isgreen){
                saw.indicator='Green';
                saw.indicatorCount = greenCount;
                saw.isgreen = true;
            }
            System.debug('SAW ==>'+saw);
            lstSalesAgreementWrapper.add(saw);
        }
        System.debug('filter --> '+filter);
        List<SalesAgreementWrapper> indicator_salesAgreement = new List<SalesAgreementWrapper>();
            if(filter.indicator=='All'){
                indicator_salesAgreement.addAll(lstSalesAgreementWrapper);
            }else{
                for(SalesAgreementWrapper saw:lstSalesAgreementWrapper){
                    if(saw.indicator==filter.indicator){
                        indicator_salesAgreement.add(saw);
                    }
                }
            }
        System.debug('lstSalesAgreementWrapper '+lstSalesAgreementWrapper);
        System.debug('lstSalesAgreementWrapper '+indicator_salesAgreement);
        return indicator_salesAgreement;
    }


    /*
    * @Description  Used to send remainder based on different color status.
    * @Param		String - filters : filters is string representaion of wrapper class FiltersWrapper passed by LWC.
    * @return       returns String representation of wrapper Sales Agreement for which email has been sent.
    */
    @AuraEnabled
    public static string sendRemainder(String filter){
        Map<String,String> monthMap = new Map<String,String>();
        monthMap.put('January','Janeiro');
        monthMap.put('February','Fevereiro');
        monthMap.put('March','Março');
        monthMap.put('April','Abril');
        monthMap.put('May','Maio');
        monthMap.put('June','Junho');
        monthMap.put('July','Julho');
        monthMap.put('August','Agosto');
        monthMap.put('September','Setembro');
        monthMap.put('October','Outubro');
        monthMap.put('November','Novembro');
        monthMap.put('December','Dezembro');


        FiltersWrapper filters = (FiltersWrapper)System.JSON.deserialize(filter,FiltersWrapper.class);
        String status = filters.indicator;
        String username = [select id,Name from User where Id=:filters.salesRep].Name;
        String customeLabelEmail = System.Label.Email_Sent_to_SalesRep_or_SDM;
        String customeLabelEmailSalesRep = System.Label.Email_Sent_to_Only_Sales_Rep;
        System.debug('Status :'+filter);
        // Dynamic URL <!--CR#162 MonitorForecast - Sandeep.Vishwakarma 9-27-2022-->
        String BaseURL = System.Url.getSalesforceBaseUrl().toExternalForm();
        if(status=='Yellow'){
            
            String querySA = 'SELECT Id, Region__c,Region__r.TerritoryManager__c,Year__c, Sale_Org_Code__c, Name, SA_Status__c, Active_Forecast_Month__c, OwnerId,Owner.Name,Account.Id FROM SalesAgreement where Sale_Org_Code__c =\''+filters.salesorg+'\' and Active_Forecast_Month__c=\''+filters.month+'\' and  Year__c=\''+filters.year+'\' and Region__r.TerritoryManager__c=\''+filters.salesRep+'\' and SA_Status__c=\'Draft\'';
            List<SalesAgreement> salesAgreements = Database.query(querySA);
            Integer count = salesAgreements.size();
           // <!--CR#162 MonitorForecast - Sandeep.Vishwakarma 9-27-2022-->
            String mailbody = '<div style=""><img src="'+BaseURL+'/servlet/servlet.ImageServer?id=0150K000009suFW&oid=00D280000013Zui" width="140" height="100" style="display:block;padding:10px 0px 20px 0px"><br></br><br></br><p>Prezado(a) '+username+',</p></br></br><span>O planejamento de vendas do período <b>'+monthMap.get(filters.month)+' - '+filters.year+'</b> deve ser finalizado e enviado para a validação do seu gestor, pois o prazo está próximo ao final.</span><br></br><br></br><span style="padding-top: 5px">Por favor revise e envie os dados o mais breve possível.</span><br></br><br></br><span style="padding-top: 5px">Caso tenha alguma dúvida, favor entrar em contato com o time de Planejamento de Demanda.</span><br></br><br></br>Obrigado!<br></br><br></br><b>***</b> Esta é uma mensagem automática. Favor não responder.</div>';
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            // email.setTargetObjectId(filters.salesRep); 
            email.setToAddresses(new List<String>{customeLabelEmailSalesRep});// Edited on 01-03-22
            // email.setToAddresses(new List<String>{'shreyashi.ghosh@skinternational.com','nilam.bangar@skinternational.com','sandeep.vishwakarma@skinternational.com','rafael.chiavenato@upl-ltd.com','pedro.nery@upl-ltd.com'});
            email.setSubject('Planejamento de Vendas – Aguardando Envio para Aprovação - '+monthMap.get(filters.month)+' - '+filters.year+'');
            email.saveAsActivity = false;
            email.setHtmlBody(mailbody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }else if(status=='Red'){
            List<User> lst_user = [select id,Name,email from User where Profile.Name='Brazil Demand Planning Administrator'];
            List<String> emails = new List<String>();
            for(User u:lst_user){
                emails.add(u.email);
            }
            //<!--CR#162 MonitorForecast - Sandeep.Vishwakarma 9-27-2022-->
            String mailbody = '<div style=""><img src="'+BaseURL+'/servlet/servlet.ImageServer?id=0150K000009suFW&oid=00D280000013Zui" width="140" height="100" style="display:block;padding:10px 0px 20px 0px"><br></br><br></br><p>Prezado(a) '+username+',</p></br></br><span>O planejamento de vendas do período <b>'+monthMap.get(filters.month)+' - '+filters.year+'</b> ainda não foi gerado.</span><br></br><br></br><span style="padding-top: 5px">Por favor execute a geração do planejamento do período o mais breve possível.</span><br></br><br></br>Obrigado!<br></br><br></br><b>***</b> Esta é uma mensagem automática. Favor não responder.</div>';
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            // email.setTargetObjectId(filters.salesRep);
            // email.setToAddresses(new List<String>{'shreyashi.ghosh@skinternational.com','nilam.bangar@skinternational.com','sandeep.vishwakarma@skinternational.com','rafael.chiavenato@upl-ltd.com','pedro.nery@upl-ltd.com'});
            email.setToAddresses(new List<String>{customeLabelEmail});
            email.setSubject('Planejamento de Vendas – Aguardando Geração do Planejamento - '+monthMap.get(filters.month)+' - '+filters.year+'');
            email.setHtmlBody(mailbody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }else if(status=='Blue'){
            //Territory_Distributor__c td =  [SELECT Id, Region__c,Region__r.RegionHead__c FROM Territory_Distributor__c where TerritoryManager__c =:filters.salesRep and id =:filters.territory_id limit 1];
            
            String url = URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/n/Forecast_Admin_Panel';
            //https://upl--uat.lightning.force.com/lightning/n/Forecast_Admin_Panel
            //<!--CR#162 MonitorForecast - Sandeep.Vishwakarma 9-27-2022-->
            String mailbody = '<div style=""><img src="'+BaseURL+'/servlet/servlet.ImageServer?id=0150K000009suFW&oid=00D280000013Zui" width="140" height="100" style="display:block;padding:10px 0px 20px 0px"><br></br><br></br><p>Prezado(a),</p></br></br><span>Oplanejamento mensal de '+username+' do período '+monthMap.get(filters.month)+' - '+filters.year+' continua pendente para sua verificação.</span><br></br><br></br><span style="padding-top: 5px">Por favor, <a href='+url+'>clique aqui</a> para acessar o sistema e realizar a aprovação/reprovação do planejamento.</span><br></br><br></br><span style="padding-top: 5px">Caso tenha alguma dúvida, favor entrar em contato com o time de Planejamento de Demanda.</span><br></br><br></br>Obrigado!<br></br><br></br><b>***</b> Esta é uma mensagem automática. Favor não responder.</div>';
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            // email.setTargetObjectId(td.Region__r.RegionHead__c);
            email.setToAddresses(new List<String>{customeLabelEmailSalesRep});

            email.setSubject('Planejamento de Vendas – Aguardando Aprovação - '+username+' - '+monthMap.get(filters.month)+' - '+filters.year+'');
            email.saveAsActivity = false;
            email.setHtmlBody(mailbody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }else if(status=='Green'){
            //Territory_Distributor__c td =  [SELECT Id, Region__c,Region__r.RegionHead__c FROM Territory_Distributor__c where TerritoryManager__c =:filters.salesRep and id =:filters.territory_id limit 1];
            
            String url = URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/n/Forecast_Admin_Panel';
            //https://upl--uat.lightning.force.com/lightning/n/Forecast_Admin_Panel
            //<!--CR#162 MonitorForecast - Sandeep.Vishwakarma 9-27-2022-->
            String mailbody = '<div style=""><img src="'+BaseURL+'/servlet/servlet.ImageServer?id=0150K000009suFW&oid=00D280000013Zui" width="140" height="100" style="display:block;padding:10px 0px 20px 0px"><br></br><br></br><p>Prezado ,</p></br></br><span>Os Forecasts do CTC  '+username+' do período de '+monthMap.get(filters.month)+' - '+filters.year+' foram encerrados com sucesso.</span><br></br><br></br><span style="padding-top: 5px">Para, <a href='+url+'>clique no link</a> acessar o Sistema.</span><br></br><br></br><span style="padding-top: 5px"></span><br></br><br></br>Obrigada!!<br></br><br></br><b>***</b> This is an automated message. Please do not respond.</div>';
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            // email.setTargetObjectId(td.Region__r.RegionHead__c);
            email.setToAddresses(new List<String>{customeLabelEmail});

            email.setSubject('Plano de vendas aprovado - '+username+' - '+monthMap.get(filters.month)+' - '+filters.year+'');
            email.saveAsActivity = false;
            email.setHtmlBody(mailbody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
        return filter;
    }


    /*
    * @Description  Used to close the forecast OR Approve it.
    * @Param		String - filters : filters is string representaion of wrapper class FiltersWrapper passed by LWC.
    * @return       returns list of boolean contains number of true(success) OR false(Failure).
    */
    @AuraEnabled
    public static List<Boolean> closeForecast(String filter){
        FiltersWrapper filters = (FiltersWrapper)System.JSON.deserialize(filter,FiltersWrapper.class);
        String indicator = filters.indicator;
        String status = '';
        List<Id> salesAgreements = new List<Id>();
        Set<Id> SalesAgreementsDraft = (new Map<Id, SalesAgreement>([SELECT Id, Region__c,Region__r.TerritoryManager__c,Year__c, Sale_Org_Code__c, Name, SA_Status__c, Active_Forecast_Month__c, OwnerId,Owner.Name,Account.Id FROM SalesAgreement where Sale_Org_Code__c =:filters.salesorg and Active_Forecast_Month__c=:filters.month and  Year__c=:filters.year and Region__r.TerritoryManager__c=:filters.salesRep and SA_Status__c='Draft'])).keySet();

        Set<Id> SalesAgreementsPending = (new Map<Id, SalesAgreement>([SELECT Id, Region__c,Region__r.TerritoryManager__c,Year__c, Sale_Org_Code__c, Name, SA_Status__c, Active_Forecast_Month__c, OwnerId,Owner.Name,Account.Id FROM SalesAgreement where Sale_Org_Code__c =:filters.salesorg and Active_Forecast_Month__c=:filters.month and  Year__c=:filters.year and Region__r.TerritoryManager__c=:filters.salesRep and SA_Status__c='Pending'])).keySet();

        if(SalesAgreementsDraft.size()>0){
            List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest> ();
            for(Id id1 : SalesAgreementsDraft){
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Auto submitted by the Demand planner');
                req1.setObjectId(id1);
                requests.add(req1);
            }
            Approval.ProcessResult[] processResults = null;
            try {
                processResults = Approval.process(requests, true);
                System.debug('Process Result on line 264 '+processResults.size());
            }catch (System.DmlException e) {
                System.debug('Exception Is ' + e.getMessage());
            }
        }
        // SalesAgreementsPending.addAll(SalesAgreementsDraft);
        salesAgreements.addAll(SalesAgreementsDraft);
        salesAgreements.addAll(SalesAgreementsPending);

        Set<Id> pIds = (new Map<Id, ProcessInstance>([SELECT Id,Status,TargetObjectId FROM ProcessInstance where Status='Pending' and TargetObjectId in :salesAgreements])).keySet();

        Set<Id> pInstanceWorkitems = (new Map<Id, ProcessInstanceWorkitem>([SELECT Id,ProcessInstanceId FROM ProcessInstanceWorkitem WHERE ProcessInstanceId in :pIds])).keySet();

        List<Approval.ProcessWorkitemRequest> allReq = new List<Approval.ProcessWorkitemRequest>(); 
        System.debug('pInstanceWorkitems on line 245 '+pInstanceWorkitems);
        System.debug('pInstanceWorkitems on line 245 '+pInstanceWorkitems.size());
        for (Id pInstanceWorkitemsId:pInstanceWorkitems){
            system.debug(pInstanceWorkitemsId);
                Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
                req2.setComments('Approved by SDM');
                req2.setAction('Approve'); 
                // req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
                req2.setWorkitemId(pInstanceWorkitemsId);
                allReq.add(req2);
        }
        Approval.ProcessResult[] result2 = null;
        try {
           result2 =  Approval.process(allReq);
        } catch (Exception e) {
            System.debug('Exception while appoving '+e);
        }
        List<Boolean> success = new List<Boolean>();
        for(Approval.ProcessResult res: result2){
            success.add(res.isSuccess());
        }
       return success;
    }

    /*<!--CR#162 MonitorForecast - Sandeep.Vishwakarma 9-27-2022-->
    * @Description  Used to close the forecast OR Approve it asynchronously by calling batch class CloseMassForeCast.
    * @Param		String - filters : filters is string representaion of wrapper class FiltersWrapper passed by LWC.
    */
    @AuraEnabled
    public static void asyncCloseForecast(String filter){
        FiltersWrapper filters = (FiltersWrapper)System.JSON.deserialize(filter,FiltersWrapper.class);
        Database.executeBatch(new CloseMassForeCast(filters),50);
    }

    /*<!--CR#162 MonitorForecast - Sandeep.Vishwakarma 9-27-2022-->
    * @Description  Method use to retrive SalesAgreements of specific SalesRep For CR#162 MonitorForecast - Sandeep.Vishwakarma 9-27-2022
    * @Param String - filters : filters is string representaion of wrapper class FiltersWrapper passed by LWC.
    */
    @AuraEnabled
    public static List<SalesAgreement> getSalesAgreementsBySalesRep(String filter){
        FiltersWrapper filters = (FiltersWrapper)System.JSON.deserialize(filter,FiltersWrapper.class);
        List<SalesAgreement> salesAgreements = [SELECT Id, Region__c,StartDate,EndDate,Region__r.TerritoryManager__c,Year__c, Sale_Org_Code__c, Name, SA_Status__c, Active_Forecast_Month__c, OwnerId,Owner.Name,Account.Id,Account.Name FROM SalesAgreement where Sale_Org_Code__c =:filters.salesorg and Active_Forecast_Month__c=:filters.month and Year__c=:filters.year and Region__r.TerritoryManager__c=:filters.salesRep and SA_Status__c='Pending'];
        return salesAgreements;
    }

    /*
    * @Description  used to publish event to recall SalesAgreement For CR#162 MonitorForecast - Sandeep.Vishwakarma 9-27-2022
    * @Param List of SalesAgreement Id in JSON String format.
    * @return null
    */
    @AuraEnabled
    public static void recallSalesAgreements(String salesAgreementIds){
        List<String> Ids = (List<String>)JSON.deserialize(salesAgreementIds, List<String>.class);
        List<RecallSalesAgreements__e> recallEvents = new List<RecallSalesAgreements__e>();
        for(String s:Ids){
            RecallSalesAgreements__e recallEvent = new RecallSalesAgreements__e();
            recallEvent.SalesAgreementId__c = s;
            recallEvents.add(recallEvent);
        }
        if(recallEvents.size()>0){
            Eventbus.publish(recallEvents);
        }
    }


    /*
    * @Description  Used to recall SalesAgreemnts For CR#162 MonitorForecast - Sandeep.Vishwakarma 9-27-2022
    * @Param		List<String> - Ids : List of SalesAgreemnt Id
    * @return       void
    */
    @AuraEnabled
    public static void recallSalesAgreementsEvent(List<String> Ids){
       
       List<ProcessInstanceWorkitem> workItems = [SELECT Id,ProcessInstance.TargetObjectId,actorid,createddate,CreatedById FROM ProcessInstanceWorkitem WHERE ProcessInstance.Status = 'Pending' and ProcessInstance.TargetObjectId IN:Ids];
       
       List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest> ();
	    for (ProcessInstanceWorkitem workItem: workItems) {
                Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();  
				pwr.setAction('Removed');
				pwr.setWorkItemId(workItem.id);
                requests.add(pwr);
        }
        if(workItems.size()==0){
            throw new AuraHandledException('Records are not in Approval Process');
        }
        Approval.ProcessResult[] processResults = null;
        try {
            processResults = Approval.process(requests, true);
        }catch (System.DmlException e) {
            System.debug('Exception Is ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    /*
    * @Description  A wrapper class used to hold different filters required in soql and passed by LWC in string format.
    */
    public class FiltersWrapper{
        @AuraEnabled public String indicator;
        @AuraEnabled public String salesDistrict;
        @AuraEnabled public String salesRep;
        @AuraEnabled public String salesorg;
        @AuraEnabled public String month;
        @AuraEnabled public String year;
        @AuraEnabled public String territory_id;
        FiltersWrapper(){
            this.indicator = '';
            this.salesDistrict = '';
            this.salesRep = '';
            String salesorg='';
            this.month = '';
            this.year = '';
            this.territory_id = '';
        }
    }

    /*
    * @Description  A Wrapper class holds data for SalesAgreement , salesReps, repective color(indicator).
    */
    class SalesAgreementWrapper{
        @AuraEnabled public String territory_id;
        @AuraEnabled public String salesRep;
        @AuraEnabled public String territoryCode;
        @AuraEnabled public String salesDistrict;
        @AuraEnabled public String salesDistrictManager;
        @AuraEnabled public String month;
        @AuraEnabled public String year;
        @AuraEnabled public String indicator;
        @AuraEnabled public Integer indicatorCount;
        @AuraEnabled public Boolean isRed;
        @AuraEnabled public Boolean isyellow;
        @AuraEnabled public Boolean isblue;
        @AuraEnabled public Boolean isgreen;
        @AuraEnabled public String salesRep_id;

        public SalesAgreementWrapper(){
            territory_id='';
            salesRep='';
            territoryCode = '';
            salesDistrict='';
            salesDistrictManager = '';
            month='';
            year='';
            indicator='';
            indicatorCount=0;
            isRed = false;
            isblue = false;
            isyellow = false;
            isgreen = false;
            salesRep_id = '';
        }
    }
}