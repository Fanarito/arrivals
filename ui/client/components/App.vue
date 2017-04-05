<template lang="html">
  <div id="app">
    <div class="ui top attached menu">
      <router-link :to="{ name: 'home' }" class="item">
        Home
      </router-link>
      <router-link :to="{ name: 'flightList' }" class="item">
        Flights
      </router-link>
    </div>
    <div class="ui bottom attached segment">
      <transition name="slide-fade" mode="out-in">
        <router-view></router-view>
      </transition>
    </div>
  </div>
</template>

<style scoped>
.slide-fade-enter-active {
  transition: all .2s ease;
}
.slide-fade-leave-active {
  transition: all .3s cubic-bezier(1.0, 0.5, 0.8, 1.0);
}
.slide-fade-enter, .slide-fade-leave-to
/* .slide-fade-leave-active for <2.1.8 */ {
  transform: translateX(10px);
  opacity: 0;
}
</style>
