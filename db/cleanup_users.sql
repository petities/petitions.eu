DELETE n1 FROM users n1,
    users n2 
WHERE
    n1.id > n2.id AND n1.email = n2.email;
