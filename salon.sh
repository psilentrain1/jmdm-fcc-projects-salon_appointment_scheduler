#! /bin/bash
# GLOBALS
PSQL='psql -X --username=freecodecamp --dbname=salon --tuples-only -c'

echo -e "\n~~ Welcome to our salon! ~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  SELECT_SERVICE
}

SELECT_SERVICE() {
  echo "These are the services available:"
  SERVICES_LIST=$($PSQL "SELECT * FROM services ORDER BY service_id;")
  echo "$SERVICES_LIST" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
  echo -e "\nWhich would you like to book?"
  read SERVICE_ID_SELECTED
  
  # check valid service
  SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED;")

  # if invalid, send back to main
  if [[ -z $SERVICE_ID ]]
  then
    MAIN_MENU "That service doesn't exist, try again."
  else
    VALIDATE_CUSTOMER
  fi
}

VALIDATE_CUSTOMER() {
  echo -e "\nPlease enter your phone number:"
  read CUSTOMER_PHONE

  # check if customer exists
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")
  if [[ -z $CUSTOMER_ID ]]
  then
    ADD_CUSTOMER
  else
    SET_APPOINTMENT
  fi

}

ADD_CUSTOMER() {
  # get name
  echo -e "\nPlease enter your name:"
  read CUSTOMER_NAME

  # add customer to db
  CUSTOMER_ADDED=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")
  SET_APPOINTMENT
}

SET_APPOINTMENT() {
  # get time
  echo -e "\nWhat time should your appointment be?"
  read SERVICE_TIME

  # add appointment to db
  APPOINTMENT_ADDED=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID, '$SERVICE_TIME')")

  # confirm appointment to user
  APPOINTMENT=$($PSQL "SELECT $SERVICE_ID FROM appointments WHERE customer_id = $CUSTOMER_ID AND time = '$SERVICE_TIME';")
  if [[ -z $APPOINTMENT ]]
  then
    echo -e "\nThere was an error. Try again."
    MAIN_MENU
  else
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID;")
    echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}

MAIN_MENU