@isTest
public class TripServiceTest {

    @isTest
    // Méthode de test pour la création d'un trip
    static void testCreateTrip() {

        Test.startTest();
        Trip__c trip = TripService.createTrip('Voyage Paris'); 
        Test.stopTest();

        System.assertNotEquals(null, trip.Id, 'Le trip doit être créé avec un Id');
        System.assertNotEquals(null, trip.Name, 'Le Name (autonumber) doit être généré automatiquement');
    }

    @isTest
    // Méthode de test pour la récupération d'un trip par son Id
    static void testGetTripById() {

        Trip__c trip = TestDataFactory.createTrip(
            'Test Trip',
             'Paris',
             Date.today(),
             Date.today().addDays(5),
             1000,
             2
        );

        Test.startTest();
        Trip__c result = TripService.getTripById(trip.Id);
        Test.stopTest();

        System.assertEquals(trip.Id, result.Id, 'L\'Id du trip récupéré doit correspondre');
        System.assertNotEquals(null, result.Name, 'Le Name (autonumber) doit être présent');
        System.assertEquals('Paris', result.Destination__c);
    }

    @isTest
    // Méthode de test pour la mise à jour de la destination
    static void testUpdateTrip() {

        Trip__c trip = TestDataFactory.createTrip(
            'Test Trip',
             'Paris',
             Date.today(),
             Date.today().addDays(5),
             1000,
             2
        );

        Test.startTest();
        Trip__c updated = TripService.updateTrip(trip.Id, 'Tokyo');
        Test.stopTest();

        System.assertEquals('Tokyo', updated.Destination__c, 'La destination doit être mise à jour à Tokyo');

        // Vérification en base
        Trip__c check = [
            SELECT Destination__c FROM Trip__c WHERE Id = :trip.Id
        ];
        System.assertEquals('Tokyo', check.Destination__c, 'La mise à jour doit être persistée en base');
    }

    @isTest
    // Méthode de test pour la suppression d'un trip
    static void testDeleteTrip() {

        Trip__c trip = TestDataFactory.createTrip(
            'Test Trip',
             'Paris',
             Date.today(),
             Date.today().addDays(5),
             1000,
             2
        );

        Test.startTest();
        TripService.deleteTrip(trip.Id);
        Test.stopTest();

        List<Trip__c> trips = [
            SELECT Id FROM Trip__c WHERE Id = :trip.Id
        ];
        System.assertEquals(0, trips.size(), 'Le trip doit être supprimé');
    }
}