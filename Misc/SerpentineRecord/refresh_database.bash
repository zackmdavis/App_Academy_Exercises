if [ -f my_database.db ]
    then
    rm my_database.db
    echo "Deleted old database file"
fi
cat import_db.sql | sqlite3 my_database.db
echo "Created new database file from import script"
