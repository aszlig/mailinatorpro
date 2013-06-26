package mailinator.manifest;

typedef BrowserAction = {
    var default_icon:String;
    var default_popup:String;
}

typedef ContentScript = {
    var matches:Array<String>;
    var js:Array<String>;
    @:optional var run_at:String;
}

typedef Background = {
    var scripts:Array<String>;
};

typedef Manifest = {
    var name:String;
    var version:String;
    var manifest_version:Int;
    @:optional var description:String;
    @:optional var icons:Map<String, String>;
    @:optional var browser_action:BrowserAction;
    @:optional var content_scripts:Array<ContentScript>;
    @:optional var background:Background;
    @:optional var options_page:String;
    @:optional var permissions:Array<String>;
    @:optional var web_accessible_resources:Array<String>;
}

class Generator
{
    var domains:List<String>;

    public function new() {}

    public function get():Manifest
    {
        return {
            name: "Mailinator Pro",
            version: "0.1",
            manifest_version: 2,
            description: "Extension for Mailinator Pro",
            icons: this.get_icons(),
            browser_action: this.get_browser_action(),
            background: {
                scripts: ["js/background.js"],
            },
            permissions: this.get_permissions(),
            // http://crbug.com/134315
            web_accessible_resources: ["img/logo48.png"],
        }
    }

    private function get_icons():Map<String, String>
    {
        var icons:Map<String, String> = new Map();
        icons.set("16", "img/logo16.png");
        icons.set("48", "img/logo48.png");
        icons.set("128", "img/logo128.png");
        return icons;
    }

    private function get_browser_action():BrowserAction
    {
        return {
            default_icon: this.get_icons().get("16"),
            default_popup: "html/popup.html",
        };
    }

    private function get_permissions():Array<String>
    {
        var perms:Array<String> = new Array();
        perms.push("notifications");
        perms.push("https://api.mailinatorpro.com/api/inbox");
        return perms;
    }

    public static function generate()
    {
        var manifest = new Generator();
        var json = haxe.Json.stringify(manifest.get());
        var out = sys.io.File.write("build/chrome/manifest.json");
        out.writeString(json);
    }
}
