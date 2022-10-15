import ballerina/graphql;

//define types for assessements and marks
//define map for assessment and marks

public service class Student {
    private string studentNumber;
    private string name;
    private Course[] courses;

    function init(string studentNumber, string name) {
        self.studentNumber = studentNumber;
        self.name = name;
        self.courses = [];
    }

    resource function get studentNumber() returns string {
        return self.studentNumber;
    }

    resource function get name() returns string {
        return self.name;
    }

    resource function get courses() returns Course[] {
        return self.courses;
    }

    public function addCourses(Course courses) {
        self.courses.push(courses);
    }

}

public service class Course {
    private string courseCode;
    private float[] assessmentWeight;
    private float[] marks;

    function init(string courseCode){
        self.courseCode = courseCode;
        self.assessmentWeight = [];
        self.marks = [];
    }

    resource function get name() returns string {
        return self.courseCode;
    }

    resource function get assessmentWeight() returns float[] {
        return self.assessmentWeight;
    }

    resource function get marks() returns float[] {
        return self.marks;
    }

    public function addAssessment(float assessmentWeight, float mark) {
        self.assessmentWeight.push(assessmentWeight);
        self.marks.push(mark);
    }

}

service /graphql on new graphql:Listener(1200) {

    private Student studentEg;
    function init() {
        self.studentEg = new ("S001", "John");
    }

    //curl -X POST -H "Content-Type: application/json" -d'{"query":"{student {studentNumber name}}"}' http://localhost:1200/graphql
    resource function get student () returns Student {
        return self.studentEg;
    }

    //curl -X POST -H "Content-Type: application/json" -d'{"query":"mutation{insertCourse(courseCode=\"DSA621S\",weight=0.3,mark=70.3){studentNumber name courses {code mark}}}"}' http://localhost:1200/graphql
    remote function insertCourse(string courseCode, float weight, float mark) returns Student {
        Course newCourse = new (courseCode);
        newCourse.addAssessment(weight, mark);
        self.studentEg.addCourses(newCourse);
        return self.studentEg;
    }

    //Homework: Create a client to call the graphql service and print the result
    //Homework: Create gRPC service and client for the next class
}
