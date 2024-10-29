package echoserver;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.EOFException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.Socket;

public class EchoClient {
    public static final int portNumber = 6013;

    public static void main(String[] args) {
        String server;
        // Use "127.0.0.1", i.e., localhost, if no server is specified.
        if (args.length == 0) {
            server = "127.0.0.1";
        } else {
            server = args[0];
        }
        

        try {Socket socket = new Socket(server, portNumber);
             DataInputStream in = new DataInputStream(socket.getInputStream());
             DataOutputStream out = new DataOutputStream(socket.getOutputStream());
             InputStreamReader reader = new InputStreamReader(System.in); 

            byte userInput;
            byte inputByte;

              try{
                while((userInput = (byte) reader.read()) != -1){
                  out.writeByte(userInput);
                  out.flush(); // Ensure all bytes are sent
                  try {
                      inputByte = in.readByte(); // Read a byte
                      System.out.print((char)inputByte); // Print the byte received from the server
  
                  } catch (EOFException e) {
                    break;
                  }
                }         
            }
              finally {
                socket.close();
              }
        } catch (IOException ioe) {
            System.out.println("We caught an unexpected exception");
            System.err.println(ioe);
        }
    }
}




