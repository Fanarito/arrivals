import { Socket } from 'phoenix-elixir';
import store from '../store';
import { SOCKET_URL } from '../utils';

export const socket = new Socket(SOCKET_URL);

export function joinFlightChannel() {
  let flightChannel = socket.channel('flight:lobby', {});
  flightChannel.join()
    .receive('ok', function(data) {
      console.log('Joined channel flight:lobby', data);
    })
    .receive('error', function(resp) {
      console.log('Unable to join channel flight:lobby', resp);
    });

  flightChannel.on('insert', function(flight) {
    store.dispatch('updateFlights', [flight]);
  });
}
