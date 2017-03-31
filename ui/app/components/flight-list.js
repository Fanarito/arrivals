import Ember from 'ember';

export default Ember.Component.extend({
  searchKeyword: '',
  flights: null,
  filteredFlights: Ember.computed('searchKeyword', 'flights', function () {
    let keyword = this.get('searchKeyword');

    if (keyword == "") {
      return this.get('flights');
    }

    // let filtered = this.get('flights').filterBy('number', keyword);
    return this.get('flights').filter(function (item) {
      return item.get('date').toLowerCase().indexOf(keyword) > -1 ||
        item.get('number').toLowerCase().indexOf(keyword) > -1 ||
        item.get('scheduled_time').toLowerCase().indexOf(keyword) > -1 ||
        item.get('airline').get('name').toLowerCase().indexOf(keyword) > -1 ||
        item.get('location').get('name').toLowerCase().indexOf(keyword) > -1 ||
        item.get('status').get('name').toLowerCase().indexOf(keyword) > -1;
    });
  }),
  actions: {
    updateList: function () {
      let keyword = this.get('searchKeyword');

      if (keyword == "") {
        this.set('filteredFlights', this.get('flights'));
        return;
      }

      // let filtered = this.get('flights').filterBy('number', keyword);
      let filtered = this.get('flights').filter(function (item) {
        return item.get('date').toLowerCase().indexOf(keyword) > -1 ||
          item.get('number').toLowerCase().indexOf(keyword) > -1 ||
          item.get('scheduled_time').toLowerCase().indexOf(keyword) > -1 ||
          item.get('airline').get('name').toLowerCase().indexOf(keyword) > -1 ||
          item.get('location').get('name').toLowerCase().indexOf(keyword) > -1 ||
          item.get('status').get('name').toLowerCase().indexOf(keyword) > -1;
      });
      // let filtered = this.get('flights');
      this.set('filteredFlights', filtered);
    }
  },
  didInsertElement () {
    // this.set('filteredFlights', this.get('flights'));
  }
});
