<template lang="html">
  <div class="ui stackable container grid">
    <div v-for="flight in flights" :key="flight.id" class="four wide column">
      <FlightCard :flight="flight"></FlightCard>
    </div>
  </div>
</template>

<script lang="js">
import FlightCard from 'components/FlightCard';

export default {
  components: {
    FlightCard
  },
  computed: {
    flights() {
      return this.$store.state.flights;
    }
  },
  created: function () {
    this.$store.dispatch('getUsefulFlights');
  }
}
</script>
