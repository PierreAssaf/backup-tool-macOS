# Shell Backup & Automation Tool

This shell script allows you to **compress and back up** any file or directory, then **automatically schedule** future backups using `cron`. It's perfect for creating monthly subfolders, storing timestamped archives, and letting users pick how frequently they want to back up.

## Features
- **User-Friendly Prompts**  
  Asks for the file/directory path to back up, ensuring it exists.
- **Custom Backup Folder**  
  Lets you name or reuse a folder where backups will be stored.
- **Organized by Month**  
  Creates a subfolder (e.g., `backup-2025-02`) to keep things tidy.
- **Timestamped Archives**  
  Generates a unique `.tar.gz` file for every backup using date/time.
- **Automated with `cron`**  
  Lets you choose your backup frequency (hourly, daily, or weekly), then creates a `cron` job for you.

## How It Works
1. **Prompt for Source**  
   The script asks for a file or directory path and checks if it actually exists.
2. **Prompt for Backup Folder**  
   Creates or reuses a folder in your current directory.
3. **Monthly Subfolder**  
   Automatically appends `backup-YYYY-MM` to the chosen folder name (e.g., `backup-2025-02`).
4. **Compression**  
   Uses `tar` with gzip (`.tar.gz`) to compress the backup.  
   Avoids absolute paths to remove warnings like `tar: Removing leading '/' from member names`.
5. **Scheduling**  
   Asks how often you want to schedule backups (hourly, daily, or weekly).  
   Converts this to a `cron` job (`*/60`, `*/1440`, `*/10080`, etc.).
6. **No Overwriting**  
   Each backup archive includes a unique timestamp, preventing accidental overwrites.

## Requirements
- **Unix-like environment** (macOS, Linux, or WSL on Windows)
- `tar` (for creating archives)
- `cron` (for scheduling backups)
- `realpath` (for finding the script's absolute path, usually installed by default)

## Installation & Usage
1. **Clone the Repository**:
   ```sh
   git clone https://github.com/your-username/backup-tool.git
   cd backup-tool
