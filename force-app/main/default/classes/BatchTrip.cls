global class BatchTrip implements Database.Batchable<SObject> {

    // Méthode start pour récupérer les voyages qui commencent dans 7 jours et qui ne sont pas annulés

    global Database.QueryLocator start(Database.BatchableContext bc) {

        Date today = Date.today();
        Date targetDate = today.addDays(7);

        return Database.getQueryLocator([
            SELECT Id, Start_Date__c, Number_of_Participants__c, Status__c, End_Date__c, Destination__c, Account__c, Opportunity__c, Name
            FROM Trip__c
            WHERE Start_Date__c = :targetDate
            AND Status__c != 'Annulé' AND Status__c != 'Terminé'
        ]);
    }

 // Méthode execute pour vérifier le nombre de participants et annuler les voyages qui en ont moins de 10

    global void execute(Database.BatchableContext bc, List<Trip__c> scope) {

        List<Trip__c> ListTripsToUpdate = new List<Trip__c>();

        for(Trip__c trip : scope){

            if(trip.Number_of_Participants__c == null || trip.Number_of_Participants__c < 10){

                trip.Status__c = 'Annulé';
                ListTripsToUpdate.add(trip);
            }
        }

        if(!ListTripsToUpdate.isEmpty()){
            update ListTripsToUpdate;
        }
    }
    
 // Méthode finish pour envoyer une notification à l'administrateur avec le nombre de voyages annulés

    global void finish(Database.BatchableContext bc){
        
    }
}