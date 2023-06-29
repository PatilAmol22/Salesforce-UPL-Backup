public class GetGoalActualsResponseWrapper {

	public class Returns {
		public String actualValue;
		public String returnsValue;
	}

	public String status;
	public List<Goals> goals;
	public List<SkuLevel> skuLevel;
	public List<Invoices> invoices;
	public Returns returns;
	public GoalsXactualXlastYear goalsXactualXlastYear;
	public List<Results> results;
    public List<OtherProducts> otherProducts;
	public Object TE_ACOMPANHAMENTO;
	public Object TE_ACOMPANHAMENTO_M;
	public Object TE_ACOMPANHAMENTO_NF;
	public Object TE_ACOM_DEVOLUCAO;
	public Object TE_ACOM_META_ANTERIOR;
	public Object TE_APURACAO_RESULT;
    
    public class OtherProducts {
		public String productCategoryCode;
		public String productCategoryDescription;
		public String productBrand;
		public String salesDirectorCode;
		public String salesOfficeCode;
		public String salesDistrictCode;
		public String salesPersonCode;
		public String actualVolume;
		public String actualValue;
		public String returnsVolume;
		public String returnsValue;
		public String atingimentoVolume;
		public String goalVolume;
		public String goalValue;
		public String VOLUMRCON;
		public String VALORRCON;
		public String VOLUMDCON;
		public String VALORDCON;
		public String VLRRNF;
		public String VLDVNF;
		public String realVolume;
		public String realValue;
		public String XBONUS;
		public String BONANT;
		public String BONMET;
		public String VOLUMAN;
		public String VALORAN;
	}

	public class Results {
		public String productCategoryCode;
		public String productCategoryDescription;
		public String goalCurrentYear;
		public String VALORR;
		public String VLRRNF;
		public String VALORD;
		public String salesValue;
		public String VLRFAT;
	}

	public class SkuLevel {
		public String productCategoryCode;
		public String productCategoryDescription;
		public String productBrand;
		public String skuCode;
		public String salesDirectorCode;
		public String salesOfficeCode;
		public String salesDistrictCode;
		public String salesPersonCode;
		public String actualVolume;
		public String actualValue;
		public String returnsVolume;
		public String returnsValue;
		public String atingimentoVolume;
		public String goalVolume;
		public String goalValue;
		public String VOLUMRCON;
		public String VALORRCON;
		public String VOLUMDCON;
		public String VALORDCON;
		public String VLRRNF;
		public String VLDVNF;
		public String realVolume2ndPart;
		public String realValue2ndPart;
		public String VOLUMAN;
		public String VALORAN;
	}

	public class GoalsXactualXlastYear {
		public String lastYearValue;
		public String goalsValue;
		public String actualValue;
	}

	public class Invoices {
		public String productCategoryCode;
		public String productCategoryDescription;
		public String productBrand;
		public String invoiceNumber;
		public String skuCode;
		public String salesDirectorCode;
		public String salesOfficeCode;
		public String salesDistrictCode;
		public String salesPersonCode;
		public String VOLUMR;
		public String VALORR;
		public String VOLUMD;
		public String VALORD;
		public String IGNOR;
	}

	public class Goals {
		public String productCategoryCode;
		public String productCategoryDescription;
		public String productBrand;
		public String salesDirectorCode;
		public String salesOfficeCode;
		public String salesDistrictCode;
		public String salesPersonCode;
		public String currentVolume;
		public String currenttValue;
		public String returnsVolume;
		public String returnsValue;
		public String atingimentoVolume;
		public String goalsVolume;
		public String goalsValue;
		public String VOLUMRCON;
		public String VALORRCON;
		public String VOLUMDCON;
		public String VALORDCON;
		public String VLRRNF;
		public String VLDVNF;
		public String realVolume;
		public String realValue;
		public String XBONUS;
		public String BONANT;
		public String BONMET;
		public String VOLUMAN;
		public String VALORAN;
	}


    

	//
	/*public static GetGoalActualsResponseWrapper parse(String json) {
		return (GetGoalActualsResponseWrapper) System.JSON.deserialize(json, GetGoalActualsResponseWrapper.class);
	}*/
}