package mailinator;

@:native("window.webkitNotifications")
extern class WebkitNotification
{
    static function createNotification(
        iconUrl:String,
        title:String,
        body:String
    ):WebkitNotification;

    static function createHTMLNotification(
        url:String
    ):WebkitNotification;

    public function show():Void;
    public function cancel():Void;

    public dynamic function onclick():Void;
}

class Notification
{
    private var notification:WebkitNotification;

    public function new(title:String, message:String, ?image:String)
    {
        if (image == null)
            image = "img/logo48.png"; // XXX!

        this.notification = WebkitNotification.createNotification(
            image,
            title,
            message
        );
        this.notification.onclick = this.onclick;
    }

    public dynamic function onclick():Void {}

    public inline function hide():Void
        this.notification.cancel();

    public function show(?timeout:Int):Void
    {
        this.notification.show();

        if (timeout != null) {
            haxe.Timer.delay(this.hide, timeout * 1000);
        }
    }
}
