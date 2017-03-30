import DS from 'ember-data';

export default DS.Model.extend({
  date: DS.attr(),
  number: DS.attr(),
  scheduled_time: DS.attr(),
  real_time: DS.attr(),

  airline: DS.belongsTo('airline'),
  location: DS.belongsTo('location'),
  status: DS.belongsTo('status')
});
