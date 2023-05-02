public with sharing class EmailManager {
    @InvocableMethod (label='SendMail'description ='Return mail with feedback and vote' category ='Trainee_c')
    public static void sendFeedbackEmail(List<Trainee__c> feedbackInputs){
        feedbackInputs = [SELECT ID, Training_program_feedback__c, Vote__c FROM Trainee__c];
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for (Trainee__c IterateFeedback : feedbackInputs) {
            Id Trainee = IterateFeedback.Id;
            String Vote = IterateFeedback.Vote__c;
            String Feedback = IterateFeedback.Training_program_feedback__c;

            Trainee__c getTraineeEmail = [SELECT Email_address__c FROM Trainee__c WHERE Id = :IterateFeedback.Id LIMIT 1];
            String TraineeEmail = IterateFeedback.Email_address__c;

            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

            email.setToAddresses(new List<String>{ TraineeEmail });

            email.setSubject('Feedback sul programma di training');

            String emailBody = 'Ciao';
            emailBody += 'Grazie per aver lasciato un feedback al nostro programma di training.';
            emailBody += 'Il tuo voto è: ' + Vote + '/10\n\n';
            emailBody += 'Grazie ancora e ci auguriamo di vederti presto per il prossimo programma di training!';
            emailBody += 'Cordiali saluti,';
            emailBody += 'Tennis World';

            email.setPlainTextBody(emailBody);

            emails.add(email);
          
        }

        Messaging.sendEmail(emails);
    }
}