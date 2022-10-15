import ballerina/http;

public type CreatedInlineResponse201 record {|
    *http:Created;
    InlineResponse201 body;
|};

public type User record {
    # the username of the user
    readonly string username;
    # the first name of the user
    string firstname?;
    # the last name of the user
    string lastname?;
    # the email address of the user
    string email?;
};

public type InlineResponse201 record {
    # the username of the user newly created
    string userid?;
};

public type Error record {
    string errorType?;
    string message?;
};

//curl -X POST -H "Content-Type:application/json" http://localhost:9090/lesson2/user -d '{"userid":"rejoice1","firstname":"rejoice","lastname":"john","email":"rejoice@gmail.com"}
