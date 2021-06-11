import { ModalType } from "./ModalType";
import { ModalTypeData } from "./ModalTypeData";

export class ModalTypeDataFactory {
    private modalTypeDataList: ModalTypeData[];

    constructor() {
        this.modalTypeDataList = [
            {name: "INFO", icon: "info", title: "Informacja"},
            {name: "SUCCESS", icon: "check_circle", title: "Sukces"}
        ];
    }

    public getModalTypeData = (modalType: ModalType): ModalTypeData => this.modalTypeDataList.filter(type => type.name == ModalType[modalType])[0];
}