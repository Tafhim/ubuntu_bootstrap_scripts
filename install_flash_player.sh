# Script to install Flash player in Ubuntu

# Check if a user was specified
USER=$1
if [ "$USER" = "" ]; then
  echo "Please specify a user"
  exit
fi

# Locate the user's home directory
USER_HOME=/home/$USER
if [ ! -d $USER_HOME ]; then
  echo "The user's directory could not be found"
  exit
fi

# Assume that the Flash file was downloaded in the downloads folder
FLASH_FILE_DIR=$USER_HOME/Downloads
if [ "$2" = "" ]; then
  echo "You did not specify a location for flash tar files, using $FLASH_FILE_DIR"
else
  echo "Looking in $2 for flash files"
  FLASH_FILE_DIR=$2
fi

for flashtar in $(ls $FLASH_FILE_DIR | grep install_flash_player); do

  tar_location=$FLASH_FILE_DIR/$flashtar

  echo "Extracting $tar_location.."
  temp_files_dir=$FLASH_FILE_DIR/flash_install_temp_files
  mkdir -p $temp_files_dir
  tar -xf $tar_location -C $temp_files_dir
  cp -r $temp_files_dir/usr/* /usr/

  if [ -d $USER_HOME/.mozilla/plugins ]; then
    mkdir -p $USER_HOME/.mozilla/plugins
  fi
  cp $temp_files_dir/libflashplayer.so $USER_HOME/.mozilla/plugins

  # Delete the temporary directory
  rm -rf $temp_files_dir

done
