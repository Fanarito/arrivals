import Vue from 'vue';
import Router from 'vue-router';
import Home from '../views/Home';
import FlightDetail from '../views/FlightDetail.vue';
import FlightList from '../views/FlightList.vue';

Vue.use(Router);

export default new Router({
  mode: 'hash',
  linkActiveClass: 'active',
  routes: [
    {
      path: '/',
      redirect: '/home'
    },
    {
      name: "home",
      path: '/home',
      component: Home
    },
    {
      name: 'flightList',
      path: '/flights',
      component: FlightList
    },
    {
      name: 'flightDetail',
      path: '/flight/:id',
      component: FlightDetail
    }
  ]
});
