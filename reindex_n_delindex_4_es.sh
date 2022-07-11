#!/bin/sh

ZERO=0
max=32
index=$1

if [ -z "$index" ]; then
  echo input example: \"maxsummer-snmp-202204\"  👈 In case of reindexing daily to monthly.;
  exit
fi

curl -H "Content-Type: application/json" -XPOST http://localhost:3000/_reindex -d "{
\"source\": {
\"index\": \"$1*\"
},
\"dest\": {
\"index\": \"$1\"
}}"

echo ""
echo "🙋 Finished reindex!"

while true; do
  read -p "❓ Do you want to remove this ex indices? " yn
  case $yn in
    [Yy]* )
      for (( i=1; i < max; i++ )); do 
        if [ $i -lt 10 ]; then
          echo 🚴 Now step is $i day.
          curl -XDELETE "http://localhost:3000/$1$ZERO$i?pretty"
        else
          echo 🚴 Now step is $i day.
          curl -XDELETE "http://localhost:3000/$1$i?pretty"
        fi
      done
      echo 🙋 Finished deleting indices
      break;;
    [Nn]* ) 
      exit;; 
    * ) 
      echo 💥 Please answer \"y\" or \"n\";;
  esac
done
