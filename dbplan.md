## **table:** salon

customers
- customer_id
  - SERIAL
  - PRIMARY KEY
- phone
  - VARCHAR(15)
  - UNIQUE
- name
  - VARCHAR(50)

appointments
- appointment_id
  - SERIAL
  - PRIMARY KEY
- customer_id
  - INT
  - FOREIGN KEY
- service_id
  - INT
  - FOREIGN KEY
- time
  - VARCHAR(10)

services
- service_id
  - SERIAL
  - PRIMARY KEY
- name
  - VARCHAR(50)