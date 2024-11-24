/* document.addEventListener('DOMContentLoaded', () => {
  const form = document.getElementById('sign_in_form');
  const submitButton = document.getElementById('submit-button');
  const spinnerButton = document.getElementById('spinner-button');

  form.addEventListener('submit', (event) => {
    // Show spinner and hide submit button
    submitButton.style.display = 'none';
    spinnerButton.style.display = 'inline-flex';
  });

  form.addEventListener('ajax:error', () => {
    console.log("Error -----------------")
    // Hide spinner and show submit button when errors occur
    spinnerButton.style.display = 'none';
    submitButton.style.display = 'inline-flex';
  });

  form.addEventListener('ajax:success', () => {
    // Optionally reset the buttons on success
    spinnerButton.style.display = 'none';
    submitButton.style.display = 'inline-flex';
  });
}); */