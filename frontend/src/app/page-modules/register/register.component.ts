import { Component, OnInit, ViewChild } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { LoadingSpinnerComponent } from 'src/app/modules/loading-spinner/loading-spinner.component';
import { ModalComponent } from 'src/app/modules/modal/modal.component';
import { ModalType } from 'src/app/modules/modal/util/ModalType';
import { LoginService } from 'src/app/services/login.service';
import { TitleService } from 'src/app/services/title.service';
import { User } from 'src/app/services/user/User';
import { UserService } from 'src/app/services/user/user.service';
import { FormUtils } from 'src/app/util/FormUtils';
import { EmailValidator } from 'src/app/validator/EmailValidator';
import { UsernameValidator } from 'src/app/validator/UsernameValidator';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.scss']
})
export class RegisterComponent implements OnInit {

  registerForm: FormGroup;
  registerButtonDisabled: boolean = false;
  modalType: ModalType = ModalType.SUCCESS;

  @ViewChild(LoadingSpinnerComponent, {static: false}) spinner: LoadingSpinnerComponent;
  @ViewChild(ModalComponent, {static: false}) modal: ModalComponent;

  constructor(
    private ts: TitleService,
    private fb: FormBuilder,
    private us: UserService,
    private ls: LoginService,
    private router: Router
  ) { }

  ngOnInit() {
    this.registerForm = this.fb.group({
      username: ['', Validators.compose([Validators.required]), UsernameValidator.validate(this.us)],
      password: ['', Validators.compose([Validators.required, Validators.minLength(5)])],
      firstName: ['', Validators.required],
      lastName: ['', Validators.required],
      emailAddress: ['', Validators.compose([Validators.required, EmailValidator.validate]), EmailValidator.checkExistence(this.us)]
    });


    FormUtils.disableSubmitButton(this.registerForm)
      .subscribe(res => this.registerButtonDisabled = res);

    this.ts.setTitle("Zarejestruj się");
  }


  public register(): void {
    if (this.registerForm.valid) {
      this.spinner.show();
      this.us.createUser(this.registerForm.value).subscribe(() => {
        this.spinner.hide();
        this.modal.open();
      });
    }
    else {
      FormUtils.indicateErrors(this.registerForm)
        .subscribe(res => this.registerButtonDisabled = res);
    }
  }

  public login(): void {
    this.ls.login(new User({
      username: this.registerForm.controls['username'].value,
      password: this.registerForm.controls['password'].value
    }))
      .subscribe(res => {
        // this.ls.saveToken(res.accessToken);
        this.router.navigate(["/"]);
      });
  }
}
