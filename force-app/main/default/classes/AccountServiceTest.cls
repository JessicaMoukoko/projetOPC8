
@isTest
private class AccountServiceTest {

    @isTest
    static void CreateAccountTest() {

        // Appel de la méthode de création de compte

        Test.startTest();
        Account acc = AccountService.createAccount('Test Account');
        Test.stopTest();

        // Vérification que le compte a été créé
        System.assertNotEquals(null, acc);
        System.assertEquals('Test Account', acc.Name);
    }

    @isTest
    static void GetAccountByIdTest() {
        // Appel de la méthode de récupération de compte
        Account acc = new Account(Name = 'Test Account');   
        insert acc;

        Test.startTest();
        Account accToTest = AccountService.getAccountById(acc.Id);
        Test.stopTest();

        // Vérification que le compte a été récupéré
        System.assertNotEquals(null, accToTest);
        System.assertEquals('Test Account', accToTest.Name);
    }
   
    @isTest
    static void UpdateAccountTest() {
        // Appel de la méthode de mise à jour de compte
        Account acc = new Account(Name = 'Test Account');   
        insert acc;

        Test.startTest();
        Account accToTest = AccountService.updateAccount(acc.Id, 'Test Account Updated');
        Test.stopTest();

        // Vérification que le compte a été mis à jour
        Account accUpdated = [SELECT Id, Name FROM Account WHERE Id = :acc.Id LIMIT 1];

        System.assertNotEquals(null, accUpdated);
        System.assertEquals('Test Account Updated', accUpdated.Name);
    }

    @isTest
    static void DeleteAccountTest() {
        // Appel de la méthode de suppression de compte

        Account acc = new Account(Name = 'Test Account');   
        insert acc;

        Test.startTest();
        Account accDeleted = AccountService.deleteAccount(acc.Id);
        Test.stopTest();

        // Vérification que le compte a été supprimé
       List< Account> accToTest = [SELECT Id FROM Account WHERE Id = :acc.Id ];

        System.assertEquals(0, accToTest.size());

}
}