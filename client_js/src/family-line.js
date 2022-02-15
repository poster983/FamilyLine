import {LitElement, html} from 'lit';




class FamilyLine extends LitElement {

    firstUpdated() {
        

    }

    render() {
        return html`
        <!-- Nav Goes Here -->
        <nav>
            <a href="/">Home</a>
            <a href="/account">Account</a>
            <a href="/beings/147">Beings</a>
        </nav>
        <!-- Routed Page -->
        <slot></slot>

        `;
    }
}
customElements.define('family-line', FamilyLine);