package pages;

import com.vige.support.Enums.TextAlign;
import js.Browser;
import js.html.KeyboardEvent;
import com.vige.support.Enums.MainAxisAlignment;
import classes.Recipe;
import com.akifox.asynchttp.HttpResponse;
import haxe.Json;
import com.vige.support.Enums.CrossAxisAlignment;
import com.vige.support.Enums.FontWeight;
import com.vige.support.Enums.InputType;
import com.vige.support.Enums.CenterAlignment;
import components.*;

import com.vige.components.*;
import com.vige.components.Input.InputController;
import com.vige.core.*;
import com.vige.utils.*;
import com.vige.support.*;


class HomePage extends DynamicComponent {
  var data: Array<Recipe> = [];

  var searchInputController = new InputController();
  var currentValue: String;
  public function new() {
    getRecipe(function(token) {
      trace("Login was successfull and token was recived");
    });
  }

  
  function getRecipe(callback:String->Void){

    new SingleRequest({
      url: Config.API_RECIPE + searchInputController.getValue(),
      method: "GET",
      onComplete: function(res: HttpResponse) {
        setState(this, function(){
          trace(res.content);
          var value: Array<RecipeStruct> = Json.parse(res.content);
          
          var recipes = [];
          for(i in 0...value.length) {
            var newRecipe = new Recipe();
            newRecipe.constr(
              value[i].name, 
              value[i].category,
              value[i].hasLink,
              value[i].ingredients,
              value[i].amounts,
              value[i].steps,
              value[i].url,
              value[i].tags,
              value[i]._id,
              value[i].uploaded,
              value[i].viewed
            );
            recipes.push(newRecipe);
          } 
          data = recipes;         
        });
      },
      onProgress: function() {
      },
      onError: function(error) {
      }
    }).request();
  }

  override public function component(): Page {


    Browser.window.addEventListener('keypress', function(e: KeyboardEvent) {
      if(e.keyCode == 13) {
        currentValue = searchInputController.getValue();
        getRecipe(function(token) {
          trace("Login was successfull and token was recived");
        });
      }
    });


    
    
    page = new Page({
      navbar: new CustomNavbar().navbarComponent(),
      route: "/",
      child: new Column({
        children: [
          new Container({
            padding: Padding.fromTRBL(30, 0, 30, 0),
            child: new Center({
              alignment: CenterAlignment.Both,
              child: new Text(
                "OPPSCHRIFTER", {
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

              alignment: CenterAlignment.Both,
              child: new Input({
                type: InputType.Search, 
                controller: searchInputController,
                placeholder: "Søk etter oppskrift",
                size: new Size({
                  width: "75%",
                  maxWidth: "450px",
                }),
                value: currentValue,
                onChange: function() {
                  /*
                  currentValue = searchInputController.getValue();
                  getRecipe(function(token) {
                    trace("Login was successfull and token was recived");
                  });
                  */
                }
              })
            })
          }),
          new Container({
            padding: Padding.fromTRBL(0, 0, 30, 0),
            child: new Center({
              alignment: CenterAlignment.Both,
              child: new Button({
                child: new Text("Search"),
                onClick: function() {
                  trace("Search was clicked");
                  currentValue = searchInputController.getValue();
                  getRecipe(function(token) {
                    trace("Login was successfull and token was recived");
                  });
                }
              })
            }),
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
                children: Constructors.constructRows({
                  data: data,
                  elementsInEachRow: 1,
                  elementBuilder: function(iterator) {
                    return new Action({
                      onClick: function() {
                        Navigate.to({url: "/recipe/" + data[iterator].getId()});
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
                        child: new Column({
                          children: [
                            new Row({
                              children: [
                                new Text(data[iterator].getName(), {
                                  color: new Color({color: Colors.fromString("#2e3440")}),
                                  textSize: 18
                                }),
                                new Container({
                                  //child: new Text(Std.string(data[iterator].getUploaded())),
                                  child: new Text(DateConverter.convertTimestampToString(data[iterator].getUploaded()), {textAlignment: TextAlign.Right,
                                    textSize: 18
                                  }),
                                  size: new Size({width: "110px"})
                                })
                              ],
                              flex: true,
                              mainAxisAlignment: MainAxisAlignment.Stretch,
                              crossAxisAlignment: CrossAxisAlignment.SpaceBetween,
                              equalElementWidth: false
                            }),
                            /*
                            new Container({
                              color: new Color({backgroundColor: Colors.fromString("#2e3440")}),
                              size: new Size({height: "2px"})
                            }),
                            
                            new Container({
                              size: new Size({height: "2px"})
                            }),
                            */
                            new Text(data[iterator].getCategory(), {
                              color: new Color({color: Colors.fromString("#A4A4A4")}),
                              textSize: 12
                            })
                            
                          ],
                        })
                      })
                    });
                  },
                  rowBuilder: function(children) {
                    return new Row({
                      children: children
                    });
                  }
                })
              })
            })
          }),
        ]
      })
    });
    return page;
  }
}