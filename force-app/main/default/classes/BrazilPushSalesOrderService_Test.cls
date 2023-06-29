@isTest
public class BrazilPushSalesOrderService_Test {
    
	static testMethod void testParse() {
		String json=		'{'+
		'  "ImportHeaders": {'+
		'    "ORDER_HEADER_IN": {'+
		'      "SAP_USER":"20004518",'+
		'      "DOC_TYPE": "ZORB",'+
		'      "SALES_ORG": 5191,'+
		'      "DISTR_CHAN": 20,'+
		'      "DIVISION": 10,'+
		'      "SALES_OFF": "BR20",'+
		'      "PURCH_DATE": "2017-06-21",'+
		'      "REF_1": "000000025886",'+
		'      "SALES_DIST": "BR2006",'+
		'      "INCOTERMS1": "CFR",'+
		'      "INCOTERMS2": ".",'+
		'      "PMNTTRMS": "0014",'+
		'      "CT_VALID_F": "2017-06-22",'+
		'      "CT_VALID_T": "2018-03-31",'+
		'      "CUST_GRP1": "229",'+
		'      "CUST_GRP2": "BR2",'+
		'      "PURCH_NO_C": "899990",'+
		'      "SD_DOC_CAT": "C",'+
		'      "DOC_DATE": "2017-09-25",'+
		'      "PYMT_METH": "Q",'+
		'      "CURRENCY_VALUE": "BRL",'+
		'      "FIX_VAL_DY": "2018-03-20"'+
		'    }'+
		'  },'+
		'  "Tables": {'+
		'    "ORDER_CONDITIONS_IN": {'+
		'      "row_conditions": ['+
		'        {'+
		'          "ITM_NUMBER": "000000",'+
		'          "COND_TYPE": "ZBRD",'+
		'          "COND_VALUE": "0.000000000",'+
		'          "CURRENCY_VALUE": "USD"'+
		'        },'+
		'        {'+
		'          "ITM_NUMBER": "000010",'+
		'          "COND_TYPE": "ZBR0",'+
		'          "COND_VALUE": "100.000000000",'+
		'          "CURRENCY_VALUE": "USD"'+
		'        }'+
		'      ]'+
		'    },'+
		'    "ORDER_ITEMS_IN": {'+
		'      "row_items": ['+
		'        {'+
		'          "ITM_NUMBER": "000010",'+
		'          "MATERIAL": "000000000006250007",'+
		'          "BILL_DATE": "2017-06-27",'+
		'          "PLANT": "BR05",'+
		'          "TARGET_QTY": 90,'+
		'          "TARGET_QU": "L",'+
		'          "PO_DAT_S": "2017-06-27",'+
		'          "USAGE_IND": "B01",'+
        '          "HG_LV_ITEM": "1",'+
        '          "ITEM_CATEG": "ZTPC"'+
		'        }'+
		'      ]'+
		'    },'+
		'    "ORDER_PARTNERS": {'+
		'      "row_partners": ['+
		'        {'+
		'          "PARTN_ROLE": "AG",'+
		'          "PARTN_NUMB": "0001033267"'+
		'        },'+
		'        {'+
		'          "PARTN_ROLE": "Z1",'+
		'          "PARTN_NUMB": "57000448"'+
		'        }'+
		'      ]'+
		'    },'+
		'    "ORDER_TEXT":{'+
		'      "row_text":[{'+
		'        "ITM_NUMBER":"000000",'+
		'        "TEXT_ID":"0001",'+
		'        "LANGU":"P",'+
		'         "TEXT_LINE":"xyz"'+
		'      }]'+
		'    }'+
		'  }'+
		'}'+
		'';
		BrazilPushSalesOrderService obj = BrazilPushSalesOrderService.parse(json);
		System.assert(obj != null);
	}
}