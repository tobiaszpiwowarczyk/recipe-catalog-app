import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { AbstractService } from 'src/app/util/AbstractService';
import { Recipe } from './Recipe';
import { RecipeFilterData } from './RecipeFilterData';

@Injectable({
  providedIn: 'root'
})
export class RecipeService extends AbstractService {
  
  constructor(
    protected http: HttpClient
  ) {
    super(http);
  }

  public findFilteredRecipes = (filterData: RecipeFilterData): Observable<Recipe[]> => 
    this.http.post<Recipe[]>(`/api/recipe/filter`, JSON.stringify(filterData), {headers: this.headers});

  public findById = (id: number): Observable<Recipe> => this.http.get<Recipe>(`/api/recipe/${id}`, {headers: this.headers});
}
