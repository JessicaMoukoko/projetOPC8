public class TestDataFactory {

    public static Opportunity createOpportunityWithTripData(Account acc) {
        Opportunity opp = new Opportunity(
            Name = 'Test Opp',
            AccountId = acc.Id,
            CloseDate = Date.today().addDays(10),
            StageName = 'Prospecting',
            Destination__c = 'Paris',
            Start_Date__c = Date.today().addDays(5),
            End_Date__c = Date.today().addDays(8),
            Amount = 1000
        );
        insert opp;
        return opp;
    }
}