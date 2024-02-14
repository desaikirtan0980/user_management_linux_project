
#************************************************************************************#
#                          Project of Linux                                          #                                                      
#         script for efficient user management and backup using function             #
#         Author Name: Kirtan Desai                                                  #
#         Date Created: Feb 14 10:30PM                                               #
#************************************************************************************#

usage(){
	echo "Usage: $0 [option]"
	echo "Options: "
	echo "  -1, --add-user          Want To Add a New User"
	echo "  -2, --delete-user       Want To Delete A User"
	echo "  -3, --create-password   Want To Change User Password"
	echo "  -4, --add-group         Want To Add A New Group"
	echo "  -5, --list-users        Want To List All Existing User"
	echo "  -6, --backup-directory  Want To Backup A Specified Directory"
	echo "  -7, --help              Want To Help"
}

add_user(){
	read -p "Enter Username: " username 
	egrep "^$username" /etc/passwd > /dev/null
	if [ $? -ep 0 ]; then
		echo "User Is Already Exists, Try To Creating A New User Name"
		exit 1
	else 
	read -p "Enter The Password For $username: " password
	echo 
	sudo useradd -m -p "$(openssl passwd -1 $password)" $username
	echo "The User $username Added Successfully"

	fi
}

delete_user(){
	read -p "Enter Username that You Want To Delete: " username
       echo
      sudo userdel -r $username
     echo "User $username Deleted Successfully."
}

create_password(){
	read -p "Enter Username To Change Password: " old_username
	read -p "Do You Want Really Want To Change The Password? (y/n): " rename_option
	if [ "$rename_option" == "y" ]; then
		read -s -p "Enter New Password: " new_password
		echo
		echo "$old_username:$new_password" | sudo chpasswd   #sudo passwd -e $old_username
		echo "Password Updated Successfully."
	fi
}

add_group(){
	read -p "Enter Group Name Where You Want To Add A User: " groupname
	read -p "Enter Name Of User That You Want To Add: " username
	sudo addgroup $groupname
	sudo usermod -aG $groupname $username
	echo "$username Has Been Added To The Group $groupname Successfully."
	sudo members $groupname
}

list_user(){
	cat /etc/passwd | awk -F: '{print $1}'

}	

backup(){
	read -p "Enter The Directory To backup: " directory
	timestamp=$(date +%A,%Y,%H,%M)
	sudo tar cfz "Backup_$timestamp.tar.gz" $directory
	echo "Directory Backup Is Completed Successfully."
}

for option in "$@"; do
	case $option in
		-1| --add-user)
			add_user
			;;
		-2| --delete-user)
			delete_user
		        ;;
		-3| --create-password)
			create_password
			;;
		-4| --add-group)
			add_group
			;;
		-5| --list-user)
			list_user
			;;
		-6| --backup-directory)
			backup
			;;
		-7| --help)
			usage
			;;
		*)
			echo "Invaild Selected Option: $option"
			usage
			;;
		
		esac
done
if [[ "$?" -eq 0 ]]; then
    usage
fi
         
