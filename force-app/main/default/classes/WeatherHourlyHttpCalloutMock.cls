@isTest
global class WeatherHourlyHttpCalloutMock implements HttpCalloutMock{
   global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
       String jStr ='{';
               jStr +='"temperature": [26,26,26,26,26,26,26,26,26,25,12,12 ],';
               jStr +='"validTimeLocal": ["2021-09-01T18:30:00+0530","2021-09-01T19:30:00+0530","2021-09-01T20:30:00+0530","2021-09-01T21:30:00+0530",';
               jStr +='"2021-09-01T22:30:00+0530","2021-09-01T23:30:00+0530","2021-09-02T00:30:00+0530","2021-09-02T01:30:00+0530",';
               jStr +='"2021-09-02T02:30:00+0530","2021-09-02T03:30:00+0530","2021-09-02T04:30:00+0530","2021-09-02T05:30:00+0530",';
               jStr +='"2021-09-02T06:30:00+0530","2021-09-02T07:30:00+0530","2021-09-02T08:30:00+0530","2021-09-02T09:30:00+0530",';
               jStr +='"2021-09-02T10:30:00+0530","2021-09-02T11:30:00+0530","2021-09-02T12:30:00+0530","2021-09-02T16:30:00+0530",';
               jStr +='"2021-09-02T13:30:00+0530","2021-09-02T14:30:00+0530","2021-09-02T15:30:00+0530"],';
               jStr +='"wxPhraseLong": ["Cloudy","Cloudy","Cloudy","Cloudy","Cloudy","Cloudy","Scattered Thunderstorms",';
               jStr +='"Thunderstorms","Thunderstorms","Thunderstorms","Thunderstorms","Scattered Thunderstorms","Scattered Thunderstorms",';
               jStr +='"Scattered Thunderstorms","Scattered Thunderstorms","Scattered Thunderstorms"]';
               jStr +='}';
       
       
        response.setBody(jStr);
        response.setStatusCode(200);
        return response; 
    }
}