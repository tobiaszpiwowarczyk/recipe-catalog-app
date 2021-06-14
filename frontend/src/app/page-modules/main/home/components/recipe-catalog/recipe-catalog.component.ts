import { Component, HostListener, Input, OnInit } from '@angular/core';
import { RecipeCatalog } from 'src/app/services/recipe-catalog/RecipeCatalog';
import { recipeCatalogCardAnimation, recipeCatalogHoverAnimation } from './util/recipe-catalog-animations';

@Component({
  selector: 'app-recipe-catalog',
  templateUrl: './recipe-catalog.component.html',
  styleUrls: ['./recipe-catalog.component.scss'],
  animations: [recipeCatalogCardAnimation, recipeCatalogHoverAnimation]
})
export class RecipeCatalogComponent implements OnInit {

  hoverState: string = "false";

  @Input() catalogData: RecipeCatalog;

  constructor() { }
  ngOnInit(): void {
  }


  @HostListener("mouseover", ["$event"])
  @HostListener("mouseleave", ["$event"])
  private changeHoverState(evt: MouseEvent) {
    this.hoverState = evt.type == "mouseover" ? "true" : "false";
  }
}
