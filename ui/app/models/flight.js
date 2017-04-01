import DS from 'ember-data';
import Ember from 'ember';

export default DS.Model.extend({
  date: DS.attr('date'),
  number: DS.attr(),
  scheduled_time: DS.attr('date'),
  real_time: DS.attr('date'),

  airline: DS.belongsTo('airline'),
  location: DS.belongsTo('location'),
  status: DS.belongsTo('status'),

  numberLower: Ember.computed('number', function () {
    return this.get('number').toLowerCase();
  }),
  scheduledTimeString: Ember.computed('scheduled_time', function () {
    return this.get('scheduled_time').toString();
  }),
  realTimeString: Ember.computed('scheduled_time', function () {
    let time = this.get('real_time');
    if (time) {
      return this.get('real_time').toString();
    }
    return "None";
  })
});
