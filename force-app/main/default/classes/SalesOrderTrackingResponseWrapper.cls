public class SalesOrderTrackingResponseWrapper {
    
    public string status;
    public string creditStatus;
    public string dateOfCreditStatusChange;
    public string invoiceStatus;
    public string invoiceDate;
    public string STSENT;
    public list<SalesOrderTrackingMaterial> materials;
    public list<SalesOrderTrackingInvoices> invoices;
    public list<SalesOrderTrackingSalesOrders> salesOrders;

}