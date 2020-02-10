document.addEventListener('DOMContentLoaded', () => {
  const app = Elm.Main.init({
    node: document.getElementById('elm'),
    flags: { operator: '', time: 0, content: '☕️ No tasks', remaining: 0 }
  });

  chrome.runtime.onMessage.addListener(message => {
    app.ports.receiveMessage.send(message);
  });
});