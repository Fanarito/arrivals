<template lang="html">
  <div id="app">
    <div class="ui segment">
      <transition name="slide-fade" mode="out-in">
        <keep-alive>
          <router-view></router-view>
        </keep-alive>
      </transition>
    </div>

    <!-- Loading indicator -->
    <div v-show="loading" id="loading-indicator" class="ui icon message">
      <i class="notched circle loading icon"></i>
      <div class="content">
        <div class="header">
          Just one second
        </div>
        <p>We're fetching that content for you.</p>
      </div>
    </div>
  </div>
</template>

<script lang="js">

export default {
  computed: {
    loading() {
      return this.$store.state.loading_data;
    }
  }
}
</script>

<style lang="css">
.slide-fade-enter-active {
    transition: all .2s ease;
}
.slide-fade-leave-active {
    transition: all .3s cubic-bezier(1.0, 0.5, 0.8, 1.0);
}
.slide-fade-enter, .slide-fade-leave-to
/* .slide-fade-leave-active for <2.1.8 */ {
    transform: translateY(10px);
    opacity: 0;
}

.list-item {
  transition: all 0.5s;
  margin-right: 10px;
}
.list-enter-active, .list-leave-active {
  transition: all 0.5s;
  position: absolute;
}
.list-enter, .list-leave-to /* .list-leave-active for <2.1.8 */ {
  opacity: 0;
  transform: translateY(30px);
}
.list-move {
  transition: transform 0.5s;
}

#loading-indicator {
    position: fixed;
    bottom: 0;
}
</style>
