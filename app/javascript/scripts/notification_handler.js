class NotificationHandler {
  constructor(button) {
    this.notifiableButton = button;
  }
  init() {
    console.log("here");
    this.fetchnotificationcount.bind(this).call();
    this.notifiableButton.addEventListener("click", async (event) => {
      event.preventDefault();
      this.loadNotifications();
      this.readNotifications();
    });
  }

  async fetchnotificationcount() {
    const notification = document.querySelector("#notifications");
    const res = await fetch(notification.dataset.url);
    const json = await res.json();
    this.handleCount(json.unread_count);
  }

  handleCount(data) {
    const badge = document.getElementById("notifiable-badge");
    if (data == 0) {
      badge.style.display = "none";
    } else {
      badge.style.display = "block";
      badge.innerText = data;
    }
    setTimeout(this.fetchnotificationcount.bind(this), 3000);
  }

  async loadNotifications() {
    const button = document.getElementById("notification-bell");
    const data = await (await fetch(button.dataset.url)).json();
    const menuDiv = document.getElementById("notification-menu");
    menuDiv.classList.toggle("on");
    const menuItem = document.getElementById("notification-items");

    menuItem.innerHTML = "";
    for (let i = 0; i < data.length; i++) {
      console.log(data[i]);
      menuItem.innerHTML +=
        "<a id=" +
        data[i].id +
        " href=" +
        data[i].path +
        " class='notifications-item' >" +
        "<div class='text'>" +
        "<h4>" +
        data[i].content +
        "</h4>" +
        "<p>" +
        data[i].time +
        "</p>" +
        "</div>" +
        "</a>";
    }
  }
  async readNotifications() {
    const button = document.getElementById("notification-bell");
    const data = await (await fetch(button.form.action, { method: "put"} )).json();
    console.log(data);
    if (data.error) {
      this.handleError(data.error);
    } else {
      console.log("read");
    }
  }

  generateDataForRequest(form) {
    const data = new URLSearchParams();
    for (const pair of new FormData(form)) {
      data.append(pair[0], pair[1]);
    }
    return data;
  }

  handleError(error) {
    const noticeElement = document.getElementById("notice");
    noticeElement.textContent = error;
    noticeElement.scrollIntoView();
  }
}
let notificationHandler = new NotificationHandler(
  document.querySelector("[data-ref=notifiable-button]")
);
notificationHandler.init();
