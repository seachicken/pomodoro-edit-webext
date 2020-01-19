browser.runtime.onInstalled.addListener((details) => {
  console.log('previousVersion', details.previousVersion)
})

const socket = new WebSocket('ws://localhost:62115');
socket.addEventListener('message', function (event) {
  new Notification(event.data);
});