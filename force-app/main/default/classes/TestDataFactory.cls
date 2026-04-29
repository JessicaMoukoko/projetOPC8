@IsTest
public class TestDataFactory {

    public static Account createAccount(String name) {
        Account acc = new Account(Name = name);
        insert acc;
        return acc;
    }

    public static Opportunity createOpportunity(String name, Id accountId, Date closeDate, String stage, String destination, Date startDate, Date endDate, Decimal amount, Integer participants) {
        Opportunity opp = new Opportunity(
            Name = name,
            AccountId = accountId,
            CloseDate = closeDate,
            StageName = stage,
            Destination__c = destination,
            Start_Date__c = startDate,
            End_Date__c = endDate,
            Amount = amount,
            Number_of_Participants__c = participants
        );
        insert opp;
        return opp;
    }

    public static Trip__c createTrip(String status, Id accountId, Id opportunityId, String destination, Date startDate, Date endDate, Integer participants) {
        Trip__c trip = new Trip__c(
            Status__c = status,
            Account__c = accountId,
            Opportunity__c = opportunityId,
            Destination__c = destination,
            Start_Date__c = startDate,
            End_Date__c = endDate,
            Number_of_Participants__c = participants
        );
        insert trip;
        return trip;
    }

    public static Contract createContract(Id accountId, Date startDate, String status) {
        Contract con = new Contract(
            AccountId = accountId,
            StartDate = startDate,
            Status = status
        );
        insert con;
        return con;
    }
}