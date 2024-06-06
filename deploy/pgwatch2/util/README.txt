Scripts in this folder are used to create secrets that are necessary for PGWatch to work.
One is for enabling the Postgres connection.
The other one is for enabling the connection to Influxdb.
Before running the create-pgwatch-secrets.sh, the content of pgwatch-secrets.sh needs to be specified.

IMPORTANT:
PLEASE NOTE THAT THE PASSWORD INSIDE THE POSTGRES CONNECTION STRING NEEDS TO BE PERCENT ENCODED!

Inside that script is the creation of needed environment variables that will be used to create the secrets.
After running the script, further explanation will be available as the script output.