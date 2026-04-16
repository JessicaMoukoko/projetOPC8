@isTest
public class OpportunityServiceTest {

    // Méthode utilitaire pour créer un Account
    private static Account createTestAccount() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        return acc;
    }

    @isTest
    static void testCreateOpportunity() {
        Account acc = createTestAccount();

        Test.startTest();
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
        Test.stopTest();

        System.assertNotEquals(null, opp.Id, 'L\'opportunité doit être créée');
        System.assertEquals('Test Opportunity', opp.Name);
        System.assertEquals('Prospecting', opp.StageName);
        System.assertEquals(acc.Id, opp.AccountId);
    }

    @isTest
    static void testGetOpportunityById() {
        Account acc = createTestAccount();
        
        Opportunity opp = OpportunityService.createOpportunity(
            'Test Opportunity',
            acc.Id,
            Date.today().addDays(30),
            'Prospecting',
            'Paris',
             Date.today().addDays(30),
             Date.today().addDays(37),
             100,
             20);

        Test.startTest();
        Opportunity result = OpportunityService.getOpportunityById(opp.Id);
        Test.stopTest();

        System.assertEquals(opp.Id, result.Id);
        System.assertEquals('Test Opportunity', result.Name);
        System.assertEquals('Prospecting', result.StageName);
    }

    @isTest
    static void testUpdateOpportunity() {
        Account acc = createTestAccount();
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

        Test.startTest();
        Opportunity updated = OpportunityService.updateOpportunity(
            opp.Id,
            'Closed Won'
        );
        Test.stopTest();

        System.assertEquals('Closed Won', updated.StageName);

        // Vérification en base
        Opportunity check = [
            SELECT StageName FROM Opportunity WHERE Id = :opp.Id
        ];
        System.assertEquals('Closed Won', check.StageName);
    }

    @isTest
    static void testDeleteOpportunity() {
        Account acc = createTestAccount();
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

        Test.startTest();
        OpportunityService.deleteOpportunity(opp.Id);
        Test.stopTest();

        // Vérifier suppression
        List<Opportunity> opps = [
            SELECT Id FROM Opportunity WHERE Id = :opp.Id
        ];
        System.assertEquals(0, opps.size(), 'L\'opportunité doit être supprimée');
    }
}