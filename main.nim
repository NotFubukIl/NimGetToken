import puppy, json


proc TwoFA(ticket: string): string = 
    echo "> 2FA Code ?: "
    var code: string = readLine(stdin)
    var Req = Request(
        url: parseUrl("https://discord.com/api/v9/auth/mfa/totp"),
        verb: "POST",
        headers: @[Header(key: "Content-Type", value: "application/json")],
        body: "{\"code\":\"" & code & "\",\"ticket\":\"" & ticket & "\"}"
    )
    var res = fetch(Req)
    var json = parseJson(res.body)
    if not json{"token"}.isNil:
        return $json["token"]
    if not json{"message"}.isNil:
        echo "An Invalid Code Was Provided !";
        return TwoFA(ticket)


proc main(): void =
    echo ("> Mail: ?")
    var mail: string = readLine(stdin)
    echo ("> Password: ?")
    var password: string = readLine(stdin)
    var z = Request(
        url: parseUrl("https://discord.com/api/v9/auth/login"),
        verb: "POST",
        headers: @[Header(key: "Content-Type", value: "application/json")],
        body: "{\"email\":\"" & mail & "\",\"password\":\"" & password & "\"}"
    )
    var res = fetch(z)
    var json = parseJson(res.body)
    
    if not json{"token"}.isNil:
        echo ("Your Token Is " & getStr(json["token"]))

    if not json{"captcha_key"}.isNil:
        echo ("Cannot Get Token, There Is A Captcha To Do !")

    if not json{"errors"}.isNil:
        echo ("Email Or Password Is Invalid !")

    if not json{"ticket"}.isNil:
        var token = TwoFA($json["ticket"])
        echo token
    var m: string = readLine(stdin)
main()