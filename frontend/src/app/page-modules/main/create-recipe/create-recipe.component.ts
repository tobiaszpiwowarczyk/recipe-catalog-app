import { AfterViewInit, Component, OnInit, ViewChild } from '@angular/core';
import { AbstractControl, FormBuilder, FormGroup, ValidationErrors, Validators } from '@angular/forms';
import { Router } from '@angular/router';
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
  selector: 'app-create-recipe',
  templateUrl: './create-recipe.component.html',
  styleUrls: ['./create-recipe.component.scss']
})
export class CreateRecipeComponent implements OnInit, AfterViewInit {

  recipeForm: FormGroup;
  ingredientForm: FormGroup;
  recipeCatalogList: RecipeCatalog[];
  recipe: Recipe;
  ingredientModalFooterType: ModalFooterType = ModalFooterType.OK;
  modalApprovalType: ModalType = ModalType.SUCCESS;
  createRecipeButtonDisabled: boolean = false;

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
    private rs: RecipeService
  ) { }

  ngOnInit() {

    this.recipe = new Recipe();

    if (!this.ls.isUserLogged())
      this.router.navigate(["/"]);

    this.title.setTitle("Nowy przepis");

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
      .subscribe(catalogs => {
        this.recipeCatalogFilter.setItems(
          catalogs.map((y, i) => new DropdownItem({ id: i, content: y.name, image: y.imageName, additionalData: { id: y.id } }))
        );
        this.recipeCatalogFilter.selectItem(0);
      });

    this.recipeForm.valueChanges.subscribe(res => {
      this.recipe.catalog = new RecipeCatalog({id: res.catalog.additionalData.id});
      this.recipe.name = res.name;
      this.recipe.description = res.description.replace(/\n/g, '\\n');
      this.recipe.imagePath = res.imagePath;
      this.recipe.levelOfDifficulty = res.levelOfDifficulty;
      this.recipe.creationTime = res.creationTime;
      console.log(res);
    });

    FormUtils.disableSubmitButton(this.recipeForm)
      .subscribe(res => this.createRecipeButtonDisabled = res);
  }

  ngAfterViewInit(): void {
    this.ingredientsModal.onOpen.subscribe(() => this.ingredientName.focus());
    this.recipeCreationApproveModal.onClose.subscribe(() => window.location.reload());
  }


  public createRecipe(): void {
    if (this.recipeForm.valid) {
      this.spinner.show();
      this.rs.createRecipe(this.recipe)
        .subscribe(res => {
          if (res.created) {
            this.spinner.hide();
            this.recipeCreationApproveModal.open();
          }
        });
    }
    else {
      FormUtils.indicateErrors(this.recipeForm)
        .subscribe(res => {
          this.createRecipeButtonDisabled = res;
          this.recipeForm.updateValueAndValidity();
        });
    }
  }

  public addIngredient(): void {
    this.recipe.ingredients.push(new RecipeIngredient({
      name: this.ingredientForm.value.name
    }));
    this.ingredientForm.reset();
  }

  public removeIngredient(index: number): void {
    this.recipe.ingredients.splice(index, 1);
  }

  private validateIngredient = (control: AbstractControl): ValidationErrors =>
    this.recipe.ingredients.filter(x => x.name.toLocaleLowerCase() == (control.value || "").toLowerCase()).length == 0 ? null : { ingredientExists: true };
}