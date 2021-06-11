import { AbstractControl, AsyncValidatorFn, FormControl, ValidationErrors } from "@angular/forms";
import { timer } from "rxjs";
import { map, switchMap } from "rxjs/operators";
import { User } from "../services/user/User";
import { UserService } from "../services/user/user.service";

export class EmailValidator {
    static validate = (input: AbstractControl): ValidationErrors => /^[a-zA-Z0-9\.\-\_]+@+[a-z]+\.+[a-z]{2,3}$/g.test(input.value) ? null : { emailAddressIncorrect: true };

    static checkExistence(us: UserService): AsyncValidatorFn {
        return (c: FormControl) => {
            return timer(500).pipe(
                switchMap(() => us.validateField(new User({ emailAddress: c.value }), "emailAddress")
                    .pipe(map(res => res.exists ? { emailAddressExists: true } : null))
                )
            );
        };
    }
}