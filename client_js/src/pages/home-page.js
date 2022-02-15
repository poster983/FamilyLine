import {LitElement, html} from 'lit';
import "../components/fam-media-grid-item.js"
import "../components/fam-media-grid.js"

class HomePage extends LitElement {



    

    render() {
        return html`
        <fam-media-grid>
            <fam-media-grid-item type="image" src="https://picsum.photos/200/300"></fam-media-grid-item>
            <fam-media-grid-item type="image" src="https://picsum.photos/1920/1080"></fam-media-grid-item>
            <fam-media-grid-item type="image" src="https://picsum.photos/1080/1920"></fam-media-grid-item>
            <fam-media-grid-item type="image" src="https://picsum.photos/720/360"></fam-media-grid-item>
            <fam-media-grid-item type="image" src="https://picsum.photos/400/300"></fam-media-grid-item>
            <fam-media-grid-item type="image" src="https://picsum.photos/600/600"></fam-media-grid-item>
            <fam-media-grid-item type="image" src="https://picsum.photos/1920/1280"></fam-media-grid-item>
            <fam-media-grid-item type="image" src="https://picsum.photos/720/1280"></fam-media-grid-item>
            <fam-media-grid-item type="video" src="https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/1080/Big_Buck_Bunny_1080_10s_1MB.mp4"></fam-media-grid-item>

        </fam-media-grid>

        `;
    }
}
customElements.define('home-page', HomePage);