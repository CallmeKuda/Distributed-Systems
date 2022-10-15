import ballerina/http;
import Lab2.types as Types;
import Lab2.datastore as Datastore;

listener http:Listener ep0 = new (8080, config = {host: "localhost"});

service /vle/api/v1 on ep0 {
    resource function get users() returns Types:User[]|http:Response {
        return Datastore:user.toArray();
    }

    resource function post users(@http:Payload Types:User payload) returns Types:CreatedInlineResponse201|Types:Error {
        string[] conflictingUsernames = from var {username} in Datastore:user
            where username == payload.username
            select username;

        if conflictingUsernames.length() > 0 {

            return <Types:Error>{
                errorType: "User already exists",
                message: string `User with username ${payload.username} already exists`
            };

        } else {
            Datastore:user.put(payload);
            return <Types:CreatedInlineResponse201>{
                body: {userid: payload.username}
            };
        }
    }
    resource function get users/[string username]() returns Types:User|Types:Error {
        Types:User? theUser = Datastore:user.get(username);
        if theUser == () {
            return <Types:Error>{
                errorType: "User not found",
                message: string `User with username ${username} not found`
            };
        } else {
            return theUser;
        }
    }
    resource function put users/[string username](@http:Payload Types:User payload) returns Types:User|Types:Error {
        Types:User? theUser = Datastore:user.get(username);
        if theUser == () {
            return <Types:Error>{
                errorType: "User not found",
                message: string `User with username ${username} not found`
            };
        } else {
            string? firstname = payload.firstname;
            if firstname != () {
                theUser.firstname = firstname;
            }
            string? lastname = payload.lastname;
            if lastname != () {
                theUser.lastname = lastname;
            }
            string? email = payload.email;
            if email != () {
                theUser.email = email;
            }
            return theUser;
        }
    }

    resource function delete users/[string username]() returns http:NoContent|Types:Error {
        Types:User? theUser = Datastore:user.get(username);
        if theUser == () {
            return <Types:Error>{
                errorType: "User not found",
                message: string `User with username ${username} not found`
            };
        } else {
            http:NoContent noContent = { };
            return noContent;
        }
    }
}