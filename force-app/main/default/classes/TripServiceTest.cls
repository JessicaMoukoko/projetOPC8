@isTest
public class TripServiceTest {

    @isTest
      // méthode de test pour la création d'un trip 
    static void testCreateTrip() {

        Test.startTest();
        Trip__c trip = TripService.createTrip('Voyage Paris');
        Test.stopTest();

        System.assertNotEquals(null, trip.Id, 'Le trip doit être créé');
        System.assertEquals('Voyage Paris', trip.Name);
    }

    @isTest
      // méthode de test pour la récupération d'un trip par son Id
    static void testGetTripById() {

        Trip__c trip = TripService.createTrip('Voyage Rome');

        Test.startTest();
        Trip__c result = TripService.getTripById(trip.Id);
        Test.stopTest();

        System.assertEquals(trip.Id, result.Id);
        System.assertEquals('Voyage Rome', result.Name);
    }

    @isTest
       // méthode de test pour la mise à jour d'un trip
    static void testUpdateTrip() {

        Trip__c trip = TripService.createTrip('Ancien Nom');

        Test.startTest();
        Trip__c updated = TripService.updateTrip(
            trip.Id,
            'Nouveau Nom'
        );
        Test.stopTest();

        System.assertEquals('Nouveau Nom', updated.Name);

        // Vérification en base
        Trip__c check = [
            SELECT Name FROM Trip__c WHERE Id = :trip.Id
        ];
        System.assertEquals('Nouveau Nom', check.Name);
    }

    @isTest
         // méthode de test pour la suppression d'un trip
    static void testDeleteTrip() {

        Trip__c trip = TripService.createTrip('Voyage à supprimer');

        Test.startTest();
        TripService.deleteTrip(trip.Id);
        Test.stopTest();

        // Vérifier suppression
        List<Trip__c> trips = [
            SELECT Id FROM Trip__c WHERE Id = :trip.Id
        ];
        System.assertEquals(0, trips.size(), 'Le trip doit être supprimé');
    }
}