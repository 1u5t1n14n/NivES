{ ... }:

{

	services.ntfy-sh = {
		settings = {
			base-url = "http://192.168.178.185:8088";
			listen-http = "0.0.0.0:8088";
		};
	};

	networking.firewall.allowedTCPPorts = [ 8088 ];

}
