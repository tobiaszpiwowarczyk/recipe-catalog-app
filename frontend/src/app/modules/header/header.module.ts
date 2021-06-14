import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HeaderComponent } from './header.component';
import { ContainerModule } from '../container/container.module';
import { RouterModule } from '@angular/router';
import { HeaderMenuComponent } from './header-menu/header-menu.component';
import { HeaderMenuItemComponent } from './header-menu-item/header-menu-item.component';
import { HeaderMenuItemWithLinkDirective } from './directives/header-menu-item-with-link.directive';



@NgModule({
  declarations: [HeaderComponent, HeaderMenuComponent, HeaderMenuItemComponent, HeaderMenuItemWithLinkDirective],
  imports: [
    CommonModule,
    RouterModule,
    ContainerModule
  ],
  exports: [HeaderComponent]
})
export class HeaderModule { }
