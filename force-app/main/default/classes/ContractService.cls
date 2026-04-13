public with sharing class ContractService {


    //Méthode pour créer un contrat
    public static Contract createContract(Id accountId, Date startDate, String status) {
        Contract con = new Contract(
            AccountId = accountId,
            StartDate = startDate,
            Status = status
        );
        insert con;
        return con;
    }

    // Méthode pour récupérer un contrat par son Id
    public static Contract getContractById(Id contractId) {
        return [
            SELECT Id, AccountId, StartDate, Status
            FROM Contract
            WHERE Id = :contractId
            LIMIT 1
        ];
    }

    // Méthode pour update le statut d'un contrat
    public static Contract updateContract(Id contractId, String status) {
        Contract con = [
            SELECT Id, Status
            FROM Contract
            WHERE Id = :contractId
            LIMIT 1
        ];
        con.Status = status;
        update con;
        return con;
    }

    // Méthode pour supprimer un contrat
    public static void deleteContract(Id contractId) {
        delete [SELECT Id FROM Contract WHERE Id = :contractId];
    }
}