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
  var isLink: Bool = false;

  var nameInputController = new InputController();
  var nameValue = "";
  var categoryInputController = new InputController();
  var categoryValue = "";
  var linkInputController = new InputController();
  var linkValue: Bool;
  var urlInputController = new InputController();
  var urlValue = "";
  var tagsInputController = new InputController();
  var tagsValue = "";

  var ingredientAmount = 1;
  var ingredientInputController = new InputController();
  var ingredientController = new Array<InputController>();
  var ingredientControllersIntermediateValues = new Array<String>();

  var amountInputController = new InputController();
  var amountController = new Array<InputController>();
  var amountControllersIntermediateValues = new Array<String>();

  var stepInputController = new InputController();
  var stepControllers = new Array<InputController>();
  var stepControllersIntermediateValues = new Array<String>();
  var stepAmount = 1;


  function addRecipe(){
    var object:Dynamic;
    var req = new Http( "http://localhost:3000/api/recipe");

    function testFunc(data:String, callback:String->Void):Void  {

      object = Json.parse(data);
      req.setHeader ("Content-type", "application/json");     
      req.setPostData(Json.stringify(object));
        
      req.onData = function(response:String) {        
        callback( response );
      }
      req.request( true ); 	
    }

    testFunc(newRecipe.toJSON(), function(response){
      Navigate.to({url: "/", hardRefresh: true});
    });
  }

  public function new() {}


  function generateIngredients(): Array<Widget> {
    //stepControllers = [];
    var widgets: Array<Widget> = [];
    for(i in 0...ingredientAmount) {
      var ingredientTempController = new InputController();
      var amountTempController = new InputController();
      var ingredientValue = "";
      var amountValue = "";
      if(i >= ingredientController.length) {
        ingredientController.push(ingredientTempController);
        amountController.push(amountTempController);
        ingredientControllersIntermediateValues.push(ingredientValue);
        amountControllersIntermediateValues.push(amountValue);
      } else {
        ingredientTempController = ingredientController[i];
        amountTempController = amountController[i];
        ingredientValue = ingredientControllersIntermediateValues[i];
        amountValue = amountControllersIntermediateValues[i];
      }
      
      widgets.push(
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
                  controller: ingredientTempController,
                  placeholder: "Ingrediens",
                  value: ingredientValue

                }),
                new Container({
                  size: new Size({
                    width: "20px",
                  }),
                }),
                new Input({
                  type: InputType.Search, 
                  controller: amountTempController,
                  placeholder: "Mengde",
                  value: amountValue

                })
              ]
            })
          })
        })
      );
    }
    return widgets;
  }

  function generateSteps(): Array<Widget> {
    //stepControllers = [];
    var widgets: Array<Widget> = [];
    for(i in 0...stepAmount) {
      var controller = new InputController();
      var value = "";
      if(i >= stepControllers.length) {
        stepControllers.push(controller);
        stepControllersIntermediateValues.push(value);
      } else {
        controller = stepControllers[i];
        value = stepControllersIntermediateValues[i];
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
              value: value,
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

  function getCorrectSection(): Widget {
    if(isLink) {
      return new Container({
        padding: Padding.fromTRBL(0, 0, 30, 0),
        child: new Center({
          alignment: CenterAlignment.Both,
          child: new Input({
            type: InputType.Search, 
            controller: urlInputController,
            placeholder: "Link til oppskrift",
            value: urlValue,
            size: new Size({
              width: "75%",
              maxWidth: "450px",
            })
          })
        })
      });
    } else {
      return new Column({
        children: [
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
          new Column({
            children: generateIngredients()
          }),
          new Container({
            padding: Padding.fromTRBL(0, 0, 30, 0),
            child: new Center({
              alignment: CenterAlignment.Both,
              child: new Button({
                child: new Text("+"),
                onClick: function () {
                  saveValues();
                  setState(this, function(e) {
                    ingredientAmount++;
                  });
                  
                }
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
                  saveValues();
                  setState(this, function(e) {
                    stepAmount++;
                  });
                }
              })
            })
          })
        ]
      });
    }
  }

  function saveValues() {
    nameValue = nameInputController.getValue();
    categoryValue = categoryInputController.getValue();
    urlValue = urlInputController.getValue();
    tagsValue = tagsInputController.getValue();
    linkValue = linkInputController.getElement().checked;
    for(i in 0...ingredientController.length){
      ingredientControllersIntermediateValues[i] = ingredientController[i].getValue();
      amountControllersIntermediateValues[i] = amountController[i].getValue();
    }

    for(i in 0...stepControllers.length){
      stepControllersIntermediateValues[i] = stepControllers[i].getValue();
    }
  }

  override public function component(): Page {
    page = new Page({
      navbar: new CustomNavbar().navbarComponent(),
      route: "/add",
      child: new Column({
        children: [
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
                value: nameValue,
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
                value: categoryValue,
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
                
                //flex: true,
                size: new Size({
                  width: "75%",
                  maxWidth: "450px",
                }),
                children: [
                  new Text("Vil du legge til en link?", {
                    size: new Size({
                      width: "10px",
                    }),
                  }),
                  new Input({
                    type: InputType.Checkbox, 
                    margin: Margin.fromTRBL(0, 0, 0, 10),
                    controller: linkInputController,
                    placeholder: "Stikkord",
                    size: new Size({
                      width: "10px",
                    }),
                    checked: linkValue,
                    onClick: function() {
                      linkValue = linkInputController.getElement().checked;
                      setState(this, function() {
                        if(isLink){
                          isLink = false;
                        } else {
                          isLink = true;
                        }

                      });
                    }
                  })
                ],
                mainAxisAlignment: MainAxisAlignment.Left
              }),
            }),
          }),
          //Manual entry
          getCorrectSection(),
          //Url entry
          
          new Container({
            padding: Padding.fromTRBL(0, 0, 30, 0),
            child: new Center({
              alignment: CenterAlignment.Both,
              child: new Input({
                type: InputType.Search, 
                controller: tagsInputController,
                placeholder: "Stikkord",
                value: tagsValue,
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
                  /*
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
*/

                  saveValues();

                  newRecipe = new Recipe();
                  newRecipe.constr(
                    nameInputController.getValue(), 
                    categoryInputController.getValue(), 
                    isLink,
                    ingredientControllersIntermediateValues,
                    amountControllersIntermediateValues,
                    stepControllersIntermediateValues,
                    urlInputController.getValue(), 
                    tagsInputController.getValue());
                  
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