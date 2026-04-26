@isTest
public class OpportunityTriggerHandlerTest {


    @isTest
    static void testHandleAfterUpdate_CreateTrip() {

        Account acc = AccountService.createAccount('Test Account');
        Opportunity opp = OpportunityService.createOpportunity(
            'Test Opportunity',
            acc.Id,
            Date.today().addDays(10),
            'Prospecting',
            'Paris',
            Date.today().addDays(20),
            Date.today().addDays(25),
            1000,
            2
        );

        // Simuler oldMap (avant update)
        Opportunity oldOpp = opp.clone(false, true, false, false);
        oldOpp.StageName = 'Prospecting';

        Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>{
            opp.Id => oldOpp
        };

        // Update vers Closed Won
        opp.StageName = 'Closed Won';

        Test.startTest();
        OpportunityTriggerHandler.handleAfterUpdate(
            new List<Opportunity>{ opp },
            oldMap
        );
        Test.stopTest();

        // Vérifier qu’un Trip__c a été créé
        List<Trip__c> trips = [
            SELECT Id, Status__c, Destination__c, Opportunity__c
            FROM Trip__c
            WHERE Opportunity__c = :opp.Id
        ];

        System.assertEquals(1, trips.size(), 'Un trip doit être créé');
        System.assertEquals('A venir', trips[0].Status__c);
        System.assertEquals('Paris', trips[0].Destination__c);
    }

    @isTest
    static void testHandleAfterUpdate_NoTripIfAlreadyClosedWon() {

        Account acc = AccountService.createAccount('Test Account');
        Opportunity opp = OpportunityService.createOpportunity(
            'Test Opportunity',
            acc.Id,
            Date.today().addDays(10),
            'Closed Won',
            'Paris',
            Date.today().addDays(20),
            Date.today().addDays(25),
            1000,
            2
        );

        // Simuler déjà Closed Won avant update
        Opportunity oldOpp = opp.clone(false, true, false, false);
        oldOpp.StageName = 'Closed Won';

        Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>{
            opp.Id => oldOpp
        };

        // Toujours Closed Won après update
        opp.StageName = 'Closed Won';

        Test.startTest();
        OpportunityTriggerHandler.handleAfterUpdate(
            new List<Opportunity>{ opp },
            oldMap
        );
        Test.stopTest();

        // Vérifier qu’aucun Trip__c n’est créé
        List<Trip__c> trips = [
            SELECT Id FROM Trip__c WHERE Opportunity__c = :opp.Id
        ];

        System.assertEquals(0, trips.size(), 'Aucun trip ne doit être créé');
    }

    @isTest
    static void testHandleAfterUpdate_NoTripIfNotClosedWon() {

        Account acc = AccountService.createAccount('Test Account');
        Opportunity opp = OpportunityService.createOpportunity(
            'Test Opportunity',
            acc.Id,
            Date.today().addDays(10),
            'Prospecting',
            'Paris',
            Date.today().addDays(20),
            Date.today().addDays(25),
            1000,
            2
        );

        // old stage
        Opportunity oldOpp = opp.clone(false, true, false, false);
        oldOpp.StageName = 'Prospecting';

        Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>{
            opp.Id => oldOpp
        };

        // nouveau stage différent de Closed Won
        opp.StageName = 'Negotiation/Review';

        Test.startTest();
        OpportunityTriggerHandler.handleAfterUpdate(
            new List<Opportunity>{ opp },
            oldMap
        );
        Test.stopTest();

        // Vérifier qu’aucun Trip__c n’est créé
        List<Trip__c> trips = [
            SELECT Id FROM Trip__c WHERE Opportunity__c = :opp.Id
        ];

        System.assertEquals(0, trips.size(), 'Aucun trip ne doit être créé');
    }
}