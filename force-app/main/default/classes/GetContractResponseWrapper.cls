public class GetContractResponseWrapper {
    public String status;
	public List<ContractHeaders> contractHeaders;
	public class ContractHeaders {
		public String companyCode;
		public String contractNumber;
		public String ERDAT;
		public String customerCode;
		public String customerName;
		public String contractTypeCode;
		public String contractTypeName;
		public String regionCode;
		public String regionName;
		public String salesDirectorCode;
		public String salesDirectorName;
		public String salesOfficeCode;
		public String BEZEI;
		public String salesDistrictCode;
		public String salesDistrictName;
		public String contractStatusCode;
		public String contractStatusName;
		public String workflowStatusCode;
		public String workflowStatusDescription;
		public String contractInitialDate;
		public String contractFinalDate;
		public String salesPersonCode;
		public String salesPersonName;
		public String curr;
		public String contractCategoryCode;
		public String contractCategoryName;
		public String lastInvoiceDate;
		public String PMETA;
		public String DIATR;
		public String DEVPR;
		public String customerNameAndCity;
		public String city;
		public String state;
		public String documentCNP;
		public String STCD2CPF;
		public String CLVTX;
		public String growthIndex;
		public String EXPMM;
	}
	
	/*public static GetContractResponseWrapper parse(String json) {
		return (GetContractResponseWrapper) System.JSON.deserialize(json, GetContractResponseWrapper.class);
	}*/
}