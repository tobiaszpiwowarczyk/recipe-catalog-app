import { animate, animateChild, group, query, state, style, transition, trigger } from "@angular/animations";

const bezier = "cubic-bezier(0,.8,.2,1)";
export const MODAL_ANIMATION_TIME = 500;

export const modalAnimation = trigger("modalAnimation", [
    state("show", style({
        opacity: 1,
        transform: "translate(-50%, 0) scale(1)"
    })),
    state("hide", style({
        opacity: 0,
        transform: "translate(-50%, 70%) scale(0)"
    })),

    transition("show => hide", animate(`${MODAL_ANIMATION_TIME}ms ${bezier}`)),
    transition("hide => show", animate(`${MODAL_ANIMATION_TIME}ms ${bezier}`))
]);

export const modalOverlayAnimation = trigger("modalOverlayAnimation", [
    state("show", style({
        display: "block"
    })),
    state("hide", style({
        display: "none"
    })),

    transition("show => hide", [
        group([
            query(":self", animate(`0ms ${MODAL_ANIMATION_TIME}ms ${bezier}`)),
            query("@modalAnimation", animateChild())
        ])
    ]),
    transition("hide => show", [
        group([
            query(":self", animate(`0ms ${bezier}`)),
            query("@modalAnimation", animateChild())
        ])
    ])
]);