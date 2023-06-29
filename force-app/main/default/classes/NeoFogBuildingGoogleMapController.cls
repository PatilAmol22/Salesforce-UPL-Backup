public class NeoFogBuildingGoogleMapController {
    @AuraEnabled
    public static List<Neofog_Building__c> getNeoFogBuilding(Id neoFogId) {
        return [SELECT Id, Name, GPS_Coordinates__c, GPS_Coordinates__Latitude__s, GPS_Coordinates__Longitude__s FROM Neofog_Building__c WHERE Id = : neoFogId];  
    }
}