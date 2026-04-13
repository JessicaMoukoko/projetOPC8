public with sharing class OpportunityService {

    // Méthode pour créer une opportunité

    public static Opportunity createOpportunity(
        String name,
        Id accountId,
        Date closeDate,
        String stage,
        String destination,
        Date startDate,
        Date endDate,
        Decimal amount,
        Integer numberOfParticipants
    ) {

        Opportunity opp = new Opportunity(
            Name = name,
            AccountId = accountId,
            CloseDate = closeDate,
            StageName = stage,
            Destination__c = destination,
            Start_Date__c = startDate,
            End_Date__c = endDate,
            Amount = amount,
            Number_of_Participants__c = numberOfParticipants
        );

        insert opp;
        return opp;
    }

    // Méthode pour récupérer une opportunité par son Id
    public static Opportunity getOpportunityById(Id oppId) {
        return [
            SELECT Id, Name, StageName, CloseDate, AccountId,
                   Destination__c, Start_Date__c, End_Date__c,
                   Amount, Number_of_Participants__c
            FROM Opportunity
            WHERE Id = :oppId
            LIMIT 1
        ];
    }

    // Méthode pour update le stage d'une opportunité
    public static Opportunity updateOpportunity(Id oppId, String stage) {
        Opportunity opp = [
            SELECT Id, StageName
            FROM Opportunity
            WHERE Id = :oppId
            LIMIT 1
        ];
        opp.StageName = stage;
        update opp;
        return opp;
    }

    // Méthode pour supprimer une opportunité
    public static void deleteOpportunity(Id oppId) {
        delete [SELECT Id FROM Opportunity WHERE Id = :oppId];
    }
}