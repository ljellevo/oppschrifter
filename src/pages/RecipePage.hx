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

class RecipePage extends DynamicComponent {
  var data: Array<Recipe> = [];

  var searchInputController = new InputController();
  var currentValue: String;
  public function new() {}

  

  override public function component(): Page {
    
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
            padding: Padding.fromTRBL(30, 0, 30, 0),
            child: new Center({
              alignment: CenterAlignment.Both,
              child: new Text(
                "RECIPE", {
                  textSize: 40, 
                  font: new Fonts("Poppins", "sans-serif"),
                  fontWeight: FontWeight.W900,
                  color: new Color({color: Colors.fromString("#2e3440")}),
                })
            })
          }),
        ]
      })
    });
    return page;
  }
}