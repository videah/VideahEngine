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

### ``network.server.send(packet, id):``

Sends a packet to connected clients.

### Arguments:


##### `` packet: table ``


*Optional*:

##### `` id: clientid `` 


### Usage:

```lua
local packet = {
engine.network.server.send(tbl)
```

