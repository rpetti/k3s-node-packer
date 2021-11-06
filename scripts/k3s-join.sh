#!/bin/sh

export script=/etc/local.d/k3s-join.start
mkdir -p $(dirname $script)

echo "
#!/bin/sh
curl -sfL https://get.k3s.io | K3S_URL=$K3S_URL K3S_TOKEN=$K3S_TOKEN sh -
rm $script
" > $script

chmod +x $script
rc-update add local default