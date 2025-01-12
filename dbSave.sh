#! /bin/bash
echo $(pg_dump -cC --inserts -U freecodecamp salon > salon.sql)
