/*
 Name : weatherClass
 Author : Kuhinoor
 Description : this is wrapper class using in WeatherForecastCtlr.
*/ 

public class weatherClass{
        @AuraEnabled
        Public String location;
        @AuraEnabled
        Public Date dt{get;set;}
        @AuraEnabled
        public String maxTemp{get;set;}
        @AuraEnabled
        public String minTemp{get;set;}
        @AuraEnabled
        public String weather{get;set;}
        @AuraEnabled
        public String percip{get;set;}
        @AuraEnabled
        public String humidity{get;set;} 
        @AuraEnabled
        public String windSpeed{get;set;}
        @AuraEnabled
        public String currTime{get;set;}
    }