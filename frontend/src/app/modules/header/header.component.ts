import { Component, OnInit } from '@angular/core';
import { LoginService } from 'src/app/services/login.service';

@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: [
    './header.component.scss'
  ]
})
export class HeaderComponent implements OnInit {

  isLogged: boolean = false;
  fullName: string;

  constructor(
    private ls: LoginService
  ) { }

  ngOnInit() {
    this.isLogged = this.ls.isUserLogged();

    if (this.isLogged)
      this.ls.getLoggedUser().subscribe(res => this.fullName = res.firstName + " " + res.lastName);
  }


  logout(): void {
    this.ls.logout()
    .subscribe(res => {
      if (res.logout) {
        window.location.reload();
      }
    })
  }
}
