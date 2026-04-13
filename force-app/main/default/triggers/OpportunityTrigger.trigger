trigger OpportunityTrigger on Opportunity (after update) {

    // Appel de la méthode handleAfterUpdate du handler pour gérer les actions à effectuer après la mise à jour d'une opportunité
    
    if(Trigger.isAfter && Trigger.isUpdate){
        OpportunityTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}