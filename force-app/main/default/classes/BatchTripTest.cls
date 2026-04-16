@isTest
public class BatchTripTest {

    @isTest
    static void testBatchTripExecution() {
        Account acc = AccountService.createAccount('Test Account');
        Opportunity opp = OpportunityService.createOpportunity(
            'Test Opportunity',
            acc.Id,
            Date.today().addDays(30),
            'Prospecting',
            'Paris',
             Date.today().addDays(30),
             Date.today().addDays(37),
             100,
             20
        );
        // Dates de test
        Date today = Date.today();
        Date targetDate = today.addDays(7);

        // Création des données de test
        List<Trip__c> trips = new List<Trip__c>();

        // Cas 1 : doit être annulé (<10 participants)
        trips.add(new Trip__c(
            Name = 'Trip 1',
            Status__c = 'A venir',
            Account__c = acc.Id,
            Opportunity__c = opp.Id,
            Destination__c = 'Paris',
            End_Date__c = targetDate.addDays(5),
            Start_Date__c = targetDate,
            Number_of_Participants__c = 5    
        ));

        // Cas 2 : ne doit PAS être annulé (>=10 participants)
        trips.add(new Trip__c(
            Name = 'Trip 2',
            Status__c = 'A venir',
            Account__c = acc.Id,
            Opportunity__c = opp.Id,
            Destination__c = 'Paris',
            End_Date__c = targetDate.addDays(5),
            Start_Date__c = targetDate,
            Number_of_Participants__c = 15    

        ));

        // Cas 3 : hors périmètre (date différente)
        trips.add(new Trip__c(
            Name = 'Trip 3',
            Start_Date__c = today.addDays(10),
            Number_of_Participants__c = 3,
            Status__c = 'A venir',
            Account__c = acc.Id,
            Opportunity__c = opp.Id,
            Destination__c = 'Paris',
            End_Date__c = today.addDays(10).addDays(5)
        ));

        insert trips;

        // Exécution du batch
        Test.startTest();
        BatchTrip batch = new BatchTrip();
        Database.executeBatch(batch, 200);
        Test.stopTest();

        // Vérification des résultats
        List<Trip__c> updatedTrips = [
            SELECT Id, Status__c, Number_of_Participants__c, Start_Date__c
            FROM Trip__c
            WHERE Id IN :trips
        ];

        for(Trip__c t : updatedTrips) {
            if(t.Number_of_Participants__c < 10 && t.Start_Date__c == targetDate) {
                System.assertEquals('Annulé', t.Status__c, 'Le voyage aurait dû être annulé');
            }
            if(t.Number_of_Participants__c >= 10 && t.Start_Date__c == targetDate) {
                System.assertNotEquals('Annulé', t.Status__c, 'Le voyage ne devait pas être annulé');
            }
        }
    }

    @isTest
    static void testBatchWithNoTripsToUpdate() {

        Date targetDate = Date.today().addDays(7);
        Account acc = AccountService.createAccount('Test Account');
        Opportunity opp = OpportunityService.createOpportunity(
            'Test Opportunity',
            acc.Id,
            Date.today().addDays(30),
            'Prospecting',
            'Paris',
             Date.today().addDays(30),
             Date.today().addDays(37),
             100,
             20
        );
        // Aucun trip à annuler
        Trip__c trip = new Trip__c(
            Name = 'Trip OK',
            Status__c = 'A venir',
            Account__c = acc.Id,
            Opportunity__c = opp.Id,
            Destination__c = 'Paris',
            End_Date__c = targetDate.addDays(5),
            Start_Date__c = targetDate,
            Number_of_Participants__c = 20
        );

        insert trip;

        Test.startTest();
        Database.executeBatch(new BatchTrip(), 200);
        Test.stopTest();

        // Vérification
        Trip__c result = [
            SELECT Status__c FROM Trip__c WHERE Id = :trip.Id
        ];

        System.assertEquals('A venir', result.Status__c);
    }
}