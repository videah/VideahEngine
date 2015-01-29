network = {}

network.address = "localhost"
network.port = 7632

network.updaterate = 0.1

print("Loaded networking system ...")

function network.load()

	udp = socket.udp()
	udp:settimeout(0)
	udp:setpeername(network.address, network.port)

end