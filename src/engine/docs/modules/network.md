# Network

## Packets

You communicate between the clients and the server using packets.

Packets are tables containing information to be sent back in forth, with a packet type to tell the receiver what it is.

You define a packet by doing this:
```lua
local packet = {

		ptype = "Insert Packet Type Here.",
		playername = "Insert Sender Name Here.", -- If nil, the receiver will assume it's the server.
		data = {

			-- Put extra data in here. --

		}
}
```

### ``ptype``:

 * ``c`` = *Chat Message*
 * ``join`` = *Client Join*
 * ``dc`` = *Client Disconnect*
 * ``si`` = *Get Server Information*

## Server

### network.server.send

Sends a packet to connected clients.

##### Synopsis

``network.server.send(packet, id)``

##### Arguments

``table``  <sub>packet</sub>


``clientid`` <sub>id</sub>

### Example:
Sends the chat message ``"This is a test message!"`` from ``TestName`` to all clients.
```lua
local packet = {

		ptype = "c",
		playername = "TestName", -- If nil, the receiver will assume it's the server.
		data = {

			msg = "This is a test message!"

		}
}

engine.network.server.send(packet)

```
-------------
### network.server.say

Sends a chat message from the server to all connected clients.

##### Synopsis

``network.server.say(message)``

##### Arguments

``string``  <sub>message</sub>


### Example:
Sends the chat message ``"This is the server speaking!"`` from ``Server`` to all clients.
```lua
engine.network.server.say("This is the server speaking!")

```
