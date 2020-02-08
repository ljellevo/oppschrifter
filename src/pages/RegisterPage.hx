package pages;

import js.Cookie;
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

class RegisterPage extends DynamicComponent {
  var data: Array<String> = ["Pasta", "Pizza"];
  var errorMessage: String = "";

  var usernameInputController = new InputController();
  var passwordInputController = new InputController();
  var retypePasswordInputController = new InputController();

  public function new() {}

  function login(callback:String->Void){
    var object:Dynamic;
    var req = new Http( "http://localhost:3000/api/register");

    if(usernameInputController.getValue() == "") {
      return;
    }

    if(passwordInputController.getValue() == "") {
      return;
    }

    if(passwordInputController.getValue() != retypePasswordInputController.getValue()) {
      return;
    }

    function testFunc(username: String, password: String, callback:String->Void):Void  {
      var sha = haxe.crypto.Sha256.encode(password);
      trace(sha);

      //Send username, password and random generated salt
      object = {
        username: username,
        password: sha
      };

      req.setHeader ("Content-type", "application/json");     
      req.setPostData(Json.stringify(object));
        
      req.onData = function(response:String) {   // my bound function           
          //trace(response)  // receive value - how to return it from "my_function" ?
          callback( response );
      }

      req.onError = function(error: String) {
        trace(error);
       setState(this, function() {
         errorMessage = error;
       });
      }
      req.request( true ); 	
    }

    testFunc(usernameInputController.getValue(), passwordInputController.getValue(), function(response){
      trace("Got the response via callback", response);
      Cookie.set("credentials", response, 315569260);
    });
  }

  function infoLable(): Widget {
    if(errorMessage == "Http Error #400") {
      return new Text("Brukernavn eller passord er feil");
    } else if(errorMessage != "") {
      return new Text(errorMessage);
    }
    return new Container({});
  }

  override public function component(): Page {
    page = new Page({
      route: "/register",
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
          new Center({
            margin: Margin.fromTRBL(30, 0, 0, 0),
            alignment: CenterAlignment.Both,
            child: new Container({
              shadow: [
                new Shadow({horizontal: "0px", vertical: "4px", blur: "8px", color: new Color({backgroundColor: Colors.fromString("#808080")})})
              ],
              color: new Color({backgroundColor: Colors.fromString("#fafafa")}),
              size: new Size({width: "300px"}),
              child: new Column({
                children: [
                  new Container({
                    padding: Padding.fromTRBL(30, 0, 30, 0),
                    child: new Center({
                      alignment: CenterAlignment.Both,
                      child: new Text(
                        "NY BRUKER", {
                          textSize: 40, 
                          font: new Fonts("Poppins", "sans-serif"),
                          fontWeight: FontWeight.W900,
                          color: new Color({color: Colors.fromString("#2e3440")}),
                        })
                    })
                  }),
                  infoLable(),
                  new Container({
                    padding: Padding.fromTRBL(0, 0, 30, 0),
                    child: new Center({
                      alignment: CenterAlignment.Both,
                      child: new Input({
                        type: InputType.Search, 
                        controller: usernameInputController,
                        placeholder: "Brukernavn",
                        size: new Size({
                          width: "50%",
                          maxWidth: "250px",
                        })
                      })
                    })
                  }),
                  new Container({
                    padding: Padding.fromTRBL(0, 0, 30, 0),
                    child: new Center({
                      alignment: CenterAlignment.Both,
                      child: new Input({
                        type: InputType.Password, 
                        controller: passwordInputController,
                        placeholder: "Passord",
                        size: new Size({
                          width: "50%",
                          maxWidth: "250px",
                        })
                      })
                    })
                  }),
                  new Container({
                    padding: Padding.fromTRBL(0, 0, 30, 0),
                    child: new Center({
                      alignment: CenterAlignment.Both,
                      child: new Input({
                        type: InputType.Password, 
                        controller: retypePasswordInputController,
                        placeholder: "Gjenta Passord",
                        size: new Size({
                          width: "50%",
                          maxWidth: "250px",
                        })
                      })
                    })
                  }),
                  new Container({
                    padding: Padding.fromTRBL(0, 0, 30, 0),
                    child: new Row({
                      children: [
                        new Center({
                          alignment: CenterAlignment.Both,
                          child: new Button({
                            child: new Text("Allerede bruker?"),
                            onClick: function() {
                              trace("Logg inn was clicked");
                              Navigate.to({url: "/login"});
                            }
                          })
                        }),
                        new Center({
                          alignment: CenterAlignment.Both,
                          child: new Button({
                            child: new Text("Registrer"),
                            onClick: function() {
                              trace("Logg inn was clicked");
                              login(function(token) {
                                trace("Login was successfull and token was recived");
                              });
                            }
                          })
                        })
                      ]
                    })
                  }),
                ]
              })
            })
          })
        ]
      })
    });
    return page;
  }
}