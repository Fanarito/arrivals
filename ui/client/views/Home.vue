<template lang="html">
  <div class="ui internally celled container grid">
    <div class="row">
      <div class="column">
        <div class="ui fluid left icon action input" :class="{ loading: filtering }">
          <i class="search icon"></i>
          <input v-focus v-model="keyword" type="text" placeholder="Filter..."/>
          
          <select class="ui compact selection dropdown">
            <option value="cards">Cards</option>
            <option value="list">List</option>
          </select>

        </div>
      </div>
    </div>
    <div class="row">
      <div class="column">
        <flight-card-list v-if="flightListType == 'cards'" :flights="filteredFlights"></flight-card-list>
        <flight-list v-else :flights="filteredFlights"></flight-list>
      </div>
    </div>
  </div>
</template>

<script lang="js">
import debounce from 'lodash/debounce';
import FlightList from 'components/FlightList';
import FlightCardList from 'components/FlightCardList';

export default {
  components: {
    FlightCardList,
    FlightList
  },
  data() {
    return {
      keyword: "",
      debouncedKeyword: "",
      filtering: false,
      flightListType: "cards"
    }
  },
  computed: {
    filteredFlights() {
      return this.$store.getters.getFlightsByKeywords(this.debouncedKeyword);
    }
  },
  watch: {
    keyword: function () {
      this.filtering = true;
      this.updateKeyword();
    }
  },
  methods: {
    updateKeyword: debounce(function () {
      this.debouncedKeyword = this.keyword;
      this.filtering = false;
    }, 500),

    saveFlightListType(val) {
      if (typeof(Storage) !== "undefined") {
        window.localStorage.setItem("flightListType", val);
      } else {
        // Sorry! No Web Storage support..
      }
    }
  },
  created: function () {
    this.$store.dispatch('getUsefulFlights');
    const listType = window.localStorage.getItem("flightListType");
    if (typeof(listType) === "string") {
      this.flightListType = listType;
    } else {
      this.flightListType = "cards";
    }
  },
  mounted: function () {
    let self = this;
    $('select.ui.dropdown')
      .dropdown({
        onChange: function (val) {
          self.flightListType = val;
          self.saveFlightListType(val);
        }
      })
      .dropdown('set selected', self.flightListType)
  }
}
</script>
