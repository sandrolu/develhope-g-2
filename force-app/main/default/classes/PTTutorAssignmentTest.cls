@isTest
public class PTTutorAssignmentTest {
    
    @TestSetup
    static void testSetupData(){
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
    }
    
    @isTest
    static void testStatusDesigned(){
        //retriving data
        List<Training_Program__c> pts=[SELECT Id, Level__c, Name, Status__c, 
                                             (SELECT Id, Seniority_Level__c, Training_Program__c, Available__c, Name, First_Name__c, Last_Name__c FROM Tutors__r)
                                             FROM Training_Program__c];
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
        //retriving data
        List<Training_Program__c> pts=[SELECT Id, Level__c, Name, Status__c, 
                                             (SELECT Id, Seniority_Level__c, Training_Program__c, Available__c, Name, First_Name__c, Last_Name__c FROM Tutors__r)
                                             FROM Training_Program__c];
        List<Tutor__c> tutors=[SELECT Id, Seniority_Level__c, Training_Program__c, Available__c, Name, First_Name__c, Last_Name__c FROM Tutor__c];
        //Matching tutor before test the unmatching
        List<Tutor__c> tutorsDesigned= new List<Tutor__c>();
        List<Training_Program__c> ptsDesigned= new List<Training_Program__c>();
        for(Training_Program__c pt: pts){
            pt.Status__c='Designed';
            ptsDesigned.add(pt);
        }
        update ptsDesigned;
        //Testing unmatching
        Test.startTest();
        List<Tutor__c> tutorsUnmatched=new List<Tutor__c>();
        List<Training_Program__c> ptsDoneStatus=new List<Training_Program__c>();
        for(Training_Program__c pt : pts){
            pt.Status__c='Done';
            ptsDoneStatus.add(pt);
        }
        update ptsDoneStatus;
        Test.stopTest();
        List<Training_Program__c> verifyPts=[SELECT Id, Level__c, Name, Status__c, 
                                             (SELECT Id, Seniority_Level__c, Training_Program__c, Available__c, Name, First_Name__c, Last_Name__c FROM Tutors__r)
                                             FROM Training_Program__c];
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
        //retriving data
        List<Training_Program__c> pts=[SELECT Id, Level__c, Name, Status__c, 
                                             (SELECT Id, Seniority_Level__c, Training_Program__c, Available__c, Name, First_Name__c, Last_Name__c FROM Tutors__r)
                                             FROM Training_Program__c];
        List<Tutor__c> tutors=[SELECT Id, Seniority_Level__c, Training_Program__c, Available__c, Name, First_Name__c, Last_Name__c FROM Tutor__c];
        List<Tutor__c> tutorsNotAvailable=new List<Tutor__c>();
        for(Tutor__c tutor :tutors){
            tutor.Available__c=false;
            tutorsNotAvailable.add(tutor);
        }
        update tutorsNotAvailable;
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