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
import FlightCard from 'components/FlightCard';

export default {
  components: {
    FlightCard
  },
  data() {
    return {
      keyword: "",
      filtering: false
    }
  },
  computed: {
    filteredFlights() {
      return this.$store.getters.getFlightsByKeywords(this.keyword);
    }
  },
  created: function () {
    this.$store.dispatch('getFlights');
  }
}
</script>
