public class XMLParser {
/* 
Developer Name : Pranav Dinakaran
Description : Used to parse XMl format which is returned as response in sharepoint integration
Test Class : USSharePointFileTransferTest;
*/  
    // Recursively walk through the XML
    public static String walkThrough2(DOM.XMLNode node, String nodeName) {
        String result = '\n';
        System.debug('node Name: '+node.getName().trim());

        if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
            //result += 'Element: ' + node.getName();
            if (node.getText().trim() != '' && node.getName() == nodeName) {
                result = node.getText().trim();
                System.debug('node Text: '+node.getText().trim());
            }
            for (Dom.XMLNode child: node.getChildElements()) {
                result = walkThrough2(child,nodeName);
                if(String.isNotBlank(result))
                    break;
            }
            return result;
        }
        return '';  //should never reach here
        
    }
    
}