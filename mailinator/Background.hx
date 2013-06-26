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
