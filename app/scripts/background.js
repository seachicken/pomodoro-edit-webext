function connect() {
  const socket = new WebSocket('ws://localhost:62115');

  socket.onopen = () => {
    chrome.browserAction.enable();
  };

  socket.onerror = err => {
    setTimeout(() => connect(), 5000);
  };

  socket.onclose = () => {
    chrome.browserAction.disable();
  };

  socket.onmessage = event => {
    new Notification(event.data);
  };
}

connect();