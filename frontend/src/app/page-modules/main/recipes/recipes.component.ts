import { Component, OnInit, ViewChild } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { DropdownComponent } from 'src/app/modules/dropdown/dropdown/dropdown.component';
import { DropdownItem } from 'src/app/modules/dropdown/util/DropdownItem';
import { LoadingSpinnerComponent } from 'src/app/modules/loading-spinner/loading-spinner.component';
import { LoadingSpinnerModule } from 'src/app/modules/loading-spinner/loading-spinner.module';
import { SliderComponent } from 'src/app/modules/slider/slider.component';
import { RecipeCatalogService } from 'src/app/services/recipe-catalog/recipe-catalog.service';
import { RecipeCatalog } from 'src/app/services/recipe-catalog/RecipeCatalog';
import { Recipe } from 'src/app/services/recipe/Recipe';
import { RecipeService } from 'src/app/services/recipe/recipe.service';
import { TitleService } from 'src/app/services/title.service';
import { UserService } from 'src/app/services/user/user.service';
import { recipeListAnimation } from './util/recipes-animations';

@Component({
  selector: 'app-recipes',
  templateUrl: './recipes.component.html',
  styleUrls: ['./recipes.component.scss'],
  animations: [recipeListAnimation]
})
export class RecipesComponent implements OnInit {

  recipeCatalog: RecipeCatalog;
  filtersForm: FormGroup;
  recipeList: Recipe[];
  recipeListLoading: boolean = true;
  loading: boolean = true;
  prevId: number;

  @ViewChild('recipeCatalogFilter', {static: false}) recipeCatalogFilter: DropdownComponent;
  @ViewChild('authorFilter', { static: false }) authorFilter: DropdownComponent;
  @ViewChild('levelOfDifficultySlider', { static: false }) levelOfDifficultySlider: SliderComponent;
  @ViewChild(LoadingSpinnerComponent, { static: false }) spinner: LoadingSpinnerModule;

  constructor(
    private rcs: RecipeCatalogService,
    private route: ActivatedRoute,
    private fb: FormBuilder,
    private router: Router,
    private rs: RecipeService,
    private ts: TitleService,
    private us: UserService
  ) { }

  ngOnInit() {

    this.filtersForm = this.fb.group({
      "recipeCatalog": null,
      "author": null,
      "levelOfDifficulty": 1
    });

    this.route.queryParams.subscribe(x => {
      this.recipeList = [];
      this.loading = true;
      this.rcs.findById(x.catalogId)
        .toPromise()
        .then(res => this.recipeCatalog = res)
        .then(() => this.ts.setTitle(this.recipeCatalog.name + " - Lista przepisów"))
        .then(() => {
          this.recipeListLoading = true;
          this.rcs.findAll()
            .toPromise()
            .then(catalogs => {
              this.recipeCatalogFilter.setItems(catalogs.map((y, i) => new DropdownItem({ id: i, content: y.name, image: y.imageName, additionalData: { id: y.id } })));
              this.recipeCatalogFilter.selectItem(x.catalogId - 1);
            })
            .then(() => {
              this.us.findByRecipeCatalogId(x.catalogId)
                .subscribe(res => {
                  this.authorFilter.setItems(res.map((y, i) => new DropdownItem({ id: i, content: y.id < 0 ? "Wszyscy" : y.firstName + " " + y.lastName, additionalData: { id: y.id } })));
                  var authorIndex = this.authorFilter.items.filter(y => y.additionalData["id"] == x.authorId)[0];
                  this.authorFilter.selectItem(authorIndex != undefined && authorIndex.id > 0 ? authorIndex.id : 0);
                });
            })
            .then(() => this.filtersForm.controls['levelOfDifficulty'].patchValue(x.levelOfDifficulty || 1))
            .then(() => {
              this.rs.findFilteredRecipes({
                catalogId: parseInt(x.catalogId),
                authorId: parseInt(x.authorId) || -1,
                levelOfDifficulty: parseInt(x.levelOfDifficulty) || 1
              })
                .toPromise()
                .then(res => this.recipeList = res)
                .then(() => this.recipeListLoading = false);
            });
        })
        .finally(() => this.loading = false);
    });

    this.filtersForm.valueChanges.subscribe(res => {
      if (res.recipeCatalog == null || res.author == null)
        return;
      
      var params = { 
        catalogId: res.recipeCatalog.additionalData.id,
        levelOfDifficulty: res.levelOfDifficulty
      };

      if (res.author.additionalData.id > 0)
        params["authorId"] = res.author.additionalData.id;

      this.router.navigate(['/recipes'], { queryParams: params });
    });
  }
}
