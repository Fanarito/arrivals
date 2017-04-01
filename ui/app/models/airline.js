import DS from 'ember-data';
import Ember from 'ember';

export default DS.Model.extend({
  name: DS.attr(),

  flights: DS.hasMany("flight"),

  nameLower: Ember.computed('name', function () {
    return this.get('name').toLowerCase();
  })
});
