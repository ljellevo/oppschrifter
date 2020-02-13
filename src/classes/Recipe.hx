package classes;

typedef RecipeStruct = {
  _id: String,
  name: String,
  category: String,
  hasLink: Bool,
  ingredients: Array<String>,
  amounts: Array<String>,
  steps: Array<String>,
  url: String,
  tags: String,
  uploaded: Float,
  viewed: Int
} 

class Recipe {
  var id: String;
  var name: String;
  var category: String;
  var hasLink: Bool;
  var ingredients: Array<String>;
  var amounts: Array<String>;
  var steps: Array<String>;
  var url: String;
  var tags: String;
  var dbTags: String;
  var uploaded: Float;
  var viewed: Int;
  
  public function new() { }

  public function constr(name: String, category: String, hasLink: Bool, ingredients: Array<String>, amounts: Array<String>, steps: Array<String>, url: String, tags: String, ?id: String, ?uploaded: Float, ?viewed: Int) {
    this.id = id;
    this.name = name;
    this.category = category;
    this.hasLink = hasLink;
    this.ingredients = ingredients;
    this.amounts = amounts;
    this.steps = steps;
    this.url = url;
    this.tags = tags;
    this.dbTags = tags;
    this.uploaded = uploaded != null ? uploaded : Date.now().getTime();
    this.viewed = viewed != null ? viewed : 0;
  }


  public function getId(): String {
    return id;
  }

  public function getName() : String {
    return name;
  }

  public function getCategory() :String {
    return category;
  }

  public function getHasLink(): Bool {
    return hasLink;
  }

  public function getIngredients(): Array<String> {
    return ingredients;
  }

  public function getAmounts(): Array<String> {
    return amounts;
  }

  public function getSteps(): Array<String> {
    return steps;
  }

  public function getUrl(): String {
    return url;
  }

  public function getTags(): String {
    return tags;
  }

  public function getUploaded(): Float {
    return uploaded;
  }

  public function getViewed(): Int {
    return viewed;
  }

  public function incrementView() {
    viewed++;
  }

  public function toJSON(): String {
    var object = {
      name: name,
      category: category,
      hasLink: hasLink,
      ingredients: ingredients,
      amounts: amounts,
      steps: steps,
      url: url,
      tags: tags,
      dbTags: tags + " " + name + " " + category,
      uploaded: uploaded,
      viewed: viewed
    };
    return haxe.Json.stringify(object);
  }
}