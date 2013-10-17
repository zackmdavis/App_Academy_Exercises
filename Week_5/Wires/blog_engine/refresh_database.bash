if [ -f blog_database.db ]
    then
    rm blog_database.db
    echo "Deleted old database file"
fi
cat seeds.sql | sqlite3 blog_database.db
echo "Created new database file from import script"