/**********************************************
 * Name: CNT_AccountUpdateViaSalesDisrtrict
 * Created By: Varun Shrivastava
 * Create Date: 11 May 2021
 * Purpose: Update Account Owner on Update of Sales District User Field
 * Ticket: SCTASK0465715
**********************************************/
public class CNT_AccountUpdateViaSalesDisrtrict {
    
    @InvocableMethod
    public static void getAccountNames(List<ID> salesDistrictIDList) {
        BCH_AccountUpdateViaSalesDisrtrict batchInstance = new BCH_AccountUpdateViaSalesDisrtrict(salesDistrictIDList);
        Database.executeBatch(batchInstance, 1);
        salesDistrictUpdateTurkeySO_Batch batchObj = new salesDistrictUpdateTurkeySO_Batch(salesDistrictIDList);
        Database.executeBatch(batchObj,50);
    }
}