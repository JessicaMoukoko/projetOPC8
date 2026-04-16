global class BatchTripStatus implements Database.Batchable<SObject> {

    // Méthode start pour récupérer tous les voyages

    global Database.QueryLocator start(Database.BatchableContext bc) {

        return Database.getQueryLocator([
            SELECT Id, Start_Date__c, Number_of_Participants__c, Status__c, End_Date__c, Destination__c, Account__c, Opportunity__c, Name
            FROM Trip__c
            WHERE Status__c != 'Annulé' AND Status__c != 'Terminé'
        ]);
    }

    // Méthode execute pour vérifier le nombre de participants et mettre à jour le statut des voyages

    global void execute(Database.BatchableContext bc, List<Trip__c> scope) {

        List<Trip__c> ListTripsToUpdate = new List<Trip__c>();

        for(Trip__c trip : scope){

            if(Date.today() < trip.Start_Date__c ){

                trip.Status__c = 'A venir';
                ListTripsToUpdate.add(trip);
            }
            else if (Date.today() >= trip.Start_Date__c && Date.today() <= trip.End_Date__c ){

                trip.Status__c = 'En cours';
                ListTripsToUpdate.add(trip);
            }
             else if (Date.today() > trip.End_Date__c){ 

                trip.Status__c = 'Terminé';
                ListTripsToUpdate.add(trip);   
        }

        if(!ListTripsToUpdate.isEmpty()){
            update ListTripsToUpdate;
        }
    }
}

// Méthode finish pour envoyer une notification à l'administrateur avec le nombre de voyages mis à jour

    global void finish(Database.BatchableContext bc){
        
    }
}
