import DS from 'ember-data';
import config from '../config/environment';

console.log(config.DS.host);

export default DS.JSONAPIAdapter.extend({
  namespace: 'api',
  host: config.DS.host
});
