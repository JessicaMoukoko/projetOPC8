global class TripScheduler implements Schedulable {

    // Méthode execute pour exécuter le batch qui annule les voyages avec moins de 10 participants

    global void execute(SchedulableContext sc) {

        BatchTrip batch = new BatchTrip();
        Database.executeBatch(batch, 200);
    }
}