public with sharing class TripService {

     // Méthode pour créer un voyage
    public static Trip__c createTrip(String name) {
        Trip__c trip = new Trip__c(Name = name);
        insert trip;
        return trip;
    }
   
      // Méthode pour récupérer un voyage par son Id
    public static Trip__c getTripById(Id tripId) {
        return [
            SELECT Id, Name
            FROM Trip__c
            WHERE Id = :tripId
            LIMIT 1
        ];
    }

     // Méthode pour update le nom d'un voyage
    public static Trip__c updateTrip(Id tripId, String newName) {
        Trip__c trip = [
            SELECT Id, Name
            FROM Trip__c
            WHERE Id = :tripId
            LIMIT 1
        ];
        trip.Name = newName;
        update trip;
        return trip;
    }

      // Méthode pour supprimer un voyage
    public static void deleteTrip(Id tripId) {
        delete [SELECT Id FROM Trip__c WHERE Id = :tripId];
    }
}