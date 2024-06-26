package main

import (
	"context"
	"encoding/json"
	"fmt"
	"os"

	"github.com/sirupsen/logrus"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

// EventParser has methods to handle different types of AWS EventBridge events.
type EventParser struct {
	log *logrus.Logger
}

// NewEventParser creates a new instance of EventParser.
func NewEventParser(logger *logrus.Logger) *EventParser {
	return &EventParser{
		log: logger,
	}
}

func (e *EventParser) EventHandler(ctx context.Context, event events.CloudWatchEvent) error {
	switch event.DetailType {
	// Make sure it's from Cloudtrail
	case "AWS API Call via CloudTrail":
		e.log.Info("Handling Cloudtrail event")
		return e.HandleEvent(ctx, event)
	default:
		return fmt.Errorf("unhandled detail type: %s", event.DetailType)
	}
}

// HandleEvent deals with different events based on source
func (e *EventParser) HandleEvent(ctx context.Context, event events.CloudWatchEvent) error {
	switch event.Source {

	// Handle S3 events
	case "aws.s3":
		var s3Event events.S3Event
        e.log.Info("Handling S3 event")
		if err := json.Unmarshal(event.Detail, &s3Event); err != nil {
			return fmt.Errorf("could not unmarshal event into S3Event: %w", err)
		}
		return e.handleS3Event(s3Event)

	// Handle EC2 events
	case "aws.ec2":
        e.log.Warn("No event handler defined for EC2")
		return fmt.Errorf("No event handler for EC2")
	default:
		return fmt.Errorf("Unknown event source: %s", event.Source)
	}
}

// handleS3Event deals with S3 related events (from Cloudtrail)
func (e *EventParser) handleS3Event(event events.S3Event) error {
	e.log.Infof("Event: %#v", event)
	for _, record := range event.Records {
		e.log.Infof("Record: %v", record)
	}
	return nil
}

func main() {
	// create a new instance of the logger. You can have any number of instances.
	var log = logrus.New()

	// Log as JSON instead of the default ASCII formatter.
	log.SetFormatter(&logrus.JSONFormatter{})

	// Output to stdout instead of the default stderr
	// Can be any io.Writer, see below for File example
	log.SetOutput(os.Stdout)

	// Only log the warning severity or above.
	log.SetLevel(logrus.InfoLevel)

	// Create new parser
	parser := NewEventParser(log)

	if len(os.Args) > 1 {
		// Read JSON event from a file specified in the command line arguments
		filePath := os.Args[1]
		fileContent, err := os.ReadFile(filePath)
		if err != nil {
			fmt.Printf("Error reading event file: %v\n", err)
			os.Exit(1)
		}

		var event events.CloudWatchEvent
		if err := json.Unmarshal(fileContent, &event); err != nil {
			fmt.Printf("Error decoding event from file: %v\n", err)
			os.Exit(1)
		}

		// Process the event
		if err := parser.EventHandler(context.Background(), event); err != nil {
			fmt.Printf("Error handling event: %v\n", err)
			os.Exit(1)
		}
	} else {
		// Lambda mode, waiting for CloudWatch events
        log.Info("Starting Lambda function")
		lambda.Start(func(ctx context.Context, event events.CloudWatchEvent) error {
			return parser.EventHandler(ctx, event)
		})
	}
}
