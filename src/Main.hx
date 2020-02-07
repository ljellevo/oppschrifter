import pages.*;
import js.Browser;
import com.vige.core.*;


class Main {
  static function main() {
    var body = new Body();
    body.font("Poppins", "400");
    body.setGlobalTitle("OPPSCHRIFTER");
    
    Navigate.routes = [
      new HomePage(),
      new AddPage()
    ];

    Navigate.to({url: Browser.location.pathname, main: true});

    Browser.window.addEventListener('popstate', function(e) {
      Navigate.navigationEvent();
    });
    body.init();
  }
}

