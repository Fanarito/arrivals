<template lang="html">
  <div class="ui grid">
    <div class="sixteen wide column">
      <transition-group name="list" class="ui stackable grid">
        <div v-for="flight in flights" :key="flight.id" class="four wide column">
          <flight-card :flight="flight"></flight-card>
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
  props: ['flights']
}
</script>
