import { animate, state, style, transition, trigger } from "@angular/animations";
import { bezier } from "src/app/util/animation-utils";

export const DROPDOWN_ITEM_APPEAR_TIME = 200;

export const dropdownItemListAnimation = trigger("dropdownItemListAnimation", [
    state("hide", style({
        transform: "scaleY(0)"
    })),
    state("show", style({
        transform: "scaleY(1)"
    })),
    transition("show <=> hide", animate(`${DROPDOWN_ITEM_APPEAR_TIME}ms ${bezier}`))
])