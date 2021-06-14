import { Component, OnInit } from '@angular/core';
import { RecipeCatalogService } from 'src/app/services/recipe-catalog/recipe-catalog.service';
import { RecipeCatalog } from 'src/app/services/recipe-catalog/RecipeCatalog';
import { homeAnimation } from './util/home-animations';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: [
    './home.component.scss'
  ],
  animations: [homeAnimation]
})
export class HomeComponent implements OnInit {

  recipeCatalogs: RecipeCatalog[];
  loading: boolean = true;

  constructor(
    private rcs: RecipeCatalogService
  ) {}

  ngOnInit() {
    this.rcs.findAll().subscribe(res => {
      this.recipeCatalogs = res;
      this.loading = false;
    });
  }

}
