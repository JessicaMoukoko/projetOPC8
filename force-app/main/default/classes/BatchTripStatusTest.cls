@isTest
public class BatchTripStatusTest {

    @isTest
     // méthode de test pour l'exécution du batch et la vérification des statuts
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
                                      
                // Cas 1 : Voyage à venir où à la date du jour (today <= start) → doit rester à "A venir"                        
        trips.add(new Trip__c(
            Start_Date__c = today.addDays(5),
            End_Date__c = today.addDays(10),
            Status__c = 'A venir',
            Account__c = acc.Id,
            Opportunity__c = opp.Id,
            Destination__c = 'Paris',
            Number_of_Participants__c = 20
        ));

            // Cas 2 : Voyage en cours où à la date du jour (start < today < end) → doit passer à "En Cours"
        trips.add(new Trip__c(
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