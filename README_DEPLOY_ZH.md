# LiveTranslate OpenAI M2 日语→简体中文部署版

这是基于 `KazKozDev/live-translation` 的通用实时字幕工具，保留上游 MIT 许可证和版权声明。

功能：

- 捕获 Mac 系统音频；
- 使用 MLX Whisper 在本机识别日语；
- 使用 OpenAI GPT-6 Luna 翻译为简体中文；
- 悬浮窗同时显示日语原文和中文翻译；
- 保存会话历史，并导出 TXT、PDF、SRT 或 VTT。

## 1. 准备 OpenAI API

1. 在 <https://platform.openai.com/api-keys> 创建 API Key。
2. 在 <https://platform.openai.com/settings/organization/billing> 配置 API 余额或付款方式。

ChatGPT 订阅和 OpenAI API 是分别计费的。不要把 API Key 发给别人，也不要把它提交到 GitHub。

## 2. 一键安装

打开“终端”，进入本文件夹，然后执行：

```bash
chmod +x setup-m2.sh set-openai-key.sh install-app.sh
./setup-m2.sh
```

安装脚本会安装 Python、FFmpeg、BlackHole 和一个 Whisper 模型，并提示你粘贴 API Key。输入不会显示，Key 只保存在当前 macOS 用户的钥匙串中，不会写入项目文件。

## 3. 配置系统音频

1. 打开 macOS 的“音频 MIDI 设置”。
2. 点击左下角 `+`，选择“创建多输出设备”。
3. 同时勾选平时使用的扬声器/耳机和 `BlackHole 2ch`。
4. 在“系统设置 → 声音 → 输出”中选择刚创建的多输出设备。
5. 首次启动时允许 LiveTranslate 访问麦克风；这是读取 BlackHole 音频所需的系统权限。

## 4. 启动和保存

打开：

```text
~/Applications/LiveTranslate.app
```

如果 macOS 首次阻止启动，请右键应用并选择“打开”。播放任意日语音频后，悬浮窗左侧显示日语原文，右侧显示简体中文。

悬浮窗中的 `Save` 可导出 TXT、PDF、SRT 或 VTT；`History` 可查看以前的会话。字幕和历史默认保存在本机。

## 5. 更换或删除 API Key

更换：

```bash
./set-openai-key.sh
```

删除：

```bash
security delete-generic-password -a "$USER" -s "LiveTranslate OpenAI API Key"
```

## 6. 常见问题

- **只有声音、没有字幕**：确认输出设备是包含 `BlackHole 2ch` 的多输出设备，并检查麦克风权限。
- **提示找不到 API Key**：在项目目录重新执行 `./set-openai-key.sh`，然后重新打开应用。
- **401 错误**：API Key 无效或已经撤销，请重新创建并保存。
- **429 错误**：通常是余额、限额或请求频率问题，请检查 OpenAI API 账单和限额。
- **内存不足或速度慢**：低于 12 GB 内存时应用会自动使用 Whisper Small；12 GB 及以上使用 Whisper Medium。
- **查看启动日志**：打开项目目录中的 `live_translate_overlay.boot.log`。

## 隐私和使用边界

音频和语音识别在 Mac 本机处理；识别出的日语文本会发送给 OpenAI 用于翻译。请求设置为不存储 API 响应，但数据处理仍受 OpenAI API 条款和隐私政策约束。

本工具不针对任何特定网站。请只处理你有权访问和处理的内容，并遵守相关平台的服务条款、版权和隐私规则。不要公开未经授权的直播录音、录像或字幕记录。
