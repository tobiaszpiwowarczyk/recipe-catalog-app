import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { LoginService } from 'src/app/services/login.service';
import { AbstractService } from 'src/app/util/AbstractService';
import { RecipeRating } from '../util/RecipeRating';

@Injectable()
export class RecipeRatingService extends AbstractService {

  constructor(
    protected http: HttpClient,
    private ls: LoginService
  ) {
    super(http);
  }


  findUsersRating(recipeId: number): Observable<RecipeRating> {
    this.includeAccessTokenToHeaders();

    return this.http.get<RecipeRating>(`/api/recipe/rating/${recipeId}`, { headers: this.authHeaders });
  }

  updateRating = (rating: RecipeRating): Observable<RecipeRating> => 
    this.http.put<RecipeRating>("/api/recipe/rating", JSON.stringify(rating), { headers: this.authHeaders });

  createRating = (rating: RecipeRating): Observable<RecipeRating> =>
    this.http.post<RecipeRating>("/api/recipe/rating", JSON.stringify(rating), { headers: this.authHeaders });
}
