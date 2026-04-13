@isTest
public class TripTriggerhandlerTest {

    //  création Account obligatoire pour Trip__c
    private static Account createAccount() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        return acc;
    }

    @isTest

    // méthode de test avec un cas invalide
    static void testValidateDates_Error() {

        Account acc = createAccount();

        Trip__c trip = new Trip__c(
            Name = 'Trip Test',
            Account__c = acc.Id,
            Start_Date__c = Date.today(),
            End_Date__c = Date.today()
        );

        Test.startTest();
        try {
            insert trip;
            System.assert(false, 'Une erreur devait être levée');
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

        
        Trip__c trip = new Trip__c(
            Name = 'Trip Valide',
            Account__c = acc.Id,
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addDays(5)
        );

        Test.startTest();
        insert trip;
        Test.stopTest();

        System.assertNotEquals(null, trip.Id, 'Le trip doit être inséré');
    }

    @isTest
    // méthode de test avec des valeurs nulles pour les dates

    static void testValidateDates_NullValues() {

        Account acc = createAccount();

        Trip__c trip = new Trip__c(
            Name = 'Trip Sans Dates',
            Account__c = acc.Id
        );

        Test.startTest();
        insert trip;
        Test.stopTest();

        System.assertNotEquals(null, trip.Id, 'Le trip doit être inséré même sans dates');
    }
}