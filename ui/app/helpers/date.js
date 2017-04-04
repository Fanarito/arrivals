import Ember from 'ember';

export function date(params/*, hash*/) {
    return new Date(params).toLocaleDateString();
}

export default Ember.Helper.helper(date);
