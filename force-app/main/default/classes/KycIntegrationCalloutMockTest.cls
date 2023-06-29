@isTest
global class KycIntegrationCalloutMockTest implements HttpCalloutMock{
    String recName='';
    public  KycIntegrationCalloutMockTest(String recordName){
        recName=recordName;
    }
    global HttpResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse();
        res.setStatus('OK');
        res.setStatusCode(200);
        if(recName=='MatchName101'){
            res.setBody('{ "statusCode": 101, "requestId": "e8f71f83-606a-11e9-b25d-df5cca37fd9c", "result": { "score": 0.7530555555555556, "result": true } }');
        }
        if(recName=='MatchName500'){
            res.setBody('{ "status": 400, "error": "Bad Request", "request_id": "73cdbde2-80f7-11e7-8f0c-e7e769f70bd1" }');
        }
        if(recName=='MatchNameNULL'){
            res.setBody('{ "statusCode": 102, "requestId": "e8f71f83-606a-11e9-b25d-df5cca37fd9c", "result": { "score": 0.7530555555555556, "result": true } }');
        }
        if(recName=='Email101'){
            res.setBody('{ "request_id": "019e8dd2-f2d8-42c5-99ea-32ea9d13641b", "result": { "data": { "accept_all": true, "disposable": false, "email": "sharma@shikha.com", "mx_records": true, "regexp": true, "result": "accept-all", "smtp_check": true, "webmail": false }, "meta": { "params": { "email": "sharma@shikha.com" } } }, "status-code": "101" }');
        }
        if(recName=='Email500'){
            res.setBody('{ "status": 400, "error": "Bad Request", "request_id": "73cdbde2-80f7-11e7-8f0c-e7e769f70bd1" }');
        }
        if(recName=='EmailNULL'){
            res.setBody('{ "request_id": "019e8dd2-f2d8-42c5-99ea-32ea9d13641b", "result": { "data": { "accept_all": true, "disposable": false, "email": "", "mx_records": false, "regexp": false, "result": "accept-all", "smtp_check": true, "webmail": false }, "meta": { "params": { "email": "sharma@shikha.com" } } }, "status-code": "102" }');
        }
        if(recName=='PAN101'){
            res.setBody('{"result": {"name": "SANDIP TABAJI ATKARI"}, "request_id": "a924ba4c-811a-11e9-b9e9-775b828524a3", "status-code": "101"}');
        }
        if(recName=='PAN500'){
            res.setBody('{ "status": 400, "error": "Bad Request", "request_id": "73cdbde2-80f7-11e7-8f0c-e7e769f70bd1" }');
        }
        if(recName=='PANNULL'){
            res.setBody('{"result": {"name": ""}, "request_id": "a924ba4c-811a-11e9-b9e9-775b828524a3", "status-code": "102"}');
        }
        if(recName=='DL101'){
            res.setBody('{ "status-code": 101, "request_id": "73cdbde2-80f7-11e7-8f0c-e7e769f70bd1", "result": { "name": "GAURAV SAMDARIA", "dob": "12-06-1987", "img": "", "issue_date": "15-07-2005", "blood_group": "", "father/husband": "VIJAI RAJ SAMDARIA", "address": "1302 13 TH FLOOR, ORCHID 18, B.G.KHER ROAD, WORLI NAKA MUMBAI. 400018", "cov_details": [ { "issue_date": "15-07-2005", "cov": "LMV" } ], "validity": { "non-transport": "15-07-2005 to 14-07-2025", "transport": "" } } }');
        }
        if(recName=='DL500'){
            res.setBody('{ "status": 400, "error": "Bad Request", "request_id": "73cdbde2-80f7-11e7-8f0c-e7e769f70bd1" }');
        }
        if(recName=='DLNULL'){
            res.setBody('{ "status-code": 102, "request_id": "73cdbde2-80f7-11e7-8f0c-e7e769f70bd1", "result": { "name": "", "dob": "12-06-1987", "img": "", "issue_date": "15-07-2005", "blood_group": "", "father/husband": "VIJAI RAJ SAMDARIA", "address": "1302 13 TH FLOOR, ORCHID 18, B.G.KHER ROAD, WORLI NAKA MUMBAI. 400018", "cov_details": [ { "issue_date": "15-07-2005", "cov": "LMV" } ], "validity": { "non-transport": "15-07-2005 to 14-07-2025", "transport": "" } } }');
        }
        if(recName=='VoterID101'){
            res.setBody('{ "status-code": 101, "request_id": "73cdbde2-80f7-11e7-8f0c-e7e769f70bd1", "result": { "ps_lat_long": "20.41020100,77.59604900", "rln_name_v1": "मिलींद भगत", "rln_name_v2": "", "rln_name_v3": "", "part_no": "112", "rln_type": "F", "section_no": "1", "id": "S130790112010120", "name_v1": "सुष्मामिलींद भगत", "rln_name": "Milind Bhagat", "district": "Yavatmal", "last_update": "Tue Nov 15 23:50:58 IST 2016", "state": "Maharashtra", "ac_no": "79", "house_no": "28 1", "ps_name": "G. P. U. Pra. Shalechi Imarat Kholi Kran. 1 Savangi Re. ", "pc_name": "Yavatmal-Washim", "slno_inpart": "120", "name": "Sushama Bhagat", "part_name": "Sanvagi Re.", "st_code": "S13", "gender": "F", "age": 30, "ac_name": "Digras", "epic_no": "UDH5469028", "name_v3": "", "name_v2": "", "dob": "" } }');
        }
        if(recName=='VoterID500'){
            res.setBody('{ "status": 400, "error": "Bad Request", "request_id": "73cdbde2-80f7-11e7-8f0c-e7e769f70bd1" }');
        }
        if(recName=='VoterIDNULL'){
            res.setBody('{ "status-code": 102, "request_id": "73cdbde2-80f7-11e7-8f0c-e7e769f70bd1", "result": { "ps_lat_long": "", "rln_name_v1": "", "rln_name_v2": "", "rln_name_v3": "", "part_no": "112", "rln_type": "F", "section_no": "1", "id": "S130790112010120", "name_v1": "सुष्मामिलींद भगत", "rln_name": "Milind Bhagat", "district": "Yavatmal", "last_update": "Tue Nov 15 23:50:58 IST 2016", "state": "Maharashtra", "ac_no": "79", "house_no": "28 1", "ps_name": "G. P. U. Pra. Shalechi Imarat Kholi Kran. 1 Savangi Re. ", "pc_name": "Yavatmal-Washim", "slno_inpart": "120", "name": "Sushama Bhagat", "part_name": "Sanvagi Re.", "st_code": "S13", "gender": "F", "age": 30, "ac_name": "Digras", "epic_no": "UDH5469028", "name_v3": "", "name_v2": "", "dob": "" } }');
        }
        if(recName=='Fssai101'){
            res.setBody('{ "status-code": 101, "request_id": "73cdbde2-80f7-11e7-8f0c-e7e769f70bd1", "result": { "Status": "Active", "LicType": "Central License", "LicNO": "10013022002245", "FirmName": "PARLE PRODUCTS PVT. LTD.", "Address": "PARLE PRODUCTS PVT LTD NORTH LEVEL CROSSING VILE PARLE E District - Mumbai Suburban STATE - Maharashtra" } }');
        }
        if(recName=='Fssai500'){
            res.setBody('{ "status": 400, "error": "Bad Request", "request_id": "73cdbde2-80f7-11e7-8f0c-e7e769f70bd1" }');
        }
        if(recName=='FssaiNULL'){
            res.setBody('{ "status-code": 102, "request_id": "73cdbde2-80f7-11e7-8f0c-e7e769f70bd1", "result": { "Status": "", "LicType": "", "LicNO": "10013022002245", "FirmName": "PARLE PRODUCTS PVT. LTD.", "Address": "PARLE PRODUCTS PVT LTD NORTH LEVEL CROSSING VILE PARLE E District - Mumbai Suburban STATE - Maharashtra" } }');
        }
        if(recName=='BA101'){
            res.setBody('{ "status-code": "101", "request_id": "1e5a875e-e590-11e7-a842-373db1bff361", "result": { "bankTxnStatus": true, "accountNumber": "32XXXXXXXXX", "ifsc": "SBINXXXXX", "accountName": "Mr MD ZAFAR EQUBAL", "bankResponse": "Transaction Successful" } }');
        }
        if(recName=='BA500'){
            res.setBody('{ "status": 400, "error": "Bad Request", "request_id": "73cdbde2-80f7-11e7-8f0c-e7e769f70bd1" }');
        }
        if(recName=='BANULL'){
            res.setBody('{ "status-code": "102", "request_id": "1e5a875e-e590-11e7-a842-373db1bff361", "result": { "bankTxnStatus": true, "accountNumber": "32XXXXXXXXX", "ifsc": "SBINXXXXX", "accountName": "Mr MD ZAFAR EQUBAL", "bankResponse": "Transaction Successful" } }');
        }
        if(recName=='FDA101'){
            res.setBody('{ "status-code": "101", "request_id": "9632bba5-2479-11e8-bf84-4dc40ec92773", "result": { "store_name": "PRUTHVI CHEMIST. (R)", "contact_number": "9624793926", "license_detail": "20 - 75202 (04/03/2008 - 04/03/2013 - 03/03/2018)", "name": "Shri Giris", "address": "plot no. 12,valam nagar society, simada gam,, surat." } }');
        }
        if(recName=='FDA500'){
            res.setBody('{ "status": 400, "error": "Bad Request", "request_id": "73cdbde2-80f7-11e7-8f0c-e7e769f70bd1" }');
        }
        if(recName=='FDANULL'){
            res.setBody('{ "status-code": "102", "request_id": "9632bba5-2479-11e8-bf84-4dc40ec92773", "result": { "store_name": "PRUTHVI CHEMIST. (R)", "contact_number": "9624793926", "license_detail": "20 - 75202 (04/03/2008 - 04/03/2013 - 03/03/2018)", "name": "Shri Giris", "address": "plot no. 12,valam nagar society, simada gam,, surat." } }');
        }
        if(recName=='Gst101'){
            res.setBody('{ "statusCode": 101, "requestId": "c77c8741-208f-11e9-9fb6-f954fdad8f0c", "result": { "mbr": [], "canFlag": "NA", "pradr": { "em": "", "adr": "Reliance Corporate Park, 5, 5, TTC Industrial Area, Thane Belapur Road, Ghansoli, Navi Mumbai, Maharashtra, pin: 400701", "addr": "NA", "mb": "", "ntr": "Factory / Manufacturing, Retail Business, Input Service Distributor (ISD), Bonded Warehouse, SEZ, Works Contract, Warehouse / Depot, Service Provision, Leasing Business, Office / Sale Office, Recipient of Goods or Services, Wholesale Business, EOU / STP / EHTP", "lastUpdatedDate": "NA" }, "tradeNam": "RELIANCE INDUSTRIES LIMITED", "lstupdt": "26/09/2018", "contacted": {}, "rgdt": "01/07/2017", "stjCd": "MH018", "stj": "MUMBAI-LTU-1", "ctjCd": "VU0404", "ppr": "NA", "dty": "Regular", "cmpRt": "NA", "cxdt": "", "ctb": "Public Limited Company", "sts": "Active", "gstin": "27AAACR5055K1Z7", "lgnm": "RELIANCE INDUSTRIES LIMITED", "nba": [ "Factory / Manufacturing", "Retail Business", "Input Service Distributor (ISD)", "Bonded Warehouse", "SEZ", "Works Contract", "Warehouse / Depot", "Service Provision", "Leasing Business", "Office / Sale Office", "Recipient of Goods or Services", "Wholesale Business", "EOU / STP / EHTP", "Supplier of Services", "Others", "Export" ], "ctj": "RANGE-IV", "adadr": [ { "em": "", "adr": "MAKER CHAMBERS, IV, , NARIMAN POINT, MUMBAI, Maharashtra, pin: 400021", "addr": "NA", "mb": "", "ntr": "Factory / Manufacturing, Retail Business, Input Service Distributor (ISD), Bonded Warehouse, SEZ, Works Contract, Warehouse / Depot, Service Provision, Leasing Business, Office / Sale Office, Recipient of Goods or Services, Wholesale Business, EOU / STP / EHTP", "lastUpdatedDate": "NA" } ] } }');
        }
        if(recName=='Gst500'){
            res.setBody('{ "status": 400, "error": "Bad Request", "request_id": "73cdbde2-80f7-11e7-8f0c-e7e769f70bd1" }');
        }
        if(recName=='GstNULL'){
            res.setBody('{ "statusCode": 102, "requestId": "c77c8741-208f-11e9-9fb6-f954fdad8f0c", "result": { "mbr": [], "canFlag": "NA", "pradr": { "em": "", "adr": "Reliance Corporate Park, 5, 5, TTC Industrial Area, Thane Belapur Road, Ghansoli, Navi Mumbai, Maharashtra, pin: 400701", "addr": "NA", "mb": "", "ntr": "Factory / Manufacturing, Retail Business, Input Service Distributor (ISD), Bonded Warehouse, SEZ, Works Contract, Warehouse / Depot, Service Provision, Leasing Business, Office / Sale Office, Recipient of Goods or Services, Wholesale Business, EOU / STP / EHTP", "lastUpdatedDate": "NA" }, "tradeNam": "RELIANCE INDUSTRIES LIMITED", "lstupdt": "26/09/2018", "contacted": {}, "rgdt": "01/07/2017", "stjCd": "MH018", "stj": "MUMBAI-LTU-1", "ctjCd": "VU0404", "ppr": "NA", "dty": "Regular", "cmpRt": "NA", "cxdt": "", "ctb": "Public Limited Company", "sts": "Active", "gstin": "27AAACR5055K1Z7", "lgnm": "RELIANCE INDUSTRIES LIMITED", "nba": [ "Factory / Manufacturing", "Retail Business", "Input Service Distributor (ISD)", "Bonded Warehouse", "SEZ", "Works Contract", "Warehouse / Depot", "Service Provision", "Leasing Business", "Office / Sale Office", "Recipient of Goods or Services", "Wholesale Business", "EOU / STP / EHTP", "Supplier of Services", "Others", "Export" ], "ctj": "RANGE-IV", "adadr": [ { "em": "", "adr": "MAKER CHAMBERS, IV, , NARIMAN POINT, MUMBAI, Maharashtra, pin: 400021", "addr": "NA", "mb": "", "ntr": "Factory / Manufacturing, Retail Business, Input Service Distributor (ISD), Bonded Warehouse, SEZ, Works Contract, Warehouse / Depot, Service Provision, Leasing Business, Office / Sale Office, Recipient of Goods or Services, Wholesale Business, EOU / STP / EHTP", "lastUpdatedDate": "NA" } ] } }');
        }
        if(recName=='Ocr101'){
            res.setBody('{"statusCode":101,"requestId":"a0e637e0-8299-11e9-924e-bf1910b188c0","result":[{"type":"Passport Front","details":{"doi":{"value":"11/10/2011"},"surname":{"value":"RAMADUGULA"},"countryCode":{"value":"IND"},"mrz":{"line2":"J8369854<4IND5909234F2110101<<<<<<<<<<<<<<<8","line1":"P<INDRAMADUGULA<<SITA<MAHA<LAKSHMI<<<<<<<<<<"},"dob":{"value":"23/09/1959"},"gender":{"value":"FEMALE"},"doe":{"value":"10/10/2021"},"placeOfIssue":{"value":"HYDERABAD"},"placeOfBirth":{"value":"GUNDUGOLANU"},"nationality":{"value":"INDIAN"},"givenName":{"value":"SITA MAHA LAKSHMI"},"type":{"value":"P"},"passportNum":{"value":"J8369854"}}}]}');
        }
        if(recName=='Ocr500'){
            res.setBody('{ "status": 400, "error": "Bad Request", "request_id": "73cdbde2-80f7-11e7-8f0c-e7e769f70bd1" }');
        }
        if(recName=='OcrNULL'){
            res.setBody('{"statusCode":102,"requestId":"a0e637e0-8299-11e9-924e-bf1910b188c0","result":[{"type":"Passport Front","details":{"doi":{"value":"11/10/2011"},"surname":{"value":"RAMADUGULA"},"countryCode":{"value":"IND"},"mrz":{"line2":"J8369854<4IND5909234F2110101<<<<<<<<<<<<<<<8","line1":"P<INDRAMADUGULA<<SITA<MAHA<LAKSHMI<<<<<<<<<<"},"dob":{"value":"23/09/1959"},"gender":{"value":"FEMALE"},"doe":{"value":"10/10/2021"},"placeOfIssue":{"value":"HYDERABAD"},"placeOfBirth":{"value":"GUNDUGOLANU"},"nationality":{"value":"INDIAN"},"givenName":{"value":"SITA MAHA LAKSHMI"},"type":{"value":"P"},"passportNum":{"value":"J8369854"}}}]}');
        }
        return res;
    }
}