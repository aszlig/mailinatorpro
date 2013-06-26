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
