#!/bin/sh

echo " "

echo "Enter the full path of the file or directory you want to backup:"
read SOURCE_PATH        # Reads the user's input and stores it in the variable SOURCE_PATH

if [ ! -e "$SOURCE_PATH" ]; then        # Check if the user-provided path exists
        echo " "
        echo "ERROR: The file or directory does not exist."
        exit 1  # Exit the script with a status code of 1 (indicating an error)
fi

echo " "

echo "Enter a name for the new or existing backup folder:"  # Prompt user for an existing or new backup folder name (will be created in the current directory)
read BACKUP_FOLDER      # Reads the user's input and stores the variable in BACKUP_FOLDER

DESTINATION="$(pwd)/$BACKUP_FOLDER"     # Combine current directory and backup folder name to form full path

echo " "

if [ ! -d "$DESTINATION" ]; then        # Checks if the backup folder exists
        mkdir -p "$DESTINATION"  # Create the backup folder if it doesn't exist (-p to prevent errors)
        echo "Backup folder created: $DESTINATION"
else
        echo "Backup folder: $DESTINATION"      # Backup folder already exists, confirm its use
fi

echo " "

MONTHLY_FOLDER="$DESTINATION/backup-$(date +%Y-%m)"    # Define the monthly backup subfolder inside the chosen backup folder
mkdir -p "$MONTHLY_FOLDER"      # Create the monthly backup subfolder
echo "Backup will be stored in: $MONTHLY_FOLDER"        # Inform the user where the backup will be stored

echo " "

BACKUP_FILE="backup-$(date +%Y-%m-%d_%H-%M-%S).tar.gz"  # Generate a backup file name using date and time
tar -czf "$MONTHLY_FOLDER/$BACKUP_FILE" -C "$(dirname "$SOURCE_PATH")" "$(basename "$SOURCE_PATH")"  # Create a compressed backup with a relative path
echo "Backup successfully created: $MONTHLY_FOLDER/$BACKUP_FILE" # Confirm that the backup was successfully created

echo " "

echo "How often should the backup run?"
echo "Enter one of the following options: "
echo "1 - Every hour"
echo "2 - Every day"
echo "3 - Every week"
read BACKUP_CHOICE

case "$BACKUP_CHOICE" in        # Convert the user's choice into minutes
        1) BACKUP_INTERVAL=60 ;;        # Every hour
        2) BACKUP_INTERVAL=1440 ;;      # Every day
        3) BACKUP_INTERVAL=10080 ;;     # Every week
        *)      # Anything else than 1, 2, or 3 as input
        echo "Invalid option. Please enter 1, 2, or 3."
        exit 1
        ;;
esac

echo " "

CRON_SCHEDULE="*/$BACKUP_INTERVAL * * * *"       # Convert user input into a cron-compatible schedule
SCRIPT_PATH="$(realpath "$0")"  # Get the full absolute path of the script
(crontab -l 2>/dev/null; echo "$CRON_SCHEDULE $SCRIPT_PATH") | crontab -        # Add the cron job without removing existing jobs

# Convert minutes into readable format
if [ "$BACKUP_INTERVAL" -eq 60 ]; then
    INTERVAL_TEXT="every hour"
elif [ "$BACKUP_INTERVAL" -eq 1440 ]; then
    INTERVAL_TEXT="every day"
elif [ "$BACKUP_INTERVAL" -eq 10080 ]; then
    INTERVAL_TEXT="every week"
else
    INTERVAL_TEXT="every $BACKUP_INTERVAL minutes"
fi

echo "Backup automation scheduled for $INTERVAL_TEXT."  # Confirmation message
