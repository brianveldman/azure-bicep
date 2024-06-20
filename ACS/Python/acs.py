from azure.communication.email import EmailClient
def main():
    try:
        connection_string = ""
        client = EmailClient.from_connection_string(connection_string)

        message = {
            "senderAddress": "",
            "recipients":  {
                "to": [{"address": "" }],
            },
            "content": {
                "subject": "Test Email - ACS",
                "plainText": "Hello world via email, sent via ACS.",
            }
        }

        poller = client.begin_send(message)
        result = poller.result()

    except Exception as ex:
        print(ex)
main()
