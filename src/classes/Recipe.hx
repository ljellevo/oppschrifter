package classes;

typedef RecipeStruct = {
  _id: String,
  name: String,
  category: String,
  url: String,
  tags: String,
  uploaded: Float,
  viewed: Int
} 

class Recipe {
  var id: String;
  var name: String;
  var category: String;
  var url: String;
  var tags: String;
  var dbTags: String;
  var uploaded: Float;
  var viewed: Int;
  
  public function new() { }

  public function constr(name: String, category: String, url: String, tags: String, ?id: String, ?uploaded: Float, ?viewed: Int) {
    this.id = id;
    this.name = name;
    this.category = category;
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
      url: url,
      tags: tags,
      dbTags: tags + " " + name + " " + category,
      uploaded: uploaded,
      viewed: viewed
    };
    return haxe.Json.stringify(object);
  }
}