import {LitElement, html, css, unsafeCSS} from 'lit';
import tailwinds from  "../styles.css"

class FamMediaGrid extends LitElement {

    static styles = [
      //css`${unsafeCSS(tailwinds)}`,
      css`
       .grid {
        display: grid;
        align-items: center;
        grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
      } 

      /* .grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
        grid-auto-rows: 1fr;
      }

      .grid::before {
        content: '';
        width: 0;
        padding-bottom: 100%;
        grid-row: 1 / 1;
        grid-column: 1 / 1;
      }

      .grid > *:first-child {
        grid-row: 1 / 1;
        grid-column: 1 / 1;
      } */
    `];
  
    render() {
      return html`
        
          <slot class="grid"></slot>
  
      `;
    }
  }
  customElements.define('fam-media-grid', FamMediaGrid);