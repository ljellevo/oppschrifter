package classes;

class Recipe {
  var name: String;
  var category: String;
  var url: String;
  var tags: String;
  var uploaded: Float;
  var viewed: Int;
  
  public function new(name: String, category: String, url: String, tags: String, ?uploaded: Float, ?viewed: Int) {
    this.name = name;
    this.category = category;
    this.url = url;
    this.tags = tags;
    this.uploaded = uploaded != null ? uploaded : Date.now().getTime();
    this.viewed = viewed != null ? viewed : 0;
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
      uploaded: uploaded,
      viewed: viewed
    };
    return haxe.Json.stringify(object);
  }
}