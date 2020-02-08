package pages;

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
  var data: Array<String> = ["Pasta", "Pizza"];

  var searchInputController = new InputController();

  public function new() {}

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
                })
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
                    return new Text(data[iteratior]);
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