global class BatchEmail implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([SELECT Id, Email__c, Thank_You_Email_Sent__c FROM Trainee__c WHERE Thank_You_Email_Sent__c < 1]);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        for (sObject s : scope) {
            Trainee__c t = (Trainee__c) s;
            List<String> toAddresses = new List<String>{ t.Email__c };
            String subject = 'Oggetto della mail';
            String body = 'Testo della mail';
            EmailManager.sendMail(toAddresses, subject, body);
            
        }
    }

    global void finish(Database.BatchableContext BC) {
    }
}