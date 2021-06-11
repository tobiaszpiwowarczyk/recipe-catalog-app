import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-header-menu-item',
  templateUrl: './header-menu-item.component.html',
  styleUrls: ['./header-menu-item.component.scss']
})
export class HeaderMenuItemComponent implements OnInit {

  @Input() text: string = "";
  @Input() href: any[] = [];
  @Input() icon: string = "";

  constructor() { }

  ngOnInit() {
  }

}
