@isTest
public class TripTriggerhandlerTest {

    @isTest
    static void testValidateDates_Error() {

       Account acc =  TestDataFactory.createAccount('Test Account');
        Opportunity opp = TestDataFactory.createOpportunity(
            'Test Opportunity',
            acc.Id,
            Date.today().addDays(30),
            'Prospecting',
            'Paris',
            Date.today(),
            Date.today(), // même date pour start et end
            1000,
            2
        );

        Trip__c trip = new Trip__c(
            Status__c = 'A venir',
            Account__c = acc.Id,
            Opportunity__c = opp.Id,
            Destination__c = 'Paris',
            Start_Date__c = Date.today(),
            End_Date__c = Date.today(),
            Number_of_Participants__c = 2
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

        Account acc = TestDataFactory.createAccount('Test Account');
        Opportunity opp = TestDataFactory.createOpportunity(
            'Test Opportunity',
            acc.Id,
            Date.today().addDays(30),
            'Prospecting',
            'Paris',
             Date.today(),
             Date.today().addDays(5),
             1000,
             2
        );

        Trip__c trip = new Trip__c(
            Status__c = 'A venir',
            Account__c = acc.Id,
            Opportunity__c = opp.Id,
            Destination__c = 'Paris',
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addDays(5),
            Number_of_Participants__c = 2
        );

        Test.startTest();
        insert trip;
        Test.stopTest();

        System.assertNotEquals(null, trip.Id, 'Le trip doit être inséré');
    }    
}