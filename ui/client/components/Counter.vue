<template lang="html">
    <div class="columns is-multiline">
      <div class="column is-12">
        <div class="field">
          <input v-model="keyword" class="input" type="text" placeholder="Filter...">
        </div>
    </div>
    <div v-for="flight in flights" v-if="containsKeyword(flight)" class="column is-4">
      <md-card md-with-hover>
        <md-card-header>
          <div class="md-title">Title goes here</div>
          <div class="md-subhead">Subtitle here</div>
        </md-card-header>

        <md-card-content>
          Lorem ipsum dolor sit amet, consectetur adipisicing elit. Optio itaque ea, nostrum odio. Dolores, sed accusantium quasi non, voluptas eius illo quas, saepe voluptate pariatur in deleniti minus sint. Excepturi.
        </md-card-content>

        <md-card-actions>
          <md-button>Action</md-button>
          <md-button>Action</md-button>
        </md-card-actions>
      </md-card>
      <!-- <FlightCard :flight="flight"></FlightCard> -->
    </div>
  </div>
</template>

<script lang="js">
import FlightCard from './FlightCard';

export default {
  data() {
    return {
      keyword: ""
    }
  },
  computed: {
    flights() {
      return this.$store.state.flights;
    }
  },
  mounted: function () {
    this.$store.dispatch('getFlights');
  },
  components: {
    FlightCard
  },
  methods: {
    containsKeyword: function (flight) {
      let keyword = this.keyword.toLowerCase();
      return flight.attributes.number.toLowerCase().indexOf(keyword) > -1;
    }
  }
}
</script>

<style scoped>
</style>
