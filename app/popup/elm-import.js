document.addEventListener('DOMContentLoaded', () => {
  const app = Elm.Main.init({
    node: document.getElementById('elm'),
    flags: { operator: '', remainingSec: 0, durationSec: 0, content: '☕️ No tasks', stepNos: '', symbol: '' }
  });

  chrome.runtime.onMessage.addListener(message => {
    app.ports.receiveMessage.send(message);
  });
});
