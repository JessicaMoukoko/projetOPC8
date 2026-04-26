public class OpportunityTriggerHandler {

      // Méthode pour gérer le trigger après update d'une opportunité

    public static void handleAfterUpdate(List<Opportunity> ListOpps, Map<Id, Opportunity> oldMap) {
 
         
        List<Trip__c> ListtripsToCreate = new List<Trip__c>();

        for(Opportunity opp : ListOpps) {    
     // récupére l'ancienne version de l'opportunité à partir de la map oldMap
            Opportunity oldOpp = oldMap.get(opp.Id);

     // Vérifier si le stage de l'opportunité est passé à 'Closed Won' et qu'il n'était pas 'Closed Won' auparavant

            if(opp.StageName == 'Closed Won' && oldOpp.StageName != 'Closed Won') {

                Trip__c trip = new Trip__c();
                trip.Status__c = 'A venir';
                trip.Destination__c = opp.Destination__c;
                trip.Start_Date__c = opp.Start_Date__c;
                trip.End_Date__c = opp.End_Date__c;
                trip.Number_of_Participants__c = opp.number_of_participants__c;
                trip.Total_Cost__c = opp.amount;
                trip.Account__c = opp.AccountId;
                trip.Opportunity__c = opp.Id;

                ListtripsToCreate.add(trip);
            }
        }

        if(!ListtripsToCreate.isEmpty()){
            insert ListtripsToCreate;
        }
    }
}