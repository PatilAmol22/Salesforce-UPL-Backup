/*
 Name : WeatherForecastCtlr
 Author : Kuhinoor
 Description : This is class send request to IBM weather API and get the resonpse to display in upl APP.
*/

public class WeatherForecastCtlr {
    public integer totalRecs{get;set;}       
    public integer index{get;set;}  
    public integer blockSize{get;set;}  
    public integer pageNo{get;set;}
    private integer pageSize = 5;
    public Id recordId{get;set;}
    public Boolean showMore{get;set;}
    public Boolean isWeekly{get;set;}
    public Boolean isHoulry = false;
    public Boolean isWeekSel{get;set;}
    public String msg{get;set;}
    List<weatherClass> weatherListOriginal;
    List<weatherClass> weatherListResult;
    private static String postalKey;
    
    /*
     Name : init
   Description : this method call at time of page to intialize for daily forecast
    */
    public void init(){
        msg ='Loading....';
        index = 0; 
        blockSize = 5;
        pageNo = 1;
        totalRecs = 0;
        showMore = false;
        weatherListResult = new List<weatherClass>(); 
        weatherListOriginal = new List<weatherClass>(); 
        weatherListOriginal = getWeatherForecast(recordId);
        weatherListResult = weatherListOriginal;
        totalRecs= weatherListResult.size();
        
    }
    
    /*
     Name : init2
   Description : this method call at time of page to intialize for hourly forecast
    */
    public void init2(){
        index = 0; 
        blockSize = 5;
        pageNo = 1;
        showMore = false;
        weatherListResult = new List<weatherClass>(); 
        weatherListOriginal = new List<weatherClass>(); 
        weatherListOriginal = hourlyWeatherForecast(recordId);
        weatherListResult = weatherListOriginal;
        totalRecs= weatherListResult.size();
    }
    
    /*
     Name : getWeatherForecast
   Description : this method process daily forcast data for vf component
    */
    public list<weatherClass> getWeatherData(){
        list<weatherClass> weatherList = new list<weatherClass>();
        if(weatherListResult != null){
            if(weatherListResult.size() > 0){
                for(Integer i=index; i<blockSize; i++){
                    weatherList.add(weatherListResult[i]);
                }
                msg ='';
            }else{
                msg ='Something went wrong..';
            }
        }else{
            msg ='Loading..';
        }
        return weatherList;
    }
    
    /*
     Name : getForecast
   Description : this method process daily forcast data for aura 
   Param : accountId
    */
    @AuraEnabled
    public static List<weatherClass> getForecast(Id accountId){
        system.debug('acc id=='+getWeatherForecast(accountId));
        return getWeatherForecast(accountId);
    } 
    
    /*
     Name : getWeatherForecast
   Description : this method process daily forcast data
     Param : accountId
    */
    public static List<weatherClass> getWeatherForecast(Id accountId){
        List<weatherClass> weatherList = new List<weatherClass>();
        HttpResponse response = forecastResponse(accountId, 'daily');
        system.debug('response code=='+response.getStatusCode());
        system.debug('response code=='+response.getStatus());
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
            
            for(integer i=0;i< 10; i++){
                weatherClass we = new weatherClass();
                we.location = 'Test';
                we.dt = date.today().addDays(i);
                String maxTemp = String.valueOf(maxTempStr[i]+'°C');
                we.maxTemp = maxTemp.replace('null', '_');
                we.minTemp = String.valueOf(minTempStr[i]+'°C');
                Integer day = i*2;
                Integer night = (i*2)+1;
                we.weather = (String)percipTypestr[day];
                we.percip =  String.valueOf(percipChancestr[day]) != null ? String.valueOf(percipChancestr[day] +'/'+percipChancestr[night]+' %') : '--' +'/'+percipChancestr[night] + ' %';
                we.humidity = humidity[day] +'/'+humidity[night];
                we.windSpeed = windSpeed[day] +'/'+windSpeed[night];
                weatherList.add(we);
            }
            return weatherList;
        }
        return new List<weatherClass>();
    }
    
    /*
     Name : getHourlyForecast
   Description : this method process hourly forcast data for aura 
   Param : accountId 
    */
    @AuraEnabled
    public static List<weatherClass> getHourlyForecast(Id accountId){
        return hourlyWeatherForecast(accountId);
    }
    
    /*
     Name : hourlyWeatherForecast
   Description : this method process hourly forcast data for vf component
   Param : accountId
    */
    public static List<weatherClass> hourlyWeatherForecast(Id accountId){
        List<weatherClass> weatherList = new List<weatherClass>();
        HttpResponse response = forecastResponse(accountId, 'hourly');
        if (response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            List<Object> maxTempStr = (List<Object>)results.get('temperature');      
            List<Object> validTimeLocal = (List<Object>)results.get('validTimeLocal');   
            List<Object> wxPhraseLong = (List<Object>)results.get('wxPhraseLong');  
            
            for(integer i=0;i< 12; i++){
                weatherClass we = new weatherClass();
                we.maxTemp = string.valueOf(maxTempStr[i]+'°C'); 
                String str = string.valueOf(validTimeLocal[i]);
                String newStr = str.split('\\+')[0];
                newStr = '"'+newstr+'"';
                DateTime dt = (datetime)JSON.deserialize(newStr, Datetime.class); 
                dt = dt.addMinutes(-330);
                we.currTime = dt.format('h:mm a');
                we.weather = string.valueOf(wxPhraseLong[i]);
                weatherList.add(we);
            }
            return weatherList;
        }
        
        return new List<weatherClass>();
    }
    
    /*
     Name : forecastResponse
   Description : this method call weather service based on type
   Param : accountId, type[API type]
    */
    public static HttpResponse forecastResponse(Id accountId, String type){
        String langStr = userinfo.getLocale();
        system.debug('postalKey=='+postalKey);
        if(String.isBlank(postalKey) ){
            List<Account> accList = [ SELECT Id,Village_Pin_Code__pc,Village_Pin_Code_Manual__pc FROM account WHERE Id = : accountId];
            if(!accList.isEmpty()){
                system.debug('postal key###'+accList[0].Village_Pin_Code__pc);
                system.debug('postal key###'+accList[0].Village_Pin_Code_Manual__pc);
                if(accList[0].Village_Pin_Code__pc!=null) 
                    postalKey = accList[0].Village_Pin_Code__pc;
                if(accList[0].Village_Pin_Code_Manual__pc!=null) 
                    postalKey = accList[0].Village_Pin_Code_Manual__pc;
                
            }
        }
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
    
  /*
     Name : beginning
   Description : this method display first page
    */    
    public void beginning() {  
        index = 0;  
        blockSize = pageSize;
        pageNo = 1;
    }  
      
    /*
     Name : previous
   Description : this method display previous page
    */ 
    public void previous() { 
        pageNo--;
        index = (pageNo-1) * pageSize; 
        blockSize = pageNo *pageSize;
    }  
      
    /*
     Name : next
   Description : this method display next page
    */ 
    public void next() {    
        pageNo++;
        index = (pageNo-1) * pageSize; 
        blockSize = pageNo *pageSize;
        if(blockSize > totalrecs){
            blockSize = totalrecs;
        }
    }  
  
    /*
     Name : end
   Description : this method display last page
    */ 
    public void end() { 
        pageNo = (Integer)math.ceil(totalRecs/pageSize)+1;
        Integer endIndex = math.mod(totalRecs,pageSize);
        index = totalrecs - (endIndex > 0 ? endIndex : pageSize); 
        blockSize = totalrecs;
    }          
     
    /*
     Name : getprev
   Description : this method return boolean to hide/show previous button
    */ 
    public boolean getprev() {  
        if(index == 0)  
            return true;  
        else  
            return false;  
  
    }    
      
    /*
     Name : getnxt
   Description : this method return boolean to hide/show next button
    */ 
    public boolean getnxt() {  
        if((index + 5) >= totalRecs)  
        return true;  
        else  
        return false;  
    } 
    
    /*
     Name : moreRows
   Description : this method display more rows 
    */ 
    public void moreRows(){
        showMore = true;
    }
    
    /*
     Name : lessRows
   Description : this method display less rows 
    */ 
    public void lessRows(){
        showMore = false;
    }
    
    
}