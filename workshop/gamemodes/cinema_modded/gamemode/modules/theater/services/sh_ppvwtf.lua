local SERVICE = {
	Name = "PPV.wtf",
	IsTimed = false,

	Dependency = DEPENDENCY_COMPLETE
}

function SERVICE:Match(url)
	return url.host and url.host:match("vidembed.re")
end

if CLIENT then
	local THEATER_JS = [[
		(async () => {
			let waitForIframe = setInterval(() => {
				let iframe = document.querySelector("iframe");
				if (iframe && iframe.src.includes("vidembed.re")) {
					clearInterval(waitForIframe);
					window.cinema_controller = iframe;
					exTheater.controllerReady();
				}
			}, 100);
		})();
	]]

	function SERVICE:LoadProvider(Video, panel)
		panel:OpenURL(Video:Data())
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions(pnl)
			pnl:QueueJavascript(THEATER_JS)
		end
	end
end

function SERVICE:GetURLInfo(url)
	if url and url.encoded then
		return { Data = url.encoded }
	end

	return false
end

function SERVICE:GetVideoInfo(data, onSuccess, onFailure)
	local info = {}
	info.title = "PPV.wtf Stream"
	info.data = data

	if onSuccess then
		pcall(onSuccess, info)
	end
end

theater.RegisterService("ppvwtf", SERVICE)

