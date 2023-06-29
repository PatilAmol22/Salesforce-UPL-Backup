/* Related to Email Servicxe batch to read csv */

public class CsvReder {
    public static List<List<String>> readIETFRFC4180CSVFile(Blob file) {
        String fileString = file.toString();
        
        if (!fileString.endsWith(Parser.CRLF)) {
            fileString = fileString + Parser.CRLF;
        }
        
        List<List<String>> fileValues = new List<List<String>>();
        List<String> rowValues = new List<String>();
        CSVValue csvValue = new CSVValue();
        
        Boolean eod = false;  // Whether end of CSV data is reached
        while (!eod) {
            System.debug(fileString);
            
            csvValue = readIETFRFC4180CSVValue(fileString);
            
            rowValues.add(csvValue.value);
            
            if (csvValue.delimiter == Parser.CRLF) {
                fileValues.add(rowValues);
                
                System.debug(rowValues);
                
                if (fileValues.size() > 0) {
                    System.assertEquals(fileValues.get(0).size(),
                                        rowValues.size());
                }
                
                rowValues = new List<String>();
            }
            
            if (csvValue.biteSize() == fileString.length()) {
                eod = true;
            }
            else {
                fileString = fileString.substring(csvValue.biteSize());
            }
        }
        
        return fileValues;
    }
    
    public static CSVValue readIETFRFC4180CSVValue(String data) {
        System.assert(data.endsWith(Parser.CRLF));
        
        CSVValue csvValue = new CSVValue();
        
        if (data.startsWith(Parser.DQUOTE)) {
            csvValue.enclosed = true;
            
            Integer searchIndex = 1;      // starting index to search
            Integer dquoteIndex = -1;     // index of DQUOTE
            Integer dquotesIndex = -1;    // index of DQUOTEDQUOTE
            
            Boolean closerFound = false;
            
            while (!closerFound) {
                dquoteIndex = data.indexOf(Parser.DQUOTE, searchIndex);
                
                dquotesIndex = data.indexOf(Parser.DQUOTEDQUOTE,
                                            searchIndex);
                
                System.assert(dquoteIndex != -1);
                
                if (dquoteIndex == dquotesIndex) {
                    searchIndex = dquotesIndex
                        + Parser.DQUOTEDQUOTE.length();
                }
                else {
                    closerFound = true;
                }
            }
            
            csvValue.value = data.substring(
                Parser.DQUOTE.length(), dquoteIndex)
                .replaceAll(Parser.DQUOTEDQUOTE, Parser.DQUOTE);
            
            Integer commaIndex = data.indexOf(Parser.COMMA, dquoteIndex);
            Integer crlfIndex = data.indexOf(Parser.CRLF, dquoteIndex);
            
            if (commaIndex != -1 && commaIndex < crlfIndex) {
                csvValue.delimiter = Parser.COMMA;
            }
            else {
                csvValue.delimiter = Parser.CRLF;
            }
        }
        else {
            csvValue.enclosed = false;
            
            Integer commaIndex = data.indexOf(Parser.COMMA);
            Integer crlfIndex = data.indexOf(Parser.CRLF);
            
            if (commaIndex != -1 && commaIndex < crlfIndex) {
                csvValue.value = data.substring(0, commaIndex);
                csvValue.delimiter = Parser.COMMA;
            }
            else {
                csvValue.value = data.substring(0, crlfIndex);
                csvValue.delimiter = Parser.CRLF;
            }
        }
        
        System.debug('Returning: ' + csvValue);
        
        return csvValue;
    }
    
    public static List<List<String>> readCSVFile(String file)
    {
        //Remove trailing empty lines
        String fileString = file.replaceAll('\\s*\\z', '');
        if(!fileString.endsWith(Parser.crlf))
            fileString = fileString + Parser.crlf;
        List<List<String>> fileValues = new List<List<String>>();
        List<String> rowValues = new List<String>();
        CSVValue csvValues = new CSVValue();
        Boolean eod = false; //Whether end of CSV data is reached
        while(!eod)
        {
            csvValues = readIETFRFC4180CSVValue(fileString);
            rowValues.add(csvValues.value);
            if(csvValues.delimiter == Parser.crlf)
            {
                fileValues.add(rowValues);
                if(fileValues.size() > 0)
                {
                    if(fileValues.get(0).size() != rowValues.size()){}
                    //Throw an exception
                }
                rowValues = new List<String>();
            }
            if(csvValues.biteSize() == fileString.length())
                eod = true;
            else
                fileString = fileString.subString(csvValues.biteSize());
        }
        return fileValues;
    }
    
    public class CSVValue {
        
        public String value;
        public Boolean enclosed;
        public String delimiter;
        
        
        public CSVValue() {
            this(null, null, null);
        }
        
        public CSVValue(String value, Boolean enclosed, String delimiter) {
            this.value = value;
            this.enclosed = enclosed;
            this.delimiter = delimiter;
        }
        
        public Integer biteSize() {
            Integer biteSize = value
                .replaceAll(Parser.DQUOTE, Parser.DQUOTEDQUOTE).length()
                + delimiter.length();
            
            if (enclosed) {
                biteSize += Parser.DQUOTE.length() * 2;
            }
            
            System.debug('biteSize: ' + biteSize);
            
            return biteSize;
        }
        public Boolean equals(CSVValue compCSVValue) {
            return this.value.equals(compCSVValue.value)
                && this.enclosed == compCSVValue.enclosed
                && this.delimiter == compCSVValue.delimiter;
        }
        public void assertEquals(CSVValue compCSVValue) {
            System.assertEquals(value, compCSVValue.value);
            System.assertEquals(enclosed, compCSVValue.enclosed);
            System.assertEquals(delimiter, compCSVValue.delimiter);
        }
    }
}