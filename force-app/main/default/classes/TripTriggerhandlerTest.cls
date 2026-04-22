@isTest
public class TripTriggerhandlerTest {

    //  création Account obligatoire pour Trip__c
    private static Account createAccount() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        return acc;
    }


    private static Opportunity createOpportunity(Account acc) {
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            AccountId = acc.Id,
            CloseDate = Date.today().addDays(30),
            StageName = 'Prospecting'
        );
        insert opp;
        return opp;
    }

    @isTest

    // méthode de test avec un cas invalide
    static void testValidateDates_Error() {

        Account acc = createAccount();
        Opportunity opp = createOpportunity(acc);

        Trip__c trip = new Trip__c(
            Account__c = acc.Id,
            Start_Date__c = Date.today(),
            End_Date__c = Date.today()
        );

        Test.startTest();
        try {
            insert trip;
            System.assert(false, 'Il y aurait du avoir une erreur');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('La date de fin doit être strictement postérieure'),
                'Le message d\'erreur doit être présent'
            );
        }
        Test.stopTest();
    }

    @isTest

    // méthode de test avec un cas valide

    static void testValidateDates_Valid() {

        Account acc = createAccount();
        Opportunity opp = createOpportunity(acc);

        
        Trip__c trip = new Trip__c(
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addDays(5),
            Account__c = acc.Id,
            Opportunity__c = opp.Id,
            Destination__c = 'Paris',
            Number_of_Participants__c = 10
        );

        Test.startTest();
        insert trip;
        Test.stopTest();

        System.assertNotEquals(null, trip.Id, 'Le trip doit être inséré');
    }    
}