package components;

import com.vige.utils.Border;
import com.vige.support.Enums;
import js.Browser;
import com.vige.components.*;
import com.vige.core.*;
import com.vige.support.*;
import com.vige.utils.*;


class CustomNavbar extends DynamicComponent {

  public function new(){}

  
  private function homepageButton(text: String, src: String, url: String): Widget{
    function getButtonContents(text: String, src: String): Array<Widget>{
      var widgets: Array<Widget> = [];
      if(src != null && src != "") {
        if(url == "/") {
          widgets.push(new Container({size: new Size({width: null}), color: new Color({color: Colors.BLACK}), child: new Image({src: src, height: 25, resizeModifier: ResizeModifier.Height})}));
        } else {
          widgets.push(new Container({size: new Size({width: null}), color: new Color({color: Colors.BLACK}), child: new Image({src: src, height: 15, resizeModifier: ResizeModifier.Height})}));
        }  
      }
      
      if(text != null && text != "") {
        if(src != null && src != "") {
          widgets.push(new Container({size: new Size({width: "20px"})}));
        }
        widgets.push(new Text(text, {textSize: 12, color: new Color({color: Colors.fromString("#2e3440")})}));
      }
      return widgets;
    }

    function determineBorder(): Border {
      var path = Browser.location.pathname;
      if(path == url) {
        return new Border({style: BorderStyle.Solid, width: 5, color: Colors.fromString("#2e3440"), sides: BorderSides.Bottom});
      }
      return null;
    }

    return new Button({
      size: new Size({height: "40px", width: "70px"}),
      color: new Color({color: Colors.BLACK, backgroundColor: Colors.fromString("#fafafa")}),
      border: determineBorder(),
      child: new Row({
        mainAxisAlignment: MainAxisAlignment.Center,
        children: getButtonContents(text, src)
      }), 
      isLink: false,
      onClick: function (e) {
        if(url == "https://github.com/ljellevo/mist.io") {
          Navigate.link({url: url});
        }
        Navigate.to({url: url});
      }
    });
  }

  
  

  public function navbarComponent(): Navbar {
    var navbar = new Navbar({
      position: NavbarPosition.Top,
      offset: 0,
      color: new Color({backgroundColor: "#fafafa"}),
      child: new Row({
        mainAxisAlignment: MainAxisAlignment.Center,
        crossAxisAlignment: CrossAxisAlignment.SpacedEvenly,
        margin: Margin.fromTRBL(10, 0, 10, 0),
        children: [
          homepageButton("Oversikt", null, "/"),
          homepageButton("Ny", null, "/add"),
          homepageButton("Logg inn", null, "/login"),
        ],
      }),
      onComplete: function (){}
    });
    return navbar;
  }
}