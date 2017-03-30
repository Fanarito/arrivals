import Ember from 'ember';

export function datetime(date/*, hash*/) {
  if (date == "") {
    return "None";
  }
  return new Date(date).toLocaleTimeString([], {hour: '2-digit', minute: '2-digit'});
}

export default Ember.Helper.helper(datetime);
