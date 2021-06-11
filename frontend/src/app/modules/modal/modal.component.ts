import { Component, EventEmitter, HostListener, Input, OnInit, Output } from '@angular/core';
import { ModalType } from './util/ModalType';
import { modalAnimation, modalOverlayAnimation, MODAL_ANIMATION_TIME } from './util/modal-animations';
import { ModalTypeData } from './util/ModalTypeData';
import { ModalTypeDataFactory } from './util/ModalTypeDataFactory';

@Component({
  selector: 'app-modal',
  templateUrl: './modal.component.html',
  styleUrls: ['./modal.component.scss'],
  animations: [modalAnimation, modalOverlayAnimation]
})
export class ModalComponent implements OnInit {

  opened: boolean = false;
  modalTypeData: ModalTypeData;
  modalContentCentered: boolean = false;

  @Input() type: ModalType = ModalType.INFO;
  @Input() title: string = "";
  @Input() width: number = 500;

  @Output() onOpen: EventEmitter<any> = new EventEmitter<any>();
  @Output() onClose: EventEmitter<any> = new EventEmitter<any>();

  constructor() { }

  ngOnInit() {
    this.modalTypeData = new ModalTypeDataFactory().getModalTypeData(this.type);

    if (this.title != "") {
      this.modalTypeData.title = this.title;
    }
  }

  get modalStateName() { return this.opened ? "show" : "hide"; }

  public open(): void {
    this.opened = true;
    this.onOpen.emit({opened: this.opened});
  }

  public close = (): void => this.closeModal(false);


  
  closeModal(approved: boolean): void {
    this.opened = false;
    setTimeout(() => {
      this.onClose.next({
        opened: this.opened,
        approved: approved
      });
    }, MODAL_ANIMATION_TIME);
  }

  checkModalType = (name: string): boolean => this.type.toString() == name;

  @HostListener("click", ["$event"])
  private onModalClick(evt): void {
    if (evt.target.classList.contains('modal-overlay'))
      this.closeModal(false);
  }
}
