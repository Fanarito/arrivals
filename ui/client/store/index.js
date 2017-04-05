import Vue from 'vue';
import Vuex from 'vuex';
import axios from 'axios';

Vue.use(Vuex);

const URL = (process.env.NODE_ENV === 'production' ? "http://api.arrivals.is" : "http://localhost:4000");

const state = {
  flights: [],
  useful_flights: []
};

const mutations = {
  SET_FLIGHTS: (state, { flights }) => {
    state.flights = flights;
  },
  SET_USEFUL_FLIGHTS: (state, { flights }) => {
    state.useful_flights = flights;
  },
  SET_FLIGHT: (state, { flight }) => {
    // state.flights[flight.id] = flight;
    let changed = false;
    state.flights.some(function (item, idx) {
      if (item.id == flight.id) {
        Vue.set(state.flights, idx, flight);
        changed = true;
        return true;
      }
      return false;
    });

    if (!changed) {
      state.flights.push(flight);
    }
  }
};

const actions = {
  getUsefulFlights ({ commit }) {
    axios.get(URL + '/api/flights?useful=true').then((response) => {
      commit('SET_USEFUL_FLIGHTS', { flights: response.data.flights });
    }, (err) => {
      alert("Could not fetch flights in useful order");
    });
  },
  getFlights ({ commit }) {
    axios.get(URL + '/api/flights').then((response) => {
      commit('SET_FLIGHTS', { flights: response.data.flights });
    }, (err) => {
      console.log(err);
    });
  },
  getFlightDetails ({ commit, state }, flightId) {
    axios.get(URL + '/api/flights/' + flightId).then((response) => {
      commit('SET_FLIGHT', { flight: response.data});
    }, (err) => {
      alert("Could not fetch flights");
    });
  }
};

const getters = {
  getFlightById: (state, getters) => (id) => {
    return state.flights.find(function (flight) {
      return flight.id == id;
    });
  }
};

const store = new Vuex.Store({
  state,
  mutations,
  actions,
  getters
});

export default store;
