#!/bin/bash
source variables


if [ ! -d $BACKUP_PATH ]; then
  mkdir -p $BACKUP_PATH
fi

databases=`mysql -u $USER -p$PASSWORD -e "SHOW DATABASES;" | tr -d "|" | grep -v Database`

for db in $databases; do

  if [ $db == 'information_schema' ] || [ $db == 'performance_schema' ] || [ $db == 'mysql' ] || [ $db == 'sys' ]; then
    echo "Skipping database: $db"
    continue
  fi
  
  date=$(date -I)
    echo "Backing up database: $db with compression"
    mysqldump -u $USER -p$PASSWORD --databases $db | gzip -c > $BACKUP_PATH/$date-$db.gz
  
done


#azcopy_linux_amd64_10.13.0/azcopy copy "$BACKUP_PATH/*" "https://azstoragetesting.blob.core.windows.net/myfsqldump/?sv=2020-08-04&ss=bfqt&srt=sco&sp=rwdlacupitfx&se=2029-10-29T14:23:41Z&st=2021-10-29T06:23:41Z&spr=https&sig=eEI9gSVyY5fumV%2F%2BNAWkr88wNn%2BleP7OR9R1GD9fqaM%3D"

#rm -rf $BACKUP_PATH/*
