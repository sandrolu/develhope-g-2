public with sharing class VoteFeedbackMail {
    @InvocableMethod (label='SendMail'description ='Return mail with feedback and vote' category ='Trainee_c')
    public static void sendFeedbackEmail(List<Trainee__c> trainee){
        //vecchia query
        //trainee = [SELECT ID, Training_program_feedback__c, Vote__c FROM Trainee__c];
        Double rating= trainee[0].Rating__c;
        String feedback=trainee[0].Training_program_feedback__c;

        //vecchio ciclo
        //for (Trainee__c IterateFeedback : feedbackInputs) {
        // Id Trainee = IterateFeedback.Id;
        //    String Vote = IterateFeedback.Vote__c;
          //  String Feedback = IterateFeedback.Training_program_feedback__c;

            //Trainee__c getTraineeEmail = [SELECT Id, Email_address__c FROM Trainee__c WHERE Id = :IterateFeedback.Id LIMIT 1];
            List<String> toAddresses= (new List<String>{trainee[0].Email_address__c});

            String subject=('Feedback sul programma di training');
            
            
            String body = ('Hello!\n');
            body += ('Thanks for giving a feedback about our Training Program. ');
            body += 'Your vote is: ' + rating + '/5\n\n';
            body += 'See you for next Training Program,\n';
            body += 'Tennis World';
    
            EmailManager.sendMail(toAddresses, subject, body);                           
        }   
}