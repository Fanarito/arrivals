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
        Real: {{ realTime }}
        <br/>
        Scheduled: {{ scheduledTime }}
      </div>
    </div>
    <div class="extra content">
      <div :class="[colorClass]" class="ui bottom attached label">
        <i :class="[iconClass]" class="ui icon"></i>
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
  },
  computed: {
    realTime: function () {
      let time = this.flight.latest_status.real_time;
      if (time == null) {
        return "None";
      }
      return new Date(time).toLocaleTimeString([], {hour: '2-digit', minute: '2-digit'});
    },
    scheduledTime: function () {
      let time = this.flight.scheduled_time;
      if (time == null) {
        return "None";
      }
      return new Date(time).toLocaleTimeString([], {hour: '2-digit', minute: '2-digit'});
    },
    colorClass: function () {
      let status_name = this.flight.latest_status.name;

      switch (status_name) {
      case "Landed":
        return "green";
      case "Confirmed":
        return "yellow";
      case "Cancelled":
        return "red";
      default:
        return "orange";
      };
    },
    iconClass: function () {
      let name = this.flight.latest_status.name;

      switch (name) {
      case "Cancelled":
        return "remove";
      case "Confirmed":
        return "check";
      case "Landed":
        return "check";
      default:
        return "question";
      }
    }
  }
}
</script>

<style scoped>
</style>
