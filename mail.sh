#!/bin/bash

# Force the user to run as root
if [ "$EUID" -ne 0 ]
	then echo "Please run as root"
else
	# Loop over all the users in the emails.txt file
	for user in $(cat emails.txt | cut -d "@" -f 1);
	do
		# Generate the random password, then print
		paswrd=$(openssl rand -base64 12)
		echo $user
		echo $paswrd

		# Checks if the user exists
		if [ "$(cat /etc/passwd | cut -d ':' -f 1 | grep $user)" = "$user" ]; then
			# If the user exists, update the password
			echo "User Exists: Updating Password"
			$(echo "$user:$paswrd" | chpasswd)
		else
			# Else Create a new user
			echo "New user added"
			useradd -m -g CSI230 -s /bin/bash $user -p $paswrd
			chage -d 0 $user
		fi
		echo "|------------------|"
		
	done
fi
exit
