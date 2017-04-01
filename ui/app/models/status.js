import DS from 'ember-data';
import Ember from 'ember';

export default DS.Model.extend({
  name: DS.attr(),

  flights: DS.hasMany("flight"),

  colorClass: Ember.computed('name', function () {
    var name = this.get('name');
    var colorClass = "orange";

    switch (name) {
    case "Cancelled":
      colorClass = "red";
      break;
    case "Confirmed":
      colorClass = "yellow";
      break;
    case "Landed":
      colorClass = "green";
      break;
    }

    return colorClass;
  }),
  iconClass: Ember.computed('name', function () {
    var name = this.get('name');

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
  }),
  nameLower: Ember.computed('name', function () {
    return this.get('name').toLowerCase();
  })
});
