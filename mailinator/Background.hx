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

import mailinator.API;

class Background
{
    public static var POLL_INTERVAL = 10;

    private var poller:haxe.Timer;

    public function new()
    {
        this.poller = new haxe.Timer(Background.POLL_INTERVAL * 1000);
        this.poller.run = inline function() API.fetch_inbox(this.on_inbox);
    }

    private function on_inbox(inbox:Inbox):Void
    {
        for (message in inbox.msglist) {
            var notice:Notification = new Notification(
                message.subject,
                message.snippet
            );
            notice.show();
        }

        this.poller.stop(); // XXX: Just for testing purposes
    }

    public static function main():Void
    {
        new Background();
    }
}
