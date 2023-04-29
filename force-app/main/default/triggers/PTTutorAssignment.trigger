trigger PTTutorAssignment on Training_Program__c (before insert, before update, after insert, after update) {
    if(trigger.isAfter && trigger.isUpdate){
        List<Training_Program__c> Pts=[SELECT Id,Status__c, Level__c,Level_Number__c, Name,(
            SELECT Id,Seniority_Level__c,Training_Program__c,Available__c FROM Tutors__r) FROM Training_Program__c WHERE Id IN:Trigger.New];
        List<Tutor__c> tutors=[SELECT Id, Seniority_Level__c, Seniority_Level_Number__c, Training_Program__c, Available__c FROM Tutor__c WHERE Available__c=true ORDER BY Seniority_Level_Number__c DESC];
        Map<Decimal,List<Tutor__c>> tutorLevelMap = new Map<Decimal,List<Tutor__c>>();
        for (Tutor__c currentTutor : tutors) {
            if (!tutorLevelMap.containsKey(currentTutor.Seniority_Level_Number__c)) {
                tutorLevelMap.put(currentTutor.Seniority_Level_Number__c, new List<Tutor__c>());
            }
            tutorLevelMap.get(currentTutor.Seniority_Level_Number__c).add(currentTutor);
        }

        List<Tutor__c> tutorToUpdate=new List<Tutor__c>();
        List<Tutor__c> tutorDone=new List<Tutor__c>();
        for(Training_Program__c pt : Pts){
            if(pt.Status__c=='Designed' && pt.Tutors__r.size()==0){
                String[] lvlAvailable = MatchingTutorManager.getWhereCondition(pt.Level__c);
                for(Tutor__c tutor : tutors){
                    if(MatchingTutorManager.isMatched(lvlAvailable,tutor.Seniority_Level__c)){
                        tutor.Training_Program__c= pt.Id;
                        tutor.Available__c=false;
                        tutorToUpdate.add(tutor);
                        break;
                    }
                }
                //pt.Status__c='Doing';
            }
            if(pt.Status__c=='Done' && pt.Tutors__r.size()!=0){
                for(Tutor__c tut : pt.Tutors__r){
                    tut.Training_Program__c=null;
                    tut.Available__c=true;
                    tutorDone.add(tut);
                }
            }
                
        }
        update tutorToUpdate;
        
        /*List<Training_Program__c> PTsWithTutor=[SELECT Id,Status__c, Level__c, Name,(
            SELECT Id,Seniority_Level__c,Training_Program__c,Available__c FROM Tutors__r) FROM Training_Program__c WHERE Id IN:Trigger.New];
        List<Tutor__c> tutorDone=new List<Tutor__c>();
        for(Training_Program__c Pt : PTsWithTutor){
            if(pt.Status__c=='Done'){
                for(Tutor__c tut : pt.Tutors__r){
                    tut.Training_Program__c=null;
                    tut.Available__c=true;
                    tutorDone.add(tut);
                }
            }
        } */
        update tutorDone;
        }
    }