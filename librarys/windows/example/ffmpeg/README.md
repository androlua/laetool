1��Lae������c++����
	c++
	LXZSystem_RegisterAPI("Play", ccPlay);
	LXZSystem_RegisterAPI("Pause", ccPause);
	LXZSystem_RegisterAPI("seekpos", ccSeekpos);
	LXZSystem_RegisterAPI("Resume", ccResume);
	LXZSystem_RegisterAPI("skipfront", ccSkipNext);
	LXZSystem_RegisterAPI("skipback", ccSkipBack);	
	LXZSystem_RegisterAPI("toggle_muted", ccMutex);
	LXZSystem_RegisterAPI("volume", ccSetVolume);
	LXZSystem_RegisterAPI("toggle_fullscreen", toggle_fullscreen);
	
	lua
	LXZAPI_CallSystemAPI("skipfront", "", nil);
	LXZAPI_CallSystemAPI("toggle_fullscreen", "", nil);
	
	
	2��Lae����λ��
	http://download.csdn.net/detail/ouloba_cs/9390870
	
	3����Lae���������������޸Ĳ������Ľ���
	��ffmpeg.ui
	
	4�����ʹ��lae?
	�ɿ���Ƶ	http://www.tudou.com/programs/view/AaqZ81jIt-k