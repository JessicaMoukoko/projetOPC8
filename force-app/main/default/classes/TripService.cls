public with sharing class TripService {

     // Méthode pour créer un voyage
    public static Trip__c createTrip(String name) {
        Account acc = AccountService.createAccount('Client Test');
        opportunity opp = OpportunityService.createOpportunity(
            name,
            acc.Id, // AccountId
            Date.today().addDays(30), // CloseDate
            'Prospecting', // StageName
            'Paris', // Destination__c
            Date.today().addDays(30), // Start_Date__c
            Date.today().addDays(37), // End_Date__c
            100, // Amount
            20  // Number_of_Participants__c
        );
        Trip__c trip = new Trip__c(Name = name,Account__c = acc.Id,
         Opportunity__c = opp.Id,
         Destination__c = opp.Destination__c,
          Start_Date__c = opp.Start_Date__c,
           End_Date__c = opp.End_Date__c,
            Number_of_Participants__c = opp.Number_of_Participants__c);
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