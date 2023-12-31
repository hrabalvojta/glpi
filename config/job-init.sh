#!/bin/bash
php bin/console db:install --no-telemetry
php bin/console db:update --no-telemetry
php bin/console glpi:security:change_key
rm -rf install

### COnfigure cache
#php bin/console cache:clear
#php bin/console cache:configure -–dsn redis://glpi-redis-service:6379/glpi

### DDB tasks
#php bin/console db:check --check-all-migrations
#php bin/console db:install --no-telemetry
#php bin/console db:configure \
#    --db-host=glpi-db-service \
#    --db-port=3306 \
#    --db-name=glpi \
#    --db-user=admin \
#    --db-password=admin

### Accounts used at first start
#Change init account
#    glpi/glpi admin account,
#    tech/tech technical account,
#    normal/normal “normal” account,
#    post-only/postonly post-only account.