@isTest
public class BrazilPushContractService_Test {

 static testMethod void testParse() {
		String json=		'{'+
		'  "ImportHeaders": {'+
		'    "CONTRACT_HEADER_IN": {'+
		'      "SAP_USER": "20004518",'+
		'      "DOC_TYPE": "ZMAE",'+
		'      "SALES_ORG": 5191,'+
		'      "DISTR_CHAN": 20,'+
		'      "DIVISION": 10,'+
		'      "SALES_OFF": "BR20",'+
		'      "PURCH_DATE": "2017-06-22",'+
		'      "REF_1": "1218",'+
		'      "SALES_DIST": "BR2006",'+
		'      "INCOTERMS1": "FOB",'+
		'      "INCOTERMS2": ".",'+
		'      "PMNTTRMS": "BW00",'+
		'      "CT_VALID_F": "2017-06-23",'+
		'      "CT_VALID_T": "2018-03-31",'+
		'      "CUST_GRP1": "229",'+
		'      "CUST_GRP2": "BR2",'+
		'      "PURCH_NO_C": "22062017",'+
		'      "SD_DOC_CAT": "G",'+
		'      "DOC_DATE": "2017-09-25",'+
		'      "PYMT_METH": "Q",'+
		'      "CURRENCY_VALUE": "BRL",'+
		'      "FIX_VAL_DY": "2018-03-20"'+
		'    }'+
		'  },'+
		'  "Tables": {'+
		'    "CONTRACT_CONDITIONS_IN": {'+
		'      "row_conditions": ['+
		'        {'+
		'          "ITM_NUMBER": "000000",'+
		'          "COND_TYPE": "ZBRD",'+
		'          "COND_VALUE": "0.000000000",'+
		'          "CURRENCY_VALUE": "USD"'+
		'        },'+
		'        {'+
		'          "ITM_NUMBER": "10",'+
		'          "COND_TYPE": "ZBR0",'+
		'          "COND_VALUE": "500.000000000",'+
		'          "CURRENCY_VALUE": "USD"'+
		'        }'+
		'      ]'+
		'    },'+
		'    "CONTRACT_ITEMS_IN": {'+
		'      "row_items": ['+
		'        {'+
		'          "ITM_NUMBER": "10",'+
		'          "MATERIAL": "000000000006250007",'+
		'          "BILL_DATE": "2017-06-30",'+
		'          "PLANT": "BR05",'+
		'          "TARGET_QTY": 555,'+
		'          "TARGET_QU": "L",'+
		'          "PO_DAT_S": "2017-06-30",'+
		'          "USAGE_IND": "B15",'+
        '          "HG_LV_ITEM": "1",'+
        '          "ITEM_CATEG": "ZTPC"'+
		'        }'+
		'      ]'+
		'    },'+
		'    "CONTRACT_PARTNERS": {'+
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
		'    "CONTRACT_TEXT": {'+
		'      "row_text": ['+
		'        {'+
		'          "ITM_NUMBER": "000000",'+
		'          "TEXT_ID": "0001",'+
		'          "LANGU": "P",'+
		'          "TEXT_LINE": "Test data"'+
		'        }'+
		'      ]'+
		'    }'+
		'  }'+
		'}'+
		'';
		BrazilPushContractService obj = BrazilPushContractService.parse(json);
		System.assert(obj != null);
	}
}