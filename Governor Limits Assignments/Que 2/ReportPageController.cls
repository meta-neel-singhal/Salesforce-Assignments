public class ReportPageController {
    public list<AggregateResult> Results {
        get {
            return [SELECT SUM(Amount) totalAmount, Account.Name accountName FROM Opportunity GROUP BY Account.Name LIMIT 10];
        }
    }
}