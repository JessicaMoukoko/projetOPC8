global class TripStatusScheduler implements Schedulable {

    // Méthode execute pour exécuter le batch qui met à jour le statut des voyages

    global void execute(SchedulableContext sc) {

        BatchTripStatus batch = new BatchTripStatus();
        Database.executeBatch(batch, 200);
    }
}