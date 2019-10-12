#!/bin/bash
#There is probably something wrong here, you probably should not run it.
if [ -z $1 ]; then
	echo
	echo "			Need Repository Path"
	echo "  You can also add a second parameter to be used as a git username."
	echo " If you dont provide this then provisions will NOT be made for pushing."
	echo
	exit 1
fi
httpd="busybox-extras httpd"
repo=$1
hcount=$(grep hook /etc/passwd | wc -l) #heh
u=$3
: ${u:=hook$hcount}
guser=$2
: ${guser:=$u}
port=`expr 8080 + $hcount`
if [ "$(whoami)" !=  "$u" ]; then
	echo "create user $u..."
	#I don't really like putting sudo in a shell script but whatever
	sudo adduser $u
	sudo su $u -c "$0 $repo $guser $u"
	exit $?
fi
if [ "$(whoami)" != "$u" ]; then
	echo -n "wrong user "
	whoami
	exit 1
fi
cd ~
if [ -n $guser ]; then
	cat /dev/zero | ssh-keygen -q -N "" #assume the defaults are secure
	git config --global user.name "$guser"
	git config --global url.ssh://git@github.com/.insteadOf https://github.com/
fi
mkdir -p www/cgi-bin
cat >www/cgi-bin/hook <<EOF
#!/bin/bash
if [ "\$(whoami)" != "$u" ]; then
	echo "should be $u"
	exit 1
fi
[ -z "\$REQUEST_METHOD" ] && cd && nohup $httpd -vf -p $port -h ~/www/; exit \$?
echo "Content-type:text/plain\\n\\n"
echo
cat /dev/null | env -i "cd ~/doc && git pull && ./ci"
EOF
chmod +x www/cgi-bin/hook
git clone $repo doc
if [ -n $guser ]; then
	echo key is  
	cat ~/.ssh/id_rsa.pub
	echo
fi
echo -n "hook is http://"
hostname -f | tr -d '\n'
echo ":$port/cgi-bin/hook"
~/www/cgi-bin/hook &sleep 1 #the sleep is only to try and avoid clobering the prompt.
