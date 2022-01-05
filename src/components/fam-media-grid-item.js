import {LitElement, html, css, unsafeCSS} from 'lit';
import tailwinds from  "../styles.css"




class FamMediaGridItem extends LitElement {

  static styles = [
    //css`${unsafeCSS(tailwinds)}`,
    
    css`
    :host {
      height: calc(auto - 2px);
      aspect-ratio: 1/1;
      background-color: red;
    }

    .square {
      aspect-ratio: 1/1;
      width: auto;
      height: 100%;
      object-fit: cover;
    } 
  `];

  static properties = {
      src: {type: String}, // can be image/video/doc
      type: {type: String, } //image/video/doc
  }

  updated(changedProperties) {
    changedProperties.forEach((oldValue, propName) => {
      if(propName === "src") {
        console.log(this.src)
      }
    });
  }

  // firstUpdated() {
  //   let target = this.shadowRoot.getElementById("target");
  //   //let comp = thgetComputedStyle()
  //   this.style.height = target.style.height = 
  // }

  render() {
    if(this.type == "image") {
      return html`
        <img id="target" class="square" src="${this.src}">
      `;
    } else if(this.type == "video") {
      return html`
        <video id="target" class="square" preload="metadata">
          <source src="${this.src}#t=1.0" type="video/mp4">
        </video>
        <!-- <video class="square" src="${this.src}"></video> -->
      `;
    } else {
      console.error("INVALID TYPE: " + this.src);
      return html`
        <object id="target" width="100%" height="100%" class="square" data="${this.src}"></object>
        `;
    }

    
  }
}
customElements.define('fam-media-grid-item', FamMediaGridItem);