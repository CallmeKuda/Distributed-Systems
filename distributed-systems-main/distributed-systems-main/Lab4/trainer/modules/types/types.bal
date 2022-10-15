public type Material record{|
    string specialisation;
    Level level;
    Duration duration;
    string[] content;
    Format format;
|};

public enum Level {
    Beginner,
    Middle,
    Advanced
}

public enum Duration {
    Half_day, 
    Full_day, 
    Day_and_Half
}

public enum Format{
    Slides,
    Workshop
}

public type DatabaseConfig record {|
    string host;
    int port;
    string databaseName;
    string collection;
|};