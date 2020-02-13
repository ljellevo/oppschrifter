import com.vige.utils.Colors;
import com.vige.utils.Color;
import haxe.Http;
import js.Cookie;
import pages.*;
import js.Browser;
import com.vige.core.*;


class Main {
  static function main() {
    var body = new Body();
    body.font("Poppins", "400");
    body.setGlobalTitle("OPPSCHRIFTER");

    function auth(callback:String->Void){
      var object:Dynamic;
      var req = new Http(Config.API_AUTH);
  
      function request(callback:String->Void):Void  {
        req.setHeader("Authorization", "Bearer" + Cookie.get("credentials"));          
        req.onData = function(response:String) {     
          callback( response );
        }
        req.request(true); 	
      }
  
      request(function(response){
        trace("Got the response via callback", response);
        if(response == "true") {
          callback(response);
        }
      });
    }

    
    auth(function(token) {
      Navigate.routes = [
        new HomePage(),
        new AddPage(),
        new RecipePage()

      ];
  
      Navigate.to({url: Browser.location.pathname, main: true});
  
      Browser.window.addEventListener('popstate', function(e) {
        Navigate.navigationEvent();
      });
      body.globalBackgroundColor(new Color({backgroundColor: Colors.fromString("#fafafa")}));
      body.init();
    });
    
    Navigate.routes = [
      new LoginPage(),
      new RegisterPage()
    ];

    Navigate.to({url: Browser.location.pathname, main: true});

    Browser.window.addEventListener('popstate', function(e) {
      Navigate.navigationEvent();
    });
    body.init();
  }
}

