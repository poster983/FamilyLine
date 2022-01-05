import {LitElement, html} from 'lit';


class BeingsPage extends LitElement {



    static properties = {
        location: {type: Object, reflect: true}
    }

    render() {
        console.log(this.location)
        return html`
        
            <h1>Page for Beings</h1>
            <p></p>

            
        `;
    }
}
customElements.define('beings-page', BeingsPage);