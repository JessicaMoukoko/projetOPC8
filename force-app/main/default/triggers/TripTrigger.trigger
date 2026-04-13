trigger TripTrigger on Trip__c (before insert, before update) {

    // Appel de la méthode validateDates du handler pour valider les dates de début et de fin des voyages avant l'insertion ou la mise à jour

    if(Trigger.isBefore){
        TripTriggerHandler.validateDates(Trigger.new);
    }
}