@RestResource(urlmapping = '/weatherormandidetails/')
global without sharing class GetWeatherOrMandiInfo {
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
        String humidityVal='';
        String windSpeedVal='';
        String mandiRes='';
        Date todaysDate=null;
        String dayString='';
        String newPhone='%'+phone;
        //List<String> phoneLst=setPhoneNumbers(phone);
        List<Account> accLst=[select id,name,Village__pc,Village_Pin_Code__pc,Village_Pin_Code_Manual__pc,District__pc,State__pc,Tehsil__pc,State_Language__pc,
        Preferred_Language__pc from Account where PersonMobilePhone like :newPhone limit 1];
        //or PersonMobilePhone=:phone or Phone=:phone

        if(accLst.size()>0)
        {
            district=accLst[0].District__pc!=null?accLst[0].District__pc:'';
            tehsil=accLst[0].Tehsil__pc!=null?accLst[0].Tehsil__pc:'';
            state=accLst[0].State__pc!=null?accLst[0].State__pc:'';
            postalCode=accLst[0].Village_Pin_Code__pc!=null?accLst[0].Village_Pin_Code__pc:accLst[0].Village_Pin_Code_Manual__pc!=null?accLst[0].Village_Pin_Code_Manual__pc:'';
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
                maxTempVal = maxTemp.replace('null', '1');
                minTempVal= String.valueOf(minTempStr[0]+'°C');
                Integer day = 0*2;
                Integer night = (0*2)+1;
                System.debug('rainD'+String.valueOf(percipChancestr[day]));
                System.debug('rainN'+String.valueOf(percipChancestr[night]));
                String rainDay1=String.valueOf(percipChancestr[day]) != null ? String.valueOf(percipChancestr[day]):'1';
                String rainNight1=String.valueOf(percipChancestr[night]) != null ? String.valueOf(percipChancestr[night]):'1';
                String rainDay=rainDay1!='0'?rainDay1:'1';
                String rainNight=rainNight1!='0'?rainNight1:'1';
                rainfallVal =  rainDay +'/'+rainNight+' %';
                //rainfallVal=Integer.valueOf(percipChancestr[day])>Integer.valueOf(percipChancestr[night])?String.valueOf(percipChancestr[day]):String.valueOf(percipChancestr[night]);
                String minWindSpeed1=String.valueOf(windSpeed[day]) != null  ? String.valueOf(windSpeed[day]):'1';
                String maxWindSpeed1=String.valueOf(windSpeed[night])!=null  ?String.valueOf(windSpeed[night]):'1';
                String minWindSpeed=minWindSpeed1!='0'?minWindSpeed1:'1';
                String maxWindSpeed=maxWindSpeed1!='0'?maxWindSpeed1:'1'; 
                //windSpeedVal =  minWindSpeed  +'/'+maxWindSpeed;
                windSpeedVal=Integer.valueOf(minWindSpeed)>Integer.valueOf(maxWindSpeed)?minWindSpeed:maxWindSpeed;

                String minHumidity1=String.valueOf(humidity[day]) != null ? String.valueOf(humidity[day]):'1';
                String maxHumidity1=String.valueOf(humidity[night])!=null?String.valueOf(humidity[night]):'1';
                String minHumidity=minHumidity1!='0'?minHumidity1:'1';
                String maxHumidity=maxHumidity1!='0'?maxHumidity1:'1';
                //humidityVal=minHumidity+'/'+maxHumidity;
                humidityVal=Integer.valueOf(minHumidity)>Integer.valueOf(maxHumidity)?minHumidity:maxHumidity;
            }
        }
        JSONGenerator bodyBuilder = JSON.createGenerator(false);
        bodyBuilder.writeStartObject();
        if(accLst.size()>0)
        {

        bodyBuilder.writeFieldName('Mandi');
        bodyBuilder.writeStartObject();
        if(String.isNotBlank(finalMandiLst.market))
        {
            bodyBuilder.writeStringField('Market',finalMandiLst.market);
            mandiRes='success';
        }
        else
        {
            bodyBuilder.writeStringField('Market','');
            
        }
        if(type=='Mandi' && String.isBlank(finalMandiLst.market))
        {
            mandiRes='failure';
        }
        if(String.isNotBlank(finalMandiLst.max_price))
        {
            bodyBuilder.writeStringField('MaxVal',finalMandiLst.max_price);
            
        }
        else
        {
            bodyBuilder.writeStringField('MaxVal','');
        }
        if(String.isNotBlank(finalMandiLst.min_price))
        {
            bodyBuilder.writeStringField('MinVal',finalMandiLst.min_price);
        }
        else
        {
            bodyBuilder.writeStringField('MinVal','');
        }
        bodyBuilder.writeStringField('MandiResponse',mandiRes);
        bodyBuilder.writeEndObject();
        }
        bodyBuilder.writeFieldName('Weather');
        bodyBuilder.writeStartObject();
        if(accLst.size()==0)
        {
            bodyBuilder.writeStringField('errorcode','99');
        }
        else {
            
        
        bodyBuilder.writeStringField('Date', dayString);
        bodyBuilder.writeStringField('MaximumTemp', maxTempVal);
        bodyBuilder.writeStringField('MinimumTemp', minTempVal);
        bodyBuilder.writeStringField('Rainfall', rainfallVal);
        bodyBuilder.writeStringField('WindSpeed', windSpeedVal);
        bodyBuilder.writeStringField('Humidity', humidityVal);
        }
        bodyBuilder.writeEndObject();
        bodyBuilder.writeEndObject();
        res.responseBody=Blob.valueOf(bodyBuilder.getAsString());
        


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

    /*public static List<String> setPhoneNumbers(String phoneVal)
    {
        List<String> phoneLst=new List<String>();
        String p1='91'+phoneVal;
        String p2='+91'+phoneVal;
        phoneLst.add(p1);
        phoneLst.add(p2);
        phoneLst.add(phoneVal);
        return phoneLst;
    }*/

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
}