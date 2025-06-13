#!/bin/bash

# 生成 UUID
UUID=$(cat /proc/sys/kernel/random/uuid)

# 安装 V2Ray Core
curl -L -s https://github.com/v2fly/fhs-install-v2ray/raw/master/install-release.sh | bash

# 写入配置文件
cat > /usr/local/etc/v2ray/config.json <<EOF
{
  "inbounds": [{
    "port": 10086,
    "protocol": "vmess",
    "settings": {
      "clients": [{
        "id": "$UUID",
        "alterId": 0
      }]
    }
  }],
  "outbounds": [{
    "protocol": "freedom",
    "settings": {}
  }]
}
EOF

# 启动服务
systemctl restart v2ray
systemctl enable v2ray

# 输出连接信息
echo "✅ V2Ray 安装完成！"
echo "==========================="
echo "IP：$(curl -s ifconfig.me)"
echo "端口：10086"
echo "UUID：$UUID"
echo "协议：vmess / tcp"
echo "==========================="
echo ""
echo "🔗 VMess链接（复制粘贴即可使用）："
VMESS=$(echo -n "{\"v\":\"2\",\"ps\":\"V2Ray_$(curl -s ifconfig.me)\",\"add\":\"$(curl -s ifconfig.me)\",\"port\":\"10086\",\"id\":\"$UUID\",\"aid\":\"0\",\"net\":\"tcp\",\"type\":\"none\",\"host\":\"\",\"path\":\"\",\"tls\":\"\"}" | base64 -w 0)
echo "vmess://$VMESS"
