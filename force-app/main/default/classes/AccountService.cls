public with sharing class AccountService {

    // Méthode pour créer un compte
    public static Account createAccount(String name) {
        Account acc = new Account(Name = name);
        insert acc;
        return acc;
    }

    // Méthode pour récupérer un compte par son Id
    public static Account getAccountById(Id accountId) {
        return [SELECT Id, Name FROM Account WHERE Id = :accountId LIMIT 1];
    }

    // Méthode pour update le nom d'un compte
    public static Account updateAccount(Id accountId, String newName) {
        Account acc = [SELECT Id, Name FROM Account WHERE Id = :accountId LIMIT 1];
        acc.Name = newName;
        update acc;
        return acc;
    }

    // Méthode pour supprimer un compte
    public static void deleteAccount(Id accountId) {
        delete [SELECT Id FROM Account WHERE Id = :accountId];
    }
}