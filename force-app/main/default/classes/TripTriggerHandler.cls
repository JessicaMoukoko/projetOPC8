public class TripTriggerHandler {


    // Méthode pour gérer le trigger après update d'une opportunité
    
    public static void validateDates(List<Trip__c> trips){

        for(Trip__c trip : trips){

          
            if(trip.Start_Date__c != null && trip.End_Date__c != null){

                if(trip.End_Date__c <= trip.Start_Date__c){

                    trip.End_Date__c.addError(
                        'La date de fin doit être strictement postérieure à la date de début.'
                    );
                }
            }
        }
    }
}