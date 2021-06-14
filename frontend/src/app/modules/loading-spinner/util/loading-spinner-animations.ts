import { animate, animateChild, group, query, sequence, state, style, transition, trigger } from "@angular/animations";
import { bezier } from "src/app/util/animation-utils";

export const LOADING_SPINNER_APPEAR_TIME = 700;

export const loadingSpinnerShowAnimation = trigger("loadingSpinnerShowAnimation", [
    state("hide", style({
        display: "none",
        opacity: 0
    })),
    state("show", style({
        display: "block",
        opacity: 1
    })),
    transition("hide => show", group([
        animate(`0ms`, style({display: "block"})),
        animate(`${LOADING_SPINNER_APPEAR_TIME}ms 10ms ${bezier}`, style({opacity: 1})),
        query("@loadingSpinnerWidgetAnimation", animateChild())
    ])),
    transition("show => hide", sequence([
        query("@loadingSpinnerWidgetAnimation", animateChild()),
        animate(`${LOADING_SPINNER_APPEAR_TIME}ms ${bezier}`, style({ opacity: 0 })),
        animate(`0ms`, style({ display: "none" }))
    ]))
]);

export const loadingSpinnerWidgetAnimation = trigger("loadingSpinnerWidgetAnimation", [
    state("hide", style({
        transform: "translate(-50%, -50%) scale(0)"
    })),
    state("show", style({
        transform: "translate(-50%, -50%) scale(1)"
    })),
    transition("hide => show", [
        animate(`${LOADING_SPINNER_APPEAR_TIME*2}ms 100ms ${bezier}`)
    ]),
    transition("show => hide", [
        animate(`${LOADING_SPINNER_APPEAR_TIME/2}ms 100ms ${bezier}`)
    ])
]);