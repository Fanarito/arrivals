<template lang="html">
  <router-link v-if="flight" :to="{ name: 'flightDetail', params: {  id: flight.id } }" class="ui fluid card">
    <div class="content">
      <div class="ui header">
        {{ flight.location.name }}
        <div class="sub header">
          {{ flight.date }}
        </div>
      </div>
      <div class="description">
        {{ flight.number }} | {{ flight.airline.name }}
        <div class="ui divider"></div>
        Real: {{ flight.realTime }}
        <br/>
        Scheduled: {{ flight.scheduledTime }}
      </div>
    </div>
    <div class="extra content">
      <div :class="[flight.colorClass]" class="ui bottom attached label">
        <i :class="[flight.iconClass]" class="ui icon"></i>
        {{flight.latest_status.name}}
      </div>
    </div>
  </router-link>
</template>

<script lang="js">
import { mapGetters } from 'vuex'

export default {
  props: {
    flight: null
  }
}
</script>

<style scoped>
</style>
