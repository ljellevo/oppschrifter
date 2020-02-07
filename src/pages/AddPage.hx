package pages;

import com.vige.support.Enums.FontWeight;
import com.vige.support.Enums.InputType;
import com.vige.support.Enums.CenterAlignment;
import components.*;

import com.vige.components.*;
import com.vige.core.*;
import com.vige.utils.*;
import com.vige.support.*;

class AddPage extends DynamicComponent {
  var data: Array<String> = [];

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