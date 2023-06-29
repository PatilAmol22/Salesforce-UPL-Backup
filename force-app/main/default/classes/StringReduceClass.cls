/*
* Class Name - StringReduceClass
* Created Date - 30th Apr, 2023
* Author - Abhinay/Chakresh
* Description - Created a Controller for VF page NebulizationApplicationPage. 
* */

public class StringReduceClass {
    public static final Integer DEFAULT_LINE_LENGTH = 70;
    public static final String NEW_LINE = '\n';
    private static String SPLIT_CHARS = ' -';
    
  
    public static String splitLines(String input, Integer lineLength) {
        if (input == null) return input;
        List<String> finalLines = new List<String>();
        for (String singleLine : input.split('\n')) {
            finalLines.add(splitLinesSingleLine(singleLine, lineLength));
        }
        return String.join(finalLines, NEW_LINE);
    }
    
    private static String splitLinesSingleLine(String input, Integer lineLength) {
        if (lineLength == null) { lineLength = DEFAULT_LINE_LENGTH; }

        System.debug('input'+input.length());
        System.debug('lineLength'+lineLength);
        
        if (input == null || input.length() <= lineLength) return input;
        
        String[] words = explode(input, SPLIT_CHARS);
        
        Integer curLineLength = 0;
        List<String> strBuilder = new List<String>();
        for(Integer i = 0; i < words.size(); i += 1)
        {
            String word = words[i];
            // If adding the new word to the current line would be too long,
            // then put it on a new line (and split it up if it's too long).
            if (curLineLength + word.length() > lineLength) {
                // Only move down to a new line if we have text on the current line.
                // Avoids situation where wrapped whitespace causes emptylines in text.
                if (curLineLength > 0) {
                    strBuilder.add(NEW_LINE);
                    curLineLength = 0;
                }
                
                while (word.length() > lineLength) {
                    strBuilder.add(word.subString(0, lineLength - 1) + '');
                    word = word.subString(lineLength - 1);
                    strBuilder.add(NEW_LINE);
                }
                
                word = word.trim();
            }
            strBuilder.add(word);
            curLineLength += word.length();
        }
        
        String combinedLine = String.join(strBuilder, '');
        
        combinedLine = combinedLine.replaceAll('\\s*<br/>', '<br/>');
        return combinedLine;
    }
    
    private static String[] explode(String str, String splitCharacters) {
        List<String> parts = new List<String>();
        if (str != null) {
            Integer startIndex = 0;
            while (true) {
                Integer preIndex = str.subString(startIndex).indexOfAny(splitCharacters);
                Integer index = startIndex + preIndex;
                
                if (preIndex == -1) {
                    parts.add(str.subString(startIndex));
                    break;
                }
                
                String word = str.subString(startIndex, index);
                String nextChar = str.subString(index, index + 1);
                
                // Dashes and the likes should stick to the word occuring before it. Whitespace doesn't have to.
                if (nextChar.isWhiteSpace()) {
                    parts.Add(word);
                    parts.Add(nextChar);
                } else {
                    parts.Add(word + nextChar);
                }
                
                startIndex = index + 1;
            }
        }
        return parts;
    }
    
}