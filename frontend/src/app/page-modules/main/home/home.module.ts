import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HomeComponent } from './home.component';
import { HomeRoutingModule } from './home-routing.module';
import { LoadingSpinnerModule } from 'src/app/modules/loading-spinner/loading-spinner.module';
import { RecipeCatalogComponent } from './components/recipe-catalog/recipe-catalog.component';



@NgModule({
  declarations: [HomeComponent, RecipeCatalogComponent],
  imports: [
    CommonModule,
    HomeRoutingModule,
    LoadingSpinnerModule
  ]
})
export class HomeModule { }
