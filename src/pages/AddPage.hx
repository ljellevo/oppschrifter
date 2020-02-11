package pages;

import com.vige.support.Enums.MainAxisAlignment;
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
  var linkInputController = new InputController();
  var urlInputController = new InputController();
  var tagsInputController = new InputController();
  var ingredientInputController = new InputController();
  var amountInputController = new InputController();
  var stepInputController = new InputController();
  var stepControllers = new Array<InputController>();
  var stepAmount = 1;


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


  function generateSteps(): Array<Widget> {
    //stepControllers = [];
    var widgets: Array<Widget> = [];
    for(i in 0...stepAmount) {
      var controller = new InputController();
      if(i >= stepControllers.length) {
        stepControllers.push(controller);
      } else {
        controller = stepControllers[i];
      }
      
      widgets.push(
        new Container({
          padding: Padding.fromTRBL(0, 0, 30, 0),
          child: new Center({
            alignment: CenterAlignment.Both,
            child: new Input({
              type: InputType.Search, 
              controller: controller,
              placeholder: "Steg " + (i + 1),
              value: controller.getValue(),
              size: new Size({
                width: "75%",
                maxWidth: "450px",
              })
            })
          })
        })
      );
    }
    return widgets;
  }

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
              child: new Row({
                
                flex: true,
                size: new Size({
                  width: "75%",
                  maxWidth: "450px",
                }),
                children: [
                  new Text("Link?", {
                    size: new Size({
                      width: "10px",
                    }),
                  }),
                  new Input({
                    type: InputType.Checkbox, 
                    controller: linkInputController,
                    placeholder: "Stikkord",
                    size: new Size({
                      width: "10px",
                    }),
                  })
                ],
                mainAxisAlignment: MainAxisAlignment.Left
              }),
            }),
          }),
          //Manual entry
          new Container({
            padding: Padding.fromTRBL(30, 0, 30, 0),
            child: new Center({
              alignment: CenterAlignment.Both,
              child: new Text(
                "Ingredienser", {
                  textSize: 20, 
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
              child: new Row({
                size: new Size({
                  width: "75%",
                  maxWidth: "450px",
                }),
                children: [
                  new Input({
                    type: InputType.Search, 
                    controller: ingredientInputController,
                    placeholder: "Ingrediens",

                  }),
                  new Container({
                    size: new Size({
                      width: "20px",
                    }),
                  }),
                  new Input({
                    type: InputType.Search, 
                    controller: amountInputController,
                    placeholder: "Mengde",

                  })
                ]
              })
            })
          }),
          new Container({
            padding: Padding.fromTRBL(30, 0, 30, 0),
            child: new Center({
              alignment: CenterAlignment.Both,
              child: new Text(
                "Steg", {
                  textSize: 20, 
                  font: new Fonts("Poppins", "sans-serif"),
                  fontWeight: FontWeight.W900,
                  color: new Color({color: Colors.fromString("#2e3440")}),
                })
            })
          }),

          new Column({
            children: generateSteps()
          }),
          new Container({
            padding: Padding.fromTRBL(0, 0, 30, 0),
            child: new Center({
              alignment: CenterAlignment.Both,
              child: new Button({
                child: new Text("+"),
                onClick: function () {
                  setState(this, function(e) {
                    stepAmount++;
                  });
                }
              })
            })
          }),
          /*
          new Container({
            padding: Padding.fromTRBL(0, 0, 30, 0),
            child: new Center({
              alignment: CenterAlignment.Both,
              child: new Input({
                type: InputType.Search, 
                controller: stepInputController,
                placeholder: "Steg 1",
                size: new Size({
                  width: "75%",
                  maxWidth: "450px",
                })
              })
            })
          }),
          */
          //Url entry
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