public class OfflineLineItem {
    public String product_id;
    public String pack_Size;
    public String sku_name;
    public String sku_qty;
    public String product_name;
    public String product_image;
    public String sku_id;
    public String no_case_size;
    
    public static List<OfflineLineItem> parse(String json) {
        return (List<OfflineLineItem>) System.JSON.deserialize(json, List<OfflineLineItem>.class);
    }
}