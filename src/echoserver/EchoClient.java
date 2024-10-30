package echoserver;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.EOFException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.Socket;
import java.io.*;


public class EchoClient{
  public static final int portNumber = 6013;

  public static void main(String[] args) {
    String server;
    // Use "127.0.0.1", i.e., localhost, if no server is specified.
    if (args.length == 0) {
        server = "127.0.0.1";
    } else {
        server = args[0];
    }

    try{
      Socket socket = new Socket(server, portNumber);
      InputStream userInput = System.in;
      OutputStream out = socket.getOutputStream();
      InputStream in = socket.getInputStream();

      int data;
      while((data = userInput.read()) != -1){
        out.write(data);
        out.flush();

        int response = in.read();
        System.out.write(response);
        System.out.flush();
      }
      socket.close();
    }
      catch (IOException ioe) {
      System.out.println("We caught an unexpected exception");
      System.err.println(ioe);
  }

  }
}





