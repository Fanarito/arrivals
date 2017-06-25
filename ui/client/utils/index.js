export const PRODUCTION = (process.env.NODE_ENV === 'production' ? true : false);

export const BASE_URL = (PRODUCTION ? 'www.arrivals.is' : 'localhost:4000');

export const URL = (PRODUCTION ? '' : `http://${BASE_URL}`);
export const SOCKET_URL = (PRODUCTION ? `wss://${BASE_URL}/socket` : `ws://${BASE_URL}/socket`);
