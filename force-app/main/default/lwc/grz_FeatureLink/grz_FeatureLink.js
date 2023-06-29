import { LightningElement, track, wire } from "lwc";
import customStyle from "@salesforce/resourceUrl/Grz_Resourse";
import getFeatureLinksList from '@salesforce/apex/Grz_FeatureLinksController.getFeatureLinksList';
import featurelink from "@salesforce/label/c.Grz_FeatureLink";
import LANG from "@salesforce/i18n/lang";
export default class Grz_FeatureLink extends LightningElement {
@track language = LANG;
@track tabData;
@track customLabel;
@track urlname;
@track data;
@track isBr=false;

label = {
featurelink
};
Logo = customStyle + "/Grz_Resourse/Images/FLIcon.png";

@wire(getFeatureLinksList, { language: "$language" })
featureLinksLists(results) {
if (results.data) {
if (this.language == "pt-BR") {
this.isBr = true;
}else{
this.isBr = false;
}
this.data = results.data;
console.log('aashima data==>',this.data);
}
else if (results.error) {
this.error = results.error;
console.log('aashima error==>',this.error);

}
console.log('aashima language==>',this.language);
}
}