<template lang="html">
  <router-link v-if="flight" :to="{ name: 'flightDetail', params: {  id: flight.id } }" class="ui fluid card">
  </router-link>
</template>
