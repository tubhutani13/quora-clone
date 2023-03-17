class NotificationHandler {
  constructor(button) {
    this.notifiableButton = button;
    // this.handleCount = this.handleCount.bind(this);
  }
  init() {
    this.fetchnotificationcount.bind(this).call();
    // fetchnotification();
    // loadnotification();
    this.notifiableButton.addEventListener("click", (event) => {
      // readnotification();
      // event.preventDefault();
      console.log('cilick');
    });
  }

  async fetchnotificationcount() {
    const notification = document.querySelector("#notifications");
    const res = await fetch(notification.dataset.url);
    const json = await res.json();
    this.handleCount(json.unread_count);
  }

  handleCount(data) {
    const badge = document.getElementById('notifiable-badge');
    if (data == 0){
      badge.style.display = "none";
    }else {

      badge.style.display = "block";

      badge.innerText = data;
  }
  setTimeout(this.fetchnotificationcount.bind(this), 3000);
  }
}
let notificationHandler = new NotificationHandler(
  document.querySelector("[data-ref=notifiable-button]")
);
notificationHandler.init();
