function connect() {
  const socket = new WebSocket('ws://localhost:62115');

  socket.onopen = () => {
    chrome.action.enable();
  };

  socket.onclose = () => {
    chrome.action.disable();
    chrome.action.setBadgeText({ text: '' });

    chrome.alarms.create({ delayInMinutes: 1 });
  };

  socket.onmessage = event => {
    const ptext = JSON.parse(event.data);

    switch (ptext.type) {
      case 'interval':
        const time = `${Math.floor(ptext.remainingSec / 60)}:${(ptext.remainingSec % 60).toString().padStart(2, 0)}`;
        chrome.action.setBadgeText({ text: time });

        chrome.runtime.sendMessage(ptext);
        break;
      case 'step':
        chrome.notifications.create({
          type: 'basic',
          title: '🍅 Go to the next step',
          message: ptext.content,
          iconUrl: 'images/icon-128.png'
        });
        break;
      case 'finish':
        chrome.notifications.create({
          type: 'basic',
          title: '🍅 Finished!',
          message: ptext.content,
          iconUrl: 'images/icon-128.png'
        });
        break;
    }
  };
}

chrome.alarms.onAlarm.addListener(() => connect());
chrome.action.setBadgeBackgroundColor({ color: '#000' });

connect();
