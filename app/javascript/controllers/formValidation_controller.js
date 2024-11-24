import { Controller } from '@hotwired/stimulus';
import { z } from "zod";

// Validation schema
const phoneValidation = new RegExp(
  /^(?:(?:\+|00)?(55)\s?)?(?:\(?([1-9][0-9])\)?\s?)?(?:((?:9\d|[2-9])\d{3})\-?(\d{4}))$/
);

// Minimum 8 characters, at least one uppercase letter, one lowercase letter, one number and one special character
const passwordValidation = new RegExp(
  /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$/
);

const validationSchema = z.object({
    name: z.string().min(1, { message: 'Name is required' }),
    username: z.string().min(3, { message: 'Username is required' }),
    gender: z.string().min(3, { message: 'Gender is required' }),
    email: z
      .string()
      .min(1, { message: 'Email is required' })
      .email({ message: 'Invalid email address' }),
    password: z
      .string()
      .min(6, { message: 'Must have at least 6 characters' })
      /* .regex(passwordValidation, {
        message: 'Password must include uppercase, lowercase, number, and special character',
      }), */,
    repeatPassword: z.string().min(6, { message: 'Must have at least 6 characters' }),
    phone: z.string().min(11, { message: 'Phone number is required' }),
})
  

export default class extends Controller {
  static targets = [
    'emailField', 'usernameField', 'submitButton', 'spinnerButton', 
    'passwordField', 'repeatPasswordField'
  ];

  connect() {
    this.emailFieldTarget.addEventListener('input', this.handleTyping.bind(this));
    this.usernameFieldTarget.addEventListener('input', this.handleTyping.bind(this));
    this.passwordFieldTarget.addEventListener('input', this.handleTyping.bind(this));
    this.repeatPasswordFieldTarget.addEventListener('input', this.handleTyping.bind(this));

    this.element.addEventListener('turbo:submit-start', this.handleSubmitStart.bind(this));
    this.element.addEventListener('turbo:submit-end', this.handleSubmitEnd.bind(this));
  }

  handleTyping(event) {
    const fieldName = event.target.id;
    const fieldValue = event.target.value;

    try {
      validationSchema.shape[fieldName].parse(fieldValue);
      console.log(`${fieldName} is valid`);
      // Clear any error display for this field
      this.clearError(event.target);

      const password = this.passwordFieldTarget.value;
      const repeatPassword = this.repeatPasswordFieldTarget.value;

      if (fieldName === 'repeatPassword' || fieldName === 'password') {
        if (password && repeatPassword && password !== repeatPassword) {
          this.showError(this.repeatPasswordFieldTarget, 'Passwords do not match');
        } else {
          this.clearError(this.repeatPasswordFieldTarget);
        }
      }
    } catch (error) {
      if (error instanceof z.ZodError) {
        console.error(`${fieldName} is invalid: ${error.errors[0].message}`);
        this.showError(event.target, error.errors[0].message);
      }
    }
  }

  // Utility to show error message
  showError(inputElement, message) {
    let errorElement = inputElement.nextElementSibling;
    if (!errorElement || !errorElement.classList.contains('error-message')) {
      errorElement = document.createElement('div');
      errorElement.className = 'error-message';
      inputElement.after(errorElement);
    }
    errorElement.textContent = message;
  }

  // Utility to clear error message
  clearError(inputElement) {
    const errorElement = inputElement.nextElementSibling;
    if (errorElement && errorElement.classList.contains('error-message')) {
      errorElement.remove();
    }
  }

  handleSubmitStart() {
    this.submitButtonTarget.style.display = "none";
    this.spinnerButtonTarget.style.display = "inline-flex";
  }

  handleSubmitEnd(event) {
    if (event.detail.success) {
      this.submitButtonTarget.style.display = "inline-flex";
      this.spinnerButtonTarget.style.display = "none";
    }
  }
}
