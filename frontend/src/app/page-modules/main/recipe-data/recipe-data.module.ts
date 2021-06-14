import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RecipeDataComponent } from './recipe-data.component';
import { RecipeDataRoutingModule } from './recipe-data-routing.module';
import { RatingComponent } from './components/rating/rating.component';
import { LoadingSpinnerModule } from 'src/app/modules/loading-spinner/loading-spinner.module';
import { ButtonModule } from 'src/app/modules/button/button.module';
import { ReactiveFormsModule } from '@angular/forms';
import { RecipeCommentComponent } from './components/recipe-comment/recipe-comment.component';
import { RecipeCommentService } from './services/recipe-comment.service';
import { RecipeRatingService } from './services/recipe-rating.service';



@NgModule({
  declarations: [RecipeDataComponent, RatingComponent, RecipeCommentComponent],
  imports: [
    CommonModule,
    RecipeDataRoutingModule,
    LoadingSpinnerModule,
    ButtonModule,
    ReactiveFormsModule
  ],
  providers: [RecipeCommentService, RecipeRatingService]
})
export class RecipeDataModule { }
