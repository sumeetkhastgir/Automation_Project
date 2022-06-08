# Automation_Project
Automation project

This shell script contains the automation for the following steps:

1. Updates the apt repository and installs apache2

2. Checks if apache2 is running and if not, it starts the service.

3. Checks if apache2 is enabled and if not, it enables it.

4. Compresses the log files generated by apache2

5. Uploads the compressed file to the s3 bucket
