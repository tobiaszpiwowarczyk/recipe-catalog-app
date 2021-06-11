import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MainComponent } from './main.component';
import { MainRoutingModule } from "./main-routing.module";
import { HeaderModule } from 'src/app/modules/header/header.module';
import { ContainerModule } from 'src/app/modules/container/container.module';


@NgModule({
  declarations: [MainComponent],
  imports: [
    CommonModule,
    MainRoutingModule,
    HeaderModule,
    ContainerModule
  ]
})
export class MainModule { }
