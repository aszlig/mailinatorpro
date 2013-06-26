package mailinator;

extern class Stats
{
    public var reads:Int;
    public var total:Int;
    public var emailsreceived:Int;
    public var apicalls:Int;
    public var maxreads:Int;
}

extern class MessageHeader
{
    public var seconds_ago:Int;
    public var id:String;
    public var to:String;
    public var time:Int;
    public var subject:String;
    public var snippet:String;
    public var been_read:Bool;
    public var from:String;
    public var ip:String;
}

typedef Message = Dynamic;

extern class Inbox
{
    public var stats:Stats;
    public var msglist:Array<MessageHeader>;
}

class API
{
    private static var TOKEN = "<REPLACE/SCRAPE_ME>";

    private static inline function
        request<T>(name:String, params:Map<String, String>, cb:T -> Void):Void
    {
        var url:String = "https://api.mailinatorpro.com/api/" + name;
        var http:haxe.Http = new haxe.Http(url);
        http.setParameter("access_token", API.TOKEN);
        for (key in params.keys())
            http.setParameter(key, params.get(key));

        http.onData = inline function(data:String) cb(haxe.Json.parse(data));
        http.request();
    }

    public static function fetch_inbox(cb:Inbox -> Void):Void
        API.request("inbox", ["limit" => "10"], cb);

    public static function
        fetch_message(mh:MessageHeader, cb:Message -> Void):Void
        API.request("email", ["id" => mh.id], cb);
}
