import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RegisterComponent } from './register.component';
import { RegisterRoutingModule } from './register-routing.module';
import { InputModule } from 'src/app/modules/input/input.module';
import { ButtonModule } from 'src/app/modules/button/button.module';
import { LoadingSpinnerModule } from 'src/app/modules/loading-spinner/loading-spinner.module';
import { ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule } from "@angular/common/http";
import { ModalModule } from 'src/app/modules/modal/modal.module';



@NgModule({
  declarations: [RegisterComponent],
  imports: [
    CommonModule,
    RegisterRoutingModule,
    InputModule,
    ButtonModule,
    ModalModule,
    LoadingSpinnerModule,
    ReactiveFormsModule,
    HttpClientModule
  ]
})
export class RegisterModule { }
