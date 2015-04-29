--
-- lovebird
--
-- Copyright (c) 2014, rxi
--
-- This library is free software; you can redistribute it and/or modify it
-- under the terms of the MIT license. See LICENSE for details.
--

local socket = require "socket"

local lovebird = { _version = "0.3.0" }

lovebird.loadstring = loadstring or load
lovebird.inited = false
lovebird.host = "*"
lovebird.buffer = ""
lovebird.lines = {}
lovebird.pages = {}

lovebird.wrapprint = true
lovebird.timestamp = true
lovebird.allowhtml = false
lovebird.echoinput = true
lovebird.port = 8000
lovebird.whitelist = { "127.0.0.1", "192.168.*.*" }
lovebird.maxlines = 200
lovebird.updateinterval = .5

print("Loaded WebConsole on port " .. lovebird.port)

lovebird.pages["index"] = [[
<?lua
-- Handle console input
if req.parsedbody.input then
  local str = req.parsedbody.input
  if lovebird.echoinput then
    lovebird.pushline({ type = 'input', str = str })
  end
  xpcall(function() assert(lovebird.loadstring(str, "input"))() end,
         lovebird.onerror)
end
?>

<!doctype html>
<html>
  <head>
  <meta http-equiv="x-ua-compatible" content="IE=Edge"/>
  <title>VideahEngine WebConsole</title>
  <style>
    body { 
      margin: 0px;
      font-size: 14px;
      font-family: helvetica, verdana, sans;
      background: #FFFFFF;
    }
    form {
      margin-bottom: 0px;
    }
    .timestamp {
      color: #909090;
      padding-right: 4px;
    }
    .repeatcount {
      color: #F0F0F0;
      background: #505050;
      font-size: 11px;
      font-weight: bold;
      text-align: center;
      padding-left: 4px;
      padding-right: 4px;
      padding-top: 0px;
      padding-bottom: 0px;
      border-radius: 7px;
      display: inline-block;
    }
    .errormarker {
      color: #F0F0F0;
      background: #8E0000;
      font-size: 11px;
      font-weight: bold;
      text-align: center;
      border-radius: 8px;
      width: 17px;
      padding-top: 0px;
      padding-bottom: 0px;
      display: inline-block;
    }
    .greybordered {
      margin: 12px;
      background: #F0F0F0;
      border: 1px solid #E0E0E0;
      border-radius: 3px;
    }
    .inputline {
      font-family: mono, courier;
      font-size: 13px;
      color: #606060;
    }
    .inputline:before {
      content: '\00B7\00B7\00B7';
      padding-right: 5px;
    }
    .errorline {
      color: #8E0000;
    }
    #header {
      background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAFAAAABQCAIAAAABc2X6AAABpUlEQVR4nOXawW7CMBAE0KmvqJ9QVf3/z6u499CqpSiQ2Nn1zoy5QE7WQ5DYs/Py9v6Bitfl8lqybqta+Hr9LFm3oe7LLjG377d1zO330yLmdnuxgrndXdub78FwN2+AYW3eBsPX/BAMU/MzMBzNO2DYmffB8DIfAsPIfBQMF3MHGBbmPjD0zd1giJtHwFA2D4Ihax4HQ9N8CgxB81kw1MwBYEiZY8DQMYeBIWKOBEPBHAwGvTkeDG5zChjE5iwwWM2JYFCac8HgM6eDQWaeAQaTeRIYNOZ5YHCYp4JBYJ4NRrW5AIxSc6vqS5UV01DXESsx//yk1zH//YcXMf+7aa1gvr9L25s3Hkve5u3nsLH54cbD1fxsp2Vp3tla+pn399Jm5kOHByfz0dOSjbnjeOhh7jsPG5i7AwB180jiIW0ejHh0zeOZlqj5VIinaD6bWsqZA2JaLXNMLi1kDgviVcyRkwcJc/Cohd8cP1siN6cM05jNWdNDWnPiuJTTnDsfJjSnD8TZzDMaAFTmSZUHHvO8jgeJeWqphcE8u8VTbi6oLdWavwB4Xu4gQW8MRQAAAABJRU5ErkJggg==');
      height: 25px;
      color: #F0F0F0;
      padding: 9px
    }
    #title {
      float: left;
      font-size: 20px;
    }
    #title a {
      color: #F0F0F0;
      text-decoration: none;
    }
    #title a:hover {
      color: #FFFFFF;
    }
    #version {
      font-size: 10px;
    }
    #status {
      float: right;
      font-size: 14px;
      padding-top: 4px;
    }
    #main a {
      color: #000000;
      text-decoration: none;
      background: #E0E0E0;
      border: 1px solid #D0D0D0;
      border-radius: 3px;
      padding-left: 2px;
      padding-right: 2px;
      display: inline-block;
    }
    #main a:hover {
      background: #D0D0D0;
      border: 1px solid #C0C0C0;
    }
    #console {
      position: absolute;
      top: 40px; bottom: 0px; left: 0px; right: 312px;
    }
    #input {
      position: absolute;
      margin: 10px;
      bottom: 0px; left: 0px; right: 0px;
    }
    #inputbox {
      width: 100%;
      font-family: mono, courier;
      font-size: 13px;
    }
    #output {
      overflow-y: scroll;
      position: absolute;
      margin: 10px;
      line-height: 17px;
      top: 0px; bottom: 36px; left: 0px; right: 0px;
    }
    #env {
      position: absolute;
      top: 40px; bottom: 0px; right: 0px;
      width: 300px;
    }
    #envheader {
      padding: 5px;
      background: #E0E0E0;
    }
    #envvars {
      position: absolute;
      left: 0px; right: 0px; top: 25px; bottom: 0px;
      margin: 10px;
      overflow-y: scroll;
      font-size: 12px;
    }
  </style>
  </head>
  <body>
    <div id="header">
      <div id="title">
        <img id="headerImage" src="data:image/png;base64,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">
        <!-- <a href="https://github.com/rxi/lovebird">lovebird</a> -->
        <!-- <span id="version"><?lua echo(lovebird._version) ?></span> -->
      </div>
      <div id="status"></div>
    </div>
    <div id="main">
      <div id="console" class="greybordered">
        <div id="output"> <?lua echo(lovebird.buffer) ?> </div>
        <div id="input">
          <form method="post" 
                onkeydown="return onInputKeyDown(event);"
                onsubmit="onInputSubmit(); return false;">
            <input id="inputbox" name="input" type="text"></input>
          </form>
        </div>
      </div>
      <div id="env" class="greybordered">
        <div id="envheader"></div>
        <div id="envvars"></div>
      </div>
    </div>
    <script>
      document.getElementById("inputbox").focus();

      var changeFavicon = function(href) {
        var old = document.getElementById("favicon");
        if (old) document.head.removeChild(old);
        var link = document.createElement("link");
        link.id = "favicon";
        link.rel = "shortcut icon";
        link.href = href;
        document.head.appendChild(link);
      }

      var truncate = function(str, len) {
        if (str.length <= len) return str;
        return str.substring(0, len - 3) + "...";
      }

      var geturl = function(url, onComplete, onFail) {
        var req = new XMLHttpRequest();
        req.onreadystatechange = function() {
          if (req.readyState != 4) return;
          if (req.status == 200) {
            if (onComplete) onComplete(req.responseText);
          } else {
            if (onFail) onFail(req.responseText);
          }
        }
        url += (url.indexOf("?") > -1 ? "&_=" : "?_=") + Math.random();
        req.open("GET", url, true);
        req.send();
      }

      var divContentCache = {}
      var updateDivContent = function(id, content) {
        if (divContentCache[id] != content) {
          document.getElementById(id).innerHTML = content;
          divContentCache[id] = content
          return true;
        }
        return false;
      }

      var onInputSubmit = function() {
        var b = document.getElementById("inputbox");
        var req = new XMLHttpRequest();
        req.open("POST", "/", true);
        req.send("input=" + encodeURIComponent(b.value));
        /* Do input history */
        if (b.value && inputHistory[0] != b.value) {
          inputHistory.unshift(b.value);
        }
        inputHistory.index = -1;
        /* Reset */
        b.value = "";
        refreshOutput();
      }

      /* Input box history */
      var inputHistory = [];
      inputHistory.index = 0;
      var onInputKeyDown = function(e) {
        var key = e.which || e.keyCode;
        if (key != 38 && key != 40) return true;
        var b = document.getElementById("inputbox");
        if (key == 38 && inputHistory.index < inputHistory.length - 1) {
          /* Up key */
          inputHistory.index++;
        }
        if (key == 40 && inputHistory.index >= 0) {
          /* Down key */
          inputHistory.index--;
        }
        b.value = inputHistory[inputHistory.index] || "";
        b.selectionStart = b.value.length;
        return false;
      }

      /* Output buffer and status */
      var refreshOutput = function() {
        geturl("/buffer", function(text) {
          updateDivContent("status", "connected &#9679;");
          if (updateDivContent("output", text)) {
            var div = document.getElementById("output"); 
            div.scrollTop = div.scrollHeight;
          }
          /* Update favicon */
          changeFavicon("data:image/png;base64," + 
"iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAAP1BMVEUAAAAAAAAAAAD////19fUO"+
"Dg7v7+/h4eGzs7MlJSUeHh7n5+fY2NjJycnGxsa3t7eioqKfn5+QkJCHh4d+fn7zU+b5AAAAAnRS"+
"TlPlAFWaypEAAABRSURBVBjTfc9HDoAwDERRQ+w0ern/WQkZaUBC4e/mrWzppH9VJjbjZg1Ii2rM"+
"DyR1JZ8J0dVWggIGggcEwgbYCRbuPRqgyjHNpzUP+39GPu9fgloC5L9DO0sAAAAASUVORK5CYII="
          );
        },
        function(text) {
          updateDivContent("status", "disconnected &#9675;");
          /* Update favicon */
          changeFavicon("data:image/png;base64," + 
"iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAAYFBMVEUAAAAAAAAAAADZ2dm4uLgM"+
"DAz29vbz8/Pv7+/h4eHIyMiwsLBtbW0lJSUeHh4QEBDn5+fS0tLDw8O0tLSioqKfn5+QkJCHh4d+"+
"fn5ycnJmZmZgYGBXV1dLS0tFRUUGBgZ0He44AAAAAnRSTlPlAFWaypEAAABeSURBVBjTfY9HDoAw"+
"DAQD6Z3ey/9/iXMxkVDYw0g7F3tJReosUKHnwY4pCM+EtOEVXrb7wVRA0dMbaAcUwiVeDQq1Jp4a"+
"xUg5kE0ooqZu68Di2Tgbs/DiY/9jyGf+AyFKBAK7KD2TAAAAAElFTkSuQmCC"
          );
        });
      }
      setInterval(refreshOutput,
                  <?lua echo(lovebird.updateinterval) ?> * 1000);

      /* Environment variable view */
      var envPath = "";
      var refreshEnv = function() {
        geturl("/env.json?p=" + envPath, function(text) { 
          var json = eval("(" + text + ")");

          /* Header */
          var html = "<a href='#' onclick=\"setEnvPath('')\">env</a>";
          var acc = "";
          var p = json.path != "" ? json.path.split(".") : [];
          for (var i = 0; i < p.length; i++) {
            acc += "." + p[i];
            html += " <a href='#' onclick=\"setEnvPath('" + acc + "')\">" +
                    truncate(p[i], 10) + "</a>";
          }
          updateDivContent("envheader", html);

          /* Handle invalid table path */
          if (!json.valid) {
            updateDivContent("envvars", "Bad path");
            return;
          }

          /* Variables */
          var html = "<table>";
          for (var i = 0; json.vars[i]; i++) {
            var x = json.vars[i];
            var fullpath = (json.path + "." + x.key).replace(/^\./, "");
            var k = truncate(x.key, 15);
            if (x.type == "table") {
              k = "<a href='#' onclick=\"setEnvPath('" + fullpath + "')\">" +
                  k + "</a>";
            }
            var v = "<a href='#' onclick=\"insertVar('" +
                    fullpath.replace(/\.(-?[0-9]+)/g, "[$1]") +
                    "');\">" + x.value + "</a>"
            html += "<tr><td>" + k + "</td><td>" + v + "</td></tr>";
          }
          html += "</table>";
          updateDivContent("envvars", html);
        });
      }
      var setEnvPath = function(p) { 
        envPath = p;
        refreshEnv();
      }
      var insertVar = function(p) {
        var b = document.getElementById("inputbox");
        b.value += p;
        b.focus();
      }
      setInterval(refreshEnv, <?lua echo(lovebird.updateinterval) ?> * 1000);
    </script>
  </body>
</html>
]]


lovebird.pages["buffer"] = [[ <?lua echo(lovebird.buffer) ?> ]]


lovebird.pages["env.json"] = [[
<?lua 
  local t = _G
  local p = req.parsedurl.query.p or ""
  p = p:gsub("%.+", "%."):match("^[%.]*(.*)[%.]*$")
  if p ~= "" then
    for x in p:gmatch("[^%.]+") do
      t = t[x] or t[tonumber(x)]
      -- Return early if path does not exist
      if type(t) ~= "table" then
        echo('{ "valid": false, "path": ' .. string.format("%q", p) .. ' }')
        return
      end
    end
  end
?>
{
  "valid": true,
  "path": "<?lua echo(p) ?>",
  "vars": [
    <?lua 
      local keys = {}
      for k in pairs(t) do 
        if type(k) == "number" or type(k) == "string" then
          table.insert(keys, k)
        end
      end
      table.sort(keys, lovebird.compare)
      for _, k in pairs(keys) do 
        local v = t[k]
    ?>
      { 
        "key": "<?lua echo(k) ?>",
        "value": <?lua echo( 
                          string.format("%q",
                            lovebird.truncate(
                              lovebird.htmlescape(
                                tostring(v)), 26))) ?>,
        "type": "<?lua echo(type(v)) ?>",
      },
    <?lua end ?>
  ]
}
]]



function lovebird.init()
  -- Init server
  lovebird.server = assert(socket.bind(lovebird.host, lovebird.port))
  lovebird.addr, lovebird.port = lovebird.server:getsockname()
  lovebird.server:settimeout(0)
  -- Wrap print
  lovebird.origprint = print
  if lovebird.wrapprint then
    local oldprint = print
    print = function(...)
      oldprint(...)
      lovebird.print(...)
    end
  end
  -- Compile page templates
  for k, page in pairs(lovebird.pages) do
    lovebird.pages[k] = lovebird.template(page, "lovebird, req", 
                                          "pages." .. k)
  end
  lovebird.inited = true
end


function lovebird.template(str, params, chunkname)
  params = params and ("," .. params) or ""
  local f = function(x) return string.format(" echo(%q)", x) end
  str = ("?>"..str.."<?lua"):gsub("%?>(.-)<%?lua", f)
  str = "local echo " .. params .. " = ..." .. str
  local fn = assert(lovebird.loadstring(str, chunkname))
  return function(...)
    local output = {}
    local echo = function(str) table.insert(output, str) end
    fn(echo, ...)
    return table.concat(lovebird.map(output, tostring))
  end
end


function lovebird.map(t, fn)
  local res = {}
  for k, v in pairs(t) do res[k] = fn(v) end
  return res
end


function lovebird.trace(...)
  local str = "[lovebird] " .. table.concat(lovebird.map({...}, tostring), " ")
  print(str)
  if not lovebird.wrapprint then lovebird.print(str) end
end


function lovebird.unescape(str)
  local f = function(x) return string.char(tonumber("0x"..x)) end
  return (str:gsub("%+", " "):gsub("%%(..)", f))
end


function lovebird.parseurl(url)
  local res = {}
  res.path, res.search = url:match("/([^%?]*)%??(.*)")
  res.query = {}
  for k, v in res.search:gmatch("([^&^?]-)=([^&^#]*)") do
    res.query[k] = lovebird.unescape(v)
  end
  return res
end


function lovebird.htmlescape(str)
  return str:gsub("<", "&lt;")
end


function lovebird.truncate(str, len)
  if #str <= len then
    return str
  end
  return str:sub(1, len - 3) .. "..."
end


function lovebird.compare(a, b)
  local na, nb = tonumber(a), tonumber(b)
  if na then
    if nb then return na < nb end
    return false
  elseif nb then
    return true
  end
  return tostring(a) < tostring(b)
end


function lovebird.checkwhitelist(addr)
  if lovebird.whitelist == nil then return true end
  for _, a in pairs(lovebird.whitelist) do
    local ptn = "^" .. a:gsub("%.", "%%."):gsub("%*", "%%d*") .. "$"
    if addr:match(ptn) then return true end
  end
  return false
end


function lovebird.clear()
  lovebird.lines = {}
  lovebird.buffer = ""
end


function lovebird.pushline(line)
  line.time = os.time()
  line.count = 1
  table.insert(lovebird.lines, line)
  if #lovebird.lines > lovebird.maxlines then
    table.remove(lovebird.lines, 1)
  end
  lovebird.recalcbuffer()
end


function lovebird.recalcbuffer()
  local function doline(line)
    local str = line.str
    if not lovebird.allowhtml then
      str = lovebird.htmlescape(line.str):gsub("\n", "<br>")
    end
    if line.type == "input" then
      str = '<span class="inputline">' .. str .. '</span>'
    else
      if line.type == "error" then
        str = '<span class="errormarker">!</span> ' .. str
        str = '<span class="errorline">' .. str .. '</span>'
      end
      if line.count > 1 then
        str = '<span class="repeatcount">' .. line.count .. '</span> ' .. str
      end
      if lovebird.timestamp then
        str = os.date('<span class="timestamp">%H:%M:%S</span> ', line.time) .. 
              str
      end
    end
    return str
  end
  lovebird.buffer = table.concat(lovebird.map(lovebird.lines, doline), "<br>")
end


function lovebird.print(...)
  local t = {}
  for i = 1, select("#", ...) do
    table.insert(t, tostring(select(i, ...)))
  end
  local str = table.concat(t, " ")
  local last = lovebird.lines[#lovebird.lines]
  if last and str == last.str then
    -- Update last line if this line is a duplicate of it
    last.time = os.time()
    last.count = last.count + 1
    lovebird.recalcbuffer()
  else
    -- Create new line
    lovebird.pushline({ type = "output", str = str })
  end
end


function lovebird.onerror(err)
  lovebird.pushline({ type = "error", str = err })
  if lovebird.wrapprint then
    lovebird.origprint("[lovebird] ERROR: " .. err)
  end
end


function lovebird.onrequest(req, client)
  local page = req.parsedurl.path
  page = page ~= "" and page or "index"
  -- Handle "page not found"
  if not lovebird.pages[page] then 
    return "HTTP/1.1 404\r\nContent-Type: text/html\r\n\r\nBad page"
  end
  -- Handle page
  local str
  xpcall(function()
    str = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n" ..
          lovebird.pages[page](lovebird, req)
  end, lovebird.onerror)
  return str
end


function lovebird.onconnect(client)
  -- Create request table
  local requestptn = "(%S*)%s*(%S*)%s*(%S*)"
  local req = {}
  req.socket = client
  req.addr, req.port = client:getsockname()
  req.request = client:receive()
  req.method, req.url, req.proto = req.request:match(requestptn)
  req.headers = {}
  while 1 do
    local line = client:receive()
    if not line or #line == 0 then break end
    local k, v = line:match("(.-):%s*(.*)$")
    req.headers[k] = v
  end
  if req.headers["Content-Length"] then
    req.body = client:receive(req.headers["Content-Length"])
  end
  -- Parse body
  req.parsedbody = {}
  if req.body then
    for k, v in req.body:gmatch("([^&]-)=([^&^#]*)") do
      req.parsedbody[k] = lovebird.unescape(v)
    end
  end
  -- Parse request line's url
  req.parsedurl = lovebird.parseurl(req.url)
  -- Handle request; get data to send
  local data, index = lovebird.onrequest(req), 0
  -- Send data
  while index < #data do
    index = index + client:send(data, index)
  end
  -- Clear up
  client:close()
end


function lovebird.update()
  if not lovebird.inited then lovebird.init() end 
  while 1 do
    local client = lovebird.server:accept()
    if not client then break end
    client:settimeout(0)
    local addr = client:getsockname()
    if lovebird.checkwhitelist(addr) then 
      xpcall(function() lovebird.onconnect(client) end, function() end)
    else
      lovebird.trace("got non-whitelisted connection attempt: ", addr)
      client:close()
    end
  end
end


return lovebird
