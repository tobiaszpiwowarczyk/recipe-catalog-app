import { ValidationErrors } from "@angular/forms";
import { ErrorMessage } from "./ErrorMessage";

export class ErrorMessageFactory {
    private errorMessages: ErrorMessage[];

    constructor() {
        this.errorMessages = [
            {name: "required", message: "To pole jest wymagane"},
            {name: "minlength", message: "Hasło powinno zawierać conajmniej $requiredLength znaków. Wprowadziłeś $actualLength znaki"},
            {name: "usernameExists", message: "Podana nazwa użytkownika już istnieje"},
            {name: "emailAddressIncorrect", message: "Podany adres e-mail jest nieprawidłowy"},
            {name: "emailAddressExists", message: "Podany adres e-mail już istnieje"}
        ];
    }

    public getErrorMessage(errors: ValidationErrors): ErrorMessage {
        var firstError = Object.keys(errors)[0];
        var value = errors[firstError];
        var message = this.errorMessages.filter(x => x.name == firstError)[0].message;
        var tagRegex = /\$[A-Za-z]+/g;

        if (tagRegex.test(message))
            message.match(tagRegex).forEach(entry => message = message.replace(entry, value[entry.substring(1)]));

        return new ErrorMessage({name: firstError, message: message});
    }
}