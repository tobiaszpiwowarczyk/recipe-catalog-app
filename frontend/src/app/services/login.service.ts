import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { AbstractService } from '../util/AbstractService';
import { User } from './user/User';

@Injectable({
  providedIn: 'root'
})
export class LoginService extends AbstractService {

  private static readonly ACCESS_TOKEN: string = "accessToken";
  private static readonly AUTHORIZATION: string = "Authorization";

  constructor(protected http: HttpClient) {
    super(http);

    if (this.isUserLogged())
      this.authHeaders = this.authHeaders.append(LoginService.AUTHORIZATION, localStorage.getItem(LoginService.ACCESS_TOKEN));
  }

  public validateUser = (user: User): Observable<any> =>
    this.http.post("/api/login/validate", JSON.stringify(user), {headers: this.headers});

  public login = (user: User): Observable<any> => 
    this.http.post("/api/login", JSON.stringify(user), { headers: this.headers }).pipe(x => this.saveToken(x));

  public logout = (): Observable<any> => this.http.delete("/api/login", {headers: this.authHeaders}).pipe(x => this.removeToken(x));

  public getLoggedUser = (): Observable<User> => {
    return this.http.get<User>("/api/login", { headers: this.authHeaders })
  };

  public isUserLogged = (): boolean => localStorage.getItem(LoginService.ACCESS_TOKEN) != null;


  private saveToken(source: Observable<any>): Observable<any> {
    source.subscribe(res => {
      localStorage.setItem(LoginService.ACCESS_TOKEN, res.accessToken);
      this.authHeaders = this.authHeaders.append(LoginService.AUTHORIZATION, res.accessToken);
    });
    return source;
  }

  private removeToken(source: Observable<any>): Observable<any> {
    source.subscribe(res => {
      if (res.logout) {
        localStorage.removeItem(LoginService.ACCESS_TOKEN);
        this.authHeaders = this.authHeaders.delete(LoginService.AUTHORIZATION);
      }
    })
    return source;
  }
}
