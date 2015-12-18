export NODE_ENV="development"
export SECRET_KEY="f7b5c8b906ba4c9b8cf5122f09466669"
# export API_KEY="bebb3e74265e4acabe5bc35199935225"
# # export API_HOSTNAME="$(boot2docker ip)"
# export API_PORT="80"


export PORT="3000"
# export MYSQL_SERVER="gallo-dev.crsivdt70avv.us-west-2.rds.amazonaws.com"
# export MYSQL_USER="awsuser"
# export MYSQL_PASSWORD="ci4bdTTanP776MeDRZXb"

export MYSQL_PROT="3306"
export MYSQL_SERVER="localhost"
export MYSQL_USER="root"
export MYSQL_PASSWORD="password"

# FOR TESTING ONLY
export NITRO_ENV="qa521"
export NITRO_SERVER="https://devapi.bunchball.net/v0"
export NITRO_API_KEY="fccd44db6c3d4b3d8a04dc67ab34e6ef"
export ENVIRONMENT="localhost"
export NITRO_USERID="jz@test.com"
export NITRO_PASSWORD="password"

export NEW_RELIC_LICENSE_KEY=''

node_modules/nodemon/bin/nodemon.js --harmony app.js

# cd to usr/local/mysql/bin
# run ./mysql -h gallo-dev.crsivdt70avv.us-west-2.rds.amazonaws.com -u awsuser -p gallo_dev
# input password
