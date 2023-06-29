public class GetApprovalHistoryResponseWrapper {
    
    public String status;
	public List<ApprovalHistory> approvalHistory;

	public class ApprovalHistory {
		public String dateOfRecord;
		public String hourOfRecord;
		public String status;
		public String statusCode;
		public String statusDescription;
		public String profileCode;
		public String profileDescription;
		public String sapUserTransactionCode;
		public String approverEmail;
		public String actionCode;
		public String actionDescription;
		public String datetimeOfRecord;
		public String approvalComments;
	}

}