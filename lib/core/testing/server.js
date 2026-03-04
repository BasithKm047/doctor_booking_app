const WebSocket = require('ws');
const { getServiceData } = require('./services/service');

const PORT = Number(process.env.PORT) || 8080;
const wss = new WebSocket.Server({ port: PORT });

wss.on('listening', () => {
  console.log(`WebSocket server running on ws://localhost:${PORT}`);
});

wss.on('error', (error) => {
  if (error.code === 'EADDRINUSE') {
    console.error(`Port ${PORT} is already in use. Stop the other process or use another port.`);
  } else {
    console.error('WebSocket server error:', error.message);
  }
  process.exit(1);
});

wss.on('connection', (ws) => {
  console.log('Client connected');

  ws.on('message', (raw) => {
    const message = raw.toString().trim();
    console.log('Received:', message);

    if (message === 'get_service_data') {
      ws.send(
        JSON.stringify({
          type: 'service_data',
          payload: getServiceData(),
        })
      );
      return;
    }

    ws.send(`Echo: ${message}`);
  });

  ws.on('close', () => console.log('Client disconnected'));
});
