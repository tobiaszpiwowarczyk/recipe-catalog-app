import { Component, HostListener, Input, OnInit } from '@angular/core';
import { Recipe } from 'src/app/services/recipe/Recipe';
import { recipeListItemAnimation, recipeListItemHoverAnimation } from '../../util/recipes-animations';

@Component({
  selector: 'app-recipe',
  templateUrl: './recipe.component.html',
  styleUrls: ['./recipe.component.scss'],
  animations: [recipeListItemAnimation, recipeListItemHoverAnimation]
})
export class RecipeComponent implements OnInit {

  hoverState: string = "false";

  @Input() data: Recipe;

  constructor() { }

  ngOnInit() {
  }

  @HostListener("mouseover", ["$event"])
  @HostListener("mouseleave", ["$event"])
  private setHoverState(evt) {
    this.hoverState = (evt.type == "mouseover").toString();
  }
}
