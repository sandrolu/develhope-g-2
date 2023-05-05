public class MatchingTutorManager {
    /*public static String[] getWhereCondition(String lvlPt){
       String[] result=new String[5];
        switch on lvlPt{
            when 'Entry'{
                result.add('Entry');
                result.add('Low');
                result.add('Medium');
                result.add('High');
                result.add('Professional');
            }
            when 'Low'{
                result.add('Low');
                result.add('Medium');
                result.add('High');
                result.add('Professional');
            }
            when 'Medium'{
                result.add('Medium');
                result.add('High');
                result.add('Professional');
            }
            when 'High'{
                result.add('High');
                result.add('Professional');
            }
            when 'Professional'{
                result.add('Professional');
            }
        }
        return result;
    } */
    
    public static Tutor__c matchingTutorMap(Decimal ptLvl, Map<Decimal,List<Tutor__c>> tutorsMap){
        //List<Decimal> ptLvlList=new List<Decimal>();
        List<Tutor__c> matchingTutors;
        /*for(Decimal i=ptLvl; i<=5;i++){
            ptLvlList.add(i);
        }*/
        for(Decimal i=ptLvl; i<=5;i++){
            if(tutorsMap.containsKey(i)){
               matchingTutors= tutorsMap.get(i);
                break;
            }
        }
        matchingTutors[0].Available__c=false;
            return matchingTutors[0];
        
    }
    
}