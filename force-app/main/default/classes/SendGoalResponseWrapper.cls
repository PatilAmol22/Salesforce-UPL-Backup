public class SendGoalResponseWrapper {

	public String status;
	public String error;
	//public String goals;
	public List<Goals> goals;

	public class Goals {
		public String skuCode;
		public String goalVolume;
		public String unitPrice;
	}
	
	/*public static SendGoalResponseWrapper parse(String json) {
		return (SendGoalResponseWrapper) System.JSON.deserialize(json, SendGoalResponseWrapper.class);
	}*/
}