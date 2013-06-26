/* Copyright (C) 2013 aszlig
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
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
