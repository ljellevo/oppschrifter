package pages;

import js.Browser;
import com.vige.support.Enums.TextAlign;
import com.vige.support.Enums.MainAxisAlignment;
import classes.Recipe;
import com.akifox.asynchttp.HttpResponse;
import haxe.Json;

import com.vige.support.Enums.CrossAxisAlignment;
import com.vige.support.Enums.FontWeight;
import com.vige.support.Enums.CenterAlignment;
import components.*;

import com.vige.components.*;
import com.vige.components.Input.InputController;
import com.vige.core.*;
import com.vige.utils.*;
import com.vige.support.*;

class RecipePage extends DynamicComponent {
  var data: Recipe;

  var searchInputController = new InputController();
  var currentValue: String;
  public function new() {}

  override public function init() {
    getRecipe();
  }

  function getRecipe(){
    new SingleRequest({
      url: "http://localhost:3000/api/recipe/" + Navigate.getParameters()[0],
      method: "GET",
      onComplete: function(res: HttpResponse) {
        setState(this, function(){
          var value: RecipeStruct = Json.parse(res.content);
          var recipe = new Recipe();
          recipe.constr(
            value.name, 
            value.category,
            value.hasLink,
            value.ingredients,
            value.amounts,
            value.steps,
            value.url,
            value.tags,
            value._id,
            value.uploaded,
            value.viewed
          );
          data = recipe;
        });
      },
      onProgress: function() {
      },
      onError: function(error) {
      }
    }).request();
  }

  function deleteRecipe(){
    new SingleRequest({
      url: "http://localhost:3000/api/recipe/" + Navigate.getParameters()[0] + "/delete",
      method: "GET",
      onComplete: function(res: HttpResponse) {
        Navigate.to({url: "/", hardRefresh: true});
      },
      onProgress: function() {
      },
      onError: function(error) {
      }
    }).request();
  }

  function isLink() {
    if(data.getHasLink()){
      return new Container({
        padding: Padding.fromTRBL(0, 0, 30, 0),
        child: new Center({
          alignment: CenterAlignment.Both,
          child: new Column({
            size: new Size({
              width: "75%",
              maxWidth: "450px",
            }),
            children: [
              new Text("Link til oppskrift", {
                color: new Color({color: Colors.fromString("#A4A4A4")})
              }),
              new Action({
                onClick: function() {
                  Navigate.link({url: data.getUrl()});
                },
                child: new Container({
                  color: new Color({backgroundColor: Colors.fromString("#fafafa")}),
                  //margin: Margin.fromTRBL(0, 0, 20, 0),
                  size: new Size({
                    width: "100%",
                    //maxWidth: "450px",
                  }),
                  shadow: [
                    new Shadow({horizontal: "0px", vertical: "4px", blur: "6px", color: new Color({backgroundColor: Colors.fromString("#CDCDCD")})}),
                    new Shadow({horizontal: "0px", vertical: "0px", blur: "2px", color: new Color({backgroundColor: Colors.fromString("#CDCDCD")})})
                  ],
                  padding: Padding.all(20),
                  child: new Row({
                    flex: true,
                    children: [
                      new Text("godt.no", {
                        color: new Color({color: Colors.fromString("#2e3440")}),
                        textSize: 20
                      }),
                    ]
                  })
                })
              }),
            ]
          })
        })
      });
    }
    return new Container({});
  }

  function generateSteps(): Widget {
    if(data.getHasLink()){
      return new Container({});
    }
    return new Container({
      child: new Column({
        children: [
          new Text("Ingredienser", {
            color: new Color({color: Colors.fromString("#A4A4A4")})
          }),
          new Column({
            children: Constructors.constructRows({
              data: data.getIngredients(),
              elementsInEachRow: 1,
              elementBuilder: function(i) {
                return new Text(" - " + data.getIngredients()[i] + " " + data.getAmounts()[i]);
              },
              rowBuilder: function(children) {
                return new Row({children: children});
              }
            })
          }),
          new Container({
            size: new Size({height: "30px"})
          }),
          new Text("Fremgangsmåte", {
            color: new Color({color: Colors.fromString("#A4A4A4")})
          }),
          new Column({
            children: Constructors.constructRows({
              data: data.getSteps(),
              elementsInEachRow: 1,
              elementBuilder: function(i) {
                return new Text(Std.string(i + 1) + ". " + data.getSteps()[i]);
              },
              rowBuilder: function(children) {
                return new Row({children: children});
              }
            })
          })
        ]
      })
    });
  }

  

  override public function component(): Page {
    if(data != null){
      page = new Page({
        
        navbar: new CustomNavbar().navbarComponent(),
        route: "/recipe/:id",

        child: new Column({          
          children: [      
            new Center({
              margin: Margin.fromTRBL(30, 0, 0, 0),
              alignment: CenterAlignment.Both,
              child: new Container({
                shadow: [
                  new Shadow({horizontal: "0px", vertical: "4px", blur: "6px", color: new Color({backgroundColor: Colors.fromString("#CDCDCD")})}),
                  new Shadow({horizontal: "0px", vertical: "6px", blur: "20px", color: new Color({backgroundColor: Colors.fromString("#CDCDCD")})})
                ],
                color: new Color({backgroundColor: Colors.fromString("#fafafa")}),
                size: new Size({
                  width: "75%",
                  maxWidth: "450px",
                }),
                padding: Padding.all(30),
                child: new Column({
                  children: [
                    new Container({
                      padding: Padding.fromTRBL(0, 0, 0, 0),
                      child: new Center({
                        alignment: CenterAlignment.Both,
                        child: new Text(
                          data.getName() != null ? data.getName() : "", {
                            textSize: 40, 
                            font: new Fonts("Poppins", "sans-serif"),
                            fontWeight: FontWeight.W900,
                            color: new Color({color: Colors.fromString("#2e3440")}),
                          })
                      })
                    }),
                    new Container({
                      padding: Padding.fromTRBL(0, 0, 30, 0),
                      child: new Center({
                        alignment: CenterAlignment.Horizontal,
                        child: new Row({
                          mainAxisAlignment: MainAxisAlignment.Center,
                          crossAxisAlignment: CrossAxisAlignment.SpacedEvenly,
                          children: [
                            new Text(data.getCategory(), {
                              color: new Color({color: Colors.fromString("#A4A4A4")})
                            }),
                            new Text(Std.string(data.getViewed() + " visninger"), {
                              color: new Color({color: Colors.fromString("#A4A4A4")})
                            }),
                            new Text(DateConverter.convertTimestampToString(data.getUploaded()), {
                              color: new Color({color: Colors.fromString("#A4A4A4")})
                            })

                          ]
                        })
                      })
                    }),
                    isLink(),
                    generateSteps(),
                  ]
                })
              })
            }),
            //
            new Center({
              
              alignment: CenterAlignment.Horizontal,
              child: new Container({
                size: new Size({
                  width: "75%",
                  maxWidth: "450px",
                }),
                margin: Margin.fromTRBL(30, 0, 0, 0),
                child:  new Text(data.getTags(), {
                  color: new Color({color: Colors.fromString("#A4A4A4")}),
                  textAlignment: TextAlign.Center
                })
              })
            }),
            new Center({
              
              alignment: CenterAlignment.Horizontal,
              child: new Button({
                margin: Margin.fromTRBL(30, 0, 0, 0),
                child: new Text("Slett oppskrift"),
                color: new Color({backgroundColor: Colors.RED, color: Colors.WHITE}),
                onClick: function() {
                  if(Browser.window.confirm("Sikker på at du vil slette oppskriften?")){
                    //True
                    deleteRecipe();
                  }
                }
              })
            })
          ]
        })
      });
      return page;
    } else {
      page = new Page({
        navbar: new CustomNavbar().navbarComponent(),
        route: "/recipe/:id",
        child: new Column({
          children: [
          ]
        })
      });
      return page;
    }
  }
}