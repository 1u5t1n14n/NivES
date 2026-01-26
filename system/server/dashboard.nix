{ ... }:

{

	services.homepage-dashboard = {
		port = 8082;
		allowedHosts = "localhost:8082,127.0.0.1:8082,192.168.178.188:8082";

		openFirewall = true;
	};

}
