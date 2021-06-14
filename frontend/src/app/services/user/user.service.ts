import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { AbstractService } from 'src/app/util/AbstractService';
import { User } from './User';

@Injectable({
  providedIn: 'root'
})
export class UserService extends AbstractService {
  
  constructor(protected http: HttpClient) {
    super(http);
  }

  public validateField = (user: User, fieldName: string): Observable<any> => 
    this.http.post(`/api/user/validate?field=${fieldName}`, JSON.stringify(user), { headers: this.headers });

  public createUser = (user: User): Observable<User> =>
    this.http.post<User>("/api/user", JSON.stringify(user), { headers: this.headers });

  public findByRecipeCatalogId = (recipeCatalogId: number): Observable<User[]> =>
    this.http.get<User[]>(`/api/user/recipe-catalog/${recipeCatalogId}`, { headers: this.headers });
}
