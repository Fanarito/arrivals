<template lang="html">
  <div class="ui stackable container grid">
    <div class="sixteen wide column">
      <div class="ui fluid input">
        <input v-model="keyword" type="text" placeholder="Filter..."/>
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
      keyword: ""
    }
  },
  computed: {
    flights() {
      return this.$store.state.useful_flights;
    },
    filteredFlights() {
      if (this.keyword === "") {
        return this.$store.state.useful_flights;
      }

      let keyword = this.keyword.toLowerCase();
      return this.$store.state.useful_flights.filter(function (item) {
        return item.date.indexOf(keyword) > -1 ||
          item.number.toLowerCase().indexOf(keyword) > -1 ||
          item.scheduled_time.indexOf(keyword) > -1 ||
          item.airline.name.toLowerCase().indexOf(keyword) > -1 ||
          item.location.name.toLowerCase().indexOf(keyword) > -1 ||
          item.latest_status.name.toLowerCase().indexOf(keyword) > -1 ||
          String(item.latest_status.real_time).indexOf(keyword) > -1;
      });
    }
  },
  created: function () {
    this.$store.dispatch('getUsefulFlights');
  }
}
</script>
