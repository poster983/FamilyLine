import {LitElement, html} from 'lit';


class AccountPage extends LitElement {



    static properties = {
        location: {type: Object}
    }

    render() {
        console.log(this.location)
        return html`
        
            <h1>Page for account</h1>
            <p></p>

            
        `;
    }
}
customElements.define('account-page', AccountPage);