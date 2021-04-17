function connect() {
  const socket = new WebSocket('ws://localhost:62115');

  socket.onopen = () => {
    chrome.browserAction.enable();
  };

  socket.onclose = () => {
    chrome.browserAction.disable();
    chrome.browserAction.setBadgeText({ text: '' });

    setTimeout(() => connect(), 5000);
  };

  socket.onmessage = event => {
    const ptext = JSON.parse(event.data);

    switch (ptext.type) {
      case 'interval':
        const time = `${Math.floor(ptext.remaining / 60)}:${(ptext.remaining % 60).toString().padStart(2, 0)}`;
        chrome.browserAction.setBadgeText({ text: time });

        chrome.runtime.sendMessage(ptext);
        break;
      case 'finish':
        new Notification(`Finished! ${ptext.content}`, { icon: 'images/icon-128.png'});
        break;
    }
  };
}

chrome.browserAction.setBadgeBackgroundColor({ color: '#000' });
connect();