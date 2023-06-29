/* Related to Email Service batch to read csv */

public class SplitString {
    
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
    
    /*public static String[] splitFirst(String source, String splitter)
    {
        // hold the results as we find them
        List<String> rv = new List<String>();
        Integer last = 0;
        Integer next = 0;
        
        // find first splitter in source
        next = source.indexOf(splitter, last);
        if (next != -1)
        {
            // isolate from last thru before next
            rv.add(source.substring(last, next));
            last = next + splitter.length();
        }
        
        if (last < source.length())
        {
            rv.add(source.substring(last, source.length()));
        }
        
        // convert to array
        //return (String[]) rv.toArray(new String[rv.size()]);
        return rv;
    }*/
}