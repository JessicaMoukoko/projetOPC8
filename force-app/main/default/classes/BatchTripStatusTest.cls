@isTest
public class BatchTripStatusTest {

    @isTest
    static void testBatchTripStatusExecution() {
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
        Date today = Date.today();

        List<Trip__c> trips = new List<Trip__c>();

        // Cas 1 : Voyage à venir (Start_Date > today)
        trips.add(new Trip__c(
            Name = 'Trip A venir',
            Start_Date__c = today.addDays(5),
            End_Date__c = today.addDays(10),
            Status__c = 'A venir',
            Account__c = acc.Id,
            Opportunity__c = opp.Id,
            Destination__c = 'Paris',
            Number_of_Participants__c = 20
        ));

        // Cas 2 : Voyage en cours (today entre start et end)
        trips.add(new Trip__c(
            Name = 'Trip En cours',
            Start_Date__c = today.addDays(-2),
            End_Date__c = today.addDays(2),
            Status__c = 'A venir', 
            Account__c = acc.Id,
            Opportunity__c = opp.Id,
            Destination__c = 'Paris',
            Number_of_Participants__c = 20
        ));

        // Cas 3 : Voyage terminé (today > end)
        trips.add(new Trip__c(
            Name = 'Trip Terminé',
            Start_Date__c = today.addDays(-10),
            End_Date__c = today.addDays(-5),
            Status__c = 'A venir',
            Account__c = acc.Id,
            Opportunity__c = opp.Id,
            Destination__c = 'Paris',
            Number_of_Participants__c = 20  
        ));

        // Cas 4 : Déjà annulé → ignoré
        trips.add(new Trip__c(
            Name = 'Trip Annulé',
            Start_Date__c = today.addDays(5),
            End_Date__c = today.addDays(10),
            Status__c = 'Annulé',
            Account__c = acc.Id,
            Opportunity__c = opp.Id,
            Destination__c = 'Paris',
            Number_of_Participants__c = 20
        ));

        // Cas 5 : Déjà terminé → ignoré
        trips.add(new Trip__c(
            Name = 'Trip Déjà Terminé',
            Start_Date__c = today.addDays(-10),
            End_Date__c = today.addDays(-5),
            Status__c = 'Terminé',
            Account__c = acc.Id,
            Opportunity__c = opp.Id,
            Destination__c = 'Paris',
            Number_of_Participants__c = 20  
        ));

        insert trips;

        // Exécution du batch
        Test.startTest();
        Database.executeBatch(new BatchTripStatus(), 200);
        Test.stopTest();

        // Récupération des résultats
        Map<String, Trip__c> results = new Map<String, Trip__c>();
        for(Trip__c t : [
            SELECT Name, Status__c 
            FROM Trip__c 
            WHERE Id IN :trips
        ]) {
            results.put(t.Name, t);
        }

        // Assertions
        System.assertEquals('A venir', results.get('Trip A venir').Status__c);
        System.assertEquals('En Cours', results.get('Trip En cours').Status__c);
        System.assertEquals('Terminé', results.get('Trip Terminé').Status__c);

        // Vérifier qu'ils ne changent pas
        System.assertEquals('Annulé', results.get('Trip Annulé').Status__c);
        System.assertEquals('Terminé', results.get('Trip Déjà Terminé').Status__c);
    }

    @isTest
    static void testBatchWithEmptyScope() {

        // Aucun enregistrement à traiter
        Test.startTest();
        Database.executeBatch(new BatchTripStatus(), 200);
        Test.stopTest();

        // Si aucune exception → OK
        System.assert(true);
    }
}