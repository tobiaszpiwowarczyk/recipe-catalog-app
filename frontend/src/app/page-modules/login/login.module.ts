import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { LoginComponent } from './login.component';
import { LoginRoutingModule } from './login-routing.module';
import { InputModule } from 'src/app/modules/input/input.module';
import { ButtonModule } from 'src/app/modules/button/button.module';
import { ReactiveFormsModule } from '@angular/forms';
import { LoadingSpinnerModule } from 'src/app/modules/loading-spinner/loading-spinner.module';
import { RouterModule } from '@angular/router';



@NgModule({
  declarations: [LoginComponent],
  imports: [
    CommonModule,
    LoginRoutingModule,
    ReactiveFormsModule,
    InputModule,
    ButtonModule,
    LoadingSpinnerModule,
    RouterModule
  ]
})
export class LoginModule { }
