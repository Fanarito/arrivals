<template lang="html">
  <table class="ui selectable table">
    <thead>
      <tr>
        <th>Re.</th>
        <th>Sch.</th>
        <th>From</th>
        <th>Number</th>
        <th>Airline</th>
        <th>Status</th>
      </tr>
    </thead>
    <transition-group tag="tbody" name="list">
      <router-link tag="tr" :to="{ name: 'flightDetail', params: {  id: flight.id } }" v-for="flight in flights" :key="flight.id">
        <td>{{flight.realTime}}</td>
        <td>{{flight.scheduledTime}}</td>
        <td>{{flight.number}}</td>
        <td>{{flight.location.name}}</td>
        <td>{{flight.airline.name}}</td>
        <td>
          <i :class="[flight.colorClass, flight.iconClass]" class="ui icon"></i>
          {{flight.latest_status.name}}
        </td>
      </router-link>
    </transition-group>
  </table>
</template>

<script lang="js">
export default {
  props: ['flights'],
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
    }
  }
}
</script>
