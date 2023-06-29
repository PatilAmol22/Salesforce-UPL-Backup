public class Grz_BeeTrackResponse {

    public class DispatchCreate{
        public String resource {get;set;}
        public String event {get;set;}
        public String account_name {get;set;}
        public DispatchGuide dispatch_guide {get;set;}
        public List<Items> items {get;set;}
    }
    public class DispatchGuide {
		public String identifier {get;set;}	//106927
		public String contact_name {get;set;}	//ARENA FERTILIZANTES SEMILLAS DIST L
		public String contact_email {get;set;}	//jrojas@arenafertilizantes.cl
		public String contact_address {get;set;}	//LOTE 1 A DE LA HIJUELA 1, LAS TORCAZAS, PANQUEHUE,MALLOA
	}
    public class Items {
		public Integer id {get;set;}	//506038960
		public String name {get;set;}	//BIOTRON PLUS (12X1 L)_CHI
		public Integer quantity {get;set;}	//60
		public Integer original_quantity {get;set;}	//60
		public Integer delivered_quantity {get;set;}	//0
		public String code {get;set;}	//6031298
	}
    
    public class DispatchUpdate{
        public String resource {get;set;}	//dispatch
        public String event {get;set;}	//update
        public String identifier {get;set;}	//106927
        public Integer dispatch_id {get;set;}	//331426125
        public String truck_identifier {get;set;}	//SAYMO05
        public Integer status {get;set;}	//2
        public String substatus {get;set;}	//Entrega Exitosa
        public String substatus_code {get;set;}	//
        public String estimated_at {get;set;}	//2021-11-26T16:17:39.000-03:00
        public String arrived_at {get;set;}	//2021-11-26 15:37:57-0300
        public List<Items> items {get;set;}
        public List<EvaluationAnswers> evaluation_answers {get;set;}
    }

    public class EvaluationAnswers {
		public String cast_z {get;set;}	//photo
		public String name {get;set;}	//Foto de la guía firmada
		public String value {get;set;} //https://cdn.beetrack.com/mobile_evaluations/images/IMG_20211126_153744_5303840591463438008.jpg
    }
}