import ballerina/time;

const INVALID_ACCOUNT_NUMBER = "INVALID_ACCOUNT_NUMBER";
const INSUFFICIENT_ACCOUNT_BALANCE = "INSUFFICIENT_ACCOUNT_BALANCE";

type AccountManagerErrorReason INVALID_ACCOUNT_NUMBER | INSUFFICIENT_ACCOUNT_BALANCE;

type AccountManagerErrorDetail record {|
    string message?;
    error cause?;
    int time?;
    string account;
|};

public type AccountManagerError error<AccountManagerErrorReason,AccountManagerErrorDetail>;

public type AccountManager object {
    private map<decimal> accounts={AC1:1500.00, AC2:2550.00};

    public function getAccountBalance(string accountNumber) returns decimal|AccountManagerError {
        decimal|error result = self.accounts.get(accountNumber);
        if (result is error) {
            return error(INVALID_ACCOUNT_NUMBER, time=time:currentTime().time, account=accountNumber);
        }else{
            return result;
        }
    }

    public function debitAccount(string accountNumber, decimal amount) returns AccountManagerError? {
        decimal|error result = self.accounts.get(accountNumber);
        if (result is error) {
            return error(INVALID_ACCOUNT_NUMBER, time=time:currentTime().time, account=accountNumber);
        }else{
            decimal balance = result - amount;
            if (balance<0.0) {
                return error(INSUFFICIENT_ACCOUNT_BALANCE, time=time:currentTime().time, account=accountNumber);
            }else{
                self.accounts[accountNumber]=balance;
            }
        }
    }

    public function creditAccount(string accountNumber, decimal amount)returns AccountManagerError?{
        decimal? result=self.accounts[accountNumber];
        if result is decimal{
            self.accounts[accountNumber]= result + amount;
        }else{
            return error(INVALID_ACCOUNT_NUMBER, time=time:currentTime().time, account=accountNumber);
        }
    }
};
