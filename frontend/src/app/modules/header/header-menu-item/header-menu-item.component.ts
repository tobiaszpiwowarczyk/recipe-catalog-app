import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-header-menu-item',
  templateUrl: './header-menu-item.component.html',
  styleUrls: ['./header-menu-item.component.scss']
})
export class HeaderMenuItemComponent implements OnInit {

  withLink: boolean = false;
  href: any[] = [];

  @Input() text: string = "";
  @Input() icon: string = "";

  constructor() { }

  ngOnInit() {
  }

}
