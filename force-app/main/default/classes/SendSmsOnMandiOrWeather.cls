@RestResource(urlmapping = '/weatherormandidetailsms/')
global without sharing class SendSmsOnMandiOrWeather {
    
    @HttpPost
    global static void postRequestValue(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String jsonBody=req.requestBody.toString();
        JSONParser parser=JSON.createParser(jsonBody);
        String fieldName,fieldValue,type,commodity,phone;
        String district,postalCode,tehsil;
        String state;
        while(parser.nextToken()!=null)
        {
            if(parser.getCurrentToken()!=JSONToken.END_OBJECT)
            {
                fieldName=parser.getCurrentName();
                fieldValue=parser.getText();
                if(fieldName!=fieldValue)
                {
                    if(fieldName=='Type')
                    {
                        type=fieldValue;
                    }

                    else if(fieldName=='Commodity')
                    {
                        commodity=fieldValue;
                    }

                    else if(fieldName=='Phone')
                    {
                        phone=fieldValue;
                    }
                }
                
            }
        }
        Integer maxValMandi=null;
        MandiWrapper finalMandiLst=new MandiWrapper();
        String maxTempVal='';
        String minTempVal='';
        String rainfallVal='';
        String windSpeedVal='';
        Date todaysDate=null;
        String humidityVal='';
        String dayString='';
        String rainfallChance='';
        String newPhone='%'+phone;
        String lang='';
        List<Account> accLst=[select id,name,Village__pc,Village__c,Village_Pin_Code__pc,Village_Pin_Code_Manual__pc,Village_Postal_Code__c,District__pc,District__c,State__pc,State__c,Tehsil__pc,Tehsil__c,State_Language__pc,
        Preferred_Language__pc,Language__c,recordType.name,Abusive_Caller__c from Account where PersonMobilePhone like :newPhone limit 1];
        //or PersonMobilePhone=:phone or Phone=:phone

        if(accLst.size()>0)
        {
            district=accLst[0].District__pc!=null?accLst[0].District__pc:'';
            state=accLst[0].State__pc!=null?accLst[0].State__pc:'';
            tehsil=accLst[0].Tehsil__pc!=null?accLst[0].Tehsil__pc:'';
            postalCode=accLst[0].Village_Pin_Code__pc!=null?accLst[0].Village_Pin_Code__pc:accLst[0].Village_Pin_Code_Manual__pc!=null?accLst[0].Village_Pin_Code_Manual__pc:'';
            lang=accLst[0].Preferred_Language__pc!=null?accLst[0].Preferred_Language__pc:'';
        }

        if(type=='Mandi')
        {
            List<MandiWrapper> mandiDetails = new List<MandiWrapper>();
            MandiPrice__c mpObj = MandiPrice__c.getOrgDefaults();
        
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            String endPointStr; 
            if(mpObj != null && String.isNotBlank(mpObj.EndPoint__c) && String.isNotBlank(mpObj.ApiKey__c)){   
                endPointStr = mpObj.EndPoint__c+'?api-key='+mpObj.ApiKey__c+'&format=json&offset=0&limit='+mpObj.Limit__c.intValue();
                request.setEndpoint(endPointStr);
                request.setMethod('GET');
            }
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                String myMapObjects = JSON.serialize((List<Object>)results.get('records')) ;
                //system.debug('body-->>'+myMapObjects);
                mandiDetails = (List<MandiWrapper>)JSON.deserialize(myMapObjects, List<MandiWrapper>.class);
                finalMandiLst=sortByLoction(mandiDetails,district,state,tehsil,commodity);

                String content = '';
                String encodedcontent = '';
                String senderId = 'Nurture';
                SMS_Template__c smsTemplate=new SMS_Template__c();


                JSONGenerator bodyBuilder = JSON.createGenerator(false);
                bodyBuilder.writeStartObject();
                bodyBuilder.writeStringField('Status Message', 'success');
                bodyBuilder.writeEndObject();
                res.responseBody=Blob.valueOf(bodyBuilder.getAsString());
                if(lang!=null){
                    if(lang=='English' || lang=='Hindi' || lang=='Telugu' || lang=='Kannada' || lang=='Tamil' || lang=='Malayalam' || lang=='Punjabi' || lang=='Gujarati' || lang=='Marathi')
                    {
                        smsTemplate = [Select id,Name__c,ObjectName__c,Template_Text__c from SMS_Template__c where ObjectName__c = 'NurtureAccount' AND Name__c like : 'MandiTemplate' AND Language__c=:lang limit 1];
                    }
                    else {
                        smsTemplate = [Select id,Name__c,ObjectName__c,Template_Text__c from SMS_Template__c where ObjectName__c = 'NurtureAccount' AND Name__c like : 'MandiTemplate' AND Language__c='Hindi' limit 1];
                    }
                    
                }
                else {
                    smsTemplate = [Select id,Name__c,ObjectName__c,Template_Text__c from SMS_Template__c where ObjectName__c = 'NurtureAccount' AND Name__c like : 'MandiTemplate' AND Language__c='Hindi' limit 1];
                }
                content=parseTemplateMandi(smsTemplate.Template_Text__c,finalMandiLst,postalCode,commodity);
                encodedcontent = EncodingUtil.urlEncode(content, 'UTF-8');
                if(!Test.isRunningTest())
                {
                    sendSMS(encodedcontent,phone,'Nurture');
                }
                
            }
        }

        else if(type=='Weather')
        {
            HttpResponse response = forecastResponse('daily',postalCode);
            if (response.getStatusCode() == 200) {
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                List<Object> maxTempStr = (List<Object>)results.get('calendarDayTemperatureMax');
                List<Object> minTempStr = (List<Object>)results.get('calendarDayTemperatureMin');
                String dayPartStr = JSON.serialize((List<Object>)results.get('daypart'));
                List<Object> dayPartResults = (List<Object>) JSON.deserializeUntyped(dayPartStr);
                Map<String, Object> result2 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(dayPartResults[0]));
                List<Object> percipTypestr = (List<Object>)result2.get('wxPhraseLong');
                List<Object> percipChancestr = (List<Object>)result2.get('precipChance');
                List<Object> humidity = (List<Object>)result2.get('relativeHumidity');
                List<Object> windSpeed = (List<Object>)result2.get('windSpeed');

                todaysDate = date.today().addDays(0);
                dayString = todaysDate.format();
                String maxTemp = String.valueOf(maxTempStr[0]+'°C');
                maxTempVal = maxTemp.replace('null', '0');
                minTempVal= String.valueOf(minTempStr[0]+'°C');
                Integer day = 0*2;
                Integer night = (0*2)+1;
                rainfallVal =  String.valueOf(percipChancestr[day]) != null ? String.valueOf(percipChancestr[day] +'/'+percipChancestr[night]+' %') : '1' +'/'+percipChancestr[night] + ' %';
                rainfallChance=String.valueOf(percipChancestr[night]) !=null?String.valueOf(percipChancestr[night]):'0';
                //rainfallVal=Integer.valueOf(percipChancestr[day])>Integer.valueOf(percipChancestr[night])?String.valueOf(percipChancestr[day]):String.valueOf(percipChancestr[night]);
                String minWindSpeed=String.valueOf(windSpeed[day]) != null ? String.valueOf(windSpeed[day]):'0';
                String maxWindSpeed=String.valueOf(windSpeed[night])!=null?String.valueOf(windSpeed[night]):'0';
                
                //windSpeedVal =  minWindSpeed  +'/'+maxWindSpeed;
                windSpeedVal=Integer.valueOf(minWindSpeed)>Integer.valueOf(maxWindSpeed)?minWindSpeed:maxWindSpeed;

                String minHumidity=String.valueOf(humidity[day]) != null ? String.valueOf(humidity[day]):'0';
                String maxHumidity=String.valueOf(humidity[night])!=null?String.valueOf(humidity[night]):'0';
                //humidityVal=minHumidity+'/'+maxHumidity;
                humidityVal=Integer.valueOf(minHumidity)>Integer.valueOf(maxHumidity)?minHumidity:maxHumidity;
                String content = '';
                String encodedcontent = '';
                String senderId = 'Nurture';
                SMS_Template__c smsTemplate=new SMS_Template__c();
                if(lang!=null){
                    if(lang=='English' || lang=='Hindi' || lang=='Telugu' || lang=='Kannada' || lang=='Tamil' || lang=='Malayalam' || lang=='Punjabi' || lang=='Gujarati' || lang=='Marathi')
                    {
                        smsTemplate = [Select id,Name__c,ObjectName__c,Template_Text__c from SMS_Template__c where ObjectName__c = 'NurtureAccount' AND Name__c like : 'WeatherTemplate' AND Language__c=:lang limit 1];
                    }
                    else {
                        smsTemplate = [Select id,Name__c,ObjectName__c,Template_Text__c from SMS_Template__c where ObjectName__c = 'NurtureAccount' AND Name__c like : 'WeatherTemplate' AND Language__c='Hindi' limit 1];
                    }
                    
                }
                else {
                    smsTemplate = [Select id,Name__c,ObjectName__c,Template_Text__c from SMS_Template__c where ObjectName__c = 'NurtureAccount' AND Name__c like : 'WeatherTemplate' AND Language__c='Hindi' limit 1];
                }
                content=parseTemplate(smsTemplate.Template_Text__c,minTempVal,maxTempVal,windSpeedVal,humidityVal,rainfallChance,postalCode);
                encodedcontent = EncodingUtil.urlEncode(content, 'UTF-8');
                if(!Test.isRunningTest())
                {
                    sendSMS(encodedcontent,phone,'Nurture');
                }
                
                JSONGenerator bodyBuilder = JSON.createGenerator(false);
                bodyBuilder.writeStartObject();
                bodyBuilder.writeStringField('Status Message', 'success');
                bodyBuilder.writeEndObject();
                res.responseBody=Blob.valueOf(bodyBuilder.getAsString());
            }
        }
    }

    public static MandiWrapper sortByLoction(list<MandiWrapper> mandiList, String districtStr, String stateStr, String tehsilStr, String commodityStr){
        list<MandiWrapper> mandiListSorted = new list<MandiWrapper>();
        String mandiMaxVal;
        String mandiMinVal;
        String marketName='';
        Boolean firstFlag=true;
        MandiWrapper finalLstMandi=new MandiWrapper();
        for(MandiWrapper md : mandiList){
            if(((md.district.contains(districtStr) || districtStr.contains(md.district)) || (md.district.contains(tehsilStr) || tehsilStr.contains(md.district))) && md.state == stateStr && md.commodity==commodityStr){
                if(firstFlag==true)
                {
                    mandiMaxVal=md.max_price;
                    mandiMinVal=md.min_price;
                    marketName=md.market;
                    finalLstMandi.max_price=md.max_price;
                    finalLstMandi.min_price=md.min_price;
                    finalLstMandi.market=md.market;
                    firstFlag=false;
                    break;
                }
                /*mandiListSorted.add(md);
                Integer tempMaxVal= Integer.valueOf(md.max_price);
                if(tempMaxVal<mandiMaxVal)
                {
                    mandiMaxVal=tempMaxVal;
                }*/

            }
        }
        
        

        return finalLstMandi;
    }

    public static HttpResponse forecastResponse(String type,String postalKey){
        String langStr = userinfo.getLocale();
        system.debug('postalKey=='+postalKey);
        Weather_API__c weatherObj = Weather_API__c.getOrgDefaults();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        if(weatherObj != null && String.isNotBlank(weatherObj.End_Point__c) && String.isNotBlank(weatherObj.Api_Key__c)){ 
            String endPointStr = weatherObj.End_Point__c+type+'/15day?postalKey='+postalKey+':'+weatherObj.CountryCode__c+'&units='+weatherObj.Unit__c+'&language='+langStr+'&format=json&apiKey='+weatherObj.Api_Key__c;
            request.setEndpoint(endPointStr);
            request.setMethod('GET');
        }
        system.debug('request=='+request);
        HttpResponse response = http.send(request);
        system.debug('response=='+response);
        return response;
    }

    @future(callout=true)
    public static void sendSMS(String encoded,String phoneNumber,String senderId){
        System.debug('@@@');
        List<SMS_Endpoint__mdt> smsmetadata = new List<SMS_Endpoint__mdt> ();
        if(senderId == 'Nurture')
        {
            smsmetadata = [Select DeveloperName,MasterLabel, KeyPart__c,SenderIDPart__c from SMS_Endpoint__mdt WHERE MasterLabel = 'Nurture'];
        }
        else{
            smsmetadata = [Select DeveloperName,MasterLabel, KeyPart__c,SenderIDPart__c from SMS_Endpoint__mdt WHERE MasterLabel = 'UPL'];
        }
        Response r = new Response();
        Status s = new Status();
        r.status = s;
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setEndpoint(smsmetadata[0].KeyPart__c+phoneNumber+smsmetadata[0].SenderIDPart__c+encoded);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'text/JSON');
        Http http = new Http();
        response = http.send(request);
        system.debug('!!!'+response);
        system.debug(response.getBody());
        List<string> splitted = response.getBody().split('&');
        if(splitted.size() > 0){
            r.ackid = splitted[0].right(splitted[0].length() - splitted[0].indexOf('=')-1);
            r.resTime = splitted[3].right(splitted[3].length() - splitted[3].indexOf('=')-1);
            s.code = splitted[1].right(splitted[1].length() - splitted[1].indexOf('=')-1);
            s.description= splitted[2].right(splitted[2].length() - splitted[2].indexOf('=')-1);
        }
        r.res = response.getBody();
        
    }

    public static String parseTemplate(String template,String minTemp,String maxTemp,String windSpeed,String humidity,String rainChance,String pincode){
        template=template.replaceFirst('\\{\\#var\\#\\}','care');
        template=template.replaceFirst('\\{\\#var\\#\\}',pincode);
        template=template.replaceFirst('\\{\\#var\\#\\}',maxTemp);
        template=template.replaceFirst('\\{\\#var\\#\\}',minTemp);
        template=template.replaceFirst('\\{\\#var\\#\\}',rainChance);
        template=template.replaceFirst('\\{\\#var\\#\\}',windSpeed);
        template=template.replaceFirst('\\{\\#var\\#\\}','18001021199');

        
        return template;
    }

    public static String parseTemplateMandi(String template,MandiWrapper finalMandiLst,String postalCode,String commodity)
    {
        String market=finalMandiLst.market!=null?finalMandiLst.market:'';
        String maxVal=finalMandiLst.max_price!=null?finalMandiLst.max_price:'';
        String minVal=finalMandiLst.min_price!=null?finalMandiLst.min_price:'';
        template=template.replaceFirst('\\{\\#var\\#\\}','care');
        template=template.replaceFirst('\\{\\#var\\#\\}',postalCode);
        template=template.replaceFirst('\\{\\#var\\#\\}',market);
        template=template.replaceFirst('\\{\\#var\\#\\}',commodity);
        template=template.replaceFirst('\\{\\#var\\#\\}',maxVal);
        template=template.replaceFirst('\\{\\#var\\#\\}',minVal);
        template=template.replaceFirst('\\{\\#var\\#\\}','18001021199');
        return template;

    }

    public class MandiWrapper{
        
        public Integer Id;
        
        public String commodity{get;set;}
        
        public String variety{get;set;}
        
        public String market{get;set;}
        // @AuraEnabled
        //public String arrival_date{get;set;}
        
        public String district{get;set;}
        
        public String state{get;set;}
        
        public String modal_price{get;set;}
        
        public String max_price{get;set;}
        
        public String min_price{get;set;}
    }

    public class Status{
        public String code;
        public String description;
    }

    public class Response {
        public String ackid;
        public String resTime;
        public Status status;
        public String res;
    }
}