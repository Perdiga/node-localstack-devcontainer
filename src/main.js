// Import the DynamoDBClient and ListTablesCommand from the AWS SDK v3
import { DynamoDBClient, ListTablesCommand } from '@aws-sdk/client-dynamodb';

// Create a DynamoDB client configured to connect to LocalStack
const client = new DynamoDBClient({
  region: 'us-east-1',
  endpoint: 'http://localhost:4566',
});

// Function to list all DynamoDB tables
const listTables = async () => {
  try {
    const command = new ListTablesCommand({});
    const data = await client.send(command);
    console.log('DynamoDB Tables:', data.TableNames);
  } catch (err) {
    console.error('Error listing tables:', err);
  }
};

// Call the function to list tables
listTables();