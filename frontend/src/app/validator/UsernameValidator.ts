import { AsyncValidatorFn, FormControl } from "@angular/forms";
import { timer } from "rxjs";
import { map, switchMap } from "rxjs/operators";
import { User } from "../services/user/User";
import { UserService } from "../services/user/user.service";

export class UsernameValidator {
    
    public static validate(us: UserService) : AsyncValidatorFn {
        return (c: FormControl) => {
            return timer(500).pipe(
                switchMap(() => us.validateField(new User({ username: c.value }), "username")
                                .pipe(map(res => res.exists ? { usernameExists: true } : null))
                )
            );
        };
    }
}