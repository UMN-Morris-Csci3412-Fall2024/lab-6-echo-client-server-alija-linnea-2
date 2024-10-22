package echoserver;
import java.io.*;
import java.net.*;

public class EchoServer {
    public static void main(String[] args) {
        // Set default port to 12345 or use the specified port from command line
        int port = args.length > 0 ? Integer.parseInt(args[0]) : 12345;

        try (ServerSocket serverSocket = new ServerSocket(port)) {
            System.out.println("Server is listening on port " + port);

            while (true) {
                Socket socket = serverSocket.accept();
                System.out.println("New client connected");

                // Handle client communication
                new EchoHandler(socket).start();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

class EchoHandler extends Thread {
    private final Socket socket;

    public EchoHandler(Socket socket) {
        this.socket = socket;
    }

    public void run() {
        try (InputStream in = socket.getInputStream();
             OutputStream out = socket.getOutputStream()) {

            int data;
            while ((data = in.read()) != -1) {
                out.write(data);
                out.flush();  // Ensure data is sent immediately
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                socket.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
