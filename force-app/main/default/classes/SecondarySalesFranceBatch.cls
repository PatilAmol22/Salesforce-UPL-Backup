global class SecondarySalesFranceBatch implements Database.batchable<String>, Database.Stateful
{
    
    String m_csvFile;
    Integer execution=0;
	public SecondarySalesFranceBatch(String csv)
    {
        m_csvFile= csv;
    }

	global Iterable<String> start(Database.batchableContext batchableContext){
        System.debug('m_csvFile 2:--'+m_csvFile);
        return new CSVIterator(m_csvFile, Parser.crlf);
    }


	global void execute(Database.BatchableContext batchableContext, List<String> scope){
        try{
            String csvFile = '';
            if (execution!=0)
            {
            csvFile='\r\n';
            }
                for(String row : scope){
                csvFile += row + Parser.crlf;
            }  
            String results = SecondarySalesFrance.passFile(csvFile);
            execution++;
            //masterwrap.addAll(wrap);
        }
        catch(Exception e){
            System.debug('Line No: '+e.getLineNumber()+' Error message: '+e.getMessage());
        }
    }
      global void finish(Database.BatchableContext batchableContext){
          //do nothing          
}
}