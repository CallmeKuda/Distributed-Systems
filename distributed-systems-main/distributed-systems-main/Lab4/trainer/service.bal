import ballerinax/kafka;
import trainer.datastore as Datastore;
import trainer.types as Types;

kafka:ProducerConfiguration producerConfig = {
    clientId: "trainer-id",
    acks: "all",
    retryCount: 3
};
kafka:Producer kafkaProducer = check new (kafka:DEFAULT_URL, producerConfig);

kafka:ConsumerConfiguration consumerConfig = {
    groupId: "trainer-id",
    topics: ["training-req"],
    pollingInterval: 1,
    offsetReset: "earliest"
};
kafka:Consumer kafkaConsumer = check new (kafka:DEFAULT_URL, consumerConfig);

listener kafka:Listener Listener = new (kafka:DEFAULT_URL, consumerConfig);

service /kafkaService on Listener{
    private Datastore:store store;
    private Types:DatabaseConfig databaseConfig = {
        host: "localhost",
        port: 27017,
        databaseName: "test",
        collection: "training"
    };
    function init() returns error?{
        self.store = check new(self.databaseConfig);
    }

    function processRecord(kafka:ConsumerRecord consumerRecord, Datastore:store store) returns error|error {
        byte[] message = consumerRecord.value;
        string messageString = check string:fromBytes(message);
        string specialisation_req = messageString.substring(0, <int>messageString.indexOf(","));
        Types:Material[]|error results = check store.getMaterials(specialisation_req);

        foreach Types:Material item in results {
            _ = check kafkaProducer->send({value:  item.toString().toBytes(), topic: "training-res"});
        }
    }

    remote function onConsumerRecord(kafka:Caller caller, kafka:ConsumerRecord[] consumerRecord) returns error? {
        foreach kafka:ConsumerRecord item in consumerRecord {
            error processRecordResult = self.processRecord(item, self.store);
        }
    }
}