/**************************************************************************************************
* Name               : Grz_Customer360Wrapper                                                      
* Description        : Wrapper class for all Customer360 moduled
* Created Date       : 30/06/2022                                                                 
* Created By         : Nikhil Verma (Grazitti)                                                                       
**************************************************************************************************/ 
public without sharing class Grz_Customer360Wrapper {

    public class Wrapper {
        @AuraEnabled public Object data                 {get;set;}
        @AuraEnabled public Item items                  {get;set;}
        @AuraEnabled public Item collection             {get;set;}
        @AuraEnabled public Object account              {get;set;}
        @AuraEnabled public String totalCredit          {get;set;}
        @AuraEnabled public String totalDebit           {get;set;}
        @AuraEnabled public Decimal totalOutstanding    {get;set;}
        @AuraEnabled public CustomerInfo customerInfo   {get;set;}
        @AuraEnabled public List<ItemInfo> ItemInfo     {get;set;}
        @AuraEnabled public List<Lineitems> lineitems   {get;set;}
        @AuraEnabled public String message              {get;set;}
        @AuraEnabled public Boolean success             {get;set;}
    
        public Wrapper(){
            this.message = 'Success';
            this.success = true;
        }
    }

    public class ReturnData {
        @AuraEnabled public String Type         {get;set;}
        @AuraEnabled public String Code         {get;set;}
        @AuraEnabled public String Message      {get;set;}
    }

    public class LabelsWrapper{
        @AuraEnabled public String creditSummary        {get;set;}
        @AuraEnabled public String creditLimit          {get;set;}
        @AuraEnabled public String usedLimit            {get;set;}
        @AuraEnabled public String balanceLimit         {get;set;}
        @AuraEnabled public String percentageUsed       {get;set;}
        @AuraEnabled public String reportDate           {get;set;}
        @AuraEnabled public String cstName              {get;set;}
        @AuraEnabled public String cstSap               {get;set;}

        @AuraEnabled public String outstandingSummary       {get;set;}
        @AuraEnabled public String X0_30                    {get;set;}
        @AuraEnabled public String X31_60                   {get;set;}
        @AuraEnabled public String X61_75                   {get;set;}
        @AuraEnabled public String X76_90                   {get;set;}
        @AuraEnabled public String X91_120                  {get;set;}
        @AuraEnabled public String X121_150                 {get;set;}
        @AuraEnabled public String X151_180                 {get;set;}
        @AuraEnabled public String X181_210                 {get;set;}
        @AuraEnabled public String X211_Above               {get;set;}
        @AuraEnabled public String Greater90                {get;set;}
        @AuraEnabled public String totalOutstanding         {get;set;}
        @AuraEnabled public String unadjustedReceipts       {get;set;}
        @AuraEnabled public String unadjustedCredits        {get;set;}
        @AuraEnabled public String netOutstanding           {get;set;}
        @AuraEnabled public String currencyKey              {get;set;}
        
        @AuraEnabled public String collection               {get;set;}
        @AuraEnabled public String x1_15                    {get;set;}
        @AuraEnabled public String x16_30                   {get;set;}
        @AuraEnabled public String x61_90                   {get;set;}
        @AuraEnabled public String netOverdue               {get;set;}
        @AuraEnabled public String totalCollectibles        {get;set;}
        @AuraEnabled public String totalCollection          {get;set;}
        @AuraEnabled public String forecastedCollection     {get;set;}
        @AuraEnabled public String nonForecastedCollection  {get;set;}

        @AuraEnabled public String ledgerStatement  {get;set;}
        @AuraEnabled public String docDate          {get;set;}
        @AuraEnabled public String docNumber        {get;set;}
        @AuraEnabled public String docType          {get;set;}
        @AuraEnabled public String docDes           {get;set;}
        @AuraEnabled public String refChqNumber     {get;set;}
        @AuraEnabled public String maturityDate     {get;set;}
        @AuraEnabled public String debit            {get;set;}
        @AuraEnabled public String credit           {get;set;}
        @AuraEnabled public String balance          {get;set;}
        @AuraEnabled public String openingBalance   {get;set;}
        @AuraEnabled public String noData           {get;set;}
        @AuraEnabled public String closingBalance   {get;set;}
        @AuraEnabled public String cstTotal         {get;set;}
        @AuraEnabled public String yy               {get;set;}
        @AuraEnabled public String mm               {get;set;}

        @AuraEnabled public String overdueSummary       {get;set;}
        @AuraEnabled public String getStatement         {get;set;}
        @AuraEnabled public String documentDate         {get;set;}
        @AuraEnabled public String initialDate          {get;set;}
        @AuraEnabled public String finalDate            {get;set;}
        @AuraEnabled public String dueDate              {get;set;}
        @AuraEnabled public String amount               {get;set;}
        @AuraEnabled public String overdue              {get;set;}
        @AuraEnabled public String pt                   {get;set;}
        @AuraEnabled public String total                {get;set;}
        @AuraEnabled public String errorInSap           {get;set;}
        @AuraEnabled public String dataMissingErr       {get;set;}
    }

    public class Grz_CreditSummaryWrapper {
        @AuraEnabled public List< Credit > CreditInfo{get;set;}
    }

    public class Credit {
        @AuraEnabled public String company_code             {get;set;}
        @AuraEnabled public String credit_control           {get;set;}
        @AuraEnabled public String sales_organization       {get;set;}
        @AuraEnabled public String customer_number          {get;set;}
        @AuraEnabled public String clean_limit              {get;set;}
        @AuraEnabled public String Line_limit               {get;set;}
        @AuraEnabled public String Total_receivables        {get;set;}
        @AuraEnabled public String Credit_exposure          {get;set;}
        @AuraEnabled public String ZTOT_LIB_GARANT          {get;set;}
        @AuraEnabled public String Next_internal_review     {get;set;}
        @AuraEnabled public String CreditLimit              {get;set;}
        @AuraEnabled public String CreditExposure           {get;set;}
        @AuraEnabled public String Percentage               {get;set;}
        @AuraEnabled public String BalanceLimit             {get;set;}
    }

    public class Grz_OutstandingWrapper {
        @AuraEnabled public Item item                       {get;set;}
        @AuraEnabled public ReturnData ReturnData           {get;set;}
        @AuraEnabled public String customerNumber           {get;set;}
        @AuraEnabled public String custName                 {get;set;}
        @AuraEnabled public String bucket1                  {get;set;} //X0_30
        @AuraEnabled public String bucket2                  {get;set;} //X31_60
        @AuraEnabled public String bucket3                  {get;set;} //X61_75
        @AuraEnabled public String bucket4                  {get;set;} //X76_90
        @AuraEnabled public String bucket5                  {get;set;} //X91_120
        @AuraEnabled public String bucket6                  {get;set;} //X121_150
        @AuraEnabled public String bucket7                  {get;set;} //X151_180
        @AuraEnabled public String bucket8                  {get;set;} //X181_210
        @AuraEnabled public String bucket9                  {get;set;} //X211_Above
        @AuraEnabled public String greater90                {get;set;}
        @AuraEnabled public String totalOutstanding         {get;set;}
        @AuraEnabled public String unadjustedReceipts       {get;set;}
        @AuraEnabled public String unadjustedCredits        {get;set;}
        @AuraEnabled public String netOutstanding           {get;set;}
        @AuraEnabled public String currencyKey              {get;set;}
    }

    public class Grz_CollectionWrapper {
        @AuraEnabled public List<Item> item                 {get;set;}
        @AuraEnabled public ReturnData ReturnData           {get;set;}
    }

    public class Item {
        @AuraEnabled public String customerNumber           {get;set;}
        @AuraEnabled public String custName                 {get;set;}
        @AuraEnabled public String bucket1                  {get;set;} //X0_30
        @AuraEnabled public String bucket2                  {get;set;} //X31_60
        @AuraEnabled public String bucket3                  {get;set;} //X61_75
        @AuraEnabled public String bucket4                  {get;set;} //X76_90
        @AuraEnabled public String bucket5                  {get;set;} //X91_120
        @AuraEnabled public String bucket6                  {get;set;} //X121_150
        @AuraEnabled public String bucket7                  {get;set;} //X151_180
        @AuraEnabled public String bucket8                  {get;set;} //X181_210
        @AuraEnabled public String bucket9                  {get;set;} //X211_Above
        @AuraEnabled public String greater90                {get;set;}
        @AuraEnabled public String totalOutstanding         {get;set;}
        @AuraEnabled public String unadjustedReceipts       {get;set;}
        @AuraEnabled public String unadjustedCredits        {get;set;}
        @AuraEnabled public String netOutstanding           {get;set;}
        @AuraEnabled public String currencyKey              {get;set;}

        @AuraEnabled public String companyCode                  {get;set;}
        @AuraEnabled public String customer                     {get;set;}
        @AuraEnabled public String x1_15                        {get;set;}
        @AuraEnabled public String x16_30                       {get;set;}
        @AuraEnabled public String x31_60                       {get;set;}
        @AuraEnabled public String x61_90                       {get;set;}
        @AuraEnabled public String x91_120                      {get;set;}
        @AuraEnabled public String netOverdue                   {get;set;}
        @AuraEnabled public String totalCollectibles            {get;set;}
        @AuraEnabled public String totalCollection              {get;set;}
        @AuraEnabled public String fiscalYear                   {get;set;}
        @AuraEnabled public String fiscalPeriod                 {get;set;}
        @AuraEnabled public String desc_z                       {get;set;}
        @AuraEnabled public String forecastedCollection         {get;set;}
        @AuraEnabled public String nonForecastedCollection      {get;set;}
    }

    public class Grz_LedgerWrapper {
        @AuraEnabled public CustomerInfo customerInfo   {get;set;}
        @AuraEnabled public List<ItemInfo> ItemInfo     {get;set;}
    }
    public class ItemInfo {
        @AuraEnabled public String AccountingDocNumber      {get;set;}
        @AuraEnabled public String Credit                   {get;set;}
        @AuraEnabled public String Debit                    {get;set;}
        @AuraEnabled public String DocType                  {get;set;}
        @AuraEnabled public String docDes                   {get;set;}
        @AuraEnabled public String DocumentHeaderText       {get;set;}
        @AuraEnabled public String PostDate                 {get;set;}
        @AuraEnabled public String ReferebceChqNumber       {get;set;}
        @AuraEnabled public String RunningBalance           {get;set;}
        @AuraEnabled public String SGTXT                    {get;set;}
        @AuraEnabled public String ClearingDoc              {get;set;}
        @AuraEnabled public String BlineDate                {get;set;}
        @AuraEnabled public String DsctDays1                {get;set;}
        @AuraEnabled public String DueDate                  {get;set;}
    }
    
    public class CustomerInfo {
        @AuraEnabled public String City                     {get;set;}
        @AuraEnabled public String ClosingBalance           {get;set;}
        @AuraEnabled public String CustomerCode             {get;set;}
        @AuraEnabled public String CustomerName             {get;set;}
        @AuraEnabled public String GlAccountNumber          {get;set;}
        @AuraEnabled public String GlAccountLongText        {get;set;}
        @AuraEnabled public String SalesOffice              {get;set;}
        @AuraEnabled public String OpeningBalance           {get;set;}
    }

    public class Grz_OverdueWrapper{
        @AuraEnabled public List<Lineitems> Lineitems   {get;set;}
        @AuraEnabled public ReturnData ReturnData       {get;set;}
    }

    public class Lineitems {
        @AuraEnabled public String DocNo        {get;set;}
        @AuraEnabled public String DocDate      {get;set;}
        @AuraEnabled public String AmtDoccur    {get;set;}
        @AuraEnabled public String DsctDays1    {get;set;}
        @AuraEnabled public String BlineDate    {get;set;}
        @AuraEnabled public String CompCode     {get;set;}
        @AuraEnabled public String Customer     {get;set;}
        @AuraEnabled public String DocType      {get;set;}
        @AuraEnabled public String docDes       {get;set;}
        @AuraEnabled public String DueDate      {get;set;}
        @AuraEnabled public String DbCrInd      {get;set;}
        @AuraEnabled public boolean overDued    {get;set;}
        @AuraEnabled public String salesOrderLink    {get;set;}
        @AuraEnabled public String salesOrder    {get;set;}
    }
}