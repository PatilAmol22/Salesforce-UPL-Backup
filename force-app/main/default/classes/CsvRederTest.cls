/* Related to Email Servicxe batch to read csv (test class for CSV Reader) */
@isTest
public class CsvRederTest {
        
    /**
     * Test some use cases for reading IETF RFC 4180-compliant CSV values.
     */
    public static testMethod void readIETFRFC4180CSVValueTest() {
        String data = null;  // Placeholder for data to use in testing.
        
        System.debug(data = Parser.CRLF);
        new CsvReder.CSVValue('', false, Parser.CRLF)
                .assertEquals(CsvReder.readIETFRFC4180CSVValue(data));
        
        System.debug(data = '""' + Parser.CRLF);
        new CsvReder.CSVValue('', true, Parser.CRLF)
                .assertEquals(CsvReder.readIETFRFC4180CSVValue(data));
        
        System.debug(data = '"",asdf' + Parser.CRLF);
        new CsvReder.CSVValue('', true, Parser.COMMA)
                .assertEquals(CsvReder.readIETFRFC4180CSVValue(data));
        
        System.debug(data = ',asdf' + Parser.CRLF);
        new CsvReder.CSVValue('', false, Parser.COMMA)
                .assertEquals(CsvReder.readIETFRFC4180CSVValue(data));
        
        System.debug(data = '"' + Parser.CRLF + '",blah' + Parser.CRLF);
        new CsvReder.CSVValue(Parser.CRLF, true, Parser.COMMA)
                .assertEquals(CsvReder.readIETFRFC4180CSVValue(data));
        
        System.debug(data = '"""marty""","""chang"""' + Parser.CRLF);
        new CsvReder.CSVValue('"marty"', true, Parser.COMMA)
                .assertEquals(CsvReder.readIETFRFC4180CSVValue(data));
        
        System.debug(data = '"com""pli""cate' + Parser.CRLF + 'd"'
                + Parser.CRLF);
        new CsvReder.CSVValue('com"pli"cate' + Parser.CRLF + 'd', true, Parser.CRLF)
                .assertEquals(CsvReder.readIETFRFC4180CSVValue(data));
        
        System.debug(data = 'asdf' + Parser.CRLF);
        new CsvReder.CSVValue('asdf', false, Parser.CRLF)
                .assertEquals(CsvReder.readIETFRFC4180CSVValue(data));
    }
    
    public static testMethod void readIETFRFC4180CSVFile() {
        String data = 'abc,"def","g""h""i"' + Parser.CRLF + '"j' + Parser.CRLF
            + 'kl","m' + Parser.CRLF + 'n""o""",';
        
        List<List<String>> fileValues =
         CsvReder.readIETFRFC4180CSVFile(Blob.valueOf(data));
       
    }
}