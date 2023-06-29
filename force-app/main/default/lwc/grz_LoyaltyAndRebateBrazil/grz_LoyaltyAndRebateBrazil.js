/**************************************************************************************************
* Name               : Grz_LoyaltyAndRebateBrazil                                                      
* Description        : JS controller for Grz_LoyaltyAndRebateBrazil component
* Created Date       : 10/02/2022                                                                
* Created By         : Grazitti Interactive                                                                    
* -------------------------------------------------------------------------------------------------
* VERSION  AUTHOR           DATE            COMMENTS                                                    
* 1.0      Nikhil Verma     10/02/2022      Initial Draft.                                              
**************************************************************************************************/
import { LightningElement, track, wire, api } from "lwc";
import Icons from "@salesforce/resourceUrl/Grz_Resourse";
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getContractDate from "@salesforce/apex/Grz_LoyaltyAndRebateBrazil.getContractDate"; //for contract Date and filter values
import getContractData from "@salesforce/apex/Grz_LoyaltyAndRebateBrazil.getContractData"; //for getting rebate records
export default class Grz_LoyaltyAndRebateBrazil extends NavigationMixin(
  LightningElement
) {
  @track searchKey = "";
  @api recordId;
  @track isInternal;
  @track progressPageLink;
  @track progressPageLink1;
  @track pagenumber = 1;
  @track recordstart = 0;
  @track recordend = 0;
  @track totalpages = 1;
  @track totalrecords = 0;
  @track isLoading = false;
  @track isLoaded = false;
  @track currentpagenumber = 1;
  @track pagesize = 10;
  @track pagesizeStr = "10";
  @track contractList;
  @track error;
  @track contractStartDate = "";
  @track contractEndDate = "";
  @track dataForFilter = "";
  /*Picklist Values*/
  @track directorsVal = "All";
  @track buVal = "All";
  @track regionalVal = "All";
  @track ctcVal = "All";
  @track distributorVal = "All";
  @track typeVal = "All";
  @track classificationVal = "All";
  @track statusVal = "All";
  /*Picklist options*/
  @track directorsOptions;
  @track buOptions;
  @track regionalOptions;
  @track ctcOptions;
  @track distributorOptions;
  @track typeOptions;
  @track classificationOptions;
  @track statusOptions;

  @track isSearched = false;
  backgroundimage = Icons + "/Grz_Resourse/Images/Carousel.jpg";
  get recordOption() {
    return [
      { label: "10", value: "10" },
      { label: "20", value: "20" },
      { label: "30", value: "30" }
    ];
  }
  renderedCallback() {
    this.template.querySelectorAll(".testcss").forEach((but) => {
      but.style.backgroundColor =
        this.pagenumber === parseInt(but.dataset.id, 10) ? "#F47920" : "white";
      but.style.color =
        this.pagenumber === parseInt(but.dataset.id, 10) ? "white" : "black";
    });
  }
  @wire(getContractDate)
  getContractDate(result) {
    if (result.data) {
      console.log("wire running====>", result);
      this.isLoaded = true;
      this.isInternal = result.data.isInternal;
      if (!this.isInternal) {
        this.contractList = result.data.liRebateContracts;
        if (this.contractList.length == 0) {
          this.nodata = true;
        } else {
          this.nodata = false;
        }
      }
      /**************************  Picklist Option Setup  ****************************************/
      if (this.isInternal) {
        this.contractStartDate = result.data.startDate;
        this.contractEndDate = result.data.endDate;
        let directors = result.data.liDirector;
        let tempdirectors = [];
        const option = {
          label: "escolha um...",
          value: "All"
        };
        tempdirectors = [...tempdirectors, option];
        for (let i = 0; i < directors.length; i++) {
          const option = {
            label: directors[i].name,
            value: directors[i].Id
          };
          tempdirectors = [...tempdirectors, option];
        }

        let bus = result.data.liBU;
        let tempbus = [];
        const option1 = {
          label: "escolha um...",
          value: "All"
        };
        tempbus = [...tempbus, option1];
        for (let i = 0; i < bus.length; i++) {
          const option = {
            label: bus[i].name,
            value: bus[i].Id
          };
          tempbus = [...tempbus, option];
        }

        let regionals = result.data.liRegion;
        let tempregionals = [];
        const option2 = {
          label: "escolha um...",
          value: "All"
        };
        tempregionals = [...tempregionals, option2];
        for (let i = 0; i < regionals.length; i++) {
          const option = {
            label: regionals[i].name,
            value: regionals[i].Id
          };
          tempregionals = [...tempregionals, option];
        }

        let ctcs = result.data.liSalesRep;
        let tempctcs = [];
        const option3 = {
          label: "escolha um...",
          value: "All"
        };
        tempctcs = [...tempctcs, option3];
        for (let i = 0; i < ctcs.length; i++) {
          const option = {
            label: ctcs[i].name,
            value: ctcs[i].Id
          };
          tempctcs = [...tempctcs, option];
        }

        let distributors = result.data.liDistributor;
        let tempdistributors = [];
        const option4 = {
          label: "escolha um...",
          value: "All"
        };
        tempdistributors = [...tempdistributors, option4];
        for (let i = 0; i < distributors.length; i++) {
          const option = {
            label: distributors[i].name,
            value: distributors[i].Id
          };
          tempdistributors = [...tempdistributors, option];
        }

        let classifications = result.data.liCategory;
        let tempClassification = [];
        const option5 = {
          label: "escolha um...",
          value: "All"
        };
        tempClassification = [...tempClassification, option5];
        for (let i = 0; i < classifications.length; i++) {
          const option = {
            label: classifications[i],
            value: classifications[i]
          };
          tempClassification = [...tempClassification, option];
        }

        let types = result.data.liType;
        let tempTypes = [];
        const option6 = {
          label: "escolha um...",
          value: "All"
        };
        tempTypes = [...tempTypes, option6];
        for (let i = 0; i < types.length; i++) {
          const option = {
            label: types[i],
            value: types[i]
          };
          tempTypes = [...tempTypes, option];
        }

        let status = result.data.liWFStatus;
        let tempStatus = [];
        const option7 = {
          label: "escolha um...",
          value: "All"
        };
        tempStatus = [...tempStatus, option7];
        for (let i = 0; i < status.length; i++) {
          const option = {
            label: status[i],
            value: status[i]
          };
          tempStatus = [...tempStatus, option];
        }
        this.classificationOptions = tempClassification;
        this.typeOptions = tempTypes;
        this.statusOptions = tempStatus;
        this.directorsOptions = tempdirectors;
        this.buOptions = tempbus;
        this.regionalOptions = tempregionals;
        this.ctcOptions = tempctcs;
        this.distributorOptions = tempdistributors;
      }
      /******************************************************************/
    } else if (result.error) {
      this.error = result.error;
      console.log("---Wire error----", this.error);
    }
  }
  handleAllData() {
    getContractData({
      startDatestring: this.contractStartDate,
      enddatestring: this.contractEndDate,
      directorsId: this.directorsVal,
      buId: this.buVal,
      regionalId: this.regionalVal,
      ctcId: this.ctcVal,
      distributorId: this.distributorVal,
      typeStr: this.typeVal,
      classificationStr: this.classificationVal,
      statusStr: this.statusVal,
      pageNumber: this.pagenumber,
      pageSize: this.pagesize
    })
      .then((result) => {
        if (result) {
          console.log("handle all data running +++++ ");
          console.log("full Wrapper1 +++++ ", result);
          this.contractList = result.liRebateContracts;
          this.dataForFilter = result.liRebateContracts;
          if (this.contractList.length == 0) {
            this.nodata = true;
          } else {
            this.nodata = false;
          }
          this.totalrecords = result.totalRecords;
          this.recordstart = result.RecordStart;
          this.recordend = result.RecordEnd;
          this.totalpages = Math.ceil(this.totalrecords / this.pagesize);
          this.generatePageList(this.pagenumber, this.totalpages);
          this.isLoading = false;
        }
      })
      .catch((error) => {
        this.error = error;
        console.log("---search error catch----", this.error);
      });
  }
  onChangeSearch(event) {
    this.searchKey = event.target.value;
    let filteredData = this.dataForFilter.filter(
      (obj) =>
        obj.DistributorCodeAndName.toLowerCase().includes(
          this.searchKey.toLowerCase()
        ) ||
        (obj.Contract &&
          obj.Contract.toLowerCase().includes(this.searchKey.toLowerCase())) ||
        (obj.Type &&
          obj.Type.toLowerCase().includes(this.searchKey.toLowerCase())) ||
        (obj.Category_Name &&
          obj.Category_Name.toLowerCase().includes(
            this.searchKey.toLowerCase()
          )) ||
        (obj.Status &&
          obj.Status.toLowerCase().includes(this.searchKey.toLowerCase())) ||
        (obj.Director &&
          obj.Director.toLowerCase().includes(this.searchKey.toLowerCase())) ||
        (obj.BU &&
          obj.BU.toLowerCase().includes(this.searchKey.toLowerCase())) ||
        (obj.Branch &&
          obj.Branch.toLowerCase().includes(this.searchKey.toLowerCase())) ||
        (obj.CTC &&
          obj.CTC.toLowerCase().includes(this.searchKey.toLowerCase())) ||
        (obj.Initial_date &&
          obj.Initial_date.toLowerCase().includes(
            this.searchKey.toLowerCase()
          )) ||
        (obj.Final_date &&
          obj.Final_date.toLowerCase().includes(this.searchKey.toLowerCase()))
    );
    this.contractList = filteredData;
  }
  startDateChange(event) {
    this.contractStartDate = event.target.value;
  }
  endDateChange(event) {
    this.contractEndDate = event.target.value;
  }
  handleProgressAction(event) {
    console.log(event.currentTarget.dataset.value);
    this.recordId = event.currentTarget.dataset.value;
    this.progressPageLink = "rebatedetailpage?id=" + this.recordId;
  }
  //For embedding rebate calculator button - Gurubaksh Grewal(Grazitti) (RITM0534476/RITM0523779)
  handleProgressAction1(event) {
    console.log(event.currentTarget.dataset.value);
    this.recordId = event.currentTarget.dataset.value;
    this.progressPageLink1 = "rebategoalpage?id=" + this.recordId;
  }
  handleContractSearch() {
    if (this.contractStartDate != null && this.contractEndDate != null) {
      var start = new Date(this.contractStartDate.slice(0, 10));
      var end = new Date(this.contractEndDate);
      if (end < start) {
        const event = new ShowToastEvent({
          title:
            "A data de término não pode ser anterior à data de início",
          variant: "error"
        });
        this.dispatchEvent(event);
      } else if (start > end) {
        const event = new ShowToastEvent({
          title: "A data de início não pode ser posterior à data de término",
          variant: "error"
        });
        this.dispatchEvent(event);
      } else {
        this.isSearched = true;
        this.isLoading = true;
        this.handleAllData();
      }
    } else {
      const event = new ShowToastEvent({
        title: "A data não pode estar vazia",
        variant: "error"
      });
      this.dispatchEvent(event);
    }
  }
  handleResetFilter() {
    this.directorsVal = "All";
    this.buVal = "All";
    this.regionalVal = "All";
    this.ctcVal = "All";
    this.distributorVal = "All";
    this.typeVal = "All";
    this.classificationVal = "All";
    this.statusVal = "All";
    this.pagesizeStr = "10";
    this.isLoading = true;
    this.handleAllData();
  }
  handleContractCancel() {
    this.isSearched = false;
    this.directorsVal = "All";
    this.buVal = "All";
    this.regionalVal = "All";
    this.ctcVal = "All";
    this.distributorVal = "All";
    this.typeVal = "All";
    this.classificationVal = "All";
    this.statusVal = "All";
  }
  handleFilterOptions(event) {
    if (event.target.dataset.value == "Directors") {
      this.directorsVal = event.target.value;
      this.isLoading = true;
      this.handleAllData();
    } else if (event.target.dataset.value == "BU") {
      this.buVal = event.target.value;
      this.isLoading = true;
      this.handleAllData();
    } else if (event.target.dataset.value == "Regional") {
      this.regionalVal = event.target.value;
      this.isLoading = true;
      this.handleAllData();
    } else if (event.target.dataset.value == "CTC") {
      this.ctcVal = event.target.value;
      this.isLoading = true;
      this.handleAllData();
    } else if (event.target.dataset.value == "Distributor") {
      this.distributorVal = event.target.value;
      this.isLoading = true;
      this.handleAllData();
    } else if (event.target.dataset.value == "Type") {
      this.typeVal = event.target.value;
      this.isLoading = true;
      this.handleAllData();
    } else if (event.target.dataset.value == "Classification") {
      this.classificationVal = event.target.value;
      this.isLoading = true;
      this.handleAllData();
    } else if (event.target.dataset.value == "Status") {
      this.statusVal = event.target.value;
      this.isLoading = true;
      this.handleAllData();
    }
  }
  handleRecordPerPage(event) {
    this.pagesize = parseInt(event.detail.value);
    this.pagesizeStr = event.detail.value;
    this.isLoading = true;
    this.handleAllData();
  }
  handleFirst(event) {
    var pagenumber = 1;
    this.pagenumber = pagenumber;
    this.isLoading = true;
    this.handleAllData();
    /*const scrollOptions = {
      left: 0,
      top: ,
      behavior: "smooth"
    };
    window.scrollTo(scrollOptions);*/
  }
  processMe(event) {
    if (this.pagenumber != parseInt(event.target.name)) {
      this.pagenumber = parseInt(event.target.name);
      this.isLoading = true;
      this.handleAllData();
    } else {
      this.isLoading = false;
    }
    /*const scrollOptions = {
      left: 0,
      top: 0,
      behavior: "smooth"
    };
    window.scrollTo(scrollOptions);*/
  }
  get disableFirst() {
    if (this.pagenumber == 1) {
      return true;
    }
    return false;
  }
  get disableNext() {
    if (
      this.pagenumber == this.totalpages ||
      this.pagenumber >= this.totalpages
    ) {
      return true;
    }
    return false;
  }
  handlePrevious(event) {
    this.pagenumber--;
    this.isLoading = true;
    this.handleAllData();
    /*const scrollOptions = {
      left: 0,
      top: 0,
      behavior: "smooth"
    };
    window.scrollTo(scrollOptions);*/
  }
  handleNext(event) {
    this.pagenumber = this.pagenumber + 1;
    this.isLoading = true;
    this.handleAllData();
    /*const scrollOptions = {
      left: 0,
      top: 0,
      behavior: "smooth"
    };
    window.scrollTo(scrollOptions);*/
  }
  handleLast(event) {
    this.pagenumber = this.totalpages;
    this.isLoading = true;
    this.handleAllData();
    /*const scrollOptions = {
      left: 0,
      top: 0,
      behavior: "smooth"
    };
    window.scrollTo(scrollOptions);*/
  }
  generatePageList = (pagenumber, totalpages) => {
    var pagenumber = parseInt(pagenumber);
    var pageList = [];
    var totalpages = this.totalpages;
    this.pagelist = [];
    if (totalpages > 1) {
      if (totalpages < 3) {
        if (pagenumber == 1) {
          pageList.push(1, 2);
        }
        if (pagenumber == 2) {
          pageList.push(1, 2);
        }
      } else {
        if (pagenumber + 1 < totalpages && pagenumber - 1 > 0) {
          pageList.push(pagenumber - 1, pagenumber, pagenumber + 1);
        } else if (pagenumber == 1 && totalpages > 2) {
          pageList.push(1, 2, 3);
        } else if (pagenumber + 1 == totalpages && pagenumber - 1 > 0) {
          pageList.push(pagenumber - 1, pagenumber, pagenumber + 1);
        } else if (pagenumber == totalpages && pagenumber - 1 > 0) {
          pageList.push(pagenumber - 2, pagenumber - 1, pagenumber);
        }
      }
    }
    this.pagelist = pageList;
  };
}