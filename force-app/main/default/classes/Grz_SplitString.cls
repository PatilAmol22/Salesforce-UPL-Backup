public class Grz_SplitString {
    public List<String> safeSplit(String inStr, String delim)
    {
        Integer regexFindLimit = 100;
        Integer regexFindCount = 0;
        
        List<String> outputList = new List<String>();
        
        Matcher matObj = Pattern.compile(delim).matcher(inStr);
        
        Integer lastEnd = 0;
        
        while(!matObj.hitEnd())
        {
            while(regexFindCount < regexFindLimit && !matObj.hitEnd())
            {
                if(matObj.find())
                {
                    outputList.add(inStr.substring(lastEnd, matObj.start()));  
                    lastEnd = matObj.end();
                }
                else
                {
                    outputList.add(inStr.substring(lastEnd));
                    lastEnd = inStr.length();
                }
                
                regexFindCount++;
            }
            
            matObj.reset(inStr);        
            matObj.region(lastEnd, matObj.regionEnd());
            
            regexFindCount = 0;
        }
        
        return outputList;
    }
}