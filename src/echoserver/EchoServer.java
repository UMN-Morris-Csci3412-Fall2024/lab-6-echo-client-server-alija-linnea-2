package echoserver;

import java.net.*;
import java.io.*;

public class EchoServer {
    public static final int portNumber = 6013;

    public static void main(String[] args) {
        try {
            // Start listening on the specified port
            ServerSocket serverSock = new ServerSocket(portNumber);

            // Run forever, which is common for server style services
            while (true) {
                // Wait until someone connects
                Socket client = serverSock.accept();

                try{ 
                  DataInputStream in = new DataInputStream(client.getInputStream());
                    DataOutputStream out = new DataOutputStream(client.getOutputStream()); 

                    // Read and write bytes until the end of the stream
                    while (true) {
                        try {
                            byte inputByte = in.readByte(); // Read a byte
                            out.writeByte(inputByte); // Echo the byte back
                            System.out.println(inputByte);
                        } catch (EOFException e) {
                            // End of stream reached, break the loop
                            break;
                        }
                }
                } finally {
                    client.close(); 
                    serverSock.close(); //why did that fix the error on the large chunk of text?
                }
            }
        } catch (IOException e) {
            System.out.println("Exception caught when trying to listen on port "
                + portNumber + " or listening for a connection");
            System.out.println(e.getMessage());
        }
    }
  }

