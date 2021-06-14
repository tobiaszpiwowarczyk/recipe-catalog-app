import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute } from '@angular/router';
import { LoginService } from 'src/app/services/login.service';
import { Recipe } from 'src/app/services/recipe/Recipe';
import { RecipeService } from 'src/app/services/recipe/recipe.service';
import { TitleService } from 'src/app/services/title.service';
import { RecipeCommentService } from './services/recipe-comment.service';
import { RecipeRatingService } from './services/recipe-rating.service';
import { RecipeRating } from './util/RecipeRating';

@Component({
  selector: 'app-recipe-data',
  templateUrl: './recipe-data.component.html',
  styleUrls: ['./recipe-data.component.scss']
})
export class RecipeDataComponent implements OnInit {

  recipeData: Recipe;
  loading: boolean = true;
  commentsForm: FormGroup;
  ratingForm: FormGroup;
  loggedIn: boolean = false;
  ratingData: RecipeRating;

  constructor(
    private rs: RecipeService,
    private route: ActivatedRoute,
    private ts: TitleService,
    private fb: FormBuilder,
    private ls: LoginService,
    private rcs: RecipeCommentService,
    private rrs: RecipeRatingService
  ) { }

  ngOnInit() {

    this.loading = true;
    this.loggedIn = this.ls.isUserLogged();

    if (this.loggedIn) {
      this.commentsForm = this.fb.group({
        "comment": ['', Validators.required]
      });

      this.ratingForm = this.fb.group({
        'rating': 0
      });

      this.ratingForm.valueChanges.subscribe(res => {
        if (this.ratingData != null) {
          this.rrs.updateRating(new RecipeRating({
            id: this.ratingData.id,
            value: res.rating
          }))
            .subscribe(x => this.ratingData = x);
        }
        else {
          this.rrs.createRating(new RecipeRating({
            value: res.rating,
            recipe: {
              id: this.recipeData.id
            }
          }))
            .subscribe(x => this.ratingData = x);
        }
      });
    }

    this.route.queryParams.subscribe(x => {
      this.rs.findById(parseInt(x.id))
      .toPromise()
      .then(res => {
        res.createdDate = new Date(res.createdDate);
        res.comments.sort((a, b) => (a.createdDate > b.createdDate) ? -1 : 1);
        this.recipeData = res;
        this.ts.setTitle(res.name);
      })
      .then(() => {
        this.rrs.findUsersRating(this.route.snapshot.queryParams.id)
          .toPromise()
          .then(res => {
              this.ratingData = res;
              this.ratingForm.controls['rating'].patchValue(res.value);
          })
          .finally(() => this.loading = false);
      });
    })
  }


  public addComment(): void {
    this.rcs.createComment({
      content: this.commentsForm.controls['comment'].value,
      recipe: new Recipe({
        id: this.recipeData.id
      }),
      createdDate: new Date(),
      likes: 0,
      dislikes: 0
    })
      .subscribe(res => {
        this.recipeData.comments.unshift(res);
        this.commentsForm.reset();
      });
  }
}
