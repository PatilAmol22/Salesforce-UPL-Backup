public class GetStockInChannelResponseWrapper {
    
    public String status;
	public List<SumByCustomer> sumByCustomer;

	public class SumByCustomer {
		public String skuCode;
		public String customerCode;
		public String yearMonth;
		public String Volume;
		public String netSales;
	}

	
	/*public static GetStockInChannelResponseWrapper parse(String json) {
		return (GetStockInChannelResponseWrapper) System.JSON.deserialize(json, GetStockInChannelResponseWrapper.class);
	}*/

}