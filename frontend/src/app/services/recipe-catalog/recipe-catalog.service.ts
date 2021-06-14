import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { AbstractService } from 'src/app/util/AbstractService';
import { RecipeCatalog } from './RecipeCatalog';

@Injectable({
  providedIn: 'root'
})
export class RecipeCatalogService extends AbstractService {

  constructor(protected http: HttpClient) {
    super(http);
  }

  findAll = (): Observable<RecipeCatalog[]> => this.http.get<RecipeCatalog[]>("/api/recipe/catalog", { headers: this.headers });
  findById = (id: number): Observable<RecipeCatalog> => this.http.get<RecipeCatalog>(`/api/recipe/catalog/${id}`, {headers: this.headers});
}