@isTest
public class BrazilPushMaefilService_Test {
	static testMethod void testParse() {
		String json=		'{'+
		'  "ImportHeaders": {'+
		'    "ORDER_HEADER_IN": {'+
		'      "SAP_USER":"20004518",'+
		'      "DOC_TYPE": "ZFIL",'+
		'      "SALES_ORG": 5191,'+
		'      "DISTR_CHAN": 20,'+
		'      "DIVISION": 10,'+
		'      "SALES_OFF": "BR20",'+
		'      "PURCH_DATE": "2017-10-26",'+
		'      "REF_1": "000000025939",'+
		'      "SALES_DIST": "BR2006",'+
		'      "INCOTERMS1": "CIF",'+
		'      "INCOTERMS2": ".",'+
		'      "PMNTTRMS": "0103",'+
		'      "CT_VALID_F": "2017-10-26",'+
		'      "CT_VALID_T": "2018-03-31",'+
		'      "CUST_GRP1": "229",'+
		'      "CUST_GRP2": "BR2",'+
		'      "PURCH_NO_C": "234523465",'+
		'      "SD_DOC_CAT": "C",'+
		'      "DOC_DATE": "2017-10-26",'+
		'      "REF_DOC": "7009090361",'+
		'      "REFDOC_CAT": "G",'+
		'      "FIX_VAL_DY":"2018-03-20",'+
		'      "PYMT_METH": "Y",'+
		'      "CURRENCY_VALUE": "BRL"'+
		'    }'+
		'  },'+
		'  "Tables": {'+
		'    "ORDER_CONDITIONS_IN": {'+
		'      "row_conditions": ['+
		'        {'+
		'          "ITM_NUMBER": "000000",'+
		'          "COND_TYPE": "ZBRD",'+
		'          "COND_VALUE": "0.000000000",'+
		'          "CURRENCY_VALUE": "BRL"'+
		'        },'+
		'        {'+
		'          "ITM_NUMBER": "000010",'+
		'          "COND_TYPE": "ZBR0",'+
		'          "COND_VALUE": "1000.000000000",'+
		'          "CURRENCY_VALUE": "BRL"'+
		'        }'+
		'      ]'+
		'    },'+
		'    "ORDER_ITEMS_IN": {'+
		'      "row_items": ['+
		'        {'+
		'          "ITM_NUMBER": "000010",'+
		'          "MATERIAL": "000000000006250007",'+
		'          "BILL_DATE": "2017-10-27",'+
		'          "PLANT": "BR05",'+
		'          "TARGET_QTY": 30.000,'+
		'          "TARGET_QU": "L",'+
		'          "PO_DAT_S":"2017-10-27",'+
		'          "USAGE_IND": "B10",'+
		'          "REF_DOC": "7009090361",'+
		'          "REF_DOC_IT" :"000010",'+
		'          "REF_DOC_CA": "G",'+
        '          "HG_LV_ITEM": "1",'+
        '          "ITEM_CATEG": "ZTPC"'+
		'        }'+
		'      ]'+
		'    },'+
		'    "ORDER_PARTNERS": {'+
		'      "row_partners": ['+
		'        {'+
		'          "PARTN_ROLE": "AG",'+
		'          "PARTN_NUMB": "0001033738"'+
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
		'          "TEXT_ID":"0001",'+
		'          "LANGU":"P",'+
		'          "TEXT_LINE": "ajbbja"'+
		'      }]'+
		'    }'+
		'  }'+
		'}'+
		'';
		BrazilPushMaefilService obj = BrazilPushMaefilService.parse(json);
		System.assert(obj != null);
	}
}