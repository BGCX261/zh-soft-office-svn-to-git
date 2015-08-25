{ 多语言版本语言定义 }
{ 2007-03-21 by muhx }

{ 简体中文版本 }
resourcestring

  { 公共部分 }
  LComp = '北大青鸟';
  LSoftServerName = '在线更新程序  服务端';
  LSoftClientName = '在线更新程序  客户端';
  LURL = 'www.jbbis.com.cn';
  LAbout = '关于';
  LHelp = '帮助';
  LFunction = '任务';
  LOK = '确定';
  LApply = '应用';
  LCancel = '取消';
  LError = '错误';
  LWarning = '警告';
  LInfo = '信息';
  LQuestion = '询问';
  LSuccess = '成功';
  LFailure = '失败';
  LSend = '发送';
  LBackupInfo = '备份文件信息';
  LLoadBackup = '加载备份项';
  LComebackBtn = '恢复文件';
  LLogin = '用户登录';
  LSystem = '系统';
  LLogout = '用户退出';

  { 任务 }
  LService = '在线更新服务';
  LComeback = '恢复为以前版本';
  LTalk = '会话';
  LConfig = '配置管理';
  LLog = '日志管理';

  { 服务 }
  LSelectFile = '选择需要更新的文件';
  LStartService = '启动服务';
  LStopService = '停止服务';
  LUpdate = '更新';
  LContinue = '继续';
  LIndex = '序号';
  LFilePath = '文件路径';
  LFileName = '文件名称';
  LFileLength = '文件大小';
  LProgress = '更新进度';
  LStartTime = '开始时间';
  LContinueTime = '持续时间';
  LTransRate = '传输速率';
  LUpdateInfo = '更新信息';
  LServerInfo = '设置提供服务的服务器信息';
  LServerPort = '服务器端口';
  LServerIP = '服务器IP地址';

  { 错误信息 }
  LCanNotFindFile = '无法在指定路径找到文件 %S';
  LFileSizeOverflow = '文件 %S 为空或者太大';
  LSendUpdateListError = '发送更新列表失败';
  LNotifyUpdateError = '通知客户端 %D 更新文件失败';
  LRequestUpdateListError = '请求接收更新列表失败';
  LRecvUpdateListError = '接收更新列表失败';
  LSaveUpdateListError = '保存更新列表失败';
  LXMLDocumentExist = 'XMLDocument 对象已经存在';
  LListNotCreate = '文件列表容器类没有创建';
  LFileNotFount = '找不到文件 %S ，操作失败';
  LSaveFileError = '保存文件失败';
  LClientNotActive = '客户端没有启动或者启动失败';
  LChatError = '会话没有发送成功';
  LChatExist = '内容为空，请输入要发送的内容';

  { 事件信息 }
  LRequestUpdate = '服务器通知需要进行更新，回复服务器请求%S';
  LShouldNotUpdate = '本地文件已经是最新版本，不需要更新';
  LShouldUpdate = '服务器文件版本和本地文件版本不同，正在下载服务器文件';
  LBeginRecvFile = '开始接收文件';
  LEndRecvFile = '文件接收完毕';
  LStartUpdate = '正在更新文件';
  LUserEndUpdate = '用户取消了更新操作';
  LEndUpdate = '文件更新完毕';
  LFileIsRunning = '错误代码: %D ' + #13 + '文件 %S 正在运行，' + #13 + '请关闭后重试，或者取消更新操作';

