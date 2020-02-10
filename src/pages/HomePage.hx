package pages;

import com.vige.support.Enums.MainAxisAlignment;
import classes.Recipe;
import com.akifox.asynchttp.HttpResponse;
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
  tags: String,
  uploaded: Float,
  viewed: Int
} 




class HomePage extends DynamicComponent {
  var data: Array<Recipe> = [];

  var searchInputController = new InputController();
  var currentValue: String;
  public function new() {}

  
  function getRecipe(callback:String->Void){
    /*
    var object:Dynamic;
    var req = new Http( "http://localhost:3000/api/recipe/all");

    function request(callback:Array<RecipeStruct>->Void):Void  {
      object = {search: ""};

      req.setHeader ("Content-type", "application/json");   
      req.setPostData(Json.stringify(object));
        
      req.onData = function(response:String) {
        var recipes = [];
        var value: Array<RecipeStruct> = Json.parse(response);

        
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
    */
    new SingleRequest({
      url: "http://localhost:3000/api/recipe/" + searchInputController.getValue(),
      method: "GET",
      onComplete: function(res: HttpResponse) {
        setState(this, function(){
          var value: Array<RecipeStruct> = Json.parse(res.content);
          
          var recipes = [];
          for(i in 0...value.length) {
            recipes.push(
              new Recipe(
                value[i].name, 
                value[i].category,
                value[i].url,
                value[i].tags,
                value[i].uploaded,
                value[i].viewed
              )
            );
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
                onchange: function() {
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
                    return new Container({
                      margin: Margin.fromTRBL(0, 0, 20, 0),
                      size: new Size({
                        height: "100px",
                        width: "100%",
                      }),
                      shadow: [
                        new Shadow({horizontal: "0px", vertical: "4px", blur: "6px", color: new Color({backgroundColor: Colors.fromString("#CDCDCD")})}),
                        new Shadow({horizontal: "0px", vertical: "6px", blur: "20px", color: new Color({backgroundColor: Colors.fromString("#CDCDCD")})})
                      ],
                      child: new Text(data[iterator].getName())
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