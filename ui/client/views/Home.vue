<template lang="html">
  <div class="ui stackable container grid">
    <div class="sixteen wide column">
      <div class="ui fluid left icon input" :class="{ loading: filtering }">
        <input v-model="keyword" type="text" placeholder="Filter..."/>
        <i class="search icon"></i>
      </div>
    </div>
    <div class="sixteen wide column">
      <transition-group name="list" class="ui stackable grid">
        <div v-for="flight in filteredFlights" :key="flight.id" class="four wide column">
          <FlightCard :flight="flight"></FlightCard>
        </div>
      </transition-group>
    </div>
  </div>
</template>

<script lang="js">
import _ from 'lodash';
import FlightCard from 'components/FlightCard';

export default {
  components: {
    FlightCard
  },
  data() {
    return {
      keyword: "",
      debouncedKeyword: "",
      filtering: false
    }
  },
  computed: {
    filteredFlights() {
      return this.$store.getters.getUsefulFlightsByKeywords(this.debouncedKeyword);
    }
  },
  watch: {
    keyword: function () {
      this.filtering = true;
      this.updateKeyword();
    }
  },
  methods: {
    updateKeyword: _.debounce(function () {
      this.debouncedKeyword = this.keyword;
      this.filtering = false;
    }, 750)
  },
  created: function () {
    this.$store.dispatch('getUsefulFlights');
  }
}
</script>
