<template lang="html">
  <div class="ui internally celled stackable container grid">
    <div class="row">
      <div class="column">
        <button @click="$router.back()" class="ui basic primary labeled icon button">
          <i class="left arrow icon"></i>
          Back
        </button>
      </div>
    </div>
    <div class="row">
      <div class="column">
        <FlightCard :flight=flight></FlightCard>
      </div>
    </div>
    <div class="row">
      <div class="column">
        <div v-if="flight" class="ui relaxed divided list">
          <div v-for="status in flight.statuses" class="item">
            <div class="content">
              <div class="header">
                {{ status.name }} <span v-if="status.real_time">{{ timeDisplay(status.real_time) }}</span>
              </div>
              <div class="description">
                {{ dateTimeDisplay(status.inserted_at) }}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="js">
import FlightCard from 'components/FlightCard';

export default {
  components: {
    FlightCard
  },
  methods: {
    timeDisplay: function (time) {
      return new Date(time).toLocaleTimeString();
    },
    dateTimeDisplay: function (time) {
      return new Date(time).toLocaleString();
    }
  },
  computed: {
    flight() {
      return this.$store.getters.getFlightById(this.$route.params.id);
    }
  },
  activated: function () {
    this.$store.dispatch('getFlightDetails', this.$route.params.id);
  }
}
</script>
