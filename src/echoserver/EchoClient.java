
package echoserver;

import java.io.*;
import java.net.*;

public class EchoClient {
    public static void main(String[] args) {
        String hostname = "localhost";  // Use the server's hostname or IP
        int port = 12345;  // Match the server port

        try (Socket socket = new Socket(hostname, port);
             InputStream keyboardIn = System.in;
             OutputStream socketOut = socket.getOutputStream();
             InputStream socketIn = socket.getInputStream()) {

            int data;
            while ((data = keyboardIn.read()) != -1) {
                socketOut.write(data);
                socketOut.flush();

                int response = socketIn.read();
                System.out.write(response);
                System.out.flush();
            }
            socket.shutdownOutput();  // Indicate end of output
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
