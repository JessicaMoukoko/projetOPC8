@isTest
private class TripSchedulerTest {

    @isTest
    static void testSchedulerExecute() {
        // Planification du job via un cron expression
        String cronExp = '0 0 0 * * ?';

        Test.startTest();
            String jobId = System.schedule('Test TripScheduler', cronExp, new TripScheduler());
        Test.stopTest();

        // Vérification que le job a bien été planifié
        CronTrigger ct = [
            SELECT Id, CronExpression, TimesTriggered, State
            FROM CronTrigger
            WHERE Id = :jobId
        ];

        System.assertEquals(cronExp, ct.CronExpression, 'La cron expression doit correspondre');
        System.assertEquals(0, ct.TimesTriggered, 'Le job ne doit pas encore avoir été déclenché');
        System.assertEquals('WAITING', ct.State, 'Le job doit être en attente');
    }
}