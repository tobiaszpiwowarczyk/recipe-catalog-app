import { animate, animateChild, query, stagger, state, style, transition, trigger } from "@angular/animations";
import { bezier } from "src/app/util/animation-utils";
import { RECIPE_CATALOG_APPPEAR_TIME, RECIPE_CATALOG_HOVER_TIME } from "../../home/components/recipe-catalog/util/recipe-catalog-animations";

export const recipeListAnimation = trigger("recipeListAnimation", [
    transition("* => show", [
        query("@recipeListItemAnimation", stagger(100, animateChild()), { optional: true })
    ])
]);

export const recipeListItemAnimation = trigger("recipeListItemAnimation", [
    transition(":enter", [
        style({ transform: "scale(0)" }),
        animate(`${RECIPE_CATALOG_APPPEAR_TIME}ms ${bezier}`)
    ]),
    transition(":leave", [
        style({ transform: "scale(1)" }),
        animate(`${RECIPE_CATALOG_APPPEAR_TIME}ms ${bezier}`)
    ])
]);

export const recipeListItemHoverAnimation = trigger("recipeListItemHoverAnimation", [
    state('true', style({ transform: "scale(1.05)" })),
    state('false', style({ transform: "scale(1)" })),

    transition("true <=> false", animate(`${RECIPE_CATALOG_HOVER_TIME}ms ${bezier}`))
])