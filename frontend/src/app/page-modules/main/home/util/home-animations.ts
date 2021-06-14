import { animateChild, query, stagger, transition, trigger } from "@angular/animations";

export const homeAnimation = trigger("homeAnimation", [
    transition("* => *", [
        query("@recipeCatalogCardAnimation", stagger(100, animateChild()), {optional: true})
    ])
]);