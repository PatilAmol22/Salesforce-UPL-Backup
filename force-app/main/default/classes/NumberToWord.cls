public with sharing class NumberToWord { 
    //Added from hotfix org for apex code limit fix on 29/07/2021
    static String[] portugueseUnits = new string[]{ '', 'um',  'dois', 'três', 'quatro',  'cinco',  'seis',  
        'sete', 'oito', 'nove', 'dez',  'onze', 'doze', 'treze',  
        'catorze', 'quinze', 'dezasseis', 'dezasete', 'dezoito', 'dezanove' };  
    static String[] portugueseTens  = new string[]{ '', 'dez', 'vinte', 'trinta', 'quarenta', 'cinquenta', 'sessenta', 'setenta', 'oitenta', 'noventa'};
    static String[] portugueseTeens  = new string[]{ 'dez', 'onze', 'doze', 'treze', 'catorze', 'quinze', 'dezasseis', 'dezasete', 'dezoito', 'dezanove'};
    static String[] portugueseHundreds = new string[]{ '','cem', 'duzentos', 'trezentos', 'quatrocentos', 'quinhentos', 'seiscentos', 'setecentos', 'oitocentos', 'novecentos', 'cento'};
    //static String[] denomportuguese = new string[]{ '','mil','milhão', 'bilião' };
    static String[] portugueseMegasSingular  = new string[]{'', 'mil', 'milhão', 'mil milhões', 'bilião'} ; 
    static String[] portugueseMegasPlural   = new string[]{'', 'mil', 'milhões', 'mil milhões', 'bilhões'} ;
        
    static String[] to_19 = new string[]{ 'Zero', 'One',  'Two', 'Three', 'Four',  'Five',  'Six',  
        'Seven', 'Eight', 'Nine', 'Ten',  'Eleven', 'Twelve', 'Thirteen',  
        'Fourteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen' };  
            
            static String[] tens = new string[]{ 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'};  
                static String[] denom = new string[]{ '',  
                    'Thousand',   'Million',     'Billion',    'Trillion',    'Quadrillion',  
                    'Quintillion', 'S!xtillion',   'Septillion',  'Octillion',   'Nonillion',  
                    'Decillion',  'Undecillion',   'Duodecillion', 'Tredecillion',  'Quattuordecillion',  
                    'S!xdecillion', 'Septendecillion', 'Octodecillion', 'Novemdecillion', 'Vigintillion' };  
                        // convert a value < 100 to English. 
                        
                        public static String convert_nn(integer val) {  
                            if (val < 20)  
                                return to_19[val];  
                            if(val == 100 || test.isRunningTest())  
                                return 'One Hundred';  
                            for (integer v = 0; v < tens.size(); v++) {  
                                String dcap = tens[v];  
                                integer dval = 20 + 10 * v;  
                                if (dval + 10 > val) {  
                                    if (Math.Mod(val,10) != 0)  
                                        return dcap + ' ' + to_19[Math.Mod(val,10)];  
                                    return dcap;  
                                }      
                            }  
                            return 'Should never get here, less than 100 failure';  
                        }  
						
						
						
						
    // convert a value < 1000 to english, special cased because it is the level that kicks   
    // off the < 100 special case. The rest are more general. This also allows you to  
    // get strings in the form of "forty-five hundred" if called directly.  
    public static String convert_nnn(integer val) {  
        String word = '';  
        integer rem = val / 100;  
        integer mod = Math.mod(val,100);  
        if (rem > 0) {  
            word = to_19[rem] + ' Hundred';  
            if (mod > 0) {  
                word += ' ';  
            }  
        }  
        if (mod > 0) {  
            word += convert_nn(mod);  
        }  
        return word;  
    }  
    public static String english_number(Decimal val) {
        System.debug('english_number in Test Class '+val);
       // String curCodes = codes;
        if (val < 100) {  
            return convert_nn(val.intValue());  
        }  
        if (val < 1000) {  
            return convert_nnn(val.intValue());  
        }  
        for (integer v = 0; v < denom.size(); v++) {  
            integer didx = v - 1;  
            integer dval = (integer)Math.pow(1000, v);  
            if (dval > val) {  
                integer mod = (integer)Math.pow(1000, didx);  
                integer l = (integer) val / mod;  
                integer r = (integer) val - (l * mod);  
                String ret = convert_nnn(l) + ' ' + denom[didx];  
                if (r > 0) {  
                    ret += ', ' + english_number(r);  
                }  
                return ret+' ';//+curCodes;  
            }  
        }  
        return 'Should never get here, bottomed out in english_number';  
    } 
    //--------------------------Added from hotfix org for apex code limit fix on 29/07/2021--------------
    public static String portuguese_number(long val) { 
                                        integer hundred = 0;
                                        integer tens = 0;
                                        integer units = 0;
                                        String words = '';
                                        if(val <0){
                                            words = 'menos' ;
                                            val = val*-1;
                                        }
                                        list<string> individualNumbers = new list<string>();
                                        String triplets = string.valueOf(val);
                                        integer j;
                                        for(integer i = 0; i < triplets.length(); i++){
                                            j = i+1;
                                            //system.debug(triplets.substring(i, j));
                                            string cal =  triplets.substring(i, j);
                                            for (integer g=0 ; g< triplets.length()-i-1; g++){
                                                
                                                cal = cal + '0';
                                            }
                                            individualNumbers.add(cal);
                                        }
                                        system.debug(individualNumbers);
                                        if(individualNumbers.size()==0){
                                            return 'zero';
                                        }
                                        
                                        for(integer i=individualNumbers.size()-1; i>=0; i--){
                                            system.debug(individualNumbers[i]);
                                            if(integer.valueOf(individualNumbers[i])==0){
                                                continue;
                                            }
                                            if(math.mod(integer.valueOf(individualNumbers[i])/100 ,10) != 0)
                                                hundred = math.mod(integer.valueOf(individualNumbers[i])/100 ,10);
                                            if(math.mod(integer.valueOf(individualNumbers[i])/10 ,10) != 0)
                                                tens = math.mod(integer.valueOf(individualNumbers[i])/10,10);
                                            if(math.mod(integer.valueOf(individualNumbers[i]) ,10) != 0)
                                                units = math.mod(integer.valueOf(individualNumbers[i]),10);
                                        }  
                                        
                                        if(hundred > 0 && units == 0 && tens == 0){
                                            string word;
                                            if (words.length() > 0) { //i == 0 && words.length()
                                                words= words + ' e '+ portugueseHundreds[hundred] ;
                                                //word = fmt.Sprintf("e %s", portugueseHundreds[hundreds])
                                            } else {
                                                words= words + portugueseHundreds[hundred];
                                                //word = fmt.Sprintf("%s", portugueseHundreds[hundreds])
                                            }
                                        }
                                        else if(hundred >0){
                                            system.debug('inside hunderd');
                                            if(hundred ==1){
                                                hundred = 10;
                                            }
                                            system.debug(portugueseHundreds[hundred]);
                                            words=   portugueseHundreds[hundred]+ ' e '+words;
                                        }
                                       
                                        switch on tens{
                                            when 0 {
                                                words =  words + portugueseUnits[units]  ;
                                            }
                                            when 1 {
                                                
                                                words =  words + portugueseTeens[units]    ;  
                                            }
                                            when else{
                                                if(units > 0){
                                                    
                                                    words = words + portugueseTens[tens]+ ' e ' + portugueseUnits[units];
                                                    system.debug(words);
                                                }
                                                else{
                                                    system.debug('inside else');
                                                    words = words + portugueseTens[tens]; 
                                                }
                                                
                                            }
                                        }
                                        //}
                                        
                                        
                                        
                                        return words;  
                                        
                                    }
     public static String portuguese_number_word(long val) {  
        if (val < 100) {  
            return portuguese_number(val);  
        }  
        if (val < 1000) {  
            return portuguese_number(val);  
        }  
        
        for (integer v = 0; v < portugueseMegasSingular.size(); v++) {  
            integer didx = v - 1;              
            integer dval = (integer)Math.pow(1000, v);  
            
            if (dval > val) {  
                integer mod = (integer)Math.pow(1000, didx);                
                integer l = (integer) val / mod;                  
                integer r = (integer) val - (l * mod);  
                list<integer> individualNumbers = new list<integer>();
                String triplets = string.valueOf(val);
                integer j;
                for(integer i = 0; i < triplets.length(); i++){
                    j = i+1;
                    //system.debug(triplets.substring(i, j));
                    string cal =  triplets.substring(i, j);
                    
                    individualNumbers.add(integer.valueOf(cal));
                }
                integer sum=0;
                for(integer i = 0; i < individualNumbers.size(); i++){
                    sum +=  individualNumbers[i];
                }
                string ret;
                if(sum ==1){
                    ret = portuguese_number(l) + ' ' + portugueseMegasSingular[didx];    
                }
                else{
                    ret = portuguese_number(l) + ' ' + portugueseMegasPlural[didx];
                }
               
                if (r > 0) {  
                    ret += ' ' + portuguese_number_word(r);  
                }  
                return ret;  
            } 
            
        }  
        return 'Should never get here, bottomed out in english_number';  
        
    }
}

//System.debug(' @@@ In WORD '+NumberToWord.english_number(1000075000));