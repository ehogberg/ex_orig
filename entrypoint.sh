#! /bin/sh

while ! pg_isready -q -h $DATABASE_HOST -p $DATABASE_PORT -U $DATABASE_USER
do
    echo "$(date) - waiting for database to start"
    sleep 2
done

echo "Creating $DATABASE_NAME (if necessary.)"
mix ecto.create
mix event_store.create
mix event_store.init


echo "Database $DATABASE_NAME exists, running migrations..."
mix ecto.migrate
echo "Migrations finished."

exec mix phx.server
