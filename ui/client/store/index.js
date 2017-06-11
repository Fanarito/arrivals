import Vue from 'vue';
import Vuex from 'vuex';
import axios from 'axios';
import _ from 'lodash';
import Fuse from 'fuse.js';

Vue.use(Vuex);

// If the mode is not production use localhost:4000
const URL = (process.env.NODE_ENV === 'production' ? "" : "http://localhost:4000");

const state = {
  flights: [],
  useful_flights: [],
  loading_data: false
};

const mutations = {
  SET_FLIGHTS: (state, { flights }) => {
    state.flights = flights;
  },
  UPDATE_FLIGHTS: (state, { flights }) => {
    _.forEach(flights, function (flight) {
      let idx = _.findIndex(state.flights, { id: flight.id });
      if (idx > -1) {
        Vue.set(state.flights, idx, flight);
      } else {
        state.flights.push(flight);
      }
    });
  },
  SET_USEFUL_FLIGHTS: (state, { flights }) => {
    state.useful_flights = flights;
  },
  SET_LOADING_DATA: (state, { bool }) => {
    state.loading_data = bool;
  }
};

const actions = {
  getUsefulFlights ({ commit }) {
    commit('SET_LOADING_DATA', { bool: true });
    axios.get(URL + '/api/flights?useful=true').then((response) => {
      commit('SET_USEFUL_FLIGHTS', { flights: response.data.flights });
      commit('UPDATE_FLIGHTS', { flights: response.data.flights });
      commit('SET_LOADING_DATA', { bool: false });
    }, (err) => {
      alert("Could not fetch flights in useful order");
    });
  },
  getFlights ({ commit }) {
    commit('SET_LOADING_DATA', { bool: true });
    axios.get(URL + '/api/flights').then((response) => {
      commit('UPDATE_FLIGHTS', { flights: response.data.flights });
      commit('SET_LOADING_DATA', { bool: false });
    }, (err) => {
      console.log(err);
    });
  },
  getFlightDetails ({ commit, state }, flightId) {
    commit('SET_LOADING_DATA', { bool: true });
    axios.get(URL + '/api/flights/' + flightId).then((response) => {
      commit('UPDATE_FLIGHTS', { flights: [response.data]});
      commit('SET_LOADING_DATA', { bool: false });
    }, (err) => {
      alert("Could not fetch flights");
    });
  }
};

const getters = {
  getOrderedFlights: (state, getters) => (id) => {
    return _.orderBy(state.flights, ['date', 'asc']);
  },
  getFlightById: (state, getters) => (id) => {
    return _.find(state.flights, { id: parseInt(id) });
  },
  getFlightsByKeywords: (state, getters) => (keywords) => {
    if (keywords === '') { return getters.getOrderedFlights(); };
    var options = {
      keys: ['number', 'latest_status.name', 'location.name', 'airline.name']
    };
    var fuse = new Fuse(state.flights, options);
    return fuse.search(keywords);
  },
  getUsefulFlightsByKeywords: (state, getters) => (keywords) => {
    if (keywords === '') { return state.useful_flights; };
    var options = {
      keys: ['number', 'latest_status.name', 'location.name', 'airline.name']
    };
    var fuse = new Fuse(state.useful_flights, options);
    return fuse.search(keywords);
  }
};

const store = new Vuex.Store({
  state,
  mutations,
  actions,
  getters
});

export default store;
