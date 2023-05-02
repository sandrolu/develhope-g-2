@isTest
public class PTTutorAssignmentTest {
    @isTest
    static void testStatusDesigned(){
        //generate test data
        List<Training_Program__c> pts=new List<Training_Program__c>();
        List<Tutor__c> tutors=new List<Tutor__c>();
        for(Integer i=1;i<=5;i++){
            Training_Program__c ptTest = new Training_Program__c(Level__c=''+i,Name='Test '+i,Status__c='Preparing');
            Tutor__c tutorTest = new Tutor__c(Seniority_Level__c=''+i, Available__c=true, First_Name__c='First name Test '+i
                                            , Last_Name__c='Last name test '+i,name='Test '+i);
            pts.add(ptTest);
            tutors.add(tutorTest);    
        }
        insert pts;
        insert tutors;
        //data generated
        Test.startTest();
        List<Training_Program__c> ptsChangingStatus=new List<Training_Program__c>();
        for(Training_Program__c pt : pts){
            pt.Status__c='Designed';
            ptsChangingStatus.add(pt);
        }
        update ptsChangingStatus;
        Test.stopTest();
        List<Training_Program__c> verifyPts=[SELECT Id, Level__c, Name, Status__c, 
                                             (SELECT Id, Seniority_Level__c, Training_Program__c, Available__c, Name, First_Name__c, Last_Name__c FROM Tutors__r)
                                             FROM Training_Program__c];
        for(Training_Program__c pt : verifyPts){
            System.assertEquals(pt.Tutors__r[0].Seniority_Level__c, pt.Level__c, 'ERROR');
        }
    }
    
    @isTest
    static void testStatusDone(){
        //generate test data
        List<Training_Program__c> pts=new List<Training_Program__c>();
        List<Tutor__c> tutors=new List<Tutor__c>();
        for(Integer i=1;i<=5;i++){
            Training_Program__c ptTest = new Training_Program__c(Level__c=''+i,Name='Test '+i,Status__c='Designed');
            id ptTestId = ptTest.Id;
            Tutor__c tutorTest = new Tutor__c(Seniority_Level__c=''+i, Available__c=true, First_Name__c='First name Test '+i
                                            , Last_Name__c='Last name test '+i,name='Test '+i, Training_Program__c=ptTestId);
            pts.add(ptTest);
            tutors.add(tutorTest);
        }
        insert pts;
        insert tutors;
        pts.sort();
        tutors.sort();
        Map<Training_Program__c,Tutor__c> ptsWithTutorsMap= new Map<Training_Program__c,Tutor__c>();
        for(Integer i=0;i<=4;i++){
            ptsWithTutorsMap.put(pts[i],tutors[i]);
        }
        //Testing unmatching
        Test.startTest();
        List<Tutor__c> tutorsUnmatched=new List<Tutor__c>();
        List<Training_Program__c> ptsDoneStatus=new List<Training_Program__c>();
        for(Training_Program__c pt : pts){
            tutorsUnmatched.add(pt.Tutors__r[0]);
            pt.Status__c='Done';
            ptsDoneStatus.add(pt);
        }
        update ptsDoneStatus;
        update tutorsUnmatched;
        Test.stopTest();
        List<Training_Program__c> verifyPts=[SELECT Id, Level__c, Name, Status__c, 
                                             (SELECT Id, Seniority_Level__c, Training_Program__c, Available__c, Name, First_Name__c, Last_Name__c FROM Tutors__r)
                                             FROM Training_Program__c];
        List<Tutor__c> verifyTutors=ptsWithTutorsMap.values();
        List<Tutor__c> verifyTutorsUnmatched=[SELECT Id, Seniority_Level__c, Training_Program__c, Available__c, Name, First_Name__c, Last_Name__c FROM Tutor__c];
        for(Training_Program__c pt : verifyPts){
            System.assertEquals(pt.Tutors__r.size(),0, 'ERROR - ci sono tutor assegnati');
        	for(Tutor__c tutor : verifyTutorsUnmatched){
            	System.assertEquals(tutor.Training_Program__c,null, 'ERROR - ci sono tutor assegnati');
            	System.assertEquals(tutor.Available__c,true, 'ERROR - ci sono tutor che risultano non disponibili');
        	}
        }
    }
    
    @isTest
    static void testNullException(){
        //generate test data
        List<Training_Program__c> pts=new List<Training_Program__c>();
        List<Tutor__c> tutors=new List<Tutor__c>();
        for(Integer i=1;i<=5;i++){
            Training_Program__c ptTest = new Training_Program__c(Level__c=''+i,Name='Test '+i,Status__c='Preparing');
            Tutor__c tutorTest = new Tutor__c(Seniority_Level__c=''+i, Available__c=false, First_Name__c='First name Test '+i
                                            , Last_Name__c='Last name test '+i,name='Test '+i);
            pts.add(ptTest);
            tutors.add(tutorTest);    
        }
        insert pts;
        insert tutors;
        //data generated
        //Test
        Test.startTest();
        List<Training_Program__c> ptsChangingStatus=new List<Training_Program__c>();
        for(Training_Program__c pt : pts){
            pt.Status__c='Designed';
            ptsChangingStatus.add(pt);
        }
        Database.SaveResult[] result = Database.update(ptsChangingStatus, false);
        Test.stopTest();
        List<Training_Program__c> verifyPts=[SELECT Id, Level__c, Name, Status__c, 
                                             (SELECT Id, Seniority_Level__c, Training_Program__c, Available__c, Name, First_Name__c, Last_Name__c FROM Tutors__r)
                                             FROM Training_Program__c];
        for(Training_Program__c pt : verifyPts){
            System.assertEquals(pt.Tutors__r.size(), 0, 'ERROR');
        }
    }
}