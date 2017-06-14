import { socket, joinFlightChannel } from './channel';

export default function init() {
  socket.connect();
  joinFlightChannel();
}
