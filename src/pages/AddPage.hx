package pages;

import haxe.Json;
import haxe.Http;
import com.vige.support.Enums.FontWeight;
import com.vige.support.Enums.InputType;
import com.vige.support.Enums.CenterAlignment;
import components.*;

import com.vige.components.*;
import com.vige.components.Input.InputController;
import com.vige.core.*;
import com.vige.utils.*;
import com.vige.support.*;
import classes.*;

class AddPage extends DynamicComponent {
  var data: Array<String> = [];
  var status: String = "";
  var newRecipe: Recipe;

  var nameInputController = new InputController();
  var categoryInputController = new InputController();
  var urlInputController = new InputController();
  var tagsInputController = new InputController();


  function addRecipe(){
    /*
    new SingleRequest({
      url: "http://localhost:3000/api/recipe",
      method: "POST",
      content: {data: newRecipe.toJSON()},
      //content: "hey",
      contentType: "application/json",
      onComplete: function(res: HttpResponse) {
        trace(res);
        setState(this, function(){
          status = "Oppskrift lastet opp";
        });
      },
      onProgress: function() {
        setState(this, function(){
          status = "Laster";
        });
      }
    }).request();
    */
    var object:Dynamic;
    var req = new Http( "http://localhost:3000/api/recipe");

    function testFunc(data:String, callback:String->Void):Void  {

      object = Json.parse(data);
      req.setHeader ("Content-type", "application/json");     
      req.setPostData(Json.stringify(object));
        
      req.onData = function(response:String) {   // my bound function           
          //trace(response)  // receive value - how to return it from "my_function" ?
          callback( response );
      }
      
      req.request( true ); 	
    }

    testFunc(newRecipe.toJSON(), function(response){
      trace("Got the response via callback", response);
    });
  }

  public function new() {}

  override public function component(): Page {
    page = new Page({
      navbar: new CustomNavbar().navbarComponent(),
      route: "/add",
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
                "NY", {
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
                controller: nameInputController,
                placeholder: "Navn på oppskrift",
                size: new Size({
                  width: "75%",
                  maxWidth: "450px",
                })
              })
            })
          }),
          new Container({
            padding: Padding.fromTRBL(0, 0, 30, 0),
            child: new Center({
              alignment: CenterAlignment.Both,
              child: new Input({
                type: InputType.Search, 
                controller: categoryInputController,
                placeholder: "Kategori",
                size: new Size({
                  width: "75%",
                  maxWidth: "450px",
                })
              })
            })
          }),
          new Container({
            padding: Padding.fromTRBL(0, 0, 30, 0),
            child: new Center({
              alignment: CenterAlignment.Both,
              child: new Input({
                type: InputType.Search, 
                controller: urlInputController,
                placeholder: "Link til oppskrift",
                size: new Size({
                  width: "75%",
                  maxWidth: "450px",
                })
              })
            })
          }),
          new Container({
            padding: Padding.fromTRBL(0, 0, 30, 0),
            child: new Center({
              alignment: CenterAlignment.Both,
              child: new Input({
                type: InputType.Search, 
                controller: tagsInputController,
                placeholder: "Stikkord",
                size: new Size({
                  width: "75%",
                  maxWidth: "450px",
                })
              })
            })
          }),
          new Container({
            padding: Padding.fromTRBL(0, 0, 30, 0),
            child: new Center({
              alignment: CenterAlignment.Both,
              child: new Button({
                child: new Text("Legg til"),
                onClick: function () {
                  trace("Added");
                  
                  if(nameInputController.getValue() == "") {
                    return;
                  }

                  if(categoryInputController.getValue() == "") {
                    return;
                  }

                  if(urlInputController.getValue() == "") {
                    return;
                  }

                  if(tagsInputController.getValue() == "") {
                    return;
                  }

                  newRecipe = new Recipe();
                  newRecipe.constr(nameInputController.getValue(), categoryInputController.getValue(), urlInputController.getValue(), tagsInputController.getValue());
                  
                  //newRecipe = new Recipe("Pasta Carbonara", "Italiensk", "http://oppskrifter.no", "middag pasta italiensk kjapp");
                  addRecipe();
                }
              })
            })
          }),
        ]
      })
    });
    return page;
  }
}