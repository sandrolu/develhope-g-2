public class MatchingTutorManager {
    public static String[] getWhereCondition(String lvlPt){
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
    }
    
    public static boolean isMatched(String[] levelList, String lvlTutor){
        boolean result = false;
        for(String lvl:levelList){
            if(lvlTutor == lvl){
                result = true;
            }
        }
        return result;
    }
}