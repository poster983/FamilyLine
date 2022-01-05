import {LitElement, html, css, unsafeCSS} from 'lit';
import tailwinds from  "../styles.css"




class FamMediaGridItem extends LitElement {

  static styles = [
    //css`${unsafeCSS(tailwinds)}`,
    
    css`
    :host {
      height: auto;
      width: auto;
      aspect-ratio: 1/1;
      /* background-color: red; */
    }

    .square {
      aspect-ratio: 1/1;
      width: auto;
      height: 100%;
      object-fit: cover;
      transition: all 0.3s;
    } 

    .square:hover {
      transform: scale(1.1);
      
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
    let media;
    if(this.type == "image") {
      media =  html`
        <img id="target" class="square" src="${this.src}">
      `;
    } else if(this.type == "video") {
      media =  html`
        <video id="target" class="square" preload="metadata">
          <source src="${this.src}#t=1.0" type="video/mp4">
        </video>
        <!-- <video class="square" src="${this.src}"></video> -->
      `;
    } else {
      console.error("INVALID TYPE: " + this.src);
      media =  html`
        <object id="target" width="100%" height="100%" class="square" data="${this.src}"></object>
        `;
    }

    return html`
      <a href="${this.src}">
        ${media}
      </a>
    `;

    
  }
}
customElements.define('fam-media-grid-item', FamMediaGridItem);