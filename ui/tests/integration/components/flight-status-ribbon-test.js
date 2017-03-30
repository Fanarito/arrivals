import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('flight-status-ribbon', 'Integration | Component | flight status ribbon', {
  integration: true
});

test('it renders', function(assert) {

  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{flight-status-ribbon}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:
  this.render(hbs`
    {{#flight-status-ribbon}}
      template block text
    {{/flight-status-ribbon}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});
