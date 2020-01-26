function connect() {
  const socket = new WebSocket('ws://localhost:62115');

  socket.onopen = () => {
    chrome.browserAction.enable();
  };

  socket.onclose = () => {
    chrome.browserAction.disable();

    setTimeout(() => connect(), 5000);
  };

  socket.onmessage = event => {
    new Notification(event.data, { icon: 'images/icon-128.png'});
  };
}

connect();