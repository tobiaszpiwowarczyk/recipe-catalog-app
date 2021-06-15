import { AfterViewInit, Component, OnInit, ViewChild } from '@angular/core';
import { FormGroup, FormBuilder, Validators, AbstractControl, ValidationErrors } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { DropdownComponent } from 'src/app/modules/dropdown/dropdown/dropdown.component';
import { DropdownItem } from 'src/app/modules/dropdown/util/DropdownItem';
import { InputComponent } from 'src/app/modules/input/input.component';
import { LoadingSpinnerComponent } from 'src/app/modules/loading-spinner/loading-spinner.component';
import { ModalComponent } from 'src/app/modules/modal/modal.component';
import { ModalFooterType } from 'src/app/modules/modal/util/ModalFooterType';
import { ModalType } from 'src/app/modules/modal/util/ModalType';
import { LoginService } from 'src/app/services/login.service';
import { RecipeCatalogService } from 'src/app/services/recipe-catalog/recipe-catalog.service';
import { RecipeCatalog } from 'src/app/services/recipe-catalog/RecipeCatalog';
import { Recipe } from 'src/app/services/recipe/Recipe';
import { RecipeService } from 'src/app/services/recipe/recipe.service';
import { RecipeIngredient } from 'src/app/services/recipe/RecipeIngredient';
import { TitleService } from 'src/app/services/title.service';
import { FormUtils } from 'src/app/util/FormUtils';

@Component({
  selector: 'app-edit-recipe',
  templateUrl: './edit-recipe.component.html',
  styleUrls: ['./../create-recipe/create-recipe.component.scss']
})
export class EditRecipeComponent implements OnInit, AfterViewInit {

  recipeForm: FormGroup;
  ingredientForm: FormGroup;
  recipeCatalogList: RecipeCatalog[];
  recipe: Recipe;
  updatedRecipe: Recipe;
  ingredientModalFooterType: ModalFooterType = ModalFooterType.OK;
  modalApprovalType: ModalType = ModalType.SUCCESS;
  updateRecipeButtonDisabled: boolean = false;

  @ViewChild("recipeCatalogFilter", { static: false }) recipeCatalogFilter: DropdownComponent;
  @ViewChild("ingredientsModal", { static: false }) ingredientsModal: ModalComponent;
  @ViewChild("recipeCreationApproveModal", { static: false }) recipeCreationApproveModal: ModalComponent;
  @ViewChild("ingredientName", { static: false }) ingredientName: InputComponent;
  @ViewChild("spinner", { static: false }) spinner: LoadingSpinnerComponent;

  constructor(
    private title: TitleService,
    private rcs: RecipeCatalogService,
    private fb: FormBuilder,
    private ls: LoginService,
    private router: Router,
    private route: ActivatedRoute,
    private rs: RecipeService
  ) { }

  ngOnInit() {

    this.recipe = new Recipe();
    this.updatedRecipe = new Recipe();

    if (!this.ls.isUserLogged())
      this.router.navigate(["/"]);
    else {
      this.ls.getLoggedUser()
        .subscribe(res => {
          if (res.role.id != 2)
            this.router.navigate(["/"]);
        });
    }

    this.recipeForm = this.fb.group({
      "imagePath": ['', Validators.required],
      "catalog": null,
      "levelOfDifficulty": 1,
      "creationTime": ['', Validators.compose([Validators.required, Validators.min(0)])],
      "name": ['', Validators.required],
      "description": ['', Validators.required]
    });

    this.ingredientForm = this.fb.group({
      "name": ['', Validators.compose([Validators.required, this.validateIngredient])]
    });

    this.rcs.findAll()
      .toPromise()
      .then(catalogs => {
        this.recipeCatalogFilter.setItems(
          catalogs.map((y, i) => new DropdownItem({ id: i, content: y.name, image: y.imageName, additionalData: { id: y.id } }))
        );
      })
      .then(() => {
        this.rs.findById(this.route.snapshot.queryParams.id)
          .subscribe(res => {
            this.recipe = res;
            this.title.setTitle(this.recipe.name + " - Modyfikuj przepis");

            this.recipeForm.patchValue({
              "imagePath": this.recipe.imagePath,
              "catalog": this.recipeCatalogFilter.getItemByAdditionalData("id", this.recipe.catalog.id),
              "levelOfDifficulty": this.recipe.levelOfDifficulty,
              "creationTime": this.recipe.creationTime,
              "name": this.recipe.name,
              "description": this.recipe.description.replace(/\\n/g, "\n")
            });
          });
      });

    this.recipeForm.valueChanges.subscribe(res => {
      this.updatedRecipe.id = this.route.snapshot.queryParams.id;
      this.updatedRecipe.catalog = new RecipeCatalog({ id: res.catalog.additionalData.id });
      this.updatedRecipe.name = res.name;
      this.updatedRecipe.description = res.description.replace(/\n/g, '\\n'),
      this.updatedRecipe.imagePath = res.imagePath;
      this.updatedRecipe.levelOfDifficulty = res.levelOfDifficulty;
      this.updatedRecipe.creationTime = res.creationTime;
    });

    FormUtils.disableSubmitButton(this.recipeForm)
      .subscribe(res => {
        this.updateRecipeButtonDisabled = res;
        console.log(res);
      });
  }


  ngAfterViewInit(): void {
    this.ingredientsModal.onOpen.subscribe(() => this.ingredientName.focus());
    this.recipeCreationApproveModal.onClose.subscribe(() => {
      this.router.navigate(['/recipe-data'], {queryParams: {id: this.route.snapshot.queryParams.id}});
    });
  }

  public updateRecipe() {
    if (this.recipeForm.valid) {
      this.updatedRecipe.ingredients = this.recipe.ingredients;

      console.log(this.updatedRecipe);
      this.spinner.show();
      this.rs.updateRecipe(this.updatedRecipe)
        .subscribe(res => {
          if (res.updated) {
            this.spinner.hide();
            this.recipeCreationApproveModal.open();
          }
        });
    }
    else {
      FormUtils.indicateErrors(this.recipeForm)
        .subscribe(res => {
          this.updateRecipeButtonDisabled = res;
          this.recipeForm.updateValueAndValidity();
        });
    }
  }


  public addIngredient(): void {
    this.recipe.ingredients.push(new RecipeIngredient({
      name: this.ingredientForm.value.name,
      recipe: {id: this.recipe.id}
    }));
    this.ingredientForm.reset();
  }

  public removeIngredient(index: number): void {
    this.recipe.ingredients.splice(index, 1);
  }


  private validateIngredient = (control: AbstractControl): ValidationErrors =>
    this.recipe.ingredients.filter(x => x.name.toLocaleLowerCase() == (control.value || "").toLowerCase()).length == 0 ? null : { ingredientExists: true };
}
