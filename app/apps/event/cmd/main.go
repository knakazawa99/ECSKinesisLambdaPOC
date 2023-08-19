package main

import (
	"context"
	"encoding/json"
	"fmt"
	"time"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

type Log struct {
	Pat     time.Time `json:"pat"`
	ID      string    `json:"id"`
	LogType string    `json:"log_type"`
}

func handler(ctx context.Context, kinesisEvent events.KinesisEvent) {
	for _, record := range kinesisEvent.Records {
		kinesisRecord := record.Kinesis
		dataBytes := kinesisRecord.Data
		dataText := string(dataBytes)
		fmt.Printf("%s Data = %s \n", record.EventName, dataText)

		log := Log{}
		if err := json.Unmarshal(dataBytes, &log); err != nil {

		}

		fmt.Println(fmt.Sprintf("pat := %v, id := %v", log.Pat, log.LogType))
	}
}

func main() {
	lambda.Start(handler)
}
