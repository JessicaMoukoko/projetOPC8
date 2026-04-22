public with sharing class TripService {

    // Méthode pour créer un voyage
   public static Trip__c createTrip(String name) {
    Account acc = AccountService.createAccount('Client Test');
    Opportunity opp = OpportunityService.createOpportunity(
        name,
        acc.Id,
        Date.today().addDays(30),
        'Prospecting',
        'Paris',
        Date.today().addDays(30),
        Date.today().addDays(37),
        100,
        20
    );
    Trip__c trip = new Trip__c(
        Account__c = acc.Id,
        Opportunity__c = opp.Id,
        Destination__c = opp.Destination__c,
        Start_Date__c = opp.Start_Date__c,
        End_Date__c = opp.End_Date__c,
        Number_of_Participants__c = opp.Number_of_Participants__c
    );
    insert trip;

    // Requête nécessaire pour récupérer le Name (autonumber) généré par Salesforce
    
    return [SELECT Id, Name, Destination__c, Start_Date__c, End_Date__c, Number_of_Participants__c
            FROM Trip__c WHERE Id = :trip.Id];
}

    // Méthode pour récupérer un voyage par son Id
    public static Trip__c getTripById(Id tripId) {
        return [
            SELECT Id, Name, Destination__c, Start_Date__c, End_Date__c, Number_of_Participants__c
            FROM Trip__c
            WHERE Id = :tripId
            LIMIT 1
        ];
    }

    // Méthode pour mettre à jour la destination d'un voyage
    public static Trip__c updateTrip(Id tripId, String destination) {
        Trip__c trip = [
            SELECT Id, Destination__c
            FROM Trip__c
            WHERE Id = :tripId
            LIMIT 1
        ];
        trip.Destination__c = destination;
        update trip;
        return trip;
    }

    // Méthode pour supprimer un voyage
    public static void deleteTrip(Id tripId) {
        delete [SELECT Id FROM Trip__c WHERE Id = :tripId];
    }
}