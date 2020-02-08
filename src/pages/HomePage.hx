package pages;

import haxe.Json;
import haxe.Http;
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

typedef RecipeStruct = {
  _id: String,
  name: String,
  category: String,
  url: String,
  tags: String
} 

class HomePage extends DynamicComponent {
  var data: Array<RecipeStruct> = [];

  var searchInputController = new InputController();

  public function new() {}

  function getRecipe(callback:String->Void){
    var object:Dynamic;
    var req = new Http( "http://localhost:3000/api/recipe/all");

    function request(callback:Array<RecipeStruct>->Void):Void  {
      object = {search: ""};

      req.setHeader ("Content-type", "application/json");   
      req.setPostData(Json.stringify(object));
        
      req.onData = function(response:String) {
        var recipes = [];
        var value: Array<RecipeStruct> = Json.parse(response);
        /*
        for(i in 0...value.length) {
          recipes.push(value[i])
        }
        */
        
        callback( value );
      }
      
      req.request( true ); 	
    }

    request(function(value: Array<RecipeStruct>){
      trace("Got the response via callback", value);
      setState(this, function() {
        data = value;
      });
    });
  }

  override public function component(): Page {
    page = new Page({
      navbar: new CustomNavbar().navbarComponent(),
      route: "/",
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
                onchange: function() {
                  getRecipe(function(token) {
                    trace("Login was successfull and token was recived");
                  });
                }
              })
            })
          }),
          new Container({
            padding: Padding.fromTRBL(30, 0, 30, 0),
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
                  elementBuilder: function(iteratior) {
                    return new Text(data[iteratior].name);
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
          new Center({
            alignment: CenterAlignment.Both,
            child: new Button({
              child: new Text("Search"),
              onClick: function() {
                trace("Search was clicked");
                getRecipe(function(token) {
                  trace("Login was successfull and token was recived");
                });
              }
            })
          })
        ]
      })
    });
    return page;
  }
}