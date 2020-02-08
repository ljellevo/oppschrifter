package classes;

class Recipe {
  var name: String;
  var category: String;
  var url: String;
  var tags: String;
  
  public function new(name: String, category: String, url: String, tags: String) {
    this.name = name;
    this.category = category;
    this.url = url;
    this.tags = tags;
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

  public function toJSON(): String {
    var object = {
      name: name,
      category: category,
      url: url,
      tags: tags
    };
    return haxe.Json.stringify(object);
  }
}