import consumer from "channels/consumer"

consumer.subscriptions.create("NotificationsChannel", {
  connected() {
    console.log("Connected to notifications channel")
  },

  disconnected() {
    console.log("Disconnected from notifications channel")
  },

  received(data) {
    // Show a toast notification when a new post is created
    const notificationContainer = document.getElementById("notification-container")
    if (notificationContainer && data.message) {
      const toast = document.createElement("div")
      toast.className = "fixed top-4 right-4 bg-green-500 text-white px-4 py-2 rounded shadow-lg transition-opacity duration-500 ease-in-out"
      toast.textContent = data.message
      
      notificationContainer.appendChild(toast)
      
      // Remove the toast after 5 seconds
      setTimeout(() => {
        toast.classList.add("opacity-0")
        setTimeout(() => {
          toast.remove()
        }, 500)
      }, 5000)
    }
  }
});
