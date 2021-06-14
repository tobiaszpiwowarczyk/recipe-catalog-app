import { Component, Input, OnInit } from '@angular/core';
import { RecipeComment } from 'src/app/services/recipe/RecipeComment';

@Component({
  selector: 'app-recipe-comment',
  templateUrl: './recipe-comment.component.html',
  styleUrls: ['./recipe-comment.component.scss']
})
export class RecipeCommentComponent implements OnInit {

  @Input() data: RecipeComment;

  constructor() { }

  ngOnInit() {
    this.data.createdDate = new Date(this.data.createdDate);
  }

}
