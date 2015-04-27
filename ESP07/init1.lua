wifi.setmode(wifi.SOFTAP);
wifi.ap.config({ssid="Sniper_Locator",pwd="12345678"});
print(wifi.sta.getip())
gpio.mode(4, gpio.OUTPUT)
gpio.write(4, gpio.LOW)
gpio.mode(3, gpio.OUTPUT)
gpio.write(3, gpio.HIGH)
srv=net.createServer(net.TCP) 
srv:listen(80,function(conn) 
   conn:on("receive", function(client,request)
        local buf = "<head><meta http-equiv=\"refresh\" content=\"2\"><\head>";
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
        local _GET = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                _GET[k] = v
            end
        end
		buf = buf.."<h1>----+ Sniper_Locator +------ </h1>";
        buf = buf.."<p> --------POWER-------- <a href=\"?pin=OFF\"><button>RESET</button></a>&nbsp;</p>";
        buf = buf.."<p> ---WRITING DATA--- <a href=\"?pin=ON\"><button>Start/Stop</button></a>&nbsp;</p>";
        local _on,_off = "",""
        if(_GET.pin == "OFF")then
              gpio.write(3, gpio.LOW);
			  tmr.delay(1000000);
			  gpio.write(3, gpio.HIGH);
		elseif(_GET.pin == "ON")then
              gpio.write(4, gpio.HIGH);
			  tmr.delay(500000);
			  gpio.write(4, gpio.LOW);
		end
        client:send(buf);
        client:close();
        collectgarbage();
    end)
end)
