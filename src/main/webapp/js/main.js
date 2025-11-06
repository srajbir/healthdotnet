window.addEventListener('pageshow', (event) => {
  if (event.persisted) {
    const form = document.querySelector('form');
    if (form) form.reset();
  }
});
