import { EventEmitter } from "@angular/core";
import { FormGroup } from "@angular/forms";
import { Observable, Observer } from "rxjs";

export class FormUtils {
    static disableSubmitButton(form: FormGroup): Observable<boolean> {
        return new Observable((observer: Observer<boolean>) => {
            form.statusChanges.subscribe(res => {
                observer.next(res != "VALID" && Object.values(form.controls).every(x => x.dirty || x.touched));
            });
        });
    }

    static indicateErrors(form: FormGroup): Observable<boolean> {
        return new Observable((observer: Observer<boolean>) => {
            Object.values(form.controls)
                .forEach(control => {
                    control.markAsTouched();
                    (control.statusChanges as EventEmitter<any>).emit(control.status);
                    observer.next(!Object.values(form.controls).every(x => x.valid && (x.dirty || x.touched)));
                });
        });
    }
}