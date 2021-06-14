import { animate, state, style, transition, trigger } from "@angular/animations";
import { bezier } from "src/app/util/animation-utils";

export const RECIPE_CATALOG_APPPEAR_TIME = 700;
export const RECIPE_CATALOG_HOVER_TIME = 200;

export const recipeCatalogCardAnimation = trigger("recipeCatalogCardAnimation", [
    transition(":enter", [
        style({transform: "scale(0)"}),
        animate(`${RECIPE_CATALOG_APPPEAR_TIME}ms ${bezier}`)
    ]),
    transition(":leave", [
        style({transform: "scale(1)"}),
        animate(`${RECIPE_CATALOG_APPPEAR_TIME}ms ${bezier}`)
    ])
]);


export const recipeCatalogHoverAnimation = trigger("recipeCatalogHoverAnimation", [
    state('true', style({ transform: "scale(1.05)" })),
    state('false', style({ transform: "scale(1)" })),
    
    transition("true <=> false", animate(`${RECIPE_CATALOG_HOVER_TIME}ms ${bezier}`))
])