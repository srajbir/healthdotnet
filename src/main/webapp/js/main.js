window.addEventListener('pageshow', (event) => {
  const form = document.querySelector('form');
  if (!form) return;

  // Always reset on back-forward cache restore
  if (event.persisted) {
    form.reset();
  } else {
    // Also reset if reloaded normally
    form.reset();
  }
});
