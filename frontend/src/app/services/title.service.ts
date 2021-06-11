import { Injectable } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { environment } from "../../environments/environment";


@Injectable({
  providedIn: 'root'
})
export class TitleService {

  private mainTitle: string;

  constructor(
    private title: Title
  ) {
    this.mainTitle = environment.title;
    this.title.setTitle(this.mainTitle);
  }

  public setTitle = (title: string): void => this.title.setTitle(`${this.mainTitle} - ${title}`);
}
