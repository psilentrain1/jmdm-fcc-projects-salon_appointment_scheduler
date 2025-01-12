#! /bin/bash
echo $(psql -U postgres < salon.sql)