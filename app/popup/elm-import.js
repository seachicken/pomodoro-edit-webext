document.addEventListener('DOMContentLoaded', () => {
  const app = Elm.Main.init({
    node: document.getElementById('elm'),
    flags: { operator: '', time: 0, content: '☕️ No tasks'}
  });

  chrome.runtime.onMessage.addListener(message => {
    app.ports.receiveMessage.send(message);
  });
});