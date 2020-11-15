import kanishkamw/common;

public type OnlineBankingTransferErrorDetail record {|
    string message?;
    common:AccountManagerError cause;
    string sourceAccount;
    string targetAccount;
    decimal amount;
|};

const OB_TRANSFER_ERROR = "ONLINE_BANKING_TRANSFER_ERROR";

public type OnlineBankingTransferError error<OB_TRANSFER_ERROR,OnlineBankingTransferErrorDetail>;


type OnlineBanking object {
    private common:AccountManager accountManager;

    public function __init(common:AccountManager accountManager) {
       self.accountManager=accountManager; 
    }

    public function lookupAccountBalance(string accountNumber) returns decimal|common:AccountManagerError{
        return self.accountManager.getAccountBalance(accountNumber);
    }

    public function transferMoney(string sourceAccount, string targetAccount, decimal amount) returns OnlineBankingTransferError?{
        common:AccountManagerError? err = self.accountManager.debitAccount(sourceAccount,amount);
        if err is error{
            return error(OB_TRANSFER_ERROR,cause=err, sourceAccount=sourceAccount, targetAccount=targetAccount, amount=amount);
        }
        err = self.accountManager.creditAccount(targetAccount, amount);
        if (err is error) {
            return error(OB_TRANSFER_ERROR,cause=err,sourceAccount=sourceAccount, targetAccount=targetAccount, amount=amount);
        }
    }

};
