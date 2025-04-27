
make_ros() {
  local file=$1
  local name=$2
  local lan=$3
  echo "/ip firewall address-list remove [/ip firewall address-list find list=$name]"
  echo "/ip firewall address-list"
  if [[ ! -z "$lan" ]]; then
    echo "add address=10.0.0.0/8 disabled=no list=$name"
    echo "add address=172.16.0.0/12 disabled=no list=$name"
    echo "add address=192.168.0.0/16 disabled=no list=$name"
    echo "add address=159.148.147.0/24 disabled=no list=$name"
    echo "add address=159.148.172.0/24 disabled=no list=$name"

    # Apple ip list. DO NOT USE vpn for Apple Services
    echo "add address=17.0.0.0/8 disabled=no list=$name"
    echo "add address=144.178.0.0/18 disabled=no list=$name"
    echo "add address=192.35.50.0/24 disabled=no list=$name"
    echo "add address=198.183.16.0/23 disabled=no list=$name"
    echo "add address=204.179.120.0/24 disabled=no list=$name"
    echo "add address=205.180.175.0/24 disabled=no list=$name"
  fi
  while read line; do
    echo "add address=$line disabled=no list=$name"
  done < $file
}

make_ros_ipv6() {
  local file=$1
  local name=$2
  local lan=$3
  echo "/ipv6 firewall address-list remove [/ipv6 firewall address-list find list=$name]"
  echo "/ipv6 firewall address-list"
  if [[ ! -z "$lan" ]]; then
    echo "add address=fd00::/8 disabled=no list=$name"
  fi
  while read line; do
    echo "add address=$line disabled=no list=$name"
  done < $file
}

for file in *.txt; do
  name=${file%.*}
  if [ -z ${file##*.ipv6.txt} ]; then
    make_ros_ipv6 $file $name > $name.rsc
  else
    make_ros $file $name > $name.rsc
  fi
done

# Generate backward Compatibility address-list.rsc
make_ros chnroutes.txt novpn yes > address-list.rsc
make_ros_ipv6 chnroutes.ipv6.txt novpn.ipv6 yes > address-list.ipv6.rsc
