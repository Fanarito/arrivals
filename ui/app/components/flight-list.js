import Ember from 'ember';

export default Ember.Component.extend({
  searchKeyword: '',
  flights: null,
  filteredFlights: Ember.computed('searchKeyword', 'flights', function () {
    let keyword = this.get('searchKeyword').toLowerCase();

    if (keyword === "") {
      return this.get('flights');
    }

    return this.get('flights').filter(function (item) {
      return item.get('date').toString().indexOf(keyword) > -1 ||
        item.get('numberLower').indexOf(keyword) > -1 ||
        item.get('scheduledTimeString').indexOf(keyword) > -1 ||
        item.get('realTimeString').indexOf(keyword) > -1 ||
        item.get('airline').get('nameLower').indexOf(keyword) > -1 ||
        item.get('location').get('nameLower').indexOf(keyword) > -1 ||
        item.get('status').get('nameLower').indexOf(keyword) > -1;
    });
  })
});
