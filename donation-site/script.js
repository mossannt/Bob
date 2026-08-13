const PAYMENT_ID = "YOUR-PAYMENT-USERNAME";

document.querySelector("#year").textContent = new Date().getFullYear();

document.querySelectorAll(".copy-button").forEach((button) => {
  button.addEventListener("click", async () => {
    const originalLabel = button.firstChild.textContent;
    const value = button.dataset.copy || PAYMENT_ID;

    try {
      await navigator.clipboard.writeText(value);
      button.firstChild.textContent = "Copied! ";
      button.classList.add("copied");
      const feedback = button.closest(".donation-card").querySelector(".copy-feedback");
      feedback.textContent = "Payment ID copied to your clipboard.";
      window.setTimeout(() => {
        button.firstChild.textContent = originalLabel;
        button.classList.remove("copied");
        feedback.textContent = "Replace the ID in script.js.";
      }, 2200);
    } catch (error) {
      const feedback = button.closest(".donation-card").querySelector(".copy-feedback");
      feedback.textContent = `Copy unavailable. Use: ${value}`;
    }
  });
});

document.querySelectorAll('a[href^="#"]').forEach((link) => {
  link.addEventListener("click", (event) => {
    const target = document.querySelector(link.getAttribute("href"));
    if (!target) return;
    event.preventDefault();
    target.scrollIntoView({ behavior: "smooth", block: "start" });
  });
});
