@isTest
global class WeatherHttpCalloutMock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        String jStr = '{ "calendarDayTemperatureMax": [33,33,24,34,34,34,33,32,31,32,33,33,33,32,32],';
                jStr +='"calendarDayTemperatureMin": [25,24,24,24,25,25,25,24,24,24,24,24,24,24,24],';
                jStr +='"daypart": [{"precipChance": [null,4,4,4,4,2,8,6,8,18,18,24,33,40,47,44,60,24,42,21,24,24,24,18,37,24,24,24,24,36],';
                jStr +='"relativeHumidity":[null,59,55,62,53,61,51,60,49,63,51,67,59,76,64,78,65,78,63,73,62,72,62,72,61,71,62,73,64,75],';
                jStr +='"windSpeed": [null,21,24,15,20,10,16,9,13,7,13,10,16,16,13,12,10,9,12,11,14,10,12,11,12,10,12,11,12,12],';
                jStr +='"wxPhraseLong": [null,"Partly Cloudy","Partly Cloudy","Partly Cloudy","Partly Cloudy","Partly Cloudy","Partly Cloudy","Partly Cloudy","Partly Cloudy","Partly Cloudy","Mostly Sunny","Partly Cloudy","Isolated Thunderstorms","Isolated Thunderstorms","Scattered Thunderstorms","Scattered Thunderstorms","Scattered Thunderstorms","Partly Cloudy","PM Thunderstorms","Partly Cloudy","Partly Cloudy","Partly Cloudy","Partly Cloudy","Partly Cloudy","Isolated Thunderstorms","Partly Cloudy","Partly Cloudy","Partly Cloudy","Partly Cloudy","Thunderstorms Late"]';
                jStr +='}]}';
            
            
        response.setBody(jStr);
        response.setStatusCode(200);
        return response; 
    }
}