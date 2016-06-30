
--�����ӿ�
LXZDoFile("LXZHelper.lua");
LXZDoFile("serial.lua");

--ÿ֡����,root����status��IsActive����Ϊtrue,���ɴ���OnUpdate�¼���
local function OnUpdate(window, msg, sender)
	UpdateWindow();
end

--����Ŀ¼��Ŀ¼�����ļ��б�
local function UpdateDirectry(dir)
	local root = HelperGetRoot();
	
	--set current dir.	
	lfs.chdir(dir);
	HelperSetWindowText(root:GetLXZWindow("directry"), dir);
	
	--
	local items = root:GetLXZWindow("folders:area:items"); --Ŀ¼�ļ�����
	local item = root:GetLXZWindow("folders:item"); --Ŀ¼�ļ���	
	local path = lfs.currentdir();
	
	--�������������
	items:ClearChilds();
	
	--������Ŀ¼�µ���Ŀ¼�ļ�
	local cnt = 0;
	for file in lfs.dir(lfs.currentdir()) do
		local wnd = item:Clone(); --��¡һ��Ŀ¼�ļ���"folders:item"
		wnd:Show();                      --��ʾ
		HelperSetWindowText(wnd:GetChild("text"), file); --����Ŀ¼�����ļ���
		items:AddChild(wnd);		 --����items������
			
		local f = path.."\\"..file;
		local attr = lfs.attributes(f);				
		if attr and attr.mode=="directory" then
			wnd:GetChild("icon"):SetState(0); --ͨ��0״̬����Ŀ¼ͼ��
		else
			wnd:GetChild("icon"):SetState(1);--ͨ��1״̬�����ļ���ͼ��
		end		
		
		if attr then			
			HelperSetWindowText(wnd:GetChild("access time"), os.date("%c", attr.access) );
			HelperSetWindowText(wnd:GetChild("modify time"), os.date("%c", attr.modification));
			HelperSetWindowText(wnd:GetChild("change time"), os.date("%c", attr.change));
			HelperSetWindowText(wnd:GetChild("permissions"), attr.permissions);
		end
		
		cnt=cnt+1;
	end
	
	--����޷����ʸ�Ŀ¼�������"."��".."
	if cnt==0 then
		local wnd = item:Clone();
		wnd:Show();
		HelperSetWindowText(wnd:GetChild("text"), ".");
		items:AddChild(wnd);		
		wnd:GetChild("icon"):SetState(0);
		
		local wnd = item:Clone();
		wnd:Show();
		HelperSetWindowText(wnd:GetChild("text"), "..");
		items:AddChild(wnd);		
		wnd:GetChild("icon"):SetState(0);
	end
	
	--��ֱ��������Ӧ���ݴ�С��
	local msg = CLXZMessage:new_local();
	local wnd = root:GetLXZWindow("folders:vertical slider");
	wnd:ProcMessage("OnReset", msg, wnd);
	
end

--��ȡ��չ��  
function getextension(filename)  
    return filename:match(".+%.(%w+)$")  
end  

--������
local function OnMouseEnterItem(window, msg, sender)
	local file=HelperGetWindowText(sender:GetChild("text"));
	local path = lfs.currentdir();
	
	local f = path.."\\"..file;
	 local attr,err = lfs.attributes (f)
	 if attr== nil then
		LXZMessageBox("error:"..err);
		return;
	 end
	 
	 local root = HelperGetRoot();	
     assert (type(attr) == "table");
	 local ext = getextension(file);
	 
	 LXZAPI_OutputDebugStr("OnMouseEnterItem:"..f.." mode:"..attr.mode);
	 
     if attr.mode == "file" and (ext=="png" or ext=="PNG" or ext=="jpg") then --�����ͼƬ�ļ�
		LXZAPI_OutputDebugStr("OnMouseEnterItem:"..f.." ext:"..ext.." mode:"..attr.mode);
		local wnd = root:GetLXZWindow ("folders:show picture");
		HelperSetWindowPictureFile(wnd,f);
		wnd:Show();
		HelperCoroutine(function(thread)
			AddWndUpdateFunc(wnd, EffectFaceOut, {from=255, End=200,step=3, old=255, hide=true}, thread);		
			coroutine.yield();
			local texture = ILXZTexture:GetTexture(f);
			if texture then
				texture:RemoveTexture();
			end
		end);
	 end
end

--���Ŀ¼�����ļ���
local function OnClickItem(window, msg, sender)
	local file=HelperGetWindowText(sender:GetChild("text"));
	local path = lfs.currentdir();
	
	local f = path.."\\"..file;
	 local attr,err = lfs.attributes (f)
	 if attr== nil then
		LXZMessageBox("error:"..err);
		return;
	 end
	 
	-- LXZMessageBox("type(attr)"..type(attr).."f:"..f)
     assert (type(attr) == "table");
     if attr.mode == "directory" then --�����Ŀ¼
		UpdateDirectry(f);		
	 end

end

--ui����ʱ�������¼�
local function OnLoad(window, msg, sender)
	local root = HelperGetRoot();
	
	--set default.
	local default_dir = "c:\\";
	HelperSetWindowText(root:GetLXZWindow("directry"), default_dir);
	
	--set folder list.
	UpdateDirectry(default_dir);
	
end

--�¼���ӿڰ�
local event_callback = {}
event_callback ["OnUpdate"] = OnUpdate;
event_callback ["OnLoad"] = OnLoad;
event_callback ["OnClickItem"] = OnClickItem;
event_callback ["OnMouseEnterItem"] = OnMouseEnterItem;

--�¼��ַ���
function main_dispacher(window, cmd, msg, sender)
---	LXZAPI_OutputDebugStr("cmd 1:"..cmd);
	if(event_callback[cmd] ~= nil) then
--		LXZAPI_OutputDebugStr("cmd 2:"..cmd);
		event_callback[cmd](window, msg, sender);
	end
end

