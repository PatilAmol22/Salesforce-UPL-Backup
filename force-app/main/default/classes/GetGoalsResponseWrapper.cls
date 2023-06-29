Public class GetGoalsResponseWrapper {

	public String status;
    //public String E_NATAOT;
    public String E_NETAOT;
    public String E_NETOUT;
    public String E_PCMMT;
    //public Object TE_APROVA;
    //public Object TE_METAS;
	public List<Materials> materials;
	public List<ApprovalHistory> approvalHistory;

	public class ApprovalHistory {
		public String approverCode;
		public String approverEmail;
		public String approverProfileCode;
		public String approverProfileName;
		public String actionCode;
		public String actionDescription;
		public String comments;
		public String dateOfApproval;
	}

	public class Materials {
		public String skuCode;
		public String EXTWG;
		public String MAKTX;
		public String productCategory;
		public String DEMCLS;
		/*public Integer volumeLastYear;
		public Integer unitPriceLastYear;
		public Integer totalValueLastYear;
		public Integer volumeCurrentYear;
		public Integer unitPriceCurrentYear;
		public Integer totalValueCurrentYear;
*/
        public String volumeLastYear;
		public String unitPriceLastYear;
		public String totalValueLastYear;
		public String volumeCurrentYear;
		public String unitPriceCurrentYear;
		public String totalValueCurrentYear;
        
}

	
	/*public static GetGoalsResponseWrapper parse(String json) {
		return (GetGoalsResponseWrapper) System.JSON.deserialize(json, GetGoalsResponseWrapper.class);
	}*/
}