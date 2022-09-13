import { Socket, Presence } from 'phoenix';

let socket = new Socket("/socket", {
  params: { token: sessionStorage.userToken }
})

socket.connect()

let channel = socket.channel("game:lobby", {})
channel.join()
  .receive("ok", resp => { 
    console.log("Joined successfully", resp)
    document.addEventListener('mousemove', (e) => {
      const x = e.pageX / window.innerWidth;
      const y = e.pageY / window.innerHeight;
      channel.push('move', { x, y })
    })
 })
  .receive("error", resp => { console.log("Unable to join", resp) })

const presence = new Presence(channel);

presence.onSync(() => {
  const ul = document.createElement('ul');

  presence.list((name, { metas: [firstDevice] }) => {
    const { x, y, color } = firstDevice;
    const cursorLi = cursorTemplate({
      name,
      x: x * window.innerWidth,
      y: y * window.innerHeight,
      color
    });
    ul.appendChild(cursorLi);
  });

  document.getElementById('cursor-list').innerHTML = ul.innerHTML;
});

function cursorTemplate({ x, y, name, color }) {
  const li = document.createElement('li');
  li.classList =
    'flex flex-col absolute pointer-events-none whitespace-nowrap overflow-hidden';
  li.style.left = x + 'px';
  li.style.top = y + 'px';
  li.style.color = color;

  li.innerHTML = `
    <svg
      version="1.1"
      width="25px"
      height="25px"
      xmlns="http://www.w3.org/2000/svg"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      viewBox="0 0 21 21">
        <polygon
          fill="black"
          points="8.2,20.9 8.2,4.9 19.8,16.5 13,16.5 12.6,16.6" />
        <polygon
          fill="currentColor"
          points="9.2,7.3 9.2,18.5 12.2,15.6 12.6,15.5 17.4,15.5"
        />
    </svg>
    <span class="mt-1 ml-4 px-1 text-sm text-white" />
  `;

  li.lastChild.style.backgroundColor = color;
  li.lastChild.textContent = name;

  return li;
}
export default socket
