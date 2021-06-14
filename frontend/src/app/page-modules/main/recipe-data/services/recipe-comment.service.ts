import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { LoginService } from 'src/app/services/login.service';
import { RecipeComment } from 'src/app/services/recipe/RecipeComment';
import { AbstractService } from 'src/app/util/AbstractService';

@Injectable()
export class RecipeCommentService extends AbstractService {

  constructor(
    protected http: HttpClient,
    private ls: LoginService
  ) {
    super(http);
  }

  public createComment = (comment: RecipeComment): Observable<RecipeComment> => {
    if (this.ls.isUserLogged() && !this.authHeaders.has(LoginService.AUTHORIZATION))
      this.authHeaders = this.authHeaders.append(LoginService.AUTHORIZATION, localStorage.getItem(LoginService.ACCESS_TOKEN));

    return this.http.post<RecipeComment>("/api/recipe/comment", JSON.stringify(comment), { headers: this.authHeaders });
  }
}
