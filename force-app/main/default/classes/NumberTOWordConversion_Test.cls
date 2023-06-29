@isTest
public class NumberTOWordConversion_Test {
    
    @isTest
    static void TestNumberToWordConversion(){
        Test.startTest();
        Decimal num1 = 888888888.88;
        Decimal num2 = 100000000.00;
        String NumInWords = '';
        
        NumberTOWordConversion numToWord = new NumberTOWordConversion();
        NumInWords = numToWord.getNumberTOWordConversion(num1);
        
        System.debug('NumInWords : '+NumInWords);
        
        system.assertEquals(' Eighty Eight Crore Eighty Eight Lakh Eighty Eight Thousand Eight Hundred and Eighty Eight Rupiah And  Eighty Eight Paise Only', NumInWords);
        
        NumInWords = numToWord.getNumberTOWordConversion(num2);
        
        System.debug('NumInWords : '+NumInWords);
        //system.assertEquals('', NumInWords);
        Test.stopTest();
    }

}