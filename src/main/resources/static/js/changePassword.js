const newPassword = document.getElementById("newPassword")
  , confirm_Password = document.getElementById("confirmPassword");

function validatePassword() {
  if (newPassword.value != confirm_Password.value) {
    confirm_Password.setCustomValidity("New And Confirm Password Does Not Match");
    return false;
  } else {
    confirm_Password.setCustomValidity('');
    return true;
  }
}

newPassword.onchange = validatePassword;
confirm_Password.onkeyup = validatePassword;

enableSubmitButton();

function enableSubmitButton() {
  document.getElementById('submitButton').disabled = false;
  document.getElementById('loader').style.display = 'none';
}

function disableSubmitButton() {
  document.getElementById('submitButton').disabled = true;
  document.getElementById('loader').style.display = 'unset';
}

function validateChangePasswordForm() {
  const form = document.getElementById('changePasswordForm');

  for (let i = 0; i < form.elements.length; i++) {
    if (form.elements[i].value === '' && form.elements[i].hasAttribute('required')) {
      return false;
    }
  }

  if (!validatePassword()) {
    return false;
  }

  onSignup();
}