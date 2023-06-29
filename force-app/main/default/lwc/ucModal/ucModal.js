import {LightningElement, track, api} from 'lwc';

export default class ucModal extends LightningElement {

    @api name;
    @api showFooter = false;
    @api width;
    @api height;
    @api availableReactions;
    @api cancelReactions;


    @track showModal = false;
    @track isConfirmModalOpen=false;
    @api confirmationMessage;

    @api openModal(selectedRows) {
        this.showModal = true;
        console.log('open modal received selectedRows of: ' + JSON.stringify(selectedRows));
        
    }

    get containerStyle() {
        let style = '';
        if (this.width) {
            style += 'width: ' + this.width + '; max-width: ' + this.width
        }else{
            style='max-width: 90%';
        }
        return style;
    }

    get bodyStyle() {
        let style = '';
        if (this.height) {
            style += 'height: ' + this.height;
        }
        return style;
    }

    handleReactionButtonClick(event) {
        let reactionValue = event.currentTarget.dataset.value;
        if(this.confirmationMessage==undefined){
            this.confirmationMessage='Are you sure you want to approve records?';
        }
        this.isConfirmModalOpen=true;
    }

    handleReactionCancelButtonClick(event){
        this.closeModal();
    }

    submitDetails(event){
        let reactionValue = event.currentTarget.dataset.value;
        if (reactionValue) {
            this.dispatchReactionEvent(reactionValue);
        }
        this.closeModal();
    }

    closeConfirmModal(event){
        this.isConfirmModalOpen=false;
    }
    
    dispatchReactionEvent(reaction) {
        const memberRefreshedEvt = new CustomEvent('reaction', {
            bubbles: true,
            detail: {
                name: this.name,
                value: reaction
            }
        });
        this.dispatchEvent(memberRefreshedEvt);
    }

    @api
    closeModal(event) {
        this.showModal = false;
    }

}