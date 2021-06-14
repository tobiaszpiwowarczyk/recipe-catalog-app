import { Directive, Input, OnInit } from '@angular/core';
import { HeaderMenuItemComponent } from '../header-menu-item/header-menu-item.component';

@Directive({
  selector: 'app-header-menu-item[appHeaderMenuItemWithLink]'
})
export class HeaderMenuItemWithLinkDirective implements OnInit {

  @Input("appHeaderMenuItemWithLink") href: any[] = [];

  constructor(
    private component: HeaderMenuItemComponent
  ) {}

  ngOnInit(): void {
    this.component.withLink = true;
    this.component.href = this.href;
  }

}
