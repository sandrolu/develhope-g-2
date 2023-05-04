trigger AssignTraineeToPT on Trainee__c (before insert) {
    
    List<Trainee__c> traineesDaAssegnare = new List<Trainee__c>();
    List<Id> ptIdsToCheck = new List<Id>();
    Map<Id, Integer> ptTraineeCounts = new Map<Id, Integer>();
    
    for (Trainee__c trainee : Trigger.new) {  // popola la lista di trainee da assegnare e la lista di ID PT da controllare
        if (trainee.Training_Program__c != null) {
            traineesDaAssegnare.add(trainee);
            ptIdsToCheck.add(trainee.Training_Program__c);
        }
    }
    
    for (AggregateResult result : [ // ottengo il numero dei trainee per ogni PT nella lista di ID PT da controllare
        SELECT Training_Program__c, COUNT(Id) traineeCount
        FROM Trainee__c
        WHERE Training_Program__c IN :ptIdsToCheck
        GROUP BY Training_Program__c])
    {
        ptTraineeCounts.put((Id)result.get('PT__c'), (Integer)result.get('traineeCount'));
    }
    
    for (Trainee__c trainee : traineesDaAssegnare) { // assegno i trainee ai PT se il conteggio dei trainee del PT non è >= 3
        if (ptTraineeCounts.containsKey(trainee.Training_Program__c) && ptTraineeCounts.get(trainee.Training_Program__c) >= 3) {
            trainee.addError('Questo PT ha già 3 partecipanti assegnati.');
        }
    }
}