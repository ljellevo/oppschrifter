package pages;

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

  

  override public function component(): Page {
    if(data != null){
      page = new Page({
        navbar: new CustomNavbar().navbarComponent(),
        route: "/recipe/:id",
        child: new Column({
          children: [
            new Container({
              color: new Color({backgroundColor: Colors.CYAN}),
              size: new Size({width: "100%", height: "20px"})
            }),
            new Container({
              color: new Color({backgroundColor: Colors.RED}),
              size: new Size({width: "100%", height: "20px"})
            }),
            new Container({
              color: new Color({backgroundColor: Colors.BLUE}),
              size: new Size({width: "100%", height: "20px"})
            }),
            new Container({
              padding: Padding.fromTRBL(30, 0, 0, 0),
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
                child: new Text(data.getCategory(), {
                  color: new Color({color: Colors.fromString("#A4A4A4")})
                })
              })
            }),
            new Container({
              padding: Padding.fromTRBL(0, 0, 30, 0),
              child: new Center({
                alignment: CenterAlignment.Both,
                child: new Column({
                  size: new Size({
                    width: "75%",
                    maxWidth: "450px",
                  }),
                  children: [
                    new Action({
                      onClick: function() {
                        Navigate.link({url: data.getUrl()});
                      },
                      child: new Container({
                        color: new Color({backgroundColor: Colors.fromString("#fafafa")}),
                        margin: Margin.fromTRBL(0, 0, 20, 0),
                        size: new Size({
                          width: "100%",
                        }),
                        shadow: [
                          new Shadow({horizontal: "0px", vertical: "4px", blur: "6px", color: new Color({backgroundColor: Colors.fromString("#CDCDCD")})}),
                          new Shadow({horizontal: "0px", vertical: "0px", blur: "2px", color: new Color({backgroundColor: Colors.fromString("#CDCDCD")})})
                        ],
                        padding: Padding.all(20),
                        child: new Row({
                          flex: true,
                          children: [
                            new Image({
                              src: "./assets/pancake.jpg",
                              height: 100,
                              width: 100
                            }),
                            new Container({
                              size: new Size({width: "40px"})
                            }),
                            new Column({
                              mainAxisAlignment: MainAxisAlignment.Center,
                              crossAxisAlignment: CrossAxisAlignment.Center,
                              children: [
                                new Row({
                                  children: [
                                    new Text("godt.no", {
                                      color: new Color({color: Colors.fromString("#2e3440")}),
                                      textSize: 20
                                    }),
                                  ],
                                  flex: true,
                                  mainAxisAlignment: MainAxisAlignment.Center,
                                  crossAxisAlignment: CrossAxisAlignment.SpaceAround,
                                  equalElementWidth: false,
                                  size: new Size({height: "100%"})
                                }),
                                
                                /*
                                new Container({
                                  color: new Color({backgroundColor: Colors.fromString("#2e3440")}),
                                  size: new Size({height: "2px"})
                                }),
                                new Text(data.getUrl(), {
                                  color: new Color({color: Colors.fromString("#A4A4A4")})
                                })
                                */
                              ],

                            })
                          
                          ]
                        })
                      })
                    }),
                    new Text(data.getTags(), {
                      color: new Color({color: Colors.fromString("#A4A4A4")})
                    })
                  ]
                })
              })
            }),
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
            new Container({
              color: new Color({backgroundColor: Colors.CYAN}),
              size: new Size({width: "100%", height: "20px"})
            }),
            new Container({
              color: new Color({backgroundColor: Colors.RED}),
              size: new Size({width: "100%", height: "20px"})
            }),
            new Container({
              color: new Color({backgroundColor: Colors.BLUE}),
              size: new Size({width: "100%", height: "20px"})
            }),
          ]
        })
      });
      return page;
    }
  }
}