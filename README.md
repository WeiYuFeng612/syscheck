# syscheck

一条命令完成 Linux 服务器健康巡检。纯 Bash 实现，无需安装任何依赖，面向 CentOS 7（bash 4.2 / kernel 3.10）测试，也可用于 RHEL、Rocky、Ubuntu、Debian 等发行版。

## 安装

```bash
curl -fsSL https://raw.githubusercontent.com/WeiYuFeng612/syscheck/main/install.sh | sudo bash
```

如果服务器访问不了 GitHub，可改用 jsDelivr 镜像：

```bash
curl -fsSL https://cdn.jsdelivr.net/gh/WeiYuFeng612/syscheck@main/install.sh | sudo bash
```

也可以用 `git` 手动安装：

```bash
git clone https://github.com/WeiYuFeng612/syscheck.git
sudo install -m 0755 syscheck/syscheck /usr/local/bin/syscheck
```

## 用法

```text
syscheck [选项] [检查项...]

检查项（默认全部）：
  system   系统、内核、运行时长
  cpu      CPU 型号、使用率、负载
  mem      内存与 swap
  disk     磁盘空间与 inode
  net      IP、监听端口、TCP 连接数
  svc      失败的 systemd 服务
  sec      SELinux、防火墙、SSH 配置、SSH 登录失败次数
  proc     进程总数、僵尸进程、CPU/内存占用 Top5

选项：
  -q, --quiet       只输出 WARN/CRIT 和汇总
  -n, --no-color    关闭彩色输出
  -w, --warn N      告警阈值百分比（默认 80）
  -c, --crit N      严重阈值百分比（默认 90）
  -v, --version     版本号
  -h, --help        帮助
```

示例：

```bash
sudo syscheck              # 完整巡检
sudo syscheck disk mem     # 只查磁盘和内存
syscheck -q -w 70 -c 85    # 静默模式，自定义阈值
```

## 退出码

| 退出码 | 含义 |
|---|---|
| 0 | 全部正常 |
| 1 | 存在告警（WARN） |
| 2 | 存在严重问题（CRIT） |

因此可以直接放进 cron 做定时巡检，例如：

```bash
*/30 * * * * /usr/local/bin/syscheck -q -n || /usr/local/bin/syscheck -q -n | mail -s "syscheck alert" admin@example.com
```

## 卸载

```bash
sudo rm -f /usr/local/bin/syscheck
```

## 许可证

MIT
