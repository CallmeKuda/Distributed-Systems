import trainer.types as Types;
import ballerinax/kafka;
import ballerinax/mongodb;

public class store {
    private mongodb:Client mongoClient;
    private string collection;
    function init(Types:DatabaseConfig databaseConfig) returns error? {
        mongodb:ConnectionConfig mongoConfig = {
            port: databaseConfig.port,
            host: databaseConfig.host
        };
        self.mongoClient = check new (mongoConfig, databaseConfig.databaseName);
        self.collection = databaseConfig.collection;
    }

    public function getMaterials(string? specialisation, string? level, string?  duration) returns Types:Material[]|error {
        map<json> query = {};

        if (specialisation != ()) {
            query["specialisation"] = specialisation;
        }
        if (level != ()) {
            query["level"] = level;
        }
        if (duration != ()) {
            query["duration"] = duration;
        }

        map<json>[] results = checkpanic self.mongoClient->find(self.collection, (), (), (), (), 0, query);
        Types:Material[] allMaterial = [];
        foreach var item in results {
            Types:Material|error theMaterial = item.fromJsonWithType(Types:Material);
            if (theMaterial is Types:Material) {
                allMaterial.push(theMaterial);
            }
        }

        return allMaterial;
    }

}

