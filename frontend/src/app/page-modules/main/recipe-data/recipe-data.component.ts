import { Component, OnInit, ViewChild } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { ModalComponent } from 'src/app/modules/modal/modal.component';
import { ModalEvent } from 'src/app/modules/modal/util/ModalEvent';
import { ModalFooterType } from 'src/app/modules/modal/util/ModalFooterType';
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

  dataFound: boolean = true;
  recipeData: Recipe;
  loading: boolean = true;
  commentsForm: FormGroup;
  ratingForm: FormGroup;
  loggedIn: boolean = false;
  ratingData: RecipeRating;
  hasAdditionalPrivileges: boolean = false;
  recipeRemovalModalFooterType: ModalFooterType = ModalFooterType.YES_NO;

  @ViewChild("recipeRemovalModal", { static: false }) recipeRemovalModal: ModalComponent;

  constructor(
    private rs: RecipeService,
    private route: ActivatedRoute,
    private ts: TitleService,
    private fb: FormBuilder,
    private ls: LoginService,
    private rcs: RecipeCommentService,
    private rrs: RecipeRatingService,
    private router: Router
  ) { }

  ngOnInit() {

    this.loading = true;
    this.loggedIn = this.ls.isUserLogged();

    if (this.loggedIn) {

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

      this.ls.getLoggedUser()
        .subscribe(res => this.hasAdditionalPrivileges = res.role.id == 2);
    }

    this.route.queryParams.subscribe(x => {
      this.rs.findById(parseInt(x.id))
      .toPromise()
      .then(res => {
        res.createdDate = new Date(res.createdDate);
        res.comments.sort((a, b) => (a.createdDate > b.createdDate) ? -1 : 1);
        this.recipeData = res;
        this.ts.setTitle(res.name);

        if (res.commentsCount < 5) {
          this.commentsForm = this.fb.group({
            "comment": ['', Validators.required]
          });
        }

      })
      .then(() => {
        if (this.loggedIn) {
          this.rrs.findUsersRating(this.route.snapshot.queryParams.id)
            .toPromise()
            .then(res => {
              if (res != null) {
                this.ratingData = res;
                this.ratingForm.controls['rating'].patchValue(res.value);
              }
            });
        }
      })
      .catch(() => this.dataFound = false)
      .finally(() => this.loading = false);
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

  public editRecipe(): void {
    this.router.navigate(["/edit-recipe"], { queryParams: { id: this.route.snapshot.queryParams.id }});
  }

  public removeRecipe(evt: ModalEvent): void {
    if (evt.approved) {
      this.rs.removeRecipe(this.route.snapshot.queryParams.id)
        .subscribe(res => {
          if (res.removed) {
            this.router.navigate(['/recipes'], {queryParams: {catalogId: this.recipeData.catalog.id}});
          }
        })
    }
  }
}
