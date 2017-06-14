import Vue from 'vue';
import { sync } from 'vuex-router-sync';
import App from './components/App';
import router from './router';
import store from './store';
import init from './init';

sync(store, router);

const app = new Vue({
  router,
  store,
  ...App
});

Vue.directive('focus', {
  // Using v-focus on an input focuses it when rendered
  inserted: function (el) {
    el.focus();
  }
});

init();

export { app, router, store }
