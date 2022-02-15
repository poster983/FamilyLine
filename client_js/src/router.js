/* THE ROUTER */
import "./pages/home-page.js"
import "./pages/account-page.js"
import "./pages/beings-page.js"

import {Router} from '@vaadin/router';
const outlet = document.querySelector("family-line")
export const router = new Router(outlet);
router.setRoutes([
    {path: '/', component: 'home-page'},
    // {path: '/users', component: 'x-user-list'},
    {path: '/account', component: 'account-page'},
    {path: '/beings/:id', component: 'beings-page'},
]);


