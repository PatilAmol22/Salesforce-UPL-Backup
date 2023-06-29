public class SendGoalRequestWrapper {
/*
	public String actionCode;
	public String companyCode;
	public String contractNumber;
	public String approverEmail;
	public String I_ENVIAR;
	public String I_NETOUT;
	public String userRole;
	public String comments;
	public List<Goals> goals;

	public class Goals {
		public String skuCode;
		public String volume;
		public String unitPrice;
	}
*/
    public class Item {
		public String skuCode;
		public String volume;
		public String unitPrice;
	}

	public String actionCode;
	public String companyCode;
	public String contractNumber;
	public String approverEmail;
	public String I_ENVIAR;
	public String I_NETOUT;
	public String userRole;
	public String comments;
	public Goals goals;

	public class Goals {
		public List<Item> item;
	}
	
	/*public static SendGoalRequestWrapper parse(String json) {
		return (SendGoalRequestWrapper) System.JSON.deserialize(json, SendGoalRequestWrapper.class);
	}*/
}