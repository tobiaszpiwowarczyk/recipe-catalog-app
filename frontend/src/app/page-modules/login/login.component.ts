import { Component, OnInit, ViewChild } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { InputComponent } from 'src/app/modules/input/input.component';
import { LoadingSpinnerComponent } from 'src/app/modules/loading-spinner/loading-spinner.component';
import { LoginService } from 'src/app/services/login.service';
import { TitleService } from 'src/app/services/title.service';
import { FormUtils } from 'src/app/util/FormUtils';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html'
})
export class LoginComponent implements OnInit {

  loginForm: FormGroup;
  loginButtonDisabled: boolean = false;
  loginError: boolean = false;

  @ViewChild(LoadingSpinnerComponent, { static: false }) spinner: LoadingSpinnerComponent;
  @ViewChild(InputComponent, {static: false}) username: InputComponent;

  constructor(
    private fb: FormBuilder,
    private ts: TitleService,
    private ls: LoginService,
    private router: Router
  ) { }

  ngOnInit() {
    this.loginForm = this.fb.group({
      username: ['', Validators.required],
      password: ['', Validators.required]
    });

    FormUtils.disableSubmitButton(this.loginForm)
      .subscribe(res => this.loginButtonDisabled = res);

    this.ts.setTitle("Zaloguj się");
  }



  public login(): void {
    if (this.loginForm.valid) {
      this.spinner.show();
      this.ls.validateUser(this.loginForm.value)
        .subscribe(res => {
          if (!res.exists) {
            this.loginError = true;
            this.loginForm.reset();
            this.username.focus();
            this.loginButtonDisabled = false;
          }
          else {
            this.ls.login(this.loginForm.value).subscribe(() => this.router.navigate(["/"]));
          }
          this.spinner.hide();
        });
    }
    else {
      FormUtils.indicateErrors(this.loginForm)
        .subscribe(res => this.loginButtonDisabled = res);
    }
  }
}
