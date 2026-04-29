@isTest
public class ContractServiceTest {

    @isTest
    static void testCreateContract() {
        Account acc = TestDataFactory.createAccount('Test Account');

        Test.startTest();
        Contract con = ContractService.createContract(
            acc.Id,
            Date.today(),
            'Draft'
        ); 
        Test.stopTest();

        System.assertNotEquals(null, con.Id, 'Le contrat doit être créé');
        System.assertEquals(acc.Id, con.AccountId);
        System.assertEquals('Draft', con.Status);
    }

    @isTest
    static void testGetContractById() {
        Account acc = TestDataFactory.createAccount('Test Account');
        Contract con = TestDataFactory.createContract(
            acc.Id,
            Date.today(),
            'Draft'
        );

        Test.startTest();
        Contract result = ContractService.getContractById(con.Id);
        Test.stopTest();

        System.assertEquals(con.Id, result.Id);
        System.assertEquals('Draft', result.Status);
    }

    @isTest
    static void testUpdateContract() {
        Account acc = TestDataFactory.createAccount('Test Account');
        Contract con = TestDataFactory.createContract(
            acc.Id,
            Date.today(),
            'Draft'
        );

        Test.startTest();
        Contract updated = ContractService.updateContract(
            con.Id,
            'Activated'
        );
        Test.stopTest();

        System.assertEquals('Activated', updated.Status);

        // Vérifier en base
        Contract check = [SELECT Status FROM Contract WHERE Id = :con.Id];
        System.assertEquals('Activated', check.Status);
    }

    @isTest
    static void testDeleteContract() {
        Account acc = TestDataFactory.createAccount('Test Account');
        Contract con = TestDataFactory.createContract(
            acc.Id,
            Date.today(),
            'Draft'
        );

        Test.startTest();
        ContractService.deleteContract(con.Id);
        Test.stopTest();

        // Vérifier suppression
        List<Contract> contracts = [
            SELECT Id FROM Contract WHERE Id = :con.Id
        ];
        System.assertEquals(0, contracts.size(), 'Le contrat doit être supprimé');
    }
}