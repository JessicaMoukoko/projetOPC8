@isTest
public class BatchTripStatusTest {

    @isTest
     // méthode de test pour l'exécution du batch et la vérification des statuts
    static void testBatchTripStatusExecution() {

       Account acc = TestDataFactory.createAccount('Test Account');
        Opportunity opp = TestDataFactory.createOpportunity(
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

        // Cas 1 : Voyage à venir où à la date du jour (today <= start) → doit rester à "A venir"    

        Trip__c trip1 = TestdataFactory.createTrip(
            'A venir',
            acc.Id,
            opp.Id,
            'Paris',
            today.addDays(5),
            today.addDays(10),
            20
        );
         
        // Cas 2 : Voyage en cours où à la date du jour (start < today < end) → doit passer à "En Cours"

        Trip__c trip2 = TestdataFactory.createTrip(
            'A venir',
            acc.Id, 
            opp.Id,
            'Paris',
            today.addDays(-2),
            today.addDays(2),
            20
        );
        
        // Cas 3 : Voyage terminé (today > end)

        Trip__c trip3 = TestdataFactory.createTrip(
            'En cours',
            acc.Id,
            opp.Id,
            'Paris',
            today.addDays(-10),
            today.addDays(-5),
            20
        ); 

        // Cas 4 : Déjà annulé → ignoré

        Trip__c trip4 = TestdataFactory.createTrip(
            'Annulé',
            acc.Id,
            opp.Id,
            'Paris',
            today.addDays(5),
            today.addDays(10),
            20
        ); 

        // Cas 5 : Déjà terminé → ignoré

        Trip__c trip5 = TestdataFactory.createTrip(
            'Terminé',
            acc.Id,
            opp.Id,
            'Paris',
            today.addDays(-10),
            today.addDays(-5),
            20
        );

        trips.add(trip1);
        trips.add(trip2);
        trips.add(trip3);
        trips.add(trip4);
        trips.add(trip5);

        // Exécution du batch
        Test.startTest();
        Database.executeBatch(new BatchTripStatus(), 200);
        Test.stopTest();

        // Récupération des résultats
        Map<Id, Trip__c> results = new Map<Id, Trip__c>(
            [SELECT Status__c FROM Trip__c WHERE Id IN :trips]
        );

        // Assertions - Vérifier les statuts attendus pour chaque cas de test
        System.assertEquals('A venir', results.get(trips[0].Id).Status__c, 'Cas 1: Voyage à venir');
        System.assertEquals('En Cours', results.get(trips[1].Id).Status__c, 'Cas 2: Voyage en cours');
        System.assertEquals('Terminé', results.get(trips[2].Id).Status__c, 'Cas 3: Voyage terminé');
        System.assertEquals('Annulé', results.get(trips[3].Id).Status__c, 'Cas 4: Voyage annulé');
        System.assertEquals('Terminé', results.get(trips[4].Id).Status__c, 'Cas 5: Voyage terminé');
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